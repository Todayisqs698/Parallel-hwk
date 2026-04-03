import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

plt.rcParams['font.sans-serif'] = ['SimHei']
plt.rcParams['axes.unicode_minus'] = False

colors = {
    'naive': '#555555',     # 深灰
    'two_way': '#9467bd',   # 紫色
    'four_way': '#1f77b4',  # 蓝色
    'iter_dc': '#2ca02c',   # 绿色
    'rec_dc': '#ff7f0e'     # 橙色
}

# 读取数据
df = pd.read_csv('sum_performance_pow2.csv')

#图 1：执行时间 (双对数坐标)
fig1, ax1 = plt.subplots(figsize=(10, 5), dpi=120)
ax1.set_facecolor('#F9F9F9')
for key in ['naive', 'two_way', 'four_way']:
    ax1.plot(df['N'], df[key], color=colors[key], label=key, linewidth=2)
ax1.plot(df['N'], df['iter_dc'], color=colors['iter_dc'], label='iter_dc', linestyle='--')
ax1.plot(df['N'], df['rec_dc'], color=colors['rec_dc'], label='rec_dc', linestyle='--')
ax1.set_xscale('log'); ax1.set_yscale('log')
ax1.set_title(label="",fontsize=13, fontweight='bold')
ax1.set_xlabel('数组大小 (N)'); ax1.set_ylabel('执行时间 (ms)')
ax1.grid(True, which="both", ls="-", alpha=0.15); ax1.legend()

# 图 2：加速比趋势
fig2, ax2 = plt.subplots(figsize=(10, 5), dpi=120)
ax2.plot(df['N'], df['speedup_two_way'], color=colors['two_way'], label='S2')
ax2.plot(df['N'], df['speedup_four_way'], color=colors['four_way'], label='S4')
ax2.plot(df['N'], df['speedup_iter_dc'], color=colors['iter_dc'], label='S_iter', linestyle='--')
ax2.plot(df['N'], df['speedup_rec_dc'], color=colors['rec_dc'], label='S_rec', linestyle='--')
ax2.axhline(y=1, color='red', linestyle='-', alpha=0.5)
ax2.set_xscale('log'); ax2.set_ylim(0, 4.5)
ax2.set_title(label="",fontsize=13, fontweight='bold')
ax2.set_xlabel('数组大小 (N)'); ax2.set_ylabel('加速比')
ax2.grid(True, alpha=0.2); ax2.legend()
plt.show()