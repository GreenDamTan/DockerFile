#!/bin/bash

if [ ! -z "$root_password" ]; then
	printf 'define the password,do config password %s\n' "$root_password"
	echo "root:$root_password"|chpasswd
fi

if [ -z "$setting_ssh_port" ];
  then
    printf 'not define the ssh_port,do mask sshd \n'
    #printf 'not define the ssh_port,do mask sshd \n'
    #systemctl disable sshd
    #systemctl mask sshd
  else
    printf 'define the ssh_port,do config ssh_port %s\n' "$setting_ssh_port"
    sed -i "s/.*Port.*/Port $setting_ssh_port/g" /etc/ssh/sshd_config
    sed -i "s/.*PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config
    sed -i "s/.*PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
    systemctl enable sshd
fi

if [ ! -z "$port" ]; then
	printf 'replace Proxmox port to %s\n' "$port"
	sed -i "s|8006|$port|g" /usr/share/perl5/PVE/Firewall.pm
  sed -i "s|8006|$port|g" /usr/share/perl5/PVE/Cluster/Setup.pm
  sed -i "s|8006|$port|g" /usr/share/perl5/PVE/APIServer/AnyEvent.pm
  sed -i "s|8006|$port|g" /usr/share/perl5/PVE/API2/LXC.pm
  sed -i "s|8006|$port|g" /usr/share/perl5/PVE/API2/Qemu.pm
  sed -i "s|8006|$port|g" /usr/share/perl5/PVE/APIClient/LWP.pm
  sed -i "s|8006|$port|g" /usr/share/perl5/PVE/CLI/pct.pm
  sed -i "s|8006|$port|g" /usr/share/perl5/PVE/CLI/qm.pm
  sed -i "s|8006|$port|g" /usr/share/perl5/PVE/Service/pveproxy.pm
	#sed -i "s/host => \$host/host => '127.0.0.1'/g" /usr/share/perl5/PVE/Cluster/Setup.pm
	# need patch pve-cluster/src/pmxcfs/pmxcfs.c
fi

for i in `ip -o link show | awk -F': ' '{print $2}' |awk -F '@' '{print $1}'| grep -w -v 'lo' | grep -v '^docker' | grep -v '^br-'`;
do
  if grep -iq "${i}" /etc/network/interfaces; then echo "${i} is exists"; continue; fi
  if [[ ${i} == *"ovs"* ]]; then
      echo "ovs ink detect ${i}"
      echo -e "\niface ${i} inet manual\n        ovs_type OVSBridge" >> /etc/network/interfaces
  fi
done

if [ -z "$setting_no_mock_hosts" ]; then
  hostname=`uname -n`
  if [[ -z `cat /etc/hosts |grep -v "fe" |grep -v "127" |grep -v "::" |grep $hostname ` ]]; then
    if grep -iq "192.168.6.66" /etc/hosts; then echo "mock hosts is exists"; else echo "192.168.6.66 `uname -n`" >> /etc/hosts; fi;
  fi
fi

[ -d "/host/var/run/openvswitch" ] && ln -s /host/var/run/openvswitch /var/run/ && echo "ln openvswitch"

[ -f "/usr/bin/pve-fake-subscription" ] && /usr/bin/pve-fake-subscription

[ ! -f "/var/log/pve-firewall.log" ] && echo -e "You are runing PVE in dokcer. \nMore information in : https://hub.docker.com/r/makedie/proxmox_ve \n" > /var/log/pve-firewall.log

exec "$@"