#!/bin/bash

# this script creates a GRE tunnel between our game-client
# and the cn201 node, and routes all traffic destined for the 
# CN subnet (10.10.0.0/16) through cn201
# 
# required because only cn201 is connected to the lab
# run this on game client (129.97.60.179)

sudo ip tunnel add gre1 mode gre remote 129.97.26.28 local 129.97.60.179 ttl 255
sudo ip addr add 10.200.0.1/30 dev gre1
sudo ip link set gre1 up
sudo ip route add 10.10.0.0/16 via 10.200.0.2 dev gre1

# this routes traffic destined for the openstack private network
# corresponding to our VM based deployment through the GRE tunnel
sudo ip route add 192.168.0.0/16 via 10.200.0.2 dev gre1
