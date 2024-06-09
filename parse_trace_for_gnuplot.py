# parse_trace_for_gnuplot.py
import re

def parse_trace_file(file_path, output_path):
    with open(file_path, 'r') as trace_file, open(output_path, 'w') as out_file:
        start_time = None
        for line in trace_file:
            if line.startswith('+'):
                parts = re.split(r'\s+', line)
                time = float(parts[1])
                pkt_size = int(parts[5])
                if start_time is None:
                    start_time = time
                elapsed_time = time - start_time
                throughput = pkt_size * 8  # Convert bytes to bits
                out_file.write(f"{elapsed_time} {throughput}\n")

trace_file_path = 'out.tr'
output_data_path = 'throughput.dat'
parse_trace_file(trace_file_path, output_data_path)
