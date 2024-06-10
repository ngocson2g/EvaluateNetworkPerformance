perl throughput_vs_sim_time.pl out.tr 0 5 > out-tcp0.tr
perl throughput_vs_sim_time.pl out.tr 1 6 > out-tcp1.tr
perl throughput_vs_sim_time.pl out.tr 2 7 > out-tcp2.tr
perl throughput_vs_sim_time.pl out.tr 3 6 > out-cbr.tr

gnuplot
set title “Throughput_vs_sim_time of all Connections”
set xlabel “Simulation Time (s)”
set ylabel “Throughput(t) (kbps)”
Plot ‘out-tcp0.tr’ w lines, ‘out-tcp1.tr’ w lines, ‘out-tcp2.tr’ w lines, ‘out-cbr.tr’ w lines
