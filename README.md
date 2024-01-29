## A Census of Curves of Genus 6 over $\mathbb{F}_2$
### by Yongyuan Huang, Kiran S. Kedlaya, and Jun Bo Lau

This repository contains the code (written in SageMath and Magma) and data used to build a census of curves of genus 6 over the finite field $\mathbb{F}_2$. This is based primarily on Kedlaya's paper "The relative class number one problem for function fields, III" and its [associated code repository](https://github.com/kedlaya/same-class-number). Some findings:
- There are 72227 isomorphism classes and 38327 isogeny classes of curves of genus 6 over $\mathbb{F}_2$.
- \# $\mathcal{M}_6(\mathbb{F}_2)= 68615$. 

The directory ```Census``` contains the code and data for each stratum in the Brill-Noether statification of the moduli stack $\mathcal{M}_6$ of curves of genus 6. Each stratum is represented by a single subdirectory with its own README:

- Hyperelliptic curves (`Census/hyperelliptic`)
- Trigonal curves of Maroni invariant 0 (`Census/trigonal_maroni_0`)
- Trigonal curves of Maroni invariant 2 (`Census/trigonal_maroni_2`)
- Bielliptic curves (`Census/bielliptic`)
- Smooth plane quintic curves (`Census/plane_quintics`)
- All others (`Census/generic`)

The subdirectory ```Census/Shared``` includes some utility code taken from https://github.com/kedlaya/same-class-number.

Some additional utility files can be found in this directory:

- ```assemble_data.sage```: compiles a Sage list of representatives of isomorphism classes.
- ```data-to-txtfile.sage```: compiles a list of isogeny classes of Jacobians indexed by their LMFDB labels.
- ```query_data.sage```: provides some examples of how to query the data.
- ```test_nonisomorphism.sage```: verifies that all of the curves are pairwise nonisomorphic (even across Brill-Noether strata).

Our data is also available via the table of isogeny classes of abelian varieties over finite fields in the [LMFDB](https://www.lmfdb.org). 

We thank the Simons Collaboration in Arithmetic Geometry, Number Theory, and Computation and Boston University's Department of Mathematics and Statistics for providing computational resources for this project. 

