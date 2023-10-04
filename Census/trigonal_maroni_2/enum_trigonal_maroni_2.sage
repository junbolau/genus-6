import sys
import os 

current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)

load_attach_path(parent)

load('preamble.sage')

# Construct the sets of F_2-rational points for a specific (2,1)-hypersurface X_1
# in P^1 X P^2 

F = GF(2)
P.<x0,x1,y0,y1,y2> = F[]
gen1 = x0^2*y0 + x0*x1*y1 + x1^2*y2

S1 = [vector(t) for t in ProjectiveSpace(F, 1)]
S2 = [vector(t) for t in ProjectiveSpace(F, 2)]
for v in S1 + S2:
    v.set_immutable()
S0 = list(itertools.product(S1, S2))
S = [x for x in S0 if gen1(*x[0], *x[1]) == 0]

# Construct a subgroup G0 of GL(2, F_2) X GL(3, F_2) fixing X_1
l0 = [Matrix(F,[[1,1,0,0,0],[0,1,0,0,0],[0,0,1,0,0],[0,0,0,1,0],[0,0,1,1,1]]),
      Matrix(F,[[0,1,0,0,0],[1,0,0,0,0],[0,0,0,0,1],[0,0,0,1,0],[0,0,1,0,0]])]
G0 = GL(5,F).subgroup(l0)

# Use an orbit lookup tree to find G0-orbit representatives for 6-tuples of F_2-points in X_1
def apply_group_elem(g, x):
    g1 = g.submatrix(nrows=2,ncols=2)
    g2 = g.submatrix(row=2,col=2)
    v1 = g1*x[0]
    v2 = g2*x[1]
    v1.set_immutable()
    v2.set_immutable()
    return (v1, v2)

assert all(apply_group_elem(g, x) in S for g in l0[:1] for x in S)

def stabilizer(x):
    G1 = vec_stab(Matrix(F, x[0]), transpose=True)
    G2 = vec_stab(Matrix(F, x[1]), transpose=True)
    l0 = [block_matrix(2,2,[g.matrix(),0,0,identity_matrix(3)], subdivide=False) for g in G1.gens()] + \
        [block_matrix(2,2,[identity_matrix(2),0,0,g.matrix()], subdivide=False) for g in G2.gens()]
    return GL(5, F).subgroup(l0)

def optimized_rep(g):
    return g.matrix()

methods = {'apply_group_elem': apply_group_elem,
           'stabilizer': stabilizer,
           'optimized_rep': optimized_rep}
tree = build_orbit_tree(G0, S, 10, methods, verbose=False)

monos13 = [prod(x) for x in itertools.product([prod(y) for y in itertools.combinations_with_replacement([x0,x1],1)],
                                              [prod(y) for y in itertools.combinations_with_replacement([y0,y1,y2],3)])]

coords13 = {x: vector(F, (mu(*x[0], *x[1]) for mu in monos13)) for x in S}

perp = Matrix([coords13[x] for x in S])
perp.set_immutable()
curves = defaultdict(list) 

for i in range(0, 10):
    for vecs in green_nodes(tree, i):
        target = vector(F, (0 if x in vecs else 1 for x in S))
        for v2 in solve_right_iterator(perp, target):
            gen2 = sum(v2[j]*monos13[j] for j in range(20))
            curves[(i)].append((gen1, gen2))

print([(s, len(curves[s])) for s in curves])

# Close out this case
"""
I1 = P.ideal([x0,x1])
I2 = P.ideal([y0,y1,y2])
CR = magma.CoxRing(P, [I1,I2], [[1,1,0,0,0],[0,0,1,1,1]], [])
proj = CR.ToricVariety()

with open("ss_trigonalmaroni2.txt", "w") as f:
    for i in range(0,10): 
        print('Handling curves with ', i, 'F_2 points')
        f.write('curves with ' + str(i) + ' F_2 points')
        lst = closeout(6, curves[(i,)], X=proj)
        f.write(str(lst))
"""
