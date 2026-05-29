#pragma once

#include <omp.h>
#include <vector>
#include <queue>
#include <algorithm>
#include "ivf_index_base.h"
#include "simd_utils.h"

class IVFOpenMPSIMD : public IVFIndexBase {
public:
    //粗排：并行化 Query 与 1024 个簇中心的距离计算
    void coarse_select_parallel(const float* query, size_t nprobe, std::vector<size_t>& out) const {
        std::vector<std::pair<float, size_t>> dists(nlist);

        #pragma omp parallel for schedule(static)
        for (int c = 0; c < (int)nlist; ++c) {
            const float* cv = centroids.data() + c * dim;
            // 计算 query 到簇中心的距离 (1 - IP)
            float dist = InnerProductSIMD(query, cv, dim);
            dists[c] = {dist, (size_t)c};
        }

        std::partial_sort(dists.begin(), dists.begin() + nprobe, dists.end());
        
        out.resize(nprobe);
        for (size_t i = 0; i < nprobe; ++i) {
            out[i] = dists[i].second;
        }
    }

    //search
    IVFHeap search(const float* query, size_t k, size_t nprobe, size_t p = 0) const {
        if (p < k) p = k;
        nprobe = std::min(nprobe, nlist);

        // 调用子类并行粗排
        std::vector<size_t> sel;
        coarse_select_parallel(query, nprobe, sel);

        // 为每个线程分配独立的局部堆
        int num_threads = omp_get_max_threads();
        std::vector<IVFHeap> thread_heaps(num_threads);

        #pragma omp parallel for schedule(dynamic, 1)
        for (int ci = 0; ci < (int)nprobe; ++ci) {
            int tid = omp_get_thread_num();
            IVFHeap& local_heap = thread_heaps[tid];

            size_t cid = sel[ci];
            size_t n_vec = inv_ids[cid].size();
            const float* vecs = inv_vecs[cid].data();

            for (size_t j = 0; j < n_vec; ++j) {
                const float* v = vecs + j * dim;
                float dist = InnerProductSIMD(v, query, dim);

                // 压入局部线程堆
                ivf_heap_push(local_heap, dist, inv_ids[cid][j], p);
            }
        }

        // Reduce 阶段：将 8 个线程的局部堆合并
        IVFHeap result;
        for (auto& lh : thread_heaps) {
            while (!lh.empty()) {
                ivf_heap_push(result, lh.top().first, lh.top().second, k);
                lh.pop();
            }
        }

        return result;
    }
};