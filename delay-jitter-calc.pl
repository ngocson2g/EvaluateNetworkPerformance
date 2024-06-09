#!/usr/bin/perl
# This is the file: delay-jitter-calc.pl
# type: perl delay-jitter-calc.pl <tracefile> <tcp/udp> <send_node> <receive_node>
# ==============================================================

$ARGC = 10;
$line_parameters = $#ARGV + 1;
if ($line_parameters < 4) {
    print STDOUT "This program needs exactly 4 parameters!\n";
    print STDOUT "You've just typed in: $line_parameters \n";
    print STDOUT "Please type again like this:\n";
    print STDOUT "perl delay-jitter-calc.pl tracefile-name tcp/udp send-node receive-node\n";
    print STDOUT "(For example: perl delay-jitter-calc.pl chapter5-sample1.tr tcp 0 5)\n\n";
    exit 0;
}

$infile = $ARGV[0];
$protocol = $ARGV[1];
$send_node = $ARGV[2];
$recv_node = $ARGV[3];

if ($protocol eq "udp") {
    $protocol = "cbr";
}

# --------------------------------------------------------------
# Search input trace file for send_time and receive_time
# of each received packet, store them for later use
# --------------------------------------------------------------
open (DATA, "<$infile") || die "Can't open $infile $!";
while (<DATA>) {
    @x = split(' ');
    # Column 0 is event
    if (($x[0] eq '+') && ($x[2] == $send_node) && ($x[4] eq $protocol)) {
        $seq = $x[10];
        if ($send_time[$seq] == 0) {
            $send_time[$seq] = $x[1];
            # printf("%3d %4.6f\n",$seq,$send_time[$seq]);
        }
    }
    if (($x[0] eq 'r') && ($x[3] == $recv_node) && ($x[4] eq $protocol)) {
        $seq = $x[10];
        $receiv_time[$seq] = $x[1];
    }
}

# --------------------------------------------------------------
# Calculate delay, mean delay, jitter and standard deviation of delay
# from send_time and receive_time of all packets, then print out
printf("Seq| Send_t  | Rec_t  | Delay   | Mean_Delay | Jitter\n");
printf("---------------------------------------------------\n");

$i = 0;
$temp = 0;
while ($i <= $seq) {
    if (($send_time[$i] != 0) && ($receiv_time[$i] != 0)) {
        $delay[$i] = $receiv_time[$i] - $send_time[$i];
        $temp = $temp + $delay[$i];
        $mean_delay = $temp / ($i + 1);
        $jitter = $delay[$i] - $mean_delay;
        #remove ‘#(*)’ from the following lines to output to the file for drawing graphs later
        # (*)printf("%3d %4.6f %4.6f %4.6f %4.6f %4.6f\n",$i,$send_time[$i],$receiv_time[$i],$delay[$i],$mean_delay,$jitter);
        printf("%3d %4.6f %4.6f %4.6f %4.6f %4.6f\n", $i, $send_time[$i], $receiv_time[$i], $delay[$i], $mean_delay, $jitter);
    }
    $i++;
}

$i = 0;
$s2 = 0;
while ($i < $seq) {
    $d = $delay[$i] - $mean_delay;
    $s2 = $s2 + $d * $d;
    $i++;
}

$dev_delay = sqrt($s2 / ($seq + 1));
# (**)quote the following 5 lines to output to the file to draw graphs
printf("---------------------------------------------------\n");
print STDOUT "Mean delay = $mean_delay\n";
print STDOUT "Standard deviation of delay = $dev_delay\n";
# =================================================================
close DATA;
exit(0);
