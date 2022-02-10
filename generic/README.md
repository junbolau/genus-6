This folder contains files used for the computation of supersingular generic curves of genus 6 over F_2. The codes are based on Kedlaya's codes for "The relative class number one problem for function fields, I, II, III" found here: https://github.com/kedlaya/same-class-number/tree/main/Part%20III

1. Compute the orbits of GL(2,5) on wedge^2 F_2^5 to get ```genus6-flats.txt```
2. ```sspointcounts_F2.sage ```: Compute F_2 points of elements and compare with supersingular point counts from ```ss_pointcount.txt```
3. ```sspointcounts_F16.sage```: Compute up to F_16 points from the previous list and compare with supersingular point counts
4. ```closeout.sage```: Close out computation by computing the remaining isomorphism classes (uses MAGMA)

In total, there are 38 supersingular curves of genus 6 in the generic case.
