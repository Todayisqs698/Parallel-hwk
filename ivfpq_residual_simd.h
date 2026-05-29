#pragma once

#include "ivf_index_base.h"
#include <arm_neon.h>


static const int RPQIVF_M     = 16;
static const int RPQIVF_K     = 256;
static const int RPQIVF_SUBD  = 6;
static const int RPQIVF_ALND  = 8;
static const int RPQIVF_MITER = 10;
static const int RPQIVF_LUT_N = RPQIVF_M * RPQIVF_K;  // 4096 floats = 16KB

class IVFPQResidualSIMD : public IVFIndexBase {
public:
 
    std::vector<std::vector<float>>   local_codebooks_;  // [nlist][M×K×ALND]
    std::vector<std::vector<uint8_t>> inv_pq_codes_;     // [nlist][list_len×M]


    void build_residual_pq(const float* base, size_t n, size_t d,
                            size_t nl, int kmeans_iter = IVF_KMEANS_ITER) {
        //  IVF 聚类
        std::cout << "[IVF-PQ-Residual] Step1: IVF clustering (nlist="
                  << nl << ")..." << std::endl;
        build(base, n, d, nl, kmeans_iter);

        // 每簇计算残差 → 训练本地码本
        std::cout << "[IVF-PQ-Residual] Step2+3: Training " << nlist
                  << " local codebooks..." << std::endl;
        local_codebooks_.resize(nlist);
        for (size_t c = 0; c < nlist; ++c) {
            local_codebooks_[c].assign(RPQIVF_M * RPQIVF_K * RPQIVF_ALND, 0.f);
            size_t len = inv_ids[c].size();

            // 构建残差矩阵：residuals[j] = inv_vecs[c][j] - centroids[c]
            std::vector<float> residuals(len * dim);
            const float* centroid = centroids.data() + c * dim;
            for (size_t j = 0; j < len; ++j) {
                const float* v = inv_vecs[c].data() + j * dim;
                float*       r = residuals.data() + j * dim;
                for (size_t dd = 0; dd < dim; ++dd)
                    r[dd] = v[dd] - centroid[dd];
            }

            // 簇内样本不足 K 时，从全库随机补充（避免 KMeans 空簇）
            // 以最小样本数 = K 为目标
            std::vector<float> train_data;
            if (len >= (size_t)RPQIVF_K) {
                train_data = residuals;   
            } else {
                // 不足时补充全库随机残差（用全库簇心 0 号作近似）
                train_data = residuals;
                std::mt19937 rng(42 + (int)c);
                std::uniform_int_distribution<size_t> uid(0, n-1);
                size_t need = (size_t)RPQIVF_K - len;
                const float* c0 = centroids.data();  // 用簇心0补充
                for (size_t extra = 0; extra < need; ++extra) {
                    size_t pick = uid(rng);
                    for (size_t dd = 0; dd < dim; ++dd)
                        train_data.push_back(base[pick*dim+dd] - c0[dd]);
                }
            }

            size_t train_n = train_data.size() / dim;
            for (int m = 0; m < RPQIVF_M; ++m)
                train_subspace(train_data.data(), train_n, m,
                               local_codebooks_[c].data() + m*RPQIVF_K*RPQIVF_ALND);
        }

        // 用本地码本对各簇残差编码
        std::cout << "[IVF-PQ-Residual] Step4: Encoding residuals..." << std::endl;
        inv_pq_codes_.resize(nlist);
        for (size_t c = 0; c < nlist; ++c) {
            size_t len = inv_ids[c].size();
            inv_pq_codes_[c].resize(len * RPQIVF_M);
            const float* centroid = centroids.data() + c * dim;
            const float* cb       = local_codebooks_[c].data();
            for (size_t j = 0; j < len; ++j) {
                const float* v = inv_vecs[c].data() + j * dim;
                // 计算残差
                std::vector<float> res(dim);
                for (size_t dd = 0; dd < dim; ++dd)
                    res[dd] = v[dd] - centroid[dd];
                // 用本地码本编码
                encode_residual(res.data(), cb,
                                inv_pq_codes_[c].data() + j * RPQIVF_M);
            }
        }
        std::cout << "[IVF-PQ-Residual] Build done." << std::endl;
    }

