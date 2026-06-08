/**
 * main_mpi.cc  —  MPI 分布式向量检索主评测程序
 * =====================================================================
 * 用法（集群）：
 * mpirun -np <进程数> ./main_mpi [--mode ivf|hybrid|hnsw] [--nprobe N] [--ef N]
 *
 * 用法（单机测试）：
 * mpirun -np 4 ./main_mpi --mode ivf
 *
 * 编译：
 * mpicxx main_mpi.cc -o main_mpi -O2 -std=c++11 -lm -fopenmp
 *
 * 评测模式：
 * flat      — MPI Flat 精确检索（标量）
 * flat_simd — MPI Flat + SIMD 精确检索
 * ivf_base  — MPI IVF 基础版（标量）
 * ivf_omp   — MPI IVF + OpenMP
 * ivf       — MPI-IVF with SIMD（Task A）
 * hybrid    — MPI + OpenMP 混合并行 IVF（Task B）
 * hnsw      — MPI 分布式 HNSW 图索引（Task C）
 * =====================================================================
 */

#include <mpi.h>
#include <omp.h>
#include <vector>
#include <cstring>
#include <string>
#include <iostream>
#include <fstream>
#include <set>
#include <chrono>
#include <iomanip>
#include <sstream>
#include <sys/time.h>

#include "ivf_mpi_simd.h"
#include "ivf_mpi_hybrid.h"
#include "hnsw_mpi.h"
#include "hnsw_mpi_simd.h"
#include "multi_hnsw_mpi.h"
#include "ivf_hnsw_mpi.h"
#include "flat_mpi.h"
#include "flat_mpi_simd.h"
#include "ivf_mpi.h"
#include "ivf_mpi_omp.h"

// ─────────────────────────────────────────────────────────────────────
// 数据加载（所有 MPI 测试共用）
// ─────────────────────────────────────────────────────────────────────
template<typename T>
T* LoadData(const std::string& data_path, size_t& n, size_t& d) {
    std::ifstream fin;
    fin.open(data_path, std::ios::in | std::ios::binary);
    if (!fin) {
        std::cerr << "Error: Cannot open " << data_path << std::endl;
        MPI_Abort(MPI_COMM_WORLD, 1);
    }
    fin.read((char*)&n, 4);
    fin.read((char*)&d, 4);
    T* data = new T[n * d];
    int sz = sizeof(T);
    for (size_t i = 0; i < n; ++i) {
        fin.read(((char*)data + i * d * sz), d * sz);
    }
    fin.close();
    return data;
}

// ─────────────────────────────────────────────────────────────────────
// 计时工具
// ─────────────────────────────────────────────────────────────────────
inline long long now_us() {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return (long long)tv.tv_sec * 1000000ll + tv.tv_usec;
}

