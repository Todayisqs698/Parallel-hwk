#pragma once

#include <vector>
#include <queue>
#include <algorithm>
#include <numeric>
#include <string>
#include <fstream>
#include <stdexcept>
#include <iostream>
#include <cstring>
#include <cmath>
#include <cassert>
#include <limits>
#include <random>
#include <omp.h>
#include <arm_neon.h>
#include "hnswlib/hnswlib/hnswlib.h"

using namespace hnswlib;


// NEON SIMD L2 距离（用于粗排：query 到各簇心的距离）
static inline float neon_l2sqr(const float* a, const float* b, size_t dim) {
    float32x4_t sum0 = vdupq_n_f32(0.f);
    float32x4_t sum1 = vdupq_n_f32(0.f);
    size_t i = 0;
    for (; i + 8 <= dim; i += 8) {
        float32x4_t d0 = vsubq_f32(vld1q_f32(a+i),   vld1q_f32(b+i));
        float32x4_t d1 = vsubq_f32(vld1q_f32(a+i+4), vld1q_f32(b+i+4));
        sum0 = vfmaq_f32(sum0, d0, d0);
        sum1 = vfmaq_f32(sum1, d1, d1);
    }
    for (; i + 4 <= dim; i += 4) {
        float32x4_t d = vsubq_f32(vld1q_f32(a+i), vld1q_f32(b+i));
        sum0 = vfmaq_f32(sum0, d, d);
    }
    float s = vaddvq_f32(vaddq_f32(sum0, sum1));
    for (; i < dim; ++i) { float d = a[i]-b[i]; s += d*d; }
    return s;
}

using IVFHNSWPair = std::pair<float, labeltype>;
using IVFHNSWHeap = std::priority_queue<IVFHNSWPair>;   // 大顶堆

static inline void ivfhnsw_heap_push(IVFHNSWHeap& h, float d, labeltype id, size_t p) {
    if (h.size() < p)             h.emplace(d, id);
    else if (d < h.top().first) { h.pop(); h.emplace(d, id); }
}


// IVFHNSWIndex
class IVFHNSWIndex {
public:
    size_t dim_;              
    size_t nlist_;            
    int    M_;                
    int    ef_construction_;  

    std::vector<float> centroids_;                    
    std::vector<InnerProductSpace*>   spaces_;
    std::vector<HierarchicalNSW<float>*>           sub_indexes_;
    std::vector<std::vector<labeltype>>            sub_label_to_global_;
    size_t N_  = 0;   

    IVFHNSWIndex(size_t dim, size_t nlist, int M = 16, int ef_construction = 150)
        : dim_(dim), nlist_(nlist), M_(M), ef_construction_(ef_construction) {}

    ~IVFHNSWIndex() { clear(); }

