#pragma once
/**
 * multi_hnsw_mpi.h  —  分布式 Multi-HNSW：多进程独立子图并行检索
 * =====================================================================
 * 对应任务 C：分布式 multi-HNSW 头文件
 *
 * 与 hnsw_mpi.h 的核心区别：
 *   hnsw_mpi.h       — 每进程 1 个 HNSW 子图（单分片 HNSW）
 *   multi_hnsw_mpi.h — 每进程 S 个 HNSW 子图（多分片 HNSW）
 *
 * 多子图设计动机（来自 Lab4 §4.2 "HNSW-on-HNSW" 思路延伸）：
 *   1. 将本进程的 local_n 条向量再按 S 份子集划分，每份独立建一个 HNSW；
 *   2. 查询时先用一个轻量级路由图（导航 HNSW）确定最近的 S' 个子图，
 *      再对选中子图做精细 HNSW 路由；
 *   3. 多子图结构降低了单图规模（O(N/P/S) 节点），图路由更快；
 *   4. 跨子图并行（OpenMP）进一步提升单进程吞吐量。
 *
 * 三级并行层次：
 *   Level 1 (MPI)    : P 个进程各负责 N/P 条向量，独立运行
 *   Level 2 (OpenMP) : 每进程 S 个子图，omp parallel for 并行搜索
 *   Level 3 (SIMD)   : hnswlib 内部 InnerProductSpace 距离计算
 *
 * 数据划分结构（P=4 进程，S=2 子图为例）：
 *   全量 N 向量
 *   ├── Rank 0: N/4 向量
 *   │   ├── SubGraph 0: N/8 向量
 *   │   └── SubGraph 1: N/8 向量
 *   ├── Rank 1: N/4 向量
 *   │   ├── SubGraph 0: N/8 向量
 *   │   └── SubGraph 1: N/8 向量
 *   ...
 *
 * 查询流程：
 *   Rank r:
 *     1. MPI_Bcast 接收查询向量
 *     2. 粗排：导航 HNSW（nav_hnsw）快速定位本进程最近的 nsubprobe 个子图
 *     3. 精排：OpenMP 并行在 nsubprobe 个子图上各做 HNSW 路由
 *     4. 线程 Reduce → 进程级 top-p 堆
 *     5. MPI_Gatherv → 0 号进程全局归并
 *
 * 通信原语：
 *   MPI_Scatterv — 分发本地向量数据（建索引，一次性）
 *   MPI_Bcast    — 广播查询（每次查询）
 *   MPI_Gather   — 收集结果数量
 *   MPI_Gatherv  — 收集 (dist, id) 对
 * =====================================================================
 */

#include <mpi.h>
#include <omp.h>
#include <vector>
#include <queue>
#include <cstring>
#include <limits>
#include <random>
#include <iostream>
#include <algorithm>
#include <cassert>
#include "hnswlib/hnswlib/hnswlib.h"
#include "simd_utils.h"

using namespace hnswlib;

// ─────────────────────────────────────────────────────────────────────
// 堆工具
// ─────────────────────────────────────────────────────────────────────
using MultiHNSWPair = std::pair<float, uint32_t>;
using MultiHNSWHeap = std::priority_queue<MultiHNSWPair>;

static inline void multi_hnsw_heap_push(MultiHNSWHeap& h, float d,
                                          uint32_t id, size_t p) {
    if (h.size() < p)             h.emplace(d, id);
    else if (d < h.top().first) { h.pop(); h.emplace(d, id); }
}

// 缓存行对齐的线程私有堆（消除伪共享）
struct alignas(64) AlignedMultiHeap {
    MultiHNSWHeap h;
};

