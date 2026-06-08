#pragma once
/**
 * ivf_mpi_omp.h  —  IVF + MPI + OpenMP 三级并行检索
 * =====================================================================
 * 对应任务 B：IVF + MPI + OpenMP 多线程并行头文件
 *
 * 三级并行层次：
 *   Level 1 (MPI 进程间)  : 簇级块划分，P 个进程各处理 nlist/P 个倒排桶
 *   Level 2 (OpenMP 进程内): 进程内 T 个线程并行扫描本进程拥有的倒排桶
 *   Level 3 (数据预取)    : __builtin_prefetch 预热 L1 缓存，降低内存访问延迟
 *
 * OpenMP 调度策略对比（设计决策）：
 *   粗排阶段: schedule(static)   — nlist 个簇心距离计算等量，静态分发减少调度开销
 *   精排阶段: schedule(dynamic,1) — 桶长存在偏态，动态单桶粒度自适应负载均衡
 *
 * 与 ivf_mpi_simd.h 的区别：
 *   ivf_mpi_simd.h — 进程内串行扫描 + SIMD 内积加速（单线程 SIMD）
 *   ivf_mpi_omp.h  — 进程内多线程 + 标量内积（OMP 并行，无 SIMD）
 *
 * 与 ivf_mpi_hybrid.h 的区别：
 *   ivf_mpi_hybrid.h — MPI + OpenMP dynamic + SIMD 三者融合（完全体）
 *   ivf_mpi_omp.h    — MPI + OpenMP，不使用 SIMD（纯 OMP 并行语义清晰）
 *
 * 设计要点：
 *   1. 每个 OpenMP 线程维护私有局部堆（避免锁竞争）
 *   2. alignas(64) 强制堆结构独占缓存行（消除伪共享）
 *   3. 精排后 Reduce：各线程局部堆归并成进程级堆，再 MPI_Gatherv 汇聚
 *
 * 编译：
 *   mpicxx -std=c++11 -O3 -fopenmp ...
 *   OMP_NUM_THREADS=4 mpirun -np 4 ./main_mpi --mode ivf_omp
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

// 复用 ivf_mpi.h 中的工具函数（独立编译时直接内联，避免重复定义）
#ifndef IVF_MPI_TOOLS_DEFINED
#define IVF_MPI_TOOLS_DEFINED

// ─────────────────────────────────────────────────────────────────────
// 堆工具
// ─────────────────────────────────────────────────────────────────────
using IVFOMPPair = std::pair<float, uint32_t>;
using IVFOMPHeap = std::priority_queue<IVFOMPPair>;

static inline void ivf_omp_heap_push(IVFOMPHeap& h, float d,
                                      uint32_t id, size_t p) {
    if (h.size() < p)             h.emplace(d, id);
    else if (d < h.top().first) { h.pop(); h.emplace(d, id); }
}

// 标量内积距离
static inline float ivf_omp_ip(const float* a, const float* b, size_t dim) {
    float ip = 0.0f;
    for (size_t i = 0; i < dim; ++i) ip += a[i] * b[i];
    return 1.0f - ip;
}

// 标量 L2 距离（粗排用）
static inline float ivf_omp_l2sq(const float* a, const float* b, size_t dim) {
    float s = 0.0f;
    for (size_t i = 0; i < dim; ++i) {
        float df = a[i] - b[i];
        s += df * df;
    }
    return s;
}

// KMeans++ 训练（与 ivf_mpi.h 中的实现相同）
static void ivf_omp_kmeans(const float* data, size_t n, size_t dim,
                             size_t K, int max_iter, float* centroids) {
    std::mt19937 rng(42);

    {
        std::uniform_int_distribution<size_t> uid(0, n - 1);
        size_t first = uid(rng);
        std::memcpy(centroids, data + first * dim, dim * sizeof(float));
    }

    std::vector<float> min_dists(n, std::numeric_limits<float>::max());
    for (size_t ci = 1; ci < K; ++ci) {
        const float* last = centroids + (ci - 1) * dim;
        for (size_t i = 0; i < n; ++i) {
            float d = ivf_omp_l2sq(data + i * dim, last, dim);
            if (d < min_dists[i]) min_dists[i] = d;
        }
        std::discrete_distribution<size_t> dd(min_dists.begin(),
                                               min_dists.end());
        size_t pick = dd(rng);
        std::memcpy(centroids + ci * dim, data + pick * dim,
                    dim * sizeof(float));
    }

    std::vector<int>   assign(n);
    std::vector<float> new_centers(K * dim);
    std::vector<int>   counts(K);

    for (int iter = 0; iter < max_iter; ++iter) {
        for (size_t i = 0; i < n; ++i) {
            float md = std::numeric_limits<float>::max();
            int   bk = 0;
            const float* v = data + i * dim;
            for (size_t c = 0; c < K; ++c) {
                float d = ivf_omp_l2sq(v, centroids + c * dim, dim);
                if (d < md) { md = d; bk = (int)c; }
            }
            assign[i] = bk;
        }
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

// 序列化倒排列表
static void ivf_omp_pack(
    const std::vector<std::vector<float>>&    inv_vecs,
    const std::vector<std::vector<uint32_t>>& inv_ids,
    const std::vector<int>&                   owned_cids,
    size_t dim, std::vector<char>& buf)
{
    size_t total = sizeof(int);
    for (int cid : owned_cids) {
        total += sizeof(int) * 2;
        total += inv_ids[cid].size() * dim * sizeof(float);
        total += inv_ids[cid].size() * sizeof(uint32_t);
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

static void ivf_omp_unpack(
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
        std::memcpy(inv_vecs[cid].data(), ptr,
                    (size_t)nv * dim * sizeof(float));
        ptr += (size_t)nv * dim * sizeof(float);

        inv_ids[cid].resize((size_t)nv);
        std::memcpy(inv_ids[cid].data(), ptr, (size_t)nv * sizeof(uint32_t));
        ptr += (size_t)nv * sizeof(uint32_t);
    }
}

#endif  // IVF_MPI_TOOLS_DEFINED

// ─────────────────────────────────────────────────────────────────────
// 缓存行对齐的线程私有堆（消除伪共享）
// ─────────────────────────────────────────────────────────────────────
struct alignas(64) AlignedOMPHeap {
    IVFOMPHeap h;
};

// ═════════════════════════════════════════════════════════════════════
// IVFMPIOpenMP — IVF + MPI + OpenMP 三级并行检索类
// ═════════════════════════════════════════════════════════════════════
class IVFMPIOpenMP {
public:
    IVFMPIOpenMP() : rank_(0), size_(1), nlist_(0), dim_(0), N_(0) {
        MPI_Comm_rank(MPI_COMM_WORLD, &rank_);
        MPI_Comm_size(MPI_COMM_WORLD, &size_);
    }

    ~IVFMPIOpenMP() = default;

    // ─────────────────────────────────────────────────────────────────
    // build_distributed — 与 IVFMPI::build_distributed 完全相同
    //   0 号进程：KMeans++ 训练 → 构建倒排列表 → 分发
    //   所有进程：接收本进程倒排列表分区
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
            std::cout << "[IVF-MPI-OMP Rank 0] Building distributed IVF index\n"
                      << "  nlist=" << nlist_
                      << "  N=" << N_
                      << "  dim=" << dim_
                      << "  OMP threads=" << omp_get_max_threads()
                      << std::endl;

            size_t train_n = std::min(N_, (size_t)50000);
            ivf_omp_kmeans(base, train_n, dim_, nlist_, kmeans_iter,
                           centroids_.data());

            std::cout << "[IVF-MPI-OMP Rank 0] Building inverted lists..." << std::endl;
            for (size_t i = 0; i < N_; ++i) {
                const float* v = base + i * dim_;
                float md = std::numeric_limits<float>::max();
                size_t best = 0;
                for (size_t c = 0; c < nlist_; ++c) {
                    float d2 = ivf_omp_l2sq(v, centroids_.data() + c * dim_,
                                             dim_);
                    if (d2 < md) { md = d2; best = c; }
                }
                inv_vecs_[best].insert(inv_vecs_[best].end(), v, v + dim_);
                inv_ids_[best].push_back((uint32_t)i);
            }
        }

        MPI_Bcast(centroids_.data(), (int)(nlist_ * dim_), MPI_FLOAT,
                  0, MPI_COMM_WORLD);

        size_t chunk = (nlist_ + size_ - 1) / size_;
        {
            size_t c_start = (size_t)rank_ * chunk;
            size_t c_end   = std::min(c_start + chunk, nlist_);
            owned_cids_.clear();
            for (size_t c = c_start; c < c_end; ++c)
                owned_cids_.push_back((int)c);
        }

        if (rank_ == 0) {
            for (int dst = 1; dst < size_; ++dst) {
                size_t dst_start = (size_t)dst * chunk;
                size_t dst_end   = std::min(dst_start + chunk, nlist_);
                std::vector<int> dst_cids;
                for (size_t c = dst_start; c < dst_end; ++c)
                    dst_cids.push_back((int)c);

                std::vector<char> buf;
                ivf_omp_pack(inv_vecs_, inv_ids_, dst_cids, dim_, buf);

                int buf_sz = (int)buf.size();
                MPI_Send(&buf_sz, 1, MPI_INT, dst, 20, MPI_COMM_WORLD);
                MPI_Send(buf.data(), buf_sz, MPI_BYTE, dst, 21,
                         MPI_COMM_WORLD);
            }

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
            MPI_Recv(&buf_sz, 1, MPI_INT, 0, 20, MPI_COMM_WORLD,
                     MPI_STATUS_IGNORE);
            std::vector<char> buf(buf_sz);
            MPI_Recv(buf.data(), buf_sz, MPI_BYTE, 0, 21, MPI_COMM_WORLD,
                     MPI_STATUS_IGNORE);
            ivf_omp_unpack(buf.data(), dim_, nlist_,
                           inv_vecs_, inv_ids_, owned_cids_);
        }
    }

    // ─────────────────────────────────────────────────────────────────
    // search_omp — IVF + MPI + OpenMP 分布式检索
    //
    //   OpenMP 并行策略：
    //     粗排 (coarse)  : schedule(static)   — 簇心数量固定均匀，局部性好
    //     精排 (fine)    : schedule(dynamic,1) — 桶长偏态，单桶粒度自适应
    //
    //   线程私有数据：
    //     AlignedOMPHeap — 缓存行对齐的私有局部堆，消除伪共享
    //
    //   归并流程：
    //     线程局部堆 → reduce → 进程级堆 → MPI_Gatherv → 全局归并
    // ─────────────────────────────────────────────────────────────────
    IVFOMPHeap search_omp(const float* query, size_t k,
                           size_t nprobe, size_t p = 0) const {
        if (p < k) p = k;
        nprobe = std::min(nprobe, nlist_);

        int num_threads = omp_get_max_threads();

        // ── 1. 广播查询向量 ──────────────────────────────────────────
        std::vector<float> q_buf(dim_);
        if (rank_ == 0)
            std::memcpy(q_buf.data(), query, dim_ * sizeof(float));
        MPI_Bcast(q_buf.data(), (int)dim_, MPI_FLOAT, 0, MPI_COMM_WORLD);

        // ── 2. 粗排：OpenMP static 并行计算所有簇心距离 ─────────────
        //   每个线程处理连续一段簇心，共享读取簇心数据（无写冲突）
        std::vector<std::pair<float, size_t>> coarse(nlist_);

        #pragma omp parallel for schedule(static)
        for (int c = 0; c < (int)nlist_; ++c) {
            float d2 = ivf_omp_l2sq(q_buf.data(),
                                     centroids_.data() + c * dim_, dim_);
            coarse[c] = {d2, (size_t)c};
        }

        // partial_sort 不能并行，但 nlist 通常只有 1024，开销可忽略
        std::partial_sort(coarse.begin(), coarse.begin() + nprobe,
                          coarse.end());

        // 收集本进程需要扫描的倒排桶（owned && in top-nprobe）
        std::vector<int> local_probe_cids;
        local_probe_cids.reserve(nprobe);
        for (size_t i = 0; i < nprobe; ++i) {
            size_t cid = coarse[i].second;
            for (int oc : owned_cids_)
                if ((size_t)oc == cid) {
                    local_probe_cids.push_back((int)cid);
                    break;
                }
        }

        // ── 3. 精排：OpenMP dynamic 并行扫描本进程倒排桶 ────────────
        //   每个线程拥有一个私有局部堆，避免锁竞争
        //   schedule(dynamic,1)：单桶粒度调度，适应偏态桶长分布
        std::vector<AlignedOMPHeap> thread_heaps((size_t)num_threads);

        int n_local_probes = (int)local_probe_cids.size();

        #pragma omp parallel
        {
            int tid = omp_get_thread_num();
            IVFOMPHeap& local_h = thread_heaps[tid].h;

            #pragma omp for schedule(dynamic, 1)
            for (int probe_i = 0; probe_i < n_local_probes; ++probe_i) {
                int cid = local_probe_cids[probe_i];
                size_t n_vec = inv_ids_[cid].size();
                const float* vecs = inv_vecs_[cid].data();

                for (size_t j = 0; j < n_vec; ++j) {
                    // 预取下下个向量（跨越 L1→L2 延迟）
                    if (j + 2 < n_vec)
                        __builtin_prefetch(vecs + (j + 2) * dim_, 0, 3);

                    float dist = ivf_omp_ip(vecs + j * dim_,
                                             q_buf.data(), dim_);
                    ivf_omp_heap_push(local_h, dist,
                                       inv_ids_[cid][j], p);
                }
            }
        }  // implicit OpenMP barrier

        // ── 4. 线程 Reduce → 进程级堆 ───────────────────────────────
        //   串行归并各线程私有堆，得到进程级 top-k 堆
        IVFOMPHeap proc_heap;
        for (int t = 0; t < num_threads; ++t) {
            IVFOMPHeap& lh = thread_heaps[t].h;
            while (!lh.empty()) {
                ivf_omp_heap_push(proc_heap, lh.top().first,
                                   lh.top().second, p);
                lh.pop();
            }
        }
        while (proc_heap.size() > k) proc_heap.pop();

        // ── 5. 序列化进程级 top-k ────────────────────────────────────
        int local_count = (int)proc_heap.size();
        std::vector<float>    ld(local_count);
        std::vector<uint32_t> li(local_count);
        for (int i = local_count - 1; i >= 0; --i) {
            ld[i] = proc_heap.top().first;
            li[i] = proc_heap.top().second;
            proc_heap.pop();
        }

        // ── 6. Gather 结果数量 ───────────────────────────────────────
        std::vector<int> all_counts(size_);
        MPI_Gather(&local_count, 1, MPI_INT,
                   all_counts.data(), 1, MPI_INT, 0, MPI_COMM_WORLD);

        // ── 7. Gatherv (dist, id) ────────────────────────────────────
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

        // ── 8. 0 号进程全局归并 ──────────────────────────────────────
        IVFOMPHeap result;
        if (rank_ == 0) {
            for (int i = 0; i < (int)all_dists.size(); ++i)
                ivf_omp_heap_push(result, all_dists[i], all_ids[i], k);
        }
        return result;
    }

    // ─────────────────────────────────────────────────────────────────
    // search_omp_static — OpenMP static 调度版本（对比基准）
    //   适用于倒排桶长分布均匀的场景（桶长方差小时优于 dynamic）
    // ─────────────────────────────────────────────────────────────────
    IVFOMPHeap search_omp_static(const float* query, size_t k,
                                  size_t nprobe) const {
        nprobe = std::min(nprobe, nlist_);
        int num_threads = omp_get_max_threads();

        std::vector<float> q_buf(dim_);
        if (rank_ == 0)
            std::memcpy(q_buf.data(), query, dim_ * sizeof(float));
        MPI_Bcast(q_buf.data(), (int)dim_, MPI_FLOAT, 0, MPI_COMM_WORLD);

        std::vector<std::pair<float, size_t>> coarse(nlist_);
        for (size_t c = 0; c < nlist_; ++c) {
            float d2 = ivf_omp_l2sq(q_buf.data(),
                                     centroids_.data() + c * dim_, dim_);
            coarse[c] = {d2, c};
        }
        std::partial_sort(coarse.begin(), coarse.begin() + nprobe,
                          coarse.end());

        std::vector<int> local_probe_cids;
        for (size_t i = 0; i < nprobe; ++i) {
            size_t cid = coarse[i].second;
            for (int oc : owned_cids_)
                if ((size_t)oc == cid) {
                    local_probe_cids.push_back((int)cid);
                    break;
                }
        }

        // 使用 static 调度：按线程数均匀切分桶列表
        std::vector<AlignedOMPHeap> thread_heaps((size_t)num_threads);
        int n_local = (int)local_probe_cids.size();

        #pragma omp parallel
        {
            int tid = omp_get_thread_num();
            IVFOMPHeap& lh = thread_heaps[tid].h;

            // schedule(static)：各线程均分 n_local 个桶
            #pragma omp for schedule(static)
            for (int probe_i = 0; probe_i < n_local; ++probe_i) {
                int cid = local_probe_cids[probe_i];
                size_t n_vec = inv_ids_[cid].size();
                const float* vecs = inv_vecs_[cid].data();

                for (size_t j = 0; j < n_vec; ++j) {
                    if (j + 2 < n_vec)
                        __builtin_prefetch(vecs + (j + 2) * dim_, 0, 3);
                    float dist = ivf_omp_ip(vecs + j * dim_,
                                             q_buf.data(), dim_);
                    ivf_omp_heap_push(lh, dist, inv_ids_[cid][j], k);
                }
            }
        }

        // Reduce + MPI Gather
        IVFOMPHeap proc_heap;
        for (int t = 0; t < num_threads; ++t) {
            IVFOMPHeap& lh = thread_heaps[t].h;
            while (!lh.empty()) {
                ivf_omp_heap_push(proc_heap, lh.top().first,
                                   lh.top().second, k);
                lh.pop();
            }
        }

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
                displs[r] = total; total += all_counts[r];
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

        IVFOMPHeap result;
        if (rank_ == 0)
            for (int i = 0; i < (int)all_dists.size(); ++i)
                ivf_omp_heap_push(result, all_dists[i], all_ids[i], k);

        return result;
    }

    int  rank()     const { return rank_; }
    int  mpi_size() const { return size_; }

private:
    int    rank_, size_;
    size_t nlist_, dim_, N_;

    std::vector<float>               centroids_;
    std::vector<std::vector<float>>  inv_vecs_;
    std::vector<std::vector<uint32_t>> inv_ids_;
    std::vector<int>                 owned_cids_;
};
