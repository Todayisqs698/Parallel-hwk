#pragma once

#include <omp.h>
#include "ivfpq_index_base.h"

class IVFPQOpenMPSIMD : public IVFPQIndexBase {
public:
    /**
     * search
     * @param nprobe    粗排候选簇数
     * @param rerank_p  精排候选池大小（>= k）
     */
    IVFHeap search(const float* query, size_t k,
                   size_t nprobe, size_t rerank_p = 0) const {
        if (rerank_p < k) rerank_p = k;
        nprobe = std::min(nprobe, nlist);

        //  粗排
        std::vector<size_t> sel;
        coarse_select(query, nprobe, sel);

        //LUT 构建
        alignas(64) float lut[PQ_LUT_N];
        build_lut_simd(query, lut);  

        // 展平候选向量 
        struct FlatEntry { const uint8_t* codes; uint32_t gid; };
        std::vector<FlatEntry> flat;
        flat.reserve(nprobe * (N / nlist + 64));
        for (size_t ci = 0; ci < nprobe; ++ci) {
            size_t cid   = sel[ci];
            size_t n_vec = inv_ids[cid].size();
            const uint8_t* base_ptr = inv_pq_codes_[cid].data();
            for (size_t j = 0; j < n_vec; ++j)
                flat.push_back({base_ptr + j * PQ_M, inv_ids[cid][j]});
        }

        // OpenMP 并行扫描 + 线程私有局部堆 
        int num_t = omp_get_max_threads();
        std::vector<IVFHeap> thread_heaps(num_t);

        #pragma omp parallel
        {
            int tid = omp_get_thread_num();
            IVFHeap& local = thread_heaps[tid];

            #pragma omp for schedule(static)
            for (int i = 0; i < (int)flat.size(); ++i) {
                const uint8_t* vc = flat[i].codes;

                float s0 = lut[0*PQ_K + vc[0]];
                float s1 = lut[1*PQ_K + vc[1]];
                float s2 = lut[2*PQ_K + vc[2]];
                float s3 = lut[3*PQ_K + vc[3]];
                for (int m = 4; m < PQ_M; m += 4) {
                    s0 += lut[(m+0)*PQ_K + vc[m+0]];
                    s1 += lut[(m+1)*PQ_K + vc[m+1]];
                    s2 += lut[(m+2)*PQ_K + vc[m+2]];
                    s3 += lut[(m+3)*PQ_K + vc[m+3]];
                }
                ivf_heap_push(local, s0+s1+s2+s3, flat[i].gid, rerank_p);
            }
        }

        // Reduce
        IVFHeap coarse;
        for (auto& lh : thread_heaps) {
            while (!lh.empty()) {
                ivf_heap_push(coarse, lh.top().first, lh.top().second, rerank_p);
                lh.pop();
            }
        }

        // Rerank 
        return rerank(coarse, query, k);
    }
};