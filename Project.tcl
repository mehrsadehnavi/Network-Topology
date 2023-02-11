# Creating a new simulator object ns:
set ns [new Simulator]

# Creating a dynamic rout:
$ns rtproto DV

# Opening the tracing files:
set tracefile [open out.tr w]
$ns trace-all $tracefile

# Opening the animation files:
set namfile [open out.nam w]
$ns namtrace-all $namfile

$ns color 1 Blue
$ns color 2 Red
$ns color 3 Green

# Creating 10 nodes n0, n1, n2, n3, n4, n5, n6, n7, n8, n9:
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]

# Simplex-links:
$ns simplex-link $n4 $n5 300KB 100ms DropTail
$ns simplex-link $n5 $n4 300KB 100ms DropTail

# Orienting simplex links:
$ns simplex-link-op $n4 $n5 orient right
$ns simplex-link-op $n5 $n4 orient left

# Duplex-links:
$ns duplex-link $n0 $n4 10MB 2ms DropTail
$ns duplex-link $n1 $n4 10MB 2ms DropTail
$ns duplex-link $n2 $n4 10MB 2ms DropTail
$ns duplex-link $n3 $n4 10MB 2ms DropTail
$ns duplex-link $n5 $n6 500KB 40ms DropTail
$ns duplex-link $n6 $n7 500KB 40ms DropTail
$ns duplex-link $n7 $n8 500KB 40ms DropTail
$ns duplex-link $n8 $n9 500KB 40ms DropTail
$ns duplex-link $n9 $n5 500KB 40ms DropTail

# Orienting duplex links:
$ns duplex-link-op $n0 $n4 orient down
$ns duplex-link-op $n1 $n4 orient right-down
$ns duplex-link-op $n2 $n4 orient right-up
$ns duplex-link-op $n3 $n4 orient up
$ns duplex-link-op $n5 $n6 orient right-up
$ns duplex-link-op $n6 $n7 orient right-down
$ns duplex-link-op $n7 $n8 orient left-down
$ns duplex-link-op $n8 $n9 orient left
$ns duplex-link-op $n9 $n5 orient left-up

# Creating TCP connections:
set tcp19 [new Agent/TCP]

# Linking agents to nodes:
$ns attach-agent $n1 $tcp19

# Creating TCPsink connections:
set tcpsink19 [new Agent/TCPSink]

# Linking sinks to nodes:
$ns attach-agent $n9 $tcpsink19

# Setting the traffic to FTP and connecting it to TCP agents:
set ftp19 [new Application/FTP]

# Attaching ftp agents to tcp agents:
$ftp19 attach-agent $tcp19

# Connecting the source to the sink:
$ns connect $tcp19 $tcpsink19

# Starting the traffic at 1.0 seconds:
$ns at 1.0 "$ftp19 start"

# Crashing the link between n7 and n8 from 2.0-4.0 seconds:
$ns rtmodel-at 2.0 down $n7 $n8
$ns rtmodel-at 4.0 up $n7 $n8

# Calling the finish procedure at 4.0 seconds:
$ns at 4.0 "finish"

# Procedure finish{}
proc finish {} {
	global ns tracefile namfile
	exec nam out.nam & #execute the animation within the procedure
	exit 0
}

# Running the simulation:
$ns run
