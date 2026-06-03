"""
协程 vs 线程 性能对比 — PPT 图表生成脚本

基于 Go benchmark 真实数据：N=50000 下 Goroutine vs ThreadPool 的对比。

运行前安装依赖：
    pip install matplotlib numpy

运行：
    python plot_results.py

输出：
    chart1_耗时对比.png   — N=50000 下各方案总耗时对比柱状图
    chart2_吞吐量趋势.png  — 不同并发规模下 Goroutine vs ThreadPool(P=1000) 吞吐量趋势
"""

import matplotlib
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
import numpy as np

# ── 全局样式 ──────────────────────────────────────────────
matplotlib.rcParams.update({
    "font.family": "sans-serif",
    "font.sans-serif": ["Microsoft YaHei", "SimHei", "DejaVu Sans", "Arial"],
    "font.size": 14,
    "axes.titlesize": 20,
    "axes.labelsize": 16,
    "xtick.labelsize": 13,
    "ytick.labelsize": 13,
    "legend.fontsize": 14,
    "figure.dpi": 150,
    "savefig.dpi": 300,
    "savefig.bbox": "tight",
    "savefig.facecolor": "white",
})

# ── 学术配色 ──────────────────────────────────────────────
DEEP_BLUE    = "#1B3A5C"   # Goroutine / 协程主色
STEEL_BLUE   = "#3A6B8C"
LIGHT_GOLD   = "#D4A853"   # ThreadPool 主色
WARM_GRAY    = "#A0937D"
SLATE_GRAY   = "#6B7D8E"
OFF_WHITE    = "#FFFFFF"
DARK_GRAY    = "#2D2D2D"
MED_GRAY     = "#8C8C8C"
ACCENT_RED   = "#C44E52"

BAR_COLORS = [DEEP_BLUE, LIGHT_GOLD, WARM_GRAY, SLATE_GRAY]

# ──────────────────────────────────────────────────────────
# 图表一：N=50000 总耗时对比柱状图（对数坐标）
# ──────────────────────────────────────────────────────────

def plot_time_comparison():
    methods = [
        "Goroutine\n(有栈协程)",
        "ThreadPool\nP=1000",
        "ThreadPool\nP=500",
        "ThreadPool\nP=200",
    ]
    times_ms = [302, 5041, 10078, 25188]
    throughputs = [165563, 9919, 4961, 1985]
    colors = [DEEP_BLUE, LIGHT_GOLD, WARM_GRAY, SLATE_GRAY]

    fig, ax = plt.subplots(figsize=(12, 7))
    fig.patch.set_facecolor("white")
    ax.set_facecolor(OFF_WHITE)

    x = np.arange(len(methods))
    bars = ax.bar(x, times_ms, width=0.55, color=colors, edgecolor="white", linewidth=1.2, zorder=3)

    # 对数坐标 — 核心：凸显协程的"降维打击"
    ax.set_yscale("log")
    ax.set_ylabel("总耗时 (ms) ", fontweight="bold")
    ax.set_xticks(x)
    ax.set_xticklabels(methods)
    ax.set_ylim(100, 100000)

    # 网格
    ax.grid(axis="y", linestyle="--", alpha=0.4, color=MED_GRAY, zorder=0)
    ax.yaxis.set_major_formatter(mticker.ScalarFormatter())
    ax.yaxis.set_minor_formatter(mticker.NullFormatter())

    # 数值标注
    for bar, time_val, tp_val in zip(bars, times_ms, throughputs):
        height = bar.get_height()
        # 在柱顶上方标注时间
        ax.text(bar.get_x() + bar.get_width() / 2, height * 1.15,
                f"{time_val:,} ms",
                ha="center", va="bottom", fontsize=15, fontweight="bold", color=DARK_GRAY)
        # 在柱中间标注吞吐量
        ax.text(bar.get_x() + bar.get_width() / 2, height * 0.35,
                f"{tp_val:,} t/s",
                ha="center", va="center", fontsize=12, color="white", fontweight="bold")

    # 标题
    ax.set_title("N=50,000 并发任务 — 总耗时对比", fontweight="bold", pad=20, color=DARK_GRAY)



    # 底部注释
    fig.text(0.5, 0.01,
             "任务: 100ms sleep 模拟 I/O 阻塞 | 测试环境: Go 1.x, GOMAXPROCS=24 | 线程池=信号量限流 goroutine",
             ha="center", fontsize=10, color=MED_GRAY, style="italic")

    plt.tight_layout(rect=[0, 0.03, 1, 1])
    fig.savefig("chart1_耗时对比.png", facecolor="white", edgecolor="none")
    plt.close()
    print("[OK] chart1_耗时对比.png saved")


