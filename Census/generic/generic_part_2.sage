import sys
import os 

current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)

load_attach_path(parent)

load('preamble.sage')

# Read from disk the precomputed data about codimension-4 flats in P^9
F = GF(2)
with open("genus6-flats.txt", "r") as f:
    s = f.read()
    l = sage_eval(s)
    l = [[vector(F, v) for v in vecs] for vecs in l]

# Construct the points of Gr(2,5) in P^9 and verify the Plucker relations
coords = {}
for V in VectorSpace(F, 5).subspaces(2):
    M = V.matrix()
    M.set_immutable()
    coords[M] = vector(M.minors(2))

S = list(coords.keys())

P.<x01,x02,x03,x04,x12,x13,x14,x23,x24,x34> = PolynomialRing(F, 10)
P_gens = list(P.gens())


# Plucker relations
quads = (x01*x23 + x02*x13 + x03*x12,
         x01*x24 + x02*x14 + x04*x12,
         x01*x34 + x03*x14 + x04*x13,
         x02*x34 + x03*x24 + x04*x23,
         x12*x34 + x13*x24 + x14*x23)

assert all(gen(*coords[M]) == 0 for M in coords for gen in quads)

load("weil_poly_dim6.sage")
load("weil_poly_utils.sage")

pointcounts = []
for pol in data: # data comes from weil_poly_dim6.sage 
    pointcounts.append(tuple(point_count_from_weil_poly(pol.reverse(),4,q=2)))
    
with open("pointcounts.sage", "w") as f:
    f.write( "data = " +str(pointcounts))

load("pointcounts.sage")


def vecs_to_gens(vecs):
    return tuple(sum(P.gens()[i] * v[i] for i in range(10)) for v in vecs)

#def redundancy(gens, F=F, P=P, monos2=monos2, quads=quads):
#    return [vector(F, ((gen*y).coefficient(mu) for mu in monos2)) for gen in gens for y in P.gens()] + \
#       [vector(F, (gen.coefficient(mu) for mu in monos2)) for gen in quads]


# We also enforce point counts over F_{2^2} using point counts
F4 = GF(4)
S4 = []
for V in VectorSpace(F4, 5).subspaces(2):
    M = V.matrix()
    v = vector(M.minors(2))
    i = min(j for j in range(10) if v[j])
    assert v[i] == 1
    v.set_immutable()
    S4.append(v)

tmp2 = set(t[:2] for t in data)

curves = defaultdict(list)
for vecs in l:
    M = Matrix(vecs)
    non_pivots = M.nonpivots()
    P_gens_new = [P_gens[i] for i in non_pivots]
    monos2 = [prod(x) for x in itertools.combinations_with_replacement(P_gens_new, 2)]
    quadrics = [sum(combo) for r in range(1,len(monos2) + 1) for combo in itertools.combinations(monos2, r)]
    
    V1 = Matrix(vecs).row_space()
    V = Matrix(vecs).right_kernel()
    gens = vecs_to_gens(V1.basis())
    pts = [coords[x] for x in S if coords[x] in V] # points in the intersection of the flat with Gr(2,5)
    pts2 = [x for x in S4 if all(gen(*x) == 0 for gen in gens)]
    

    for quadric in quadrics:
       s1 = sum(1 for x in pts if P(quadric(*x) ==0))
       if s1 <= 10:
           s2 = sum(1 for x in pts2 if quadric(*x) == 0)
           if (s1, s2) in tmp2:
               curves[(s1, s2)].append((gens, quadric))

    print([(s,len(curves[s])) for s in curves])
    
FILE_NAME = f'generic_unfiltered_unchecked' + '.txt'
with open(FILE_NAME, 'w') as f:
    f.write(str(curves))

    



