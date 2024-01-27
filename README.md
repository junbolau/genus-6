A Census of Curves of Genus 6 over F_2
by Yongyuan Huang, Kiran S. Kedlaya, and Jun Bo Lau

This repository accompanies the paper of the same title. It contains the code (written in SageMath and Magma) and data used to conduct a census of curves of genus 6 over the finite field F_2. 

The census proceeds by separately enumerating curves in the various Brill-Noether strata. The code for each stratum is in a separate subdirectory with its own README:

- Hyperelliptic curves (`Census/hyperelliptic`)
- Trigonal curves of Maroni invariant 0 (`Census/trigonal_maroni_0`)
- Trigonal curves of Maroni invariant 2 (`Census/trigonal_maroni_2`)
- Bielliptic curves (`Census/bielliptic`)
- Smooth plane quintic curves (`Census/plane_quintics`)
- All others (`Census/generic`)

The Sage file `assemble_data.sage` extracts the results into a single Sage object.
The Sage file `query_data.sage` performs some additional verifications on the results.
The Sage file `test_nonisomorphism.sage` tests that all of the curves are pairwise nonisomorphic.
