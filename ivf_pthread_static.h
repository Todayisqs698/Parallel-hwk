#pragma once

#include <pthread.h>
#include <atomic>
#include <vector>
#include <queue>
#include <algorithm>
#include "ivf_index_base.h"
#include "simd_utils.h" 

class IVFPthreadStatic : public IVFIndexBase {
private:
    // 线程池共享的内部状态
    enum Stage { STAGE_IDLE, STAGE_CENTER, STAGE_SCAN, STAGE_EXIT };
    
    // 用 64 字节对齐来打包线程私有局部堆
    struct alignas(64) AlignedHeap { 
        IVFHeap h; 
    };

    // 定义粗排距离和 ID 的配对
    using DistIdx = std::pair<float, size_t>;

public:
    IVFPthreadStatic() : stop_(false), stage_(STAGE_IDLE) { 
        init_pool(); 
    }
    
    ~IVFPthreadStatic() { 
        stop_pool(); 
    }

    //search 
    
    IVFHeap search(const float* query, size_t k, size_t nprobe, size_t p = 0) {
        if (p < k) p = k;
        nprobe = std::min(nprobe, nlist);

        cur_query_ = query;
        cur_p_     = p;
        cur_k_     = k;
        real_probe_= nprobe;

        // 初始化各线程的局部堆
        for (int t = 0; t < IVF_NTHREADS; ++t) {
            local_heaps_[t].h = IVFHeap();
        }

        //聚类中心粗排并行化
        cent_dists_.resize(nlist);
        stage_ = STAGE_CENTER;
        
        // 所有子线程共同计算 1024 个聚类中心
        pthread_barrier_wait(&bar_start_); 
        run_center(0);                     
        pthread_barrier_wait(&bar_end_);  
        // 串行部分：主线程负责对粗排结果做部分排序，选出前 nprobe 个候选簇
        std::partial_sort(cent_dists_.begin(), cent_dists_.begin() + nprobe, cent_dists_.end());

        //倒排表精排零拷贝并行扫描
        stage_ = STAGE_SCAN;
        
        // 所有子线程共同切分 nprobe 个倒排列表进行精排
        pthread_barrier_wait(&bar_start_);
        run_scan(0);                       
        pthread_barrier_wait(&bar_end_);   

        //全局 Reduce 合并
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

    const float* cur_query_ = nullptr;
    size_t       cur_p_     = 0;
    size_t       cur_k_     = 0;
    size_t       real_probe_= 0;

    // 粗排中间结果存储
    std::vector<DistIdx> cent_dists_;

    // 独立线程对齐局部堆
    AlignedHeap local_heaps_[IVF_NTHREADS];

    // Pthread 线程池与同步栅栏
    pthread_t          threads_[IVF_NTHREADS - 1];
    pthread_barrier_t  bar_start_;
    pthread_barrier_t  bar_end_;
    std::atomic<bool>  stop_;
    std::atomic<Stage> stage_;

    struct WArg { IVFPthreadStatic* self; int tid; };
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
        stage_ = STAGE_EXIT;
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

    // 子线程常驻事件循环
    void thread_loop(int tid) {
        while (true) {
            pthread_barrier_wait(&bar_start_); 
            
            Stage cur_stage = stage_.load(std::memory_order_acquire);
            if (cur_stage == STAGE_EXIT || stop_.load(std::memory_order_acquire)) break;

            if (cur_stage == STAGE_CENTER) {
                run_center(tid);
            } else if (cur_stage == STAGE_SCAN) {
                run_scan(tid);
            }

            pthread_barrier_wait(&bar_end_); 
        }
    }

    //粗排执行体：8核按 chunk 均分 1024 个聚类中心
    void run_center(int tid) {
        size_t chunk = (nlist + IVF_NTHREADS - 1) / IVF_NTHREADS;
        size_t st = (size_t)tid * chunk;
        size_t ed = std::min(st + chunk, nlist);

        const float* query = cur_query_;
        for (size_t cid = st; cid < ed; ++cid) {
            const float* cv = centroids.data() + cid * dim;
            float dist = InnerProductSIMD(query, cv, dim);
            cent_dists_[cid] = {dist, cid};
        }
    }

    //精排执行体：零拷贝直接寻址 
    
    void run_scan(int tid) {
        // 按照选出的倒排列表数量进行静态均分
        size_t chunk = (real_probe_ + IVF_NTHREADS - 1) / IVF_NTHREADS;
        size_t rs = (size_t)tid * chunk;
        size_t re = std::min(rs + chunk, real_probe_);

        IVFHeap& local = local_heaps_[tid].h;
        const float* query = cur_query_;
        size_t p = cur_p_;

        for (size_t r = rs; r < re; ++r) {
            size_t lid = cent_dists_[r].second;
            
            size_t n_vec = inv_ids[lid].size();
            const float* vecs_base = inv_vecs[lid].data();
            const uint32_t* ids_base = inv_ids[lid].data();

            for (size_t j = 0; j < n_vec; ++j) {
                const float* v = vecs_base + j * dim;
            
                if (j + 2 < n_vec) {
                    __builtin_prefetch(vecs_base + (j + 2) * dim, 0, 3);
                }
                float dist = InnerProductSIMD(v, query, dim);
                ivf_heap_push(local, dist, ids_base[j], p);
            }
        }
    }
};