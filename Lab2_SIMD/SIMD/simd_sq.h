#pragma once
#include <vector>
#include <queue>
#include <arm_neon.h>
#include <cmath>
#include <algorithm>
#include <omp.h>
#include "simd_utils.h"

struct SQInt8Index {
    std::vector<int8_t> sq_data; // 量化后的特征数据
    std::vector<float> scales;   // 每个向量独立的 scale
    const float* raw_base;       // 原始 float32 数据指针（用于精排）
    size_t n, dim;

    // 1. 训练阶段：逐向量对称量化 
    void train(const float* base, size_t num, size_t d) {
        n = num; dim = d; raw_base = base;
        sq_data.resize(n * dim);
        scales.resize(n);

        #pragma omp parallel for
        for (size_t i = 0; i < n; ++i) {
            const float* vec = base + i * dim;
            float max_val = 0.0f;
            for (size_t j = 0; j < dim; ++j) {
                float abs_v = std::abs(vec[j]);
                if (abs_v > max_val) max_val = abs_v;
            }

            // 对称量化[-127, 127]
            float s = max_val > 1e-9f ? max_val / 127.0f : 1.0f;
            scales[i] = s;

            for (size_t j = 0; j < dim; ++j) {
                sq_data[i * dim + j] = (int8_t)std::round(vec[j] / s);
            }
        }
    }

    // 2. 粗排专用内积
    // 针对 dim=96 优化，每次处理 16 个元素
    inline float coarse_dist_simd(const float* q, const int8_t* b_sq, float s) {
        float32x4_t sum_vec = vdupq_n_f32(0.0f);
        float32x4_t v_scale = vdupq_n_f32(s);

        for (size_t d = 0; d < dim; d += 16) {
            int8x16_t v8 = vld1q_s8(b_sq + d);
            
            // s8x16 -> s16x8 -> s32x4 -> f32x4
            int16x8_t v16_l = vmovl_s8(vget_low_s8(v8));
            int16x8_t v16_h = vmovl_s8(vget_high_s8(v8));

            // 处理低 8 位 (两个 f32x4)
            float32x4_t vf0 = vcvtq_f32_s32(vmovl_s16(vget_low_s16(v16_l)));
            float32x4_t vf1 = vcvtq_f32_s32(vmovl_s16(vget_high_s16(v16_l)));
            sum_vec = vfmaq_f32(sum_vec, vld1q_f32(q + d),     vmulq_f32(vf0, v_scale));
            sum_vec = vfmaq_f32(sum_vec, vld1q_f32(q + d + 4), vmulq_f32(vf1, v_scale));

            // 处理高 8 位 (两个 f32x4)
            float32x4_t vf2 = vcvtq_f32_s32(vmovl_s16(vget_low_s16(v16_h)));
            float32x4_t vf3 = vcvtq_f32_s32(vmovl_s16(vget_high_s16(v16_h)));
            sum_vec = vfmaq_f32(sum_vec, vld1q_f32(q + d + 8),  vmulq_f32(vf2, v_scale));
            sum_vec = vfmaq_f32(sum_vec, vld1q_f32(q + d + 12), vmulq_f32(vf3, v_scale));
        }
        return 1.0f - vaddvq_f32(sum_vec);
    }

    // 3. 两阶段搜索函数 
    std::priority_queue<std::pair<float, uint32_t>> search(const float* query, size_t k, size_t p) {
        if (p < k) p = k;
        int num_threads = omp_get_max_threads();	
       
	// 粗排 
        // 使用大顶堆记录距离最小的 p 个候选者
        std::vector<std::priority_queue<std::pair<float, uint32_t>>> thread_heaps(num_threads);
        #pragma omp parallel 
	{
		int tid=omp_get_thread_num();
		auto&my_heap=thread_heaps[tid];
                #pragma omp for schedule(static)

                for (size_t i = 0; i < n; ++i) {
                    float d_approx = coarse_dist_simd(query, &sq_data[i * dim], scales[i]);

                    if (my_heap.size() < p) {
                        my_heap.emplace(d_approx, (uint32_t)i);
                    } else if (d_approx < my_heap.top().first) {
                        my_heap.pop();
                        my_heap.emplace(d_approx, (uint32_t)i);
                    }
                }
        }
        std::priority_queue<std::pair<float, uint32_t>> coarse_heap;
        for (auto& h : thread_heaps) {
            while (!h.empty()) {
                auto& item = h.top();
                if (coarse_heap.size() < p) {
                    coarse_heap.push(item);
                } else if (item.first < coarse_heap.top().first) {
                    coarse_heap.pop();
                    coarse_heap.push(item);
                }
                h.pop();
            }
        }
        // 精排 (Rerank)
        std::priority_queue<std::pair<float, uint32_t>> top_k_heap;
        
        while (!coarse_heap.empty()) {
            uint32_t id = coarse_heap.top().second;
            coarse_heap.pop();
            float d_exact = InnerProductSIMD(raw_base + id * dim, query, dim);
            if (top_k_heap.size() < k) {
                top_k_heap.emplace(d_exact, id);
            } else if (d_exact < top_k_heap.top().first) {
                top_k_heap.pop();
                top_k_heap.emplace(d_exact, id);
            }
        }

        return top_k_heap;
    }
};
