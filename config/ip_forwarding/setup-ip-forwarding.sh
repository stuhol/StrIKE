#!/bin/bash

# Enable persistant ip forwarding
sed -i '{ s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/ }' /etc/sysctl.conf 

# Read newly edited sysctl.conf
sysctl -p /etc/sysctl.conf > /dev/null 2>&1

# Add iptables masquerade script to if-up.d and run it
cp iptables-masquerade /etc/network/if-up.d/
/etc/network/if-up.d/iptables-masquerade
