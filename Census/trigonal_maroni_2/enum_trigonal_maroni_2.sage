import sys
import os 

current = os.path.dirname(os.path.realpath(__file__))
parent = os.path.dirname(current)
sys.path.append(parent)

load_attach_path(parent)

load('preamble.sage')

# Construct the sets of F_2_i-rational points for a specific (2,1)-hypersurface X_1
# in P^1 X P^2 for i = 1,2,3,4

F = GF(2)
P.<x0,x1,y0,y1,y2> = PolynomialRing(F, 5, order='lex')
gen1 = x0^2*y0 + x0*x1*y1 + x1^2*y2

S1 = [vector(t) for t in ProjectiveSpace(F, 1)]
S2 = [vector(t) for t in ProjectiveSpace(F, 2)]
for v in S1 + S2:
    v.set_immutable()
S0 = list(itertools.product(S1, S2))
S = [x for x in S0 if gen1(*x[0], *x[1]) == 0]

F4 = GF(4)
S14 = [vector(t) for t in ProjectiveSpace(F4, 1)]
S24 = [vector(t) for t in ProjectiveSpace(F4, 2)]
for v in S14 + S24:
    v.set_immutable()
S04 = list(itertools.product(S14, S24))
S4 = [x for x in S04 if gen1(*x[0], *x[1]) == 0]

F8 = GF(8)
S18 = [vector(t) for t in ProjectiveSpace(F8, 1)]
S28 = [vector(t) for t in ProjectiveSpace(F8, 2)]
for v in S18 + S28:
    v.set_immutable()
S08 = list(itertools.product(S18, S28))
S8 = [x for x in S08 if gen1(*x[0], *x[1]) == 0]

F16 = GF(16)
S116 = [vector(t) for t in ProjectiveSpace(F16, 1)]
S216 = [vector(t) for t in ProjectiveSpace(F16, 2)]
for v in S116 + S216:
    v.set_immutable()
S016 = list(itertools.product(S116, S216))
S16 = [x for x in S016 if gen1(*x[0], *x[1]) == 0]

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

# For each k-tuple of F_2-rational points of X_1, find (1,3)-surfaces X_2 such that X_1\cap X_2
# contains precisely the chosen set of F_2-points. We also enforce the desired point counts over F_2^i.


monos13 = [prod(x) for x in itertools.product([prod(y) for y in itertools.combinations_with_replacement([x0,x1],1)],
                                              [prod(y) for y in itertools.combinations_with_replacement([y0,y1,y2],3)])]

coords13 = {x: vector(F, (mu(*x[0], *x[1]) for mu in monos13)) for x in S}

#load("weil_poly_dim6.sage")
#load("weil_poly_utils.sage")

#pointcounts = []
#for pol in data: # data comes from weil_poly_dim6.sage 
#    pointcounts.append(tuple(point_count_from_weil_poly(pol.reverse(),4,q=2)))
    
#with open("pointcounts.sage", "w") as f:
#    f.write( "data = " +str(pointcounts))

load("pointcounts.sage")


perp = Matrix([coords13[x] for x in S])
perp.set_immutable()
tmp2 = set(t[:2] for t in data)
tmp3 = set(t[:3] for t in data)
tmp4 = set(t[:4] for t in data)
curves = defaultdict(list)

for s in range(0,11):
    for vecs in green_nodes(tree, s):
        target = vector(F, (0 if x in vecs else 1 for x in S))
        for v2 in solve_right_iterator(perp, target):
            gen2 = sum(v2[i]*monos13[i] for i in range(20))
            s2 = sum(1 for x in S4 if gen2(*x[0], *x[1]) == 0)
            if (s,s2) in tmp2:
                s3 = sum(1 for x in S8 if gen2(*x[0], *x[1]) == 0)
                if (s,s2,s3) in tmp3:
                    s4 = sum(1 for x in S16 if gen2(*x[0], *x[1]) == 0)
                    if (s,s2,s3,s4) in tmp4:
                        curves[(s,s2,s3,s4)].append((gen1, gen2))

lst = list(curves.keys())
for j in range(28):
    FILE_NAME = f'maroni_type2_unfiltered_batch_{j}' + '.txt'
    with open(FILE_NAME, 'w') as f:
        if j == 27:
            for key in lst[66*j:]:
                for gens in curves[key]:
                    tmp = []
                    for i in gens[1]:
                        tmp.append(monos13.index(i[1]))
                    f.write(str(tmp))
                    f.write('\n')
        else:
            for key in lst[66*j: 66*j+66]:
                for gens in curves[key]:
                    tmp = []
                    for i in gens[1]:
                        tmp.append(monos13.index(i[1]))
                    f.write(str(tmp))
                    f.write('\n')
    f.close()




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
