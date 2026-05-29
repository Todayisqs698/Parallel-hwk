#pragma once
#include "ivf_index_base.h"

class IVFFlat : public IVFIndexBase {
public:
    // build() 直接继承自 IVFIndexBase，无需重写
    // search：串行精确检索,nprobe=粗排候选簇数, p=候选池大小
    IVFHeap search(const float* query, size_t k,
                   size_t nprobe, size_t p = 0) const {
        if (p < k) p = k;
        nprobe = std::min(nprobe, nlist);

        // 粗排：选出 nprobe 个最近簇
        std::vector<size_t> sel;
        coarse_select(query, nprobe, sel);

        // 精排：串行标量内积，维护 top-p 最大堆 
        IVFHeap heap;
        for (size_t ci = 0; ci < nprobe; ++ci) {
            size_t cid       = sel[ci];
            size_t n_vec     = inv_ids[cid].size();
            const float* vecs = inv_vecs[cid].data();

            for (size_t j = 0; j < n_vec; ++j) {
                const float* v = vecs + j * dim;

                // 标量内积
                float ip = 0.f;
                for (size_t d = 0; d < dim; ++d) ip += v[d] * query[d];
                float dist = 1.f - ip;  
                ivf_heap_push(heap, dist, inv_ids[cid][j], p);
            }
        }
        // p → k：若 p > k，将堆缩减到 k
        while (heap.size() > k) heap.pop();
        return heap;
    }
};