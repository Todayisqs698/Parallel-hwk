import matplotlib
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
import numpy as np

# ── 全局样式（与 Go 脚本完全对齐，确保贴进同一份 PPT 毫无违和感） ──────────────────────────────
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

# ── 沿用相同的学术暗色与高级灰配色 ──────────────────────────────────────────
DEEP_BLUE    = "#1B3A5C"   # asyncio 异步协程主色
LIGHT_GOLD   = "#D4A853"   # ThreadPool 线程池主色
WARM_GRAY    = "#A0937D"   # Serial 串行主色
SLATE_GRAY   = "#6B7D8E"
OFF_WHITE    = "#FFFFFF"
DARK_GRAY    = "#2D2D2D"
MED_GRAY     = "#8C8C8C"

# ==========================================
# 1. 提取并准备数据
# ==========================================
io_methods = ['Serial\n(串行执行)', 'ThreadPool\n(低并发线程池)', 'ThreadPool\n(高并发线程池)', 'asyncio\n(异步协程)']
io_means = [10.794163, 0.250644, 0.103201, 0.030756]
io_stds = [0.033215, 0.010472, 0.006182, 0.001912]
colors_io = [WARM_GRAY, LIGHT_GOLD, SLATE_GRAY, DEEP_BLUE]

cpu_methods = ['Serial\n(串行执行)', 'ThreadPool_1\n(线程池方案1)', 'ThreadPool_2\n(线程池方案2)', 'asyncio(base)\n(标准异步)', 'asyncio+Exec\n(异步+执行器)']
cpu_means = [2.532511, 2.525666, 2.524196, 2.536414, 2.543548]
cpu_stds = [0.004143, 0.008219, 0.013875, 0.014862, 0.008610]
# CPU 场景全部采用不同深浅的冷灰色系，暗喻“性能无本质差别”
colors_cpu = ["#9E9E9E", "#757575", "#616161", "#424242", "#212121"]

# ==========================================
# 2. 绘制图一：IO 密集型任务双子图精细化对比
# ==========================================
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 7))
fig.patch.set_facecolor("white")
ax1.set_facecolor(OFF_WHITE)
ax2.set_facecolor(OFF_WHITE)

# 左图：全局对比
bars1 = ax1.bar(io_methods, io_means, yerr=io_stds, capsize=6,
                error_kw={"ecolor": DARK_GRAY, "linewidth": 1.2},
                color=colors_io, edgecolor="white", linewidth=1.2, alpha=0.9, width=0.5, zorder=3)
for bar in bars1:
    height = bar.get_height()
    ax1.annotate(f'{height:.3f} s', xy=(bar.get_x() + bar.get_width() / 2, height),
                 xytext=(0, 5), textcoords="offset points", ha='center', va='bottom', fontsize=12, fontweight='bold', color=DARK_GRAY)
ax1.set_title('全局性能对比（含老大哥串行）', fontsize=14, fontweight='bold', color=DARK_GRAY, pad=10)
ax1.set_ylabel('平均耗时 (秒)', fontsize=13, fontweight='bold')
ax1.set_ylim(0, 13)
ax1.grid(axis="y", linestyle="--", alpha=0.4, color=MED_GRAY, zorder=0)

# 右图：聚焦高并发方案（剔除串行，放大细节）
high_perf_methods = io_methods[1:]
high_perf_means = io_means[1:]
high_perf_stds = io_stds[1:]
colors_high = colors_io[1:]

bars2 = ax2.bar(high_perf_methods, high_perf_means, yerr=high_perf_stds, capsize=6,
                error_kw={"ecolor": DARK_GRAY, "linewidth": 1.2},
                color=colors_high, edgecolor="white", linewidth=1.2, alpha=0.9, width=0.4, zorder=3)
for bar in bars2:
    height = bar.get_height()
    ax2.annotate(f'{height:.3f} s', xy=(bar.get_x() + bar.get_width() / 2, height),
                 xytext=(0, 5), textcoords="offset points", ha='center', va='bottom', fontsize=12, fontweight='bold', color=DARK_GRAY)
ax2.set_title('高效并发方案局部细节放大', fontsize=14, fontweight='bold', color=DARK_GRAY, pad=10)
ax2.set_ylabel('平均耗时 (秒)', fontsize=13, fontweight='bold')
ax2.set_ylim(0, 0.35)
ax2.grid(axis="y", linestyle="--", alpha=0.4, color=MED_GRAY, zorder=0)

plt.suptitle('IO 密集型场景（2,000个任务）— 多维度精细化对比', fontsize=20, fontweight='bold', y=0.98, color=DARK_GRAY)
fig.text(0.5, 0.01,
         "负载: 2000个任务 × 5ms 阻塞等待 | 环境: Python 3.12 | 误差棒代表5次测试标准差(std_s)",
         ha="center", fontsize=10, color=MED_GRAY, style="italic")

plt.tight_layout(rect=[0, 0.03, 1, 0.95])
plt.savefig('io_dense_subplots.png')
plt.close()
print("[OK] io_dense_subplots.png saved")

# ==========================================
# 3. 绘制图二：CPU 密集型任务对比（众生平等）
# ==========================================
fig, ax = plt.subplots(figsize=(12, 7))
fig.patch.set_facecolor("white")
ax.set_facecolor(OFF_WHITE)

x = np.arange(len(cpu_methods))
bars = ax.bar(x, cpu_means, yerr=cpu_stds, capsize=6,
              error_kw={"ecolor": DARK_GRAY, "linewidth": 1.2},
              color=colors_cpu, edgecolor="white", linewidth=1.2, alpha=0.8, width=0.5, zorder=3)

for bar, val in zip(bars, cpu_means):
    height = bar.get_height()
    ax.annotate(f'{val:.3f} s',
                xy=(bar.get_x() + bar.get_width() / 2, height),
                xytext=(0, 5),
                textcoords="offset points",
                ha='center', va='bottom', fontsize=13, fontweight='bold', color=DARK_GRAY)

ax.set_title('CPU 密集型场景（80个任务）— 耗时性能实测', fontsize=20, fontweight='bold', pad=20, color=DARK_GRAY)
ax.set_ylabel('平均耗时 (秒)', fontsize=16, fontweight='bold')
ax.set_xticks(x)
ax.set_xticklabels(cpu_methods)
ax.set_ylim(0, 3.5)
ax.grid(axis="y", linestyle="--", alpha=0.4, color=MED_GRAY, zorder=0)

fig.text(0.5, 0.01,
         "负载: 80个纯数学计算任务(12万次循环) | 结论: 受制于 Python GIL，多线程与协程均无法激活多核并行加速",
         ha="center", fontsize=10, color=MED_GRAY, style="italic")

plt.tight_layout(rect=[0, 0.03, 1, 1])
plt.savefig('cpu_bound_benchmark.png')
plt.close()

print("[OK] cpu_bound_benchmark.png saved")