    IVFHeap search(const float* query, size_t k,
                   size_t nprobe, size_t rerank_p = 0) const {
        if (rerank_p < k) rerank_p = k;
        nprobe = std::min(nprobe, nlist);

        // 粗排
        std::vector<size_t> sel;
        coarse_select(query, nprobe, sel);

        // 对每个候选簇，独立构建 LUT + ADC 扫描
        IVFHeap coarse;
        alignas(64) float lut[RPQIVF_LUT_N];

        for (size_t ci = 0; ci < nprobe; ++ci) {
            size_t cid = sel[ci];

            // 计算 query 相对于簇心 cid 的残差查询向量
            // query_res_c = query - centroids[cid]
            alignas(16) float query_res[96] = {};   // dim <= 96
            const float* centroid = centroids.data() + cid * dim;
            for (size_t dd = 0; dd < dim; ++dd)
                query_res[dd] = query[dd] - centroid[dd];

            // 用簇 cid 的本地码本为残差查询向量构建 LUT（NEON SIMD）
            build_lut_simd_local(query_res, local_codebooks_[cid].data(), lut);

            // ADC 扫描：与全局码本版完全相同的内层循环
            size_t         n_vec    = inv_ids[cid].size();
            const uint8_t* base_ptr = inv_pq_codes_[cid].data();

            if (n_vec > 0) __builtin_prefetch(base_ptr, 0, 3);

            for (size_t j = 0; j < n_vec; ++j) {
                if (j + 16 < n_vec)
                    __builtin_prefetch(base_ptr + (j+16)*RPQIVF_M, 0, 2);

                const uint8_t* vc = base_ptr + j * RPQIVF_M;
                float s0 = lut[0*RPQIVF_K + vc[0]];
                float s1 = lut[1*RPQIVF_K + vc[1]];
                float s2 = lut[2*RPQIVF_K + vc[2]];
                float s3 = lut[3*RPQIVF_K + vc[3]];
                for (int m = 4; m < RPQIVF_M; m += 4) {
                    s0 += lut[(m+0)*RPQIVF_K + vc[m+0]];
                    s1 += lut[(m+1)*RPQIVF_K + vc[m+1]];
                    s2 += lut[(m+2)*RPQIVF_K + vc[m+2]];
                    s3 += lut[(m+3)*RPQIVF_K + vc[m+3]];
                }
                ivf_heap_push(coarse, s0+s1+s2+s3, inv_ids[cid][j], rerank_p);
            }
        }

        //Rerank
        IVFHeap final_k;
        while (!coarse.empty()) {
            uint32_t id = coarse.top().second;
            coarse.pop();
            float exact = InnerProductSIMD(raw_base + (size_t)id * dim,
                                            query, dim);
            ivf_heap_push(final_k, exact, id, k);
        }
        return final_k;
    }

private:
    void build_lut_simd_local(const float* query_res,
                               const float* cb,      
                               float*       lut) const {
        for (int m = 0; m < RPQIVF_M; ++m) {
            alignas(16) float q_align[RPQIVF_ALND] = {};
            std::memcpy(q_align, query_res + m * RPQIVF_SUBD,
                        RPQIVF_SUBD * sizeof(float));
            float32x4_t q_v0 = vld1q_f32(q_align);
            float32x4_t q_v1 = vld1q_f32(q_align + 4);

            const float* cb_m  = cb + m * RPQIVF_K * RPQIVF_ALND;
            float*       lut_m = lut + m * RPQIVF_K;

            for (int ki = 0; ki < RPQIVF_K; ki += 4) {
                for (int jj = 0; jj < 4; ++jj) {
                    const float* c = cb_m + (ki+jj) * RPQIVF_ALND;
                    float32x4_t d0 = vsubq_f32(q_v0, vld1q_f32(c));
                    float32x4_t d1 = vsubq_f32(q_v1, vld1q_f32(c+4));
                    lut_m[ki+jj]   = vaddvq_f32(
                        vfmaq_f32(vmulq_f32(d0, d0), d1, d1));
                }
            }
        }
    }
    void encode_residual(const float* res, const float* cb, uint8_t* out) const {
        for (int m = 0; m < RPQIVF_M; ++m) {
            const float* vs = res + m * RPQIVF_SUBD;
            const float* cbm = cb + m * RPQIVF_K * RPQIVF_ALND;
            float mn = std::numeric_limits<float>::max(); uint8_t bk = 0;
            for (int ki = 0; ki < RPQIVF_K; ++ki) {
                const float* c = cbm + ki * RPQIVF_ALND;
                float d = 0;
                for (int sd = 0; sd < RPQIVF_SUBD; ++sd) {
                    float df = vs[sd]-c[sd]; d += df*df;
                }
                if (d < mn) { mn = d; bk = (uint8_t)ki; }
            }
            out[m] = bk;
        }
    }

    //子空间 KMeans 训练（与其他文件一致）
    void train_subspace(const float* data, size_t n_t, int m, float* out_cb) {
        std::vector<size_t> idx(n_t);
        for (size_t i = 0; i < n_t; ++i) idx[i] = i;
        std::mt19937 rng(99 + m); 
        std::shuffle(idx.begin(), idx.end(), rng);
        size_t init_k = std::min((size_t)RPQIVF_K, n_t);
        for (size_t k = 0; k < init_k; ++k)
            std::memcpy(out_cb + k*RPQIVF_ALND,
                        data + idx[k]*dim + m*RPQIVF_SUBD,
                        RPQIVF_SUBD * sizeof(float));

        for (int k = (int)init_k; k < RPQIVF_K; ++k)
            std::memcpy(out_cb + k*RPQIVF_ALND,
                        out_cb + (k % (int)init_k)*RPQIVF_ALND,
                        RPQIVF_ALND * sizeof(float));

        std::vector<int> asgn(n_t);
        for (int iter = 0; iter < RPQIVF_MITER; ++iter) {
            for (size_t i = 0; i < n_t; ++i) {
                const float* v = data + i*dim + m*RPQIVF_SUBD;
                float md = std::numeric_limits<float>::max(); int bk = 0;
                for (int k = 0; k < RPQIVF_K; ++k) {
                    float d = 0; const float* c = out_cb + k*RPQIVF_ALND;
                    for (int sd = 0; sd < RPQIVF_SUBD; ++sd) {
                        float df = v[sd]-c[sd]; d += df*df;
                    }
                    if (d < md) { md = d; bk = k; }
                }
                asgn[i] = bk;
            }
            std::vector<float> nc(RPQIVF_K * RPQIVF_SUBD, 0.f);
            std::vector<int>   cnt(RPQIVF_K, 0);
            for (size_t i = 0; i < n_t; ++i) {
                int k = asgn[i]; cnt[k]++;
                for (int sd = 0; sd < RPQIVF_SUBD; ++sd)
                    nc[k*RPQIVF_SUBD+sd] += data[i*dim+m*RPQIVF_SUBD+sd];
            }
            for (int k = 0; k < RPQIVF_K; ++k) {
                if (cnt[k] > 0)
                    for (int sd = 0; sd < RPQIVF_SUBD; ++sd)
                        out_cb[k*RPQIVF_ALND+sd] = nc[k*RPQIVF_SUBD+sd]/cnt[k];
            }
        }
    }
};