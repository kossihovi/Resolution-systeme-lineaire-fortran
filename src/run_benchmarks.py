import numpy as np
import matplotlib.pyplot as plt
import bench 

 

#print(bench.bench_.__doc__) 
#print(bench.bench(1000))   

tailles = [1, 10, 100, 1000, 10000, 100000, 1000000]
#tailles = [10, 100, 200, 300, 500, 1000]
temps = []


for n in tailles:
    t = bench.bench(n)
    temps.append(t)


#Plot of the time of system resolution
#plt.plot(tailles, temps, marker='o')
#plt.xlabel("Taille du système n ")
#plt.ylabel(" Temps d'execution (s) ")
#plt.title( "Temps d'éxecution de la méthode de Jacobi ")
#plt.grid(False)
#plt.savefig('bench.png')
#plt.show()



plt.loglog(tailles, temps, 's-')
plt.xlabel('n')
plt.ylabel('temps (s)')
plt.title('Jacobi : temps de résolution')
plt.grid(False, which='both')
#plt.savefig('bench.png')
plt.show()