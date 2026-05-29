#pragma once
#include <arm_neon.h>

// 封装 8 路浮点并行计算
struct Simd8Float {
    float32x4x2_t data;

    Simd8Float() {
        data.val[0] = vdupq_n_f32(0.0f);
        data.val[1] = vdupq_n_f32(0.0f);
    }

    // 从内存加载数据
    explicit Simd8Float(const float* x) {
        data.val[0] = vld1q_f32(x);
        data.val[1] = vld1q_f32(x + 4);
    }

    // FMA: this = this + (a * b)
    // 建议直接传入寄存器数据，减少结构体拷贝开销
    inline void fma(const float32x4_t& a0, const float32x4_t& a1, 
                   const float32x4_t& b0, const float32x4_t& b1) {
        data.val[0] = vfmaq_f32(data.val[0], a0, b0);
        data.val[1] = vfmaq_f32(data.val[1], a1, b1);
    }

    // 改进的水平求和
    float horizontal_sum() const {
        // 分别求和再汇总，精度更稳
        return vaddvq_f32(data.val[0]) + vaddvq_f32(data.val[1]);
    }
};

// 极致优化的内积函数：4路并行展开 (处理16个float/循环)
inline float InnerProductSIMD(const float* a, const float* b, size_t dim) {
    float32x4_t sum0 = vdupq_n_f32(0.0f);
    float32x4_t sum1 = vdupq_n_f32(0.0f);
    float32x4_t sum2 = vdupq_n_f32(0.0f);
    float32x4_t sum3 = vdupq_n_f32(0.0f);
    
    size_t i = 0;
    // 16-way unrolling: 提升吞吐量，降低循环跳转开销
    for (; i + 15 < dim; i += 16) {
        sum0 = vfmaq_f32(sum0, vld1q_f32(a + i),      vld1q_f32(b + i));
        sum1 = vfmaq_f32(sum1, vld1q_f32(a + i + 4),  vld1q_f32(b + i + 4));
        sum2 = vfmaq_f32(sum2, vld1q_f32(a + i + 8),  vld1q_f32(b + i + 8));
        sum3 = vfmaq_f32(sum3, vld1q_f32(a + i + 12), vld1q_f32(b + i + 12));
    }

    // 处理剩余的 8 个元素
    for (; i + 7 < dim; i += 8) {
        sum0 = vfmaq_f32(sum0, vld1q_f32(a + i),     vld1q_f32(b + i));
        sum1 = vfmaq_f32(sum1, vld1q_f32(a + i + 4), vld1q_f32(b + i + 4));
    }

    // 汇总各路寄存器
    float32x4_t final_sum = vaddq_f32(vaddq_f32(sum0, sum1), vaddq_f32(sum2, sum3));
    float res = vaddvq_f32(final_sum);

    // 处理末尾不足 8 个的部分
    for (; i < dim; ++i) {
        res += a[i] * b[i];
    }
    
    // 注意：如果是余弦距离，返回 1.0 - IP；如果是纯内积，直接返回 res
    return 1.0f - res; 
}
