## Common preamble for genus 5, 6, and 7 enumerations

# Import packages

import itertools, pandas, time
from collections import defaultdict

# Load other Sage files

load("../Shared/orbits.sage") # Group orbits
load("../Shared/linalg.sage") # Auxiliary linear algebra
load("../Shared/cyclic_covers.sage") # Cyclic covers of function fields
load("../Shared/weil_poly_utils.sage") # Utility functions for Weil polynomials
load("../Shared/ss_pointcount.sage") ##supersingular curves point counts

        
# Record the current time.

timestamp = time.time()

def report_time():
    seconds = ceil(time.time() - timestamp) 
    if seconds < 300:
        print("Total time: {} seconds".format(seconds))
    else:
        minutes = ceil(seconds//60)
        print("Total time: {} minutes".format(minutes))


def closeout(curves=None, genus=None):
    if not curves:
        print("No curves found in this case!")
        report_time()
        return
    # Pick out cases with matching point counts.
    l = []
    Q.<T> = QQ[]
    failure = []

    for s in curves:
        print(s)
        for gens in curves[s]:
            try:
                X = magma.ProjectiveSpace(P)
                Y = X.Scheme(gens)
                if Y.Dimension() > 1 or str(Y.IsIrreducible()) == "false" or str(Y.IsReduced()) == "false":
                    continue
                C = Y.Curve()
                F0 = C.FunctionField()
                F = F0.AlgorithmicFunctionField()
                g = Integer(F.Genus())
                if genus and (genus != g):
                    continue
                ct = tuple(Integer(F.NumberOfPlacesOfDegreeOneECF(i)) for i in range(1, g+1))
                assert ct[:len(s)] == s
                if ct in pointcount:
                    l.append(F)
            except:
                failure.append((s,gens))
                
    print("Number of curves found: {}".format(len(l)))
    # Identify distinct isomorphism classes.
    l2 = isomorphism_class_reps(l)
    print("Number of isomorphism classes found: {}".format(len(l2)))
    report_time()
    return l2,failure