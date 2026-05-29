#pragma once
/**
 * ivfpq_index_base.h  —  IVF-PQ 中间层基类
 * PQ 参数（与 simd_pq.h 完全对齐）：
 *   M_PQ  = 16  子空间数
 *   K_PQ  = 256 每子空间聚类数（uint8_t 编码）
 *   SUB_D = 6   每子空间维度（dim=96 时，16×6=96 ✓）
 *   ALN_D = 8   对齐维度（NEON float32x4_t×2 加载，SUB_D 尾部补 0）
 *
 * 提供给子类的工具：
 *   build_pq()          — 训练码本 + 编码全库 + 分配到倒排列表
 *   build_lut()         — 构建单条 query 的距离查找表（标量版）
 *   build_lut_simd()    — 构建 LUT（NEON 4路展开版）
 *   scan_list_serial()  — 串行扫描单个簇的 PQ codes，累加 ADC 距离
 *   rerank()            — 对粗候选 top-rerank_p 精排（InnerProductSIMD）
 * ─────────────────────────────────────────────────────────────────────
 */

#include "ivf_index_base.h"
#include <arm_neon.h>

static const int PQ_M     = 16;
static const int PQ_K     = 256;
static const int PQ_SUBD  = 6;
static const int PQ_ALND  = 8;
static const int PQ_MITER = 10;
// LUT 总浮点数：M × K = 4096，字节数 16KB
static const int PQ_LUT_N = PQ_M * PQ_K;

struct IVFPQIndexBase : public IVFIndexBase {

    std::vector<float>   pq_codebooks_;              // [M × K × ALN_D]
    std::vector<std::vector<uint8_t>> inv_pq_codes_; // [nlist][list_len × M]

    
    void build_pq(const float* base, size_t n, size_t d,
                  size_t nl, int kmeans_iter = IVF_KMEANS_ITER) {
        //先调用父类 build，构建 IVF 倒排列表 
        build(base, n, d, nl, kmeans_iter);

        //PQ 码本训练（全库前 10000 条作为训练集）
        std::cout << "[IVF-PQ] Training PQ codebooks (M=" << PQ_M
                  << " K=" << PQ_K << ")..." << std::endl;
        pq_codebooks_.assign(PQ_M * PQ_K * PQ_ALND, 0.f);
        size_t train_n = std::min(N, (size_t)10000);
        for (int m = 0; m < PQ_M; ++m)
            pq_train_subspace(base, train_n, m,
                              &pq_codebooks_[m * PQ_K * PQ_ALND]);

        // 全库 PQ 编码
        std::cout << "[IVF-PQ] Encoding " << N << " vectors..." << std::endl;
        std::vector<uint8_t> global_codes(N * PQ_M);
        for (size_t i = 0; i < N; ++i)
            pq_encode_vec(base + i * dim, &global_codes[i * PQ_M]);

        //将 PQ codes 按 IVF 分配结果写入各簇 
        inv_pq_codes_.resize(nlist);
        for (size_t c = 0; c < nlist; ++c) {
            size_t len = inv_ids[c].size();
            inv_pq_codes_[c].resize(len * PQ_M);
            for (size_t j = 0; j < len; ++j) {
                uint32_t gid = inv_ids[c][j];
                std::memcpy(&inv_pq_codes_[c][j * PQ_M],
                            &global_codes[gid * PQ_M],
                            PQ_M);
            }
        }
        std::cout << "[IVF-PQ] Build done." << std::endl;
    }

 
    // 标量版 LUT 构建
    void build_lut(const float* query, float* lut) const {
        for (int m = 0; m < PQ_M; ++m) {
            const float* q_sub = query + m * PQ_SUBD;
            const float* cb_m  = &pq_codebooks_[m * PQ_K * PQ_ALND];
            float*       lut_m = lut + m * PQ_K;
            for (int ki = 0; ki < PQ_K; ++ki) {
                const float* c = cb_m + ki * PQ_ALND;
                float s = 0.f;
                for (int sd = 0; sd < PQ_SUBD; ++sd) {
                    float df = q_sub[sd] - c[sd]; s += df * df;
                }
                lut_m[ki] = s;
            }
        }
    }

 
    // build_lut_simd — NEON 4路展开版 LUT 构建
    void build_lut_simd(const float* query, float* lut) const {
        for (int m = 0; m < PQ_M; ++m) {
            alignas(16) float q_align[PQ_ALND] = {};
            std::memcpy(q_align, query + m * PQ_SUBD, PQ_SUBD * sizeof(float));
            float32x4_t q_v0 = vld1q_f32(q_align);
            float32x4_t q_v1 = vld1q_f32(q_align + 4);

            const float* cb_m  = &pq_codebooks_[m * PQ_K * PQ_ALND];
            float*       lut_m = lut + m * PQ_K;

            for (int ki = 0; ki < PQ_K; ki += 4) {
                for (int jj = 0; jj < 4; ++jj) {
                    const float* c  = cb_m + (ki + jj) * PQ_ALND;
                    float32x4_t d0  = vsubq_f32(q_v0, vld1q_f32(c));
                    float32x4_t d1  = vsubq_f32(q_v1, vld1q_f32(c + 4));
                    lut_m[ki + jj]  = vaddvq_f32(
                        vfmaq_f32(vmulq_f32(d0, d0), d1, d1));
                }
            }
        }
    }


