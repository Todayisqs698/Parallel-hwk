#include <iostream>
#include <chrono>
#include <vector>
#include <cmath>
#include <algorithm>
#include <fstream>
#include <iomanip>
#include <functional>
#include <numeric>

using namespace std;

// 硬件参数配置
const double L1_CACHE_KB = 48.0;
const double L2_CACHE_KB = 2048.0;
const double L3_CACHE_KB = 30720.0;

struct TestResult {
    double mean;
    double stdev;
};

// 高精度测量函数：保留了标准差逻辑
TestResult measure_time(function<void()> func, int repeat_times) {
    vector<double> times;
    times.reserve(repeat_times);
    
    // 预热一次，排除冷启动干扰
    func(); 

    for (int i = 0; i < repeat_times; i++) {
        auto start = chrono::high_resolution_clock::now();
        func();
        auto end = chrono::high_resolution_clock::now();
        double duration = chrono::duration_cast<chrono::microseconds>(end - start).count() / 1000.0;
        times.push_back(duration);
    }

    double sum = accumulate(times.begin(), times.end(), 0.0);
    double mean = sum / repeat_times;

    double accum = 0.0;
    for (double t : times) accum += (t - mean) * (t - mean);
    double stdev = sqrt(accum / repeat_times);

    return {mean, stdev};
}

struct CacheAlignedMatrix {
    vector<double> data;
    int n;
    CacheAlignedMatrix(int size) : n(size) {
        data.resize((size_t)size * size, 1.0);
    }
    inline double get(int row, int col) const {
        return data[(size_t)row * n + col]; 
    }
};

// 逐列访问 (Naive)
void naive_column_access(const CacheAlignedMatrix& matrix, 
                        const vector<double>& vec,
                        vector<double>& result) {
    int n = matrix.n;
    for (int col = 0; col < n; col++) {
        double sum = 0.0;
        for (int row = 0; row < n; row++) {
            sum += matrix.get(row, col) * vec[row]; 
        }
        result[col] = sum;
    }
}

// 按行访问 (Optimized)
void optimized_row_access(const CacheAlignedMatrix& matrix, 
                         const vector<double>& vec,
                         vector<double>& result) {
    int n = matrix.n;
    fill(result.begin(), result.end(), 0.0);
    for (int row = 0; row < n; row++) {
        double vec_val = vec[row]; 
        for (int col = 0; col < n; col++) {
            result[col] += matrix.get(row, col) * vec_val;
        }
    }
}

int main() {
    // 1. 修改点：直接生成 1 到 4096 的序列
    // 注意：全量测试不需要再手动插入边界点，因为 1-4096 已经包含了它们
    
    ofstream csv_file("matrix_full_analyses_1_4096.csv");
    csv_file << "矩阵大小,列访问时间(ms),列StdDev,行访问时间(ms),行StdDev,加速比,"
             << "内存占用(KB),L1缓存倍数,L2缓存倍数,L3缓存倍数\n";

    cout << "开始全量性能测试 (1 - 4096)..." << endl;
    auto total_start = chrono::high_resolution_clock::now();

    for (int n = 1; n <= 4096; ++n) {
        // 2. 优化迭代次数策略：确保小规模测得准，大规模跑得快
        int repeat_times;
        if (n <= 128)      repeat_times = 500; // 极小规模，增加采样以应对系统噪声
        else if (n <= 512) repeat_times = 100;
        else if (n <= 1024)repeat_times = 30;
        else if (n <= 2048)repeat_times = 10;
        else               repeat_times = 3;   // 大规模矩阵单次耗时久，减少次数

        CacheAlignedMatrix matrix(n);
        vector<double> vector_data(n, 2.0);
        vector<double> result1(n);
        vector<double> result2(n);

        // 内存计算
        double memory_KB = (double)((size_t)n * n * sizeof(double) + n * sizeof(double)) / 1024.0;
        
        // 测量
        TestResult res_naive = measure_time([&]() {
            naive_column_access(matrix, vector_data, result1);
        }, repeat_times);

        TestResult res_optimized = measure_time([&]() {
            optimized_row_access(matrix, vector_data, result2);
        }, repeat_times);

        double speedup = res_naive.mean / (res_optimized.mean + 1e-9);

        // 写入文件
        csv_file << n << "," 
                 << fixed << setprecision(5) << res_naive.mean << "," << res_naive.stdev << ","
                 << res_optimized.mean << "," << res_optimized.stdev << "," 
                 << setprecision(3) << speedup << ","
                 << setprecision(2) << memory_KB << ","
                 << memory_KB / L1_CACHE_KB << ","
                 << memory_KB / L2_CACHE_KB << ","
                 << memory_KB / L3_CACHE_KB << "\n";

        // 每隔 128 步打印一次进度
        if (n % 128 == 0 || n == 4096) {
            auto now = chrono::high_resolution_clock::now();
            auto elapsed = chrono::duration_cast<chrono::seconds>(now - total_start).count();
            cout << "进度: " << n << "/4096 | 已耗时: " << elapsed << "s | 当前加速比: " << speedup << endl;
        }
    }

    csv_file.close();
    cout << "\n实验完成！全量数据已写入 matrix_full_analyses_1_4096.csv" << endl;
    return 0;
}