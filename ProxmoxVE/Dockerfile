FROM debian:bullseye-20220822 as builder1
#base mirrow
ENV DEBIAN_FRONTEND=noninteractiv
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list &&\
    sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list

RUN echo "root:root"|chpasswd && \
    apt update &&\
    apt install -y --no-install-recommends ca-certificates wget curl screen vim systemctl busybox && \
    busybox --install &&\
    echo "deb https://mirrors.ustc.edu.cn/proxmox/debian/pve bullseye pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list &&\
    wget https://mirrors.ustc.edu.cn/proxmox/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg &&\
    apt update &&\
    #intall proxmox-ve without recommends. ifupdown2 will install failed but ok
    apt-get -y --no-install-recommends  install  proxmox-ve=7.2-1 || echo ok && \
    #clean
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*
#repacked proxmox-ve
RUN wget https://mirrors.ustc.edu.cn/proxmox/debian/dists/bullseye/pve-no-subscription/binary-amd64/proxmox-ve_7.2-1_all.deb && \
    mkdir /tmp/pve && \
    dpkg -X proxmox-ve_7.2-1_all.deb /tmp/pve/ && \
    dpkg -e proxmox-ve_7.2-1_all.deb /tmp/pve/DEBIAN && \
    sed -i "s/pve-kernel-helper,//g" /tmp/pve/DEBIAN/control && \
    sed -i "s/pve-kernel-5.15,//g" /tmp/pve/DEBIAN/control && \
    dpkg-deb -Zxz  -b /tmp/pve/ /tmp/ && \
    #repacked pve-manager
    wget https://mirrors.ustc.edu.cn/proxmox/debian/dists/bullseye/pve-no-subscription/binary-amd64/pve-manager_7.2-7_amd64.deb && \
    mkdir /tmp/pve-manager && \
    dpkg -X pve-manager_7.2-7_amd64.deb  /tmp/pve-manager/ && \
    dpkg -e pve-manager_7.2-7_amd64.deb /tmp/pve-manager/DEBIAN && \
    sed -i "s/ifupdown2 (>= 2.0.1-1+pve8) | ifenslave (>= 2.6),//g" /tmp/pve-manager/DEBIAN/control && \
    dpkg-deb -Zxz  -b /tmp/pve-manager/ /tmp &&\
    ##install again
    dpkg -i /tmp/*.deb || echo ok &&\
    rm -rf /*.deb /tmp/*

STOPSIGNAL SIGINT
CMD [ "/lib/systemd/systemd", "log-level=info", "unit=sysinit.target"]