    // 串行扫描单个簇的 PQ codes，ADC 累加距离
    void scan_list_serial(size_t cid, const float* lut,
                           size_t start, size_t end,
                           size_t p, IVFHeap& heap) const {
        const uint8_t* base_ptr = inv_pq_codes_[cid].data() + start * PQ_M;
        for (size_t j = start; j < end; ++j) {
            if (j + 16 < end)
                __builtin_prefetch(base_ptr + (j - start + 16) * PQ_M, 0, 3);

            const uint8_t* vc = base_ptr + (j - start) * PQ_M;
            float s0 = lut[0 * PQ_K + vc[0]];
            float s1 = lut[1 * PQ_K + vc[1]];
            float s2 = lut[2 * PQ_K + vc[2]];
            float s3 = lut[3 * PQ_K + vc[3]];
            for (int m = 4; m < PQ_M; m += 4) {
                s0 += lut[(m+0)*PQ_K + vc[m+0]];
                s1 += lut[(m+1)*PQ_K + vc[m+1]];
                s2 += lut[(m+2)*PQ_K + vc[m+2]];
                s3 += lut[(m+3)*PQ_K + vc[m+3]];
            }
            ivf_heap_push(heap, s0+s1+s2+s3, inv_ids[cid][j], p);
        }
    }

    // rerank — 对 PQ 粗候选精排
    IVFHeap rerank(IVFHeap& coarse, const float* query, size_t k) const {
        IVFHeap final_k;
        while (!coarse.empty()) {
            uint32_t id  = coarse.top().second;
            coarse.pop();
            float exact  = InnerProductSIMD(raw_base + (size_t)id * dim,
                                             query, dim);
            ivf_heap_push(final_k, exact, id, k);
        }
        return final_k;
    }

private:
    // PQ 子空间 KMeans 训练
    void pq_train_subspace(const float* base, size_t n_t, int m, float* out_cb) {
        std::vector<size_t> idx(n_t);
        for (size_t i = 0; i < n_t; ++i) idx[i] = i;
        std::mt19937 rng(42 + m);
        std::shuffle(idx.begin(), idx.end(), rng);
        // 随机初始化 K 个簇心
        for (int k = 0; k < PQ_K; ++k)
            std::memcpy(out_cb + k * PQ_ALND,
                        base + idx[k] * dim + m * PQ_SUBD,
                        PQ_SUBD * sizeof(float));
        std::vector<int> asgn(n_t);
        for (int iter = 0; iter < PQ_MITER; ++iter) {
            for (size_t i = 0; i < n_t; ++i) {
                const float* v = base + i * dim + m * PQ_SUBD;
                float md = std::numeric_limits<float>::max(); int bk = 0;
                for (int k = 0; k < PQ_K; ++k) {
                    float d = 0; const float* c = out_cb + k * PQ_ALND;
                    for (int sd = 0; sd < PQ_SUBD; ++sd) {
                        float df = v[sd]-c[sd]; d += df*df;
                    }
                    if (d < md) { md = d; bk = k; }
                }
                asgn[i] = bk;
            }
            std::vector<float> nc(PQ_K * PQ_SUBD, 0.f);
            std::vector<int>   cnt(PQ_K, 0);
            for (size_t i = 0; i < n_t; ++i) {
                int k = asgn[i]; cnt[k]++;
                for (int sd = 0; sd < PQ_SUBD; ++sd)
                    nc[k*PQ_SUBD+sd] += base[i*dim+m*PQ_SUBD+sd];
            }
            for (int k = 0; k < PQ_K; ++k) {
                if (cnt[k] > 0)
                    for (int sd = 0; sd < PQ_SUBD; ++sd)
                        out_cb[k*PQ_ALND+sd] = nc[k*PQ_SUBD+sd] / cnt[k];
                else {
                    size_t r = idx[std::uniform_int_distribution<size_t>(0,n_t-1)(rng)];
                    std::memcpy(out_cb+k*PQ_ALND, base+r*dim+m*PQ_SUBD,
                                PQ_SUBD*sizeof(float));
                }
            }
        }
    }

    //单向量 PQ 编码
    void pq_encode_vec(const float* v, uint8_t* out) const {
        for (int m = 0; m < PQ_M; ++m) {
            const float* vs = v + m * PQ_SUBD;
            const float* cb = &pq_codebooks_[m * PQ_K * PQ_ALND];
            float mn = std::numeric_limits<float>::max(); uint8_t bk = 0;
            for (int k = 0; k < PQ_K; ++k) {
                const float* c = cb + k * PQ_ALND;
                float d = 0;
                for (int sd = 0; sd < PQ_SUBD; ++sd) {
                    float df = vs[sd]-c[sd]; d += df*df;
                }
                if (d < mn) { mn = d; bk = (uint8_t)k; }
            }
            out[m] = bk;
        }
    }
};