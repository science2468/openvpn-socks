# 使用Alpine作为基础镜像
FROM alpine:latest

# 安装OpenVPN和Dante（SOCKS服务器）
RUN apk update && \
    apk add --no-cache openvpn dante-server

# 创建OpenVPN配置目录
RUN mkdir -p /etc/openvpn

# 复制OpenVPN配置文件到容器中
COPY client.ovpn /etc/openvpn/client.ovpn

# 复制update-resolv-conf脚本到容器中
COPY update-resolv-conf /etc/openvpn/update-resolv-conf

# 为update-resolv-conf脚本添加执行权限
RUN chmod +x /etc/openvpn/update-resolv-conf

# 配置Dante SOCKS服务器
RUN echo "
logoutput: stderr
internal: 0.0.0.0 port = 1080  # 在所有接口上监听代理请求
external: tun0                # 使用VPN接口
method: username none
client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: error
}
socksmethod: none
" > /etc/sockd.conf

# 启动脚本，启动OpenVPN和Dante SOCKS服务器
CMD openvpn --config /etc/openvpn/client.ovpn & sockd -f /etc/sockd.conf -N
