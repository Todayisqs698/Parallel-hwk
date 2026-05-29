#pragma once
/**
 * hnsw_search.h  —  HNSW Layer 0 并行查询：四种变体
 * =====================================================================
 * 变体 A: HNSWSearchBaseline      — 单线程 + NEON SIMD
 * 变体 B: HNSWSearchMultiEntry    — 多入口点并行
 * 变体 C: HNSWSearchEdgeParallel  — 邻居边划分并行（静态线程池）
 * 变体 D: HNSWSearchPointPartition — Layer0 点划分全量扫描并行
 * =====================================================================
 */

#include <vector>
#include <queue>
#include <mutex>
#include <atomic>
#include <pthread.h>
#include <random>
#include <algorithm>
#include <cstring>
#include <limits>
#include "hnswlib/hnswlib/hnswlib.h"
#include "simd_utils.h"   

using namespace hnswlib;

// 结果类型（与 hnswlib searchKnn 返回类型一致）
using KNNResult = std::priority_queue<std::pair<float, labeltype>>;

// ─────────────────────────────────────────────────────────────────────
// 合并多个 KNNResult 堆 → top-k
// ─────────────────────────────────────────────────────────────────────
static KNNResult merge_results(std::vector<KNNResult>& heaps, size_t k) {
    std::priority_queue<std::pair<float,labeltype>> merged;
    for (auto& h : heaps) {
        while (!h.empty()) {
            auto top = h.top(); h.pop();
            merged.push(top);
            if (merged.size() > k) merged.pop();
        }
    }
    return merged;
}

// ═════════════════════════════════════════════════════════════════════
// 变体 A: HNSWSearchBaseline — 单线程 Baseline
// ═════════════════════════════════════════════════════════════════════
class HNSWSearchBaseline {
public:
    HierarchicalNSW<float>* index;
    explicit HNSWSearchBaseline(HierarchicalNSW<float>* idx) : index(idx) {}

    KNNResult search(const float* query, size_t k, size_t ef) {
        index->setEf(ef);
        return index->searchKnn(query, k);
    }
};

// ═════════════════════════════════════════════════════════════════════
// 变体 B: HNSWSearchMultiEntry — 多入口点并行
// ═════════════════════════════════════════════════════════════════════
class HNSWSearchMultiEntry {
public:
    static const int N_THREADS = 4;
    HierarchicalNSW<float>* index;

    explicit HNSWSearchMultiEntry(HierarchicalNSW<float>* idx) : index(idx) {
        rng_.seed(42);
    }

    struct Arg {
        HNSWSearchMultiEntry* self;
        int    tid;
        const float* query;
        size_t k;
        size_t ef;
        const tableint* entries;   
        size_t n_local;            
        KNNResult* result;
    };

    static KNNResult search_from_ep(
        HierarchicalNSW<float>* idx,
        const float* query,
        tableint ep,
        size_t ef,
        size_t k)
    {
        using PairDT = std::pair<float, tableint>;
        using MaxHeap = std::priority_queue<PairDT>;                                                            // R
        using MinHeap = std::priority_queue<PairDT, std::vector<PairDT>, std::greater<PairDT>>;            // C

        static thread_local std::vector<uint16_t> visited_buf;
        static thread_local uint16_t              visited_tag = 0;
        size_t n = idx->cur_element_count;
        if (visited_buf.size() < n) visited_buf.assign(n, 0);
        ++visited_tag;
        if (visited_tag == 0) {
            std::fill(visited_buf.begin(), visited_buf.end(), 0);
            visited_tag = 1;
        }

        auto dist_fn  = idx->fstdistfunc_;
        auto dist_par = idx->dist_func_param_;
        auto get_data = [&](tableint id) {
            return idx->getDataByInternalId(id);
        };

        float ep_dist = dist_fn(query, get_data(ep), dist_par);
        MaxHeap R;  R.emplace(ep_dist, ep);
        MinHeap C;  C.emplace(ep_dist, ep);
        visited_buf[ep] = visited_tag;
        float lower_bound = ep_dist;

        while (!C.empty()) {
            auto c_top = C.top();
            float c_dist = c_top.first;
            tableint c_node = c_top.second;
            if (c_dist > lower_bound && R.size() >= ef) break;
            C.pop();

            auto* link = idx->get_linklist0(c_node);
            int   nbs  = (int)idx->getListCount(link);
            tableint* nb_arr = reinterpret_cast<tableint*>(link + 1);

            for (int j = 0; j < std::min(nbs, 4); ++j)
                __builtin_prefetch(get_data(nb_arr[j]), 0, 2);

            for (int j = 0; j < nbs; ++j) {
                tableint nb = nb_arr[j];
                if (visited_buf[nb] == visited_tag) continue;
                visited_buf[nb] = visited_tag;

                if (j + 4 < nbs)
                    __builtin_prefetch(get_data(nb_arr[j + 4]), 0, 2);

                float nb_dist = dist_fn(query, get_data(nb), dist_par);

                if (R.size() < ef || nb_dist < lower_bound) {
                    C.emplace(nb_dist, nb);
                    R.emplace(nb_dist, nb);
                    if (R.size() > ef) R.pop();
                    if (!R.empty()) lower_bound = R.top().first;
                }
            }
        }

        KNNResult result;
        while (!R.empty()) {
            auto top = R.top(); R.pop();
            result.emplace(top.first, idx->getExternalLabel(top.second));
        }
        while (result.size() > k) result.pop();
        return result;
    }