// ─────────────────────────────────────────────────────────────────────
// NEON L2 距离（用于导航 HNSW 粗排）
// ─────────────────────────────────────────────────────────────────────
static inline float multi_hnsw_l2sq(const float* a, const float* b,
                                     size_t dim) {
    float s = 0.f;
    size_t i = 0;
#if defined(__ARM_NEON) || defined(__ARM_NEON__)
    #include <arm_neon.h>
    float32x4_t acc0 = vdupq_n_f32(0.f);
    float32x4_t acc1 = vdupq_n_f32(0.f);
    for (; i + 8 <= dim; i += 8) {
        float32x4_t d0 = vsubq_f32(vld1q_f32(a+i),   vld1q_f32(b+i));
        float32x4_t d1 = vsubq_f32(vld1q_f32(a+i+4), vld1q_f32(b+i+4));
        acc0 = vfmaq_f32(acc0, d0, d0);
        acc1 = vfmaq_f32(acc1, d1, d1);
    }
    for (; i + 4 <= dim; i += 4) {
        float32x4_t d = vsubq_f32(vld1q_f32(a+i), vld1q_f32(b+i));
        acc0 = vfmaq_f32(acc0, d, d);
    }
    s = vaddvq_f32(vaddq_f32(acc0, acc1));
#endif
    for (; i < dim; ++i) { float d = a[i]-b[i]; s += d*d; }
    return s;
}

// ─────────────────────────────────────────────────────────────────────
// 每个子图的元数据封装
// ─────────────────────────────────────────────────────────────────────
struct SubGraph {
    InnerProductSpace*      space    = nullptr;
    HierarchicalNSW<float>* hnsw     = nullptr;
    std::vector<uint32_t>   id_map;    // local_label → global_id
    float                   centroid[0];  // 柔性数组（不直接用，用 centroid_vec）

    SubGraph() = default;
    ~SubGraph() { delete hnsw; delete space; }

    // 不可复制
    SubGraph(const SubGraph&)            = delete;
    SubGraph& operator=(const SubGraph&) = delete;
    SubGraph(SubGraph&&) noexcept        = default;
};

// ═════════════════════════════════════════════════════════════════════
// MultiHNSWMPI — 多子图 HNSW + MPI 分布式检索类
// ═════════════════════════════════════════════════════════════════════
class MultiHNSWMPI {
public:
    MultiHNSWMPI() : rank_(0), size_(1), dim_(0),
                     local_n_(0), local_start_(0),
                     n_subgraphs_(1),
                     nav_space_(nullptr), nav_hnsw_(nullptr),
                     local_base_(nullptr) {
        MPI_Comm_rank(MPI_COMM_WORLD, &rank_);
        MPI_Comm_size(MPI_COMM_WORLD, &size_);
    }

    ~MultiHNSWMPI() {
        subgraphs_.clear();   // ~SubGraph 会 delete hnsw/space
        delete nav_hnsw_;
        delete nav_space_;
        delete[] local_base_;
    }

