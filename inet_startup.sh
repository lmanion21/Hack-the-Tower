#!/bin/bash

#Internet Startup Script#

#This script will run the iptables command for nextEPC and wireshark for packet capture
#Once Wireshark is up, you want to capture packets on the <pgwtun> interface

cd /home/cadet/nextEPC/nextepc/
iptables -t nat -A POSTROUTING -o wlp1s0 -j MASQUERADE
iptables -I INPUT -i pgwtun -j ACCEPT
wireshark
