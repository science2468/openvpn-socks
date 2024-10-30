# 使用Alpine作为基础镜像
FROM alpine:latest

# 安装OpenVPN和Dante（SOCKS服务器）
RUN apk update && \
    apk add --no-cache openvpn dante-server

# 复制update-resolv-conf脚本到容器中
COPY update-resolv-conf /etc/openvpn/update-resolv-conf

# 配置Dante SOCKS服务器
RUN cat <<EOF > /etc/sockd.conf
logoutput: stderr
internal: 0.0.0.0 port = 1080  # 在所有接口上监听代理请求
external: tun0                # 使用VPN接口
method: username none
client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: error
}
socksmethod: none
EOF

# 启动脚本，启动OpenVPN和Dante SOCKS服务器
CMD openvpn --config /etc/openvpn/client.ovpn & sockd -f /etc/sockd.conf -N

