#pragma once

#include <vector>
#include <queue>
#include <algorithm>
#include <pthread.h>
#include <cstring>
#include <arm_neon.h>
#include <cmath>
#include <random>
#include <iostream>
#include <limits>
#include <atomic>
#include <cassert>
#include "simd_utils.h"   // InnerProductSIMD

#ifndef PQ_PTHREAD_CONSTS
#define PQ_PTHREAD_CONSTS
static constexpr int PQ_PT_NUM_THREADS  = 8;   // 1 主线程 + 7 子线程
static constexpr int PQ_PT_K_CENTROIDS  = 256;
static constexpr int PQ_PT_SUB_DIM      = 6;
static constexpr int PQ_PT_ALIGN_DIM    = 8;
static constexpr int PQ_PT_M_SUBSPACES  = 16;
static constexpr int PQ_PT_MAX_ITER     = 10;

static constexpr size_t PQ_PT_LUT_BYTES =
    PQ_PT_M_SUBSPACES * PQ_PT_K_CENTROIDS * sizeof(float);
#endif

using HeapPairF = std::pair<float, uint32_t>;
using MaxHeapF  = std::priority_queue<HeapPairF>;

static inline void heap_push_bounded(MaxHeapF& h, float dist, uint32_t id, size_t p) {
    if (h.size() < p)              h.emplace(dist, id);
    else if (dist < h.top().first) { h.pop(); h.emplace(dist, id); }
}


class PQIndexPthread {
public:
    std::vector<float>   codebooks;  
    std::vector<uint8_t> codes;      
    const float*         raw_base = nullptr;
    size_t n = 0, dim = 0;

    PQIndexPthread()  { init_pool(); }
    ~PQIndexPthread() { stop_pool(); }

    void train(const float* base, size_t num, size_t d) {
        n = num; dim = d; raw_base = base;
        codebooks.assign(PQ_PT_M_SUBSPACES * PQ_PT_K_CENTROIDS * PQ_PT_ALIGN_DIM, 0.0f);
        codes.resize(n * PQ_PT_M_SUBSPACES);

        std::cout << "--- [PQ-Pthread] Training " << PQ_PT_M_SUBSPACES
                  << " subspaces (serial KMeans) ---" << std::endl;
        for (int m = 0; m < PQ_PT_M_SUBSPACES; ++m) {
            size_t train_n = std::min((size_t)10000, n);
            train_subspace_internal(base, train_n, dim, m,
                &codebooks[m * PQ_PT_K_CENTROIDS * PQ_PT_ALIGN_DIM]);
        }

        std::cout << "--- [PQ-Pthread] Encoding (Pthread parallel) ---" << std::endl;
        encode_parallel(base);
        std::cout << "--- [PQ-Pthread] Ready ---" << std::endl;
    }

    MaxHeapF search(const float* query, size_t k, size_t p = 0) {
        if (p == 0 || p < k) p = k;
        auto results = batch_search(query, 1, k, p);
        return std::move(results[0]);
    }

   
    // Batch query 搜索
    std::vector<MaxHeapF> batch_search(const float* queries, size_t Q,
                                        size_t k, size_t p = 0) {
        if (p == 0 || p < k) p = k;
        assert(n > 0 && "Index not trained");

        std::vector<MaxHeapF> results(Q);
        for (int t = 0; t < PQ_PT_NUM_THREADS; ++t) {
            auto& ctx        = worker_ctx_[t];
            ctx.bq_queries   = queries;
            ctx.bq_Q         = Q;
            ctx.bq_k         = k;
            ctx.bq_p         = p;
            ctx.bq_results   = results.data();
        }

        dispatch_and_join(PHASE_BATCH_QUERY);
        return results;
    }

private:

    enum Phase {
        PHASE_IDLE        = 0,
        PHASE_BATCH_QUERY,  
        PHASE_ENCODE,        
        PHASE_STOP
    };


    struct alignas(64) WorkerCtx {
        PQIndexPthread* self;
        int             tid;

        const float*    bq_queries;
        size_t          bq_Q;
        size_t          bq_k;
        size_t          bq_p;
        MaxHeapF*       bq_results;   
        const float*    enc_base;
        size_t          enc_lo, enc_hi;
    };