    void clear() {
        for (auto* p : sub_indexes_) delete p;
        for (auto* p : spaces_)      delete p;
        sub_indexes_.clear();
        spaces_.clear();
        sub_label_to_global_.clear();
        centroids_.clear();
    }

    
    // build
    void build(const float* base, size_t n, int kmeans_iter = 20, float kmeans_tol = 1e-4f) {
        clear();
        N_   = n;
        if (n == 0) throw std::runtime_error("[IVF-HNSW] Empty base");
        if (nlist_ > n) {
            std::cerr << "[IVF-HNSW] Warning: nlist=" << nlist_ << " > N=" << n << ", reduced to " << n << "\n";
            nlist_ = n;
        }

        std::cout << "[IVF-HNSW] K-means: nlist=" << nlist_ << "  iter=" << kmeans_iter << "  N=" << n << "\n";
        kmeans_train(base, n, kmeans_iter, kmeans_tol);

        std::cout << "[IVF-HNSW] Assigning " << n << " vectors to clusters...\n";
        std::vector<int> assign(n);
        assign_to_clusters(base, n, assign);

        std::vector<std::vector<size_t>> buckets(nlist_);
        for (size_t i = 0; i < n; ++i)
            buckets[assign[i]].push_back(i);

        spaces_.resize(nlist_, nullptr);
        sub_indexes_.resize(nlist_, nullptr);
        sub_label_to_global_.resize(nlist_);

        for (size_t c = 0; c < nlist_; ++c) {
            spaces_[c]   = new InnerProductSpace(dim_);
            size_t sz    = buckets[c].size();
            sub_indexes_[c] = new HierarchicalNSW<float>(spaces_[c], std::max(sz, (size_t)1), M_, ef_construction_);
            sub_label_to_global_[c] = std::vector<labeltype>(sz);
        }

        std::cout << "[IVF-HNSW] Building sub-indexes with continuous cache buffers...\n";

        // OpenMP 并行
        #pragma omp parallel for schedule(dynamic, 1)
        for (int c = 0; c < (int)nlist_; ++c) {
            const std::vector<size_t>& bkt = buckets[c];
            size_t bkt_sz = bkt.size();
            if (bkt_sz == 0) continue;

            std::vector<float> local_continuous_buffer(bkt_sz * dim_);
            for (size_t j = 0; j < bkt_sz; ++j) {
                std::memcpy(local_continuous_buffer.data() + j * dim_,
                            base + bkt[j] * dim_, 
                            dim_ * sizeof(float));
            }

            // HNSW 从高局部性的连续地址读取数据
            for (size_t j = 0; j < bkt_sz; ++j) {
                const float* v = local_continuous_buffer.data() + j * dim_;
                sub_indexes_[c]->addPoint(v, (labeltype)j);
                sub_label_to_global_[c][j] = (labeltype)bkt[j];
            }
        }
        std::cout << "[IVF-HNSW] Build done.\n";
    }

    
    // search:Query-level 粗排双阶段自适应剪枝 + 动态 ef
    IVFHNSWHeap search(const float* query, size_t k, size_t nprobe, size_t ef_search = 0) const {
        if (sub_indexes_.empty())
            throw std::runtime_error("[IVF-HNSW] Index not built");
        if (ef_search < k) ef_search = k;
        nprobe = std::min(nprobe, nlist_);

        // 粗排：NEON SIMD 计算距离
        std::vector<std::pair<float, size_t>> cdists(nlist_);
        #pragma omp simd
        for (size_t c = 0; c < nlist_; ++c)
            cdists[c] = {neon_l2sqr(query, centroids_.data() + c * dim_, dim_), c};

        std::partial_sort(cdists.begin(), cdists.begin() + nprobe, cdists.end());

        int num_t = omp_get_max_threads();
        std::vector<IVFHNSWHeap> thread_heaps(num_t);

    
        // 阶段 A：先用极高并行度扫描前 2 个最自信的近邻桶，快速建立局部 Top-K 临界线
        size_t confident_probe = std::min((size_t)6, nprobe);
        
        #pragma omp parallel for schedule(dynamic, 1)
        for (int ci = 0; ci < (int)confident_probe; ++ci) {
            size_t cid = cdists[ci].second;
            int tid = omp_get_thread_num();

            if (sub_indexes_[cid]->cur_element_count == 0) continue;

            sub_indexes_[cid]->setEf(ef_search); // 核心桶分配完整 ef_search
            auto local = sub_indexes_[cid]->searchKnn(query, k);

            const auto& label_map = sub_label_to_global_[cid];
            while (!local.empty()) {
                auto top = local.top(); local.pop();
                if (top.second < label_map.size()) {
                    ivfhnsw_heap_push(thread_heaps[tid], top.first, label_map[top.second], k);
                }
            }
        }

        // 估计当前系统第 k 名的最佳距离上界
        float pruning_threshold = std::numeric_limits<float>::max();
        size_t total_collected = 0;
        for (const auto& lh : thread_heaps) {
            total_collected += lh.size();
        }
        // 如果前 2 个核心桶已经填满了候选堆，取出第 0 号线程大顶堆的堆顶作为乐观边界
        if (total_collected >= k && !thread_heaps[0].empty()) {
            pruning_threshold = thread_heaps[0].top().first;
        }

    
        // 阶段 B：对其余长尾桶进行自适应启发式剪枝与ef_search 降级
        if (nprobe > confident_probe) {
            #pragma omp parallel for schedule(dynamic, 1)
            for (int ci = (int)confident_probe; ci < (int)nprobe; ++ci) {
                size_t cid = cdists[ci].second;
                float center_dist = cdists[ci].first;
                int tid = omp_get_thread_num();

                if (sub_indexes_[cid]->cur_element_count == 0) continue;

                // 动态剪枝策略：如果当前 Query 到桶中心的粗排距离，已经劣于当前 Top-K 的最差候选距离，说明该桶内绝对不可能包含能入选全局 Top-K的点，直接跳过整个桶的搜索   
                if (center_dist > pruning_threshold) {
                    continue; 
                }

                // 动态 ef_search 路由
                size_t dynamic_ef = std::max(k, ef_search / 2);
                sub_indexes_[cid]->setEf(dynamic_ef);
                
                auto local = sub_indexes_[cid]->searchKnn(query, k);

                const auto& label_map = sub_label_to_global_[cid];
                while (!local.empty()) {
                    auto top = local.top(); local.pop();
                    if (top.second < label_map.size()) {
                        ivfhnsw_heap_push(thread_heaps[tid], top.first, label_map[top.second], k);
                    }
                }
            }
        }

        // 归并
        IVFHNSWHeap result;
        for (auto& lh : thread_heaps) {
            while (!lh.empty()) {
                ivfhnsw_heap_push(result, lh.top().first, lh.top().second, k);
                lh.pop();
            }
        }
        return result;
    }

