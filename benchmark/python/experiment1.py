"""
实验一：Python 协程基准实验 — 验证适用场景边界
=================================================
对比 串行执行 / 线程池 / asyncio协程 在 IO密集型 vs CPU密集型 任务下的性能差异。

运行：
    python experiment1.py

依赖（仅 matplotlib 需额外安装）：
    pip install matplotlib
"""

import asyncio
import concurrent.futures
import csv
import math
import os
import statistics
import time
from dataclasses import dataclass, field
from typing import Callable

import matplotlib
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker

# ── 全局样式 ────────────────────────────────────────────
matplotlib.rcParams.update({
    "font.family": "sans-serif",
    "font.sans-serif": ["Microsoft YaHei", "SimHei", "DejaVu Sans", "Arial"],
    "font.size": 14,
    "axes.titlesize": 18,
    "axes.labelsize": 15,
    "xtick.labelsize": 13,
    "ytick.labelsize": 13,
    "legend.fontsize": 13,
    "figure.dpi": 150,
    "savefig.dpi": 300,
    "savefig.bbox": "tight",
    "savefig.facecolor": "white",
})

DEEP_BLUE  = "#1B3A5C"
LIGHT_GOLD = "#D4A853"
SLATE_GRAY = "#6B7D8E"
WARM_GRAY  = "#A0937D"
ACCENT_RED = "#C44E52"
OFF_WHITE  = "#FFFFFF"
DARK_GRAY  = "#2D2D2D"
MED_GRAY   = "#8C8C8C"
GREEN      = "#4C9F70"

# ── 实验配置 ────────────────────────────────────────────

REPEAT = 5                     # 每组实验重复次数
IO_TASK_COUNT = 2000           # IO 密集型任务数
CPU_TASK_COUNT = 80            # CPU 密集型任务数
IO_SLEEP_SEC = 0.005           # 5ms 非阻塞等待 (模拟 I/O)
CPU_LOOP_COUNT = 120_000       # 12 万次数学循环
THREAD_POOL_SIZES = [50, 200]  # 线程池大小

# 输出路径
CSV_PATH  = "experiment1_results.csv"
CHART_PATH = "chart_python_benchmark.png"


# ── 结果数据类 ──────────────────────────────────────────

@dataclass
class SingleRun:
    """单次运行结果"""
    duration_s: float


@dataclass
class GroupResult:
    """一组重复实验的统计结果"""
    name: str
    task_type: str           # "IO" | "CPU"
    method: str              # "Serial" | "ThreadPool(P=N)" | "asyncio"
    task_count: int
    runs: list[float] = field(default_factory=list)

    @property
    def mean_s(self) -> float:
        return statistics.mean(self.runs) if self.runs else 0.0

    @property
    def std_s(self) -> float:
        return statistics.stdev(self.runs) if len(self.runs) > 1 else 0.0

    @property
    def mean_ms(self) -> float:
        return self.mean_s * 1000

    @property
    def throughput(self) -> float:
        return self.task_count / self.mean_s if self.mean_s > 0 else 0.0


# ── IO 密集型任务 ───────────────────────────────────────

def io_task_serial(n: int, sleep_sec: float) -> float:
    """串行: 逐个执行 sleep"""
    t0 = time.perf_counter()
    for _ in range(n):
        time.sleep(sleep_sec)
    return time.perf_counter() - t0


def io_task_threadpool(n: int, sleep_sec: float, workers: int) -> float:
    """线程池: 多线程并发 sleep"""
    t0 = time.perf_counter()
    with concurrent.futures.ThreadPoolExecutor(max_workers=workers) as executor:
        futures = [executor.submit(time.sleep, sleep_sec) for _ in range(n)]
        concurrent.futures.wait(futures)
    return time.perf_counter() - t0


async def io_sleep_async(sleep_sec: float):
    await asyncio.sleep(sleep_sec)


async def io_task_asyncio(n: int, sleep_sec: float) -> float:
    """asyncio 协程: 单线程异步并发"""
    t0 = time.perf_counter()
    await asyncio.gather(*(io_sleep_async(sleep_sec) for _ in range(n)))
    return time.perf_counter() - t0


# ── CPU 密集型任务 ──────────────────────────────────────

def cpu_work(loop_count: int) -> int:
    """纯 CPU 计算: 12 万次数学循环"""
    s = 0.0
    for i in range(loop_count):
        s += math.sin(i) * math.cos(i * 0.5) + math.sqrt(abs(i - loop_count / 2) + 1)
    return int(s) % 100