    static void run_search(Arg* a) {
        if (a->n_local == 0) return;

        HierarchicalNSW<float>* idx = a->self->index;
        const float* query          = a->query;
        size_t ef                   = a->ef;
        size_t k                    = a->k;

        std::vector<KNNResult> local_results(a->n_local);
        for (size_t i = 0; i < a->n_local; ++i) {
            tableint ep = a->entries[i];
            idx->setEf(ef);
            local_results[i] = search_from_ep(idx, query, ep, ef, k); 
        }
        *a->result = merge_results(local_results, k);
    }

    KNNResult search(const float* query, size_t k,
                     size_t ef_per_thread, size_t n_entries = N_THREADS) {
        size_t n = index->cur_element_count;
        if (n == 0) return KNNResult{};

        std::vector<tableint> entries(n_entries);
        {
            std::lock_guard<std::mutex> lk(rng_mu_);
            std::uniform_int_distribution<tableint> uid(0, (tableint)(n-1));
            for (size_t i = 0; i < n_entries; ++i)
                entries[i] = uid(rng_);
        }

        std::vector<KNNResult> thread_results(N_THREADS);
        std::vector<Arg> args(N_THREADS);
        std::vector<pthread_t> threads(N_THREADS - 1);

        size_t chunk = (n_entries + N_THREADS - 1) / N_THREADS;
        for (int t = 0; t < N_THREADS; ++t) {
            size_t lo = (size_t)t * chunk;
            size_t hi = std::min(lo + chunk, n_entries);
            args[t] = {
                this, t, query, k, ef_per_thread,
                entries.data() + lo,
                (hi > lo) ? (hi - lo) : 0,
                &thread_results[t]
            };
        }

        for (int t = 1; t < N_THREADS; ++t)
            pthread_create(&threads[t-1], nullptr, worker, &args[t]);
            
        run_search(&args[0]);
        
        for (int t = 1; t < N_THREADS; ++t)
            pthread_join(threads[t-1], nullptr);

        return merge_results(thread_results, k);
    }

private:
    std::mt19937 rng_;
    std::mutex   rng_mu_;

    static void* worker(void* arg) {
        run_search(reinterpret_cast<Arg*>(arg));
        return nullptr;
    }
};

// ═════════════════════════════════════════════════════════════════════
// 变体 C: HNSWSearchEdgeParallel — 邻居边划分并行
// ═════════════════════════════════════════════════════════════════════
class HNSWSearchEdgeParallel {
public:
    static const int N_THREADS = 8;
    HierarchicalNSW<float>* index;

    explicit HNSWSearchEdgeParallel(HierarchicalNSW<float>* idx)
        : index(idx), stop_(false)
    {
        init_pool();
    }

    ~HNSWSearchEdgeParallel() { stop_pool(); }

