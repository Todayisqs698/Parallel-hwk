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
#include "simd_utils.h"

const int K_CENTROIDS = 256;
const int SUB_DIM = 6;
const int ALIGN_DIM = 8;
const int M_SUBSPACES = 16;
const int MAX_ITER = 10;

class PQIndex {
public:
    std::vector<float> codebooks; // [M][K][8]
    std::vector<uint8_t> codes;    // [N][M]
    const float* raw_base;
    size_t n, dim;

    // 训练与编码阶段
    void train(const float* base, size_t num, size_t d) {
        n = num; dim = d; raw_base = base;
        codebooks.assign(M_SUBSPACES * K_CENTROIDS * ALIGN_DIM, 0.0f);
        codes.resize(n * M_SUBSPACES);
        std::cout << "--- [PQ] Starting Training ---" << std::endl;
        
        for (int m = 0; m < M_SUBSPACES; ++m) {
            size_t train_n = std::min((size_t)10000, n);
            train_subspace_internal(base, train_n, dim, m, &codebooks[m * K_CENTROIDS * ALIGN_DIM]);
        }

        std::cout << "--- [PQ] Starting Encoding (L2) ---" << std::endl;
        #pragma omp parallel for
        for (size_t i = 0; i < n; ++i) {
            for (int m = 0; m < M_SUBSPACES; ++m) {
                const float* vec_sub = base + i * dim + m * SUB_DIM;
                float min_l2 = std::numeric_limits<float>::max();
                uint8_t best_k = 0;

                for (int k = 0; k < K_CENTROIDS; ++k) {
                    const float* center = &codebooks[(m * K_CENTROIDS + k) * ALIGN_DIM];
                    float l2_dist = 0;
                    for (int sd = 0; sd < SUB_DIM; ++sd) {
                         float diff = vec_sub[sd] - center[sd];
                         l2_dist += diff * diff;
                    }
                    if (l2_dist < min_l2) { 
                        min_l2 = l2_dist; 
                        best_k = (uint8_t)k; 
                    }
                }
                codes[i * M_SUBSPACES + m] = best_k;
            }
        }
    }
    
