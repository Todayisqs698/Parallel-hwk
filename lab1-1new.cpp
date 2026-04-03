#include<iostream>
#include<chrono>
#include<vector>
#include<cmath>
#include<algorithm>
#include<fstream>
#include<iomanip>
#include<functional>
#include<numeric>
using namespace std;
// 定义缓存大小 (单位: KB)
const double L1_CACHE_KB = 48.0;
const double L2_CACHE_KB = 2048.0;
const double L3_CACHE_KB = 30720.0;

#include <numeric>
struct TestResult {

    double mean;

    double stdev;

};
TestResult measure_time(function<void()> func, int repeat_times) {
    vector<double> times;

    for (int i = 0; i < repeat_times; i++) {

        auto start = chrono::high_resolution_clock::now();

        func();

        auto end = chrono::high_resolution_clock::now();

        double duration = chrono::duration_cast<chrono::microseconds>(end - start).count() / 1000.0;

        times.push_back(duration);

    }



    double sum = accumulate(times.begin(), times.end(), 0.0);

    double mean = sum / repeat_times;



    double sq_sum = inner_product(times.begin(), times.end(), times.begin(), 0.0);

    double stdev = sqrt(sq_sum / repeat_times - mean * mean);



    return {mean, stdev};

}



struct CacheAlignedMatrix {

    vector<double> data;

    int n;

    CacheAlignedMatrix(int size) : n(size) {

        data.resize(size * size, 1.0);

    }

    inline double get(int row, int col) const {

        return data[row * n + col]; 

    }

};

//按列访问

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

//按行访问

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

    vector<int> test_sizes;

    for (int size = 16; size <= 4096; size *= 2) {

        test_sizes.push_back(size);

    }

    for (double factor : {0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0}) {

        int l1_boundary_test = static_cast<int>(sqrt(L1_CACHE_KB * 128) * factor);

        int l2_boundary_test = static_cast<int>(sqrt(L2_CACHE_KB * 128) * factor);

        int l3_boundary_test = static_cast<int>(sqrt(L3_CACHE_KB * 128) * factor);

        test_sizes.push_back(l1_boundary_test);

        test_sizes.push_back(l2_boundary_test);

        test_sizes.push_back(l3_boundary_test);

    }

    sort(test_sizes.begin(), test_sizes.end());

    test_sizes.erase(unique(test_sizes.begin(), test_sizes.end()), test_sizes.end());

    ofstream csv_file("matrix_cache_analyses.csv");

    csv_file << "矩阵大小,列访问时间(ms),列StdDev,行访问时间(ms),行StdDev,加速比,"

             << "内存占用(KB),L1缓存倍数,L2缓存倍数,L3缓存倍数\n";

    for (int n : test_sizes) {

        int repeat_times;

        if (n < 100) {

            repeat_times = 1000;

        } else if (n < 1000) {

            repeat_times = 100;

        } else if (n < 2000) {

            repeat_times = 10;

        } else {

            repeat_times = 3;

        }

        cout << "测试矩阵大小: " << n << "x" << n << endl;

        CacheAlignedMatrix matrix(n);

        vector<double> vector_data(n, 2.0);

        vector<double> result1(n);

        vector<double> result2(n);

        double memory_KB = (n * n * sizeof(double) + n * sizeof(double)) / 1024.0;

        double l1_ratio = memory_KB / L1_CACHE_KB;

        double l2_ratio = memory_KB / L2_CACHE_KB;

        double l3_ratio = memory_KB / L3_CACHE_KB;

        TestResult res_naive = measure_time([&]() {

            naive_column_access(matrix, vector_data, result1);

        }, repeat_times);

        double time_naive = res_naive.mean;

        TestResult res_optimized = measure_time([&]() {

            optimized_row_access(matrix, vector_data, result2);

        }, repeat_times);

        double time_optimized = res_optimized.mean;

        double speedup = time_naive / time_optimized;

        csv_file << n << "," << fixed << setprecision(3) << res_naive.mean << ","<< setprecision(3) << res_naive.stdev << ","

                 << fixed << setprecision(3) << res_optimized.mean << ","<< fixed << setprecision(3) << res_optimized.stdev << "," << fixed << setprecision(2) << speedup << ","

                 << fixed << setprecision(2) << memory_KB << ","

                 << fixed << setprecision(2) << l1_ratio << ","

                 << fixed << setprecision(2) << l2_ratio << ","

                 << fixed << setprecision(2) << l3_ratio << "\n";

    }
    csv_file.close();
    cout << "实验完成，数据已写入 matrix_cache_analyses.csv" << endl;
    return 0;
}