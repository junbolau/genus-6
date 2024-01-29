from collections import defaultdict

f = open("data/pc_unfiltered.txt",'r').readlines()
R.<x,y> = PolynomialRing(GF(2))
d = defaultdict(list)
for line in f:
    lst = sage_eval(line,{'x':x,'y':y})
    d[tuple(lst[0])].append([lst[1]])
    
lst = list(d.keys())
for j in range(25):
    f = open('data/sorted_' + str(j) + '.txt','w+')
    for key in lst[134*j:134*j + 134]:
        for eqn in d[key]:
            tmp = [list(key),list(eqn)]
            f.write(str(tmp))
            f.write('\n')
    f.close()
