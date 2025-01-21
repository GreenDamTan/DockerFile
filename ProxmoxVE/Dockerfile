FROM debian:bookworm-20250113 as builder1
#base mirrow
ARG DEBIAN_FRONTEND=noninteractive
ARG pve_mirror_url=https://mirrors.ustc.edu.cn/proxmox/debian/dists/bookworm/pve-no-subscription/binary-amd64

ENV container=docker

LABEL GreenDamTan="GreenDamTan"
LABEL maintainer="github.com/GreenDamTan"
LABEL git="github.com/GreenDamTan/DockerFile"

USER 0:0
EXPOSE 8006:8006

RUN echo 'APT::Get::Assume-Yes "1";' > /etc/apt/apt.conf.d/00-custom && \
    echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-custom && \
    echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-custom

RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources &&\
    sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list.d/debian.sources &&\
    echo 'LANG=en_US.UTF-8' > /etc/default/locale &&\
    echo "root:root"|chpasswd && \
    apt-get update &&\
    apt-get install -y apt-utils &&\
    apt-get install -y --no-install-recommends ca-certificates && \
    sed -i 's/http:/https:/g' /etc/apt/sources.list.d/debian.sources && \
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

#RUN --mount=type=bind,target=/sys/fs/cgroup
#RUN --mount=type=bind,target=/sys/fs/fuse
#RUN --mount=type=tmpfs,destination=/tmp
#RUN --mount=type=tmpfs,destination=/var/cache
#RUN --mount=type=tmpfs,destination=/var/run
#RUN --mount=type=tmpfs,destination=/run
#RUN --mount=type=tmpfs,destination=/run/lock

