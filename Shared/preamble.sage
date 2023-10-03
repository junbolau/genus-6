## Common preamble for genus 5, 6, and 7 enumerations

# Import packages

import itertools, pandas, time
from collections import defaultdict

# Load other Sage files

load("orbits.sage") # Group orbits
load("linalg.sage") # Auxiliary linear algebra
load("Shared/cyclic_covers.sage") # Cyclic covers of function fields
load("Shared/weil_poly_utils.sage") # Utility functions for Weil polynomials

# Record the current time.

# Declare a function to close out a given notebook.
# The input is assumed to be a dictionary `curves` indexed by tuples of positive integers.
# The value `curves[s]` is assumed to be a list of tuples of generators of subschemes of the Magma projective scheme
# `X` (if `X` is specified) or Magma function fields (if `X` is omitted).
# If `genus` is specified, verify that the curves all have the specified genus.

G = GL(3,2).as_matrix_group()

def PGLaction(g,f):
    return f(g[0,0]*x0 + g[0,1]*x1 + g[0,2]*x2, g[1,0]*x0 + g[1,1]*x1 + g[1,2]*x2, g[2,0]*x0 + g[2,1]*x1 + g[2,2]*x2)


def closeout_1(curves=None, X=None, genus=None, write_filename = None, i = 0):
    if not curves:
        print("No curves found in this case!")
        report_time()
        return
    l = []
    error_lst = []
    Q.<T> = QQ[]
    
    i = 0
    
    tmp = list(curves.keys())
    
    for s in tmp:
        print(s)
        tmp2 = list(curves[s]):
        for gens in tmp2:
            if not X: # In this case, assume gens is already a function field.
                F = gens
            else:
                Y = X.Scheme(gens)
                # Only keep Y if it is integral of dimension 1.
                if Y.Dimension() > 1 or str(Y.IsIrreducible()) == "false" or str(Y.IsReduced()) == "false":
                    continue
                C = Y.Curve()
                F0 = C.FunctionField()
                # Convert F0 into Magma's preferred internal representation.
                F = F0.AlgorithmicFunctionField()

            ct = tuple(Integer(F.NumberOfPlacesOfDegreeOneECF(i)) for i in range(1, 6+1))
            # Cross-check the point counts we already computed.
            
            if not ct[:len(s)] == s:
                error_lst.append([gens,s,ct[:len(s)]])    
                for g in G:
                    try:
                        curves[s].remove(PGLaction(matrix(g),gens))
                    except:
                        continue
                    
                i+=1
            if ct in data:
                l.append(gens)
                curves[s].remove(gens)
                i +=1
                
            if i % 7000 == 0:
                with open(write_filename + "_"+ str(i) + ".sage", "w") as f:
                    f.write("pregenus_"+ str(i) + "=" + str(l))
                f.close()
    
                with open("error_lst_quintic" + "_" + str(i)+ ".sage", "w") as f:
                    f.write("error_lst_" + str(i) + "=" + str(error_lst))
                f.close()
                
                with open("curves_unfiltered_quintic.sage", "w") as f:
                    f.write("curves =" + str(curves))
                f.close()
                
                l = []
                error_lst = []
                
                
                
        del curves[s]
        
        if curves == {}:
            print(len(error_lst))
            with open(write_filename + "_"+ str(i) + ".sage", "w") as f:
                f.write("pregenus_"+ str(i) + "=" + str(l))
            f.close()

            with open("error_lst_quintic" + "_" + str(i)+ ".sage", "w") as f:
                f.write("error_lst_" + str(i) + "=" + str(error_lst))
            f.close()

            return "all done!"
    
            
def closeout_2(fields=None, X=None, genus=None, write_filename=None):
    report_time()
    final = []
    for F in fields:
        g = Integer(F.Genus())
        if g == genus:
            final.append(F)
            
    print("Number of curves found: {}".format(len(final)))
    # Identify distinct isomorphism classes.
    l2 = isomorphism_class_reps(final)
    print("Number of isomorphism classes found: {}".format(len(l2)))

    with open(write_filename + ".txt", "w") as f:
        f.write(str(l2))
    f.close()
    # Announce that we're done, and report the timing.
    print("All curves included!")
    report_time()