# 推荐
```
podman pull ghcr.io/science2468/openvpn-socks:latest
```
```
podman run --rm -d --name openvpn-socks --device=/dev/net/tun --cap-add=NET_ADMIN \
 -p 1080:1080 \
 -v /home/max/us-tcp:/etc/openvpn-socks \
 -e OVPN=/etc/openvpn-socks/yourconfig.tcp.ovpn \
 science2468/openvpn-socks
 ```
在命令行执行后，后台运行，直接关闭命令行依然能用；执行```podman stop openvpn-socks```容器就没有了。好处就是随时就能换config.ovpn
