#pragma once
#include <pthread.h>
#include <atomic>
#include "ivfpq_index_base.h"

class IVFPQPthreadStatic : public IVFPQIndexBase {
public:
    IVFPQPthreadStatic()  : stop_(false) { init_pool(); }
    ~IVFPQPthreadStatic() { stop_pool(); }

    /**
     * search
     * @param nprobe    粗排候选簇数
     * @param rerank_p  精排候选池大小（>= k）
     */
    IVFHeap search(const float* query, size_t k,
                   size_t nprobe, size_t rerank_p = 0) {
        if (rerank_p < k) rerank_p = k;
        nprobe = std::min(nprobe, nlist);

        //  粗排
        cur_sel_.resize(nprobe);
        {
            std::vector<size_t> sel;
            coarse_select(query, nprobe, sel);
            cur_sel_ = sel;
        }

        // NEON SIMD LUT 构建
        build_lut_simd(query, shared_lut_);

        // 静态分配
        cur_nprobe_   = nprobe;
        cur_query_    = query;
        cur_rerank_p_ = rerank_p;
        for (int t = 0; t < IVF_NTHREADS; ++t)
            local_heaps_[t].h = IVFHeap();

        dispatch_and_join();

        // Reduce → 粗候选堆
        IVFHeap coarse;
        for (int t = 0; t < IVF_NTHREADS; ++t) {
            IVFHeap& lh = local_heaps_[t].h;
            while (!lh.empty()) {
                ivf_heap_push(coarse, lh.top().first, lh.top().second, rerank_p);
                lh.pop();
            }
        }

        //Rerank
        return rerank(coarse, query, k);
    }

private:
    const float*         cur_query_    = nullptr;
    size_t               cur_rerank_p_ = 0;
    size_t               cur_nprobe_   = 0;
    std::vector<size_t>  cur_sel_;             
    alignas(64) float    shared_lut_[PQ_LUT_N];


    struct alignas(64) AlignedHeap { IVFHeap h; };
    AlignedHeap local_heaps_[IVF_NTHREADS];


    pthread_t         threads_[IVF_NTHREADS - 1];
    pthread_barrier_t bar_start_;
    pthread_barrier_t bar_end_;
    std::atomic<bool> stop_;

    struct WArg { IVFPQPthreadStatic* self; int tid; };
    WArg wargs_[IVF_NTHREADS];

    void init_pool() {
        pthread_barrier_init(&bar_start_, nullptr, IVF_NTHREADS);
        pthread_barrier_init(&bar_end_,   nullptr, IVF_NTHREADS);
        for (int t = 0; t < IVF_NTHREADS; ++t) wargs_[t] = {this, t};
        for (int t = 1; t < IVF_NTHREADS; ++t)
            pthread_create(&threads_[t-1], nullptr, worker, &wargs_[t]);
    }

    void stop_pool() {
        stop_.store(true, std::memory_order_release);
        pthread_barrier_wait(&bar_start_);
        for (int t = 1; t < IVF_NTHREADS; ++t)
            pthread_join(threads_[t-1], nullptr);
        pthread_barrier_destroy(&bar_start_);
        pthread_barrier_destroy(&bar_end_);
    }

    static void* worker(void* arg) {
        WArg* a = (WArg*)arg;
        a->self->thread_loop(a->tid);
        return nullptr;
    }

    void thread_loop(int tid) {
        while (true) {
            pthread_barrier_wait(&bar_start_);
            if (stop_.load(std::memory_order_acquire)) break;
            run_pq_static(tid);
            pthread_barrier_wait(&bar_end_);
        }
    }

    void dispatch_and_join() {
        pthread_barrier_wait(&bar_start_);
        run_pq_static(0);             
        pthread_barrier_wait(&bar_end_);
    }

 
    void run_pq_static(int tid) {
        // LUT 
        alignas(64) float private_lut[PQ_LUT_N];
        std::memcpy(private_lut, shared_lut_, PQ_LUT_N * sizeof(float));

        IVFHeap& local  = local_heaps_[tid].h;
        size_t   rp     = cur_rerank_p_;
        size_t   nprobe = cur_nprobe_;

        // stride 分配
        for (size_t ci = (size_t)tid; ci < nprobe; ci += IVF_NTHREADS) {
            size_t         cid      = cur_sel_[ci];
            size_t         n_vec    = inv_ids[cid].size();
            const uint8_t* codes    = inv_pq_codes_[cid].data();

            if (n_vec == 0) continue;
            __builtin_prefetch(codes, 0, 3);

            // ADC 扫描
            size_t j = 0;
            for (; j + 3 < n_vec; j += 4) {
                if (j + 16 < n_vec)
                    __builtin_prefetch(codes + (j + 16) * PQ_M, 0, 2);

                const uint8_t* vc0 = codes + (j+0) * PQ_M;
                const uint8_t* vc1 = codes + (j+1) * PQ_M;
                const uint8_t* vc2 = codes + (j+2) * PQ_M;
                const uint8_t* vc3 = codes + (j+3) * PQ_M;

                float s0 = private_lut[0*PQ_K + vc0[0]];
                float s1 = private_lut[0*PQ_K + vc1[0]];
                float s2 = private_lut[0*PQ_K + vc2[0]];
                float s3 = private_lut[0*PQ_K + vc3[0]];
                for (int m = 1; m < PQ_M; ++m) {
                    s0 += private_lut[m*PQ_K + vc0[m]];
                    s1 += private_lut[m*PQ_K + vc1[m]];
                    s2 += private_lut[m*PQ_K + vc2[m]];
                    s3 += private_lut[m*PQ_K + vc3[m]];
                }
                ivf_heap_push(local, s0, inv_ids[cid][j+0], rp);
                ivf_heap_push(local, s1, inv_ids[cid][j+1], rp);
                ivf_heap_push(local, s2, inv_ids[cid][j+2], rp);
                ivf_heap_push(local, s3, inv_ids[cid][j+3], rp);
            }
            // 尾部处理
            for (; j < n_vec; ++j) {
                const uint8_t* vc = codes + j * PQ_M;
                float s = 0;
                for (int m = 0; m < PQ_M; ++m)
                    s += private_lut[m * PQ_K + vc[m]];
                ivf_heap_push(local, s, inv_ids[cid][j], rp);
            }
        }
    }
};