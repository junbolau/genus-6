This collection of code computes all isomorphism classes of trigonal curves of genus 6 of Maroni invariant 2 over F_2 and stores all the data, including the ones used in the intermediate steps. 

enum_trigonal_maroni_2.sage - SageMath code that enumerates candidate curves and stores them in ./data_unfiltered/.

curve_check.m - Magma code that checks whether each of the candidate curves in ./data_unfiltered/ is integral of genus 6 and computes their point count over F_{2^i} for i=1,2,3,4,5,6. The filtered data are then stored in ./data_filtered/. 

file_mod.py - Helper Python code that groups together curves in ./data_filtered/ with the same point counts over F_{2^i} for i=1,2,3,4,5,6 and stores the regrouped curves in ./data_filtered_updated/. 

isom_class_check.m - Magma code that computes the distinct isomorphism classes of curves in ./data_filtered_updated/ and stores each isomorphism class in ./sorted_data. For each isomorphism class, it also computes the order of its automorphism group over F_2. 