import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
df = pd.read_csv('1-1.csv')
df = df[df['MatrixSize'] >= 16].copy()
plt.rcParams['font.sans-serif'] = ['SimHei']
plt.rcParams['axes.unicode_minus'] = False

fig, ax = plt.subplots(figsize=(10, 6), dpi=200)
ax.plot(df['MatrixSize'], df['TimeNaive'], color='#E74C3C',
        label='平凡算法 (按列访问)', linewidth=1)

ax.plot(df['MatrixSize'], df['TimeOpt'], color='#2E86C1',
        label='优化算法 (按行访问)', linewidth=1)
ax.set_xscale('linear')
ax.set_xlim(0, 4096)
ax.set_yscale('linear')
ax.set_ylim(0, df['TimeNaive'].max() * 1.2) 
boundaries = [
    (78, 'L1', '#CB4335'),
    (512, 'L2', '#28B463'),
    (1982, 'L3 ', '#D4AC0D')
]
for pos, label, col in boundaries:
    ax.axvline(x=pos, color=col, linestyle='--', alpha=0.4, linewidth=1)
    ax.text(pos, 0.95, label, transform=ax.get_xaxis_transform(),
            rotation=0, color=col, fontsize=10, fontweight='bold',
            bbox=dict(facecolor='white', edgecolor=col, alpha=0.8, boxstyle='round,pad=0.3'),
            horizontalalignment='center')
ax.set_xlabel('矩阵规模 (n × n)', fontsize=12, fontweight='bold')
ax.set_ylabel('平均执行时间 (ms)', fontsize=12, fontweight='bold')
ax.set_title('矩阵大小与算法运行时间关系 ', fontsize=14, pad=20)
ax.grid(True, linestyle=':', alpha=0.5)
ax.legend(loc='upper left', bbox_to_anchor=(0.02, 0.9)) 
plt.tight_layout()
plt.show()