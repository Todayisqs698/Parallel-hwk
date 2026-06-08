#pragma once
/**
 * ivf_mpi_simd.h  —  MPI 分布式 IVF 并行检索（对应 Lab4 §4.1）
 * =====================================================================
 * 数据划分策略：
 *   - 0 号进程负责 KMeans++ 训练 + 构建完整倒排列表
 *   - 按聚类簇 ID 进行块划分（Block Partition），通过 MPI_Send/Recv
 *     将倒排列表分发给各 MPI 进程
 *   - 簇心向量（centroids）在所有进程间广播复制（数据量小，~384KB）
 *
 * 查询流程：
 *   1. 0 号进程接收查询向量 → MPI_Bcast 广播给所有进程
 *   2. 各进程独立在本地的簇心副本上执行粗排（L2 距离选 nprobe）
 *   3. 各进程仅搜索自己拥有的、且在 top-nprobe 内的倒排桶
 *   4. 各进程将局部 top-p 堆序列化后 MPI_Gather 到 0 号进程
 *   5. 0 号进程归并所有局部结果 → 全局 top-k
 *
 * 通信原语：
 *   MPI_Bcast   — 广播查询向量与簇心
 *   MPI_Send/Recv — 点对点分发倒排列表
 *   MPI_Gather  — 收集各进程局部检索结果
 * =====================================================================
 */

#include <mpi.h>
#include <vector>
#include <queue>
#include <algorithm>
#include <cstring>
#include <limits>
#include <random>
#include <iostream>
#include "simd_utils.h"

// ─────────────────────────────────────────────────────────────────────
// MPI 工具函数：序列化 / 反序列化倒排列表
// ─────────────────────────────────────────────────────────────────────

// 将一个进程拥有的全部倒排列表打包为连续字节流
// 格式：[n_owned_clusters: int]
//       对每个簇: [global_cid: int][n_vec: int]
//                 [vec_data: float[n_vec*dim]][id_data: uint32_t[n_vec]]
static void mpi_pack_inverted_lists(
    const std::vector<std::vector<float>>&   inv_vecs,
    const std::vector<std::vector<uint32_t>>& inv_ids,
    const std::vector<int>&                   owned_cids,
    size_t dim,
    std::vector<char>& buffer)
{
    // 先计算总字节数
    size_t total_bytes = sizeof(int); // n_owned_clusters
    for (int cid : owned_cids) {
        total_bytes += sizeof(int);                      // global_cid
        total_bytes += sizeof(int);                      // n_vec
        size_t nv = inv_ids[cid].size();
        total_bytes += nv * dim * sizeof(float);         // vec_data
        total_bytes += nv * sizeof(uint32_t);             // id_data
    }

    buffer.resize(total_bytes);
    char* ptr = buffer.data();

    // n_owned_clusters
    int n_owned = (int)owned_cids.size();
    std::memcpy(ptr, &n_owned, sizeof(int)); ptr += sizeof(int);

    for (int cid : owned_cids) {
        size_t nv = inv_ids[cid].size();

        // global_cid
        std::memcpy(ptr, &cid, sizeof(int)); ptr += sizeof(int);

        // n_vec
        int nv_int = (int)nv;
        std::memcpy(ptr, &nv_int, sizeof(int)); ptr += sizeof(int);

        // vec_data (连续存储)
        size_t vec_bytes = nv * dim * sizeof(float);
        std::memcpy(ptr, inv_vecs[cid].data(), vec_bytes);
        ptr += vec_bytes;

        // id_data
        size_t id_bytes = nv * sizeof(uint32_t);
        std::memcpy(ptr, inv_ids[cid].data(), id_bytes);
        ptr += id_bytes;
    }
}

// 从连续字节流恢复倒排列表
static void mpi_unpack_inverted_lists(
    const char* buffer,
    size_t dim,
    std::vector<std::vector<float>>&   inv_vecs,
    std::vector<std::vector<uint32_t>>& inv_ids,
    std::vector<int>&                   owned_cids,
    size_t nlist)
{
    const char* ptr = buffer;

    int n_owned;
    std::memcpy(&n_owned, ptr, sizeof(int)); ptr += sizeof(int);

    owned_cids.resize(n_owned);
    inv_vecs.resize(nlist);
    inv_ids.resize(nlist);

    for (int i = 0; i < n_owned; ++i) {
        int cid;
        std::memcpy(&cid, ptr, sizeof(int)); ptr += sizeof(int);
        owned_cids[i] = cid;

        int nv;
        std::memcpy(&nv, ptr, sizeof(int)); ptr += sizeof(int);

        // vec_data
        inv_vecs[cid].resize(nv * dim);
        size_t vec_bytes = nv * dim * sizeof(float);
        std::memcpy(inv_vecs[cid].data(), ptr, vec_bytes);
        ptr += vec_bytes;

        // id_data
        inv_ids[cid].resize(nv);
        size_t id_bytes = nv * sizeof(uint32_t);
        std::memcpy(inv_ids[cid].data(), ptr, id_bytes);
        ptr += id_bytes;
    }
}

