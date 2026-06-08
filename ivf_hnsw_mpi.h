#pragma once
/**
 * ivf_hnsw_mpi.h  —  IVF-HNSW 混合嵌套索引 + MPI 分布式
 * =====================================================================
 * 对应任务 C：IVF-HNSW 混合索引 + MPI 头文件
 *
 * 架构：嵌套两级索引（与 ivf_hnsw.h 算法完全对齐，加入 MPI 分布式）
 *
 *   粗级（IVF 层）：
 *     K-Means 聚类 → nlist 个簇心
 *     query 到每簇心的 NEON SIMD L2 粗排 → 选出 nprobe 个最近桶
 *
 *   精级（HNSW 层）：
 *     每个 IVF 桶内建一个独立 HNSW 子索引
 *     对选中的 nprobe 个桶做 HNSW 精确路由 → 收集候选 top-k
 *
 * MPI 分布式策略（桶级块划分）：
 *   nlist = 256, P = 4 进程：
 *     Rank 0 → 桶 [0,   64)  各自持有独立 HNSW 子索引
 *     Rank 1 → 桶 [64,  128)
 *     Rank 2 → 桶 [128, 192)
 *     Rank 3 → 桶 [192, 256)
 *
 *   查询流程（所有进程同步执行）：
 *     1. MPI_Bcast  广播簇心 + 查询向量
 *     2. 各进程在全量簇心上独立粗排（结果一致）
 *     3. 各进程仅精排自己拥有的、在 top-nprobe 内的桶
 *     4. MPI_Gatherv 汇聚局部 (dist, id) → 0 号进程全局归并
 *
 * 三级并行：
 *   Level 1 (MPI):    桶级块划分，各进程并行构建+检索
 *   Level 2 (OpenMP): 进程内多桶 HNSW 路由并行（dynamic 调度）
 *   Level 3 (SIMD):   粗排 NEON L2 + HNSW 内 InnerProductSpace
 *
 * 与 ivf_hnsw.h 的区别：
 *   ivf_hnsw.h     — 单机单进程，nlist 个 HNSW 全部在一个进程
 *   ivf_hnsw_mpi.h — MPI 分布式，nlist/P 个 HNSW 分散在 P 个进程
 *
 * 通信原语：
 *   MPI_Bcast   — 广播簇心数组（建索引阶段），广播查询向量（每次查询）
 *   MPI_Scatter/Send/Recv — 分发各桶的向量数据（建索引阶段，一次性）
 *   MPI_Gather  — 收集局部结果数量
 *   MPI_Gatherv — 收集局部 (dist, id) 对
 *
 * 编译：
 *   mpicxx -std=c++11 -O3 -fopenmp -march=armv8-a+simd -mcpu=cortex-a72
 * =====================================================================
 */

#include <mpi.h>
#include <omp.h>
#include <vector>
#include <queue>
#include <algorithm>
#include <cstring>
#include <cmath>
#include <limits>
#include <random>
#include <iostream>
#include <cassert>
#include "hnswlib/hnswlib/hnswlib.h"
#include "simd_utils.h"

using namespace hnswlib;

// ─────────────────────────────────────────────────────────────────────
// NEON SIMD L2 距离（粗排：query → 簇心，与 ivf_hnsw.h 保持一致）
// ─────────────────────────────────────────────────────────────────────
static inline float ivfhnsw_mpi_l2sq(const float* a, const float* b,
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
    for (; i < dim; ++i) { float d = a[i] - b[i]; s += d * d; }
    return s;
}

// ─────────────────────────────────────────────────────────────────────
// 堆工具
// ─────────────────────────────────────────────────────────────────────
using IVFHNSWMPIPair = std::pair<float, uint32_t>;
using IVFHNSWMPIHeap = std::priority_queue<IVFHNSWMPIPair>;

static inline void ivfhnsw_mpi_heap_push(IVFHNSWMPIHeap& h, float d,
                                           uint32_t id, size_t p) {
    if (h.size() < p)             h.emplace(d, id);
    else if (d < h.top().first) { h.pop(); h.emplace(d, id); }
}

