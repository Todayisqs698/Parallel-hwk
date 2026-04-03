#include <iostream>
#include <vector>
#include <chrono>
#include <functional>
#include <fstream>
#include <iomanip>
#include <algorithm>
#include <cmath>

using namespace std;
volatile double global_sink = 0.0;

// 1. 朴素累加
double naive_sum(const vector<double>& a) {
    double s = 0;
    for (double x : a) s += x;
    return s;
}

// 2. 两路并行
double two_way_sum(const vector<double>& a) {
    double s1 = 0, s2 = 0;
    size_t i = 0, n = a.size();
    for (; i + 1 < n; i += 2) {
        s1 += a[i];
        s2 += a[i + 1];
    }
    if (i < n) s1 += a[i];
    return s1 + s2;
}

// 3. 四路并行
double four_way_sum(const vector<double>& a) {
    double s1 = 0, s2 = 0, s3 = 0, s4 = 0;
    size_t i = 0, n = a.size();
    for (; i + 3 < n; i += 4) {
        s1 += a[i];
        s2 += a[i + 1];
        s3 += a[i + 2];
        s4 += a[i + 3];
    }
    for (; i < n; i++) s1 += a[i];
    return s1 + s2 + s3 + s4;
}

// 4. 递归分治
double rec_sum(const vector<double>& a, size_t l, size_t r) {
    if (r - l <= 1) return a[l];
    size_t mid = l + (r - l) / 2;
    return rec_sum(a, l, mid) + rec_sum(a, mid, r);
}

double divide_conquer_sum(const vector<double>& a) {
    if (a.empty()) return 0;
    return rec_sum(a, 0, a.size());
}

// 5. 循环分治 
double iterative_dc_sum(const vector<double>& a) {
    static vector<double> work; 
    work = a; 
    size_t n = work.size();
    for (size_t step = 1; step < n; step *= 2) {
        for (size_t i = 0; i < n; i += 2 * step) {
            if (i + step < n) {
                work[i] += work[i + step];
            }
        }
    }
    return work[0];
}

// 计时封装 
double measure(const function<double()>& f, int repeat) {
    for(int i=0; i<5; ++i) f();

    auto start = chrono::high_resolution_clock::now();
    double checksum = 0.0;
    for (int i = 0; i < repeat; i++) {
        checksum += f();
    }
    auto end = chrono::high_resolution_clock::now();
    
    global_sink = checksum; 
    return chrono::duration<double, milli>(end - start).count() / repeat;
}
int get_repeat(size_t n) {
    if (n <= 1024) return 10000;
    if (n <= 65536) return 1000;
    if (n <= 1048576) return 100;
    return 10;
}
nt main() {
    ofstream csv("sum_performance_pow2.csv");
    using AlgoFunc = function<double(const vector<double>&)>;
    vector<pair<string, AlgoFunc>> algos = {
        {"naive", naive_sum},
        {"two_way", two_way_sum},
        {"four_way", four_way_sum},
        {"iter_dc", iterative_dc_sum},
        {"rec_dc", divide_conquer_sum}

    };
    csv << "N,naive,two_way,four_way,iter_dc,rec_dc,speedup_two_way,speedup_four_way,speedup_iter_dc,speedup_rec_dc\n";
    cout << "开始测试 (规模为 2^n)..." << endl;
    for (int k = 7; k <= 27; ++k) {
        size_t N = static_cast<size_t>(pow(2, k));
        vector<double> data(N);
        for (size_t i = 0; i < N; i++) {
            data[i] = (i % 100) * 0.1;
        }
        int rep = get_repeat(N);
        cout << "正在测试 2^" << k << " (N=" << N << "), 重复 " << rep << " 次..." << endl;
        vector<double> results;
        for (auto& algo : algos) {
            double t = measure([&]() { return algo.second(data); }, rep);
            results.push_back(t);

        }
        csv << N;
        for (double t : results) csv << "," << fixed << setprecision(8) << t;
        for (size_t i = 1; i < results.size(); i++) {
            csv << "," << results[0] / results[i];
        }
        csv << "\n";

    }
    csv.close();
    cout << "数据已保存至 sum_performance.csv" << endl;
    return 0;
}