    KNNResult search(const float* query, size_t k, size_t ef) {
        using PairDT  = std::pair<float, tableint>;
        using MaxHeap = std::priority_queue<PairDT>;
        using MinHeap = std::priority_queue<PairDT, std::vector<PairDT>, std::greater<PairDT>>;

        size_t n = index->cur_element_count;
        if (n == 0) return KNNResult{};

        if (visited_.size() < n) visited_.assign(n, 0);
        ++visit_tag_;
        if (visit_tag_ == 0) {
            std::fill(visited_.begin(), visited_.end(), 0);
            visit_tag_ = 1;
        }

        auto dist_fn  = index->fstdistfunc_;
        auto dist_par = index->dist_func_param_;
        auto get_data = [&](tableint id) {
            return index->getDataByInternalId(id);
        };

        tableint ep     = index->enterpoint_node_;
        float    ep_d   = dist_fn(query, get_data(ep), dist_par);
        MaxHeap  R;     R.emplace(ep_d, ep);
        MinHeap  C;     C.emplace(ep_d, ep);
        visited_[ep]    = visit_tag_;
        float lb        = ep_d;

        while (!C.empty()) {
            auto c_top = C.top();
            float c_dist = c_top.first;
            tableint c_node = c_top.second;
            if (c_dist > lb && R.size() >= ef) break;
            C.pop();

            auto* link   = index->get_linklist0(c_node);
            int      nbs    = (int)index->getListCount(link);
            tableint* nbarr = reinterpret_cast<tableint*>(link + 1);

            std::vector<tableint> unvisited;
            unvisited.reserve(nbs);
            for (int j = 0; j < nbs; ++j) {
                if (visited_[nbarr[j]] != visit_tag_) {
                    visited_[nbarr[j]] = visit_tag_;   
                    unvisited.push_back(nbarr[j]);
                }
            }

            if (unvisited.empty()) continue;
            size_t m = unvisited.size();

            if (worker_dists_.size() < m) worker_dists_.resize(m);

            cur_query_    = query;
            cur_nodes_    = unvisited.data();
            cur_n_nodes_  = m;
            cur_dists_    = worker_dists_.data();

            size_t chunk = (m + N_THREADS - 1) / N_THREADS;
            for (int t = 0; t < N_THREADS; ++t) {
                shard_lo_[t] = (size_t)t * chunk;
                shard_hi_[t] = std::min((size_t)(t+1)*chunk, m);
            }

            dispatch_and_join();   

            for (size_t j = 0; j < m; ++j) {
                float d = worker_dists_[j];
                if (R.size() < ef || d < lb) {
                    C.emplace(d, unvisited[j]);
                    R.emplace(d, unvisited[j]);
                    if (R.size() > ef) R.pop();
                    if (!R.empty()) lb = R.top().first;
                }
            }
        }

        KNNResult result;
        while (!R.empty()) {
            auto top = R.top(); R.pop();
            result.emplace(top.first, index->getExternalLabel(top.second));
        }
        while (result.size() > k) result.pop();
        return result;
    }

private:
    const float* cur_query_   = nullptr;
    const tableint* cur_nodes_   = nullptr;
    size_t          cur_n_nodes_ = 0;
    float* cur_dists_   = nullptr;
    size_t          shard_lo_[N_THREADS];
    size_t          shard_hi_[N_THREADS];

    std::vector<float>    worker_dists_;  
    std::vector<uint16_t> visited_;
    uint16_t              visit_tag_ = 0;

    pthread_t         threads_[N_THREADS - 1];
    pthread_barrier_t bar_start_;
    pthread_barrier_t bar_end_;
    std::atomic<bool> stop_;

    struct WArg { HNSWSearchEdgeParallel* self; int tid; };
    WArg wargs_[N_THREADS];

    void init_pool() {
        pthread_barrier_init(&bar_start_, nullptr, N_THREADS);
        pthread_barrier_init(&bar_end_,   nullptr, N_THREADS);
        for (int t = 0; t < N_THREADS; ++t) wargs_[t] = {this, t};
        for (int t = 1; t < N_THREADS; ++t)
            pthread_create(&threads_[t-1], nullptr, worker, &wargs_[t]);
    }

    void stop_pool() {
        stop_.store(true, std::memory_order_release);
        pthread_barrier_wait(&bar_start_);
        for (int t = 1; t < N_THREADS; ++t) pthread_join(threads_[t-1], nullptr);
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
            compute_distances(tid);
            pthread_barrier_wait(&bar_end_);
        }
    }

    void dispatch_and_join() {
        pthread_barrier_wait(&bar_start_);
        compute_distances(0);     
        pthread_barrier_wait(&bar_end_);
    }

    void compute_distances(int tid) {
        auto dist_fn   = index->fstdistfunc_;
        auto dist_par  = index->dist_func_param_;
        const float* q = cur_query_;
        size_t lo      = shard_lo_[tid];
        size_t hi      = shard_hi_[tid];

        for (size_t j = lo; j < hi; ++j) {
            char* v = index->getDataByInternalId(cur_nodes_[j]);
            cur_dists_[j] = dist_fn(q, v, dist_par);
        }
    }
};

