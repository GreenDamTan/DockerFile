FROM debian:bullseye-20220822 as builder1
RUN sed -i 's|^deb http://ftp.debian.org|deb https://mirrors.ustc.edu.cn|g' /etc/apt/sources.list &&\
    sed -i 's|^deb http://security.debian.org|deb https://mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list &&\
    sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list &&\
    sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list
COPY systemctl3.py /usr/bin/systemctl
RUN chmod +x /usr/bin/systemctl && \
    ln -sf /usr/bin/systemctl /bin/systemctl &&\
    apt update &&\
    apt install -y wget python3 &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*
RUN echo "deb https://mirrors.ustc.edu.cn/proxmox/debian/pve bullseye pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list &&\
    wget https://mirrors.ustc.edu.cn/proxmox/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
CMD ['/bin/bash','-c','/usr/bin/systemctl && /usr/bin/systemctl --init && /bin/bash']