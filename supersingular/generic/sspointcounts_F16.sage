# Do point counting from F_2^2 to F_2^4

#Input:
# curves = {(s1,): [gens]}

#Outputs:
# curves = {(s1,s2,s3,s4): [gens]}

## TODO:
## sometimes returns nonreduced schemes (magma step)
## ~L115-119: sometimes returns 0 in gens 
## computation may end early if no matching point count: error coming from minlen


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
    
if ARGS.F_2_pts_batch in {"0","1", "2"}:
    batch = ARGS.F_2_pts_batch
else:
    raise ValueError("Batch must be one of '0', '1', '2'.")

try:
    os.mkdir("results")
except FileExistsError:
    pass

if F2pts == "5":
    OUTPUT_FILE_PREFIX = "results/ss_{}_{}".format(F2pts,batch)  ###########################change file name
    OUTPUT_FILE = OUTPUT_FILE_PREFIX + ".txt"
    LOG_FILE = OUTPUT_FILE_PREFIX + ".log"
else:
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


#Read from existing file, update file every WRITE_FREQ instances
with open(OUTPUT_FILE, "r") as f:
    s = f.read()
    curves = sage_eval(s,locals = {'x01': x01,'x02': x02,'x03':x03,'x04':x04,'x12':x12,'x13':x13,'x14':x14,'x23':x23,'x24':x24,'x34':x34})

write_counter = 0
WRITE_FREQ = 15000

start_time = time.time()
    
    
#F_4 points
minlen = min([len(key) for key in curves])

if minlen == 1:
    tmp = [s for s in curves if len(s) == 1]
    tmp2 = set(t[:2] for t in pointcount)
    for (s1,) in tmp:
        gens1 = 0
        while curves[(s1,)]:
            gens = curves[(s1,)].pop(0)
            if gens1 != gens[:-1]:
                gens1 = gens[:-1]
                pts2 = [xk for xk in S4 if all(gen(*xk) == 0 for gen in gens1)]

            s2 = sum(1 for xk in pts2 if gens[-1](*xk) == 0)
            if (s1, s2) in tmp2:
                try:
                    curves[(s1,s2)].append(gens)
                except:
                    curves[(s1,s2)] = [gens]
                
            write_counter += 1
            if write_counter > WRITE_FREQ:
                with open(OUTPUT_FILE,"w") as f:
                    f.write(str(curves))
                    f.close()
                print([(sp,len(curves[sp])) for sp in curves.keys()])
                write_counter = 0
                
        logging.info("Done with {}".format((s1,)))
        del curves[(s1,)]
        
        try:
            minlen = min([len(key) for key in curves])
        except:
            print("No supersingular curves from point count.")
            break


with open(OUTPUT_FILE,"w") as f:
    f.write(str(curves))
    f.close()
print([(sp,len(curves[sp])) for sp in curves.keys()])


#F_8 and F_16 calculations
while minlen < 4 and minlen != 0:
    tmp = [s for s in curves if len(s) == minlen]
    tmp2 = set(t[:minlen+1] for t in pointcount)
    for s in tmp:
        while curves[s]:
            gens = curves[s].pop(0)
            i = count_by_ideal(gens, minlen+1)
            s1 = s + (i,)
            if s1 in tmp2:
                try:
                    curves[s1].append(gens)
                except:
                    curves[s1] = [gens]
                
            write_counter += 1
            if write_counter > WRITE_FREQ:
                with open(OUTPUT_FILE,"w") as f:
                    f.write(str(curves))
                    f.close()
                print([(sp,len(curves[sp])) for sp in curves.keys()])
                write_counter = 0
                
        logging.info("Done with {}".format(s))
        del curves[s]
        
        try:
            minlen = min([len(key) for key in curves])
        except:
            print("No supersingular curves from point count.")
            break
            

with open(OUTPUT_FILE,"w") as f:
    f.write(str(curves))
    f.close()
print([(sp,len(curves[sp])) for sp in curves.keys()])
    
end_time = time.time()

logging.info("Done. Computation took {} seconds in total.".format(round(end_time - start_time,3)))
