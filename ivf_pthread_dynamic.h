#pragma once

#include <pthread.h>
#include <atomic>
#include "ivf_index_base.h"

class IVFPthreadDynamic : public IVFIndexBase {
public:
    struct TaskBlock {
        uint32_t cid;          // 所属簇
        uint32_t start;        // 在该簇列表中的起始向量下标
        uint32_t end;          // 结束下标
    };

    IVFPthreadDynamic()  : stop_(false) { init_pool(); }
    ~IVFPthreadDynamic() { stop_pool(); }

    //search :Pthread 静态线程池 + 动态任务抢占 + NEON SIMD 内积
    
    IVFHeap search(const float* query, size_t k,
                   size_t nprobe, size_t p = 0) {
        if (p < k) p = k;
        nprobe = std::min(nprobe, nlist);

        //粗排（主线程串行）
        std::vector<size_t> sel;
        coarse_select(query, nprobe, sel);

        // ── 构建 TaskBlock 数组 ────────────────────────────────────
        // 按簇顺序展平，每 IVF_TASK_BLOCK 个向量为一块
        task_blocks_.clear();
        for (size_t ci = 0; ci < nprobe; ++ci) {
            uint32_t cid   = (uint32_t)sel[ci];
            uint32_t n_vec = (uint32_t)inv_ids[cid].size();
            for (uint32_t off = 0; off < n_vec; off += IVF_TASK_BLOCK) {
                task_blocks_.push_back({
                    cid, off,
                    std::min(off + (uint32_t)IVF_TASK_BLOCK, n_vec)
                });
            }
        }
        task_counter_.store(0, std::memory_order_relaxed);

        // ── 设置本轮查询参数（子线程只读）──────────────────────────
        cur_query_ = query;
        cur_p_     = p;
        for (int t = 0; t < IVF_NTHREADS; ++t)
            local_heaps_[t].h = IVFHeap();   

        // ── 放行所有工作线程（含主线程 tid=0）──────────────────────
        dispatch_and_join();

        // ── Reduce：归并 8 个局部堆 → top-k ──────────────────────
        IVFHeap result;
        for (int t = 0; t < IVF_NTHREADS; ++t) {
            IVFHeap& lh = local_heaps_[t].h;
            while (!lh.empty()) {
                ivf_heap_push(result, lh.top().first, lh.top().second, k);
                lh.pop();
            }
        }
        return result;
    }

private:
    const float*            cur_query_ = nullptr;
    size_t                  cur_p_     = 0;
    std::vector<TaskBlock>  task_blocks_;
    std::atomic<size_t>     task_counter_;

    // 局部堆
    struct alignas(64) AlignedHeap { IVFHeap h; };
    AlignedHeap local_heaps_[IVF_NTHREADS];

    //线程池 
    pthread_t         threads_[IVF_NTHREADS - 1];
    pthread_barrier_t bar_start_;
    pthread_barrier_t bar_end_;
    std::atomic<bool> stop_;

    struct WArg { IVFPthreadDynamic* self; int tid; };
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
        for (int t = 1; t < IVF_NTHREADS; ++t) pthread_join(threads_[t-1], nullptr);
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
            run_dynamic(tid);
            pthread_barrier_wait(&bar_end_);
        }
    }

    void dispatch_and_join() {
        pthread_barrier_wait(&bar_start_);
        run_dynamic(0);                   
        pthread_barrier_wait(&bar_end_);
    }

    // 动态无锁抢占任务块 
    void run_dynamic(int tid) {
        IVFHeap& local     = local_heaps_[tid].h;
        const float* query = cur_query_;
        size_t p           = cur_p_;
        size_t n_tasks     = task_blocks_.size();

        while (true) {
            // 无锁原子递增：每次抢占一个 TaskBlock（256 个向量）
            size_t idx = task_counter_.fetch_add(1, std::memory_order_relaxed);
            if (idx >= n_tasks) break;

            const TaskBlock& tb = task_blocks_[idx];
            const float* vecs   = inv_vecs[tb.cid].data() + tb.start * dim;
            uint32_t n_vec      = tb.end - tb.start;

            __builtin_prefetch(vecs, 0, 3);

            for (uint32_t j = 0; j < n_vec; ++j) {
                if (j + 8 < n_vec)
                    __builtin_prefetch(vecs + (j+8)*dim, 0, 2);

                float dist = InnerProductSIMD(vecs + j*dim, query, dim);
                ivf_heap_push(local, dist, inv_ids[tb.cid][tb.start + j], p);
            }
        }
    }
};