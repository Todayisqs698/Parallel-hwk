import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
df = pd.read_csv('1-1.csv')
df = df[df['MatrixSize'] >= 64].copy()

df['Speedup_Smooth'] = df['Speedup'].rolling(window=10, min_periods=1).mean()
plt.rcParams['font.sans-serif'] = ['SimHei']
plt.rcParams['axes.unicode_minus'] = False

fig, ax = plt.subplots(figsize=(10, 6), dpi=200)
ax.plot(df['MatrixSize'], df['Speedup_Smooth'], color='#8E44AD',
        label='加速比', linewidth=1.0)

ax.set_xscale('linear')
ax.set_xlim(0, 4096)
ax.set_yscale('linear')
ax.set_ylim(0, df['Speedup_Smooth'].max() * 1.4)
boundaries = [
    (78, 'L1', '#CB4335'),
    (512, 'L2', '#28B463'),
    (1982, 'L3', '#D4AC0D')
]

for pos, label, col in boundaries:
    ax.axvline(x=pos, color=col, linestyle='--', alpha=0.4, linewidth=1)
    ax.text(pos, 0.96, label, transform=ax.get_xaxis_transform(),
            rotation=0, color=col, fontsize=10, fontweight='bold',
            bbox=dict(facecolor='white', edgecolor=col, alpha=0.9, boxstyle='round,pad=0.3'),
            horizontalalignment='center', verticalalignment='center')

ax.set_xlabel('矩阵规模 (n × n)', fontsize=12, fontweight='bold')
ax.set_ylabel('加速比', fontsize=12, fontweight='bold')
ax.set_title('矩阵大小与加速比的关系', fontsize=14, pad=30) 
ax.grid(True, linestyle=':', alpha=0.5)
ax.legend(loc='upper left', bbox_to_anchor=(0.02, 0.92))  

plt.tight_layout()
plt.subplots_adjust(top=0.88)
plt.show()