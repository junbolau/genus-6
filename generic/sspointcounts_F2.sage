# Do point counting from F_2^2 to F_2^4

#Input:

#Outputs:
# curves = {(s1,: [gens]}

## TODO:


#! /usr/bin/env sage

import argparse
import logging
import os

load("preamble.sage")

parser = argparse.ArgumentParser()
parser.add_argument("F_2_pts", help="1,3,5,7 or 9")
parser.add_argument("F_2_pts_batch", help="0,1,2") # only 5_F16 has 2 batches
ARGS = parser.parse_args()


if ARGS.F_2_pts in {"1", "3", "5","7","9"}:
    F2pts = ARGS.F_2_pts
else:
    raise ValueError("F_2 points must be one of '1', '3', '5', '7' or '9'.")


try:
    os.mkdir("results")
except FileExistsError:
    pass

OUTPUT_FILE_PREFIX = "results/ss_{}".format(F2pts)
OUTPUT_FILE = OUTPUT_FILE_PREFIX + ".txt"
LOG_FILE = OUTPUT_FILE_PREFIX + ".log"
    
# Set up log file
logging.basicConfig(
    filename=LOG_FILE,
    encoding="utf-8",
    format="%(asctime)s %(levelname)s: %(message)s",
    level=logging.DEBUG
)

# Set up environment

F = GF(2)
P.<x01,x02,x03,x04,x12,x13,x14,x23,x24,x34> = PolynomialRing(F, 10)

quads = (x01*x23 + x02*x13 + x03*x12,
         x01*x24 + x02*x14 + x04*x12,
         x01*x34 + x03*x14 + x04*x13,
         x02*x34 + x03*x24 + x04*x23,
         x12*x34 + x13*x24 + x14*x23)
monos2 = [prod(x) for x in itertools.combinations_with_replacement(P.gens(), 2)]

def vecs_to_gens(vecs):
    return tuple(sum(P.gens()[i] * v[i] for i in range(10)) for v in vecs)
    
def redundancy(gens, F=F, P=P, monos2=monos2, quads=quads):
    return [vector(F, ((gen*y).coefficient(mu) for mu in monos2)) for gen in gens for y in P.gens()] + \
       [vector(F, (gen.coefficient(mu) for mu in monos2)) for gen in quads]
       
       
with open("genus6-flats.txt", "r") as f:
    s = f.read()
    l = sage_eval(s)
    l = [[vector(F, v) for v in vecs] for vecs in l]

coords = {}
for V in VectorSpace(F, 5).subspaces(2):
    M = V.matrix()
    M.set_immutable()
    coords[M] = vector(M.minors(2))
S = list(coords.keys())

coords2 = {}
V0 = VectorSpace(F, 10)
for x in V0:
    x.set_immutable()
    coords2[x] = vector(F, (mu(*x) for mu in monos2))

F4 = GF(4)
S4 = []
for V in VectorSpace(F4, 5).subspaces(2):
    M = V.matrix()
    v = vector(M.minors(2))
    i = min(j for j in range(10) if v[j])
    assert v[i] == 1
    v.set_immutable()
    S4.append(v)

with open("ss_pointcount.txt", "r") as f:
    s = f.read()
    pointcount = sage_eval(s)


# Main calculation

start_time = time.time()

curves = defaultdict(list)
for vecs in l:
    V1 = Matrix(vecs).row_space()
    V = Matrix(vecs).right_kernel()
    gens = vecs_to_gens(V1.basis())
    pts = [coords[x] for x in S if coords[x] in V]
    print(len(pts), [(s, len(curves[s])) for s in curves])
    for v in pts:
        v.set_immutable()
    W = VectorSpace(F, 55)
    W1 = W.quotient(redundancy(gens))
    perp = Matrix([coords2[x] for x in pts])
    for s in [F2pts]:
        for pts1 in itertools.combinations(pts, s):
            target = vector(F, (0 if x in pts1 else 1 for x in pts))
            for w in solve_right_iterator(perp, target, redundancy, gens):
                gens1 = sum(w[i]*monos2[i] for i in range(55))
                curves[(s,)].append(gens + (gens1,))


with open(OUTPUT_FILE, "w") as f:
    f.write(str(curves))
    f.close()
print([(sp,len(curves[sp])) for sp in curves.keys()])

end_time = time.time()

logging.info("Done. Computation took {} seconds in total.".format(round(end_time - start_time,3)))
