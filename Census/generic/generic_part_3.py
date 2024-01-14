# File splitting 
import os
import sys

def split_and_print(file_path, lines_per_file=10000):
    with open(file_path, 'r') as original_file:
        content = original_file.readlines()

    num_files = len(content) // lines_per_file + (len(content) % lines_per_file > 0)


    for i in range(num_files):
        output_file_path = f"./flats/unfiltered/flat1/flat1_unfiltered_{i + 1}.txt"

        with open(output_file_path, 'w') as output_file:
            # Print the first line of the original file to each new file
            if i != 0:
                output_file.write(content[0])

            # Write the next lines to the current output file
            start_idx = i * lines_per_file
            end_idx = min((i + 1) * lines_per_file, len(content))
            output_file.writelines(content[start_idx:end_idx])


# Replace 'input.txt' with the path to your text file
file_path = './flats/unfiltered/' + 'genus6_flat_1_unfiltered.txt'
split_and_print(file_path)