    // ─────────────────────────────────────────────────────────────────
    // build_distributed
    //
    //   参数：
    //     base           : 全量数据（0 号进程有效）
    //     n, d           : 全量向量数、维度
    //     n_subgraphs    : 每进程的子图数量 S（建议 2~8）
    //     M              : HNSW 每节点最大邻居数
    //     ef_construction: 建图候选队列大小
    //     nav_M          : 导航 HNSW 的 M（可以小，如 8）
    //
    //   流程：
    //     1. 0 号进程 Scatterv 分发数据
    //     2. 各进程将 local_n 条向量随机打散，均分为 S 个子集
    //     3. 各进程为 S 个子集并行构建 S 个 HNSW 子图
    //     4. 各进程构建一个轻量级导航 HNSW（以子图质心为节点）
    // ─────────────────────────────────────────────────────────────────
    void build_distributed(const float* base, size_t n, size_t d,
                            size_t n_subgraphs  = 2,
                            int    M            = 16,
                            int    ef_construction = 150,
                            int    nav_M        = 8) {
        dim_         = d;
        n_subgraphs_ = std::max(n_subgraphs, (size_t)1);

        // 广播元信息
        size_t global_n = n;
        MPI_Bcast(&global_n,    1, MPI_UNSIGNED_LONG_LONG, 0, MPI_COMM_WORLD);
        MPI_Bcast(&dim_,         1, MPI_UNSIGNED_LONG_LONG, 0, MPI_COMM_WORLD);
        MPI_Bcast(&n_subgraphs_, 1, MPI_UNSIGNED_LONG_LONG, 0, MPI_COMM_WORLD);

        // 均匀块划分
        size_t chunk = (global_n + size_ - 1) / size_;
        local_start_ = (size_t)rank_ * chunk;
        size_t local_end = std::min(local_start_ + chunk, global_n);
        local_n_ = local_end - local_start_;

        assert(local_n_ >= n_subgraphs_ &&
               "local_n must be >= n_subgraphs; reduce S or P");

        // 分发向量
        local_base_ = new float[local_n_ * dim_];
        std::vector<int> sendcounts(size_), displs(size_);
        if (rank_ == 0) {
            for (int r = 0; r < size_; ++r) {
                size_t rs = (size_t)r * chunk;
                size_t re = std::min(rs + chunk, global_n);
                sendcounts[r] = (int)((re - rs) * dim_);
                displs[r]     = (int)(rs * dim_);
            }
        }
        MPI_Scatterv(base, sendcounts.data(), displs.data(), MPI_FLOAT,
                     local_base_, (int)(local_n_ * dim_), MPI_FLOAT,
                     0, MPI_COMM_WORLD);

        if (rank_ == 0)
            std::cout << "[Multi-HNSW-MPI] global_n=" << global_n
                      << "  P=" << size_ << "  S=" << n_subgraphs_
                      << "  M=" << M << "  efC=" << ef_construction
                      << std::endl;

        // ── 将 local_n 条向量均分为 S 个子集 ───────────────────────
        // 使用循环分配（round-robin）而不是连续块，减少相关向量集中在同一子图的概率
        std::vector<std::vector<uint32_t>> subsets(n_subgraphs_);
        for (size_t i = 0; i < local_n_; ++i)
            subsets[i % n_subgraphs_].push_back((uint32_t)i);

        // ── 并行构建 S 个子图 ─────────────────────────────────────
        subgraphs_.resize(n_subgraphs_);
        sub_centroids_.resize(n_subgraphs_ * dim_, 0.f);

        #pragma omp parallel for schedule(dynamic, 1)
        for (int s = 0; s < (int)n_subgraphs_; ++s) {
            const std::vector<uint32_t>& subset = subsets[s];
            size_t sz = subset.size();

            subgraphs_[s].space = new InnerProductSpace(dim_);
            subgraphs_[s].hnsw  = new HierarchicalNSW<float>(
                subgraphs_[s].space, sz, M, ef_construction);
            subgraphs_[s].id_map.resize(sz);

            // 添加向量到子图
            for (size_t j = 0; j < sz; ++j) {
                uint32_t local_idx = subset[j];
                const float* v = local_base_ + (size_t)local_idx * dim_;
                subgraphs_[s].hnsw->addPoint(v, (labeltype)j);
                // local_label j → local_idx → global_id = local_start_ + local_idx
                subgraphs_[s].id_map[j] = (uint32_t)(local_start_ + local_idx);
            }

            // 计算子图质心（用于导航 HNSW）
            float* centroid = sub_centroids_.data() + s * dim_;
            for (size_t j = 0; j < sz; ++j) {
                const float* v = local_base_ + (size_t)subset[j] * dim_;
                for (size_t di = 0; di < dim_; ++di)
                    centroid[di] += v[di];
            }
            float inv_sz = 1.f / (float)sz;
            for (size_t di = 0; di < dim_; ++di)
                centroid[di] *= inv_sz;

            #pragma omp critical
            std::cout << "[Multi-HNSW-MPI Rank " << rank_
                      << "] SubGraph[" << s << "] built: " << sz
                      << " nodes" << std::endl;
        }

        // ── 构建导航 HNSW（以 S 个子图质心为节点）────────────────
        // 导航 HNSW 节点数 = n_subgraphs_（非常小），路由极快
        nav_space_ = new InnerProductSpace(dim_);
        nav_hnsw_  = new HierarchicalNSW<float>(
            nav_space_, n_subgraphs_, nav_M, 200);

        for (size_t s = 0; s < n_subgraphs_; ++s)
            nav_hnsw_->addPoint(sub_centroids_.data() + s * dim_,
                                 (labeltype)s);

        std::cout << "[Multi-HNSW-MPI Rank " << rank_
                  << "] Navigation HNSW built (" << n_subgraphs_
                  << " centroids)" << std::endl;
    }

