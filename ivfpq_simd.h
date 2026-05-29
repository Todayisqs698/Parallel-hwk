#pragma once


#include "ivfpq_index_base.h"
#include <algorithm>
#include <vector>

class IVFPQSimd : public IVFPQIndexBase {
public:
    // build_pq() 继承自 IVFPQIndexBase，直接使用

    IVFHeap search(const float* query, size_t k,
                   size_t nprobe, size_t rerank_p = 0) const {
        if (rerank_p < k) rerank_p = k;
        nprobe = std::min(nprobe, nlist);

        // 粗排（选出 nprobe 个最近簇）
        std::vector<size_t> sel;
        coarse_select(query, nprobe, sel);

        // 构建 LUT（ NEON SIMD 4路展开） 
        alignas(64) float lut[PQ_LUT_N];
        build_lut_simd(query, lut); 

        //单线程串行扫描
        IVFHeap coarse;
        for (size_t ci = 0; ci < nprobe; ++ci) {
            size_t cid   = sel[ci];
            size_t n_vec = inv_ids[cid].size();
            
            if (n_vec == 0) continue;
            scan_list_interleaved_4way(cid, lut, rerank_p, coarse);
        }

        // Rerank（NEON InnerProduct 精排）
        return rerank(coarse, query, k);
    }
private:
    void scan_list_interleaved_4way(size_t cid, const float* lut, size_t p, IVFHeap& heap) const {
        size_t n_vec = inv_ids[cid].size();
        const uint8_t* codes_base = inv_pq_codes_[cid].data();
        const uint32_t* ids_base  = inv_ids[cid].data();

        size_t j = 0;
        // 主循环：每次跨步同时加载、计算 4 个独立的向量
        for (; j + 3 < n_vec; j += 4) {
 
            __builtin_prefetch(codes_base + (j + 16) * PQ_M, 0, 3);
            __builtin_prefetch(ids_base + j + 16, 0, 3);

            const uint8_t* vc0 = codes_base + (j + 0) * PQ_M;
            const uint8_t* vc1 = codes_base + (j + 1) * PQ_M;
            const uint8_t* vc2 = codes_base + (j + 2) * PQ_M;
            const uint8_t* vc3 = codes_base + (j + 3) * PQ_M;


            float s0 = 0.0f;
            float s1 = 0.0f;
            float s2 = 0.0f;
            float s3 = 0.0f;

            for (int m = 0; m < PQ_M; ++m) {
                size_t offset = m * PQ_K;
                s0 += lut[offset + vc0[m]];
                s1 += lut[offset + vc1[m]];
                s2 += lut[offset + vc2[m]];
                s3 += lut[offset + vc3[m]];
            }

            // 直接推入大顶堆
            ivf_heap_push(heap, s0, ids_base[j + 0], p);
            ivf_heap_push(heap, s1, ids_base[j + 1], p);
            ivf_heap_push(heap, s2, ids_base[j + 2], p);
            ivf_heap_push(heap, s3, ids_base[j + 3], p);
        }

        // 尾部边界处理：当剩余向量不足 4 个时，退回传统标量循环
        for (; j < n_vec; ++j) {
            const uint8_t* vc = codes_base + j * PQ_M;
            float s = 0.0f;
            for (int m = 0; m < PQ_M; ++m) {
                s += lut[m * PQ_K + vc[m]];
            }
            ivf_heap_push(heap, s, ids_base[j], p);
        }
    }
};