// ─────────────────────────────────────────────────────────────────────
// 堆工具
// ─────────────────────────────────────────────────────────────────────
using MPIIVFPair = std::pair<float, uint32_t>;
using MPIIVFHeap = std::priority_queue<MPIIVFPair>;

static inline void mpi_ivf_heap_push(MPIIVFHeap& h, float d, uint32_t id, size_t p) {
    if (h.size() < p)             h.emplace(d, id);
    else if (d < h.top().first) { h.pop(); h.emplace(d, id); }
}

// ─────────────────────────────────────────────────────────────────────
// KMeans++ 训练（与 ivf_index_base.h 逻辑一致，独立实现避免依赖）
// ─────────────────────────────────────────────────────────────────────
static void mpi_ivf_kmeans(const float* data, size_t n, size_t dim,
                            size_t K, int max_iter, float* centroids) {
    std::mt19937 rng(42);

    auto l2sq = [&](const float* a, const float* b) {
        float s = 0;
        for (size_t d = 0; d < dim; ++d) { float df = a[d]-b[d]; s += df*df; }
        return s;
    };

    // KMeans++ 初始化
    std::vector<size_t> chosen;
    {
        std::uniform_int_distribution<size_t> uid(0, n-1);
        chosen.push_back(uid(rng));
        std::memcpy(centroids, data + chosen[0]*dim, dim*sizeof(float));
    }
    std::vector<float> min_dists(n, std::numeric_limits<float>::max());
    for (size_t ci = 1; ci < K; ++ci) {
        const float* last = centroids + (ci-1)*dim;
        for (size_t i = 0; i < n; ++i) {
            float d = l2sq(data + i*dim, last);
            if (d < min_dists[i]) min_dists[i] = d;
        }
        std::discrete_distribution<size_t> dd(min_dists.begin(), min_dists.end());
        size_t pick = dd(rng);
        chosen.push_back(pick);
        std::memcpy(centroids + ci*dim, data + pick*dim, dim*sizeof(float));
    }

    // Lloyd 迭代
    std::vector<int> assign(n);
    for (int iter = 0; iter < max_iter; ++iter) {
        for (size_t i = 0; i < n; ++i) {
            float md = std::numeric_limits<float>::max(); int bk = 0;
            const float* v = data + i*dim;
            for (size_t c = 0; c < K; ++c) {
                float d = l2sq(v, centroids + c*dim);
                if (d < md) { md = d; bk = (int)c; }
            }
            assign[i] = bk;
        }
        std::vector<float> nc(K*dim, 0.f);
        std::vector<int>   cnt(K, 0);
        for (size_t i = 0; i < n; ++i) {
            int c = assign[i]; cnt[c]++;
            for (size_t d = 0; d < dim; ++d)
                nc[c*dim+d] += data[i*dim+d];
        }
        for (size_t c = 0; c < K; ++c) {
            if (cnt[c] > 0)
                for (size_t d = 0; d < dim; ++d)
                    centroids[c*dim+d] = nc[c*dim+d] / cnt[c];
        }
    }
}

// ═════════════════════════════════════════════════════════════════════
// IVFMPISIMD — MPI 分布式 IVF 检索类
// ═════════════════════════════════════════════════════════════════════
class IVFMPISIMD {
public:
    IVFMPISIMD() : rank_(0), size_(1), nlist_(0), dim_(0), N_(0) {
        MPI_Comm_rank(MPI_COMM_WORLD, &rank_);
        MPI_Comm_size(MPI_COMM_WORLD, &size_);
    }

    ~IVFMPISIMD() = default;

