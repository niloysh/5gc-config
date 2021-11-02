#!/bin/bash

# this script creates a network namespace
# and forces all traffic from that namespace
# to go though the uesimtun0 tunnel interface

# create namespace and connect veth pair
# bring up the interfaces
ip netns add gamespace
ip link add veth1 type veth peer name veth2
ip link set veth2 netns gamespace
ip addr add 10.0.3.1/24 dev veth1
ip netns exec gamespace ip addr add 10.0.3.2/24 dev veth2
ip link set veth1 up
ip netns exec gamespace ip link set veth2 up

# setup iptables rules to forward anything coming out of namespace
# to uesimtun0 created by UERANSIM
iptables -A FORWARD -o uesimtun0 -i veth1 -j ACCEPT
iptables -A FORWARD -i uesimtun0 -o veth1 -j ACCEPT

# masquerade (snat) so that return traffic has somewhere to go
iptables -t nat -A POSTROUTING -s 10.0.3.2/24 -o uesimtun0 -j MASQUERADE

# set default route for traffic from namespace to use 
# the veth interface in root namespace
ip netns exec gamespace ip route add default via 10.0.3.1

# masquerade traffic going to GRE tunnel for cn201
# traffic bound for cn subnet (10.10.0.0/16) is being re-routed
# through the GRE tunnel, so we need this rule
iptables -t nat -A POSTROUTING -s 10.0.3.2/24 -o gre1 -j MASQUERADE

# create resolv.conf for namespace for dns resolution
mkdir -p /etc/netns/gamespace
FILE="/etc/netns/gamespace/resolv.conf"
touch $FILE
cat << EOF > $FILE
nameserver 172.19.32.5
nameserver 172.19.32.6
search cs.uwaterloo.ca uwaterloo.ca
EOF

# restart network manager for resolv.conf to take affect
service network-manager restart

# create routing policies
# echo 200 gamespace >> /etc/iproute2/rt_tables # if not exists, uncomment
ip route add default dev uesimtun0 table rt_gamespace
ip rule add from 10.0.3.2/24 table rt_gamespace
