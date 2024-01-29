load("assemble_data.sage")

curves_by_zeta = defaultdict(list)
for (counts, isom_order, isom_type, stratum, eqn) in curves:
    curves_by_zeta[counts].append((isom_order, isom_type, stratum, eqn))

with open('lmfdbgenus6_curves_F2.txt', 'w') as file: 
    R.<x,y> = ZZ[]
    for counts in curves_by_zeta:
        weil_poly = weil_poly_from_point_count(counts, 6)
        label = label_from_weil_poly(weil_poly)
        curves = curves_by_zeta[counts]
        jacobian_count = len(curves)
        hyp_count = sum([1 for curve in curves if 'hyperelliptic' in curve])
        equations = [latex(R(curve[3])) for curve in curves]
        formatted_equations = "{{{}}}".format(", ".join(equations))
        file.write('{}|1|{}|{}|{}'.format(label, jacobian_count, hyp_count, formatted_equations))
        file.write('\n')
        