# Run this in parallel using this command:
# ls ./data_filtered/ | parallel -j27 "python3 file_mod.py {}"

import sys
import ast
from collections import defaultdict 


FILE_NAME = './data_filtered/' + sys.argv[1]
with open(FILE_NAME, 'r') as f:
    lines = f.read().split('\n')
    counts = defaultdict(list)
    for ele in lines[0:-1]:
        tmp = ast.literal_eval(ele)
        counts[tuple(tmp[0])].append(tmp[1])

    OUTPUT_FILE_NAME = './data_filtered_updated/' + sys.argv[1]
    with open(OUTPUT_FILE_NAME, 'w') as g:
        for ct in counts:
            for elem in counts[ct]:
                tmp = [list(ct), elem]
                g.write(str(tmp)+'\n')