# ──────────────────────────────────────────────────────────
# 图表二：吞吐量 vs 并发规模 趋势折线图
# ──────────────────────────────────────────────────────────

def plot_throughput_trend():
    N_values = [100, 500, 1000, 5000, 10000, 50000]

    # Goroutine 吞吐量 (tasks/s) — 从全部 N 提取
    goroutine_tp = [990, 4854, 9524, 37879, 62500, 165563]

    # ThreadPool(P=1000) 吞吐量 — 仅当 N > 1000 时有数据
    # 小 N 时 P >= N，线程池不排队，等同协程；此处标注为"无瓶颈"
    tp1000_n = [5000, 10000, 50000]           # 有数据的 N
    tp1000_tp = [9901, 9901, 9919]             # 对应吞吐量

    fig, ax = plt.subplots(figsize=(12, 7))
    fig.patch.set_facecolor("white")
    ax.set_facecolor(OFF_WHITE)

    # Goroutine 折线
    ax.plot(N_values, goroutine_tp,
            color=DEEP_BLUE, marker="o", markersize=12, linewidth=3,
            markerfacecolor=DEEP_BLUE, markeredgecolor="white", markeredgewidth=1.5,
            label="Goroutine (有栈协程)", zorder=5)

    # ThreadPool(P=1000) 折线 — 大 N 段实线
    ax.plot(tp1000_n, tp1000_tp,
            color=LIGHT_GOLD, marker="s", markersize=12, linewidth=3,
            markerfacecolor=LIGHT_GOLD, markeredgecolor="white", markeredgewidth=1.5,
            linestyle="--", dashes=(6, 4),
            label="ThreadPool (P=1000)", zorder=4)

    # 虚线连接：N=1000 → N=5000 之间的理论过渡
    ax.plot([1000, 5000], [9524, 9901],
            color=LIGHT_GOLD, linewidth=1.5, linestyle=":", alpha=0.5, zorder=3)

    # 数值标注 — Goroutine
    offsets_g = [(0, 15), (0, 15), (0, 15), (10, -18), (10, -18), (15, -10)]
    for i, (n, tp) in enumerate(zip(N_values, goroutine_tp)):
        ax.annotate(f"{tp:,}",
                    (n, tp),
                    textcoords="offset points",
                    xytext=offsets_g[i],
                    fontsize=12, fontweight="bold", color=DEEP_BLUE,
                    ha="center")

    # 数值标注 — ThreadPool(P=1000)
    offsets_t = [(0, -22), (0, -22), (15, -10)]
    for i, (n, tp) in enumerate(zip(tp1000_n, tp1000_tp)):
        ax.annotate(f"{tp:,}",
                    (n, tp),
                    textcoords="offset points",
                    xytext=offsets_t[i],
                    fontsize=12, fontweight="bold", color=LIGHT_GOLD,
                    ha="center")

    # 坐标轴
    ax.set_xscale("log")
    ax.set_yscale("log")
    ax.set_xlabel("并发任务数 N", fontweight="bold")
    ax.set_ylabel("吞吐量 (tasks/s) — 对数坐标", fontweight="bold")
    ax.set_xticks(N_values)
    ax.set_xticklabels([f"{n:,}" for n in N_values])
    ax.get_xaxis().set_major_formatter(mticker.ScalarFormatter())
    ax.get_yaxis().set_major_formatter(mticker.ScalarFormatter())

    # 网格
    ax.grid(True, linestyle="--", alpha=0.4, color=MED_GRAY, zorder=0)

    # 图例
    ax.legend(loc="upper left", frameon=True, facecolor="white",
              edgecolor=SLATE_GRAY, framealpha=0.95)

    # 标题
    ax.set_title("吞吐量 vs 并发规模 — Goroutine 对比 ThreadPool(P=1000)",
                 fontweight="bold", pad=20, color=DARK_GRAY)



    # 底部注释
    fig.text(0.5, 0.01,
             "N ≤ 1000 时 ThreadPool(P=1000) 无排队, 性能与 Goroutine 相近 | N > 1000 后吞吐量被线程池上限锁死",
             ha="center", fontsize=10, color=MED_GRAY, style="italic")

    plt.tight_layout(rect=[0, 0.03, 1, 1])
    fig.savefig("chart2_吞吐量趋势.png", facecolor="white", edgecolor="none")
    plt.close()
    print("[OK] chart2_吞吐量趋势.png 已生成")


# ──────────────────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────────────────

if __name__ == "__main__":
    print("=" * 55)
    print("  协程 vs 线程 性能对比 — 图表生成")
    print("=" * 55)
    plot_time_comparison()
    plot_throughput_trend()
    print("\n>> 两张图表已生成，可直接插入 PPT。")
    print("   建议: 在 PPT 中标题加粗, 字体 ≥18pt, 图表背景设为透明/白色。")
