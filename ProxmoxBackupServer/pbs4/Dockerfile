FROM debian:trixie-20250721

LABEL maintainer="github.com/GreenDamTan"

ENV DEBIAN_FRONTEND=noninteractive
ENV container=docker

USER 0:0
EXPOSE 8007:8007

RUN echo 'APT::Get::Assume-Yes "1";' > /etc/apt/apt.conf.d/01-custom && \
    echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/00-custom && \
    echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-custom

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    echo 'LANG=en_US.UTF-8' > /etc/default/locale

RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources &&\
    sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list.d/debian.sources &&\
    echo "root:root"|chpasswd && \
    apt-get update &&\
    apt-get install -y apt-utils &&\
    apt-get install -y --no-install-recommends ca-certificates && \
    sed -i 's/http:/https:/g' /etc/apt/sources.list.d/debian.sources && \
    apt-get install -y wget curl screen vim &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

ARG proxmox_backup_server_ver=4.0.12-1

RUN echo "deb http://download.proxmox.com/debian/pbs trixie pbs-no-subscription" > /etc/apt/sources.list.d/pbs-no-subscription.list &&\
    wget http://enterprise.proxmox.com/debian/proxmox-archive-keyring-trixie.gpg -O /etc/apt/trusted.gpg.d/proxmox-archive-keyring.gpg &&\
    apt-get update &&\
    apt install supervisor proxmox-backup-server=${proxmox_backup_server_ver}

COPY pbs.ini /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
VOLUME [ "/etc/proxmox-backup", "/backups", "/var/lib/proxmox-backup", "/var/log/proxmox-backup" ]

STOPSIGNAL SIGINT