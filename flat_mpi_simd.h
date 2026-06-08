#pragma once
/**
 * flat_mpi_simd.h  —  MPI 分布式精确检索 + ARM NEON SIMD 向量化加速
 * =====================================================================
 * 对应任务 A：Flat+MPI+SIMD 融合头文件
 *
 * 在 flat_mpi.h 基础上，将本地暴力扫描替换为 ARM NEON SIMD 实现，
 * 与 simd_utils.h 中的 InnerProductSIMD 保持一致，实现三级并行：
 *
 *   Level 1 (MPI 进程间): Base 向量均匀分片，各进程独立扫描
 *   Level 2 (数据预取):   __builtin_prefetch 提前预热 L1 缓存
 *   Level 3 (SIMD 指令级): ARM NEON 4 路展开内积，16 floats/循环
 *
 * 与 flat_mpi.h 的区别：
 *   - flat_mpi.h：标量逐元素内积（参考实现，可读性优先）
 *   - flat_mpi_simd.h：NEON SIMD 内积（性能优先，~4x 单核吞吐提升）
 *
 * 通信原语（与 flat_mpi.h 相同）：
 *   MPI_Scatterv — 分发 Base 向量
 *   MPI_Bcast    — 广播查询向量
 *   MPI_Gather   — 收集结果数量
 *   MPI_Gatherv  — 收集局部 top-k
 *
 * 编译要求：
 *   ARM: -march=armv8-a+simd -mcpu=cortex-a72
 *   x86: 回退到 AVX2，或在 simd_utils.h 中统一处理平台差异
 * =====================================================================
 */

#include <mpi.h>
#include <vector>
#include <queue>
#include <algorithm>
#include <cstring>
#include <limits>
#include <iostream>
#include <cassert>
#include "simd_utils.h"   // InnerProductSIMD（ARM NEON / x86 AVX2 统一入口）

// ─────────────────────────────────────────────────────────────────────
// 堆工具
// ─────────────────────────────────────────────────────────────────────
using FlatSimdMPIPair = std::pair<float, uint32_t>;
using FlatSimdMPIHeap = std::priority_queue<FlatSimdMPIPair>;

static inline void flat_simd_mpi_heap_push(FlatSimdMPIHeap& h, float d,
                                             uint32_t id, size_t p) {
    if (h.size() < p)             h.emplace(d, id);
    else if (d < h.top().first) { h.pop(); h.emplace(d, id); }
}

// ═════════════════════════════════════════════════════════════════════
// FlatMPISIMD — MPI 分布式 + SIMD 向量化精确检索类
// ═════════════════════════════════════════════════════════════════════
class FlatMPISIMD {
public:
    FlatMPISIMD() : rank_(0), size_(1), dim_(0),
                    global_n_(0), local_n_(0), local_start_(0) {
        MPI_Comm_rank(MPI_COMM_WORLD, &rank_);
        MPI_Comm_size(MPI_COMM_WORLD, &size_);
    }

    ~FlatMPISIMD() = default;

