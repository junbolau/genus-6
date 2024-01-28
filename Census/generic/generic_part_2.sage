import sys
import os 

current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)

load_attach_path(parent)

load('preamble.sage')

# Read from disk the precomputed data about codimension-4 flats in P^9
F = GF(2)
P.<x01,x02,x03,x04,x12,x13,x14,x23,x24,x34> = PolynomialRing(F, 10)
P_gens = list(P.gens())

FILE_NAME = './flats/' + sys.argv[1]
with open(FILE_NAME, "r") as f:
    s = f.read()
    l = sage_eval(s)
    l = [[vector(F, v) for v in l]]

def vecs_to_gens(vecs):
    return tuple(sum(P.gens()[i] * v[i] for i in range(10)) for v in vecs)

# Construct the linear forms defining the flat
vecs = l[0]
M = Matrix(vecs)
non_pivots = M.nonpivots()
V1 = Matrix(vecs).row_space()
V = Matrix(vecs).right_kernel()
gens = vecs_to_gens(V1.basis())
flat = []
for gen in gens:
    tmp = []
    for ele in gen:
        tmp.append(P_gens.index(ele[1]))
    flat.append(tmp)

# Construct the points of Gr(2,5) in P^9 and verify the Plucker relations
coords = {}
for W in VectorSpace(F, 5).subspaces(2):
    M = W.matrix()
    M.set_immutable()
    coords[M] = vector(M.minors(2))

S = list(coords.keys())


P_monos2 = [prod(x) for x in itertools.combinations_with_replacement(P_gens, 2)]


# Plucker relations
quads = (x01*x23 + x02*x13 + x03*x12,
         x01*x24 + x02*x14 + x04*x12,
         x01*x34 + x03*x14 + x04*x13,
         x02*x34 + x03*x24 + x04*x23,
         x12*x34 + x13*x24 + x14*x23)

assert all(gen(*coords[M]) == 0 for M in coords for gen in quads)

P_gens_new = [P_gens[i] for i in non_pivots]
monos2 = [prod(x) for x in itertools.combinations_with_replacement(P_gens_new, 2)]
quadrics = [sum(combo) for r in range(1,len(monos2) + 1) for combo in itertools.combinations(monos2, r)]
        
pts = [coords[x] for x in S if coords[x] in V] # points in the intersection of the flat with Gr(2,5)
pts2 = [x for x in S4 if all(gen(*x) == 0 for gen in gens)]


FILE_NAME_new = './flats/unfiltered/'+ FILE_NAME.replace('.txt', '').replace('./flats/','') \
    + f'_unfiltered' + '.txt'
with open(FILE_NAME_new, 'w') as f:
    f.write(str(flat))
    f.write('\n')
    for quadric in quadrics:
        tmp = []
        for ele in quadric:
            tmp.append(P_monos2.index(ele[1]))
        f.write(str(tmp))
        f.write('\n')
    f.write('task completed')
