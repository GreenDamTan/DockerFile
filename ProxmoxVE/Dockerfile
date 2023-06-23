FROM debian:bookworm-20230612 as builder1
#base mirrow
ARG DEBIAN_FRONTEND=noninteractiv
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources &&\
    sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list.d/debian.sources

RUN echo "root:root"|chpasswd && \
    apt update &&\
    apt install -y --no-install-recommends ca-certificates && \
    sed -i 's/http:/https:/g' /etc/apt/sources.list.d/debian.sources && \
    apt update &&\
    apt install -y --no-install-recommends wget curl screen vim systemctl busybox && \
    busybox --install &&\
    echo "deb https://mirrors.ustc.edu.cn/proxmox/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list &&\
    wget https://mirrors.ustc.edu.cn/proxmox/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg &&\
    apt update &&\
    #intall proxmox-ve without recommends. ifupdown2 will install failed but ok
    apt-get -y --no-install-recommends  install pve-manager=8.0.3 proxmox-ve=8.0.1 || echo ok && \
    #clean
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*
#repacked proxmox-ve
RUN wget https://mirrors.ustc.edu.cn/proxmox/debian/dists/bookworm/pve-no-subscription/binary-amd64/proxmox-ve_8.0.1_all.deb && \
    mkdir /tmp/pve && \
    dpkg -X proxmox-ve_8.0.1_all.deb /tmp/pve/ && \
    dpkg -e proxmox-ve_8.0.1_all.deb /tmp/pve/DEBIAN && \
    sed -i "s/pve-kernel-helper,//g" /tmp/pve/DEBIAN/control && \
    sed -i "s/pve-kernel-6.2,//g" /tmp/pve/DEBIAN/control && \
    dpkg-deb -Zxz  -b /tmp/pve/ /tmp/ && \
    #repacked pve-manager
    wget https://mirrors.ustc.edu.cn/proxmox/debian/dists/bookworm/pve-no-subscription/binary-amd64/pve-manager_8.0.3_amd64.deb && \
    mkdir /tmp/pve-manager && \
    dpkg -X pve-manager_8.0.3_amd64.deb  /tmp/pve-manager/ && \
    dpkg -e pve-manager_8.0.3_amd64.deb /tmp/pve-manager/DEBIAN && \
    sed -i "s/ifupdown2 (>= 3.0) | ifenslave (>= 2.6),//g" /tmp/pve-manager/DEBIAN/control && \
    dpkg-deb -Zxz  -b /tmp/pve-manager/ /tmp &&\
    ##install again
    dpkg -i /tmp/*.deb || echo ok &&\
    rm -rf /*.deb /tmp/*

RUN rm -rf /etc/apt/sources.list.d/pve-enterprise.list && \
    systemctl disable pvestatd pvefw-logger corosync spiceproxy &&\
    systemctl disable getty@tty1 && \
    systemctl disable postfix && \
    systemctl disable ssh.service &&\
    systemctl disable pve-ha-lrm.service &&\
    systemctl disable pve-ha-crm.service &&\
    #no HA
    systemctl disable pve-firewall.service &&\
    #no firewall
    systemctl disable pvescheduler.service &&\
    #no pvescheduler
    systemctl disable spiceproxy.service || echo ok
    #no spice

STOPSIGNAL SIGINT
CMD [ "/lib/systemd/systemd", "log-level=info", "unit=sysinit.target"]