// 缓存行对齐的线程私有堆
struct alignas(64) AlignedIVFHNSWHeap {
    IVFHNSWMPIHeap h;
};

// ═════════════════════════════════════════════════════════════════════
// IVFHNSWMPIIndex — IVF-HNSW 嵌套索引 + MPI 分布式检索类
// ═════════════════════════════════════════════════════════════════════
class IVFHNSWMPIIndex {
public:
    IVFHNSWMPIIndex()
        : rank_(0), size_(1), dim_(0), nlist_(0), N_(0),
          M_(16), ef_construction_(150) {
        MPI_Comm_rank(MPI_COMM_WORLD, &rank_);
        MPI_Comm_size(MPI_COMM_WORLD, &size_);
    }

    ~IVFHNSWMPIIndex() { clear_local_index_(); }

    // ─────────────────────────────────────────────────────────────────
    // build_distributed
    //
    //   0 号进程执行：
    //     1. K-Means 聚类（OpenMP 并行 E-step）
    //     2. 全量数据分配到最近桶
    //     3. 按桶级块划分，将各桶数据 MPI_Send 给对应进程
    //     4. 0 号进程自身保留第 0 块
    //
    //   所有进程：
    //     - 接收本进程拥有的桶数据
    //     - OpenMP 并行为每个本地桶构建 HNSW 子索引
    //
    //   参数：
    //     nlist          : IVF 桶数（建议 4~16 × sqrt(N/P)）
    //     M              : HNSW 每节点最大邻居数（建议 16~32）
    //     ef_construction: HNSW 建图 ef（建议 100~200）
    //     kmeans_iter    : K-Means 迭代次数
    // ─────────────────────────────────────────────────────────────────
    void build_distributed(const float* base, size_t n, size_t d,
                            size_t nlist,
                            int    M             = 16,
                            int    ef_construction = 150,
                            int    kmeans_iter   = 20) {
        dim_             = d;
        nlist_           = nlist;
        M_               = M;
        ef_construction_ = ef_construction;

        // ── 广播元信息 ───────────────────────────────────────────────
        N_ = n;
        MPI_Bcast(&N_,      1, MPI_UNSIGNED_LONG_LONG, 0, MPI_COMM_WORLD);
        MPI_Bcast(&dim_,    1, MPI_UNSIGNED_LONG_LONG, 0, MPI_COMM_WORLD);
        MPI_Bcast(&nlist_,  1, MPI_UNSIGNED_LONG_LONG, 0, MPI_COMM_WORLD);

        // 每进程拥有的桶范围
        size_t chunk = (nlist_ + size_ - 1) / size_;
        local_c_start_ = (size_t)rank_ * chunk;
        local_c_end_   = std::min(local_c_start_ + chunk, nlist_);
        size_t local_nc = local_c_end_ - local_c_start_;

        centroids_.resize(nlist_ * dim_);

        // ── 0 号进程：K-Means 训练 + 分配 + 分发 ────────────────────
        if (rank_ == 0) {
            std::cout << "[IVF-HNSW-MPI Rank 0] K-Means: nlist=" << nlist_
                      << "  N=" << N_ << "  dim=" << dim_
                      << "  P=" << size_ << std::endl;

            kmeans_train_(base, N_, kmeans_iter);

            // 全量数据分配到最近桶
            std::cout << "[IVF-HNSW-MPI Rank 0] Assigning vectors..."
                      << std::endl;
            std::vector<int> assign(N_);
            assign_to_clusters_(base, N_, assign);

            // 整理每桶的 (global_id, 向量) 列表
            std::vector<std::vector<uint32_t>>  bucket_ids(nlist_);
            std::vector<std::vector<float>>     bucket_vecs(nlist_);
            for (size_t i = 0; i < N_; ++i) {
                int c = assign[i];
                bucket_ids[c].push_back((uint32_t)i);
                bucket_vecs[c].insert(bucket_vecs[c].end(),
                                      base + i * dim_,
                                      base + i * dim_ + dim_);
            }

            {   // 打印桶大小统计
                size_t mx = 0, mn = N_, tot = 0;
                for (size_t c = 0; c < nlist_; ++c) {
                    mx  = std::max(mx, bucket_ids[c].size());
                    mn  = std::min(mn, bucket_ids[c].size());
                    tot += bucket_ids[c].size();
                }
                std::cout << "[IVF-HNSW-MPI Rank 0] Bucket stats: max="
                          << mx << " min=" << mn << " avg=" << tot / nlist_
                          << std::endl;
            }

            // 广播簇心数组（所有进程的粗排都需要全量簇心）
            MPI_Bcast(centroids_.data(), (int)(nlist_ * dim_),
                      MPI_FLOAT, 0, MPI_COMM_WORLD);

            // 分发各进程拥有的桶数据
            for (int dst = 1; dst < size_; ++dst) {
                size_t dst_start = (size_t)dst * chunk;
                size_t dst_end   = std::min(dst_start + chunk, nlist_);

                // 构造打包消息
                std::vector<char> buf = pack_buckets_(
                    bucket_ids, bucket_vecs, dst_start, dst_end);
                int buf_sz = (int)buf.size();
                MPI_Send(&buf_sz, 1, MPI_INT, dst, 100, MPI_COMM_WORLD);
                MPI_Send(buf.data(), buf_sz, MPI_BYTE, dst, 101,
                         MPI_COMM_WORLD);
            }

            // 0 号进程自身建索引（桶 [0, local_c_end_)）
            std::cout << "[IVF-HNSW-MPI Rank 0] Building local HNSW "
                      << "sub-indexes for " << local_nc << " buckets..."
                      << std::endl;
            build_local_hnsw_(bucket_ids, bucket_vecs,
                               local_c_start_, local_c_end_);

        } else {
            // 非 0 进程：接收簇心
            MPI_Bcast(centroids_.data(), (int)(nlist_ * dim_),
                      MPI_FLOAT, 0, MPI_COMM_WORLD);

            // 接收分配给本进程的桶数据
            int buf_sz = 0;
            MPI_Recv(&buf_sz, 1, MPI_INT, 0, 100, MPI_COMM_WORLD,
                     MPI_STATUS_IGNORE);
            std::vector<char> buf(buf_sz);
            MPI_Recv(buf.data(), buf_sz, MPI_BYTE, 0, 101, MPI_COMM_WORLD,
                     MPI_STATUS_IGNORE);

            std::vector<std::vector<uint32_t>> bucket_ids;
            std::vector<std::vector<float>>    bucket_vecs;
            unpack_buckets_(buf, bucket_ids, bucket_vecs);

            std::cout << "[IVF-HNSW-MPI Rank " << rank_
                      << "] Building local HNSW sub-indexes for "
                      << local_nc << " buckets..." << std::endl;
            build_local_hnsw_(bucket_ids, bucket_vecs, 0, local_nc);
        }

        // 统计本进程持有的向量总数
        size_t local_total = 0;
        for (size_t i = 0; i < local_nc; ++i) {
            if (local_spaces_[i])
                local_total += local_hnsw_[i]->cur_element_count;
        }
        std::cout << "[IVF-HNSW-MPI Rank " << rank_
                  << "] Owns " << local_nc << " buckets, "
                  << local_total << " vectors total" << std::endl;
    }

