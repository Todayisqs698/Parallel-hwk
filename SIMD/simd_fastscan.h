#pragma once
#include <vector>
#include <queue>
#include <arm_neon.h>
#include <cmath>
#include <algorithm>
#include <omp.h>
#include <cstring>
#include <random>
#include <iostream>
#include <limits>
#include <stdlib.h>

// 严格统一宏定义
const int FS_K = 16;            // 4-bit PQ
const int FS_M = 16;            // 16个子空间
const int FS_SUB_DIM = 6;       // 子空间维度 (96/16)
const int FS_ALIGN_DIM = 8;     // 码本对齐维度 (为了对齐访问)
const int FS_MAX_ITER = 10;     // KMeans 迭代次数
const int FS_BLOCK = 16;        // NEON 寄存器宽度

class FastScanPQIndex {
public:
    std::vector<float> codebooks;    // [M][K][ALIGN_DIM]
    uint8_t* codes_fs;               // SoA 布局编码
    const float* raw_base;           // 用于精排的原始数据指针
    size_t n, dim, n_padded;

    FastScanPQIndex() : codes_fs(nullptr), raw_base(nullptr), n(0), dim(0), n_padded(0) {}

    ~FastScanPQIndex() {
        if (codes_fs) free(codes_fs);
    }

    // --- 训练与 SoA 编码逻辑 ---
    void train(const float* base, size_t num, size_t d) {
        n = num; dim = d; raw_base = base;
        n_padded = (n + FS_BLOCK - 1) / FS_BLOCK * FS_BLOCK;
        
        codebooks.assign(FS_M * FS_K * FS_ALIGN_DIM, 0.0f);
        
        if (codes_fs) free(codes_fs);
        if (posix_memalign((void**)&codes_fs, 64, FS_M * n_padded) != 0) {
            throw std::runtime_error("Memory allocation failed");
        }
        std::memset(codes_fs, 0, FS_M * n_padded);

        std::cout << "--- [FastScan] Training K=16 ---" << std::endl;
        for (int m = 0; m < FS_M; ++m) {
            train_subspace_internal(base, std::min((size_t)10000, n), dim, m, &codebooks[m * FS_K * FS_ALIGN_DIM]);
        }

        std::cout << "--- [FastScan] Encoding SoA Layout ---" << std::endl;
        #pragma omp parallel for
        for (size_t blk = 0; blk < n_padded / FS_BLOCK; ++blk) {
            for (int m = 0; m < FS_M; ++m) {
                for (int pos = 0; pos < FS_BLOCK; ++pos) {
                    size_t vec_idx = blk * FS_BLOCK + pos;
                    uint8_t best_k = 0;
                    if (vec_idx < n) {
                        best_k = compute_best_k(base + vec_idx * dim + m * FS_SUB_DIM, m);
                    }
                    codes_fs[blk * (FS_M * FS_BLOCK) + m * FS_BLOCK + pos] = best_k;
                }
            }
        }
    }

    // --- 核心搜索函数：极致优化版 ---
    std::priority_queue<std::pair<float, uint32_t>> search(const float* query, size_t k, size_t L) {
        if (L < k) L = k;

        // 1. 构建量化 LUT (全局 Scaling 保证线性一致性)
        float raw_luts[FS_M][16];
        float global_max_dist = 1e-6f;
        for (int m = 0; m < FS_M; ++m) {
            for (int ki = 0; ki < 16; ++ki) {
                float d2 = compute_l2_sub(query + m * FS_SUB_DIM, m, ki);
                raw_luts[m][ki] = d2;
                if (d2 > global_max_dist) global_max_dist = d2;
            }
        }
        float inv_alpha = 255.0f / global_max_dist;
        alignas(64) uint8_t q_lut[FS_M][16];
        for (int m = 0; m < FS_M; ++m) {
            for (int ki = 0; ki < 16; ++ki) {
                q_lut[m][ki] = (uint8_t)(raw_luts[m][ki] * inv_alpha);
            }
        }

        // 2. SIMD 扫描核 (双路展开 + 最小值预过滤)
        int num_threads = omp_get_max_threads();
        std::vector<std::priority_queue<std::pair<uint16_t, uint32_t>>> thread_heaps(num_threads);

        #pragma omp parallel
        {
            int tid = omp_get_thread_num();
            auto& my_heap = thread_heaps[tid];
            uint16_t threshold = 0xFFFF; // 动态更新的过滤门限

            #pragma omp for schedule(static)
            for (size_t blk = 0; blk < n_padded / FS_BLOCK; blk += 2) {
                uint16x8_t acc0_lo = vdupq_n_u16(0), acc0_hi = vdupq_n_u16(0);
                uint16x8_t acc1_lo = vdupq_n_u16(0), acc1_hi = vdupq_n_u16(0);

                const uint8_t* ptr0 = codes_fs + blk * (FS_M * FS_BLOCK);
                const uint8_t* ptr1 = codes_fs + (blk + 1) * (FS_M * FS_BLOCK);

                for (int m = 0; m < FS_M; ++m) {
                    uint8x16_t l = vld1q_u8(q_lut[m]);
                    uint8x16_t d0 = vqtbl1q_u8(l, vld1q_u8(ptr0 + m * FS_BLOCK));
                    uint8x16_t d1 = vqtbl1q_u8(l, vld1q_u8(ptr1 + m * FS_BLOCK));

                    acc0_lo = vaddw_u8(acc0_lo, vget_low_u8(d0));
                    acc0_hi = vaddw_u8(acc0_hi, vget_high_u8(d0));
                    acc1_lo = vaddw_u8(acc1_lo, vget_low_u8(d1));
                    acc1_hi = vaddw_u8(acc1_hi, vget_high_u8(d1));
                }

                // 处理两路结果的 lambda 过滤逻辑
                auto process_lane = [&](uint16x8_t al, uint16x8_t ah, size_t cur_blk) {
                    uint16x8_t m16 = vminq_u16(al, ah);
                    uint16x4_t m8 = vmin_u16(vget_low_u16(m16), vget_high_u16(m16));
                    uint16x4_t m4 = vpmin_u16(m8, m8);
                    uint16_t min_val = vget_lane_u16(m4, 0);
                    if (vget_lane_u16(m4, 1) < min_val) min_val = vget_lane_u16(m4, 1);

                    if (min_val < threshold) {
                        alignas(16) uint16_t s[16];
                        vst1q_u16(s, al); vst1q_u16(s + 8, ah);
                        for (int j = 0; j < 16; ++j) {
                            uint32_t vid = cur_blk * FS_BLOCK + j;
                            if (vid < n && s[j] < threshold) {
                                my_heap.emplace(s[j], vid);
                                if (my_heap.size() > L) {
                                    my_heap.pop();
                                    threshold = my_heap.top().first;
                                }
                            }
                        }
                    }
                };

                process_lane(acc0_lo, acc0_hi, blk);
                if (blk + 1 < n_padded / FS_BLOCK) process_lane(acc1_lo, acc1_hi, blk + 1);
            }
        }
        return perform_rerank(thread_heaps, query, k, L);
    }

private:
    float compute_l2_sub(const float* q, int m, int k) {
        const float* c = &codebooks[(m * FS_K + k) * FS_ALIGN_DIM];
        float d2 = 0;
        for (int i = 0; i < FS_SUB_DIM; ++i) {
            float diff = q[i] - c[i]; d2 += diff * diff;
        }
        return d2;
    }

