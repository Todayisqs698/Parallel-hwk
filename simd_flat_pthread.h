#pragma once
#include <vector>
#include <queue>
#include <algorithm>
#include <pthread.h>
#include <cstring>
#include <cassert>
#include <atomic>
#include <iostream>
#include "simd_utils.h"  

static constexpr int NUM_THREADS = 8;   // 1 主线程 + 7 子线程，对应 8 核

// 局部 top-p 堆操作（最大堆，堆顶是当前候选中最差的）
using HeapPair = std::pair<float, uint32_t>;   
using MaxHeap  = std::priority_queue<HeapPair>;

inline void heap_push_bounded(MaxHeap& h, float dist, uint32_t id, size_t p) {
    if (h.size() < p) {
        h.emplace(dist, id);
    } else if (dist < h.top().first) {
        h.pop();
        h.emplace(dist, id);
    }
}

// 合并多个局部 top-p 堆 → 全局 top-k
inline MaxHeap reduce_heaps(std::vector<MaxHeap>& locals, size_t k) {
    MaxHeap global;
    for (auto& lh : locals) {
        while (!lh.empty()) {
            heap_push_bounded(global, lh.top().first, lh.top().second, k);
            lh.pop();
        }
    }
    return global;
}

//  静态线程池类
class FlatSearchPool {
public:
    struct alignas(64) TaskDesc {
        const float* query;
        size_t       p;
    };

    FlatSearchPool(const float* base, size_t base_number, size_t vecdim)
        : base_(base), base_number_(base_number), vecdim_(vecdim), stop_(false)
    {
        local_heaps_.resize(NUM_THREADS);
        
        // 初始化屏障：需要等齐 NUM_THREADS 个线程
        pthread_barrier_init(&barrier_start_, nullptr, NUM_THREADS);
        pthread_barrier_init(&barrier_end_,   nullptr, NUM_THREADS);

        // 创建 NUM_THREADS - 1 个子线程
        for (int t = 1; t < NUM_THREADS; ++t) {
            worker_tids_.push_back(t);
            pthread_create(&worker_threads_[t - 1], nullptr, pool_worker, this);
        }
    }

    ~FlatSearchPool() {
        stop_ = true;
        // 激活所有子线程让其检测到 stop_ 信号并退出
        pthread_barrier_wait(&barrier_start_);
        for (int t = 1; t < NUM_THREADS; ++t) {
            pthread_join(worker_threads_[t - 1], nullptr);
        }
        pthread_barrier_destroy(&barrier_start_);
        pthread_barrier_destroy(&barrier_end_);
    }

    
    MaxHeap search(const float* query, size_t k, size_t p = 0) {
        if (p == 0 || p < k) p = k;

        // 1. 重置清空上一次的局部堆
        for (int t = 0; t < NUM_THREADS; ++t) {
            local_heaps_[t] = MaxHeap();
        }
        
        // 2. 写入当前全局任务
        task_.query = query;
        task_.p     = p;

        // 3. 释放栅栏，唤醒所有子线程开始跑 shard 计算
        pthread_barrier_wait(&barrier_start_);

        // 4. 主线程（tid = 0）不闲置，同步参与切片计算
        run_shard(0);

        // 5. 等待所有 8 个核心全部收工
        pthread_barrier_wait(&barrier_end_);

        
        return reduce_heaps(local_heaps_, k);
    }

private:
    const float* base_;
    size_t                 base_number_;
    size_t                 vecdim_;
    std::atomic<bool>      stop_;
    TaskDesc               task_;
    
    
    std::vector<MaxHeap>   local_heaps_; 
    
    pthread_barrier_t      barrier_start_;
    pthread_barrier_t      barrier_end_;
    pthread_t              worker_threads_[NUM_THREADS - 1];
    std::vector<int>       worker_tids_;

    
    void run_shard(int tid) {
        MaxHeap& heap      = local_heaps_[tid];
        const size_t p     = task_.p;
        const float* q     = task_.query;
        const float* base  = base_;
        const size_t dim   = vecdim_;
        const size_t total = base_number_;

        
        for (size_t i = (size_t)tid; i < total; i += NUM_THREADS) {
            if (i + NUM_THREADS * 2 < total) {
                __builtin_prefetch(base + (i + NUM_THREADS * 2) * dim, 0, 3);
            }

            float dist = InnerProductSIMD(base + i * dim, q, dim);
            heap_push_bounded(heap, dist, (uint32_t)i, p);
        }
    }

    static void* pool_worker(void* arg) {
        auto* pool = reinterpret_cast<FlatSearchPool*>(arg);
        int tid = 0;
        pthread_t self = pthread_self();
        for (size_t t = 0; t < pool->worker_tids_.size(); ++t) {
            if (pthread_equal(pool->worker_threads_[t], self)) {
                tid = pool->worker_tids_[t];
                break;
            }
        }

        while (true) {
            // 等待主线程分发新 Query 的启动指令
            pthread_barrier_wait(&pool->barrier_start_);
            
            if (pool->stop_) break;

            // 执行自己负责的那部分向量内积流水线
            pool->run_shard(tid);

            // 报告完成，等待进入下一个循环
            pthread_barrier_wait(&pool->barrier_end_);
        }
        return nullptr;
    }
};