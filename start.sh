#!/bin/sh

# 启动 OpenVPN
openvpn --config "$OVPN" --up /etc/openvpn/up.sh --down /etc/openvpn/down.sh --daemon

# 静默检测 tun0 接口，确保它已经启动
while true; do
    if ip a show tun0 > /dev/null 2>&1; then
        echo "tun0 interface is up."
        break  # 检测到 tun0 后，终止循环
    fi
    sleep 1
done

# 启动 sockd
sockd -f /etc/sockd/sockd.conf

# 监控 tun0 接口状态
while true; do
    if ! ip a show tun0 > /dev/null 2>&1; then
        echo "tun0 interface is down. Restarting OpenVPN and sockd..."

        # 停止 sockd
        pkill -f sockd

        # 重新启动 OpenVPN
        openvpn --config "$OVPN" --up /etc/openvpn/up.sh --down /etc/openvpn/down.sh --daemon

        # 等待 tun0 接口重新连接
        while true; do
            if ip a show tun0 > /dev/null 2>&1; then
                echo "tun0 interface is back up."
                break
            fi
            sleep 1
        done

        # 重新启动 sockd
        sockd -f /etc/sockd/sockd.conf
    fi
    sleep 5  # 每隔5秒检测一次接口状态
done
