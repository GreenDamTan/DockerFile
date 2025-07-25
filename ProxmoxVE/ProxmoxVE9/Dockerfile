FROM makedie/proxmox_ve:debian-trixie-20250630-amd64 as builder1

#ARG pve_mirror_url=https://mirrors.ustc.edu.cn/proxmox/debian/dists/trixie/pve-test/binary-amd64/

USER 0:0
EXPOSE 8006:8006

#RUN --mount=type=bind,target=/sys/fs/cgroup
#RUN --mount=type=bind,target=/sys/fs/fuse
#RUN --mount=type=tmpfs,destination=/tmp
#RUN --mount=type=tmpfs,destination=/var/cache
#RUN --mount=type=tmpfs,destination=/var/run
#RUN --mount=type=tmpfs,destination=/run
#RUN --mount=type=tmpfs,destination=/run/lock

COPY tools/fakeDeb /tmp/
RUN echo "build mock" &&\
    chmod -R a+r /tmp/. &&\
    dpkg-deb --build /tmp/ifupdown2_mock &&\
    dpkg-deb --build /tmp/ifenslave_mock &&\
    dpkg-deb --build /tmp/proxmox-kernel-helper_mock &&\
    dpkg-deb --build /tmp/proxmox-default-kernel_mock &&\
    dpkg -i /tmp/*_mock.deb &&\
    rm -rf /tmp/*_mock*

ARG pve_manager_ver=9.0.0~11
ARG proxmox_ve_ver=9.0.0
ARG qemu_server_ver=9.0.7
ARG pve_qemu_kvm_ver=10.0.2-4

RUN echo "deb https://mirrors.ustc.edu.cn/proxmox/debian/pve trixie pve-test" > /etc/apt/sources.list.d/pve-no-subscription.list &&\
    wget https://enterprise.proxmox.com/debian/proxmox-archive-keyring-trixie.gpg -O /etc/apt/trusted.gpg.d/proxmox-archive-keyring.gpg &&\
    apt-get update &&\
    echo "install pve-manager and proxmox-ve" &&\
    apt-get -y --no-install-recommends install pve-manager=${pve_manager_ver} proxmox-ve=${proxmox_ve_ver} qemu-server=${qemu_server_ver} pve-qemu-kvm=${pve_qemu_kvm_ver} proxmox-archive-keyring && \
    echo "#clean" &&\
    apt-get clean &&\
    mv /etc/apt/sources.list.d/pve-enterprise.sources /etc/apt/sources.list.d/pve-enterprise.sources.bak &&\
    rm -rf /var/lib/apt/lists/*

#reduce pveproxy pvedaemon workers
#https://github.com/proxmox/pve-manager/blob/c1689ccb1065a83be900bca61c2a56314126f4ea/PVE/Service/pvedaemon.pm#L18
#https://github.com/proxmox/pve-manager/blob/c1689ccb1065a83be900bca61c2a56314126f4ea/PVE/Service/pveproxy.pm#L32
RUN sed -e "s/max_workers => 3/max_workers => 1/g" \
    -i /usr/share/perl5/PVE/Service/pveproxy.pm \
    -i /usr/share/perl5/PVE/Service/pvedaemon.pm

RUN echo "\nYou are runing PVE in dokcer. \nMore information in : https://hub.docker.com/r/makedie/proxmox_ve \n"  >> /etc/motd

COPY tools/pve-fake-subscription_0.0.9.deb /tmp/
RUN dpkg -i /tmp/pve-fake-subscription_*.deb &&\
    rm -rf /tmp/pve-fake-subscription_*.deb &&\
    sed -e "s/YajuuSenpai/github.com\/greendamtan\//g" -i /usr/bin/pve-fake-subscription &&\
    /usr/bin/pve-fake-subscription || echo ''

COPY tools/romfile/CWWK.bin /usr/share/kvm/

RUN rm -rf /etc/apt/sources.list.d/pve-enterprise.list &&\
    systemctl mask apparmor.service postfix.service spiceproxy.service &&\
    systemctl mask pve-daily-update.timer apt-daily-upgrade.timer apt-daily.timer &&\
    echo "no firewall" &&\
    systemctl mask pve-firewall.service pvefw-logger &&\
    echo "no HA" &&\
    systemctl mask pve-ha-lrm.service pve-ha-crm.service corosync &&\
    echo "no pvescheduler" &&\
    systemctl mask pvescheduler.service &&\
    systemctl mask systemd-logind &&\
    systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

RUN systemctl enable pvestatd.service &&\
    systemctl enable pveproxy.service &&\
    systemctl enable pvebanner.service

VOLUME /var/lib/pve-cluster
VOLUME /var/lib/vz

COPY tools/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

STOPSIGNAL SIGINT
CMD [ "/lib/systemd/systemd", "log-level=info", "unit=sysinit.target"]