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
#include <stdexcept>
#include <cstdint>

// 与对齐版本保持一致
const int UFS_K = 16;
const int UFS_M = 16;
const int UFS_SUB_DIM = 6;     
const int UFS_ALIGN_DIM = 8;   // 码本仍按8对齐存放，便于一致性
const int UFS_MAX_ITER = 10;
const int UFS_BLOCK = 16;      // NEON 16 lanes

class UnalignedFastScanPQIndex {
public:
    std::vector<float> codebooks;    // [M][K][8]
    uint8_t* codes_fs;               // 非对齐分配
    const float* raw_base;
    size_t n, dim, n_padded;

    UnalignedFastScanPQIndex() : codes_fs(nullptr), raw_base(nullptr), n(0), dim(0), n_padded(0) {}

    ~UnalignedFastScanPQIndex() {
        if (codes_fs) {
            delete[] codes_fs;
            codes_fs = nullptr;
        }
    }

    void train(const float* base, size_t num, size_t d) {
        n = num; dim = d; raw_base = base;
        n_padded = (n + UFS_BLOCK - 1) / UFS_BLOCK * UFS_BLOCK;

        codebooks.assign(UFS_M * UFS_K * UFS_ALIGN_DIM, 0.0f);

        if (codes_fs) delete[] codes_fs;
        // 非对齐分配（核心点）
        codes_fs = new uint8_t[UFS_M * n_padded];
        std::memset(codes_fs, 0, UFS_M * n_padded);

        std::cout << "--- [UnalignedFastScan] Training KMeans (K=16) ---" << std::endl;
        for (int m = 0; m < UFS_M; ++m) {
            train_subspace_internal(base, std::min((size_t)10000, n), dim, m, &codebooks[m * UFS_K * UFS_ALIGN_DIM]);
        }

        std::cout << "--- [UnalignedFastScan] Encoding & SoA Layout ---" << std::endl;
        #pragma omp parallel for
        for (size_t blk = 0; blk < n_padded / UFS_BLOCK; ++blk) {
            for (int m = 0; m < UFS_M; ++m) {
                for (int pos = 0; pos < UFS_BLOCK; ++pos) {
                    size_t vec_idx = blk * UFS_BLOCK + pos;
                    uint8_t best_k = 0;
                    if (vec_idx < n) {
                        best_k = compute_best_k(base + vec_idx * dim + m * UFS_SUB_DIM, m);
                    }
                    codes_fs[blk * (UFS_M * UFS_BLOCK) + m * UFS_BLOCK + pos] = best_k;
                }
            }
        }
    }

    std::priority_queue<std::pair<float, uint32_t>> search(const float* query, size_t k, size_t L) {
        if (L < k) L = k;

        alignas(64) uint8_t q_lut[UFS_M][16];
        for (int m = 0; m < UFS_M; ++m) {
            float dists[16];
            float max_d = 1e-6f;
            for (int ki = 0; ki < 16; ++ki) {
                dists[ki] = compute_l2_sub(query + m * UFS_SUB_DIM, m, ki);
                if (dists[ki] > max_d) max_d = dists[ki];
            }
            float alpha_inv = max_d / 255.0f;
            for (int ki = 0; ki < 16; ++ki) {
                q_lut[m][ki] = (uint8_t)(dists[ki] / alpha_inv);
            }
        }

        int num_threads = omp_get_max_threads();
        std::vector<std::priority_queue<std::pair<uint16_t, uint32_t>>> thread_heaps(num_threads);

        #pragma omp parallel
        {
            int tid = omp_get_thread_num();
            auto& my_heap = thread_heaps[tid];

            #pragma omp for schedule(static)
            for (size_t blk = 0; blk < n_padded / UFS_BLOCK; ++blk) {
                uint16x8_t acc_lo = vdupq_n_u16(0);
                uint16x8_t acc_hi = vdupq_n_u16(0);
                const uint8_t* blk_ptr = codes_fs + blk * (UFS_M * UFS_BLOCK);

                for (int m = 0; m < UFS_M; ++m) {
                    // 非对齐地址也直接加载
                    uint8x16_t c = vld1q_u8(blk_ptr + m * UFS_BLOCK);
                    uint8x16_t l = vld1q_u8(q_lut[m]);
                    uint8x16_t d = vqtbl1q_u8(l, c);

                    acc_lo = vaddw_u8(acc_lo, vget_low_u8(d));
                    acc_hi = vaddw_u8(acc_hi, vget_high_u8(d));
                }

                uint16_t scores[16];
                vst1q_u16(scores, acc_lo);
                vst1q_u16(scores + 8, acc_hi);

                for (int j = 0; j < 16; ++j) {
                    uint32_t vid = blk * 16 + j;
                    if (vid < n) {
                        if (my_heap.size() < L) my_heap.emplace(scores[j], vid);
                        else if (scores[j] < my_heap.top().first) {
                            my_heap.pop();
                            my_heap.emplace(scores[j], vid);
                        }
                    }
                }
            }
        }

        return perform_rerank(thread_heaps, query, k, L);
    }

private:
    float compute_l2_sub(const float* q, int m, int k) {
        const float* c = &codebooks[(m * UFS_K + k) * UFS_ALIGN_DIM];
        float d2 = 0;
        for (int i = 0; i < UFS_SUB_DIM; ++i) {
            float diff = q[i] - c[i];
            d2 += diff * diff;
        }
        return d2;
    }