    void save(const std::string& path) const {
        if (sub_indexes_.empty()) throw std::runtime_error("[IVF-HNSW] Nothing to save");
        std::ofstream f(path, std::ios::binary);
        if (!f) throw std::runtime_error("[IVF-HNSW] Cannot open: " + path);

        write_pod(f, dim_); write_pod(f, nlist_); write_pod(f, N_);
        write_pod(f, (size_t)M_); write_pod(f, (size_t)ef_construction_);

        f.write(reinterpret_cast<const char*>(centroids_.data()), centroids_.size() * sizeof(float));

        for (size_t c = 0; c < nlist_; ++c) {
            size_t sz = sub_label_to_global_[c].size();
            write_pod(f, sz);
            f.write(reinterpret_cast<const char*>(sub_label_to_global_[c].data()), sz * sizeof(labeltype));

            std::string tmp = path + ".tmp_" + std::to_string(c);
            sub_indexes_[c]->saveIndex(tmp);
            std::ifstream tf(tmp, std::ios::binary | std::ios::ate);
            size_t blob_size = (size_t)tf.tellg();
            tf.seekg(0);
            write_pod(f, blob_size);
            std::vector<char> blob(blob_size);
            tf.read(blob.data(), blob_size);
            f.write(blob.data(), blob_size);
            tf.close();
            std::remove(tmp.c_str());
        }
    }

    void load(const std::string& path) {
        clear();
        std::ifstream f(path, std::ios::binary);
        if (!f) throw std::runtime_error("[IVF-HNSW] Cannot open: " + path);

        size_t m_t, efc_t;
        read_pod(f, dim_); read_pod(f, nlist_); read_pod(f, N_);
        read_pod(f, m_t); M_ = (int)m_t; read_pod(f, efc_t); ef_construction_ = (int)efc_t;

        centroids_.resize(nlist_ * dim_);
        f.read(reinterpret_cast<char*>(centroids_.data()), centroids_.size() * sizeof(float));

        spaces_.resize(nlist_); sub_indexes_.resize(nlist_); sub_label_to_global_.resize(nlist_);

        for (size_t c = 0; c < nlist_; ++c) {
            size_t sz; read_pod(f, sz);
            sub_label_to_global_[c].resize(sz);
            f.read(reinterpret_cast<char*>(sub_label_to_global_[c].data()), sz * sizeof(labeltype));

            size_t blob_size; read_pod(f, blob_size);
            std::string tmp = path + ".load_tmp_" + std::to_string(c);
            {
                std::ofstream tf(tmp, std::ios::binary);
                std::vector<char> blob(blob_size);
                f.read(blob.data(), blob_size);
                tf.write(blob.data(), blob_size);
            }
            spaces_[c]      = new InnerProductSpace(dim_);
            sub_indexes_[c] = new HierarchicalNSW<float>(spaces_[c], tmp, spaces_[c], sz);
            std::remove(tmp.c_str());
        }
    }

private:
    void kmeans_train(const float* base, size_t n, int max_iter, float tol) {
        centroids_.assign(nlist_ * dim_, 0.f);
        std::vector<size_t> idx(n);
        std::iota(idx.begin(), idx.end(), 0);
        std::mt19937 rng(42);
        std::shuffle(idx.begin(), idx.end(), rng);
        for (size_t c = 0; c < nlist_; ++c)
            std::memcpy(centroids_.data() + c*dim_, base + idx[c]*dim_, dim_*sizeof(float));

        std::vector<int> assign(n);
        for (int iter = 0; iter < max_iter; ++iter) {
            #pragma omp parallel for schedule(static)
            for (int i = 0; i < (int)n; ++i) {
                float md = std::numeric_limits<float>::max(); int bk = 0;
                const float* v = base + (size_t)i*dim_;
                for (size_t c = 0; c < nlist_; ++c) {
                    float d = neon_l2sqr(v, centroids_.data()+c*dim_, dim_);
                    if (d < md) { md = d; bk = (int)c; }
                }
                assign[i] = bk;
            }
            std::vector<float> new_c(nlist_*dim_, 0.f);
            std::vector<int>   cnt(nlist_, 0);
            for (size_t i = 0; i < n; ++i) {
                int c = assign[i]; cnt[c]++;
                for (size_t d = 0; d < dim_; ++d)
                    new_c[c*dim_+d] += base[i*dim_+d];
            }
            float max_shift = 0.f;
            for (size_t c = 0; c < nlist_; ++c) {
                if (cnt[c] == 0) continue;
                float shift = 0.f;
                for (size_t d = 0; d < dim_; ++d) {
                    float new_val = new_c[c*dim_+d] / cnt[c];
                    float diff    = new_val - centroids_[c*dim_+d];
                    shift        += diff*diff;
                    centroids_[c*dim_+d] = new_val;
                }
                max_shift = std::max(max_shift, std::sqrt(shift));
            }
            if (max_shift < tol) break;
        }
    }

    void assign_to_clusters(const float* base, size_t n, std::vector<int>& assign) {
        assign.resize(n);
        #pragma omp parallel for schedule(static)
        for (int i = 0; i < (int)n; ++i) {
            float md = std::numeric_limits<float>::max(); int bk = 0;
            const float* v = base + (size_t)i*dim_;
            for (size_t c = 0; c < nlist_; ++c) {
                float d = neon_l2sqr(v, centroids_.data()+c*dim_, dim_);
                if (d < md) { md = d; bk = (int)c; }
            }
            assign[i] = bk;
        }
    }

    template<typename T> static void write_pod(std::ofstream& f, const T& v) { f.write(reinterpret_cast<const char*>(&v), sizeof(T)); }
    template<typename T> static void read_pod(std::ifstream& f, T& v) { f.read(reinterpret_cast<char*>(&v), sizeof(T)); }
};