    Phase                  cur_phase_ = PHASE_IDLE;
    WorkerCtx              worker_ctx_[PQ_PT_NUM_THREADS];
    pthread_t              threads_[PQ_PT_NUM_THREADS - 1];
    pthread_barrier_t      barrier_start_;
    pthread_barrier_t      barrier_end_;
    std::atomic<bool>      stop_flag_{false};

    void init_pool() {
        for (int t = 0; t < PQ_PT_NUM_THREADS; ++t) {
            worker_ctx_[t].self = this;
            worker_ctx_[t].tid  = t;
        }
        pthread_barrier_init(&barrier_start_, nullptr, PQ_PT_NUM_THREADS);
        pthread_barrier_init(&barrier_end_,   nullptr, PQ_PT_NUM_THREADS);
        for (int t = 1; t < PQ_PT_NUM_THREADS; ++t)
            pthread_create(&threads_[t-1], nullptr, worker_entry, &worker_ctx_[t]);
    }

    void stop_pool() {
        stop_flag_  = true;
        cur_phase_  = PHASE_STOP;
        pthread_barrier_wait(&barrier_start_);
        for (int t = 1; t < PQ_PT_NUM_THREADS; ++t)
            pthread_join(threads_[t-1], nullptr);
        pthread_barrier_destroy(&barrier_start_);
        pthread_barrier_destroy(&barrier_end_);
    }

    static void* worker_entry(void* arg) {
        auto* ctx = reinterpret_cast<WorkerCtx*>(arg);
        ctx->self->worker_loop(ctx->tid);
        return nullptr;
    }

    void worker_loop(int tid) {
        while (true) {
            pthread_barrier_wait(&barrier_start_);
            if (stop_flag_) break;
            switch (cur_phase_) {
                case PHASE_BATCH_QUERY: do_batch_query_shard(tid); break;
                case PHASE_ENCODE:      do_encode_shard(tid);      break;
                default: break;
            }
            pthread_barrier_wait(&barrier_end_);
        }
    }

    void dispatch_and_join(Phase ph) {
        cur_phase_ = ph;
        pthread_barrier_wait(&barrier_start_);   
        switch (ph) {
            case PHASE_BATCH_QUERY: do_batch_query_shard(0); break;
            case PHASE_ENCODE:      do_encode_shard(0);      break;
            default: break;
        }
        pthread_barrier_wait(&barrier_end_);     // 等待所有线程完成
        cur_phase_ = PHASE_IDLE;
    }


    void do_batch_query_shard(int tid) {
        auto& ctx          = worker_ctx_[tid];
        const float* queries = ctx.bq_queries;
        size_t Q           = ctx.bq_Q;
        size_t k           = ctx.bq_k;
        size_t p           = ctx.bq_p;
        MaxHeapF* results  = ctx.bq_results;

        alignas(64) float lut[PQ_PT_M_SUBSPACES * PQ_PT_K_CENTROIDS];
        for (size_t qi = (size_t)tid; qi < Q; qi += PQ_PT_NUM_THREADS) {
            const float* query = queries + qi * dim;

            // LUT 构建（子空间并行已内联，单线程内串行 M 个子空间）
            build_lut_single(query, lut);

            // 全量扫描 codes，维护局部 top-p 堆
            MaxHeapF coarse;
            scan_codes_with_lut(lut, p, coarse);

            //  Rerank（NEON InnerProduct 精排）
            results[qi] = rerank_heap(coarse, query, k);
        }
    }

