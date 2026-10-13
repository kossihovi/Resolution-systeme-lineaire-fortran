import numpy as np
import matplotlib.pyplot as plt
import bench 

 

#print(bench.bench_.__doc__) 
#print(bench.bench(1000000))   

tailles = [1, 10, 100, 1000, 10000, 100000, 1000000]
temps = []


for n in tailles:
    t = bench.bench(n)
    temps.append(t)


# Figure creation
fig, ax = plt.subplots(figsize=(12, 6))

# Resolution time layout
ax.loglog(tailles, temps, 'd-', linewidth=1,
        markersize=6, color='blue', markerfacecolor='white',
        markeredgecolor='blue', label='Méthode de Jacobi')

# Axis
ax.set_xlabel("Taille du système n", fontsize=10)
ax.set_ylabel("Temps d'execution (s)", fontsize=10)

# Lgend
ax.legend(fontsize=8, loc='best')

# Grill
ax.grid(True, which='both', linestyle="--", alpha=0.3)

plt.title('Temps de résolution de Jacobi en fonction de n', fontsize=10)
plt.tight_layout()
#plt.savefig('Jacobi_grille.png', dpi=300, bbox_inches='tight')
plt.show()