    // ─────────────────────────────────────────────────────────────────
    // build_distributed
    //   0 号进程：KMeans 训练 → 构建倒排列表 → 划分分发
    //   其他进程：接收簇心 + 接收自己的倒排列表分区
    // ─────────────────────────────────────────────────────────────────
    void build_distributed(const float* base, size_t n, size_t d,
                           size_t nl, int kmeans_iter = 15) {
        N_    = n;
        dim_  = d;
        nlist_ = nl;

        centroids_.resize(nlist_ * dim_);
        inv_vecs_.resize(nlist_);
        inv_ids_.resize(nlist_);

        if (rank_ == 0) {
            // ── 0 号进程：训练 KMeans ────────────────────────────────
            std::cout << "[MPI-IVF Rank " << rank_
                      << "] KMeans++ training: nlist=" << nlist_
                      << "  N=" << N_ << "  dim=" << dim_ << std::endl;
            size_t train_n = std::min(N_, (size_t)50000);
            mpi_ivf_kmeans(base, train_n, dim_, nlist_, kmeans_iter,
                           centroids_.data());

            // ── 构建倒排列表 ────────────────────────────────────────
            std::cout << "[MPI-IVF Rank " << rank_
                      << "] Building inverted lists..." << std::endl;
            for (size_t i = 0; i < N_; ++i) {
                const float* v = base + i * dim_;
                float md = std::numeric_limits<float>::max();
                size_t best = 0;
                for (size_t c = 0; c < nlist_; ++c) {
                    float d2 = 0;
                    const float* cv = centroids_.data() + c * dim_;
                    for (size_t dd = 0; dd < dim_; ++dd) {
                        float df = v[dd] - cv[dd]; d2 += df * df;
                    }
                    if (d2 < md) { md = d2; best = c; }
                }
                inv_vecs_[best].insert(inv_vecs_[best].end(), v, v + dim_);
                inv_ids_[best].push_back((uint32_t)i);
            }

            // 打印统计信息
            size_t mx = 0, mn = N_;
            for (size_t c = 0; c < nlist_; ++c) {
                size_t s = inv_ids_[c].size();
                mx = std::max(mx, s); mn = std::min(mn, s);
            }
            std::cout << "[MPI-IVF Rank " << rank_
                      << "] list_len: max=" << mx << " min=" << mn
                      << " avg=" << N_ / nlist_ << std::endl;
        }

        // ── 广播簇心到所有进程 ──────────────────────────────────────
        MPI_Bcast(centroids_.data(), (int)(nlist_ * dim_), MPI_FLOAT,
                  0, MPI_COMM_WORLD);

        // ── 计算块划分归属 ──────────────────────────────────────────
        // 进程 i 拥有簇 [i*nlist/P, (i+1)*nlist/P)
        owned_cids_.clear();
        size_t chunk = (nlist_ + size_ - 1) / size_;
        size_t c_start = (size_t)rank_ * chunk;
        size_t c_end   = std::min(c_start + chunk, nlist_);
        for (size_t c = c_start; c < c_end; ++c)
            owned_cids_.push_back((int)c);

        // ── 分发倒排列表 ────────────────────────────────────────────
        if (rank_ == 0) {
            // 为每个目标进程打包并发送其倒排列表分区
            for (int dst = 1; dst < size_; ++dst) {
                size_t dst_start = (size_t)dst * chunk;
                size_t dst_end   = std::min(dst_start + chunk, nlist_);
                std::vector<int> dst_cids;
                for (size_t c = dst_start; c < dst_end; ++c)
                    dst_cids.push_back((int)c);

                std::vector<char> buf;
                mpi_pack_inverted_lists(inv_vecs_, inv_ids_, dst_cids,
                                        dim_, buf);

                // 先发送缓冲区大小，再发送数据
                int buf_size = (int)buf.size();
                MPI_Send(&buf_size, 1, MPI_INT, dst, 0, MPI_COMM_WORLD);
                MPI_Send(buf.data(), buf_size, MPI_BYTE, dst, 1,
                         MPI_COMM_WORLD);

                std::cout << "[MPI-IVF Rank 0] Sent " << dst_cids.size()
                          << " clusters (" << buf_size
                          << " bytes) to rank " << dst << std::endl;
            }

            // 0 号进程保留自己的分区
            inv_vecs_.resize(nlist_);
            inv_ids_.resize(nlist_);
            // 只保留 owned_cids_ 中的簇数据（已在上面构建好）
            // 不需要额外操作，inv_vecs_/inv_ids_ 在 rank 0 上已有全量数据
            // 为节省内存，可以清理非拥有的簇
            for (size_t c = 0; c < nlist_; ++c) {
                bool owned = false;
                for (int oc : owned_cids_)
                    if ((size_t)oc == c) { owned = true; break; }
                if (!owned) {
                    inv_vecs_[c].clear();
                    inv_vecs_[c].shrink_to_fit();
                    inv_ids_[c].clear();
                    inv_ids_[c].shrink_to_fit();
                }
            }
        } else {
            // 其他进程：接收自己的倒排列表分区
            int buf_size = 0;
            MPI_Recv(&buf_size, 1, MPI_INT, 0, 0, MPI_COMM_WORLD,
                     MPI_STATUS_IGNORE);
            std::vector<char> buf(buf_size);
            MPI_Recv(buf.data(), buf_size, MPI_BYTE, 0, 1, MPI_COMM_WORLD,
                     MPI_STATUS_IGNORE);

            mpi_unpack_inverted_lists(buf.data(), dim_,
                                      inv_vecs_, inv_ids_,
                                      owned_cids_, nlist_);
        }

        // 统计各进程拥有的向量数
        size_t local_n = 0;
        for (int cid : owned_cids_)
            local_n += inv_ids_[cid].size();
        std::cout << "[MPI-IVF Rank " << rank_ << "] Owns "
                  << owned_cids_.size() << " clusters, "
                  << local_n << " vectors" << std::endl;
    }