    void build_lut_single(const float* query, float* lut) {
        for (int m = 0; m < PQ_PT_M_SUBSPACES; ++m) {
            alignas(16) float q_align[PQ_PT_ALIGN_DIM] = {};
            std::memcpy(q_align, query + m * PQ_PT_SUB_DIM,
                        PQ_PT_SUB_DIM * sizeof(float));
            float32x4_t q_v0 = vld1q_f32(q_align);
            float32x4_t q_v1 = vld1q_f32(q_align + 4);

            const float* cb_m  = &codebooks[m * PQ_PT_K_CENTROIDS * PQ_PT_ALIGN_DIM];
            float*       lut_m = lut + m * PQ_PT_K_CENTROIDS;

            // 对 K=256 个 centroid 计算 L2 距离，4 路展开减少循环开销
            for (int ki = 0; ki < PQ_PT_K_CENTROIDS; ki += 4) {
                // centroid ki
                const float* c0 = cb_m + (ki+0) * PQ_PT_ALIGN_DIM;
                float32x4_t d0  = vsubq_f32(q_v0, vld1q_f32(c0));
                float32x4_t d0h = vsubq_f32(q_v1, vld1q_f32(c0 + 4));
                lut_m[ki+0] = vaddvq_f32(vfmaq_f32(vmulq_f32(d0, d0), d0h, d0h));

                // centroid ki+1
                const float* c1 = cb_m + (ki+1) * PQ_PT_ALIGN_DIM;
                float32x4_t d1  = vsubq_f32(q_v0, vld1q_f32(c1));
                float32x4_t d1h = vsubq_f32(q_v1, vld1q_f32(c1 + 4));
                lut_m[ki+1] = vaddvq_f32(vfmaq_f32(vmulq_f32(d1, d1), d1h, d1h));

                // centroid ki+2
                const float* c2 = cb_m + (ki+2) * PQ_PT_ALIGN_DIM;
                float32x4_t d2  = vsubq_f32(q_v0, vld1q_f32(c2));
                float32x4_t d2h = vsubq_f32(q_v1, vld1q_f32(c2 + 4));
                lut_m[ki+2] = vaddvq_f32(vfmaq_f32(vmulq_f32(d2, d2), d2h, d2h));

                // centroid ki+3
                const float* c3 = cb_m + (ki+3) * PQ_PT_ALIGN_DIM;
                float32x4_t d3  = vsubq_f32(q_v0, vld1q_f32(c3));
                float32x4_t d3h = vsubq_f32(q_v1, vld1q_f32(c3 + 4));
                lut_m[ki+3] = vaddvq_f32(vfmaq_f32(vmulq_f32(d3, d3), d3h, d3h));
            }
        }
    }

    void scan_codes_with_lut(const float* lut, size_t p, MaxHeapF& heap) {
        for (size_t i = 0; i < n; ++i) {
            if (i + 16 < n)
                __builtin_prefetch(&codes[(i + 16) * PQ_PT_M_SUBSPACES], 0, 3);

            const uint8_t* vc = &codes[i * PQ_PT_M_SUBSPACES];

            // 4 路展开，与原 simd_pq.h 完全一致
            float s0 = lut[0 * PQ_PT_K_CENTROIDS + vc[0]];
            float s1 = lut[1 * PQ_PT_K_CENTROIDS + vc[1]];
            float s2 = lut[2 * PQ_PT_K_CENTROIDS + vc[2]];
            float s3 = lut[3 * PQ_PT_K_CENTROIDS + vc[3]];
            for (int m = 4; m < PQ_PT_M_SUBSPACES; m += 4) {
                s0 += lut[(m+0) * PQ_PT_K_CENTROIDS + vc[m+0]];
                s1 += lut[(m+1) * PQ_PT_K_CENTROIDS + vc[m+1]];
                s2 += lut[(m+2) * PQ_PT_K_CENTROIDS + vc[m+2]];
                s3 += lut[(m+3) * PQ_PT_K_CENTROIDS + vc[m+3]];
            }
            heap_push_bounded(heap, s0+s1+s2+s3, (uint32_t)i, p);
        }
    }

    MaxHeapF rerank_heap(MaxHeapF& coarse, const float* query, size_t k) {
        MaxHeapF final_k;
        while (!coarse.empty()) {
            uint32_t id  = coarse.top().second;
            coarse.pop();
            float exact  = InnerProductSIMD(raw_base + (size_t)id * dim, query, dim);
            heap_push_bounded(final_k, exact, id, k);
        }
        return final_k;
    }

    // 编码阶段并行（base 向量分块，训练时调用一次）

    void encode_parallel(const float* base) {
        size_t chunk = (n + PQ_PT_NUM_THREADS - 1) / PQ_PT_NUM_THREADS;
        for (int t = 0; t < PQ_PT_NUM_THREADS; ++t) {
            worker_ctx_[t].enc_base = base;
            worker_ctx_[t].enc_lo   = (size_t)t * chunk;
            worker_ctx_[t].enc_hi   = std::min((size_t)(t+1) * chunk, n);
        }
        dispatch_and_join(PHASE_ENCODE);
    }