    // ─────────────────────────────────────────────────────────────────
    // build_distributed — 将 base 数据均匀分发给所有 MPI 进程
    //   0 号进程：base 指针有效，提供全量数据
    //   非 0 进程：base 可为 nullptr，global_n 可为 0
    // ─────────────────────────────────────────────────────────────────
    void build_distributed(const float* base, size_t n, size_t d) {
        global_n_ = n;
        dim_       = d;

        // ── 1. 广播元信息 ────────────────────────────────────────────
        MPI_Bcast(&global_n_, 1, MPI_UNSIGNED_LONG_LONG, 0, MPI_COMM_WORLD);
        MPI_Bcast(&dim_,       1, MPI_UNSIGNED_LONG_LONG, 0, MPI_COMM_WORLD);

        // ── 2. 计算分片范围 ──────────────────────────────────────────
        size_t chunk = global_n_ / size_;
        local_start_ = (size_t)rank_ * chunk;
        local_n_     = (rank_ == size_ - 1)
                       ? (global_n_ - local_start_)
                       : chunk;

        // ── 3. Scatterv 分发 ─────────────────────────────────────────
        std::vector<int> sendcounts(size_), displs(size_);
        if (rank_ == 0) {
            for (int r = 0; r < size_; ++r) {
                size_t r_start = (size_t)r * chunk;
                size_t r_n     = (r == size_ - 1)
                                 ? (global_n_ - r_start)
                                 : chunk;
                sendcounts[r] = (int)(r_n * dim_);
                displs[r]     = (int)(r_start * dim_);
            }
        }

        local_vecs_.resize(local_n_ * dim_);

        MPI_Scatterv(
            base,
            sendcounts.data(),
            displs.data(),
            MPI_FLOAT,
            local_vecs_.data(),
            (int)(local_n_ * dim_),
            MPI_FLOAT,
            0, MPI_COMM_WORLD
        );

        if (rank_ == 0) {
            std::cout << "[Flat-MPI-SIMD] Built distributed flat index:\n"
                      << "  Total vectors : " << global_n_ << "\n"
                      << "  Dimension     : " << dim_       << "\n"
                      << "  MPI processes : " << size_      << "\n"
                      << "  Vectors/proc  : ~" << chunk     << std::endl;
        }
        std::cout << "[Flat-MPI-SIMD Rank " << rank_
                  << "] local_n=" << local_n_
                  << "  range=[" << local_start_
                  << ", " << local_start_ + local_n_ << ")" << std::endl;
    }

    // ─────────────────────────────────────────────────────────────────
    // search — MPI + SIMD 融合精确检索
    //
    //   Phase 1: MPI_Bcast 广播查询向量
    //   Phase 2: 各进程 SIMD 暴力扫描本地分片，维护局部 top-k 堆
    //   Phase 3: MPI_Gatherv 收集 (dist, id) → 0 号进程全局归并
    //
    //   参数 k    ：返回 top-k 个最近邻
    //   参数 p    ：进程级局部堆大小（p >= k，默认等于 k）
    //   返回值    ：最大堆（堆顶为最差候选），仅 0 号进程有效
    // ─────────────────────────────────────────────────────────────────
    FlatSimdMPIHeap search(const float* query, size_t k,
                            size_t p = 0) const {
        if (p < k) p = k;

        // ── Phase 1: 广播查询 ────────────────────────────────────────
        std::vector<float> q_buf(dim_);
        if (rank_ == 0)
            std::memcpy(q_buf.data(), query, dim_ * sizeof(float));
        MPI_Bcast(q_buf.data(), (int)dim_, MPI_FLOAT, 0, MPI_COMM_WORLD);

        // ── Phase 2: SIMD 暴力扫描本地向量 ──────────────────────────
        //   InnerProductSIMD 返回 1.0 - IP（dist 越小越相近）
        //   使用 __builtin_prefetch 预取下下个向量，减少 L1 缺失
        FlatSimdMPIHeap local_heap;
        const float* vecs = local_vecs_.data();

        for (size_t j = 0; j < local_n_; ++j) {
            // 提前 3 个向量预取，覆盖 L1→L2 延迟（约 4-6 cycle prefetch 距离）
            if (j + 3 < local_n_)
                __builtin_prefetch(vecs + (j + 3) * dim_, 0, 3);

            // SIMD 内积：ARM NEON 4 路展开，16 floats/循环
            float dist = InnerProductSIMD(vecs + j * dim_,
                                           q_buf.data(), dim_);
            uint32_t global_id = (uint32_t)(local_start_ + j);
            flat_simd_mpi_heap_push(local_heap, dist, global_id, p);
        }

        // 将局部堆收缩到 k
        while (local_heap.size() > k) local_heap.pop();

        // ── Phase 3: 序列化局部 top-k ────────────────────────────────
        int local_count = (int)local_heap.size();
        std::vector<float>    local_dists(local_count);
        std::vector<uint32_t> local_ids(local_count);
        for (int i = local_count - 1; i >= 0; --i) {
            local_dists[i] = local_heap.top().first;
            local_ids[i]   = local_heap.top().second;
            local_heap.pop();
        }

        // ── Phase 4: Gather 收集结果数量 ────────────────────────────
        std::vector<int> all_counts(size_);
        MPI_Gather(&local_count, 1, MPI_INT,
                   all_counts.data(), 1, MPI_INT,
                   0, MPI_COMM_WORLD);

        // ── Phase 5: Gatherv 收集 (dist, id) ─────────────────────────
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

        MPI_Gatherv(local_dists.data(), local_count, MPI_FLOAT,
                    all_dists.data(), all_counts.data(), displs.data(),
                    MPI_FLOAT, 0, MPI_COMM_WORLD);
        MPI_Gatherv(local_ids.data(), local_count, MPI_UINT32_T,
                    all_ids.data(), all_counts.data(), displs.data(),
                    MPI_UINT32_T, 0, MPI_COMM_WORLD);

        // ── Phase 6: 0 号进程归并全局 top-k ──────────────────────────
        FlatSimdMPIHeap result;
        if (rank_ == 0) {
            for (int i = 0; i < (int)all_dists.size(); ++i)
                flat_simd_mpi_heap_push(result, all_dists[i], all_ids[i], k);
        }
        return result;
    }

