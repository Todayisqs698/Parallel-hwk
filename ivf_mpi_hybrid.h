#pragma once
/**
 * ivf_mpi_hybrid.h  —  MPI + OpenMP 混合并行 IVF 检索（对应 Lab4 §4.1 + §4.3）
 * =====================================================================
 * 混合并行架构：
 *   - 进程间（Inter-Process）：MPI 块划分倒排列表，每个进程只维护本地数据
 *   - 进程内（Intra-Process）：OpenMP 线程池并行扫描进程拥有的倒排桶，
 *     使用 schedule(dynamic, 1) 自适应负载均衡，消除偏态桶长空转
 *
 * 设计要点：
 *   1. 粗排阶段：各进程对全量簇心并行距离计算（OpenMP static）
 *   2. 精排阶段：OpenMP dynamic 分配倒排桶 → 每线程私有局部堆 → Reduce
 *   3. 进程间汇聚：MPI_Gatherv 收集各进程精排结果 → 0 号进程归并全局 top-k
 *
 * 与纯 MPI 版本（ivf_mpi_simd.h）的区别：
 *   - 精排阶段从串行扫描改为 OpenMP 并行扫描
 *   - 每个 MPI 进程内维护 num_threads 个线程私有局部堆
 *   - 桶级粒度动态调度，抹平偏态分布长尾
 * =====================================================================
 */

#include <mpi.h>
#include <omp.h>
#include <vector>
#include <queue>
#include <algorithm>
#include <cstring>
#include <limits>
#include <random>
#include <iostream>
#include <cassert>
#include "simd_utils.h"

// ─────────────────────────────────────────────────────────────────────
// 复用 ivf_mpi_simd.h 的序列化工具和 KMeans 训练函数
// ─────────────────────────────────────────────────────────────────────

// 前向声明（实现在 ivf_mpi_simd.h 中，此处重新声明以保持独立）
static void mpi_hybrid_kmeans(const float* data, size_t n, size_t dim,
                               size_t K, int max_iter, float* centroids);

static void mpi_hybrid_pack_inv_lists(
    const std::vector<std::vector<float>>&   inv_vecs,
    const std::vector<std::vector<uint32_t>>& inv_ids,
    const std::vector<int>&                   owned_cids,
    size_t dim, std::vector<char>& buffer);

static void mpi_hybrid_unpack_inv_lists(
    const char* buffer, size_t dim,
    std::vector<std::vector<float>>&   inv_vecs,
    std::vector<std::vector<uint32_t>>& inv_ids,
    std::vector<int>& owned_cids, size_t nlist);

// ─────────────────────────────────────────────────────────────────────
// 堆工具
// ─────────────────────────────────────────────────────────────────────
using HybridIVFPair = std::pair<float, uint32_t>;
using HybridIVFHeap = std::priority_queue<HybridIVFPair>;

static inline void hybrid_heap_push(HybridIVFHeap& h, float d,
                                     uint32_t id, size_t p) {
    if (h.size() < p)             h.emplace(d, id);
    else if (d < h.top().first) { h.pop(); h.emplace(d, id); }
}

// ─────────────────────────────────────────────────────────────────────
// KMeans++ 训练（独立副本，避免跨文件链接依赖）
// ─────────────────────────────────────────────────────────────────────
static void mpi_hybrid_kmeans(const float* data, size_t n, size_t dim,
                               size_t K, int max_iter, float* centroids) {
    std::mt19937 rng(42);
    auto l2sq = [&](const float* a, const float* b) {
        float s = 0;
        for (size_t d = 0; d < dim; ++d) { float df = a[d]-b[d]; s += df*df; }
        return s;
    };
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
            for (size_t d = 0; d < dim; ++d) nc[c*dim+d] += data[i*dim+d];
        }
        for (size_t c = 0; c < K; ++c) {
            if (cnt[c] > 0)
                for (size_t d = 0; d < dim; ++d)
                    centroids[c*dim+d] = nc[c*dim+d] / cnt[c];
        }
    }
}

