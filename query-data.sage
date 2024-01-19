load("assemble_data.sage")

# Count points on M_6 and some related moduli stacks.

print("#M_6(F_2) = {}".format(sum(1/isom_order for (_, isom_order, _, _, _) in curves)))
print("#M_6,1(F_2) = {}".format(sum(1/isom_order*counts[0] for (counts, isom_order, _, _, _) in curves)))
print("#M_6,2(F_2) = {}".format(sum(1/isom_order*2*binomial(counts[0],2) for (counts, isom_order, _, _, _) in curves)))
print("#M_6,2/S_2(F_2) = {}".format(sum(1/isom_order*(binomial(counts[0],2)+counts[1]) for (counts, isom_order, _, _, _) in curves)))

# Sort curves by their point counts.
curves_by_zeta = defaultdict(list)
for (counts, isom_order, isom_type, stratum, eqn) in curves:
    curves_by_zeta[counts].append((isom_order, isom_type, stratum, eqn))
print("{} distinct zeta functions".format(len(curves_by_zeta)))

# Identify zeta functions arising from curves.
counts_with_curves = curves_by_zeta.keys()
zetas_with_curves = [weil_poly_from_point_count(t,6) for t in counts_with_curves]
newton_polys = set(tuple(u.newton_slopes(2)) for u in zetas_with_curves)
