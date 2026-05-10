#pragma once
#include <arm_neon.h>

// 封装 8 路浮点并行计算
struct Simd8Float {
    float32x4x2_t data;

    // 默认构造
    Simd8Float() = default;

    // 从内存加载数据
    explicit Simd8Float(const float* x) {
        data.val[0] = vld1q_f32(x);
        data.val[1] = vld1q_f32(x + 4);
    }

    // 向量乘法: operator*
    Simd8Float operator*(const Simd8Float& other) const {
        Simd8Float res;
        res.data.val[0] = vmulq_f32(data.val[0], other.data.val[0]);
        res.data.val[1] = vmulq_f32(data.val[1], other.data.val[1]);
        return res;
    }

    // 向量加法: operator+
    Simd8Float operator+(const Simd8Float& other) const {
        Simd8Float res;
        res.data.val[0] = vaddq_f32(data.val[0], other.data.val[0]);
        res.data.val[1] = vaddq_f32(data.val[1], other.data.val[1]);
        return res;
    }

    // FMA 
    // this = this + (a * b)
    void fma(const Simd8Float& a, const Simd8Float& b) {
        data.val[0] = vfmaq_f32(data.val[0], a.data.val[0], b.data.val[0]);
        data.val[1] = vfmaq_f32(data.val[1], a.data.val[1], b.data.val[1]);
    }

    // 将 8 路数据求和并返回单个标量
    float horizontal_sum() const {
	float32x4_t sum4 = vaddq_f32(data.val[0], data.val[1]);
        return vaddvq_f32(sum4); 
    }
};
inline float InnerProductSIMD(const float* a, const float* b, size_t dim) {
    // 1. 定义 4 个独立的向量累加器
    float32x4_t sum0 = vdupq_n_f32(0.0f);
    float32x4_t sum1 = vdupq_n_f32(0.0f);
    float32x4_t sum2 = vdupq_n_f32(0.0f);
    float32x4_t sum3 = vdupq_n_f32(0.0f);

    size_t i = 0;
    // 2. 主循环：每次处理 32 个浮点数 (4 路 * 8 路)
    for (; i + 31 < dim; i += 32) {
        // 第一路 
        sum0 = vfmaq_f32(sum0, vld1q_f32(a + i + 0),  vld1q_f32(b + i + 0));
        sum1 = vfmaq_f32(sum1, vld1q_f32(a + i + 4),  vld1q_f32(b + i + 4));
        
        // 第二路 
        sum2 = vfmaq_f32(sum2, vld1q_f32(a + i + 8),  vld1q_f32(b + i + 8));
        sum3 = vfmaq_f32(sum3, vld1q_f32(a + i + 12), vld1q_f32(b + i + 12));
        
        // 第三路 
        sum0 = vfmaq_f32(sum0, vld1q_f32(a + i + 16), vld1q_f32(b + i + 16));
        sum1 = vfmaq_f32(sum1, vld1q_f32(a + i + 20), vld1q_f32(b + i + 20));
        
        // 第四路 
        sum2 = vfmaq_f32(sum2, vld1q_f32(a + i + 24), vld1q_f32(b + i + 24));
        sum3 = vfmaq_f32(sum3, vld1q_f32(a + i + 28), vld1q_f32(b + i + 28));
    }

    // 3. 剩余部分处理 (针对非 32 倍数)
    for (; i + 3 < dim; i += 4) {
        sum0 = vfmaq_f32(sum0, vld1q_f32(a + i), vld1q_f32(b + i));
    }
    // 4. 求和 
    // 先将 4 个累加器合并
    float32x4_t final_sum_vec = vaddq_f32(vaddq_f32(sum0, sum1), vaddq_f32(sum2, sum3));
    // 处理最后少数不足 4 个的元素 
    float final_res = vaddvq_f32(final_sum_vec);
    for (; i < dim; ++i) {
        final_res += a[i] * b[i];
    }
    return 1.0f-final_res;
};

