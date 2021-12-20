# configuration

First, we need connectivity between lab nodes and CN nodes. See section below.
This directory only contains config files for the UE; use single_upf config files on the VMs.
Note: VM setup uses ueransim v3.1.7 while kube setup uses v3.1.3.

# connect lab nodes to cn nodes

We want all traffic from lab machines to be routed through the GRE tunnel to cn201 which is bridged with the 10.10.0.0/16 subnet that most cn nodes are located on, e.g., cn115. Basically, we want something like this: client (129.97.60.79) -> GRE tunnel (10.0.0.1 -> 10.0.0.2) -> cn201 (129.97.26.28) -> bridge -> 10.10.0.35 -> cn115-nsm (10.10.0.15)

First, we need to setup a static route for all traffic destined for 10.10.0.0/16 subnet, i.e.,most cn machines to go through the gre tunnel. Here, `10.0.0.2` is the IP of the remote gre tunnel end.

    ip route add 10.10.0.0/16 via 10.0.0.2 dev gre1


Second, we need to setup snat iptables rule on cn201


    sudo iptables -t nat -A POSTROUTING -o brq75fb164e-63 -s 10.0.0.1 -j SNAT --to-source 10.10.0.35


Here, basically the idea is that we take the traffic coming though the gre tunnel destined for 10.10.0.0/16 subnet which exits out the bridged port, and do SNAT to change the source to the bridged interface instead of the tunnel interface. This means that cn nodes have a valid return address.

We also need to make some changes for the UE RLS and RRC commands to work with OpenStack floating IP addresses.

First, we need to send traffic destined for the 192.168.0.0/16 subnet throught the GRE tunnel as well.

    ip route add 10.10.0.0/16 via 10.0.0.2 dev gre1

Next, we need to set a DNAT rule at cn201, which changes the destination of the gNB to the floating IP address of the gNB. This is because the gNB internal address is sent in the RLS messages and cannot be changed.


# steam ports for remote play discovery
UDP ports 27031 and 27036 and TCP ports 27036 and 27037

# create GRE  tunnel for connection between game subnet and cn subnet
    sudo ip tunnel add gre1 mode gre remote 129.97.26.28 local 129.97.60.179 ttl 255
    sudo ip addr add 10.0.0.1/30 dev gre1
    sudo ip link set gre1 up
    sudo ip route add 10.10.0.0/16 via 10.0.0.2 dev gre1
    sudo ip route add 192.168.0.0/16 via 10.0.0.2 dev gre1

# RLS decode error
ueransim in containers is v3.1.3, while the VM based setup uses v3.1.7. This can lead to RLS decode error. 

# RRC connection does not succeed
the RRC setup messages contain the wrong IP. We need at DNAT rule at cn231 (or whatever node is being used as tunnel).
sudo iptables -t nat -A PREROUTING -d 192.168.1.10 -j DNAT --to-destination 10.10.0.202


# send game traffic via 5g network
sudo ip route add 129.97.168.30 dev uesimtun0

# isolating game traffic using network namespaces
See namespace scripts.

# Connecting game over LAN using steam
Launch steam with console argument
```
steam -console
```

Type in console to connect to remote server directly
```
connect_remote 129.97.168.30:27036
```
