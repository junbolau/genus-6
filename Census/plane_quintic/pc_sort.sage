from collections import defaultdict


curves = defaultdict(set)
R.<x0,x1,x2> = PolynomialRing(GF(2))
for i in range(25):
    f = open('data/cc_' + str(i) + ".txt","r").readlines()
    for l in f:
        lst = sage_eval(l,{'x0':x0,'x1':x1,'x2':x2})
        curves[tuple(lst[0])].add(lst[1][0])
        
k_lst = list(curves.keys())
for i in range(25):
    to_write = []
    f = open("data/sorted_" + str(i) + ".txt","w+")
    for k in k_lst[148*i:148*i + 148]:
        for eqn in curves[k]:
            f.write(str([list(k),[eqn]]))
            f.write('\n')
    f.close()