    // ─────────────────────────────────────────────────────────────────
    // search — IVF-HNSW-MPI 分布式检索
    //
    //   所有进程同步调用。query 在 0 号进程有效。
    //
    //   流程：
    //     [Phase 1] Bcast query
    //     [Phase 2] 各进程 NEON SIMD 粗排（全量 nlist 簇心）
    //     [Phase 3] 各进程 OpenMP 精排（本进程拥有的 top-nprobe 桶）
    //     [Phase 4] 线程 Reduce → 进程级堆
    //     [Phase 5] MPI_Gatherv → 0 号进程全局归并
    //
    //   参数：
    //     k         : 返回最近邻数
    //     nprobe    : 粗排选取的桶数（控制精度/速度）
    //     ef_search : 每桶 HNSW 搜索的候选队列大小
    //     local_p   : 进程级局部堆大小（>= k）
    // ─────────────────────────────────────────────────────────────────
    IVFHNSWMPIHeap search(const float* query, size_t k,
                           size_t nprobe,
                           size_t ef_search = 0,
                           size_t local_p   = 0) const {
        if (ef_search < k) ef_search = k;
        if (local_p   < k) local_p   = k;
        nprobe = std::min(nprobe, nlist_);

        // ── Phase 1: 广播查询 ────────────────────────────────────────
        std::vector<float> q_buf(dim_);
        if (rank_ == 0)
            std::memcpy(q_buf.data(), query, dim_ * sizeof(float));
        MPI_Bcast(q_buf.data(), (int)dim_, MPI_FLOAT, 0, MPI_COMM_WORLD);

        // ── Phase 2: NEON SIMD 粗排（各进程独立计算，结果一致）──────
        std::vector<std::pair<float, size_t>> coarse(nlist_);
        #pragma omp parallel for schedule(static)
        for (int c = 0; c < (int)nlist_; ++c) {
            float d2 = ivfhnsw_mpi_l2sq(q_buf.data(),
                                          centroids_.data() + c * dim_,
                                          dim_);
            coarse[c] = {d2, (size_t)c};
        }
        std::partial_sort(coarse.begin(), coarse.begin() + nprobe,
                          coarse.end());

        // 找出本进程拥有的、在 top-nprobe 中的桶（本地偏移）
        std::vector<std::pair<size_t, size_t>> local_probes;
        // local_probes[i] = (global_cid, local_bucket_idx)
        for (size_t pi = 0; pi < nprobe; ++pi) {
            size_t cid = coarse[pi].second;
            if (cid >= local_c_start_ && cid < local_c_end_) {
                size_t local_idx = cid - local_c_start_;
                local_probes.push_back({cid, local_idx});
            }
        }

        // ── Phase 3: OpenMP 并行精排本地桶 ──────────────────────────
        int num_threads = omp_get_max_threads();
        std::vector<AlignedIVFHNSWHeap> thread_heaps((size_t)num_threads);

        int n_local = (int)local_probes.size();

        #pragma omp parallel for schedule(dynamic, 1)
        for (int pi = 0; pi < n_local; ++pi) {
            size_t local_idx = local_probes[pi].second;
            int    tid        = omp_get_thread_num();

            if (!local_hnsw_[local_idx] ||
                local_hnsw_[local_idx]->cur_element_count == 0) continue;

            local_hnsw_[local_idx]->setEf(ef_search);
            auto local_res = local_hnsw_[local_idx]->searchKnn(
                q_buf.data(), local_p);

            IVFHNSWMPIHeap& lh = thread_heaps[tid].h;
            const auto& id_map = local_id_maps_[local_idx];

            while (!local_res.empty()) {
                auto top       = local_res.top(); local_res.pop();
                labeltype lidx = top.second;
                if ((size_t)lidx >= id_map.size()) continue;
                uint32_t gid = id_map[lidx];
                ivfhnsw_mpi_heap_push(lh, top.first, gid, local_p);
            }
        }

        // ── Phase 4: 线程 Reduce → 进程级堆 ─────────────────────────
        IVFHNSWMPIHeap proc_heap;
        for (int t = 0; t < num_threads; ++t) {
            IVFHNSWMPIHeap& lh = thread_heaps[t].h;
            while (!lh.empty()) {
                ivfhnsw_mpi_heap_push(proc_heap, lh.top().first,
                                       lh.top().second, local_p);
                lh.pop();
            }
        }
        while (proc_heap.size() > k) proc_heap.pop();

        // ── Phase 5: MPI Gatherv + 全局归并 ─────────────────────────
        int local_count = (int)proc_heap.size();
        std::vector<float>    ld(local_count);
        std::vector<uint32_t> li(local_count);
        for (int i = local_count - 1; i >= 0; --i) {
            ld[i] = proc_heap.top().first;
            li[i] = proc_heap.top().second;
            proc_heap.pop();
        }

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

        IVFHNSWMPIHeap result;
        if (rank_ == 0)
            for (int i = 0; i < (int)all_dists.size(); ++i)
                ivfhnsw_mpi_heap_push(result, all_dists[i], all_ids[i], k);
        return result;
    }

