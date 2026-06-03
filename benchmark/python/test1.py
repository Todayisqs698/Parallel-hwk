import matplotlib
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
import numpy as np
from dataclasses import dataclass


# ── 模拟数据结构与全局变量（保证代码完全自包含，可直接运行） ──────────────────
@dataclass
class GroupResult:
    task_type: str  # "IO" 或 "CPU"
    method: str  # 方案名称
    mean_s: float  # 平均耗时
    std_s: float  # 标准差


# 统一学术配色
DEEP_BLUE = "#1B3A5C"
LIGHT_GOLD = "#D4A853"
WARM_GRAY = "#A0937D"
SLATE_GRAY = "#6B7D8E"
GREEN = "#2E7D32"
ACCENT_RED = "#C44E52"
DARK_GRAY = "#2D2D2D"
MED_GRAY = "#8C8C8C"
OFF_WHITE = "#FFFFFF"
CHART_PATH = "python_benchmark_subplots.png"

# 配置全局样式
matplotlib.rcParams.update({
    "font.family": "sans-serif",
    "font.sans-serif": ["Microsoft YaHei", "SimHei", "DejaVu Sans", "Arial"],
    "figure.dpi": 150,
    "savefig.dpi": 300,
})


# ── 可视化核心函数 ──────────────────────────────────────────────

def plot_charts(results: list[GroupResult]):
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(16, 7.5))
    fig.patch.set_facecolor("white")
    ax1.set_facecolor(OFF_WHITE)
    ax2.set_facecolor(OFF_WHITE)

    # ──────────────────────────────────────────────────
    # ── 左图: IO 密集型 耗时对比（已改为对数轴） ──
    # ──────────────────────────────────────────────────
    io_results = [r for r in results if r.task_type == "IO"]
    labels = [r.method for r in io_results]
    means = [r.mean_s for r in io_results]
    stds = [r.std_s for r in io_results]
    colors_io = [WARM_GRAY, LIGHT_GOLD, SLATE_GRAY, DEEP_BLUE]
    colors_io = colors_io[:len(io_results)]

    x = range(len(io_results))
    bars = ax1.bar(x, means, color=colors_io, edgecolor="white", linewidth=1.2, zorder=3, width=0.55)
    ax1.errorbar(x, means, yerr=stds, fmt="none", ecolor=ACCENT_RED, capsize=5, linewidth=1.5, zorder=4)

    # 【核心修改】设置 Y 轴为对数坐标，并手动美化刻度
    ax1.set_yscale("log")
    ax1.set_ylim(0.01, 30)  # 给柱顶留出空间
    ax1.yaxis.set_major_formatter(mticker.ScalarFormatter())
    ax1.yaxis.set_minor_formatter(mticker.NullFormatter())

    ax1.set_xticks(x)
    ax1.set_xticklabels(labels, fontsize=11)
    ax1.set_ylabel("耗时 (s) — 对数坐标", fontweight="bold", fontsize=13)
    ax1.set_title("IO 密集型 (2000 tasks × 5ms)", fontweight="bold", color=DARK_GRAY, fontsize=15, pad=12)
    ax1.grid(axis="y", linestyle="--", alpha=0.4, color=MED_GRAY, zorder=0)

    # 【核心修改】对数坐标下，数字标注采用乘法偏移 (mean * 1.25)
    for bar, mean in zip(bars, means):
        h = bar.get_height()
        ax1.text(bar.get_x() + bar.get_width() / 2, h * 1.25,
                 f"{mean:.4f}s", ha="center", fontsize=11, fontweight="bold", color=DARK_GRAY)

    # 重新计算降维打击倍数（Serial / asyncio）
    # 假设你的数据里第一个是 Serial，最后一个是 asyncio
    ratio = means[0] / means[-1] if len(means) > 1 else 1

    # ──────────────────────────────────────────────────
    # ── 右图: CPU 密集型 耗时对比（保持线性坐标） ──
    # ──────────────────────────────────────────────────
    cpu_results = [r for r in results if r.task_type == "CPU"]
    labels_cpu = [r.method for r in cpu_results]
    means_cpu = [r.mean_s for r in cpu_results]
    stds_cpu = [r.std_s for r in cpu_results]
    colors_cpu = ['#C69287', '#E79A90', '#EFBC91', '#E4CD87', '#FAE5B8']

    x2 = range(len(cpu_results))
    bars2 = ax2.bar(x2, means_cpu, color=colors_cpu[:len(cpu_results)], edgecolor="white", linewidth=1.2, zorder=3,
                    width=0.55)
    ax2.errorbar(x2, means_cpu, yerr=stds_cpu, fmt="none", ecolor=ACCENT_RED, capsize=5, linewidth=1.5, zorder=4)

    # 线性坐标：刻意设置稍大的顶部范围，更直观展现所有方案“高度一致”
    ax2.set_ylim(0, 3.5)

    ax2.set_xticks(x2)
    ax2.set_xticklabels(labels_cpu, fontsize=11)
    ax2.set_ylabel("耗时 (s)", fontweight="bold", fontsize=13)
    ax2.set_title("CPU 密集型 (80 tasks × 120k loops)", fontweight="bold", color=DARK_GRAY, fontsize=15, pad=12)
    ax2.grid(axis="y", linestyle="--", alpha=0.4, color=MED_GRAY, zorder=0)

    # 线性坐标下，数值标注依然采用正常的加法偏移
    max_val_cpu = max(means_cpu)
    for bar, mean in zip(bars2, means_cpu):
        h = bar.get_height()
        ax2.text(bar.get_x() + bar.get_width() / 2, h + max_val_cpu * 0.03,
                 f"{mean:.4f}s", ha="center", fontsize=11, fontweight="bold", color=DARK_GRAY)

    fig.suptitle("Python 协程基准实验 — 适用场景边界验证", fontweight="bold", fontsize=20, color=DARK_GRAY, y=0.98)
    plt.tight_layout(rect=[0, 0, 1, 0.95])
    fig.savefig(CHART_PATH, facecolor="white", edgecolor="none")
    plt.close()
    print(f"[OK] 对数轴优化版图表已成功生成 -> {CHART_PATH}")


# ── 测试执行（包含你给出的真实实验数据） ─────────────────────────────
if __name__ == "__main__":
    # 装填你图表里的原始精确测试数据
    mock_results = [
        # IO 密集型
        GroupResult("IO", "Serial\n(串行)", 10.7941, 0.0332),
        GroupResult("IO", "ThreadPool\n(低并发)", 0.2506, 0.0104),
        GroupResult("IO", "ThreadPool\n(高并发)", 0.1032, 0.0061),
        GroupResult("IO", "asyncio\n(异步协程)", 0.0308, 0.0019),

        # CPU 密集型
        GroupResult("CPU", "Serial\n(串行)", 2.5325, 0.0041),
        GroupResult("CPU", "ThreadPool_1", 2.5256, 0.0082),
        GroupResult("CPU", "ThreadPool_2", 2.5242, 0.0138),
        GroupResult("CPU", "asyncio(base)", 2.5364, 0.0148),
        GroupResult("CPU", "asyncio+Exec", 2.5435, 0.0086),
    ]

    plot_charts(mock_results)

