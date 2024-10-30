#!/bin/sh

# 启动 OpenVPN
openvpn --config "$OVPN" --up /etc/openvpn/up.sh --down /etc/openvpn/down.sh

# 静默检测 tun0 接口
while true; do
    if ip a show tun0 > /dev/null 2>&1; then
        echo "tun0 interface is up."
        break  # 检测到 tun0 后，终止循环
    fi
    sleep 1
done

# 启动 sockd
sockd -f /etc/sockd/sockd.conf -D
