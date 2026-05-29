#pragma once
#include "ivf_index_base.h"
#include "simd_utils.h" 

class IVFSimd : public IVFIndexBase {
public:
    // build() 直接继承自 IVFIndexBase，无需重写

    //search：使用 ARM NEON SIMD 加速的精确检索,query:查询向量指针,k:最终返回的 Top-K 数量,nprobe:粗排候选簇数,p:候选池大小
    IVFHeap search(const float* query, size_t k,
                   size_t nprobe, size_t p = 0) const {
        if (p < k) p = k;
        nprobe = std::min(nprobe, nlist);

        // 1. 粗排：选出 nprobe 个最近簇
        std::vector<size_t> sel;
        coarse_select(query, nprobe, sel);

        // 2. 精排：串行内积扫射，使用 NEON 算子加速，维护 top-p 最大堆 
        IVFHeap heap;
        for (size_t ci = 0; ci < nprobe; ++ci) {
            size_t cid        = sel[ci];
            size_t n_vec     = inv_ids[cid].size();
            const float* vecs = inv_vecs[cid].data();

            for (size_t j = 0; j < n_vec; ++j) {
                const float* v = vecs + j * dim;

                float dist = InnerProductSIMD(v, query, dim);

                // 压入最大堆，过滤出局部 Top-P
                ivf_heap_push(heap, dist, inv_ids[cid][j], p);
            }
        }

        // p → k：若 p > k，将堆缩减到 k
        while (heap.size() > k) heap.pop();
        return heap;
    }
};