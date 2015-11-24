#!/bin/bash

ovs-vsctl add-br br0
ovs-vsctl show

ovs-vsctl add-port br0 eth1
ifconfig eth1 0.0.0.0

#dhclient br0

#ip tuntap add mode tap vport1
#ip tuntap add mode tap vport2
#ifconfig vport1 up
#ifconfig vport2 up

#ovs-vsctl add-port br0 vport1
#ovs-vsctl add-port br0 vport2

# add the namespaces
ip netns add ns1
#### PORT 1 https://github.com/dave-tucker/container-connection-comparison/blob/master/ovs-veth.sh
# create a port pair
ip link add tap1 type veth peer name ovs-tap1
# attach one side to ovs
ovs-vsctl add-port br0 ovs-tap1

# To show the links
# ip link list
# attach the other side to namespace
ip link set tap1 netns ns1
# Chek again, and inspect that teh tap1 disappeared
# ip link list

# set the ports to up
ip netns exec ns1 ip link set dev lo up
ip netns exec ns1 ip link set dev tap1 up
ip link set dev ovs-tap1 up
#
ip netns exec ns1 dhclient tap1

ip netns exec ns1 ifconfig

ovs-vsctl show
