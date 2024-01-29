import os
import sys
import ast

def count_lines_in_file(file_path):
    with open(file_path, 'r') as file:
        lines = file.read().split('\n')
        nonstacky_count = 0
        stacky_count = 0
        error_count = 0

        for line in lines[:-1]: 
            nonstacky_count += 1
            tmp = ast.literal_eval(line)
            if 'error' in tmp:
                error_count += 1
            else: 
                stacky_count += 1/Integer(tmp[1])
        return [nonstacky_count, stacky_count, error_count]

def sum_lines_in_directory(directory_path):
    total_lines = [0, 0, 0]

    # Iterate through all files in the directory
    for (dirname, _, filenames) in os.walk(directory_path):
        for filename in filenames:
            file_path = os.path.join(dirname, filename)

        # Check if the file is a text file
            if os.path.isfile(file_path) and filename.endswith('.txt') and 'problematic' not in filename:
                counts = count_lines_in_file(file_path)
                total_lines[0] += counts[0]
                total_lines[1] += counts[1]
                total_lines[2] += counts[2]

    return total_lines

# Replace 'your_directory_path' with the path to your directory
directory_path = sys.argv[1]
func_path = directory_path.strip('sorted_data')
total_lines = sum_lines_in_directory(directory_path)

print(f'Total number of lines in all text files in {directory_path}: {total_lines}')
