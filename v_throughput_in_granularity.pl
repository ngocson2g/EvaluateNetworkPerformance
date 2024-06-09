# This is the file: v_throughput_in_granularity.pl
# type: perl v_throughput_in_granularity.pl <tracefile> <flow id> <required node> <granularity> > file
# This script comes from ...
# and modified by Assoc. Prof, Dr. Nguyen Dinh Viet
# Faculty of Technology, College of Engineering, VNU, Hanoi
# --------------------------------------------------------------

$infile = $ARGV[0];
$flow_id = $ARGV[1];
$tonode = $ARGV[2];
$granularity = $ARGV[3];
$start_time = 0;
$end_time = 0;
# We compute how many bytes were transmitted during the time interval
# specified by the granularity parameter in seconds
$sum = 0;
$clock = 0;

open (DATA, "<$infile") || die "Can't open $infile $!";

while (<DATA>) {
    @x = split(' ');
    if ($x[0] eq 'r' && $x[7] == $flow_id && $x[3] eq $tonode) {
        if ($start_time <= 0) {
            $start_time = $x[1];
            $clock = $start_time;
            # print STDOUT "Start_time = $start_time\n";
        }
        if ($x[1] - $clock < $granularity) {
            $sum = $sum + $x[5] * 8 / 1024;
        } else {
            $throughput = $sum / $granularity;
            print STDOUT "$clock $throughput\n";
            $clock += $granularity;
            $sum = $x[5] * 8 / 1024;
        }
    }
}

if ($sum > 0) {
    $throughput = $sum / $granularity;
    print STDOUT "$clock $throughput\n";
}

close DATA;
exit(0);
