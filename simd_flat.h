#pragma once
#include <vector>
#include <queue>
#include <algorithm>
#include "simd_utils.h" 
inline std::priority_queue<std::pair<float, uint32_t>> simd_flat_search(
    const float* base,
    const float* query,
    size_t base_number,
    size_t vecdim,
    size_t k) {
    // 最大堆
    std::priority_queue<std::pair<float, uint32_t>> top_k;

    for (size_t i = 0; i < base_number; ++i) {
        const float* vec = base + i * vecdim;
        float dist = InnerProductSIMD(vec, query, vecdim);
        if (top_k.size() < k) {
            top_k.emplace(dist, (uint32_t)i);
        } else if (dist < top_k.top().first) {
            top_k.pop();
            top_k.emplace(dist, (uint32_t)i);
        }
    }

    return top_k;
}
