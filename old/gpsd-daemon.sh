#!/bin/sh

#nc -u 192.168.10.20 8500 < /dev/mhi_LOOPBACK

#using udp4-datagram as this survives cerbo gx reboots
socat -u /dev/mhi_LOOPBACK udp4-datagram:192.168.10.20:8500