// ─────────────────────────────────────────────────────────────────────
// 序列化函数
// ─────────────────────────────────────────────────────────────────────
static void mpi_hybrid_pack_inv_lists(
    const std::vector<std::vector<float>>&   inv_vecs,
    const std::vector<std::vector<uint32_t>>& inv_ids,
    const std::vector<int>&                   owned_cids,
    size_t dim, std::vector<char>& buffer)
{
    size_t total_bytes = sizeof(int);
    for (int cid : owned_cids) {
        total_bytes += sizeof(int);
        total_bytes += sizeof(int);
        size_t nv = inv_ids[cid].size();
        total_bytes += nv * dim * sizeof(float);
        total_bytes += nv * sizeof(uint32_t);
    }
    buffer.resize(total_bytes);
    char* ptr = buffer.data();
    int n_owned = (int)owned_cids.size();
    std::memcpy(ptr, &n_owned, sizeof(int)); ptr += sizeof(int);
    for (int cid : owned_cids) {
        size_t nv = inv_ids[cid].size();
        std::memcpy(ptr, &cid, sizeof(int)); ptr += sizeof(int);
        int nv_int = (int)nv;
        std::memcpy(ptr, &nv_int, sizeof(int)); ptr += sizeof(int);
        size_t vec_bytes = nv * dim * sizeof(float);
        std::memcpy(ptr, inv_vecs[cid].data(), vec_bytes); ptr += vec_bytes;
        size_t id_bytes = nv * sizeof(uint32_t);
        std::memcpy(ptr, inv_ids[cid].data(), id_bytes); ptr += id_bytes;
    }
}

static void mpi_hybrid_unpack_inv_lists(
    const char* buffer, size_t dim,
    std::vector<std::vector<float>>&   inv_vecs,
    std::vector<std::vector<uint32_t>>& inv_ids,
    std::vector<int>& owned_cids, size_t nlist)
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
        inv_vecs[cid].resize(nv * dim);
        size_t vec_bytes = nv * dim * sizeof(float);
        std::memcpy(inv_vecs[cid].data(), ptr, vec_bytes); ptr += vec_bytes;
        inv_ids[cid].resize(nv);
        size_t id_bytes = nv * sizeof(uint32_t);
        std::memcpy(inv_ids[cid].data(), ptr, id_bytes); ptr += id_bytes;
    }
}

// ═════════════════════════════════════════════════════════════════════
// IVFMPIHybrid — MPI + OpenMP 混合并行 IVF 检索类
// ═════════════════════════════════════════════════════════════════════
class IVFMPIHybrid {
public:
    IVFMPIHybrid() : rank_(0), size_(1), nlist_(0), dim_(0), N_(0) {
        MPI_Comm_rank(MPI_COMM_WORLD, &rank_);
        MPI_Comm_size(MPI_COMM_WORLD, &size_);
    }

    ~IVFMPIHybrid() = default;

