import sys
import os 

current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)

load_attach_path(parent)

load('preamble.sage')

# Construct the set of F_2-rational points of P_1 \times P_1
F = GF(2)
P.<x0,x1,y0,y1> = PolynomialRing(F, 4)

S1 = [vector(t) for t in ProjectiveSpace(F,1)]
for v in S1:
    v.set_immutable()
S = list(itertools.product(S1, S1))

# Construct the group GL(2, F_2) \times GL(2, F_2), presented as a subgroup of GL(4, F_2)
l0 = [block_matrix(2,2,[g.matrix(),0,0,identity_matrix(2)], subdivide=False) for g in GL(2,F).gens()] +\
       [block_matrix(2,2,[identity_matrix(2),0,0,g.matrix()], subdivide=False) for g in GL(2,F).gens()]
G0 = GL(4,F).subgroup(l0)

# Use an orbit lookup tree to find GL(2, F_2)\times GL(2, F_2)-orbit representatives for 6-tuples of F_2 points in P_1\times P_1
def apply_group_elem(g, x):
    g1 = g.submatrix(nrows=2,ncols=2)
    g2 = g.submatrix(row=2,col=2)
    v1 = g1*x[0]
    v2 = g2*x[1]
    v1.set_immutable()
    v2.set_immutable()
    return (v1, v2) 

def stabilizer(x):
    G1 = vec_stab(Matrix(F, x[0]), transpose=True)
    G2 = vec_stab(Matrix(F, x[1]), transpose=True)
    l0 = [block_matrix(2,2,[g.matrix(),0,0,identity_matrix(2)], subdivide=False) for g in G1.gens()] + \
        [block_matrix(2,2,[identity_matrix(2),0,0,g.matrix()], subdivide=False) for g in G2.gens()]
    return GL(4, F).subgroup(l0)

def optimized_rep(g):
    return g.matrix()

methods = {'apply_group_elem': apply_group_elem,
           'stabilizer': stabilizer,
           'optimized_rep': optimized_rep}
tree = build_orbit_tree(G0, S, 10, methods, verbose=False)

# For each orbit representative of k-tuples with k=0,...,9, find (3,4)-curves passing through precisely those points

monos3 = [prod(x) for x in itertools.combinations_with_replacement([x0,x1],3)]
monos4 = [prod(x) for x in itertools.combinations_with_replacement([y0,y1],4)]
monos34 = [prod(x) for x in itertools.product(monos3, monos4)]

coords34 = {x: vector(F, (mu(*x[0], *x[1]) for mu in monos34)) for x in S}

def vec_to_gen(vec):
    return sum(vec[i]*monos34[i] for i in range(20))

curves = defaultdict(list)
perp = Matrix([coords34[x] for x in S])
for i in range(4, 10):
    for vecs in green_nodes(tree, i):
        target = vector(F, (0 if x in vecs else 1 for x in S))
        for w in solve_right_iterator(perp, target):
            curves[(i,)].append(vec_to_gen(w))



# Close out the case
I1 = P.ideal([x0,x1])
I2 = P.ideal([y0, y1])
CR = magma.CoxRing(P, [I1, I2], [[1,1,0,0],[0,0,1,1]], [])
proj = CR.ToricVariety()

with open("ss_trigonalmaroni0_1.txt", "w") as f:
    for i in range(4,10): 
        print('Handling curves with ', i, 'F_2 points')
        f.write('curves with ' + str(i) + ' F_2 points')
        lst = closeout(6, curves[(i,)], X=proj)
        f.write(str(lst))