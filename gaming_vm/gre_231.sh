#!/bin/bash
  
# this script creates a GRE tunnel between our game-client
# and the cn231 node, and routes all traffic destined for the 
# CN subnet (10.10.0.0/16) through cn231
# 
# required because only cn231 is connected to the lab
# run this on cn231

sudo ip tunnel add gre1 mode gre remote 129.97.60.179 local 129.97.26.252 ttl 255
sudo ip addr add 10.231.0.2/30 dev gre1
sudo ip link set gre1 up

# this is used to make sure all messages (RLS) know where to come back to
sudo iptables -t nat -A POSTROUTING -s 10.231.0.1 -j SNAT --to-source 10.10.0.65

# this is used to make sure RRC setup messages reach the gnb
sudo iptables -t nat -A PREROUTING -d 192.168.1.10 -j DNAT --to-destination 10.10.0.202
