# Parallel Computing:ANN

本项目为南开大学计算机学院《并行程序设计》实验报告相关代码实现。

## 项目核心
针对 ARM NEON 指令集，实现了 **PQ** 算法。

## 环境要求
- 处理器: 支持 ARM NEON 指令集
- 编译器: g++ (支持 C++11 及以上)
- 依赖: OpenMP

## 运行命令
```bash
g++ main.cc -o main -O2 -fopenmp -lpthread -std=c++11
```
