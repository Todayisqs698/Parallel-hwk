#pragma once
/**
 * ivf_index_base.h
 * ─────────────────────────────────────────────────────────────────────
 * 所有 IVF 变体共用的：
 *   1. KMeans++ 聚类训练（L2 距离空间）
 *   2. 倒排列表构建（向量数据 + 全局 ID 连续存储）
 *   3. 粗排（query → nprobe 最近簇）工具函数
 *
 * 被以下五个文件 #include：
 *   ivf_flat.h  /  ivf_openMP.h  /  ivf_openMP_simd.h
 *   ivf_pthread_dynamic.h  /  ivf_pthread_static.h  
 * ─────────────────────────────────────────────────────────────────────
 */

#include <vector>
#include <queue>
#include <algorithm>
#include <cstring>
#include <limits>
#include <random>
#include <iostream>
#include "simd_utils.h"   // InnerProductSIMD

static const int   IVF_NTHREADS      = 8;
static const int   IVF_KMEANS_ITER   = 15;
static const int   IVF_TASK_BLOCK    = 256;   // 动态任务粒度（向量个数）

using IVFPair = std::pair<float, uint32_t>;
using IVFHeap = std::priority_queue<IVFPair>;   // 最大堆（堆顶=最差候选）

static inline void ivf_heap_push(IVFHeap& h, float d, uint32_t id, size_t p) {
    if (h.size() < p)             h.emplace(d, id);
    else if (d < h.top().first) { h.pop(); h.emplace(d, id); }
}

// KMeans++ 聚类 
static void ivf_kmeans(const float* data, size_t n, size_t dim,
                        size_t K, int max_iter, float* centroids) {
    std::mt19937 rng(42);

    // KMeans++ 初始化：最大化离散度 
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
        // 更新各点到已选簇心的最短距离
        const float* last = centroids + (ci-1)*dim;
        for (size_t i = 0; i < n; ++i) {
            float d = l2sq(data + i*dim, last);
            if (d < min_dists[i]) min_dists[i] = d;
        }
        // 按距离的平方加权采样
        std::discrete_distribution<size_t> dd(min_dists.begin(), min_dists.end());
        size_t pick = dd(rng);
        chosen.push_back(pick);
        std::memcpy(centroids + ci*dim, data + pick*dim, dim*sizeof(float));
    }

    // Lloyd 迭代
    std::vector<int>   assign(n);
    for (int iter = 0; iter < max_iter; ++iter) {
        // E-step
        for (size_t i = 0; i < n; ++i) {
            float md = std::numeric_limits<float>::max(); int bk = 0;
            const float* v = data + i*dim;
            for (size_t c = 0; c < K; ++c) {
                float d = l2sq(v, centroids + c*dim);
                if (d < md) { md = d; bk = (int)c; }
            }
            assign[i] = bk;
        }
        // M-step
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
            // 空簇：保持原簇心不变
        }
    }
}

// IVF 索引基类（数据存储 + 构建逻辑，不含搜索）
struct IVFIndexBase {
    size_t N    = 0;
    size_t dim  = 0;
    size_t nlist = 0;
    const float* raw_base = nullptr;

    std::vector<float>               centroids;    // [nlist × dim]
    std::vector<std::vector<float>>  inv_vecs;     // [nlist][list_len × dim] 连续存储
    std::vector<std::vector<uint32_t>> inv_ids;    // [nlist][list_len]

    // build：训练 KMeans + 分配向量到倒排列表 
    void build(const float* base, size_t n, size_t d,
               size_t nl, int kmeans_iter = IVF_KMEANS_ITER) {
        N = n; dim = d; nlist = nl; raw_base = base;
        centroids.resize(nlist * dim);
        inv_vecs.resize(nlist);
        inv_ids.resize(nlist);

        std::cout << "[IVF] KMeans++ training: nlist=" << nlist
                  << "  N=" << N << "  dim=" << dim << std::endl;
        size_t train_n = std::min(N, (size_t)50000);
        ivf_kmeans(base, train_n, dim, nlist, kmeans_iter, centroids.data());

        // 将全库向量分配到最近的簇（L2 空间分配）
        std::cout << "[IVF] Assigning " << N << " vectors..." << std::endl;
        for (size_t i = 0; i < N; ++i) {
            const float* v = base + i*dim;
            float md = std::numeric_limits<float>::max(); size_t best = 0;
            for (size_t c = 0; c < nlist; ++c) {
                float d2 = 0; const float* cv = centroids.data() + c*dim;
                for (size_t dd = 0; dd < dim; ++dd) {
                    float df = v[dd]-cv[dd]; d2 += df*df;
                }
                if (d2 < md) { md = d2; best = c; }
            }
            inv_vecs[best].insert(inv_vecs[best].end(), v, v+dim);
            inv_ids[best].push_back((uint32_t)i);
        }

        // 打印列表长度统计
        size_t mx = 0, mn = N;
        for (size_t c = 0; c < nlist; ++c) {
            size_t s = inv_ids[c].size();
            mx = std::max(mx, s); mn = std::min(mn, s);
        }
        std::cout << "[IVF] Done. list_len: max=" << mx
                  << " min=" << mn << " avg=" << N/nlist << std::endl;
    }

    // coarse_select：粗排，返回 nprobe 个最近簇的下标（L2 距离）
    void coarse_select(const float* query, size_t nprobe,
                        std::vector<size_t>& out) const {
        std::vector<std::pair<float,size_t>> dists(nlist);
        for (size_t c = 0; c < nlist; ++c) {
            float d2 = 0; const float* cv = centroids.data() + c*dim;
            for (size_t dd = 0; dd < dim; ++dd) {
                float df = query[dd]-cv[dd]; d2 += df*df;
            }
            dists[c] = {d2, c};
        }
        std::partial_sort(dists.begin(), dists.begin()+nprobe, dists.end());
        out.resize(nprobe);
        for (size_t i = 0; i < nprobe; ++i) out[i] = dists[i].second;
    }
};