    // ─────────────────────────────────────────────────────────────────
    // search_rerank — 带精排（Rerank）的两阶段检索
    //
    //   Stage 1: 先用宽松的 ef_coarse（较小）做全进程 HNSW 路由，
    //            各进程收集 n_cand（>= k * rerank_mult）个候选
    //   Stage 2: 0 号进程收集全部候选，用 InnerProductSIMD 精算距离，
    //            返回真正的 top-k
    //
    //   适用场景：
    //     nprobe 较小（召回粗筛偏差较大）+ 需要高精度最终结果
    //     代价：Stage 2 在 0 号进程串行，适合 k 较小的情况
    // ─────────────────────────────────────────────────────────────────
    IVFHNSWMPIHeap search_rerank(const float* query, size_t k,
                                  size_t nprobe,
                                  size_t ef_coarse      = 0,
                                  size_t rerank_mult    = 4,
                                  const float* base_ptr = nullptr) const {
        // Stage 1: 粗检索，收集 k * rerank_mult 个候选
        size_t n_cand = k * rerank_mult;
        if (ef_coarse < n_cand) ef_coarse = n_cand;

        auto cand_heap = search(query, n_cand, nprobe, ef_coarse, n_cand);

        // Stage 2: 只在 0 号进程对候选用 SIMD 精算
        if (rank_ != 0 || !base_ptr) return cand_heap;

        std::vector<float>    q_buf(dim_);
        std::memcpy(q_buf.data(), query, dim_ * sizeof(float));

        IVFHNSWMPIHeap result;
        while (!cand_heap.empty()) {
            uint32_t gid   = cand_heap.top().second;
            cand_heap.pop();
            const float* v = base_ptr + (size_t)gid * dim_;
            float dist     = InnerProductSIMD(v, q_buf.data(), dim_);
            ivfhnsw_mpi_heap_push(result, dist, gid, k);
        }
        return result;
    }