    // ─────────────────────────────────────────────────────────────────
    // build_distributed — 与 IVFMPISIMD 一致的数据构建与分发
    // ─────────────────────────────────────────────────────────────────
    void build_distributed(const float* base, size_t n, size_t d,
                           size_t nl, int kmeans_iter = 15) {
        N_     = n;
        dim_   = d;
        nlist_ = nl;

        centroids_.resize(nlist_ * dim_);
        inv_vecs_.resize(nlist_);
        inv_ids_.resize(nlist_);

        if (rank_ == 0) {
            std::cout << "[MPI-Hybrid Rank " << rank_
                      << "] KMeans++ training: nlist=" << nlist_
                      << "  N=" << N_ << "  dim=" << dim_ << std::endl;
            size_t train_n = std::min(N_, (size_t)50000);
            mpi_hybrid_kmeans(base, train_n, dim_, nlist_, kmeans_iter,
                              centroids_.data());

            std::cout << "[MPI-Hybrid Rank " << rank_
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
            size_t mx = 0, mn = N_;
            for (size_t c = 0; c < nlist_; ++c) {
                size_t s = inv_ids_[c].size();
                mx = std::max(mx, s); mn = std::min(mn, s);
            }
            std::cout << "[MPI-Hybrid Rank " << rank_
                      << "] list_len: max=" << mx << " min=" << mn
                      << " avg=" << N_ / nlist_ << std::endl;
        }

        // 广播簇心
        MPI_Bcast(centroids_.data(), (int)(nlist_ * dim_), MPI_FLOAT,
                  0, MPI_COMM_WORLD);

        // 块划分
        owned_cids_.clear();
        size_t chunk = (nlist_ + size_ - 1) / size_;
        size_t c_start = (size_t)rank_ * chunk;
        size_t c_end   = std::min(c_start + chunk, nlist_);
        for (size_t c = c_start; c < c_end; ++c)
            owned_cids_.push_back((int)c);

        // 分发倒排列表
        if (rank_ == 0) {
            for (int dst = 1; dst < size_; ++dst) {
                size_t dst_start = (size_t)dst * chunk;
                size_t dst_end   = std::min(dst_start + chunk, nlist_);
                std::vector<int> dst_cids;
                for (size_t c = dst_start; c < dst_end; ++c)
                    dst_cids.push_back((int)c);

                std::vector<char> buf;
                mpi_hybrid_pack_inv_lists(inv_vecs_, inv_ids_, dst_cids,
                                          dim_, buf);
                int buf_size = (int)buf.size();
                MPI_Send(&buf_size, 1, MPI_INT, dst, 0, MPI_COMM_WORLD);
                MPI_Send(buf.data(), buf_size, MPI_BYTE, dst, 1,
                         MPI_COMM_WORLD);
                std::cout << "[MPI-Hybrid Rank 0] Sent " << dst_cids.size()
                          << " clusters (" << buf_size
                          << " bytes) to rank " << dst << std::endl;
            }
            // 清理非拥有簇
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
            int buf_size = 0;
            MPI_Recv(&buf_size, 1, MPI_INT, 0, 0, MPI_COMM_WORLD,
                     MPI_STATUS_IGNORE);
            std::vector<char> buf(buf_size);
            MPI_Recv(buf.data(), buf_size, MPI_BYTE, 0, 1, MPI_COMM_WORLD,
                     MPI_STATUS_IGNORE);
            mpi_hybrid_unpack_inv_lists(buf.data(), dim_,
                                        inv_vecs_, inv_ids_,
                                        owned_cids_, nlist_);
        }

        size_t local_n = 0;
        for (int cid : owned_cids_) local_n += inv_ids_[cid].size();
        std::cout << "[MPI-Hybrid Rank " << rank_ << "] Owns "
                  << owned_cids_.size() << " clusters, "
                  << local_n << " vectors" << std::endl;
    }

