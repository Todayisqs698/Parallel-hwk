#pragma once
/**
 * flat_mpi.h  —  MPI 分布式精确暴力检索（Brute-Force Flat Search）
 * =====================================================================
 * 对应任务 A：基础精确检索 MPI 代码
 *
 * 设计策略：
 *   - Base 数据集按行（向量）均匀划分给 P 个 MPI 进程
 *   - 0 号进程加载全量数据，通过 MPI_Scatterv 分发给各进程
 *   - 各进程在本地子集上独立进行标量内积距离暴力扫描
 *   - 局部 top-k 堆结果通过 MPI_Gatherv 汇聚到 0 号进程归并
 *
 * 内积距离：dist = 1.0 - IP，与 simd_utils.h 保持一致
 *
 * 通信原语：
 *   MPI_Scatterv — 均匀分发 Base 向量（首次建索引）
 *   MPI_Bcast    — 广播查询向量（每次查询）
 *   MPI_Gather   — 收集局部结果数量
 *   MPI_Gatherv  — 收集局部 top-k (dist, id) 对
 *
 * 架构图：
 *   Rank 0: 加载 base → Scatterv 分发 → 本地暴力扫描 → Gatherv 归并
 *   Rank 1:             接收本地分片 → 本地暴力扫描 → Gatherv 上报
 *   Rank 2:             接收本地分片 → 本地暴力扫描 → Gatherv 上报
 *   ...
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

// ─────────────────────────────────────────────────────────────────────
// 堆工具（最大堆，堆顶是当前 top-k 中距离最大的候选）
// ─────────────────────────────────────────────────────────────────────
using FlatMPIPair = std::pair<float, uint32_t>;
using FlatMPIHeap = std::priority_queue<FlatMPIPair>;

static inline void flat_mpi_heap_push(FlatMPIHeap& h, float d,
                                       uint32_t id, size_t p) {
    if (h.size() < p)             h.emplace(d, id);
    else if (d < h.top().first) { h.pop(); h.emplace(d, id); }
}

// ─────────────────────────────────────────────────────────────────────
// 标量内积计算（与 flat_scan.h 保持一致）
// dist = 1.0 - Σ(q[i] × v[i])，值越小越相似
// ─────────────────────────────────────────────────────────────────────
static inline float flat_mpi_inner_product(const float* a, const float* b,
                                            size_t dim) {
    float ip = 0.0f;
    for (size_t i = 0; i < dim; ++i)
        ip += a[i] * b[i];
    return 1.0f - ip;
}

// ═════════════════════════════════════════════════════════════════════
// FlatMPI — MPI 分布式精确检索类
// ═════════════════════════════════════════════════════════════════════
class FlatMPI {
public:
    FlatMPI() : rank_(0), size_(1), dim_(0),
                global_n_(0), local_n_(0), local_start_(0) {
        MPI_Comm_rank(MPI_COMM_WORLD, &rank_);
        MPI_Comm_size(MPI_COMM_WORLD, &size_);
    }

    ~FlatMPI() = default;

    // ─────────────────────────────────────────────────────────────────
    // build_distributed
    //   0 号进程：提供 base 数据指针，分发给所有进程
    //   非 0 进程：base / global_n 参数可为 nullptr / 0
    // ─────────────────────────────────────────────────────────────────
    void build_distributed(const float* base, size_t n, size_t d) {
        global_n_ = n;
        dim_       = d;

        // ── 1. 广播数据集元信息 ──────────────────────────────────────
        MPI_Bcast(&global_n_, 1, MPI_UNSIGNED_LONG_LONG, 0, MPI_COMM_WORLD);
        MPI_Bcast(&dim_,       1, MPI_UNSIGNED_LONG_LONG, 0, MPI_COMM_WORLD);

        // ── 2. 计算每个进程的分片范围 ────────────────────────────────
        // 进程 r 处理向量 [r*chunk, (r+1)*chunk)，最后一个进程处理尾部
        size_t chunk = global_n_ / size_;
        local_start_ = (size_t)rank_ * chunk;
        local_n_     = (rank_ == size_ - 1)
                       ? (global_n_ - local_start_)  // 最后一个进程处理余量
                       : chunk;

        // ── 3. 准备 Scatterv 参数（0 号进程）───────────────────────
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

        // ── 4. 分发向量数据 ─────────────────────────────────────────
        local_vecs_.resize(local_n_ * dim_);

        MPI_Scatterv(
            base,                           // sendbuf (0 号进程有效)
            sendcounts.data(),              // sendcounts
            displs.data(),                  // displs
            MPI_FLOAT,
            local_vecs_.data(),             // recvbuf
            (int)(local_n_ * dim_),         // recvcount
            MPI_FLOAT,
            0, MPI_COMM_WORLD
        );

        // ── 5. 打印分片信息 ─────────────────────────────────────────
        std::cout << "[Flat-MPI Rank " << rank_
                  << "] Owns vectors [" << local_start_
                  << ", " << local_start_ + local_n_ << ")"
                  << "  count=" << local_n_ << std::endl;
    }

    // ─────────────────────────────────────────────────────────────────
    // search — 分布式精确检索
    //   所有进程必须同时调用。query 在 0 号进程中有效，其他进程忽略。
    //   返回值仅在 0 号进程有效（最大堆，堆顶为最差候选）。
    // ─────────────────────────────────────────────────────────────────
    FlatMPIHeap search(const float* query, size_t k) const {
        // ── 1. 广播查询向量 ──────────────────────────────────────────
        std::vector<float> q_buf(dim_);
        if (rank_ == 0)
            std::memcpy(q_buf.data(), query, dim_ * sizeof(float));
        MPI_Bcast(q_buf.data(), (int)dim_, MPI_FLOAT, 0, MPI_COMM_WORLD);

        // ── 2. 各进程本地暴力扫描 ────────────────────────────────────
        FlatMPIHeap local_heap;
        const float* vecs = local_vecs_.data();
        for (size_t j = 0; j < local_n_; ++j) {
            // 预取下一个向量到 L1 缓存（提前 2 个向量）
            if (j + 2 < local_n_)
                __builtin_prefetch(vecs + (j + 2) * dim_, 0, 3);

            float dist = flat_mpi_inner_product(vecs + j * dim_,
                                                 q_buf.data(), dim_);
            uint32_t global_id = (uint32_t)(local_start_ + j);
            flat_mpi_heap_push(local_heap, dist, global_id, k);
        }

        // ── 3. 序列化局部 top-k ──────────────────────────────────────
        int local_count = (int)local_heap.size();
        std::vector<float>    local_dists(local_count);
        std::vector<uint32_t> local_ids(local_count);
        for (int i = local_count - 1; i >= 0; --i) {
            local_dists[i] = local_heap.top().first;
            local_ids[i]   = local_heap.top().second;
            local_heap.pop();
        }

        // ── 4. 收集各进程结果数量 ────────────────────────────────────
        std::vector<int> all_counts(size_);
        MPI_Gather(&local_count, 1, MPI_INT,
                   all_counts.data(), 1, MPI_INT,
                   0, MPI_COMM_WORLD);

        // ── 5. Gatherv 收集 (dist, id) 数据 ─────────────────────────
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

        // ── 6. 0 号进程归并全局 top-k ────────────────────────────────
        FlatMPIHeap result;
        if (rank_ == 0) {
            for (int i = 0; i < (int)all_dists.size(); ++i)
                flat_mpi_heap_push(result, all_dists[i], all_ids[i], k);
        }
        return result;
    }

    int  rank()     const { return rank_; }
    int  mpi_size() const { return size_; }
    size_t local_n() const { return local_n_; }

private:
    int    rank_, size_;
    size_t dim_, global_n_, local_n_, local_start_;

    std::vector<float> local_vecs_;   // 当前进程持有的本地向量分片
};
