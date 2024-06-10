# type: perl avg_delay_during_sim_time.pl <trace file> <flow id> <source node> <dest node>
# perl avg_delay_during_sim_time.pl out.tr 0 0 5
$infile = $ARGV[0];
$flow = $ARGV[1];
$src = $ARGV[2];
$dst = $ARGV[3];

@send = (0..0);
@recv = (0..0);
$max_pktid = 0;
$num = 0;

open(DATA, "<$infile") || die "Can't open $infile $!";
while (<DATA>) {
    @x = split(' ');
    $event_ = $x[0];
    $time_ = $x[1];
    $flow_ = $x[7];
    $pkt_ = $x[11];

    if (($event_ eq "+" || $event_ eq "s") && $flow_ == $flow && $x[2] == $src && !$send[$pkt_]) {
        # Chỉ tính lần gửi đầu tiên của gói tin, không tính các lần gửi lại
        $send[$pkt_] = $time_;
        $max_pktid = $pkt_ if ($max_pktid < $pkt_);
    }

    if ($event_ eq "r" && $flow_ == $flow && $x[3] == $dst) {
        $recv[$pkt_] = $time_;
        $num++;
    }
}
close DATA;

# Tính tổng thời gian trễ $delay rồi tính thời gian trễ trung bình của các gói tin $avg_delay
$delay = 0;
for ($count = 0; $count <= $max_pktid; $count++) {
    if ($send[$count] && $recv[$count]) {
        $delay += $recv[$count] - $send[$count];
    }
}

$avg_delay = $delay / $num;
print STDOUT "Avg delay(flow id = $flow; src node = $src; dst node = $dst) = $avg_delay(s)\n";
exit(0);