    // ─────────────────────────────────────────────────────────────────
    // search_hybrid — MPI + OpenMP 混合并行检索
    //
    // 混合并行策略：
    //   粗排: #pragma omp parallel for schedule(static)
    //         对全量簇心并行计算 L2 距离
    //   精排: #pragma omp parallel for schedule(dynamic, 1)
    //         以单桶为粒度动态分配，每线程维护私有局部堆
    //         消除 KMeans 偏态桶长导致的负载不均衡
    //   汇聚: MPI_Gatherv 收集各进程结果 → 0 号归并
    // ─────────────────────────────────────────────────────────────────
    HybridIVFHeap search_hybrid(const float* query, size_t k,
                                size_t nprobe, size_t p = 0) const {
        if (p < k) p = k;
        nprobe = std::min(nprobe, nlist_);

        // ── 1. 广播查询向量 ──────────────────────────────────────────
        std::vector<float> q_buf(dim_);
        if (rank_ == 0)
            std::memcpy(q_buf.data(), query, dim_ * sizeof(float));
        MPI_Bcast(q_buf.data(), (int)dim_, MPI_FLOAT, 0, MPI_COMM_WORLD);

        // ── 2. OpenMP 并行粗排（static 调度，最大化缓存局部性）─────
        std::vector<std::pair<float, size_t>> dists(nlist_);
        #pragma omp parallel for schedule(static)
        for (int c = 0; c < (int)nlist_; ++c) {
            const float* cv = centroids_.data() + (size_t)c * dim_;
            float d2 = 0;
            for (size_t dd = 0; dd < dim_; ++dd) {
                float df = q_buf[dd] - cv[dd]; d2 += df * df;
            }
            dists[c] = {d2, (size_t)c};
        }
        std::partial_sort(dists.begin(), dists.begin() + nprobe, dists.end());

        // ── 3. 确定本进程需搜索的簇列表 ─────────────────────────────
        // 从 top-nprobe 中筛选出本进程拥有的簇
        std::vector<size_t> local_probe_cids;
        for (size_t i = 0; i < nprobe; ++i) {
            size_t cid = dists[i].second;
            for (int oc : owned_cids_)
                if ((size_t)oc == cid) {
                    local_probe_cids.push_back(cid);
                    break;
                }
        }

        // ── 4. OpenMP 并行精排（dynamic, 1 自适应负载均衡）────────
        int num_threads = omp_get_max_threads();
        std::vector<HybridIVFHeap> thread_heaps(num_threads);

        #pragma omp parallel
        {
            int tid = omp_get_thread_num();
            HybridIVFHeap& local_h = thread_heaps[tid];

            // dynamic, 1 — 每个线程一次只拿 1 个桶，处理完再拿下一个
            // 这样桶长大的被先拿的线程处理，桶长小的后处理，避免空等
            #pragma omp for schedule(dynamic, 1)
            for (int i = 0; i < (int)local_probe_cids.size(); ++i) {
                size_t cid    = local_probe_cids[i];
                size_t n_vec  = inv_ids_[cid].size();
                const float* vecs = inv_vecs_[cid].data();
                const uint32_t* ids = inv_ids_[cid].data();

                // NEON SIMD 内积扫描
                for (size_t j = 0; j < n_vec; ++j) {
                    if (j + 2 < n_vec)
                        __builtin_prefetch(vecs + (j + 2) * dim_, 0, 3);

                    float dist = InnerProductSIMD(vecs + j * dim_,
                                                  q_buf.data(), dim_);
                    hybrid_heap_push(local_h, dist, ids[j], p);
                }
            }
        }

        // ── 5. 线程级 Reduce：归并 num_threads 个线程局部堆 ──────────
        HybridIVFHeap process_heap;
        for (auto& th : thread_heaps) {
            while (!th.empty()) {
                hybrid_heap_push(process_heap, th.top().first,
                                 th.top().second, p);
                th.pop();
            }
        }
        while (process_heap.size() > k) process_heap.pop();

        // ── 6. 序列化进程级 top-k ────────────────────────────────────
        int local_count = (int)process_heap.size();
        std::vector<float>   local_dists(local_count);
        std::vector<uint32_t> local_ids(local_count);
        for (int i = local_count - 1; i >= 0; --i) {
            local_dists[i] = process_heap.top().first;
            local_ids[i]   = process_heap.top().second;
            process_heap.pop();
        }

        // ── 7. MPI 收集所有进程的 top-k → 0 号进程归并 ──────────────
        std::vector<int> all_counts(size_);
        MPI_Gather(&local_count, 1, MPI_INT, all_counts.data(), 1,
                   MPI_INT, 0, MPI_COMM_WORLD);

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

        // ── 8. 全局归并 ─────────────────────────────────────────────
        HybridIVFHeap result;
        if (rank_ == 0) {
            for (int i = 0; i < (int)all_dists.size(); ++i)
                hybrid_heap_push(result, all_dists[i], all_ids[i], k);
        }
        return result;
    }

    int rank() const { return rank_; }
    int size() const { return size_; }

private:
    int rank_, size_;
    size_t nlist_, dim_, N_;

    std::vector<float>                 centroids_;
    std::vector<std::vector<float>>    inv_vecs_;
    std::vector<std::vector<uint32_t>> inv_ids_;
    std::vector<int>                   owned_cids_;
};
