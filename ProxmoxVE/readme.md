# 说明  
在docker里头跑单机Proxmox VE  
主要是给没kvm管理器但又有kvm的机器用  
可以部署在群辉之类的地方
## 仓库地址  
### github
https://github.com/GreenDamTan/DockerFile/tree/dev/ProxmoxVE  
### docker hub
https://hub.docker.com/r/makedie/proxmox_ve
# 命令行  
以下是最小的部署命令行，如果你需要更复杂的功能可以参考yml  
这个[your_ip]你要换成你自己访问PVE的IP  
比如说`--add-host pve:192.168.1.2`  
```shell
docker run -idt \
--network host \
--privileged \
--name pve \
--add-host pve:[your_ip] \
--hostname pve \
makedie/proxmox_ve:8.3.2
```  
这个版本号你想用什么版本自己换  
https://hub.docker.com/repository/docker/makedie/proxmox_ve/tags

# 特殊行为说明
## ovs相关
若将宿主机的/var/run/openvswitch挂载入容器/host/var/run/openvswitch  
```log
    volumes:
      - /var/run/openvswitch:/host/var/run/openvswitch
```
且宿主机存在名称带ovs字样的网桥，可自动进行部分ovs-bridge配置

# 非一致性改动说明
因为docker容器与在裸金属上运行是有区别的  
因此做出了一些优化修改，这些修改可能造成与原版ProxmoxVE行为不一致  
一般地开通虚拟机、vGPU、直通硬件等功能是可以正常工作的  
集群PVE运行未经过验证，改动有可能破坏了集群功能  
以下是明确未支持的功能：  
LXC功能未被支持  
防火墙功能未被支持  
其余功能需要自行判断
## apt安装行为更改
为缩减docker镜像大小  
本容器镜像的apt不会默认安装推荐软件包与建议软件包  
```
APT::Install-Recommends "0";
APT::Install-Suggests "0";
```
## 服务实例数
以下的修改将max_workers调整为1  
用以改善小内存设备的使用体验  
原版的ProxmoxVE默认值为3  
```dockerfile
#reduce pveproxy pvedaemon workers
#https://github.com/proxmox/pve-manager/blob/c1689ccb1065a83be900bca61c2a56314126f4ea/PVE/Service/pvedaemon.pm#L18
#https://github.com/proxmox/pve-manager/blob/c1689ccb1065a83be900bca61c2a56314126f4ea/PVE/Service/pveproxy.pm#L32
RUN sed "s/max_workers => 3/max_workers => 1/g" \
    -i /usr/share/perl5/PVE/Service/pveproxy.pm \
    -i /usr/share/perl5/PVE/Service/pvedaemon.pm
```  
## mock软件包
以下的几个软件包，因在docker内实际无法工作  
因此采取了mock的方式创建了假软件包  
这些软件包的行为必然与原版ProxmoxVE行为不一致  
```log
ifupdown2
ifenslave
proxmox-kernel-helper
proxmox-default-kernel
```  
## 服务禁用  
在dockerPVE中，以下的服务是被禁用的  
服务未被删除，如有需要可以自行恢复  
```log
apparmor.service
postfix.service
spiceproxy.service
pve-daily-update.timer
apt-daily-upgrade.timer
apt-daily.timer
pve-firewall.service
pvefw-logger
pve-ha-lrm.service
pve-ha-crm.service
corosync
pvescheduler.service
```
## 新增显示设备ramfb
原版PVE没有该设备，容器版本新增一个ramfb作为显示设备

## 默认禁用UEFI的preEnrolledKeys
原版PVE创建EFI固件时会默认启用安全启动秘钥，容器版本默认行为是不启用

## 默认启用qemu-ga
原版PVE不会启用qemu-ga，容器版本默认启用

## pve-cluster的pmxcfs组件
pmxcfs的IP检查被修改，可以接受127开头的IP  
原版不允许使用127开头的IP地址

下面的改动的思路与原因，不感兴趣可以跳过  
由于在docker中运行，因此限制实际上是不大需要的  
我们使用host网络，但未设置hosts时会报错  
经过查找可以看到如下代码  
```cpp
https://github.com/proxmox/pve-cluster/blob/3749d370ac2e1e73d2558f8dbe5d7f001651157c/src/pmxcfs/pmxcfs.c#L850
int main(int argc, char *argv[])
{
    (上略)  
    cfs.nodename = g_strdup(utsname.nodename);
    
    if (!(cfs.ip = lookup_node_ip(cfs.nodename))) {
        cfs_critical(
            "Unable to resolve node name '%s' to a non-loopback IP address - missing entry in"
            " '/etc/hosts' or DNS?",
            cfs.nodename
        );
        qb_log_fini();
        exit(-1);
    }
    cfs_message("resolved node name '%s' to '%s' for default node IP address", cfs.nodename, cfs.ip);
    (下略)
}
```  
而这个lookup_node_ip则是这样写的  
```cpp
static char *
lookup_node_ip(const char *nodename)
{	
	(上略)
	for (struct addrinfo *addr = ainfo; addr != NULL; addr = addr->ai_next) {
		if (addr->ai_family == AF_INET) {
			struct sockaddr_in *sa = (struct sockaddr_in *)addr->ai_addr;
			inet_ntop(addr->ai_family, &sa->sin_addr, buf, sizeof(buf));
			if (strncmp(buf, "127.", 4) != 0) {
				res = g_strdup(buf);
				goto ret;
			}
		} else if (addr->ai_family == AF_INET6) {
			struct sockaddr_in6 *sa = (struct sockaddr_in6 *)addr->ai_addr;
			inet_ntop(addr->ai_family, &sa->sin6_addr, buf, sizeof(buf));
			if (strcmp(buf, "::1") != 0) {
				res = g_strdup(buf);
				goto ret;
			}
		}
	}
	(下略)
}
```  
把此处检查绕过再设置一条host  
`pve:127.0.0.1`  
就可以强行拉起PVE的pmxcfs  

# 运行案例  
## 群辉  
![](img/synology/202209051909.jpg)

![](img/synology/202209051910.jpg)

## fnOS
![](img/fnOS/20240830133338.png)
