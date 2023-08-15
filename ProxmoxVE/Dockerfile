FROM debian:bookworm-20230725 as builder1
#base mirrow
ARG DEBIAN_FRONTEND=noninteractiv
ARG pve_mirror_url=https://mirrors.ustc.edu.cn/proxmox/debian/dists/bookworm/pve-no-subscription/binary-amd64
ARG pve_manager_ver=8.0.4
ARG proxmox_ve_ver=8.0.2
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
    apt-get -y --no-install-recommends  install pve-manager=${pve_manager_ver} proxmox-ve=${proxmox_ve_ver} || echo ok && \
    #clean
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*
#repacked proxmox-ve
RUN wget ${pve_mirror_url}/proxmox-ve_${proxmox_ve_ver}_all.deb && \
    mkdir /tmp/pve && \
    dpkg -X proxmox-ve_${proxmox_ve_ver}_all.deb /tmp/pve/ && \
    dpkg -e proxmox-ve_${proxmox_ve_ver}_all.deb /tmp/pve/DEBIAN && \
    sed -i "s/pve-kernel-helper,//g" /tmp/pve/DEBIAN/control && \
    sed -i "s/pve-kernel-6.2,//g" /tmp/pve/DEBIAN/control && \
    dpkg-deb -Zxz  -b /tmp/pve/ /tmp/ && \
    #repacked pve-manager
    wget ${pve_mirror_url}/pve-manager_${pve_manager_ver}_amd64.deb && \
    mkdir /tmp/pve-manager && \
    dpkg -X pve-manager_${pve_manager_ver}_amd64.deb  /tmp/pve-manager/ && \
    dpkg -e pve-manager_${pve_manager_ver}_amd64.deb /tmp/pve-manager/DEBIAN && \
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