    // ─────────────────────────────────────────────────────────────────
    // search — 分布式检索
    //   所有进程需同时调用。query 在 0 号进程有效，其他进程忽略。
    //   返回值仅在 0 号进程有效。
    // ─────────────────────────────────────────────────────────────────
    MPIIVFHeap search(const float* query, size_t k,
                      size_t nprobe, size_t p = 0) const {
        if (p < k) p = k;
        nprobe = std::min(nprobe, nlist_);

        // ── 1. 广播查询向量 ──────────────────────────────────────────
        std::vector<float> q_buf(dim_);
        if (rank_ == 0)
            std::memcpy(q_buf.data(), query, dim_ * sizeof(float));
        MPI_Bcast(q_buf.data(), (int)dim_, MPI_FLOAT, 0, MPI_COMM_WORLD);

        // ── 2. 各进程独立粗排（在所有簇心上计算距离）───────────────
        std::vector<std::pair<float, size_t>> dists(nlist_);
        for (size_t c = 0; c < nlist_; ++c) {
            const float* cv = centroids_.data() + c * dim_;
            float d2 = 0;
            for (size_t dd = 0; dd < dim_; ++dd) {
                float df = q_buf[dd] - cv[dd]; d2 += df * df;
            }
            dists[c] = {d2, c};
        }
        std::partial_sort(dists.begin(), dists.begin() + nprobe, dists.end());

        // ── 3. 各进程搜索自己拥有的、且在 top-nprobe 中的簇 ───────
        MPIIVFHeap local_heap;
        for (size_t i = 0; i < nprobe; ++i) {
            size_t cid = dists[i].second;
            // 检查该簇是否由当前进程拥有
            bool owned = false;
            for (int oc : owned_cids_)
                if ((size_t)oc == cid) { owned = true; break; }
            if (!owned) continue;

            size_t n_vec = inv_ids_[cid].size();
            const float* vecs = inv_vecs_[cid].data();

            for (size_t j = 0; j < n_vec; ++j) {
                if (j + 2 < n_vec)
                    __builtin_prefetch(vecs + (j + 2) * dim_, 0, 3);

                float dist = InnerProductSIMD(vecs + j * dim_,
                                              q_buf.data(), dim_);
                mpi_ivf_heap_push(local_heap, dist,
                                  inv_ids_[cid][j], p);
            }
        }

        // 将局部堆缩减到 k（若 p > k）
        while (local_heap.size() > k) local_heap.pop();

        // ── 4. 序列化局部 top-k 结果 ─────────────────────────────────
        int local_count = (int)local_heap.size();
        std::vector<float>   local_dists(local_count);
        std::vector<uint32_t> local_ids(local_count);
        for (int i = local_count - 1; i >= 0; --i) {
            local_dists[i] = local_heap.top().first;
            local_ids[i]   = local_heap.top().second;
            local_heap.pop();
        }

        // ── 5. 收集各进程结果大小 ────────────────────────────────────
        std::vector<int> all_counts(size_);
        MPI_Gather(&local_count, 1, MPI_INT,
                   all_counts.data(), 1, MPI_INT,
                   0, MPI_COMM_WORLD);

        // ── 6. 收集各进程的 (dist, id) 对 ───────────────────────────
        std::vector<float>   all_dists;
        std::vector<uint32_t> all_ids;
        std::vector<int>     displs(size_, 0);

        if (rank_ == 0) {
            int total = 0;
            for (int i = 0; i < size_; ++i) {
                displs[i] = total;
                total += all_counts[i];
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

        // ── 7. 0 号进程归并全局 top-k ───────────────────────────────
        MPIIVFHeap result;
        if (rank_ == 0) {
            for (int i = 0; i < (int)all_dists.size(); ++i)
                mpi_ivf_heap_push(result, all_dists[i], all_ids[i], k);
        }

        return result;
    }

    // 获取 MPI 信息
    int rank() const { return rank_; }
    int size() const { return size_; }

private:
    int rank_, size_;
    size_t nlist_, dim_, N_;

    std::vector<float>               centroids_;     // [nlist × dim] 全量簇心（所有进程一致）
    std::vector<std::vector<float>>  inv_vecs_;      // [nlist][...]  仅拥有的簇有数据
    std::vector<std::vector<uint32_t>> inv_ids_;     // [nlist][...]  仅拥有的簇有数据
    std::vector<int>                 owned_cids_;    // 当前进程拥有的簇 ID 列表
};