    // ─────────────────────────────────────────────────────────────────
    // search_batch — 批量查询接口（减少 Bcast 次数）
    //   适合 query 数量大的场景：一次广播多条查询，均摊通信开销
    //   返回：仅 0 号进程有效的 results[0..nq-1]，每个是最大堆
    // ─────────────────────────────────────────────────────────────────
    std::vector<FlatSimdMPIHeap> search_batch(
        const float* queries, size_t nq, size_t k) const
    {
        // ── 1. 广播全部查询 ──────────────────────────────────────────
        std::vector<float> q_buf(nq * dim_);
        if (rank_ == 0)
            std::memcpy(q_buf.data(), queries, nq * dim_ * sizeof(float));
        MPI_Bcast(q_buf.data(), (int)(nq * dim_), MPI_FLOAT,
                  0, MPI_COMM_WORLD);

        // ── 2. 各进程对每条查询独立扫描 ─────────────────────────────
        //   局部结果：nq 个堆，每个保留 k 个候选
        std::vector<std::vector<FlatSimdMPIPair>> local_results(nq);
        const float* vecs = local_vecs_.data();

        for (size_t qi = 0; qi < nq; ++qi) {
            const float* q = q_buf.data() + qi * dim_;
            FlatSimdMPIHeap lh;

            for (size_t j = 0; j < local_n_; ++j) {
                if (j + 3 < local_n_)
                    __builtin_prefetch(vecs + (j + 3) * dim_, 0, 3);
                float dist = InnerProductSIMD(vecs + j * dim_, q, dim_);
                flat_simd_mpi_heap_push(lh, dist,
                                         (uint32_t)(local_start_ + j), k);
            }

            local_results[qi].resize(lh.size());
            int idx = (int)lh.size() - 1;
            while (!lh.empty()) {
                local_results[qi][idx--] = lh.top();
                lh.pop();
            }
        }

        // ── 3. 逐条 Gather 归并（简洁实现；大规模可改为批量打包） ──
        std::vector<FlatSimdMPIHeap> results(nq);
        for (size_t qi = 0; qi < nq; ++qi) {
            int local_count = (int)local_results[qi].size();
            std::vector<float>    ld(local_count);
            std::vector<uint32_t> li(local_count);
            for (int i = 0; i < local_count; ++i) {
                ld[i] = local_results[qi][i].first;
                li[i] = local_results[qi][i].second;
            }

            std::vector<int> all_counts(size_);
            MPI_Gather(&local_count, 1, MPI_INT,
                       all_counts.data(), 1, MPI_INT,
                       0, MPI_COMM_WORLD);

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

            if (rank_ == 0) {
                for (int i = 0; i < (int)all_dists.size(); ++i)
                    flat_simd_mpi_heap_push(results[qi],
                                             all_dists[i], all_ids[i], k);
            }
        }

        return results;
    }

    int  rank()      const { return rank_; }
    int  mpi_size()  const { return size_; }
    size_t local_n() const { return local_n_; }
    size_t dim()     const { return dim_; }

private:
    int    rank_, size_;
    size_t dim_, global_n_, local_n_, local_start_;

    std::vector<float> local_vecs_;  // 当前进程的本地向量分片（连续内存）
};