    int    rank()     const { return rank_; }
    int    mpi_size() const { return size_; }
    size_t nlist()    const { return nlist_; }
    size_t n()        const { return N_; }

private:
    // ─────────────────────────────────────────────────────────────────
    // K-Means 训练（与 ivf_hnsw.h kmeans_train 完全一致）
    // ─────────────────────────────────────────────────────────────────
    void kmeans_train_(const float* base, size_t n, int max_iter) {
        centroids_.assign(nlist_ * dim_, 0.f);

        // KMeans++ 初始化（最大化初始离散度）
        {
            std::mt19937 rng(42);
            std::uniform_int_distribution<size_t> uid(0, n - 1);
            std::memcpy(centroids_.data(),
                        base + uid(rng) * dim_,
                        dim_ * sizeof(float));
            std::vector<float> min_dists(n, std::numeric_limits<float>::max());
            for (size_t ci = 1; ci < nlist_; ++ci) {
                const float* last = centroids_.data() + (ci - 1) * dim_;
                for (size_t i = 0; i < n; ++i) {
                    float d = ivfhnsw_mpi_l2sq(base + i * dim_, last, dim_);
                    if (d < min_dists[i]) min_dists[i] = d;
                }
                std::discrete_distribution<size_t> dd(
                    min_dists.begin(), min_dists.end());
                size_t pick = dd(rng);
                std::memcpy(centroids_.data() + ci * dim_,
                            base + pick * dim_, dim_ * sizeof(float));
            }
        }

        std::vector<int>   assign(n);
        std::vector<float> new_c(nlist_ * dim_);
        std::vector<int>   cnt(nlist_);

        for (int iter = 0; iter < max_iter; ++iter) {
            // E-step: OpenMP 并行分配
            #pragma omp parallel for schedule(static)
            for (int i = 0; i < (int)n; ++i) {
                float md = std::numeric_limits<float>::max(); int bk = 0;
                const float* v = base + (size_t)i * dim_;
                for (size_t c = 0; c < nlist_; ++c) {
                    float d = ivfhnsw_mpi_l2sq(
                        v, centroids_.data() + c * dim_, dim_);
                    if (d < md) { md = d; bk = (int)c; }
                }
                assign[i] = bk;
            }
            // M-step
            std::fill(new_c.begin(), new_c.end(), 0.f);
            std::fill(cnt.begin(), cnt.end(), 0);
            for (size_t i = 0; i < n; ++i) {
                int c = assign[i]; cnt[c]++;
                for (size_t d = 0; d < dim_; ++d)
                    new_c[c * dim_ + d] += base[i * dim_ + d];
            }
            float max_shift = 0.f;
            for (size_t c = 0; c < nlist_; ++c) {
                if (cnt[c] == 0) continue;
                for (size_t d = 0; d < dim_; ++d) {
                    float nv   = new_c[c * dim_ + d] / cnt[c];
                    float diff = nv - centroids_[c * dim_ + d];
                    max_shift  = std::max(max_shift, std::abs(diff));
                    centroids_[c * dim_ + d] = nv;
                }
            }
            std::cout << "[IVF-HNSW-MPI Rank 0] K-Means iter " << iter + 1
                      << "  max_shift=" << max_shift << std::endl;
            if (max_shift < 1e-5f) {
                std::cout << "[IVF-HNSW-MPI Rank 0] K-Means converged."
                          << std::endl;
                break;
            }
        }
    }

