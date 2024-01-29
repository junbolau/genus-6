This collection of code computes all isomorphism classes of Brill-Noether-general (aka generic) curves of genus 6 over F_2 and stores all the data, including the ones used in the intermediate steps. 

The computation is broken down into the following steps: 

1) ```generic_part_1.sage```: Identify orbit representatives for the action of $GL(5, \mathbb{F}_2)$ on 4-tuples of points in $\mathbf{P}^9(\mathbb{F}_2)^{\vee}$. There are 57 such flats, whose coordinates are stored in ```./flats/```. Only twenty of them intersect the Grassmannian $Gr(2,5)$ on an irreducible surface in $\mathbf{P}^9$. 

2) ```generic_part_2.sage```: For each of the twenty flats whose intersection with Gr(2,5) is an irreducible surface in $\mathbf{P}^9$, writes in ```./flats/unfiltered''' the $2^21$ quadrics whose intersection with their respective flat and Gr(2,5) in $\mathbf{P}^9$ may give rise to a smooth curve of genus 6. 

3) ```generic_part_3.py```: Helper Python code that splits each of the text files in ```./flats/unfiltered``` into smaller chunks for more efficient parallelization of the subsequent steps. 

4) ```curve_check.m```: Magma code that checks whether each of the candidate curves in ```./flats/unfiltered/``` is integral of genus 6 and computes their point count over $\mathbb{F}_{2^i}$ for $i=1,2,3,4,5,6$. The coefficients of the quadrics that intersect its flat and $Gr(2,5)$ in a smooth curve of genus 6 in $\mathbf{P}^9$ are then stored in ```./data_unfiltered/```. 

5) ```generic_part_4.py``` - Helper Python code that groups together curves in ```./data_unfiltered/``` with the same point counts over $\mathbb{F}_{2^i}$ for $i=1,2,3,4,5,6$ and stores the regrouped curves in ```./data_unfiltered_updated/```. 

6) ```isom_class_check.m```: Magma code that computes the distinct isomorphism classes of curves in ```./data_unfiltered_updated/``` and stores each isomorphism class in ./sorted_data. For each isomorphism class, it also computes the order of its automorphism group over $\mathbb{F}_2$.  

We have the following (nonstacky, stacky) count for the number of isomorphism classes of generic curves of genus 6 over $\mathbb{F}_2$ corresponding to each flat:
- flat 0: (2449, 2439)
- flat 1: (4705, 4682)
- flat 2: (1923, 1887)
- flat 3: (4243, 12713/3)
- flat 4: (2337, 2306)
- flat 5: (3078, 3048.5)
- flat 6: (1852, 1822.5)
- flat 8: (5552, 5519.5)
- flat 9: (5735, 5730.2)
- flat 10: (1022, 2989/3)
- flat 13: (2782, 8285/3)
- flat 14: (4668, 4649)
- flat 15: (3009, 2973)
- flat 19: (0, 0)
- flat 22: (1568, 1534)
- flat 23: (2762, 2687.75)
- flat 25: (1120, 1068.5)
- flat 31: (0, 0)
- flat 32: (0, 0)
- flat 48: (91, 4223/60)

Total: (48896, 48413)
