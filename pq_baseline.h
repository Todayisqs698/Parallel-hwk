#pragma once
#include <vector>
#include <cstdint>
#include <queue>
#include <cmath>
#include <cassert>
constexpr int PQ_M = 16;  // 子空间数量，
constexpr int PQ_K = 16;  // 聚类数量
// ======================================
// 平凡 PQ Index（Baseline版本）
// ======================================
struct PQIndexBaseline {
    int M = PQ_M;        // 子空间数
    int K = PQ_K;        // 每个子空间中心数
    int dim = 0;      // 原始维度
    int sub_dim = 0;  // dim / M
    int N = 0;        // 数据库大小

    // codebook: [M][K][sub_dim]
    std::vector<std::vector<std::vector<float>>> codebooks;

    // codes: [N][M]
    std::vector<std::vector<uint8_t>> codes;

    // 原始数据（用于rerank，可选）
    const float* base_data = nullptr;

    // ================================
    // 1️⃣ 构建 LUT（float版本）
    // ================================
    void build_LUT(const float* query, std::vector<float>& LUT) const {
        LUT.resize(M * K);

        for (int m = 0; m < M; ++m) {
            const float* q_sub = query + m * sub_dim;

            for (int k = 0; k < K; ++k) {
                const float* centroid = codebooks[m][k].data();

                float dist = 0.0f;
                for (int d = 0; d < sub_dim; ++d) {
                    float diff = q_sub[d] - centroid[d];
                    dist += diff * diff;
                }

                LUT[m * K + k] = dist;
            }
        }
    }

    // ================================
    // 2️⃣ 查表计算距离
    // ================================
    inline float compute_distance(
        const uint8_t* code,
        const std::vector<float>& LUT) const
    {
        float sum = 0.0f;

        for (int m = 0; m < M; ++m) {
            sum += LUT[m * K + code[m]];
        }

        return sum;
    }

    // ================================
    // 3️⃣ 精排（可选）
    // ================================
    float exact_distance(const float* a, const float* b) const {
        float sum = 0.0f;
        for (int i = 0; i < dim; ++i) {
            float diff = a[i] - b[i];
            sum += diff * diff;
        }
        return sum;
    }

    // ================================
    // 4️⃣ 查询接口（Top-K）
    // ================================
    std::priority_queue<std::pair<float, uint32_t>>
    query(const float* query_vec, int topk, int rerank_k = 0)
    {
        assert(M > 0 && K > 0);
        assert(dim % M == 0);

        sub_dim = dim / M;
        N = codes.size();

        // ① 构建 LUT
        std::vector<float> LUT;
        build_LUT(query_vec, LUT);

        // ② 粗排（PQ距离）
        std::priority_queue<std::pair<float, uint32_t>> heap;

        for (int i = 0; i < N; ++i) {
            float dist = compute_distance(codes[i].data(), LUT);

            if ((int)heap.size() < (rerank_k > 0 ? rerank_k : topk)) {
                heap.emplace(dist, i);
            } else if (dist < heap.top().first) {
                heap.pop();
                heap.emplace(dist, i);
            }
        }

        // 如果不需要rerank，直接返回
        if (rerank_k <= 0 || base_data == nullptr) {
            return heap;
        }

        // ③ 精排（rerank）
        std::priority_queue<std::pair<float, uint32_t>> final_top;

        while (!heap.empty()) {
            auto top = heap.top();
            uint32_t id = top.second;
            heap.pop();

            float dist = exact_distance(
                query_vec,
                base_data + (size_t)id * dim);

            if ((int)final_top.size() < topk) {
                final_top.emplace(dist, id);
            } else if (dist < final_top.top().first) {
                final_top.pop();
                final_top.emplace(dist, id);
            }
        }

        return final_top;
    }

    // ================================
    // 设置原始数据（用于rerank）
    // ================================
    void set_base_data(const float* data) {
        base_data = data;
    }
};


// ======================================
// 全局接口（和你现有代码一致）
// ======================================
static PQIndexBaseline g_pq_baseline;

inline std::priority_queue<std::pair<float,uint32_t>>
pq_search_baseline(
    float* base,
    float* query,
    size_t base_n,
    size_t dim,
    size_t k,
    int rerank_k=0)
{
    g_pq_baseline.set_base_data(base);
    g_pq_baseline.dim = dim;

    return g_pq_baseline.query(query, (int)k, rerank_k);

}
