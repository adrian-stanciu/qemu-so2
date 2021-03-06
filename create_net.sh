#!/bin/bash

if test $# -ne 1; then
    echo "Usage: $0 <device>" 1>&2
    echo " <device> must be tap0 or tap1"
    exit 1
fi

device=$1

case "$device" in
    "tap0")
        addr=172.20.0.1/24
        ;;
    "tap1")
        addr=172.30.0.1/24
        ;;
    *)
        echo "Unknown device" 1>&2
        exit 1
        ;;
esac

# If device doesn't exist add device.
if ! /sbin/ip link show dev "$device" > /dev/null 2>&1; then
    sudo ip tuntap add mode tap user "$USER" dev "$device"
fi

# Reconfigure just to be sure (even if device exists).
sudo /sbin/ip address flush dev "$device"
sudo /sbin/ip link set dev "$device" down
sudo /sbin/ip address add "$addr" dev "$device"
sudo /sbin/ip link set dev "$device" up