    void do_encode_shard(int tid) {
        const float* base = worker_ctx_[tid].enc_base;
        size_t lo         = worker_ctx_[tid].enc_lo;
        size_t hi         = worker_ctx_[tid].enc_hi;

        for (size_t i = lo; i < hi; ++i) {
            for (int m = 0; m < PQ_PT_M_SUBSPACES; ++m) {
                const float* vs = base + i * dim + m * PQ_PT_SUB_DIM;
                float        min_l2 = std::numeric_limits<float>::max();
                uint8_t      best_k = 0;
                const float* cb     = &codebooks[m * PQ_PT_K_CENTROIDS * PQ_PT_ALIGN_DIM];
                for (int k = 0; k < PQ_PT_K_CENTROIDS; ++k) {
                    const float* c = cb + k * PQ_PT_ALIGN_DIM;
                    float l2 = 0;
                    for (int sd = 0; sd < PQ_PT_SUB_DIM; ++sd) {
                        float df = vs[sd] - c[sd]; l2 += df * df;
                    }
                    if (l2 < min_l2) { min_l2 = l2; best_k = (uint8_t)k; }
                }
                codes[i * PQ_PT_M_SUBSPACES + m] = best_k;
            }
        }
    }

    // ─────────────────────────────────────────────────────────────────
    // KMeans 子空间训练
    // ─────────────────────────────────────────────────────────────────
    void train_subspace_internal(const float* data, size_t n_t, size_t total_dim,
                                  int m, float* out_cb) {
        std::vector<size_t> idx(n_t);
        for (size_t i = 0; i < n_t; ++i) idx[i] = i;
        std::mt19937 rng(42 + m);
        std::shuffle(idx.begin(), idx.end(), rng);

        // 随机初始化 K 个 centroid
        for (int k = 0; k < PQ_PT_K_CENTROIDS; ++k)
            std::memcpy(out_cb + k * PQ_PT_ALIGN_DIM,
                        data + idx[k] * total_dim + m * PQ_PT_SUB_DIM,
                        PQ_PT_SUB_DIM * sizeof(float));

        std::vector<int>   assign(n_t);
        for (int iter = 0; iter < PQ_PT_MAX_ITER; ++iter) {
            // E 步：分配
            for (size_t i = 0; i < n_t; ++i) {
                const float* v  = data + i * total_dim + m * PQ_PT_SUB_DIM;
                float best_d    = std::numeric_limits<float>::max();
                int   bk        = 0;
                for (int k = 0; k < PQ_PT_K_CENTROIDS; ++k) {
                    float d = 0; const float* c = out_cb + k * PQ_PT_ALIGN_DIM;
                    for (int sd = 0; sd < PQ_PT_SUB_DIM; ++sd) {
                        float df = v[sd] - c[sd]; d += df * df;
                    }
                    if (d < best_d) { best_d = d; bk = k; }
                }
                assign[i] = bk;
            }
            // M 步：更新
            std::vector<float> nc(PQ_PT_K_CENTROIDS * PQ_PT_SUB_DIM, 0.f);
            std::vector<int>   cnt(PQ_PT_K_CENTROIDS, 0);
            for (size_t i = 0; i < n_t; ++i) {
                int k = assign[i];
                for (int sd = 0; sd < PQ_PT_SUB_DIM; ++sd)
                    nc[k * PQ_PT_SUB_DIM + sd] += data[i * total_dim + m * PQ_PT_SUB_DIM + sd];
                cnt[k]++;
            }
            for (int k = 0; k < PQ_PT_K_CENTROIDS; ++k) {
                if (cnt[k] > 0) {
                    for (int sd = 0; sd < PQ_PT_SUB_DIM; ++sd)
                        out_cb[k * PQ_PT_ALIGN_DIM + sd] = nc[k * PQ_PT_SUB_DIM + sd] / cnt[k];
                } else {
                    // 处理空簇：随机重新初始化
                    size_t r = idx[std::uniform_int_distribution<size_t>(0, n_t-1)(rng)];
                    std::memcpy(out_cb + k * PQ_PT_ALIGN_DIM,
                                data + r * total_dim + m * PQ_PT_SUB_DIM,
                                PQ_PT_SUB_DIM * sizeof(float));
                }
            }
        }
    }
};