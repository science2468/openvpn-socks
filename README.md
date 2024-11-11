# 推荐
```
podman create --name openvpn-socks --device=/dev/net/tun --cap-add=NET_ADMIN \
 -p 1080:1080 \
 -v /home/max/ustcp:/etc/openvpn-socks \
 -e OVPN=/etc/openvpn-socks/yourconfig.tcp.ovpn \
 ghcr.io/science2468/openvpn-socks
 ```
```
mkdir -p .config/systemd/user/
```
```
podman generate systemd --name openvpn-socks > ~/.config/systemd/user/container-openvpn-socks.service
```
```
systemctl --user daemon-reload
```
```
systemctl --user enable container-openvpn-socks.service
```
```
systemctl --user start container-openvpn-socks.service
```
```
loginctl enable-linger <username>
```
`<username>` 是非root用户登录系统的当前用户名称（也就是非root用户）。具体请看[教程](https://www.cnblogs.com/newtonsky/p/15491806.html)，再看[Redhat的podman文档](https://docs.redhat.com/zh_hans/documentation/red_hat_enterprise_linux/9/html-single/building_running_and_managing_containers/index?extIdCarryOver=true&sc_cid=701f2000001OH6pAAG#proc_enabling-systemd-services_assembly_porting-containers-to-systemd-using-podman)
重新设置
```
systemctl --user stop container-openvpn-socks.service
```
```
systemctl --user disable container-openvpn-socks.service
```
