# 使用Alpine作为基础镜像
FROM alpine:latest

# 安装OpenVPN和Dante（SOCKS服务器）
RUN apk update && \
    apk add --no-cache openvpn dante-server

# 复制OpenVPN配置文件和脚本到容器中
# 复制Dante SOCKS服务器配置文件和启动脚本
COPY sockd.conf /etc/sockd/sockd.conf
COPY start.sh /
COPY update-resolv-conf /etc/openvpn/update-resolv-conf

# 为脚本添加执行权限
RUN chmod +x /etc/openvpn/update-resolv-conf
RUN chmod +x /start.sh

# 启动脚本，启动OpenVPN和Dante SOCKS服务器
ENTRYPOINT ["/start.sh"]