def cpu_task_serial(n: int, loop_count: int) -> float:
    """串行: 逐个执行计算"""
    t0 = time.perf_counter()
    for _ in range(n):
        cpu_work(loop_count)
    return time.perf_counter() - t0


def cpu_task_threadpool(n: int, loop_count: int, workers: int) -> float:
    """线程池: 多线程并发计算 (受 GIL 限制, IO 释放 GIL 但纯计算不放)"""
    t0 = time.perf_counter()
    with concurrent.futures.ThreadPoolExecutor(max_workers=workers) as executor:
        futures = [executor.submit(cpu_work, loop_count) for _ in range(n)]
        concurrent.futures.wait(futures)
    return time.perf_counter() - t0


async def cpu_work_async(loop_count: int) -> int:
    """协程版 CPU 计算 — 但计算本身不是异步的, 必须用 run_in_executor 才能不阻塞事件循环"""
    return cpu_work(loop_count)


async def cpu_task_asyncio_bare(n: int, loop_count: int) -> float:
    """
    asyncio 协程 — 裸用 (串行执行)

    关键演示: 直接把 CPU 密集函数放到 async 里不会自动并发 ——
    它会在第一个 await 之前串行跑完。这里没有 yield 点, 所以等同串行。
    """
    t0 = time.perf_counter()
    await asyncio.gather(*(cpu_work_async(loop_count) for _ in range(n)))
    return time.perf_counter() - t0


async def cpu_task_asyncio_executor(n: int, loop_count: int) -> float:
    """
    asyncio 协程 — 配合线程池

    将 CPU 任务 offload 到 ThreadPoolExecutor, 避免阻塞事件循环。
    这暴露了一个核心事实: asyncio 本身不加速 CPU 计算, 必须借助线程/进程池。
    """
    loop = asyncio.get_running_loop()
    t0 = time.perf_counter()
    tasks = [loop.run_in_executor(None, cpu_work, loop_count) for _ in range(n)]
    await asyncio.gather(*tasks)
    return time.perf_counter() - t0


# ── 实验运行器 ──────────────────────────────────────────

def run_repeated(label: str, fn: Callable[[], float], repeat: int = REPEAT) -> GroupResult:
    """重复运行 fn 多次, 返回统计结果"""
    parts = label.split("|")
    task_type = parts[0].strip()
    method = parts[1].strip()
    task_count = int(parts[2].strip())

    result = GroupResult(name=label, task_type=task_type, method=method, task_count=task_count)
    for run_idx in range(repeat):
        d = fn()
        result.runs.append(d)
        # 小间隔让系统冷却
        time.sleep(0.1)
    return result


def run_all_experiments() -> list[GroupResult]:
    all_results: list[GroupResult] = []

    # ============ IO 密集型 ============
    print("=" * 65)
    print("  实验一-A  IO 密集型 (2000 任务, 每任务 5ms sleep)")
    print("=" * 65)

    # 1. 串行
    print("\n[1/5] Serial IO ...")
    all_results.append(run_repeated("IO|Serial|2000", lambda: io_task_serial(IO_TASK_COUNT, IO_SLEEP_SEC)))
    print(f"      mean={all_results[-1].mean_s:.4f}s  std={all_results[-1].std_s:.4f}s")

    # 2. 线程池 (多种大小)
    for workers in THREAD_POOL_SIZES:
        label = f"IO|ThreadPool(P={workers})|2000"
        print(f"\n[{len(all_results)+1}/5] {label} ...")
        all_results.append(run_repeated(label, lambda w=workers: io_task_threadpool(IO_TASK_COUNT, IO_SLEEP_SEC, w)))
        print(f"      mean={all_results[-1].mean_s:.4f}s  std={all_results[-1].std_s:.4f}s")

    # 3. asyncio 协程
    print(f"\n[{len(all_results)+1}/5] IO|asyncio|2000 ...")
    all_results.append(run_repeated("IO|asyncio|2000", lambda: asyncio.run(io_task_asyncio(IO_TASK_COUNT, IO_SLEEP_SEC))))
    print(f"      mean={all_results[-1].mean_s:.4f}s  std={all_results[-1].std_s:.4f}s")

    # ============ CPU 密集型 ============
    print("\n" + "=" * 65)
    print("  实验一-B  CPU 密集型 (80 任务, 每任务 12 万次循环)")
    print("=" * 65)

    # 4. 串行
    print("\n[CPU-1/5] Serial CPU ...")
    all_results.append(run_repeated("CPU|Serial|80", lambda: cpu_task_serial(CPU_TASK_COUNT, CPU_LOOP_COUNT)))
    print(f"         mean={all_results[-1].mean_s:.4f}s  std={all_results[-1].std_s:.4f}s")

    # 5. 线程池
    for workers in THREAD_POOL_SIZES:
        label = f"CPU|ThreadPool(P={workers})|80"
        print(f"\n[CPU-{len(all_results)+1}/5] {label} ...")
        all_results.append(run_repeated(label, lambda w=workers: cpu_task_threadpool(CPU_TASK_COUNT, CPU_LOOP_COUNT, w)))
        print(f"         mean={all_results[-1].mean_s:.4f}s  std={all_results[-1].std_s:.4f}s")

    # 6. asyncio (裸用 — 预期 = 串行)
    print(f"\n[CPU-{len(all_results)+1}/5] CPU|asyncio(bare)|80 ...")
    all_results.append(run_repeated("CPU|asyncio(bare)|80", lambda: asyncio.run(cpu_task_asyncio_bare(CPU_TASK_COUNT, CPU_LOOP_COUNT))))
    print(f"         mean={all_results[-1].mean_s:.4f}s  std={all_results[-1].std_s:.4f}s")

    # 7. asyncio + ThreadPoolExecutor (正确用法)
    print(f"\n[CPU-{len(all_results)+1}/5] CPU|asyncio+Executor|80 ...")
    all_results.append(run_repeated("CPU|asyncio+Executor|80", lambda: asyncio.run(cpu_task_asyncio_executor(CPU_TASK_COUNT, CPU_LOOP_COUNT))))
    print(f"         mean={all_results[-1].mean_s:.4f}s  std={all_results[-1].std_s:.4f}s")

    return all_results