COPY tools/fakeDeb /tmp/
RUN echo "build mock" &&\
    dpkg-deb --build /tmp/ifupdown2_mock &&\
    dpkg-deb --build /tmp/ifenslave_mock &&\
    dpkg-deb --build /tmp/proxmox-kernel-helper_mock &&\
    dpkg-deb --build /tmp/proxmox-default-kernel_mock &&\
    dpkg -i /tmp/*_mock.deb &&\
    rm -rf /tmp/*_mock*

ARG pve_manager_ver=8.3.2
ARG proxmox_ve_ver=8.3.0
ARG qemu_server_ver=8.3.3

#openvswitch-switch is test
RUN apt-get update &&\
    apt-get install -y --no-install-recommends wget curl screen vim systemctl busybox pciutils openvswitch-switch &&\
    busybox --install &&\
    update-pciids &&\
    systemctl set-default multi-user.target &&\
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/proxmox/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list &&\
    wget https://mirrors.ustc.edu.cn/proxmox/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg &&\
    apt-get update &&\
    echo "install pve-manager and proxmox-ve" &&\
    apt-get -y --no-install-recommends install pve-manager=${pve_manager_ver} proxmox-ve=${proxmox_ve_ver} qemu-server=${qemu_server_ver} && \
    echo "#clean" &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

#patch for ramfb
#https://github.com/proxmox/qemu-server/blob/9ebec81f019ffbe33c4f35754066fa2b92fab4f7/PVE/QemuServer.pm#L187
#https://github.com/proxmox/qemu-server/blob/9ebec81f019ffbe33c4f35754066fa2b92fab4f7/PVE/QemuServer.pm#L1688
#https://github.com/proxmox/qemu-server/blob/9ebec81f019ffbe33c4f35754066fa2b92fab4f7/PVE/QemuServer.pm#L3662
#https://github.com/proxmox/pve-manager/blob/f157a38b211595d67e72c9a9a819947668171f75/www/manager6/Utils.js#L610
RUN sed -e "s/virtio virtio-gl vmware)/virtio virtio-gl vmware ramfb)/g" \
    -e "s/'virtio-gl' => 'virtio-vga-gl',/'virtio-gl' => 'virtio-gpu-gl','ramfb' => 'ramfb',/g" \
    -i /usr/share/perl5/PVE/QemuServer.pm &&\
    sed -z "s/vga->{type} ne 'none'){\n\tpush @\$devices, '-device', print_vga_device(\n\t    \$conf, \$vga, \$arch, \$machine_version, \$machine_type, undef, \$qxlnum, \$bridges);/vga->{type} ne 'none'){ if (\$vga->{type} eq 'ramfb'){ push @\$devices, '-device', 'ramfb'; } else { push @\$devices, '-device', print_vga_device( \$conf, \$vga, \$arch, \$machine_version, \$machine_type, undef, \$qxlnum, \$bridges);}/g" -i /usr/share/perl5/PVE/QemuServer.pm &&\
    sed -z "s/virtio: 'VirtIO-GPU',\n\t'virtio-gl': 'VirGL GPU',/virtio: 'VirtIO-GPU',\n\t'virtio-gl': 'VirGL GPU',ramfb: 'ramfb',/g" -i  /usr/share/pve-manager/js/pvemanagerlib.js

#patch for efi preEnrolledKeys
#https://github.com/proxmox/pve-manager/blob/f157a38b211595d67e72c9a9a819947668171f75/www/manager6/qemu/HDEfi.js#L70
RUN sed -z "s/name: 'preEnrolledKeys',\n\t\tchecked: true,/name: 'preEnrolledKeys',\n\t\tchecked: false,/g" -i /usr/share/pve-manager/js/pvemanagerlib.js

#patch for qemu-agent
#https://github.com/proxmox/pve-manager/blob/f157a38b211595d67e72c9a9a819947668171f75/www/manager6/qemu/Options.js#L274
#https://github.com/proxmox/pve-manager/blob/f157a38b211595d67e72c9a9a819947668171f75/www/manager6/qemu/SystemEdit.js#L150
RUN sed -z "s/header: 'QEMU Guest Agent',\n\t\tdefaultValue: false,/header: 'QEMU Guest Agent',\n\t\tdefaultValue: false,/g" -i  /usr/share/pve-manager/js/pvemanagerlib.js &&\
    sed -z "s/defaultValue: 0,\n\t    deleteDefaultValue: true,\n\t    fieldLabel: gettext('Qemu Agent'),/defaultValue: 1, checked: true, fieldLabel: gettext('Qemu Agent'),/g" -i  /usr/share/pve-manager/js/pvemanagerlib.js

#reduce pveproxy pvedaemon workers
#https://github.com/proxmox/pve-manager/blob/c1689ccb1065a83be900bca61c2a56314126f4ea/PVE/Service/pvedaemon.pm#L18
#https://github.com/proxmox/pve-manager/blob/c1689ccb1065a83be900bca61c2a56314126f4ea/PVE/Service/pveproxy.pm#L32
RUN sed "s/max_workers => 3/max_workers => 1/g" \
    -i /usr/share/perl5/PVE/Service/pveproxy.pm \
    -i /usr/share/perl5/PVE/Service/pvedaemon.pm

# pve-cluster/src/pmxcfs/pmxcfs.c patch 127.
RUN hexdump -ve '1/1 "%.2X"' /usr/bin/pmxcfs > /usr/bin/pmxcfs.hex &&\
    rm -f /usr/bin/pmxcfs &&\
    sed -e 's/003132372E/003532372E/g' -i /usr/bin/pmxcfs.hex &&\
    xxd -r -p /usr/bin/pmxcfs.hex > /usr/bin/pmxcfs &&\
    chmod a+x /usr/bin/pmxcfs &&\
    rm -f /usr/bin/pmxcfs.hex

COPY tools/pve-fake-subscription_0.0.9.deb /tmp/
RUN dpkg -i /tmp/pve-fake-subscription_*.deb &&\
    rm -rf /tmp/pve-fake-subscription_*.deb &&\
    sed -e "s/YajuuSenpai/github.com\/greendamtan\//g" -i /usr/bin/pve-fake-subscription &&\
    /usr/bin/pve-fake-subscription || echo ''

RUN rm -rf /etc/apt/sources.list.d/pve-enterprise.list &&\
    systemctl mask apparmor.service postfix.service spiceproxy.service &&\
    systemctl mask pve-daily-update.timer apt-daily-upgrade.timer apt-daily.timer &&\
    echo "no firewall" &&\
    systemctl mask pve-firewall.service pvefw-logger &&\
    echo "no HA" &&\
    systemctl mask pve-ha-lrm.service pve-ha-crm.service corosync &&\
    echo "no pvescheduler" &&\
    systemctl mask pvescheduler.service

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