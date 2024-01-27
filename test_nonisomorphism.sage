load("assemble_data.sage")

# Construct Magma function fields.

def function_field_from_curve(i):
    eqn = i[-1]
    stratum = i[-2]
    if stratum == "plane_quintic":
        A.<x,y> = GF(2)[]
        return magma.FunctionField(eqn(x,y,1))
    else:
        return magma.FunctionField(eqn)

curve_models_by_zeta = {counts: [function_field_from_curve(j) for j in i] for counts, i in curves_by_zeta.items()}

# Check pairwise nonisomorphism, even between strata.
from itertools import combinations
for counts, i in curve_models_by_zeta.items():
    assert all(len(magma.Isomorphisms(j1, j2)) == 0 for j1, j2 in combinations(i, 2))
