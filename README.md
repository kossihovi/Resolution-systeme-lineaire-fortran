# 2026_ma0922_TP FORTRAN

## Description
Ce projet porte sur la résolution d'un système linéaire de la forme $Ax=b$ par la méthode itérative de Jacobi. $A$ est une matrice carrée à coefficients creuse i.e. avec beaucoup de coefficients nuls. L'objectif est de stocker la matrice creuse $A$ de taille $n$ arbitraire sous le format compressed sparse row **CSR**. Le format **CSR** est defini avec trois tableaux unidimensionnel, *val* pour les valeurs non nulles; *nnz* le nombre de valeurs non nulles cumulées par ligne, qui commence à $0$ et *icol* l'indice de colonne de la valeur non nulle. A la suite, nous créons une interface (API) vers python pour afficher la courbe des temps de résolution du système en fonction de la taille $n$.

## Technologies 
Language : Fortran, Python

Outils : Git, GitLab

## Contenu du dépot (répertoire)

* src
  + .f90
  + .py 
* doc
  + .qmd
  + .png 

* README.md





## Compilation des fichiers .f90
Les codes sources sont accessible dans le dossier src via cd src

Pour compiler un programme, on suit la syntaxe suivante :

```{.fortran}
gfortran -Wall -pedantic -o program program.f90
./program
```
Dans notre projet pour faire nos tests dans le fichier verifications.f90, il faut exécuter la commande suivante: 

```{.fortran}
gfortran -Wall -pedantic -o verifications matutils.f90 linearsolver.f90 verifications.f90
./verifications
```
On pourra optimiser avec la commande: 

```{.fortran}
gfortran -Wall -pedantic -O2 -o verifications matutils.f90 linearsolver.f90 verifications.f90
./verifications
```


## Creation de l'interface python (API) avec f2py
La compilation se fait en deux étapes et nécessite python 3.12 et numpy 2. et numpy.f2py; aussi des dépendances comme meson. Pour installer les dépendances :

```{.python}
python -m pip install numpy matplotlib meson
```


La procédure fortran qui nous permet de créer le module python se trouve dans un fichier nommé benchmarks.f90 et utilise les fichiers matutils.f90 linearsolver.f90 dans src. Depuis le dossier src, lancez la commande suivante :

```{.python}
python -m numpy.f2py -m bench -h bench.pyf benchmarks.f90
```

Cette commande génère un fichier d'interface .pyf qui contient et resume la routine qu'on peut modifier. Ensuite toujours dans src, lancez :

```{.python}
python -m numpy.f2py -c -m bench bench.pyf matutils.f90 linearsolver.f90 benchmarks.f90
```

Cette dernière commande, si elle marche crée une librairie bench.cypython-312-darwin.so qui contient le module python nommé bench. Vous pourrez donc l'importer dans python avec "import bench" et faire vos calculs et afficher les graphiques avec matplotlib.

