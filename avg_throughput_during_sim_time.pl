# Type: perl avg_throughput_during_sim_time.pl <trace file> <flow id> <required node>
# perl avg_throughput_during_sim_time.pl out.tr 0 5
$infile = $ARGV[0];
$flow_id = $ARGV[1];
$tonode = $ARGV[2];
$start_time = 0;
$end_time = 0;
$sum = 0;

open(DATA, "<$infile") || die "Can't open $infile $!";

while (<DATA>) {
    @x = split(' ');
    # Kiểm tra nếu sự kiện tương ứng với việc nhận gói tin
    if ($x[0] eq 'r' && $x[7] == $flow_id && $x[3] eq $tonode) {
        if ($start_time == 0) {
            $start_time = $x[1];
        }
        $sum = $sum + $x[5];
        $end_time = $x[1];
    }
}

$throughput_byte = $sum / ($end_time - $start_time);
$throughput_kbit = $throughput_byte * 8 / 1024;

print STDOUT "start_time = $start_time\t";
print STDOUT "end_time = $end_time\n";
print STDOUT "Avg throughput (flow id = $flow_id; dst node = $tonode) = $throughput_kbit (Kbps)\n\n";

close DATA;
exit(0);