    // 全量数据分配到最近桶（OpenMP 并行）
    void assign_to_clusters_(const float* base, size_t n,
                              std::vector<int>& assign) {
        assign.resize(n);
        #pragma omp parallel for schedule(static)
        for (int i = 0; i < (int)n; ++i) {
            float md = std::numeric_limits<float>::max(); int bk = 0;
            const float* v = base + (size_t)i * dim_;
            for (size_t c = 0; c < nlist_; ++c) {
                float d = ivfhnsw_mpi_l2sq(
                    v, centroids_.data() + c * dim_, dim_);
                if (d < md) { md = d; bk = (int)c; }
            }
            assign[i] = bk;
        }
    }

    // ─────────────────────────────────────────────────────────────────
    // build_local_hnsw_ — OpenMP 并行为本进程的桶构建 HNSW
    //
    //   0 号进程直接传入全量 bucket_ids/bucket_vecs
    //   非 0 进程传入 unpack 之后的局部桶列表（局部偏移 0 ~ local_nc-1）
    // ─────────────────────────────────────────────────────────────────
    void build_local_hnsw_(
        const std::vector<std::vector<uint32_t>>& bucket_ids,
        const std::vector<std::vector<float>>&    bucket_vecs,
        size_t c_start, size_t c_end)
    {
        size_t nc = c_end - c_start;
        clear_local_index_();
        local_spaces_.resize(nc, nullptr);
        local_hnsw_.resize(nc, nullptr);
        local_id_maps_.resize(nc);

        #pragma omp parallel for schedule(dynamic, 1)
        for (int li = 0; li < (int)nc; ++li) {
            size_t sz = bucket_ids[li + c_start].size();
            if (sz == 0) continue;

            local_spaces_[li] = new InnerProductSpace(dim_);
            local_hnsw_[li]   = new HierarchicalNSW<float>(
                local_spaces_[li],
                std::max(sz, (size_t)1),
                M_, ef_construction_);

            local_id_maps_[li].resize(sz);
            const auto& ids  = bucket_ids[li + c_start];
            const auto& vecs = bucket_vecs[li + c_start];

            for (size_t j = 0; j < sz; ++j) {
                // 预取下个向量
                if (j + 1 < sz)
                    __builtin_prefetch(vecs.data() + (j + 1) * dim_, 0, 3);
                local_hnsw_[li]->addPoint(
                    vecs.data() + j * dim_, (labeltype)j);
                local_id_maps_[li][j] = ids[j];
            }
        }
    }