    // ─────────────────────────────────────────────────────────────────
    // search — Multi-HNSW + MPI 分布式检索
    //
    //   参数：
    //     k          : 返回 top-k
    //     ef_search  : 各子图 HNSW 搜索的 ef
    //     nsubprobe  : 本进程内搜索的子图数（<= n_subgraphs_）
    //     local_p    : 进程级局部堆大小（>= k）
    //
    //   流程：
    //     [导航] nav_hnsw_.searchKnn(q, nsubprobe) → 选出最近 nsubprobe 个子图
    //     [精排] OpenMP 并行在 nsubprobe 个子图中 HNSW 路由
    //     [Reduce] 各线程局部堆归并 → 进程级堆
    //     [MPI]   Gatherv → 0 号进程全局归并 top-k
    // ─────────────────────────────────────────────────────────────────
    MultiHNSWHeap search(const float* query, size_t k,
                          size_t ef_search = 0,
                          size_t nsubprobe = 0,
                          size_t local_p   = 0) {
        if (ef_search < k * 2) ef_search = k * 2;
        if (nsubprobe == 0 || nsubprobe > n_subgraphs_)
            nsubprobe = n_subgraphs_;
        if (local_p < k) local_p = k;

        // Bcast 查询
        std::vector<float> q_buf(dim_);
        if (rank_ == 0)
            std::memcpy(q_buf.data(), query, dim_ * sizeof(float));
        MPI_Bcast(q_buf.data(), (int)dim_, MPI_FLOAT, 0, MPI_COMM_WORLD);

        // 导航：从 S 个子图质心中选出最近的 nsubprobe 个
        nav_hnsw_->setEf(std::max(nsubprobe * 2, nsubprobe + 4));
        auto nav_res = nav_hnsw_->searchKnn(q_buf.data(), nsubprobe);

        std::vector<size_t> probe_ids;
        probe_ids.reserve(nsubprobe);
        while (!nav_res.empty()) {
            probe_ids.push_back((size_t)nav_res.top().second);
            nav_res.pop();
        }
        // nav 返回大顶堆（最远在顶），已全部取出，顺序无关紧要

        // OpenMP 并行搜索选中的子图
        int n_threads = omp_get_max_threads();
        std::vector<AlignedMultiHeap> thread_heaps((size_t)n_threads);

        int n_probes = (int)probe_ids.size();

        #pragma omp parallel for schedule(dynamic, 1) num_threads(n_threads)
        for (int pi = 0; pi < n_probes; ++pi) {
            size_t s  = probe_ids[pi];
            int    tid = omp_get_thread_num();

            if (!subgraphs_[s].hnsw ||
                subgraphs_[s].hnsw->cur_element_count == 0) continue;

            subgraphs_[s].hnsw->setEf(ef_search);
            auto local_res = subgraphs_[s].hnsw->searchKnn(
                q_buf.data(), local_p);

            MultiHNSWHeap& lh = thread_heaps[tid].h;
            const auto& id_map = subgraphs_[s].id_map;

            while (!local_res.empty()) {
                auto top = local_res.top(); local_res.pop();
                if ((size_t)top.second >= id_map.size()) continue;
                uint32_t gid = id_map[top.second];
                multi_hnsw_heap_push(lh, top.first, gid, local_p);
            }
        }

        // 线程 Reduce → 进程级堆
        MultiHNSWHeap proc_heap;
        for (int t = 0; t < n_threads; ++t) {
            MultiHNSWHeap& lh = thread_heaps[t].h;
            while (!lh.empty()) {
                multi_hnsw_heap_push(proc_heap, lh.top().first,
                                      lh.top().second, local_p);
                lh.pop();
            }
        }
        while (proc_heap.size() > k) proc_heap.pop();

        // 序列化
        int local_count = (int)proc_heap.size();
        std::vector<float>    ld(local_count);
        std::vector<uint32_t> li(local_count);
        for (int i = local_count - 1; i >= 0; --i) {
            ld[i] = proc_heap.top().first;
            li[i] = proc_heap.top().second;
            proc_heap.pop();
        }

        return gather_and_merge_(ld, li, local_count, k);
    }