// ═════════════════════════════════════════════════════════════════════
// 变体 D: HNSWSearchPointPartition — 静态线程池 + 内部ID标准映射
// ═════════════════════════════════════════════════════════════════════
class HNSWSearchPointPartition {
public:
    static const int N_THREADS = 8; 
    HierarchicalNSW<float>* index;
    size_t total_num;         // Layer0 总向量数

    explicit HNSWSearchPointPartition(HierarchicalNSW<float>* idx) 
        : index(idx), stop_(false) 
    {
        total_num = index->cur_element_count;
        // 启动常驻工作线程池
        init_pool();
    }

    ~HNSWSearchPointPartition() {
        stop_pool();
    }

    
    KNNResult search(const float* query, size_t k, size_t ef) {
        (void)ef; 
        if (total_num == 0 || k == 0) return {};

        cur_query_ = query;
        cur_k_     = k;

        // 按内部 ID [0, total_num) 进行线程均分
        size_t chunk_size = total_num / N_THREADS;
        for (int t = 0; t < N_THREADS; ++t) {
            shard_lo_[t] = (size_t)t * chunk_size;
            shard_hi_[t] = (t == N_THREADS - 1) ? total_num : (size_t)(t + 1) * chunk_size;
            thread_heaps_[t] = KNNResult(); 
        }

        // 屏障放行，多线程并发全扫
        dispatch_and_join();

        // 归并 8 个线程的 Top-K
        return merge_results(thread_heaps_, k);
    }

private:

    const float* cur_query_ = nullptr;
    size_t       cur_k_     = 0;
    size_t       shard_lo_[N_THREADS];
    size_t       shard_hi_[N_THREADS];
    
    std::vector<KNNResult> thread_heaps_{N_THREADS};


    pthread_t         threads_[N_THREADS - 1];
    pthread_barrier_t bar_start_;
    pthread_barrier_t bar_end_;
    std::atomic<bool> stop_;

    struct WArg { HNSWSearchPointPartition* self; int tid; };
    WArg wargs_[N_THREADS];

    void init_pool() {
        pthread_barrier_init(&bar_start_, nullptr, N_THREADS);
        pthread_barrier_init(&bar_end_,   nullptr, N_THREADS);
        for (int t = 0; t < N_THREADS; ++t) wargs_[t] = {this, t};
        for (int t = 1; t < N_THREADS; ++t)
            pthread_create(&threads_[t-1], nullptr, worker, &wargs_[t]);
    }

    void stop_pool() {
        stop_.store(true, std::memory_order_release);
        pthread_barrier_wait(&bar_start_);
        for (int t = 1; t < N_THREADS; ++t) pthread_join(threads_[t-1], nullptr);
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
            execute_flat_scan(tid);
            pthread_barrier_wait(&bar_end_);
        }
    }

    void dispatch_and_join() {
        pthread_barrier_wait(&bar_start_);
        execute_flat_scan(0); // 主线程执行分片 0
        pthread_barrier_wait(&bar_end_);
    }

    void execute_flat_scan(int tid) {
        auto dist_fn  = index->fstdistfunc_;
        auto dist_par = index->dist_func_param_;
        
        size_t lo = shard_lo_[tid];
        size_t hi = shard_hi_[tid];
        size_t k  = cur_k_;
        const float* q = cur_query_;
        
        KNNResult& local_heap = thread_heaps_[tid];

        for (size_t i = lo; i < hi; ++i) {
            //对后续要解析的内部节点进行内存预取
            if (i + 4 < hi) {
                __builtin_prefetch(index->getDataByInternalId((tableint)(i + 4)), 0, 3);
            }

            char* vec_ptr = index->getDataByInternalId((tableint)i);

            //计算距离
            float dist = dist_fn(q, vec_ptr, dist_par);

            //压入最大堆
            if (local_heap.size() < k) {
                local_heap.emplace(dist, index->getExternalLabel((tableint)i));
            } else if (dist < local_heap.top().first) {
                local_heap.pop();
                local_heap.emplace(dist, index->getExternalLabel((tableint)i));
            }
        }
    }
};


private:
    KNNResult merge_results_internal(std::vector<KNNResult>& heaps, size_t k) {
        std::priority_queue<std::pair<float, labeltype>> merged;
        for (auto& h : heaps) {
            while (!h.empty()) {
                auto top = h.top(); h.pop();
                merged.push(top);
                if (merged.size() > k) merged.pop();
            }
        }
        return merged;
    }
};