FROM scratch

LABEL GreenDamTan="GreenDamTan"
LABEL maintainer="github.com/GreenDamTan"
LABEL git="github.com/GreenDamTan/DockerFile"

ENV DEBIAN_FRONTEND=noninteractive
ENV container=docker

ADD iso/fniso/trimfs.tgz /

RUN mkdir -p /tmp && chmod 1777 /tmp &&\
    mkdir -p /var/cache/apt/archives/partial && chmod 1777 /var/cache/apt/archives/partial &&\
    mkdir -p /var/tmp && chmod 1777 /var/tmp &&\
    mkdir -p /var/log/apt && chmod 1777 /var/log/apt

RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-custom && \
    echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-custom

RUN echo "root:root"|chpasswd && \
    apt-get update &&\
    apt-get remove -y initramfs-tools &&\
    apt-get install -y ca-certificates apt-utils &&\
    apt-get install -y wget curl screen vim busybox &&\
    apt-get clean &&\
    busybox --install

COPY etc.tar /usr/trim
RUN ls -l /usr/trim && tar -xf /usr/trim/etc.tar -C /usr/trim
# make static machine_id
RUN echo "0000000000000000000000000000000000000000" > /usr/trim/etc/machine_id &&\
    echo "0000000000000000000000000000000000000000" > /etc/machine-id &&\
    echo "" > /etc/fstab

RUN sed -e 's/peer/trust/' -e 's/scram-sha-256/trust/' -i /etc/postgresql/15/main/pg_hba.conf &&\
    echo "local all all  trust" > /etc/postgresql/15/main/pg_hba.conf &&\
    echo "host all all 0.0.0.0/0 trust" >> /etc/postgresql/15/main/pg_hba.conf &&\
    echo "listen_addresses = '*'" >> /etc/postgresql/15/main/postgresql.conf &&\
    sed -e "s/\$2}' | grep/\$2}' |awk -F '@' '{print \$1}'| grep/g" -i /usr/trim/bin/show_startup_info.sh

RUN systemctl disable boot-efi.mount &&\
    systemctl disable trim_wayland.service rpc-statd.service nfs-mountd.service systemd-update-utmp-runlevel.service networking.service &&\
    systemctl disable trim_miniscreen.service console-setup.service emergency.service rpc-statd-notify.service nfs-server.service &&\
    systemctl disable nfs-idmapd.service nfs-blkmap.service systemd-update-utmp.service rpcbind.service getty@tty1.service nut-server.service nut-monitor.service &&\
    systemctl disable libvirtd.service

RUN systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target &&\
    rm -rf /etc/systemd/system/multi-user.target.wants/auto_thumbnailer.service &&\
    mv /etc/systemd/system/auto_thumbnailer.service /etc/systemd/system/auto_thumbnailer.service.bak &&\
    rm -rf /etc/systemd/system/multi-user.target.wants/share_service.service &&\
    mv /etc/systemd/system/share_service.service /etc/systemd/system/share_service.service.bak &&\
    rm -rf /etc/systemd/system/multi-user.target.wants/smbftpd.service &&\
    mv /etc/systemd/system/smbftpd.service /etc/systemd/system/smbftpd.service.bak &&\
    rm -rf /etc/systemd/system/multi-user.target.wants/docker.service &&\
    mv /etc/systemd/system/docker.service /etc/systemd/system/docker.service.bak &&\
    rm -rf /etc/systemd/system/multi-user.target.wants/dockermgr.service &&\
    mv /etc/systemd/system/dockermgr.service /etc/systemd/system/dockermgr.service.bak &&\
    rm -rf /etc/systemd/system/multi-user.target.wants/dsmgr.service &&\
    mv /etc/systemd/system/dsmgr.service /etc/systemd/system/dsmgr.service.bak &&\
    rm -rf /etc/systemd/system/multi-user.target.wants/avahi.service &&\
    mv /etc/systemd/system/avahi.service /etc/systemd/system/avahi.service.bak &&\
    rm -rf /etc/systemd/system/multi-user.target.wants/trim_connect.service &&\
    mv /etc/systemd/system/trim_connect.service /etc/systemd/system/trim_connect.service.bak &&\
    rm -rf /etc/systemd/system/multi-user.target.wants/webdav.service &&\
    mv /etc/systemd/system/webdav.service /etc/systemd/system/webdav.service.bak &&\
    rm -rf /etc/systemd/system/multi-user.target.wants/trim_file_monitor.service &&\
    mv /etc/systemd/system/trim_file_monitor.service /etc/systemd/system/trim_file_monitor.service.bak &&\
    rm -rf /etc/systemd/system/multi-user.target.wants/trim_trashbind.service &&\
    mv /etc/systemd/system/trim_trashbind.service /etc/systemd/system/trim_trashbind.service.bak &&\
    rm -rf /etc/systemd/system/multi-user.target.wants/trim_wayland.service &&\
    mv /etc/systemd/system/trim_wayland.service /etc/systemd/system/trim_wayland.service.bak && \
    mv /usr/lib/systemd/system/systemd-remount-fs.service /usr/lib/systemd/system/systemd-remount-fs.service.bak

STOPSIGNAL SIGINT
CMD [ "/lib/systemd/systemd", "log-level=info"]