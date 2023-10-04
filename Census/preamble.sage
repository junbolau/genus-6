## Common preamble for genus 5, 6, and 7 enumerations

# Import packages

import itertools, pandas, time
from collections import defaultdict

# Load other Sage files

load_attach_path('~/genus-6/Shared')

load("orbits.sage") # Group orbits
load("linalg.sage") # Auxiliary linear algebra
load("cyclic_covers.sage") # Cyclic covers of function fields

# Record the current time.
timestamp = time.time()

# Declare a function to close out a given notebook.
# The input is assumed to be a dictionary `curves` indexed by tuples of positive integers.
# The value `curves[s]` is assumed to be a list of tuples of generators of subschemes of the Magma projective scheme
# `X` (if `X` is specified) or Magma function fields (if `X` is omitted).
# If `genus` is specified, verify that the curves all have the specified genus.

def report_time():
    seconds = ceil(time.time() - timestamp) 
    if seconds < 300:
        print("Total time: {} seconds".format(seconds))
    else:
        minutes = ceil(seconds//60)
        print("Total time: {} minutes ({} seconds)".format(minutes,seconds))

def closeout(genus, curves=None, X=None):
    if not curves:
        print("No curves found in this case!")
        report_time()
        return

    l = []
    Q.<T> = QQ[]
    counter = 0
#    for s in curves:
        #for gens in curves[s]:
    for gens in curves:
            if not X: # In this case, assume gens is already a function field.
                F = gens
            else:
                Y = X.Scheme(gens)
                # Only keep Y if it is integral of dimension 1.
                if Y.Dimension() > 1 or str(Y.IsIrreducible()) == "false" or str(Y.IsReduced()) == "false":
                    continue
                C = Y.Curve()
                #Y.IsCurve() 
                F0 = C.FunctionField()
                # Convert F0 into Magma's preferred internal representation.
                F = F0.AlgorithmicFunctionField()
            #g = Integer(F0.Genus())
            #if genus and (genus != g):
                #continue
            l.append(F)
            
    print("Number of curves found: {}".format(len(l)))
    # Identify distinct isomorphism classes.
    l2 = isomorphism_class_reps(l, genus=6)
    print("Number of isomorphism classes found: {}".format(len(l2)))
    
    # Announce that we're done, and report the timing.
    #print("All curves recorded!")
    report_time()
    #return l2, failure
    return l2
