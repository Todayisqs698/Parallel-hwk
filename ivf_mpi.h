#pragma once
/**
 * ivf_mpi.h  —  IVF 倒排索引 + MPI 基础分布式检索
 * =====================================================================
 * 对应任务 B：纯 IVF + MPI 基础头文件
 *
 * 功能：
 *   - 进程内本地 KMeans++ 聚类（K-Means，L2 距离空间）
 *   - 簇级块划分（Cluster-level Block Partition）
 *   - 各进程本地串行精确扫描（标量内积，无 SIMD）
 *   - nprobe 参数控制精度/速度权衡
 *   - MPI_Gatherv 汇聚候选结果到 0 号进程
 *
 * 与 ivf_mpi_simd.h 的区别：
 *   ivf_mpi.h     — 纯 MPI + 标量内积，概念参考实现，易于理解和调试
 *   ivf_mpi_simd.h — MPI + NEON SIMD，调用 InnerProductSIMD 加速内积
 *   ivf_mpi_omp.h  — MPI + OpenMP，进程内多线程并行扫描
 *
 * 数据划分策略（簇级块划分）：
 *   nlist = 1024, P = 4 进程：
 *     Rank 0: 簇 [0,   256)
 *     Rank 1: 簇 [256, 512)
 *     Rank 2: 簇 [512, 768)
 *     Rank 3: 簇 [768, 1024)
 *
 * 查询流程（所有进程同步执行）：
 *   1. Bcast 查询向量
 *   2. 各进程在全量簇心上粗排（L2 距离选 nprobe）
 *   3. 各进程仅扫描本进程拥有的且在 top-nprobe 中的簇
 *   4. 局部 top-k 通过 MPI_Gatherv 汇聚到 0 号进程
 *   5. 0 号进程串行归并全局 top-k
 *
 * 通信原语：
 *   MPI_Bcast    — 广播簇心 + 广播查询向量
 *   MPI_Send/Recv — 点对点分发倒排列表
 *   MPI_Gather   — 收集局部结果大小
 *   MPI_Gatherv  — 收集局部 top-k (dist, id)
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
#include <cassert>

// ─────────────────────────────────────────────────────────────────────
// 堆工具
// ─────────────────────────────────────────────────────────────────────
using IVFMPIPair = std::pair<float, uint32_t>;
using IVFMPIHeap = std::priority_queue<IVFMPIPair>;

static inline void ivf_mpi_heap_push(IVFMPIHeap& h, float d,
                                      uint32_t id, size_t p) {
    if (h.size() < p)             h.emplace(d, id);
    else if (d < h.top().first) { h.pop(); h.emplace(d, id); }
}

// ─────────────────────────────────────────────────────────────────────
// 标量内积（内积距离 = 1 - IP，值越小越相似）
// ─────────────────────────────────────────────────────────────────────
static inline float ivf_mpi_ip(const float* a, const float* b, size_t dim) {
    float ip = 0.0f;
    for (size_t i = 0; i < dim; ++i) ip += a[i] * b[i];
    return 1.0f - ip;
}

// ─────────────────────────────────────────────────────────────────────
// 标量 L2 距离（粗排用）
// ─────────────────────────────────────────────────────────────────────
static inline float ivf_mpi_l2sq(const float* a, const float* b, size_t dim) {
    float s = 0.0f;
    for (size_t i = 0; i < dim; ++i) {
        float df = a[i] - b[i];
        s += df * df;
    }
    return s;
}

// ─────────────────────────────────────────────────────────────────────
// KMeans++ 训练（标量版，与 ivf_index_base.h 算法一致）
// ─────────────────────────────────────────────────────────────────────
static void ivf_mpi_kmeans(const float* data, size_t n, size_t dim,
                             size_t K, int max_iter, float* centroids) {
    std::mt19937 rng(42);

    // KMeans++ 初始化：最大化初始簇心离散度
    {
        std::uniform_int_distribution<size_t> uid(0, n - 1);
        size_t first = uid(rng);
        std::memcpy(centroids, data + first * dim, dim * sizeof(float));
    }

    std::vector<float> min_dists(n, std::numeric_limits<float>::max());
    for (size_t ci = 1; ci < K; ++ci) {
        const float* last = centroids + (ci - 1) * dim;
        for (size_t i = 0; i < n; ++i) {
            float d = ivf_mpi_l2sq(data + i * dim, last, dim);
            if (d < min_dists[i]) min_dists[i] = d;
        }
        std::discrete_distribution<size_t> dd(min_dists.begin(),
                                               min_dists.end());
        size_t pick = dd(rng);
        std::memcpy(centroids + ci * dim, data + pick * dim,
                    dim * sizeof(float));
    }

    // Lloyd 迭代：E-Step + M-Step
    std::vector<int>   assign(n);
    std::vector<float> new_centers(K * dim);
    std::vector<int>   counts(K);

    for (int iter = 0; iter < max_iter; ++iter) {
        // E-Step：分配最近簇
        for (size_t i = 0; i < n; ++i) {
            float md = std::numeric_limits<float>::max();
            int   bk = 0;
            const float* v = data + i * dim;
            for (size_t c = 0; c < K; ++c) {
                float d = ivf_mpi_l2sq(v, centroids + c * dim, dim);
                if (d < md) { md = d; bk = (int)c; }
            }
            assign[i] = bk;
        }

        // M-Step：更新簇心均值
        std::fill(new_centers.begin(), new_centers.end(), 0.0f);
        std::fill(counts.begin(), counts.end(), 0);
        for (size_t i = 0; i < n; ++i) {
            int c = assign[i];
            counts[c]++;
            for (size_t d = 0; d < dim; ++d)
                new_centers[c * dim + d] += data[i * dim + d];
        }
        for (size_t c = 0; c < K; ++c) {
            if (counts[c] > 0)
                for (size_t d = 0; d < dim; ++d)
                    centroids[c * dim + d] = new_centers[c * dim + d]
                                             / counts[c];
        }
    }
}

// ─────────────────────────────────────────────────────────────────────
// 序列化 / 反序列化倒排列表（用于 MPI_Send/Recv 传输）
//
// 格式：
//   [n_owned_clusters: int]
//   对每个簇：
//     [global_cid: int]
//     [n_vec: int]
//     [vec_data: float[n_vec * dim]]
//     [id_data: uint32_t[n_vec]]
// ─────────────────────────────────────────────────────────────────────
static void ivf_mpi_pack(
    const std::vector<std::vector<float>>&    inv_vecs,
    const std::vector<std::vector<uint32_t>>& inv_ids,
    const std::vector<int>&                   owned_cids,
    size_t dim, std::vector<char>& buf)
{
    size_t total = sizeof(int);  // n_owned_clusters
    for (int cid : owned_cids) {
        total += sizeof(int) * 2;                           // cid + n_vec
        total += inv_ids[cid].size() * dim * sizeof(float); // vec_data
        total += inv_ids[cid].size() * sizeof(uint32_t);    // id_data
    }
    buf.resize(total);
    char* ptr = buf.data();

    int n_owned = (int)owned_cids.size();
    std::memcpy(ptr, &n_owned, sizeof(int)); ptr += sizeof(int);

    for (int cid : owned_cids) {
        size_t nv = inv_ids[cid].size();
        std::memcpy(ptr, &cid, sizeof(int)); ptr += sizeof(int);
        int nv_int = (int)nv;
        std::memcpy(ptr, &nv_int, sizeof(int)); ptr += sizeof(int);
        std::memcpy(ptr, inv_vecs[cid].data(), nv * dim * sizeof(float));
        ptr += nv * dim * sizeof(float);
        std::memcpy(ptr, inv_ids[cid].data(), nv * sizeof(uint32_t));
        ptr += nv * sizeof(uint32_t);
    }
}

static void ivf_mpi_unpack(
    const char* buf, size_t dim, size_t nlist,
    std::vector<std::vector<float>>&    inv_vecs,
    std::vector<std::vector<uint32_t>>& inv_ids,
    std::vector<int>&                   owned_cids)
{
    const char* ptr = buf;
    int n_owned;
    std::memcpy(&n_owned, ptr, sizeof(int)); ptr += sizeof(int);

    inv_vecs.resize(nlist);
    inv_ids.resize(nlist);
    owned_cids.resize(n_owned);

    for (int i = 0; i < n_owned; ++i) {
        int cid;
        std::memcpy(&cid, ptr, sizeof(int)); ptr += sizeof(int);
        owned_cids[i] = cid;

        int nv;
        std::memcpy(&nv, ptr, sizeof(int)); ptr += sizeof(int);

        inv_vecs[cid].resize((size_t)nv * dim);
        std::memcpy(inv_vecs[cid].data(), ptr, (size_t)nv * dim * sizeof(float));
        ptr += (size_t)nv * dim * sizeof(float);

        inv_ids[cid].resize((size_t)nv);
        std::memcpy(inv_ids[cid].data(), ptr, (size_t)nv * sizeof(uint32_t));
        ptr += (size_t)nv * sizeof(uint32_t);
    }
}

// ═════════════════════════════════════════════════════════════════════
// IVFMPI — 纯 IVF + MPI 基础分布式检索类
// ═════════════════════════════════════════════════════════════════════
class IVFMPI {
public:
    IVFMPI() : rank_(0), size_(1), nlist_(0), dim_(0), N_(0) {
        MPI_Comm_rank(MPI_COMM_WORLD, &rank_);
        MPI_Comm_size(MPI_COMM_WORLD, &size_);
    }

    ~IVFMPI() = default;

    // ─────────────────────────────────────────────────────────────────
    // build_distributed
    //   0 号进程：KMeans++ → 构建倒排列表 → 分发给各进程
    //   所有进程：接收并存储本进程的倒排列表分区
    //
    //   nlist      : 聚类数量（建议 sqrt(N) 附近，如 N=100K 时 nlist=1024）
    //   kmeans_iter: Lloyd 迭代次数（默认 15 轮）
    // ─────────────────────────────────────────────────────────────────
    void build_distributed(const float* base, size_t n, size_t d,
                            size_t nlist, int kmeans_iter = 15) {
        N_     = n;
        dim_   = d;
        nlist_ = nlist;

        centroids_.resize(nlist_ * dim_);
        inv_vecs_.resize(nlist_);
        inv_ids_.resize(nlist_);

        if (rank_ == 0) {
            std::cout << "[IVF-MPI Rank 0] KMeans++ training: "
                      << "nlist=" << nlist_
                      << "  N=" << N_
                      << "  dim=" << dim_ << std::endl;

            // 限制训练样本数（大数据集取前 50K 训练，降低 O(N*K) 开销）
            size_t train_n = std::min(N_, (size_t)50000);
            ivf_mpi_kmeans(base, train_n, dim_, nlist_, kmeans_iter,
                           centroids_.data());

            // 构建倒排列表（全量 base 数据）
            std::cout << "[IVF-MPI Rank 0] Building inverted lists..." << std::endl;
            for (size_t i = 0; i < N_; ++i) {
                const float* v = base + i * dim_;
                float md = std::numeric_limits<float>::max();
                size_t best = 0;
                for (size_t c = 0; c < nlist_; ++c) {
                    float d2 = ivf_mpi_l2sq(v, centroids_.data() + c * dim_,
                                             dim_);
                    if (d2 < md) { md = d2; best = c; }
                }
                inv_vecs_[best].insert(inv_vecs_[best].end(), v, v + dim_);
                inv_ids_[best].push_back((uint32_t)i);
            }

            // 打印统计
            size_t mx = 0, mn = N_, total_v = 0;
            for (size_t c = 0; c < nlist_; ++c) {
                size_t s = inv_ids_[c].size();
                mx = std::max(mx, s);
                mn = std::min(mn, s);
                total_v += s;
            }
            std::cout << "[IVF-MPI Rank 0] list_len: "
                      << "max=" << mx << "  min=" << mn
                      << "  avg=" << total_v / nlist_ << std::endl;
        }

        // ── 广播簇心到所有进程 ────────────────────────────────────
        MPI_Bcast(centroids_.data(), (int)(nlist_ * dim_), MPI_FLOAT,
                  0, MPI_COMM_WORLD);

        // ── 计算每个进程的簇分片 ─────────────────────────────────
        size_t chunk = (nlist_ + size_ - 1) / size_;
        {
            size_t c_start = (size_t)rank_ * chunk;
            size_t c_end   = std::min(c_start + chunk, nlist_);
            owned_cids_.clear();
            for (size_t c = c_start; c < c_end; ++c)
                owned_cids_.push_back((int)c);
        }

        // ── 0 号进程分发倒排列表给各进程 ─────────────────────────
        if (rank_ == 0) {
            for (int dst = 1; dst < size_; ++dst) {
                size_t dst_start = (size_t)dst * chunk;
                size_t dst_end   = std::min(dst_start + chunk, nlist_);
                std::vector<int> dst_cids;
                for (size_t c = dst_start; c < dst_end; ++c)
                    dst_cids.push_back((int)c);

                std::vector<char> buf;
                ivf_mpi_pack(inv_vecs_, inv_ids_, dst_cids, dim_, buf);

                int buf_sz = (int)buf.size();
                MPI_Send(&buf_sz, 1, MPI_INT, dst, 10, MPI_COMM_WORLD);
                MPI_Send(buf.data(), buf_sz, MPI_BYTE, dst, 11,
                         MPI_COMM_WORLD);

                std::cout << "[IVF-MPI Rank 0] Sent "
                          << dst_cids.size() << " clusters ("
                          << buf_sz << " bytes) to rank " << dst << std::endl;
            }

            // 0 号进程清理非拥有的簇数据（释放内存）
            for (size_t c = 0; c < nlist_; ++c) {
                bool owned = false;
                for (int oc : owned_cids_)
                    if ((size_t)oc == c) { owned = true; break; }
                if (!owned) {
                    inv_vecs_[c].clear(); inv_vecs_[c].shrink_to_fit();
                    inv_ids_[c].clear();  inv_ids_[c].shrink_to_fit();
                }
            }
        } else {
            int buf_sz = 0;
            MPI_Recv(&buf_sz, 1, MPI_INT, 0, 10, MPI_COMM_WORLD,
                     MPI_STATUS_IGNORE);
            std::vector<char> buf(buf_sz);
            MPI_Recv(buf.data(), buf_sz, MPI_BYTE, 0, 11, MPI_COMM_WORLD,
                     MPI_STATUS_IGNORE);
            ivf_mpi_unpack(buf.data(), dim_, nlist_,
                           inv_vecs_, inv_ids_, owned_cids_);
        }

        // 统计本进程持有的向量数
        size_t local_n = 0;
        for (int cid : owned_cids_)
            local_n += inv_ids_[cid].size();
        std::cout << "[IVF-MPI Rank " << rank_ << "] Owns "
                  << owned_cids_.size() << " clusters, "
                  << local_n << " vectors" << std::endl;
    }

    // ─────────────────────────────────────────────────────────────────
    // search — 分布式 IVF 检索
    //   所有进程必须同步调用。
    //   query     : 0 号进程有效，其他进程忽略
    //   k         : top-k
    //   nprobe    : 粗排选取的簇数（控制精度/速度权衡）
    //   p         : 进程级局部堆大小（p >= k）
    //   返回值     : 仅 0 号进程有效
    // ─────────────────────────────────────────────────────────────────
    IVFMPIHeap search(const float* query, size_t k,
                       size_t nprobe, size_t p = 0) const {
        if (p < k) p = k;
        nprobe = std::min(nprobe, nlist_);

        // ── 1. 广播查询向量 ──────────────────────────────────────────
        std::vector<float> q_buf(dim_);
        if (rank_ == 0)
            std::memcpy(q_buf.data(), query, dim_ * sizeof(float));
        MPI_Bcast(q_buf.data(), (int)dim_, MPI_FLOAT, 0, MPI_COMM_WORLD);

        // ── 2. 粗排：各进程在全量簇心上独立计算距离 ─────────────────
        std::vector<std::pair<float, size_t>> coarse(nlist_);
        for (size_t c = 0; c < nlist_; ++c) {
            float d2 = ivf_mpi_l2sq(q_buf.data(),
                                     centroids_.data() + c * dim_, dim_);
            coarse[c] = {d2, c};
        }
        std::partial_sort(coarse.begin(), coarse.begin() + nprobe,
                          coarse.end());

        // ── 3. 精排：仅扫描本进程拥有的 top-nprobe 簇 ───────────────
        IVFMPIHeap local_heap;
        for (size_t i = 0; i < nprobe; ++i) {
            size_t cid = coarse[i].second;

            // 快速检查所有权（owned_cids_ 量级小，线性扫描 OK）
            bool owned = false;
            for (int oc : owned_cids_)
                if ((size_t)oc == cid) { owned = true; break; }
            if (!owned) continue;

            size_t n_vec = inv_ids_[cid].size();
            const float* vecs = inv_vecs_[cid].data();

            for (size_t j = 0; j < n_vec; ++j) {
                // 预取下一个向量
                if (j + 2 < n_vec)
                    __builtin_prefetch(vecs + (j + 2) * dim_, 0, 3);

                float dist = ivf_mpi_ip(vecs + j * dim_,
                                         q_buf.data(), dim_);
                ivf_mpi_heap_push(local_heap, dist,
                                   inv_ids_[cid][j], p);
            }
        }

        // 收缩到 k
        while (local_heap.size() > k) local_heap.pop();

        // ── 4. 序列化局部结果 ────────────────────────────────────────
        int local_count = (int)local_heap.size();
        std::vector<float>    ld(local_count);
        std::vector<uint32_t> li(local_count);
        for (int i = local_count - 1; i >= 0; --i) {
            ld[i] = local_heap.top().first;
            li[i] = local_heap.top().second;
            local_heap.pop();
        }

        // ── 5. Gather 结果数量 ───────────────────────────────────────
        std::vector<int> all_counts(size_);
        MPI_Gather(&local_count, 1, MPI_INT,
                   all_counts.data(), 1, MPI_INT, 0, MPI_COMM_WORLD);

        // ── 6. Gatherv (dist, id) ────────────────────────────────────
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

        // ── 7. 0 号进程全局归并 ──────────────────────────────────────
        IVFMPIHeap result;
        if (rank_ == 0) {
            for (int i = 0; i < (int)all_dists.size(); ++i)
                ivf_mpi_heap_push(result, all_dists[i], all_ids[i], k);
        }
        return result;
    }

    int  rank()    const { return rank_; }
    int  mpi_size() const { return size_; }

private:
    int    rank_, size_;
    size_t nlist_, dim_, N_;

    std::vector<float>               centroids_;   // [nlist × dim] 全量簇心（每进程均有）
    std::vector<std::vector<float>>  inv_vecs_;    // 仅本进程拥有的簇数据
    std::vector<std::vector<uint32_t>> inv_ids_;   // 对应全局 ID
    std::vector<int>                 owned_cids_;  // 本进程拥有的簇 ID
};