    // ─────────────────────────────────────────────────────────────────
    // search_exhaustive — 搜索本进程全部子图（召回最大化，对比基准）
    //   不使用导航 HNSW，强制 nsubprobe = n_subgraphs_
    //   适合评估 Multi-HNSW 召回上界（等价于单图 EF 足够大时的效果）
    // ─────────────────────────────────────────────────────────────────
    MultiHNSWHeap search_exhaustive(const float* query, size_t k,
                                     size_t ef_search = 0,
                                     size_t local_p   = 0) {
        return search(query, k, ef_search, n_subgraphs_, local_p);
    }

    // ─────────────────────────────────────────────────────────────────
    // search_two_stage — 两阶段 HNSW-on-HNSW 检索（Lab4 §4.2 核心思路）
    //
    //   Stage 1: 所有进程广播 query，粗选进程级最近 P' 个子图
    //            （使用精确 L2 距离扫描所有 n_subgraphs_ 个质心）
    //   Stage 2: 在选中子图上 OpenMP 精细 HNSW 路由
    //   阶段分离使粗选精度可控，不依赖导航 HNSW 的图质量
    // ─────────────────────────────────────────────────────────────────
    MultiHNSWHeap search_two_stage(const float* query, size_t k,
                                    size_t ef_search = 0,
                                    size_t nsubprobe = 0,
                                    size_t local_p   = 0) {
        if (ef_search < k * 2) ef_search = k * 2;
        if (nsubprobe == 0 || nsubprobe > n_subgraphs_)
            nsubprobe = n_subgraphs_;
        if (local_p < k) local_p = k;

        std::vector<float> q_buf(dim_);
        if (rank_ == 0)
            std::memcpy(q_buf.data(), query, dim_ * sizeof(float));
        MPI_Bcast(q_buf.data(), (int)dim_, MPI_FLOAT, 0, MPI_COMM_WORLD);

        // Stage 1: L2 精确粗选最近 nsubprobe 个子图质心
        std::vector<std::pair<float, size_t>> coarse(n_subgraphs_);
        for (size_t s = 0; s < n_subgraphs_; ++s) {
            float d2 = multi_hnsw_l2sq(q_buf.data(),
                                        sub_centroids_.data() + s * dim_,
                                        dim_);
            coarse[s] = {d2, s};
        }
        if (nsubprobe < n_subgraphs_)
            std::partial_sort(coarse.begin(),
                              coarse.begin() + nsubprobe, coarse.end());

        // Stage 2: OpenMP 精细搜索
        int n_threads = omp_get_max_threads();
        std::vector<AlignedMultiHeap> thread_heaps((size_t)n_threads);

        #pragma omp parallel for schedule(dynamic, 1) num_threads(n_threads)
        for (int pi = 0; pi < (int)nsubprobe; ++pi) {
            size_t s   = coarse[pi].second;
            int    tid = omp_get_thread_num();

            if (!subgraphs_[s].hnsw ||
                subgraphs_[s].hnsw->cur_element_count == 0) continue;

            subgraphs_[s].hnsw->setEf(ef_search);
            auto local_res = subgraphs_[s].hnsw->searchKnn(
                q_buf.data(), local_p);

            MultiHNSWHeap& lh = thread_heaps[tid].h;
            const auto& id_map = subgraphs_[s].id_map;

            while (!local_res.empty()) {
                auto top = local_res.top(); local_res.pop();
                if ((size_t)top.second >= id_map.size()) continue;
                uint32_t gid = id_map[top.second];
                multi_hnsw_heap_push(lh, top.first, gid, local_p);
            }
        }

        // Reduce → 进程级堆
        MultiHNSWHeap proc_heap;
        for (int t = 0; t < n_threads; ++t) {
            MultiHNSWHeap& lh = thread_heaps[t].h;
            while (!lh.empty()) {
                multi_hnsw_heap_push(proc_heap, lh.top().first,
                                      lh.top().second, local_p);
                lh.pop();
            }
        }
        while (proc_heap.size() > k) proc_heap.pop();

        int local_count = (int)proc_heap.size();
        std::vector<float>    ld(local_count);
        std::vector<uint32_t> li(local_count);
        for (int i = local_count - 1; i >= 0; --i) {
            ld[i] = proc_heap.top().first;
            li[i] = proc_heap.top().second;
            proc_heap.pop();
        }

        return gather_and_merge_(ld, li, local_count, k);
    }

