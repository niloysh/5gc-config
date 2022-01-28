# add throughput and latency limit
tc qdisc add dev uesimtun0 root tbf root rate 2048kbit latency 50ms burst 1540 

qdisc: modify the scheduler (aka queuing discipline)
add: add a new rule
dev eth0: rules will be applied on device eth0
root: modify the outbound traffic scheduler (aka known as the egress qdisc)
netem: use the network emulator to emulate a WAN property
delay: the network property that is modified
200ms: introduce delay of 200 ms

# show tc
tc qdisc show

# delete
tc qdisc del dev uesimtun0 root

# add delay
tc qdisc add dev eth0 root netem delay 97ms