# ── CSV 报表 ────────────────────────────────────────────

def save_csv(results: list[GroupResult], path: str):
    with open(path, "w", newline="", encoding="utf-8-sig") as f:
        w = csv.writer(f)
        w.writerow(["task_type", "method", "task_count", "mean_s", "std_s", "throughput_tps", "run_values_s"])
        for r in results:
            w.writerow([
                r.task_type, r.method, r.task_count,
                f"{r.mean_s:.6f}", f"{r.std_s:.6f}",
                f"{r.throughput:.2f}",
                "|".join(f"{v:.6f}" for v in r.runs),
            ])
    print(f"\n[OK] CSV saved → {path}")


# ── 终端报表 ────────────────────────────────────────────

def print_table(results: list[GroupResult]):
    print("\n" + "=" * 100)
    print(f"{'Task':<6} {'Method':<30} {'Count':>6} {'Mean(s)':>10} {'Std(s)':>10} {'Throughput(t/s)':>18}")
    print("-" * 100)
    for r in results:
        print(f"{r.task_type:<6} {r.method:<30} {r.task_count:>6} {r.mean_s:>10.4f} {r.std_s:>10.4f} {r.throughput:>18.1f}")
    print("=" * 100)


# ── 可视化 ──────────────────────────────────────────────

def plot_charts(results: list[GroupResult]):
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(16, 7))
    fig.patch.set_facecolor("white")
    ax1.set_facecolor(OFF_WHITE)
    ax2.set_facecolor(OFF_WHITE)

    # ── 左图: IO 密集型 耗时对比 ──
    io_results = [r for r in results if r.task_type == "IO"]
    labels = [r.method for r in io_results]
    means = [r.mean_s for r in io_results]
    stds = [r.std_s for r in io_results]
    colors_io = [DEEP_BLUE, LIGHT_GOLD, WARM_GRAY, GREEN]
    colors_io = colors_io[:len(io_results)]

    x = range(len(io_results))
    bars = ax1.bar(x, means, color=colors_io, edgecolor="white", linewidth=1.2, zorder=3)
    ax1.errorbar(x, means, yerr=stds, fmt="none", ecolor=ACCENT_RED, capsize=5, linewidth=1.5, zorder=4)

    ax1.set_xticks(x)
    ax1.set_xticklabels(labels, fontsize=11)
    ax1.set_ylabel("耗时 (s)", fontweight="bold")
    ax1.set_title("IO 密集型 (2000 tasks × 5ms)", fontweight="bold", color=DARK_GRAY)
    ax1.grid(axis="y", linestyle="--", alpha=0.4, color=MED_GRAY, zorder=0)

    # 标注数值
    max_val = max(means)
    for bar, mean in zip(bars, means):
        h = bar.get_height()
        ax1.text(bar.get_x() + bar.get_width() / 2, h + max_val * 0.03,
                 f"{mean:.4f}s", ha="center", fontsize=11, fontweight="bold", color=DARK_GRAY)

    # 高亮 asyncio 优势
    ax1.annotate(f"协程快 {means[0]/means[-1]:.0f}×",
                 xy=(len(io_results) - 1, means[-1]),
                 xytext=(len(io_results) - 1, means[-1] * 3),
                 fontsize=12, fontweight="bold", color=ACCENT_RED,
                 ha="center",
                 arrowprops=dict(arrowstyle="->", color=ACCENT_RED, lw=2))

    # ── 右图: CPU 密集型 耗时对比 ──
    cpu_results = [r for r in results if r.task_type == "CPU"]
    labels_cpu = [r.method for r in cpu_results]
    means_cpu = [r.mean_s for r in cpu_results]
    stds_cpu = [r.std_s for r in cpu_results]
    colors_cpu = [DEEP_BLUE, LIGHT_GOLD, WARM_GRAY, SLATE_GRAY, GREEN]

    x2 = range(len(cpu_results))
    bars2 = ax2.bar(x2, means_cpu, color=colors_cpu[:len(cpu_results)], edgecolor="white", linewidth=1.2, zorder=3)
    ax2.errorbar(x2, means_cpu, yerr=stds_cpu, fmt="none", ecolor=ACCENT_RED, capsize=5, linewidth=1.5, zorder=4)

    ax2.set_xticks(x2)
    ax2.set_xticklabels(labels_cpu, fontsize=11)
    ax2.set_ylabel("耗时 (s)", fontweight="bold")
    ax2.set_title("CPU 密集型 (80 tasks × 120k loops)", fontweight="bold", color=DARK_GRAY)
    ax2.grid(axis="y", linestyle="--", alpha=0.4, color=MED_GRAY, zorder=0)

    max_val_cpu = max(means_cpu)
    for bar, mean in zip(bars2, means_cpu):
        h = bar.get_height()
        ax2.text(bar.get_x() + bar.get_width() / 2, h + max_val_cpu * 0.03,
                 f"{mean:.4f}s", ha="center", fontsize=11, fontweight="bold", color=DARK_GRAY)

    # 高亮: asyncio(bare) ≈ Serial (无效)
    # 找到 Serial 和 asyncio(bare) 的柱子高亮
    ax2.annotate("asyncio(bare)\n≈ Serial\n协程无效!",
                 xy=(len(cpu_results) - 2, means_cpu[-2]),
                 xytext=(len(cpu_results) - 2.5, means_cpu[-2] * 0.7),
                 fontsize=10, fontweight="bold", color=ACCENT_RED,
                 ha="center",
                 bbox=dict(boxstyle="round,pad=0.3", facecolor="white", edgecolor=ACCENT_RED, alpha=0.9))

    fig.suptitle("Python 协程基准实验 — 适用场景边界验证", fontweight="bold", fontsize=19, color=DARK_GRAY, y=1.02)
    plt.tight_layout()
    fig.savefig(CHART_PATH, facecolor="white", edgecolor="none")
    plt.close()
    print(f"[OK] Chart saved → {CHART_PATH}")


