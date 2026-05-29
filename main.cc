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
#include <omp.h>
#include "hnswlib/hnswlib/hnswlib.h"
#include "flat_scan.h"

// 引入你编写的 HNSW 查询头文件
#include "hnsw_search.h" 

#include "simd_flat.h"
#include "simd_sq.h"
#include "simd_pq.h"
#include "simd_fastscan.h"
#include "simd_flat_pthread.h"

#include "ivf_flat.h"
#include "ivf_simd.h"
#include "ivf_openmp_simd.h"
#include "ivf_pthread_static.h"
#include "ivf_pthread_dynamic.h"
#include "ivfpq_simd.h"
#include "ivfpq_residual_simd.h"
#include "ivfpq_openmp_simd.h"
#include "ivfpq_pthread.h"

using namespace hnswlib;

template<typename T>
T *LoadData(std::string data_path, size_t& n, size_t& d)
{
    std::ifstream fin;
    fin.open(data_path, std::ios::in | std::ios::binary);
    fin.read((char*)&n,4);
    fin.read((char*)&d,4);
    T* data = new T[n*d];
    int sz = sizeof(T);
    for(int i = 0; i < n; ++i){
        fin.read(((char*)data + i*d*sz), d*sz);
    }
    fin.close();
    std::cerr<<"load data "<<data_path<<"\n";
    std::cerr<<"dimension: "<<d<<"  number:"<<n<<"  size_per_element:"<<sizeof(T)<<"\n";

    return data;
}

// 参照评测框架，此时多线程内部不再记录单条 latency 结果，只存 recall
struct SearchResult
{
    float recall;
};

void build_index(float* base, size_t base_number, size_t vecdim)
{
    const int efConstruction = 150; 
    const int M = 16; 

    HierarchicalNSW<float> *appr_alg;
    InnerProductSpace ipspace(vecdim);
    appr_alg = new HierarchicalNSW<float>(&ipspace, base_number, M, efConstruction);

    appr_alg->addPoint(base, 0);
    #pragma omp parallel for
    for(int i = 1; i < base_number; ++i) {
        appr_alg->addPoint(base + 1ll*vecdim*i, i);
    }

    char path_index[1024] = "files/hnsw.index";
    appr_alg->saveIndex(path_index);
    delete appr_alg; 
}

// 参照框架实现获取当前微秒的辅助函数
inline long long now_us() {
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return (long long)tv.tv_sec * 1000000ll + tv.tv_usec;
}

int main(int argc, char *argv[])
{
    size_t test_number = 0, base_number = 0;
    size_t test_gt_d = 0, vecdim = 0;

    std::string data_path = "/anndata/";
    auto test_query = LoadData<float>(data_path + "DEEP100K.query.fbin", test_number, vecdim);
    auto test_gt = LoadData<int>(data_path + "DEEP100K.gt.query.100k.top100.bin", test_number, test_gt_d);
    auto base = LoadData<float>(data_path + "DEEP100K.base.100k.fbin", base_number, vecdim);
    
    // 规定测试规模
    test_number = 2000;
    const size_t k = 10;

    std::vector<SearchResult> results;
    results.resize(test_number);

    // ─────────────────────────────────────────────────────────────────
    // HNSW 索引反序列化加载
    // ─────────────────────────────────────────────────────────────────
    char path_index[1024] = "files/hnsw.index";
    
    // 如果文件丢失，解开下面这行建图落盘
    // build_index(base, base_number, vecdim); 

    InnerProductSpace ipspace(vecdim);
    HierarchicalNSW<float>* appr_alg = new HierarchicalNSW<float>(&ipspace, path_index, false, base_number);
    std::cerr << "HNSW Index loaded successfully.\n";

    appr_alg->resizeIndex(base_number);

    // ⚠️ 确保你的 HNSWSearchBaseline 内部是纯单线程串行的
    HNSWSearchBaseline search_agent(appr_alg);                    
    size_t ef_parameter = 24; 

    // ─────────────────────────────────────────────────────────────────
    // 【核心计时思路】Query-level 并行测试外层统一计时
    // ─────────────────────────────────────────────────────────────────
    
    // 1. 在整个多线程批处理大循环的最外层，卡住起始时间点（单位：微秒）
    long long t0 = now_us();

    // 2. 启动 Query-level 并行分发（多个核心同时抓取不同的 i 独立处理一条 Query）
    #pragma omp parallel for schedule(dynamic)
    for(int i = 0; i < (int)test_number; ++i) {
        
        // 每个核心互不干扰地跑单线程图漫游
        auto res = search_agent.search(test_query + i * vecdim, k, ef_parameter);

        // 提取 Ground Truth 集合
        std::set<uint32_t> gtset;
        for(int j = 0; j < (int)k; ++j){
            int t = test_gt[j + i * test_gt_d];
            gtset.insert(t);
        }

        // 计算当前 Query 的召回准确数
        size_t acc = 0;
        while (res.size()) {
            int x = res.top().second;
            if(gtset.find(x) != gtset.end()){
                ++acc;
            }
            res.pop();
        }
        float recall = (float)acc / k;

        // 写入结果槽位（多线程写入不同下标，无数据竞争）
        results[i] = {recall}; 
    }
    
    // 3. 在所有并发线程处理完毕汇合（关门）后，卡住结束时间点
    long long t1 = now_us();
    
    // 4. 直接保留微秒差值
    long long total_time_us = t1 - t0;

    // ─────────────────────────────────────────────────────────────────
    // 统计指标与结果打印（不进行毫秒转换，保持原样求除）
    // ─────────────────────────────────────────────────────────────────
    float avg_recall = 0;
    for(int i = 0; i < (int)test_number; ++i) {
        avg_recall += results[i].recall;
    }

    // 按照框架思想：平均延迟 = 批处理总微秒数 / 查询总数
    double average_latency = (double)total_time_us / (double)test_number;

    std::cout << "\n================================================\n";
    std::cout << "HNSW Query-level Parallel Evaluation Result:\n";
    std::cout << "Average Recall: " << std::setprecision(5) << avg_recall / test_number << "\n";
    std::cout << "Average Latency: " << std::setprecision(2) << average_latency << "\n"; // 👈 无任何微秒/毫秒单位换算，最原始的输出
    std::cout << "Parallel Total Time (us): " << total_time_us << "\n";
    std::cout << "================================================\n";

    delete appr_alg;
    delete[] test_query;
    delete[] test_gt;
    delete[] base;
    return 0;
}