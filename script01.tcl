# Initialize the NS simulator
set ns [new Simulator]

$ns color 0 Red
$ns color 1 Green
$ns color 2 Blue
$ns color 3 Yellow

# Set up trace files 
set nf [open out.nam w]
$ns namtrace-all $nf
set tf [open out.tr w]
$ns trace-all $tf

# Define a procedure to finish the simulation
proc finish {} {
    global ns nf tf
    $ns flush-trace
    close $nf
    close $tf
    exec nam out.nam &
    exit 0
}

# Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

# Establish links between nodes with specified bandwidth and delay
$ns duplex-link $n0 $n3 10Mb 5ms DropTail
$ns duplex-link $n4 $n5 10Mb 5ms DropTail

$ns duplex-link $n1 $n3 10Mb 5ms DropTail
$ns duplex-link $n4 $n6 10Mb 5ms DropTail

$ns duplex-link $n2 $n3 10Mb 5ms DropTail
$ns duplex-link $n4 $n7 10Mb 5ms DropTail

$ns duplex-link $n3 $n4 1.5Mb 15ms DropTail

# Set orientation and position in visualization
$ns duplex-link-op $n0 $n3 orient down
$ns duplex-link-op $n4 $n5 orient up
$ns duplex-link-op $n1 $n3 orient right
$ns duplex-link-op $n4 $n6 orient right
$ns duplex-link-op $n2 $n3 orient up
$ns duplex-link-op $n4 $n7 orient down
$ns duplex-link-op $n3 $n4 orient right

# Set queue size of specific link
$ns queue-limit $n3 $n4 50

# Configure TCP and FTP
#tcp0 - ftp0 - sink0 
set tcp0 [new Agent/TCP]
$tcp0 set window_ 32
$ns attach-agent $n0 $tcp0
$tcp0 set fid_ 0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n5 $sink0
$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 0.4 "$ftp0 start"
$ns at 10.4 "$ftp0 stop"

#tcp1 - ftp1 - sink1
set tcp1 [new Agent/TCP]
$tcp1 set window_ 64
$ns attach-agent $n1 $tcp1
$tcp1 set fid_ 1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n6 $sink1
$ns connect $tcp1 $sink1

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns at 0.6 "$ftp1 start"
$ns at 10.6 "$ftp1 stop"

#tcp2 - ftp2 - sink2
set tcp2 [new Agent/TCP]
$tcp2 set window_ 16
$ns attach-agent $n2 $tcp2
$tcp2 set fid_ 2

set sink2 [new Agent/TCPSink]
$ns attach-agent $n7 $sink2
$ns connect $tcp2 $sink2

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ns at 0.8 "$ftp2 start"
$ns at 10.8 "$ftp2 stop"

# Configure UDP and CBR
#udp-cbr-null
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
$udp set fid_ 2

set null [new Agent/Null]
$ns attach-agent $n6 $null
$ns connect $udp $null

set cbr [new Application/Traffic/CBR]
$cbr set rate_ 1.5Mb
$cbr attach-agent $udp
$ns at 7.0 "$cbr start"
$ns at 8.0 "$cbr stop"

# Finish the simulation
$ns at 10.9 "finish"



# Run the simulation
$ns run

