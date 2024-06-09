import matplotlib.pyplot as plt

def parse_trace_file(file_path):
    time = []
    throughput = []
    start_time = 0

    with open(file_path, 'r') as file:
        for line in file:
            if line.startswith('+'):
                parts = line.split()
                current_time = float(parts[1])
                packet_size = int(parts[5])

                if start_time == 0:
                    start_time = current_time

                time.append(current_time - start_time)
                throughput.append(packet_size * 8)  # Convert bytes to bits

    return time, throughput

def plot_throughput(time, throughput):
    plt.figure(figsize=(10, 5))
    plt.plot(time, throughput, label='Throughput')
    plt.xlabel('Time (seconds)')
    plt.ylabel('Throughput (bps)')
    plt.title('Network Throughput Over Time')
    plt.legend()
    plt.grid(True)
    plt.show()

trace_file_path = 'out.tr'
time, throughput = parse_trace_file(trace_file_path)
plot_throughput(time, throughput)
