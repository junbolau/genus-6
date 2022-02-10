import argparse
import os

load("preamble.sage")

parser = argparse.ArgumentParser()
parser.add_argument("F_2_pts", help="1,3,5,7 or 9")
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


F = GF(2) 
P.<x01,x02,x03,x04,x12,x13,x14,x23,x24,x34> = PolynomialRing(F, 10)
quads = (x01*x23 + x02*x13 + x03*x12,
         x01*x24 + x02*x14 + x04*x12,
         x01*x34 + x03*x14 + x04*x13,
         x02*x34 + x03*x24 + x04*x23,
         x12*x34 + x13*x24 + x14*x23)

with open("OUTPUT_FILE","w") as f:
    s = f.read()
    curves= sage_eval(s,locals = {'x01': x01,'x02': x02,'x03':x03,'x04':x04,'x12':x12,'x13':x13,'x14':x14,'x23':x23,'x24':x24,'x34':x34})
    f.close()
    
    
proj = magma.ProjectiveSpace(P)
curves = {s: [gens + quads for gens in curves[s]] for s in curves}
fin,failure = closeout_dict(curves, genus=6)

with open("ss_7.txt", "w") as f:
    f.write(str(fin))
    f.close()
    