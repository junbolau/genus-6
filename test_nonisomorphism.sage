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

# Check pairwise nonisomorphism, even between strata.
from itertools import combinations
counts_list = list(curves_by_zeta.keys())
counts_list.sort()
for counts in counts_list:
    l = curves_by_zeta[counts]
    print(counts, len(l))
    if len(l) <= 1:
        continue
    l2 = [function_field_from_curve(j) for j in l]
    assert all(len(magma.Isomorphisms(j1, j2)) == 0 for j1, j2 in combinations(l2, 2))
