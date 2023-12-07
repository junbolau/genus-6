# File rearranging
# Run this in parallel using this command:
# ls ./data_unfiltered/ | parallel -j50 "python3 file_mod.py {}"

import sys
import ast
import os
from collections import defaultdict 

"""
FILE_NAME = './data_unfiltered/' + sys.argv[1]
with open(FILE_NAME, 'r') as f:
    lines = f.read().split('\n')
    if len(lines) > 2:
        flat = lines[0]
        counts = defaultdict(list)
        for ele in lines[1:-1]:
            tmp = ast.literal_eval(ele)
            counts[tuple(tmp[0])].append(tmp[1])

        OUTPUT_FILE_NAME = './data_unfiltered_updated/' + sys.argv[1]
        with open(OUTPUT_FILE_NAME, 'w') as g:
            g.write(str(flat) + '\n')
            for ct in counts:
                for elem in counts[ct]:
                    tmp = [list(ct), elem]
                    g.write(str(tmp)+'\n')
"""

flat = []
def read_files_into_dictionary(directory_path):
    curves = defaultdict(list)

    # Check if the given path is a directory
    if not os.path.isdir(directory_path):
        print("Error: Input is not a directory.")
        return None

    # Iterate over each file in the directory
    for filename in os.listdir(directory_path):
        file_path = os.path.join(directory_path, filename)

        # Check if the current item is a file
        if os.path.isfile(file_path):
            with open(file_path, 'r') as file:
                # Read all lines from the file and store them in the dictionary
                lines = file.read().split('\n')
                global flat 
                flat = lines[0]
                if len(lines) > 2:
                    for ele in lines[1:-1]:
                        tmp = ast.literal_eval(ele)
                        curves[tuple(tmp[0])].append(tmp[1])

    return curves

directory_path = './data_unfiltered/' + sys.argv[1]
curves = read_files_into_dictionary(directory_path)

def write_dict_to_files(input_dict, output_directory, chunk_size=50):
    # Create the output directory if it doesn't exist
    os.makedirs(output_directory, exist_ok=True)

    # Split the dictionary into chunks of specified size
    chunks = [list(input_dict.keys())[i:i + chunk_size] for i in range(0, len(input_dict), chunk_size)]

    # Write each chunk to a separate file
    for i, chunk in enumerate(chunks):
        output_filename = os.path.join(output_directory, 'with_genus_' + str(sys.argv[1]) + f'_{i + 1}.txt')

        with open(output_filename, 'w') as output_file:
            output_file.write(str(flat) + '\n')
            for key in chunk:
                for elem in curves[key]:
                    tmp = [list(key), elem]
                    output_file.write(str(tmp)+'\n')

output_directory = './data_unfiltered_updated/' + sys.argv[1]
write_dict_to_files(curves, output_directory)