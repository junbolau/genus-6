This collection of code computes all isomorphism classes of Brill-Noether-general (aka generic) curves of genus 6 over F_2 and stores all the data, including the ones used in the intermediate steps. 

The computation is broken down into the following steps: 

1) generic_part_1.sage: Identify orbit representatives for the action of GL(5, F_2) on 4-tuples of points in P^9(F_2)^{\vee}. There are 57 such flats, whose coordinates are stored in ./flats/. Only twenty of them intersect the Grassmannian Gr(2,5) on an irreducible surface in P^9. 

2) generic_part_2.sage: For each of the twenty flats whose intersection with Gr(2,5) is an irreducible surface in P^9, writes in ./flats/unfiltered the 2^21 quadrics whose intersection with their respective flat and Gr(2,5) in P^9 may give rise to a smooth curve of genus 6. 

2') generic_part_3.py: Helper Python code that splits each of the text files in ./flats/unfiltered into smaller chunks for more efficient parallelization of the subsequent steps. 

3) curve_check.m: Magma code that checks whether each of the candidate curves in ./flats/unfiltered/ is integral of genus 6 and computes their point count over F_{2^i} for i=1,2,3,4,5,6. The coefficients of the quadrics that intersect its flat and Gr(2,5) in a smooth curve of genus 6 in P^9 are then stored in ./data_unfiltered/. 

4) generic_part_4.py - Helper Python code that groups together curves in ./data_unfiltered/ with the same point counts over F_{2^i} for i=1,2,3,4,5,6 and stores the regrouped curves in ./data_unfiltered_updated/. 

5) isom_class_check.m: Magma code that computes the distinct isomorphism classes of curves in ./data_unfiltered_updated/ and stores each isomorphism class in ./sorted_data. For each isomorphism class, it also computes the order of its automorphism group over F_2.  