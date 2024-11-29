load("assemble_data.sage")
load("Census/Shared/weil_poly_utils.sage")

# Count distinct zeta functions.
print("{} distinct zeta functions".format(len(curves_by_zeta)))
print()

# Count points on M_6 and some related moduli stacks.

print("#M_6(F_2) = {}".format(sum(1/isom_order for (_, isom_order, _, _, _) in curves)))
print("#M_6,1(F_2) = {}".format(sum(1/isom_order*counts[0] for (counts, isom_order, _, _, _) in curves)))
print("#M_6,2/S_2(F_2) = {}".format(sum(1/isom_order*(binomial(counts[0],2)+(counts[1]-counts[0])/2) for (counts, isom_order, _, _, _) in curves)))
print("#M_6,2(F_2) = {}".format(sum(1/isom_order*2*binomial(counts[0],2) for (counts, isom_order, _, _, _) in curves)))
print("#M_6,3/S_3(F_2) = {}".format(sum(1/isom_order*(binomial(counts[0],3)+counts[0]*(counts[1]-counts[0])/2) for (counts, isom_order, _, _, _) in curves)))
print("#M_6,3(F_2) = {}".format(sum(1/isom_order*6*binomial(counts[0],3) for (counts, isom_order, _, _, _) in curves)))
print("#M_6,4/S_4(F_2) = {}".format(sum(1/isom_order*(binomial(counts[0],4)+binomial(counts[0],2)*(counts[1]-counts[0])/2+counts[0]*(counts[2]-counts[0])/3+binomial((counts[1]-counts[0])/2,2)+(counts[3]-counts[1])/4) for (counts, isom_order, _, _, _) in curves)))
print()

# Identify automorphism groups.
autom_groups = set((i[1], i[2]) for i in curves)
print("Automorphism groups:")
print(autom_groups)
print()

# Confirm that there are two curves with 10 or more points.
print("Curves with 10 or more points:")
print([j for j in curves if j[0][0] >= 10])
print()

# Confirm that there are no curves with zero F_8-points.
assert all(j[4] != "generic" or j[0][2] > 0 for j in curves)

# Identify zeta functions arising from curves, and confirm that they obey RH.
counts_with_curves = curves_by_zeta.keys()
zetas_with_curves = [weil_poly_from_point_count(t,6) for t in counts_with_curves]
assert all(u.is_weil_polynomial() for u in zetas_with_curves)
print("RH verified")

# Verify that all possible Newton polygons occur.
newton_polys = set(tuple(u.newton_slopes(2)) for u in zetas_with_curves)
print("Newton polygons found:")
print(newton_polys)
print()

# Tabulate supersingular curves.
supersingular_counts = [t for t in counts_with_curves if set(weil_poly_from_point_count(t,6).newton_slopes(2)) == set([1/2])]
supersingular_curves = [i for t in supersingular_counts for i in curves_by_zeta[t]]
print("{} supersingular curves found, with {} distinct zeta functions".format(len(supersingular_curves), len(supersingular_counts)))

# Check computations in "The relative class number problem for function fields, III".
targets6 = [(4, 14, 16, 18, 14, 92),
    (4, 14, 16, 18, 24, 68),
    (4, 14, 16, 26, 14, 68),
    (4, 16, 16, 20, 9, 64),
    (5, 11, 11, 31, 20, 65),
    (5, 11, 11, 31, 20, 77),
    (5, 11, 11, 31, 20, 89),
    (5, 11, 11, 31, 30, 53),
    (5, 11, 11, 31, 30, 65),
    (5, 11, 11, 31, 30, 77),
    (5, 11, 11, 31, 30, 89),
    (5, 11, 11, 31, 40, 53),
    (5, 11, 11, 31, 40, 65),
    (5, 11, 11, 39, 20, 53),
    (5, 11, 11, 39, 20, 65),
    (5, 13, 14, 25, 15, 70),
    (5, 13, 14, 25, 15, 82),
    (5, 13, 14, 25, 15, 94),
    (5, 13, 14, 25, 25, 46),
    (5, 13, 14, 25, 25, 58),
    (5, 13, 14, 25, 25, 70),
    (5, 15, 5, 35, 20, 45),
    (6, 10, 9, 38, 11, 79),
    (6, 10, 9, 38, 21, 67),
    (6, 10, 9, 38, 31, 55),
    (6, 14, 6, 26, 26, 68),
    (6, 14, 6, 26, 26, 80),
    (6, 14, 6, 26, 36, 56),
    (6, 14, 6, 34, 16, 56),
    (6, 14, 6, 34, 26, 44),
    (6, 14, 12, 26, 6, 44),
    (6, 14, 12, 26, 6, 56),
    (6, 14, 12, 26, 6, 66)]
print("Candidates for relative class number 1 covers:")
target_curves = [k for i,j in curves_by_zeta.items() if i in targets6 for k in j]
for i in file_keys:
    print(i, sum(1 for j in target_curves if j[-2] == i))

