import re
from collections import defaultdict

curves = []
file_keys = ["hyperelliptic", "plane_quintic", "bielliptic", "trigonal_maroni_0", "trigonal_maroni_2", "generic"]
rx = re.compile(r"\[\[(.*)\],'\<(.*), (.*)\>',(.*)\]\n$")
P.<x,y> = GF(2)[]
for stratum in file_keys:
    with open("Census/{}/data_{}.txt".format(stratum, stratum)) as f:
        for str in f:
            m = rx.match(str)
            counts, isom_order, isom_type, eqn = m.group(1,2,3,4)
            counts = tuple(eval(counts))
            isom_order = int(isom_order)
            isom_type = int(isom_type)
            eqn = sage_eval(eqn, locals={'x':x,'y':y})
            curves.append((counts, isom_order, isom_type, stratum, eqn))

# Sort curves by their point counts.
curves_by_zeta = defaultdict(list)
for (counts, isom_order, isom_type, stratum, eqn) in curves:
    curves_by_zeta[counts].append((isom_order, isom_type, stratum, eqn))