    uint8_t compute_best_k(const float* vec_sub, int m) {
        float min_d = 1e30f; uint8_t bk = 0;
        for (int k = 0; k < 16; ++k) {
            float d = compute_l2_sub(vec_sub, m, k);
            if (d < min_d) { min_d = d; bk = k; }
        }
        return bk;
    }

    // --- 向量化精排核心逻辑 (Rerank) ---
    std::priority_queue<std::pair<float, uint32_t>> perform_rerank(
        std::vector<std::priority_queue<std::pair<uint16_t, uint32_t>>>& heaps, 
        const float* query, size_t k, size_t L) 
    {
        std::priority_queue<std::pair<uint16_t, uint32_t>> candidates;
        for (auto& h : heaps) {
            while (!h.empty()) {
                candidates.push(h.top()); if (candidates.size() > L) candidates.pop();
                h.pop();
            }
        }

        std::priority_queue<std::pair<float, uint32_t>> final_h;
        while (!candidates.empty()) {
            uint32_t id = candidates.top().second; candidates.pop();
            const float* base_ptr = raw_base + id * dim;
            
            // NEON 向量化 L2 距离计算
            float32x4_t v_acc = vdupq_n_f32(0);
            size_t d = 0;
            for (; d + 3 < dim; d += 4) {
                float32x4_t diff = vsubq_f32(vld1q_f32(query + d), vld1q_f32(base_ptr + d));
                v_acc = vfmaq_f32(v_acc, diff, diff);
            }
            float tmp[4]; vst1q_f32(tmp, v_acc);
            float dist = tmp[0] + tmp[1] + tmp[2] + tmp[3];
            for (; d < dim; ++d) {
                float diff = query[d] - base_ptr[d]; dist += diff * diff;
            }

            if (final_h.size() < k) final_h.emplace(dist, id);
            else if (dist < final_h.top().first) { final_h.pop(); final_h.emplace(dist, id); }
        }
        return final_h;
    }

    // KMeans 训练逻辑保持稳定版本
    void train_subspace_internal(const float* data, size_t n_train, size_t total_dim, int m, float* out_cb) {
        std::vector<size_t> ids(n_train);
        for(size_t i=0; i<n_train; ++i) ids[i] = i;
        std::shuffle(ids.begin(), ids.end(), std::mt19937(42));
        for (int k = 0; k < FS_K; ++k) 
            std::memcpy(out_cb + k * FS_ALIGN_DIM, data + ids[k] * total_dim + m * FS_SUB_DIM, FS_SUB_DIM * sizeof(float));

        std::vector<int> assign(n_train);
        for (int iter = 0; iter < FS_MAX_ITER; ++iter) {
            #pragma omp parallel for
            for (size_t i = 0; i < n_train; ++i) {
                const float* v = data + i * total_dim + m * FS_SUB_DIM;
                float min_d = 1e30f; int bk = 0;
                for (int k = 0; k < FS_K; ++k) {
                    float d = 0; const float* c = out_cb + k * FS_ALIGN_DIM;
                    for (int sd = 0; sd < FS_SUB_DIM; ++sd) { float df = v[sd] - c[sd]; d += df * df; }
                    if (d < min_d) { min_d = d; bk = k; }
                }
                assign[i] = bk;
            }
            std::vector<float> new_c(FS_K * FS_SUB_DIM, 0.0f);
            std::vector<int> counts(FS_K, 0);
            for (size_t i = 0; i < n_train; ++i) {
                int k = assign[i];
                for (int sd = 0; sd < FS_SUB_DIM; ++sd) 
                    new_c[k * FS_SUB_DIM + sd] += data[i * total_dim + m * FS_SUB_DIM + sd];
                counts[k]++;
            }
            for (int k = 0; k < FS_K; ++k) {
                if (counts[k] > 0) {
                    for (int sd = 0; sd < FS_SUB_DIM; ++sd) out_cb[k * FS_ALIGN_DIM + sd] = new_c[k * FS_SUB_DIM + sd] / counts[k];
                }
            }
        }
    }
};