    int    rank()        const { return rank_; }
    int    mpi_size()    const { return size_; }
    size_t n_subgraphs() const { return n_subgraphs_; }
    size_t local_n()     const { return local_n_; }

private:
    MultiHNSWHeap gather_and_merge_(
        const std::vector<float>&    ld,
        const std::vector<uint32_t>& li,
        int local_count, size_t k) const
    {
        std::vector<int> all_counts(size_);
        MPI_Gather(&local_count, 1, MPI_INT,
                   all_counts.data(), 1, MPI_INT, 0, MPI_COMM_WORLD);

        std::vector<float>    all_dists;
        std::vector<uint32_t> all_ids;
        std::vector<int>      displs(size_, 0);

        if (rank_ == 0) {
            int total = 0;
            for (int r = 0; r < size_; ++r) {
                displs[r] = total;
                total += all_counts[r];
            }
            all_dists.resize(total);
            all_ids.resize(total);
        }

        MPI_Gatherv(ld.data(), local_count, MPI_FLOAT,
                    all_dists.data(), all_counts.data(), displs.data(),
                    MPI_FLOAT, 0, MPI_COMM_WORLD);
        MPI_Gatherv(li.data(), local_count, MPI_UINT32_T,
                    all_ids.data(), all_counts.data(), displs.data(),
                    MPI_UINT32_T, 0, MPI_COMM_WORLD);

        MultiHNSWHeap result;
        if (rank_ == 0)
            for (int i = 0; i < (int)all_dists.size(); ++i)
                multi_hnsw_heap_push(result, all_dists[i], all_ids[i], k);
        return result;
    }

    int    rank_, size_;
    size_t dim_, local_n_, local_start_;
    size_t n_subgraphs_;

    float*  local_base_;

    // 每进程 S 个子图（在堆上，通过 unique_ptr 隐式管理生命周期）
    std::vector<SubGraph>  subgraphs_;
    std::vector<float>     sub_centroids_;  // [n_subgraphs × dim]

    // 导航 HNSW（以 S 个子图质心为节点，极小的图，路由极快）
    InnerProductSpace*      nav_space_;
    HierarchicalNSW<float>* nav_hnsw_;
};
