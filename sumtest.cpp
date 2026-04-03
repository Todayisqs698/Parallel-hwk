#include <sys/time.h>
#include <iostream>
#include <vector>

using namespace std;

// 建议将 N 调大，比如 2000，否则 i7-14650HX 跑得太快捕捉不到数据
const int N = 2000; 
const int REPEAT = 50; // 重复次数，用于取平均值

// 平凡算法：按列访问 (Cache Miss 高)
void col_major_analysis(int** num, int* v, int* sum) {
    for (int j = 0; j < N; j++) {
        for (int i = 0; i < N; i++) {
            sum[i] += num[j][i] * v[j];
        }
    }
}

// 优化算法：按行访问 (Cache Friendly)
void row_major_analysis(int** num, int* v, int* sum) {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            sum[i] += num[i][j] * v[j];
        }
    }
}

int main() {
    struct timeval start, end;

    // 1. 动态内存分配 (避免栈溢出)
    int** num = new int*[N];
    for (int i = 0; i < N; i++) num[i] = new int[N];
    int* v = new int[N];
    int* sum = new int[N];

    // 2. 初始化数据 (放在计时器外面，保证 VTune 结果纯净)
    for (int i = 0; i < N; i++) {
        v[i] = i;
        sum[i] = 0;
        for (int j = 0; j < N; j++) num[i][j] = 1;
    }

    cout << "Starting Matrix Experiments (N=" << N << ")..." << endl;

    // --- 实验 A: 列优先 (Naive) ---
    gettimeofday(&start, NULL);
    for (int k = 0; k < REPEAT; k++) {
        col_major_analysis(num, v, sum);
    }
    gettimeofday(&end, NULL);
    
    long long col_time = (end.tv_sec - start.tv_sec) * 1000000 + (end.tv_usec - start.tv_usec);
    cout << "Col Major (Naive) Avg Time: " << col_time / REPEAT << " us" << endl;

    // 重置 sum 数组
    for (int i = 0; i < N; i++) sum[i] = 0;

    // --- 实验 B: 行优先 (Optimized) ---
    gettimeofday(&start, NULL);
    for (int k = 0; k < REPEAT; k++) {
        row_major_analysis(num, v, sum);
    }
    gettimeofday(&end, NULL);

    long long row_time = (end.tv_sec - start.tv_sec) * 1000000 + (end.tv_usec - start.tv_usec);
    cout << "Row Major (Optimized) Avg Time: " << row_time / REPEAT << " us" << endl;

    // 3. 释放内存
    for (int i = 0; i < N; i++) delete[] num[i];
    delete[] num;
    delete[] v;
    delete[] sum;

    return 0;
}