    uint8_t compute_best_k(const float* vec_sub, int m) {
        float min_d = 1e30f; uint8_t best_k = 0;
        for (int k = 0; k < 16; ++k) {
            float d = compute_l2_sub(vec_sub, m, k);
            if (d < min_d) { min_d = d; best_k = k; }
        }
        return best_k;
    }

    void train_subspace_internal(const float* data, size_t n_train, size_t total_dim, int m, float* out_cb) {
        std::vector<size_t> ids(n_train);
        for (size_t i = 0; i < n_train; ++i) ids[i] = i;
        std::shuffle(ids.begin(), ids.end(), std::mt19937(42));

        for (int k = 0; k < UFS_K; ++k) {
            std::memcpy(out_cb + k * UFS_ALIGN_DIM, data + ids[k] * total_dim + m * UFS_SUB_DIM, UFS_SUB_DIM * sizeof(float));
        }

        std::vector<int> assign(n_train);
        for (int iter = 0; iter < UFS_MAX_ITER; ++iter) {
            #pragma omp parallel for
            for (size_t i = 0; i < n_train; ++i) {
                const float* v = data + i * total_dim + m * UFS_SUB_DIM;
                float min_d = 1e30f; int bk = 0;
                for (int k = 0; k < UFS_K; ++k) {
                    float d = 0;
                    const float* c = out_cb + k * UFS_ALIGN_DIM;
                    for (int sd = 0; sd < UFS_SUB_DIM; ++sd) {
                        float df = v[sd] - c[sd];
                        d += df * df;
                    }
                    if (d < min_d) { min_d = d; bk = k; }
                }
                assign[i] = bk;
            }

            std::vector<float> new_c(UFS_K * UFS_SUB_DIM, 0.0f);
            std::vector<int> counts(UFS_K, 0);
            for (size_t i = 0; i < n_train; ++i) {
                int k = assign[i];
                for (int sd = 0; sd < UFS_SUB_DIM; ++sd)
                    new_c[k * UFS_SUB_DIM + sd] += data[i * total_dim + m * UFS_SUB_DIM + sd];
                counts[k]++;
            }

            for (int k = 0; k < UFS_K; ++k) {
                if (counts[k] > 0) {
                    for (int sd = 0; sd < UFS_SUB_DIM; ++sd) {
                        out_cb[k * UFS_ALIGN_DIM + sd] = new_c[k * UFS_SUB_DIM + sd] / counts[k];
                    }
                }
            }
        }
    }

    std::priority_queue<std::pair<float, uint32_t>> perform_rerank(
        std::vector<std::priority_queue<std::pair<uint16_t, uint32_t>>>& heaps,
        const float* query, size_t k, size_t L)
    {
        std::priority_queue<std::pair<uint16_t, uint32_t>> candidates;
        for (auto& h : heaps) {
            while (!h.empty()) {
                candidates.push(h.top());
                if (candidates.size() > L) candidates.pop();
                h.pop();
            }
        }

        std::priority_queue<std::pair<float, uint32_t>> final_h;
        while (!candidates.empty()) {
            uint32_t id = candidates.top().second; candidates.pop();
            float d = 0;
            for (size_t i = 0; i < dim; ++i) {
                float df = raw_base[id * dim + i] - query[i];
                d += df * df;
            }
            if (final_h.size() < k) final_h.emplace(d, id);
            else if (d < final_h.top().first) {
                final_h.pop();
                final_h.emplace(d, id);
            }
        }
        return final_h;
    }
};
