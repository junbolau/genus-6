load("assemble_data.sage")
from itertools import combinations

# Check pairwise nonisomorphism, even between strata.
counts_list = list(curves_by_zeta.keys())
counts_list.sort()
for counts in counts_list:
    l = curves_by_zeta[counts]
    print(counts, len(l))
    if len(l) <= 1:
        continue
    l2 = [magma.FunctionField(j[-1]) for j in l]
    assert all(len(magma.Isomorphisms(j1, j2)) == 0 for j1, j2 in combinations(l2, 2))