# ── Main ────────────────────────────────────────────────

def main():
    os.chdir(os.path.dirname(os.path.abspath(__file__)))

    print("=" * 65)
    print("  Python 协程基准实验")
    print("  IO 密集型 vs CPU 密集型: Serial / ThreadPool / asyncio")
    print(f"  Python 3.12+ | 每组重复 {REPEAT} 次")
    print("=" * 65)

    results = run_all_experiments()
    print_table(results)
    save_csv(results, CSV_PATH)
    plot_charts(results)

    # ── 精炼结论 ──
    io_serial  = next(r for r in results if r.name == "IO|Serial|2000")
    io_async   = next(r for r in results if r.name == "IO|asyncio|2000")
    cpu_serial = next(r for r in results if r.name == "CPU|Serial|80")
    cpu_async  = next(r for r in results if r.name == "CPU|asyncio(bare)|80")

    print("\n" + "=" * 65)
    print("  PPT 精炼结论")
    print("=" * 65)
    print(f"  IO 密集型:  协程 {io_async.mean_s:.3f}s  vs  串行 {io_serial.mean_s:.3f}s "
          f"(协程快 {io_serial.mean_s/io_async.mean_s:.0f}×)")
    print(f"  CPU 密集型: 协程(bare) {cpu_async.mean_s:.3f}s  vs  串行 {cpu_serial.mean_s:.3f}s "
          f"(协程无效, 等同串行)")
    print(f"  结论: 协程仅优化 IO 等待, 不提升 CPU 计算性能.")
    print("=" * 65)


if __name__ == "__main__":
    main()
