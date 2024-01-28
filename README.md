# Census of Curves of Genus 6 over $\mathbb{F}_2$

This repository contains the code (written in SageMath and Magma) and data used to build a census of curves of genus 6 over the finite field $\mathbb{F}_2$. This is a joint project by Yongyuan (Steve) Huang, Kiran S. Kedlaya,and Jun Bo Lau, based primarily on Kiran S. Kedlaya's work in the paper "The relative class number one problem for function fields, III." We thank the Simons Collaboration in Arithmetic Geometry, Number Theory, and Computation and Boston University's Department of Mathematics and Statistics for providing computational resources for this project. 

```Census``` contains the code and data for each stratum in the Brill-Noether statification of the moduli stack of curves of genus 6 $\mathca{M}_6$. 

Below is a quic summary of our census: 
- There are 72227 isomorphism classes and 38327 isogeny classes of curves of genus 6 over $\mathbb{F}_2$.
- $\#\mathcal{M}_6(\mathbb{F}_2)= 68615$. 

A complete list of representatives of isomorphism classes of curves in our census can be recovered via ```assemble_data.sage```. For examples of how to query the data in our census, see ```query-data.sage```. 
Our data is also available via the table of isogeny classes of abelian varieties over finite fields in the [LMFDB](https://www.lmfdb.org). 