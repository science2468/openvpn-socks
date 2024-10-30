#!/bin/sh

openvpn --config "$OVPN" --up /etc/openvpn/up.sh --down /etc/openvpn/down.sh --daemon

while ! ip a show tun0; do
    sleep 1
done

sockd -f /etc/sockd/sockd.conf -D