    // 搜索阶段 ADC
    std::priority_queue<std::pair<float, uint32_t>> search(const float* query, size_t k, size_t p) {
        if (p < k) p = k;

        // 1. 构建查询查找表 (LUT)
        alignas(64) float lut[M_SUBSPACES * K_CENTROIDS];

        for (int m = 0; m < M_SUBSPACES; ++m) {
            const float* q_sub = query + m * SUB_DIM;
            alignas(16) float q_align[8] = {0};
            std::memcpy(q_align, q_sub, SUB_DIM * sizeof(float));
            float32x4_t q_v0 = vld1q_f32(q_align);
            float32x4_t q_v1 = vld1q_f32(q_align + 4);

            for (int k_idx = 0; k_idx < K_CENTROIDS; ++k_idx) {
                const float* center = &codebooks[(m * K_CENTROIDS + k_idx) * ALIGN_DIM];
                float32x4_t c_v0 = vld1q_f32(center);
                float32x4_t c_v1 = vld1q_f32(center + 4);
                
                float32x4_t diff0 = vsubq_f32(q_v0, c_v0);
                float32x4_t diff1 = vsubq_f32(q_v1, c_v1);
                float32x4_t sumv = vmulq_f32(diff0, diff0);
                sumv = vfmaq_f32(sumv, diff1, diff1);

                lut[m * K_CENTROIDS + k_idx] = vaddvq_f32(sumv);
            }
        }
        
        int num_threads = omp_get_max_threads();
        std::vector<std::priority_queue<std::pair<float, uint32_t>>> thread_heaps(num_threads);

        #pragma omp parallel
        {
            int tid = omp_get_thread_num();
            auto& my_heap = thread_heaps[tid];

            #pragma omp for schedule(static)
            for (size_t i = 0; i < n; ++i) {
                if (i + 16 < n) {
                    __builtin_prefetch(&codes[(i + 16) * M_SUBSPACES], 0, 3);
                }
                const uint8_t* vec_codes = &codes[i * M_SUBSPACES];
                float s0 = lut[0 * K_CENTROIDS + vec_codes[0]];
                float s1 = lut[1 * K_CENTROIDS + vec_codes[1]];
                float s2 = lut[2 * K_CENTROIDS + vec_codes[2]];
                float s3 = lut[3 * K_CENTROIDS + vec_codes[3]];
                
                for (int m = 4; m < M_SUBSPACES; m += 4) {
                    s0 += lut[(m + 0) * K_CENTROIDS + vec_codes[m + 0]];
                    s1 += lut[(m + 1) * K_CENTROIDS + vec_codes[m + 1]];
                    s2 += lut[(m + 2) * K_CENTROIDS + vec_codes[m + 2]];
                    s3 += lut[(m + 3) * K_CENTROIDS + vec_codes[m + 3]];
                }
                float dist = s0 + s1 + s2 + s3;

                if (my_heap.size() < p) {
                    my_heap.emplace(dist, (uint32_t)i);
                } else if (dist < my_heap.top().first) {
                    my_heap.pop();
                    my_heap.emplace(dist, (uint32_t)i);
                }
            }
        }

        // 3. 合并与精排 (Rerank)
        std::priority_queue<std::pair<float, uint32_t>> coarse_heap;
        for (auto& h : thread_heaps) {
            while (!h.empty()) {
                if (coarse_heap.size() < p) coarse_heap.push(h.top());
                else if (h.top().first < coarse_heap.top().first) {
                    coarse_heap.pop(); coarse_heap.push(h.top());
                }
                h.pop();
            }
        }

        std::priority_queue<std::pair<float, uint32_t>> final_k;
        while (!coarse_heap.empty()) {
            uint32_t id = coarse_heap.top().second;
            coarse_heap.pop();
            
            float exact_dist = InnerProductSIMD(raw_base + (size_t)id * dim, query, dim);
            if (final_k.size() < k) final_k.emplace(exact_dist, id);
            else if (exact_dist < final_k.top().first) {
                final_k.pop(); final_k.emplace(exact_dist, id);
            }
        }
        return final_k;
    }

private:
    void train_subspace_internal(const float* data, size_t n_train, size_t total_dim, int m, float* out_cb) {
        std::vector<size_t> indices(n_train);
        for (size_t i = 0; i < n_train; ++i) indices[i] = i;
        std::mt19937 rng(42);
        std::shuffle(indices.begin(), indices.end(), rng);

        for (int k = 0; k < K_CENTROIDS; ++k) {
            std::memcpy(out_cb + k * ALIGN_DIM, data + indices[k] * total_dim + m * SUB_DIM, SUB_DIM * sizeof(float));
        }

        std::vector<int> assignments(n_train);
        for (int iter = 0; iter < MAX_ITER; ++iter) {
            #pragma omp parallel for
            for (size_t i = 0; i < n_train; ++i) {
                const float* vec = data + i * total_dim + m * SUB_DIM;
                float min_d = std::numeric_limits<float>::max();
                int best_k = 0;
                for (int k = 0; k < K_CENTROIDS; ++k) {
                    float d = 0;
                    const float* c = out_cb + k * ALIGN_DIM;
                    for (int sd = 0; sd < SUB_DIM; ++sd) { 
                        float diff = vec[sd] - c[sd]; 
                        d += diff * diff; 
                    }
                    if (d < min_d) { min_d = d; best_k = k; }
                }
                assignments[i] = best_k;
            }
            
            std::vector<float> new_c(K_CENTROIDS * SUB_DIM, 0.0f);
            std::vector<int> counts(K_CENTROIDS, 0);
            for (size_t i = 0; i < n_train; ++i) {
                int k = assignments[i];
                for (int sd = 0; sd < SUB_DIM; ++sd) 
                    new_c[k * SUB_DIM + sd] += data[i * total_dim + m * SUB_DIM + sd];
                counts[k]++;
            }

            for (int k = 0; k < K_CENTROIDS; ++k) {
                if (counts[k] > 0) {
                    for (int sd = 0; sd < SUB_DIM; ++sd) 
                        out_cb[k * ALIGN_DIM + sd] = new_c[k * SUB_DIM + sd] / counts[k];
                } else {
                    size_t r = indices[std::uniform_int_distribution<size_t>(0, n_train - 1)(rng)];
                    std::memcpy(out_cb + k * ALIGN_DIM, data + r * total_dim + m * SUB_DIM, SUB_DIM * sizeof(float));
                }
            }
        }
    }
};
