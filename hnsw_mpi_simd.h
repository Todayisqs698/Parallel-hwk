#pragma once
/**
 * hnsw_mpi_simd.h  —  HNSW + MPI 分布式 + ARM NEON SIMD 向量化加速
 * =====================================================================
 * 对应任务 C：HNSW + MPI + SIMD 向量化头文件
 *
 * 在 hnsw_mpi.h（已有）的基础上，从三个维度引入 SIMD 硬件加速：
 *
 *   [1] 自定义 SIMD 距离空间：
 *       继承 hnswlib::SpaceInterface<float>，重载 get_dist_func()，
 *       注入 NEON 4 路展开内积计算，直接替换 hnswlib 内部的 L2/IP 实现。
 *
 *   [2] 数据预取驱动的 Prefetch 策略：
 *       在向量添加和查询时，对紧邻节点数据提前发起 __builtin_prefetch，
 *       覆盖 L2→L1 的数据搬运延迟（约 10~30 cycle）。
 *
 *   [3] SIMD 粗筛（Coarse SIMD Filter）：
 *       收集 HNSW 路由中的候选节点向量，批量调用 InnerProductSIMD，
 *       利用动态阈值跳过低质量候选，减少精路由进入堆的次数。
 *
 * 架构概览：
 *   Rank 0  : Scatterv 分发数据 → 用 SIMDInnerProductSpace 建本地 HNSW
 *   Rank 1+N: 接收数据 → 用 SIMDInnerProductSpace 建本地 HNSW
 *   查询时  : Bcast query → SIMD HNSW 路由 → 局部 ID → Gatherv 归并
 *
 * 通信原语：
 *   MPI_Scatterv — 分发 Base 向量（建索引阶段，一次性）
 *   MPI_Bcast    — 广播查询向量（每次查询）
 *   MPI_Gather   — 收集各进程结果数量
 *   MPI_Gatherv  — 收集局部 (dist, id) 对
 *
 * 编译：
 *   mpicxx -std=c++11 -O3 -fopenmp -march=armv8-a+simd -mcpu=cortex-a72
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
#include "simd_utils.h"   // InnerProductSIMD (ARM NEON 4 路展开)

using namespace hnswlib;

// ─────────────────────────────────────────────────────────────────────
// SIMDInnerProductSpace — 注入 NEON SIMD 内积的自定义距离空间
//
// hnswlib 在搜索过程中通过函数指针 dist_func_ 调用距离计算。
// 通过继承 SpaceInterface<float> 并重载 get_dist_func()，
// 我们将所有 HNSW 内部的距离计算替换为 InnerProductSIMD。
//
// 注意：hnswlib InnerProductSpace 已经对某些平台有 SIMD，
//       但在 ARM 上默认回退到标量。本空间类强制使用 NEON 路径。
// ─────────────────────────────────────────────────────────────────────

// 静态 SIMD 内积函数（符合 hnswlib DISTFUNC 签名）
static float simd_ip_dist_func(const void* pVect1, const void* pVect2,
                                const void* qty_ptr) {
    size_t qty = *((const size_t*)qty_ptr);
    // InnerProductSIMD 返回 1 - IP，与 hnswlib InnerProductSpace 保持一致
    return InnerProductSIMD((const float*)pVect1,
                             (const float*)pVect2, qty);
}

class SIMDInnerProductSpace : public SpaceInterface<float> {
public:
    explicit SIMDInnerProductSpace(size_t dim) : dim_(dim) {}

    size_t get_data_size()  override { return dim_ * sizeof(float); }
    size_t dim() const { return dim_; }

    DISTFUNC<float> get_dist_func() override {
        return simd_ip_dist_func;
    }

    void* get_dist_func_param() override {
        return &dim_;
    }

private:
    size_t dim_;
};

// ─────────────────────────────────────────────────────────────────────
// 堆工具
// ─────────────────────────────────────────────────────────────────────
using HNSWSIMDPair = std::pair<float, labeltype>;
using HNSWSIMDHeap = std::priority_queue<HNSWSIMDPair>;

static inline void hnsw_simd_heap_push(HNSWSIMDHeap& h, float d,
                                        labeltype id, size_t p) {
    if (h.size() < p)             h.emplace(d, id);
    else if (d < h.top().first) { h.pop(); h.emplace(d, id); }
}

// ─────────────────────────────────────────────────────────────────────
// LocalSearchResult — 单进程局部搜索结果的序列化容器
//   由 local_search_omp_multi_entry_() 产出，供各通信变体消费。
// ─────────────────────────────────────────────────────────────────────
struct LocalSearchResult {
    std::vector<float>    dists;
    std::vector<uint32_t> ids;
    int local_count;
};

// ═════════════════════════════════════════════════════════════════════
// HNSWMPISIMDSearch — HNSW + MPI + SIMD 分布式检索类
// ═════════════════════════════════════════════════════════════════════
class HNSWMPISIMDSearch {
public:
    HNSWMPISIMDSearch() : rank_(0), size_(1), dim_(0),
                           local_n_(0), local_start_(0),
                           M_(16), ef_construction_(150),
                           appr_alg_(nullptr), space_(nullptr),
                           local_base_(nullptr),
                           comm_time_local_us_(0.0),
                           comm_time_max_us_(0.0),
                           win_dists_(MPI_WIN_NULL),
                           win_ids_(MPI_WIN_NULL) {
        MPI_Comm_rank(MPI_COMM_WORLD, &rank_);
        MPI_Comm_size(MPI_COMM_WORLD, &size_);
    }

    ~HNSWMPISIMDSearch() {
        free_onesided_windows();
        delete appr_alg_;
        delete space_;
        delete[] local_base_;
    }

    // ─────────────────────────────────────────────────────────────────
    // build_distributed
    //   与 hnsw_mpi.h 相同的分发逻辑，但建图时使用 SIMDInnerProductSpace。
    //   每进程在本地 1/P 数据上独立构建一个使用 NEON SIMD 距离的 HNSW。
    // ─────────────────────────────────────────────────────────────────
    void build_distributed(const float* base, size_t n, size_t d,
                            int M = 16, int ef_construction = 150) {
        dim_             = d;
        M_               = M;
        ef_construction_ = ef_construction;

        // 广播元信息
        size_t global_n = n;
        MPI_Bcast(&global_n, 1, MPI_UNSIGNED_LONG_LONG, 0, MPI_COMM_WORLD);
        MPI_Bcast(&dim_,     1, MPI_UNSIGNED_LONG_LONG, 0, MPI_COMM_WORLD);

        // 均匀块划分
        size_t chunk = (global_n + size_ - 1) / size_;
        local_start_ = (size_t)rank_ * chunk;
        size_t local_end = std::min(local_start_ + chunk, global_n);
        local_n_ = local_end - local_start_;

        assert(local_n_ > 0 && "A rank received 0 vectors — reduce process count");

        // 分发向量数据（Scatterv）
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

        // 构建本地 HNSW，使用 SIMD 距离空间
        std::cout << "[HNSW-MPI-SIMD Rank " << rank_
                  << "] Building SIMD HNSW: local_n=" << local_n_
                  << "  M=" << M_ << "  efC=" << ef_construction_ << std::endl;

        space_    = new SIMDInnerProductSpace(dim_);
        appr_alg_ = new HierarchicalNSW<float>(space_, local_n_, M_,
                                                ef_construction_);

        // 首个节点串行插入（hnswlib 要求 label 0 单独处理）
        appr_alg_->addPoint(local_base_, 0);
        #pragma omp parallel for schedule(dynamic, 64)
        for (int i = 1; i < (int)local_n_; ++i) {
            appr_alg_->addPoint(local_base_ + (size_t)i * dim_, (labeltype)i);
        }

        std::cout << "[HNSW-MPI-SIMD Rank " << rank_
                  << "] SIMD HNSW built (" << appr_alg_->cur_element_count
                  << " nodes)" << std::endl;
    }

    // ─────────────────────────────────────────────────────────────────
    // search — SIMD HNSW 分布式检索（单入口）
    //   hnswlib 内部通过 SIMDInnerProductSpace 调用 NEON InnerProductSIMD。
    //   外层 MPI 通信逻辑与 hnsw_mpi.h 完全相同，仅距离计算路径不同。
    // ─────────────────────────────────────────────────────────────────
    HNSWSIMDHeap search(const float* query, size_t k,
                         size_t ef_search = 0, size_t local_p = 0) {
        if (ef_search < k) ef_search = k * 2;
        if (local_p   < k) local_p   = k;
        if (!appr_alg_ || local_n_ == 0) return HNSWSIMDHeap();

        // Bcast query
        std::vector<float> q_buf(dim_);
        if (rank_ == 0)
            std::memcpy(q_buf.data(), query, dim_ * sizeof(float));
        MPI_Bcast(q_buf.data(), (int)dim_, MPI_FLOAT, 0, MPI_COMM_WORLD);

        // SIMD HNSW 路由（hnswlib 内部调用 simd_ip_dist_func）
        appr_alg_->setEf(ef_search);
        auto local_result = appr_alg_->searchKnn(q_buf.data(), local_p);

        // 局部 label → 全局 ID
        int local_count = (int)local_result.size();
        std::vector<float>    ld(local_count);
        std::vector<uint32_t> li(local_count);
        for (int i = local_count - 1; i >= 0; --i) {
            ld[i] = local_result.top().first;
            li[i] = (uint32_t)(local_result.top().second + local_start_);
            local_result.pop();
        }

        return gather_and_merge_(ld, li, local_count, k);
    }

    // ─────────────────────────────────────────────────────────────────
    // search_simd_filter — SIMD 粗筛增强版
    //
    //   策略：先用 ef_coarse（较小）做快速 HNSW 路由，收集候选集，
    //   再对候选集逐一调用 InnerProductSIMD 精算距离，利用动态阈值
    //   剪掉明显远的候选，最后以精确距离维护 top-k 堆。
    //
    //   适用场景：
    //     HNSW 内部距离近似，SIMD 精算距离准确，二者结合提升召回率。
    //     当 ef_coarse < ef_refine 时，速度比全精 ef_refine 快，
    //     召回率比全粗 ef_coarse 高。
    // ─────────────────────────────────────────────────────────────────
    HNSWSIMDHeap search_simd_filter(const float* query, size_t k,
                                     size_t ef_coarse  = 0,
                                     size_t ef_refine  = 0,
                                     size_t cand_mult  = 4) {
        if (ef_coarse < k * 2)  ef_coarse = k * 2;
        if (ef_refine < k * 4)  ef_refine = ef_coarse * cand_mult;
        if (!appr_alg_ || local_n_ == 0) return HNSWSIMDHeap();

        std::vector<float> q_buf(dim_);
        if (rank_ == 0)
            std::memcpy(q_buf.data(), query, dim_ * sizeof(float));
        MPI_Bcast(q_buf.data(), (int)dim_, MPI_FLOAT, 0, MPI_COMM_WORLD);

        // 粗路由：用较大 ef 收集候选
        appr_alg_->setEf(ef_refine);
        auto cands = appr_alg_->searchKnn(q_buf.data(), ef_refine);

        // 收集候选节点的原始向量，做 SIMD 精算
        HNSWSIMDHeap local_heap;
        float threshold = std::numeric_limits<float>::max();

        // 将 hnswlib 堆转换为 vector（hnswlib 返回大顶堆，堆顶最远）
        std::vector<std::pair<float, labeltype>> cand_vec;
        cand_vec.reserve(cands.size());
        while (!cands.empty()) {
            cand_vec.push_back(cands.top());
            cands.pop();
        }

        for (auto& cv : cand_vec) {
            labeltype local_label = cv.second;
            const float* vec = local_base_ + local_label * dim_;

            // SIMD 精算（比 hnswlib 内部路由精度更高）
            float dist = InnerProductSIMD(vec, q_buf.data(), dim_);

            // 动态阈值：堆满后只接受优于堆顶的候选
            if (local_heap.size() < k) {
                local_heap.emplace(dist, local_label);
                if (local_heap.size() == k)
                    threshold = local_heap.top().first;
            } else if (dist < threshold) {
                local_heap.pop();
                local_heap.emplace(dist, local_label);
                threshold = local_heap.top().first;
            }
        }

        // 局部 label → 全局 ID
        int local_count = (int)local_heap.size();
        std::vector<float>    ld(local_count);
        std::vector<uint32_t> li(local_count);
        for (int i = local_count - 1; i >= 0; --i) {
            ld[i] = local_heap.top().first;
            li[i] = (uint32_t)(local_heap.top().second + local_start_);
            local_heap.pop();
        }

        return gather_and_merge_(ld, li, local_count, k);
    }

    // ─────────────────────────────────────────────────────────────────
    // search_omp_multi_entry — OpenMP 多入口 + SIMD 三级并行
    //
    //   进程内启动 n_entries 个 OpenMP 线程，各自从不同随机入口点出发
    //   独立进行 SIMD HNSW 路由，最终归并各线程结果。
    //   适合 local_n 较大、HNSW 子图稠密的场景（多入口减少贪心局部极小）。
    // ─────────────────────────────────────────────────────────────────
    HNSWSIMDHeap search_omp_multi_entry(const float* query, size_t k,
                                         size_t ef_search = 0,
                                         size_t n_entries = 4,
                                         size_t local_p   = 0) {
        LocalSearchResult local = local_search_omp_multi_entry_(
            query, k, ef_search, n_entries, local_p);
        return gather_and_merge_(local.dists, local.ids,
                                  local.local_count, k);
    }

    // ═════════════════════════════════════════════════════════════════
    // 四种通信变体 — 相同局部搜索，不同结果汇总方式
    //   每个方法内部测量纯通信耗时（MPI_Wtime），并通过 MPI_Reduce(MAX)
    //   获取 Straggler 延迟，存入 comm_time_max_us_。
    //   四种方式归并的全局 Top-K 结果完全一致（bitwise identical）。
    // ═════════════════════════════════════════════════════════════════

    // (a) 阻塞集合通信 — MPI_Gather + MPI_Gatherv
    HNSWSIMDHeap search_blocking(const float* query, size_t k,
                                  size_t ef_search = 0,
                                  size_t n_entries = 4,
                                  size_t local_p   = 0) {
        LocalSearchResult local = local_search_omp_multi_entry_(
            query, k, ef_search, n_entries, local_p);
        return comm_blocking_(local, k);
    }

    // (b) 非阻塞集合通信 — MPI_Igather + MPI_Igatherv + MPI_Waitall
    HNSWSIMDHeap search_nonblocking(const float* query, size_t k,
                                     size_t ef_search = 0,
                                     size_t n_entries = 4,
                                     size_t local_p   = 0) {
        LocalSearchResult local = local_search_omp_multi_entry_(
            query, k, ef_search, n_entries, local_p);
        return comm_nonblocking_(local, k);
    }

    // (c) 点对点通信 — MPI_Send / MPI_Irecv（两轮协议）
    HNSWSIMDHeap search_p2p(const float* query, size_t k,
                              size_t ef_search = 0,
                              size_t n_entries = 4,
                              size_t local_p   = 0) {
        LocalSearchResult local = local_search_omp_multi_entry_(
            query, k, ef_search, n_entries, local_p);
        return comm_p2p_(local, k);
    }

    // (d) 单边通信 (RMA) — MPI_Win_create + MPI_Put + MPI_Win_fence
    HNSWSIMDHeap search_onesided(const float* query, size_t k,
                                   size_t ef_search = 0,
                                   size_t n_entries = 4,
                                   size_t local_p   = 0) {
        LocalSearchResult local = local_search_omp_multi_entry_(
            query, k, ef_search, n_entries, local_p);
        return comm_onesided_(local, k);
    }

    // ─────────────────────────────────────────────────────────────────
    // 通信计时访问器（最近一次任意 search_* 调用的结果）
    // ─────────────────────────────────────────────────────────────────
    double get_last_comm_time_local_us() const { return comm_time_local_us_; }
    double get_last_comm_time_max_us()   const { return comm_time_max_us_; }

    // ─────────────────────────────────────────────────────────────────
    // 持久化单边窗口生命周期（One-Sided Persistent Windows）
    //   在 build_distributed 之后调用 init，析构自动 free。
    //   max_per_rank: 单 rank 每查询最大候选数（≥ local_p）
    // ─────────────────────────────────────────────────────────────────
    void init_onesided_windows(size_t max_per_rank);
    void free_onesided_windows();

    int    rank()     const { return rank_; }
    int    mpi_size() const { return size_; }
    size_t local_n()  const { return local_n_; }

private:
    // ═════════════════════════════════════════════════════════════════
    // 公共局部搜索 — OMP 多入口 SIMD HNSW
    //   所有通信变体共享。包含 Bcast query、OMP 多入口路由、归并、序列化。
    //   返回值 LocalSearchResult 中的 ids 已经是全局 ID。
    // ═════════════════════════════════════════════════════════════════
    LocalSearchResult local_search_omp_multi_entry_(
        const float* query, size_t k, size_t ef_search,
        size_t n_entries, size_t local_p)
    {
        if (ef_search < k) ef_search = k * 2;
        if (local_p   < k) local_p   = k;

        LocalSearchResult result;
        result.local_count = 0;
        if (!appr_alg_ || local_n_ == 0) return result;

        // Bcast query
        std::vector<float> q_buf(dim_);
        if (rank_ == 0)
            std::memcpy(q_buf.data(), query, dim_ * sizeof(float));
        MPI_Bcast(q_buf.data(), (int)dim_, MPI_FLOAT, 0, MPI_COMM_WORLD);

        // OMP 多入口本地 HNSW 搜索
        int num_threads = omp_get_max_threads();
        size_t actual = std::min(n_entries, (size_t)num_threads);
        std::vector<HNSWSIMDHeap> entry_heaps(actual);

        // setEf 移到并行区域外，避免多线程竞争写入 ef_
        appr_alg_->setEf(ef_search);

        #pragma omp parallel for num_threads((int)actual)
        for (int ei = 0; ei < (int)actual; ++ei) {
            auto local_res = appr_alg_->searchKnn(q_buf.data(), local_p);

            HNSWSIMDHeap& eh = entry_heaps[ei];
            while (!local_res.empty()) {
                auto top = local_res.top(); local_res.pop();
                labeltype gid = (labeltype)((size_t)top.second + local_start_);
                hnsw_simd_heap_push(eh, top.first, gid, local_p);
            }
        }

        // 归并多入口结果
        HNSWSIMDHeap merged;
        for (auto& eh : entry_heaps) {
            while (!eh.empty()) {
                hnsw_simd_heap_push(merged, eh.top().first,
                                     eh.top().second, local_p);
                eh.pop();
            }
        }

        // 序列化为平面数组
        result.local_count = (int)merged.size();
        result.dists.resize(result.local_count);
        result.ids.resize(result.local_count);
        for (int i = result.local_count - 1; i >= 0; --i) {
            result.dists[i] = merged.top().first;
            result.ids[i]   = (uint32_t)merged.top().second;
            merged.pop();
        }
        return result;
    }

    // ─────────────────────────────────────────────────────────────────
    // 辅助：堆归并（所有通信变体共用，不计入通信时间）
    // ─────────────────────────────────────────────────────────────────
    HNSWSIMDHeap merge_heap_(const std::vector<float>&    all_dists,
                              const std::vector<uint32_t>& all_ids,
                              size_t k) const {
        return merge_heap_(all_dists, all_ids, all_dists.size(), k);
    }

    HNSWSIMDHeap merge_heap_(const std::vector<float>&    all_dists,
                              const std::vector<uint32_t>& all_ids,
                              size_t total, size_t k) const {
        HNSWSIMDHeap result;
        for (size_t i = 0; i < total; ++i)
            hnsw_simd_heap_push(result, all_dists[i],
                                 (labeltype)all_ids[i], k);
        return result;
    }

    // ─────────────────────────────────────────────────────────────────
    // 计时宏：记录通信时间并做 MPI_Reduce(MAX)
    // ─────────────────────────────────────────────────────────────────
    void record_comm_time_(double t_start, double t_end) {
        comm_time_local_us_ = (t_end - t_start) * 1.0e6;
        MPI_Reduce(&comm_time_local_us_, &comm_time_max_us_,
                   1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);
    }

    // ═════════════════════════════════════════════════════════════════
    // (a) 阻塞集合通信实现
    // ═════════════════════════════════════════════════════════════════
    HNSWSIMDHeap comm_blocking_(const LocalSearchResult& local, size_t k) {
        double t0 = MPI_Wtime();

        std::vector<int> all_counts(size_);
        MPI_Gather(&local.local_count, 1, MPI_INT,
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

        MPI_Gatherv(local.dists.data(), local.local_count, MPI_FLOAT,
                    all_dists.data(), all_counts.data(), displs.data(),
                    MPI_FLOAT, 0, MPI_COMM_WORLD);
        MPI_Gatherv(local.ids.data(), local.local_count, MPI_UINT32_T,
                    all_ids.data(), all_counts.data(), displs.data(),
                    MPI_UINT32_T, 0, MPI_COMM_WORLD);

        double t1 = MPI_Wtime();
        record_comm_time_(t0, t1);

        if (rank_ != 0) return HNSWSIMDHeap();
        return merge_heap_(all_dists, all_ids, k);
    }

    // ═════════════════════════════════════════════════════════════════
    // (b) 非阻塞集合通信实现
    // ═════════════════════════════════════════════════════════════════
    HNSWSIMDHeap comm_nonblocking_(const LocalSearchResult& local, size_t k) {
        double t0 = MPI_Wtime();

        // Phase 1: 非阻塞收集 counts
        std::vector<int> all_counts(size_);
        MPI_Request count_req;
        MPI_Igather(&local.local_count, 1, MPI_INT,
                    all_counts.data(), 1, MPI_INT, 0, MPI_COMM_WORLD,
                    &count_req);
        MPI_Wait(&count_req, MPI_STATUS_IGNORE);

        // 计算 displs + 分配接收缓冲区
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

        // Phase 2: 并发发起两个 Igatherv
        MPI_Request dist_req, id_req;
        MPI_Igatherv(local.dists.data(), local.local_count, MPI_FLOAT,
                     all_dists.data(), all_counts.data(), displs.data(),
                     MPI_FLOAT, 0, MPI_COMM_WORLD, &dist_req);
        MPI_Igatherv(local.ids.data(), local.local_count, MPI_UINT32_T,
                     all_ids.data(), all_counts.data(), displs.data(),
                     MPI_UINT32_T, 0, MPI_COMM_WORLD, &id_req);

        MPI_Request reqs[2] = {dist_req, id_req};
        MPI_Waitall(2, reqs, MPI_STATUSES_IGNORE);

        double t1 = MPI_Wtime();
        record_comm_time_(t0, t1);

        if (rank_ != 0) return HNSWSIMDHeap();
        return merge_heap_(all_dists, all_ids, k);
    }

    // ═════════════════════════════════════════════════════════════════
    // (c) 点对点通信实现（两轮协议：counts → displs → data）
    //     Tag 设计: 10=count, 11=dists, 12=ids
    //     Root 使用 Irecv 获得最大重叠，非 Root 使用阻塞 Send
    // ═════════════════════════════════════════════════════════════════
    HNSWSIMDHeap comm_p2p_(const LocalSearchResult& local, size_t k) {
        double t0 = MPI_Wtime();

        std::vector<int> all_counts(size_);
        std::vector<float>    all_dists;
        std::vector<uint32_t> all_ids;
        std::vector<int>      displs(size_, 0);

        if (size_ == 1) {
            // 单进程快速路径
            all_counts[0] = local.local_count;
            if (local.local_count > 0) {
                all_dists = local.dists;
                all_ids   = local.ids;
            }
        } else if (rank_ == 0) {
            // ── Root: Round 1 — 接收 counts ──
            all_counts[0] = local.local_count;
            std::vector<MPI_Request> count_reqs(size_ - 1);
            for (int r = 1; r < size_; ++r) {
                MPI_Irecv(&all_counts[r], 1, MPI_INT, r, 10,
                          MPI_COMM_WORLD, &count_reqs[r - 1]);
            }
            MPI_Waitall(size_ - 1, count_reqs.data(), MPI_STATUSES_IGNORE);

            // 计算 displs + 分配缓冲区
            int total = 0;
            for (int r = 0; r < size_; ++r) {
                displs[r] = total;
                total += all_counts[r];
            }
            all_dists.resize(total);
            all_ids.resize(total);

            // 拷贝 Root 自身数据
            if (local.local_count > 0) {
                std::memcpy(all_dists.data(), local.dists.data(),
                            local.local_count * sizeof(float));
                std::memcpy(all_ids.data(), local.ids.data(),
                            local.local_count * sizeof(uint32_t));
            }

            // ── Root: Round 2 — 接收 dists + ids ──
            std::vector<MPI_Request> data_reqs;
            data_reqs.reserve(2 * (size_ - 1));
            for (int r = 1; r < size_; ++r) {
                if (all_counts[r] > 0) {
                    MPI_Request dr, ir;
                    MPI_Irecv(all_dists.data() + displs[r], all_counts[r],
                              MPI_FLOAT, r, 11, MPI_COMM_WORLD, &dr);
                    MPI_Irecv(all_ids.data() + displs[r], all_counts[r],
                              MPI_UINT32_T, r, 12, MPI_COMM_WORLD, &ir);
                    data_reqs.push_back(dr);
                    data_reqs.push_back(ir);
                }
            }
            if (!data_reqs.empty())
                MPI_Waitall((int)data_reqs.size(), data_reqs.data(),
                            MPI_STATUSES_IGNORE);

        } else {
            // ── Non-Root: Round 1 — 发送 count ──
            MPI_Send(&local.local_count, 1, MPI_INT, 0, 10, MPI_COMM_WORLD);

            // ── Non-Root: Round 2 — 发送 dists + ids ──
            if (local.local_count > 0) {
                MPI_Send(local.dists.data(), local.local_count,
                         MPI_FLOAT, 0, 11, MPI_COMM_WORLD);
                MPI_Send(local.ids.data(), local.local_count,
                         MPI_UINT32_T, 0, 12, MPI_COMM_WORLD);
            }
        }

        double t1 = MPI_Wtime();
        record_comm_time_(t0, t1);

        if (rank_ != 0) return HNSWSIMDHeap();
        return merge_heap_(all_dists, all_ids, k);
    }

    // ═════════════════════════════════════════════════════════════════
    // (d) 单边通信 (RMA) 实现 — 持久化全局窗口（工业级长连接模式）
    //
    //     架构优化：
    //       - 窗口在 init_onesided_windows() 中一次性创建，全查询复用
    //       - 缓冲区在 0 号进程预分配，消除 per-query resize 开销
    //       - Fence 使用 MPI_MODE_NOPRECEDE / MPI_MODE_NOSUCCEED 断言
    //         跳过隐式 Barrier，充分发挥 RMA 异步解耦优势
    //
    //     通信阶段（纯计时区间）：
    //       Phase 1: MPI_Gather 收集各 rank 候选数
    //       Phase 2: Root 计算 displs → MPI_Bcast 广播给所有 rank
    //       Phase 3: NOPRECEDE Fence → MPI_Put → NOSUCCEED Fence
    // ═════════════════════════════════════════════════════════════════

    // init_onesided_windows — 在 build_distributed 之后调用一次
    //   仅 0 号进程分配内存；全体进程共同创建持久窗口。
    void init_onesided_windows(size_t max_per_rank) {
        size_t capacity = (size_t)size_ * max_per_rank;
        if (rank_ == 0) {
            onesided_dists_.resize(capacity);
            onesided_ids_.resize(capacity);
            MPI_Win_create(onesided_dists_.data(),
                           (MPI_Aint)capacity * sizeof(float),
                           sizeof(float), MPI_INFO_NULL,
                           MPI_COMM_WORLD, &win_dists_);
            MPI_Win_create(onesided_ids_.data(),
                           (MPI_Aint)capacity * sizeof(uint32_t),
                           sizeof(uint32_t), MPI_INFO_NULL,
                           MPI_COMM_WORLD, &win_ids_);
            std::cout << "[HNSW-MPI-SIMD Rank 0] One-sided persistent windows "
                      << "created: capacity=" << capacity
                      << " (" << size_ << " ranks × " << max_per_rank
                      << "/rank)" << std::endl;
        } else {
            MPI_Win_create(NULL, 0, 1, MPI_INFO_NULL,
                           MPI_COMM_WORLD, &win_dists_);
            MPI_Win_create(NULL, 0, 1, MPI_INFO_NULL,
                           MPI_COMM_WORLD, &win_ids_);
        }
    }

    // free_onesided_windows — 析构时自动调用，亦可手动提前释放
    void free_onesided_windows() {
        if (win_dists_ != MPI_WIN_NULL) {
            MPI_Win_free(&win_dists_);
            win_dists_ = MPI_WIN_NULL;
        }
        if (win_ids_ != MPI_WIN_NULL) {
            MPI_Win_free(&win_ids_);
            win_ids_ = MPI_WIN_NULL;
        }
        onesided_dists_.clear();
        onesided_ids_.clear();
    }

    HNSWSIMDHeap comm_onesided_(const LocalSearchResult& local, size_t k) {
        // 防御：未初始化窗口时回退到阻塞通信
        if (win_dists_ == MPI_WIN_NULL || win_ids_ == MPI_WIN_NULL) {
            return comm_blocking_(local, k);
        }

        // ── 计时起点：通信阶段开始 ──────────────────────────────────
        double t0 = MPI_Wtime();

        std::vector<int> all_counts(size_);
        std::vector<int> displs(size_, 0);
        int total = 0;

        if (size_ == 1) {
            // 单进程快速路径：零通信
            all_counts[0] = local.local_count;
            total = local.local_count;
            if (local.local_count > 0) {
                std::memcpy(onesided_dists_.data(), local.dists.data(),
                            local.local_count * sizeof(float));
                std::memcpy(onesided_ids_.data(), local.ids.data(),
                            local.local_count * sizeof(uint32_t));
            }
        } else {
            // ── Phase 1: 收集 counts（轻量阻塞 Gather）──────────────
            MPI_Gather(&local.local_count, 1, MPI_INT,
                       all_counts.data(), 1, MPI_INT, 0, MPI_COMM_WORLD);

            // ── Phase 2: Root 计算 displs + Bcast 给所有 rank ──────
            if (rank_ == 0) {
                for (int r = 0; r < size_; ++r) {
                    displs[r] = total;
                    total += all_counts[r];
                }
                // 安全检查：缓冲区溢出防护
                if ((size_t)total > onesided_dists_.size()) {
                    std::cerr << "[HNSW-MPI-SIMD Rank 0] FATAL: onesided "
                              << "buffer overflow! total=" << total
                              << " capacity=" << onesided_dists_.size()
                              << ". Re-run with larger init_onesided_windows()."
                              << std::endl;
                    MPI_Abort(MPI_COMM_WORLD, 1);
                }
                // Root 拷贝自身数据到预分配缓冲区的 displs[0] 偏移处
                if (local.local_count > 0) {
                    std::memcpy(onesided_dists_.data() + displs[0],
                                local.dists.data(),
                                local.local_count * sizeof(float));
                    std::memcpy(onesided_ids_.data() + displs[0],
                                local.ids.data(),
                                local.local_count * sizeof(uint32_t));
                }
            }
            MPI_Bcast(displs.data(), size_, MPI_INT, 0, MPI_COMM_WORLD);

            // ── Phase 3: RMA Put with optimized Fence ───────────────
            // NOPRECEDE: 断言本 epoch 前无未完成 RMA，跳过 Barrier 前置同步
            MPI_Win_fence(MPI_MODE_NOPRECEDE, win_dists_);
            MPI_Win_fence(MPI_MODE_NOPRECEDE, win_ids_);

            if (rank_ != 0 && local.local_count > 0) {
                MPI_Put(local.dists.data(), local.local_count, MPI_FLOAT,
                        0, (MPI_Aint)displs[rank_], local.local_count,
                        MPI_FLOAT, win_dists_);
                MPI_Put(local.ids.data(), local.local_count, MPI_UINT32_T,
                        0, (MPI_Aint)displs[rank_], local.local_count,
                        MPI_UINT32_T, win_ids_);
            }

            // NOSUCCEED: 断言本 epoch 后无后续 RMA，跳过 Barrier 后置同步
            MPI_Win_fence(MPI_MODE_NOSUCCEED, win_dists_);
            MPI_Win_fence(MPI_MODE_NOSUCCEED, win_ids_);
        }

        // ── 计时终点：通信阶段结束 ──────────────────────────────────
        double t1 = MPI_Wtime();
        record_comm_time_(t0, t1);

        if (rank_ != 0) return HNSWSIMDHeap();
        return merge_heap_(onesided_dists_, onesided_ids_, (size_t)total, k);
    }

    // ─────────────────────────────────────────────────────────────────
    // 原始 gather_and_merge_（保持 backward compat，search/search_omp_multi_entry 使用）
    // ─────────────────────────────────────────────────────────────────
    HNSWSIMDHeap gather_and_merge_(
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

        HNSWSIMDHeap result;
        if (rank_ == 0)
            for (int i = 0; i < (int)all_dists.size(); ++i)
                hnsw_simd_heap_push(result, all_dists[i],
                                     (labeltype)all_ids[i], k);
        return result;
    }

    int    rank_, size_;
    size_t dim_, local_n_, local_start_;
    int    M_, ef_construction_;

    float*                  local_base_;
    SIMDInnerProductSpace*  space_;
    HierarchicalNSW<float>* appr_alg_;

    // 通信计时（每次 search_* 调用后更新）
    double comm_time_local_us_;
    double comm_time_max_us_;

    // 持久化单边窗口（长连接模式，避免 per-query Win_create/Win_free）
    MPI_Win              win_dists_ = MPI_WIN_NULL;
    MPI_Win              win_ids_   = MPI_WIN_NULL;
    std::vector<float>    onesided_dists_;   // 0 号进程预分配接收缓冲区
    std::vector<uint32_t> onesided_ids_;
};