// ─────────────────────────────────────────────────────────────────────
// 主函数
// ─────────────────────────────────────────────────────────────────────
int main(int argc, char* argv[]) {
    // ── MPI 初始化 ──────────────────────────────────────────────────
    MPI_Init(&argc, &argv);

    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // ── OpenMP 线程数设置 ───────────────────────────────────────────
    int omp_threads = omp_get_max_threads();
    if (rank == 0) {
        std::cout << "================================================" << std::endl;
        std::cout << "MPI Vector Search — Distributed Evaluation" << std::endl;
        std::cout << "MPI Processes: " << size << std::endl;
        std::cout << "OMP Threads/Process: " << omp_threads << std::endl;
        std::cout << "Total parallelism: " << size * omp_threads
                  << " threads" << std::endl;
        std::cout << "================================================" << std::endl;
    }

    // ── 解析命令行参数 ──────────────────────────────────────────────
    std::string mode = "hybrid";  
    size_t nprobe = 4;
    size_t ef_search = 24;
    size_t nlist = 1024;
    size_t nsubgraphs = 2;
    size_t nsubprobe = 0;  // 0 = use all subgraphs

    for (int i = 1; i < argc; ++i) {
        if (std::strcmp(argv[i], "--mode") == 0 && i + 1 < argc)
            mode = argv[++i];
        else if (std::strcmp(argv[i], "--nprobe") == 0 && i + 1 < argc)
            nprobe = std::stoul(argv[++i]);
        else if (std::strcmp(argv[i], "--ef") == 0 && i + 1 < argc)
            ef_search = std::stoul(argv[++i]);
        else if (std::strcmp(argv[i], "--nlist") == 0 && i + 1 < argc)
            nlist = std::stoul(argv[++i]);
        else if (std::strcmp(argv[i], "--nsubgraphs") == 0 && i + 1 < argc)
            nsubgraphs = std::stoul(argv[++i]);
        else if (std::strcmp(argv[i], "--nsubprobe") == 0 && i + 1 < argc)
            nsubprobe = std::stoul(argv[++i]);
    }

    if (rank == 0) {
        std::cout << "Mode: " << mode << std::endl;
        std::cout << "nprobe: " << nprobe << std::endl;
        std::cout << "ef_search: " << ef_search << std::endl;
        std::cout << "nlist: " << nlist << std::endl;
    }

    // ── 数据路径 ────────────────────────────────────────────────────
    std::string data_path = "/anndata/";

    // ── 0 号进程加载数据 ───────────────────────────────────────────
    size_t test_number = 0, base_number = 0;
    size_t test_gt_d = 0, vecdim = 0;

    float* test_query = nullptr;
    int* test_gt    = nullptr;
    float* base       = nullptr;

    if (rank == 0) {
        test_query = LoadData<float>(data_path + "DEEP100K.query.fbin",
                                      test_number, vecdim);
        test_gt    = LoadData<int>(data_path + "DEEP100K.gt.query.100k.top100.bin",
                                    test_number, test_gt_d);
        base       = LoadData<float>(data_path + "DEEP100K.base.100k.fbin",
                                      base_number, vecdim);

        std::cout << "Base: " << base_number << " x " << vecdim << std::endl;
        std::cout << "Query: " << test_number << " x " << vecdim << std::endl;
    }

    // 广播数据集元信息
    MPI_Bcast(&test_number, 1, MPI_UNSIGNED_LONG_LONG, 0, MPI_COMM_WORLD);
    MPI_Bcast(&base_number, 1, MPI_UNSIGNED_LONG_LONG, 0, MPI_COMM_WORLD);
    MPI_Bcast(&vecdim,     1, MPI_UNSIGNED_LONG_LONG, 0, MPI_COMM_WORLD);
    MPI_Bcast(&test_gt_d,  1, MPI_UNSIGNED_LONG_LONG, 0, MPI_COMM_WORLD);

    // 测试规模
    test_number = 2000;
    const size_t k = 10;

    // ── 评测结果存储 ────────────────────────────────────────────────
    struct SearchResult { float recall; };
    std::vector<SearchResult> results;

    long long t0 = 0, t1 = 0;

    // ═════════════════════════════════════════════════════════════════
    // 模式 0: MPI Flat 精确检索 — 标量版
    // ═════════════════════════════════════════════════════════════════
    if (mode == "flat") {
        FlatMPI flat_mpi;

        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t0 = (rank == 0) ? now_us() : 0;
        flat_mpi.build_distributed(base, base_number, vecdim);
        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t1 = (rank == 0) ? now_us() : 0;
        if (rank == 0) {
            std::cout << "Flat-MPI Build time: "
                      << (build_t1 - build_t0) << " us" << std::endl; // 修改点：去除除法，改为us
        }

        if (rank == 0) results.resize(test_number);

        MPI_Barrier(MPI_COMM_WORLD);
        t0 = (rank == 0) ? now_us() : 0;

        for (size_t i = 0; i < test_number; ++i) {
            const float* q = (rank == 0) ? (test_query + i * vecdim) : nullptr;
            auto heap = flat_mpi.search(q, k);

            if (rank == 0) {
                std::set<uint32_t> gtset;
                for (size_t j = 0; j < k; ++j)
                    gtset.insert((uint32_t)test_gt[j + i * test_gt_d]);

                size_t acc = 0;
                while (!heap.empty()) {
                    if (gtset.find(heap.top().second) != gtset.end()) ++acc;
                    heap.pop();
                }
                results[i] = { (float)acc / k };
            }
        }

        MPI_Barrier(MPI_COMM_WORLD);
        t1 = (rank == 0) ? now_us() : 0;
    }

    // ═════════════════════════════════════════════════════════════════
    // 模式 0b: MPI Flat + SIMD 精确检索
    // ═════════════════════════════════════════════════════════════════
    else if (mode == "flat_simd") {
        FlatMPISIMD flat_simd;

        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t0 = (rank == 0) ? now_us() : 0;
        flat_simd.build_distributed(base, base_number, vecdim);
        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t1 = (rank == 0) ? now_us() : 0;
        if (rank == 0) {
            std::cout << "Flat-MPI-SIMD Build time: "
                      << (build_t1 - build_t0) << " us" << std::endl; // 修改点：去除除法，改为us
        }

        if (rank == 0) results.resize(test_number);

        MPI_Barrier(MPI_COMM_WORLD);
        t0 = (rank == 0) ? now_us() : 0;

        for (size_t i = 0; i < test_number; ++i) {
            const float* q = (rank == 0) ? (test_query + i * vecdim) : nullptr;
            auto heap = flat_simd.search(q, k);

            if (rank == 0) {
                std::set<uint32_t> gtset;
                for (size_t j = 0; j < k; ++j)
                    gtset.insert((uint32_t)test_gt[j + i * test_gt_d]);

                size_t acc = 0;
                while (!heap.empty()) {
                    if (gtset.find(heap.top().second) != gtset.end()) ++acc;
                    heap.pop();
                }
                results[i] = { (float)acc / k };
            }
        }

        MPI_Barrier(MPI_COMM_WORLD);
        t1 = (rank == 0) ? now_us() : 0;
    }

    // ═════════════════════════════════════════════════════════════════
    // 模式 1a: MPI IVF 基础版
    // ═════════════════════════════════════════════════════════════════
    else if (mode == "ivf_base") {
        IVFMPI ivf_base;

        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t0 = (rank == 0) ? now_us() : 0;
        ivf_base.build_distributed(base, base_number, vecdim, nlist);
        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t1 = (rank == 0) ? now_us() : 0;
        if (rank == 0) {
            std::cout << "IVF-MPI-Base Build time: "
                      << (build_t1 - build_t0) << " us" << std::endl; // 修改点：去除除法，改为us
        }

        if (rank == 0) results.resize(test_number);

        MPI_Barrier(MPI_COMM_WORLD);
        t0 = (rank == 0) ? now_us() : 0;

        for (size_t i = 0; i < test_number; ++i) {
            const float* q = (rank == 0) ? (test_query + i * vecdim) : nullptr;
            auto heap = ivf_base.search(q, k, nprobe, k * 5);

            if (rank == 0) {
                std::set<uint32_t> gtset;
                for (size_t j = 0; j < k; ++j)
                    gtset.insert((uint32_t)test_gt[j + i * test_gt_d]);

                size_t acc = 0;
                while (!heap.empty()) {
                    if (gtset.find(heap.top().second) != gtset.end()) ++acc;
                    heap.pop();
                }
                results[i] = { (float)acc / k };
            }
        }

        MPI_Barrier(MPI_COMM_WORLD);
        t1 = (rank == 0) ? now_us() : 0;
    }

    // ═════════════════════════════════════════════════════════════════
    // 模式 1b: MPI IVF + OpenMP
    // ═════════════════════════════════════════════════════════════════
    else if (mode == "ivf_omp") {
        IVFMPIOpenMP ivf_omp;

        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t0 = (rank == 0) ? now_us() : 0;
        ivf_omp.build_distributed(base, base_number, vecdim, nlist);
        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t1 = (rank == 0) ? now_us() : 0;
        if (rank == 0) {
            std::cout << "IVF-MPI-OMP Build time: "
                      << (build_t1 - build_t0) << " us" << std::endl; // 修改点：去除除法，改为us
        }

        if (rank == 0) results.resize(test_number);

        MPI_Barrier(MPI_COMM_WORLD);
        t0 = (rank == 0) ? now_us() : 0;

        for (size_t i = 0; i < test_number; ++i) {
            const float* q = (rank == 0) ? (test_query + i * vecdim) : nullptr;
            auto heap = ivf_omp.search_omp(q, k, nprobe, k * 5);

            if (rank == 0) {
                std::set<uint32_t> gtset;
                for (size_t j = 0; j < k; ++j)
                    gtset.insert((uint32_t)test_gt[j + i * test_gt_d]);

                size_t acc = 0;
                while (!heap.empty()) {
                    if (gtset.find(heap.top().second) != gtset.end()) ++acc;
                    heap.pop();
                }
                results[i] = { (float)acc / k };
            }
        }

        MPI_Barrier(MPI_COMM_WORLD);
        t1 = (rank == 0) ? now_us() : 0;
    }

    // ═════════════════════════════════════════════════════════════════
    // 模式 1c: MPI-IVF with SIMD
    // ═════════════════════════════════════════════════════════════════
    else if (mode == "ivf") {
        IVFMPISIMD ivf_mpi;

        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t0 = (rank == 0) ? now_us() : 0;
        ivf_mpi.build_distributed(base, base_number, vecdim, nlist);
        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t1 = (rank == 0) ? now_us() : 0;
        if (rank == 0) {
            std::cout << "MPI-IVF Build time: "
                      << (build_t1 - build_t0) << " us" << std::endl; // 修改点：去除除法，改为us
        }

        if (rank == 0) results.resize(test_number);

        MPI_Barrier(MPI_COMM_WORLD);
        t0 = (rank == 0) ? now_us() : 0;

        for (size_t i = 0; i < test_number; ++i) {
            const float* q = (rank == 0) ? (test_query + i * vecdim) : nullptr;
            auto heap = ivf_mpi.search(q, k, nprobe, k * 5);

            if (rank == 0) {
                std::set<uint32_t> gtset;
                for (size_t j = 0; j < k; ++j)
                    gtset.insert((uint32_t)test_gt[j + i * test_gt_d]);

                size_t acc = 0;
                while (!heap.empty()) {
                    if (gtset.find(heap.top().second) != gtset.end()) ++acc;
                    heap.pop();
                }
                results[i] = { (float)acc / k };
            }
        }

        MPI_Barrier(MPI_COMM_WORLD);
        t1 = (rank == 0) ? now_us() : 0;
    }

    // ═════════════════════════════════════════════════════════════════
    // 模式 2: MPI + OpenMP 混合并行 IVF
    // ═════════════════════════════════════════════════════════════════
    else if (mode == "hybrid") {
        IVFMPIHybrid ivf_hybrid;

        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t0 = (rank == 0) ? now_us() : 0;
        ivf_hybrid.build_distributed(base, base_number, vecdim, nlist);
        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t1 = (rank == 0) ? now_us() : 0;
        if (rank == 0) {
            std::cout << "MPI-Hybrid Build time: "
                      << (build_t1 - build_t0) << " us" << std::endl; // 修改点：去除除法，改为us
        }

        if (rank == 0) results.resize(test_number);

        MPI_Barrier(MPI_COMM_WORLD);
        t0 = (rank == 0) ? now_us() : 0;

        for (size_t i = 0; i < test_number; ++i) {
            const float* q = (rank == 0) ? (test_query + i * vecdim) : nullptr;
            auto heap = ivf_hybrid.search_hybrid(q, k, nprobe, k * 5);

            if (rank == 0) {
                std::set<uint32_t> gtset;
                for (size_t j = 0; j < k; ++j)
                    gtset.insert((uint32_t)test_gt[j + i * test_gt_d]);

                size_t acc = 0;
                while (!heap.empty()) {
                    if (gtset.find(heap.top().second) != gtset.end()) ++acc;
                    heap.pop();
                }
                results[i] = { (float)acc / k };
            }

            if (rank == 0 && i % 200 == 0)
                std::cout << "   Processed " << i << "/" << test_number
                          << " queries\r" << std::flush;
        }

        MPI_Barrier(MPI_COMM_WORLD);
        t1 = (rank == 0) ? now_us() : 0;
    }

    // ═════════════════════════════════════════════════════════════════
    // 模式 3: MPI 分布式 HNSW 图索引
    // ═════════════════════════════════════════════════════════════════
    else if (mode == "hnsw") {
        HNSWMPI hnsw_mpi;

        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t0 = (rank == 0) ? now_us() : 0;
        hnsw_mpi.build_distributed(base, base_number, vecdim);
        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t1 = (rank == 0) ? now_us() : 0;
        if (rank == 0) {
            std::cout << "MPI-HNSW Build time: "
                      << (build_t1 - build_t0) << " us" << std::endl; // 修改点：去除除法，改为us
        }

        if (rank == 0) results.resize(test_number);

        MPI_Barrier(MPI_COMM_WORLD);
        t0 = (rank == 0) ? now_us() : 0;

        for (size_t i = 0; i < test_number; ++i) {
            const float* q = (rank == 0) ? (test_query + i * vecdim) : nullptr;
            auto heap = hnsw_mpi.search_multi_entry(q, k, ef_search, 4, k * 4);

            if (rank == 0) {
                std::set<uint32_t> gtset;
                for (size_t j = 0; j < k; ++j)
                    gtset.insert((uint32_t)test_gt[j + i * test_gt_d]);

                size_t acc = 0;
                while (!heap.empty()) {
                    if (gtset.find((uint32_t)heap.top().second) != gtset.end())
                        ++acc;
                    heap.pop();
                }
                results[i] = { (float)acc / k };
            }

            if (rank == 0 && i % 100 == 0)
                std::cout << "   Processed " << i << "/" << test_number
                          << " queries\r" << std::flush;
        }

        MPI_Barrier(MPI_COMM_WORLD);
        t1 = (rank == 0) ? now_us() : 0;
    }

    // ═════════════════════════════════════════════════════════════════
    // 模式 4: MPI 分布式 HNSW + SIMD 向量化加速
    // ═════════════════════════════════════════════════════════════════
    else if (mode == "hnsw_simd") {
        HNSWMPISIMDSearch hnsw_simd;

        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t0 = (rank == 0) ? now_us() : 0;
        hnsw_simd.build_distributed(base, base_number, vecdim);
        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t1 = (rank == 0) ? now_us() : 0;
        if (rank == 0) {
            std::cout << "MPI-HNSW-SIMD Build time: "
                      << (build_t1 - build_t0) << " us" << std::endl;
        }

        if (rank == 0) results.resize(test_number);

        MPI_Barrier(MPI_COMM_WORLD);
        t0 = (rank == 0) ? now_us() : 0;

        for (size_t i = 0; i < test_number; ++i) {
            const float* q = (rank == 0) ? (test_query + i * vecdim) : nullptr;
            // 三级并行：MPI + OpenMP 多入口 + NEON SIMD 距离
            auto heap = hnsw_simd.search_omp_multi_entry(q, k, ef_search, 4, k * 4);

            if (rank == 0) {
                std::set<uint32_t> gtset;
                for (size_t j = 0; j < k; ++j)
                    gtset.insert((uint32_t)test_gt[j + i * test_gt_d]);

                size_t acc = 0;
                while (!heap.empty()) {
                    if (gtset.find((uint32_t)heap.top().second) != gtset.end())
                        ++acc;
                    heap.pop();
                }
                results[i] = { (float)acc / k };
            }

            if (rank == 0 && i % 100 == 0)
                std::cout << "   Processed " << i << "/" << test_number
                          << " queries\r" << std::flush;
        }

        MPI_Barrier(MPI_COMM_WORLD);
        t1 = (rank == 0) ? now_us() : 0;
    }

    // ═════════════════════════════════════════════════════════════════
    // 通信对比模式族 — 固定索引 + SIMD 局部搜索，仅换汇总通信方式
    //   每个模式输出通信耗时（max straggler us/query）
    // ═════════════════════════════════════════════════════════════════

    // hnsw_blocking   — MPI_Gather + MPI_Gatherv（阻塞集合通信）
    // hnsw_nonblocking— MPI_Igather + MPI_Igatherv + MPI_Waitall（非阻塞集合通信）
    // hnsw_p2p        — MPI_Send / MPI_Irecv（点对点通信）
    // hnsw_onesided   — MPI_Win_create + MPI_Put + MPI_Win_fence（单边 RMA）

    else if (mode == "hnsw_blocking" || mode == "hnsw_nonblocking" ||
             mode == "hnsw_p2p" || mode == "hnsw_onesided") {

        HNSWMPISIMDSearch hnsw_simd;

        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t0 = (rank == 0) ? now_us() : 0;
        hnsw_simd.build_distributed(base, base_number, vecdim);
        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t1 = (rank == 0) ? now_us() : 0;
        if (rank == 0) {
            std::cout << "MPI-HNSW-SIMD (" << mode << ") Build time: "
                      << (build_t1 - build_t0) << " us" << std::endl;
        }

        // One-Sided 持久化窗口：建图后一次性创建，所有查询复用
        if (mode == "hnsw_onesided") {
            hnsw_simd.init_onesided_windows(k * 4);  // capacity = size_ × local_p
        }

        if (rank == 0) results.resize(test_number);
        double total_comm_max_us = 0.0;  // 累计 max straggler 通信时间

        MPI_Barrier(MPI_COMM_WORLD);
        t0 = (rank == 0) ? now_us() : 0;

        for (size_t i = 0; i < test_number; ++i) {
            const float* q = (rank == 0) ? (test_query + i * vecdim) : nullptr;

            HNSWSIMDHeap heap;
            if (mode == "hnsw_blocking")
                heap = hnsw_simd.search_blocking(q, k, ef_search, 4, k * 4);
            else if (mode == "hnsw_nonblocking")
                heap = hnsw_simd.search_nonblocking(q, k, ef_search, 4, k * 4);
            else if (mode == "hnsw_p2p")
                heap = hnsw_simd.search_p2p(q, k, ef_search, 4, k * 4);
            else // hnsw_onesided
                heap = hnsw_simd.search_onesided(q, k, ef_search, 4, k * 4);

            if (rank == 0) {
                total_comm_max_us += hnsw_simd.get_last_comm_time_max_us();

                std::set<uint32_t> gtset;
                for (size_t j = 0; j < k; ++j)
                    gtset.insert((uint32_t)test_gt[j + i * test_gt_d]);

                size_t acc = 0;
                while (!heap.empty()) {
                    if (gtset.find((uint32_t)heap.top().second) != gtset.end())
                        ++acc;
                    heap.pop();
                }
                results[i] = { (float)acc / k };
            }

            if (rank == 0 && i % 100 == 0)
                std::cout << "   Processed " << i << "/" << test_number
                          << " queries\r" << std::flush;
        }

        MPI_Barrier(MPI_COMM_WORLD);
        t1 = (rank == 0) ? now_us() : 0;

        // 输出通信耗时统计
        if (rank == 0) {
            double avg_comm_max_us = total_comm_max_us / (double)test_number;
            std::cout << "\n   --- Communication Stats (" << mode << ") ---" << std::endl;
            std::cout << "   Avg Comm Time (max straggler): " << std::fixed
                      << std::setprecision(2) << avg_comm_max_us << " us/query" << std::endl;
        }
    }

    // ═════════════════════════════════════════════════════════════════
    // 模式 C+: 分布式 Multi-HNSW（每进程 S 个子图 + 导航 HNSW）
    // ═════════════════════════════════════════════════════════════════
    else if (mode == "multi_hnsw") {
        MultiHNSWMPI multi_hnsw;

        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t0 = (rank == 0) ? now_us() : 0;
        multi_hnsw.build_distributed(base, base_number, vecdim,
                                      nsubgraphs, 16, 150, 8);
        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t1 = (rank == 0) ? now_us() : 0;
        if (rank == 0) {
            std::cout << "Multi-HNSW-MPI Build time: "
                      << (build_t1 - build_t0) << " us" << std::endl;
        }

        if (rank == 0) results.resize(test_number);

        MPI_Barrier(MPI_COMM_WORLD);
        t0 = (rank == 0) ? now_us() : 0;

        for (size_t i = 0; i < test_number; ++i) {
            const float* q = (rank == 0) ? (test_query + i * vecdim) : nullptr;
            auto heap = multi_hnsw.search(q, k, ef_search, nsubprobe, k * 4);

            if (rank == 0) {
                std::set<uint32_t> gtset;
                for (size_t j = 0; j < k; ++j)
                    gtset.insert((uint32_t)test_gt[j + i * test_gt_d]);

                size_t acc = 0;
                while (!heap.empty()) {
                    if (gtset.find((uint32_t)heap.top().second) != gtset.end())
                        ++acc;
                    heap.pop();
                }
                results[i] = { (float)acc / k };
            }

            if (rank == 0 && i % 100 == 0)
                std::cout << "   Processed " << i << "/" << test_number
                          << " queries\r" << std::flush;
        }

        MPI_Barrier(MPI_COMM_WORLD);
        t1 = (rank == 0) ? now_us() : 0;
    }

    // ═════════════════════════════════════════════════════════════════
    // 模式 C++: IVF-HNSW 混合嵌套索引 + MPI 分布式
    //   粗级 K-Means → 精级每桶 HNSW；桶级块划分分发
    // ═════════════════════════════════════════════════════════════════
    else if (mode == "ivf_hnsw") {
        IVFHNSWMPIIndex ivf_hnsw;

        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t0 = (rank == 0) ? now_us() : 0;
        ivf_hnsw.build_distributed(base, base_number, vecdim, nlist, 16, 150, 20);
        MPI_Barrier(MPI_COMM_WORLD);
        long long build_t1 = (rank == 0) ? now_us() : 0;
        if (rank == 0) {
            std::cout << "IVF-HNSW-MPI Build time: "
                      << (build_t1 - build_t0) << " us" << std::endl;
        }

        if (rank == 0) results.resize(test_number);

        MPI_Barrier(MPI_COMM_WORLD);
        t0 = (rank == 0) ? now_us() : 0;

        for (size_t i = 0; i < test_number; ++i) {
            const float* q = (rank == 0) ? (test_query + i * vecdim) : nullptr;
            auto heap = ivf_hnsw.search(q, k, nprobe, ef_search, k * 5);

            if (rank == 0) {
                std::set<uint32_t> gtset;
                for (size_t j = 0; j < k; ++j)
                    gtset.insert((uint32_t)test_gt[j + i * test_gt_d]);

                size_t acc = 0;
                while (!heap.empty()) {
                    if (gtset.find((uint32_t)heap.top().second) != gtset.end())
                        ++acc;
                    heap.pop();
                }
                results[i] = { (float)acc / k };
            }

            if (rank == 0 && i % 100 == 0)
                std::cout << "   Processed " << i << "/" << test_number
                          << " queries\r" << std::flush;
        }

        MPI_Barrier(MPI_COMM_WORLD);
        t1 = (rank == 0) ? now_us() : 0;
    }

    else {
        if (rank == 0)
            std::cerr << "Unknown mode: " << mode
                      << ". Use: flat | flat_simd | ivf_base | ivf_omp | ivf | hybrid | hnsw | hnsw_simd | hnsw_blocking | hnsw_nonblocking | hnsw_p2p | hnsw_onesided | multi_hnsw | ivf_hnsw"
                      << std::endl;
        MPI_Finalize();
        return 1;
    }

// ── 结果统计（仅 0 号进程）──────────────────────────────────────
    if (rank == 0) {
        float avg_recall = 0;
        for (size_t i = 0; i < test_number; ++i)
            avg_recall += results[i].recall;

        double avg_latency = (double)(t1 - t0) / (double)test_number;
        double throughput = (t1 - t0) > 0 ? ((double)test_number / (double)(t1 - t0) * 1000000.0) : 0.0;

        std::cout << "\n================================================" << std::endl;
        std::cout << "MPI " << mode << " Evaluation Result:" << std::endl;
        std::cout << "   MPI Processes:  " << size << std::endl;
        std::cout << "   OMP Threads:    " << omp_threads << std::endl;
        std::cout << "   Queries:        " << test_number << std::endl;
        std::cout << "   Top-K:          " << k << std::endl;
        
        // 保持召回率的小数位数
        std::cout << "   Average Recall: " << std::fixed << std::setprecision(5)
                  << avg_recall / test_number << std::endl;
                  
        // 【核心修改】强制使用标准定点小数(std::fixed)，保留 2 位小数，彻底干掉科学计数法
        std::cout << "   Average Latency: " << std::fixed << std::setprecision(2)
                  << avg_latency << " us" << std::endl;
        std::cout << "   Throughput (QPS): " << std::fixed << std::setprecision(2)
                  << throughput << " queries/s" << std::endl;          
        // 整数总时间输出，也确保它不用科学计数法
        std::cout << "   Total Time:     " << (t1 - t0)
                  << " us" << std::endl;
        std::cout << "================================================" << std::endl;
    }

    // ── 清理 ─────────────────────────────────────────────────────────
    if (rank == 0) {
        delete[] test_query;
        delete[] test_gt;
        delete[] base;
    }

    MPI_Finalize();
    return 0;
}