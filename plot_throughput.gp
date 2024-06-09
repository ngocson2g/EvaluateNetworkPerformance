# plot_throughput.gp
set terminal pngcairo size 800,600 enhanced font 'Verdana,10'
set output 'throughput.png'
set title "Network Throughput Over Time"
set xlabel "Time (seconds)"
set ylabel "Throughput (bps)"
set grid
plot 'throughput.dat' using 1:2 with lines title 'Throughput'
