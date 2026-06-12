# this file is to reduce size of measurements.csv file in order to plot data much faster
import os

input_path = os.getcwd()
output_path = input_path.replace('pbg data', 'sampled pbg data')
os.makedirs(output_path, exist_ok=True)
output_file = open(f"{output_path}\\sampled_measurements.csv", 'w')
input_file = open("measurements.csv", 'r')
lines = input_file.readlines()
length = len(lines)
sampled_lines = [lines[0], lines[1]] + [lines[i*100] for i in range(1, length) if i*100<length]
output_file.writelines(sampled_lines)
input_file.close()
output_file.close()