    // ─────────────────────────────────────────────────────────────────
    // 序列化打包工具（0 号进程 → 各目标进程）
    //
    // 消息格式：
    //   [n_buckets : uint32_t]
    //   per bucket:
    //     [n_vec    : uint32_t]
    //     [ids      : uint32_t[n_vec]]
    //     [vecs     : float[n_vec × dim]]
    // ─────────────────────────────────────────────────────────────────
    std::vector<char> pack_buckets_(
        const std::vector<std::vector<uint32_t>>& bucket_ids,
        const std::vector<std::vector<float>>&    bucket_vecs,
        size_t c_start, size_t c_end) const
    {
        size_t nc = c_end - c_start;
        size_t total = sizeof(uint32_t);   // n_buckets
        for (size_t c = c_start; c < c_end; ++c) {
            total += sizeof(uint32_t);                          // n_vec
            total += bucket_ids[c].size()  * sizeof(uint32_t); // ids
            total += bucket_vecs[c].size() * sizeof(float);    // vecs
        }

        std::vector<char> buf(total);
        char* ptr = buf.data();

        uint32_t nb = (uint32_t)nc;
        std::memcpy(ptr, &nb, sizeof(uint32_t)); ptr += sizeof(uint32_t);

        for (size_t c = c_start; c < c_end; ++c) {
            uint32_t nv = (uint32_t)bucket_ids[c].size();
            std::memcpy(ptr, &nv, sizeof(uint32_t)); ptr += sizeof(uint32_t);

            std::memcpy(ptr, bucket_ids[c].data(),
                        nv * sizeof(uint32_t));
            ptr += nv * sizeof(uint32_t);

            std::memcpy(ptr, bucket_vecs[c].data(),
                        (size_t)nv * dim_ * sizeof(float));
            ptr += (size_t)nv * dim_ * sizeof(float);
        }
        return buf;
    }

    void unpack_buckets_(
        const std::vector<char>&           buf,
        std::vector<std::vector<uint32_t>>& bucket_ids,
        std::vector<std::vector<float>>&    bucket_vecs) const
    {
        const char* ptr = buf.data();
        uint32_t nb;
        std::memcpy(&nb, ptr, sizeof(uint32_t)); ptr += sizeof(uint32_t);

        bucket_ids.resize(nb);
        bucket_vecs.resize(nb);

        for (uint32_t i = 0; i < nb; ++i) {
            uint32_t nv;
            std::memcpy(&nv, ptr, sizeof(uint32_t)); ptr += sizeof(uint32_t);

            bucket_ids[i].resize(nv);
            std::memcpy(bucket_ids[i].data(), ptr, nv * sizeof(uint32_t));
            ptr += nv * sizeof(uint32_t);

            bucket_vecs[i].resize((size_t)nv * dim_);
            std::memcpy(bucket_vecs[i].data(), ptr,
                        (size_t)nv * dim_ * sizeof(float));
            ptr += (size_t)nv * dim_ * sizeof(float);
        }
    }

    void clear_local_index_() {
        for (auto* p : local_hnsw_)   { delete p; }
        for (auto* p : local_spaces_) { delete p; }
        local_hnsw_.clear();
        local_spaces_.clear();
        local_id_maps_.clear();
    }

    int    rank_, size_;
    size_t dim_, nlist_, N_;
    int    M_, ef_construction_;
    size_t local_c_start_, local_c_end_;  // 本进程拥有的全局桶范围

    std::vector<float> centroids_;   // [nlist × dim]（每进程均有完整副本，用于粗排）

    // 本进程拥有的局部桶 HNSW（下标 = 局部偏移，非全局 cid）
    std::vector<InnerProductSpace*>      local_spaces_;
    std::vector<HierarchicalNSW<float>*> local_hnsw_;
    std::vector<std::vector<uint32_t>>   local_id_maps_;  // local_label → global_id
};
