import sys
import os 

current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)

load_attach_path(parent)

load('preamble.sage')

# Construct generators for GL(5,F_2) acting on \bigvee^2 F_2^5
F = GF(2)
G0 = SymmetricGroup(10)
g1 = G0([(1,5,8,10,4),(2,6,9,3,7)]).matrix().change_ring(F)
g2 = identity_matrix(F, 10)
g2[1,4] = 1
g2[2,5] = 1
g2[3,6] = 1
G = MatrixGroup([g1,g2])

# Construct an orbit lookup tree of depth 4 for the action of G on the dual of P^9
def apply_group_elem(g, x):
    x1 = g*x
    x1.set_immutable()
    return x1

def stabilizer(x):
    return vec_stab(Matrix(F, x), transpose=True)

def optimized_rep(g):
    return g.matrix()

def forbid(vecs, easy=False):
    return (Matrix(vecs).rank() < len(vecs))

methods = {'apply_group_elem': apply_group_elem,
           'stabilizer': stabilizer,
           'optimized_rep': optimized_rep,
           'forbid': forbid}

S = [x for x in VectorSpace(F, 10) if x != 0]
for x in S:
    x.set_immutable()
tree = build_orbit_tree(G, S, 4, methods, verbose=False)

H = GL(4,F)
gens = []
while H.subgroup(gens).order() != H.order():
    gens.append(H.random_element().matrix())

# Use the action of GL(4, F_2) to identify 4-tuples whose spans are G-equivalent
edges = []
for mats in green_nodes(tree, 4):
    for g in gens:
        mats0 = tuple(sum(g[i,j]*mats[j] for j in range(4)) for i in range(4))
        for v in mats0:
            v.set_immutable()
        mats1, g1 = orbit_rep_from_tree(G, tree, mats0, apply_group_elem, optimized_rep)
        edges.append((mats, mats1))

Gamma = Graph(edges, loops=True)
l = [cc[0] for cc in Gamma.connected_components(sort=False)]

i = 0
for ele in l:
    FILE_NAME = f'./flats/genus6_flat_{i}' + '.txt'
    with open(FILE_NAME, "w") as f:
        f.write(str(ele))
    i += 1
