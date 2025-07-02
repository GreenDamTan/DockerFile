FROM debian:bookworm-20250630 as builder1
#base mirrow
ARG DEBIAN_FRONTEND=noninteractive

ENV container=docker
ENV LC_ALL=C.UTF-8 LANGUAGE=C.UTF-8 LANG=C.UTF-8

LABEL GreenDamTan="GreenDamTan"
LABEL maintainer="github.com/GreenDamTan"
LABEL git="github.com/GreenDamTan/DockerFile"

USER 0:0

RUN echo 'APT::Get::Assume-Yes "1";' > /etc/apt/apt.conf.d/01-custom && \
    echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/00-custom && \
    echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-custom

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources &&\
    sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list.d/debian.sources &&\
    echo "root:root"|chpasswd && \
    apt-get update &&\
    apt-get install -y apt-utils &&\
    apt-get install -y --no-install-recommends ca-certificates && \
    sed -i 's/http:/https:/g' /etc/apt/sources.list.d/debian.sources && \
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

#openvswitch-switch is test
RUN apt-get update &&\
    apt-get install -y --no-install-recommends wget curl screen vim systemctl busybox pciutils mdevctl openvswitch-switch &&\
    busybox --install &&\
    update-pciids &&\
    systemctl set-default multi-user.target &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

RUN cd /lib/systemd/system/sysinit.target.wants/ && rm $(ls | grep -v systemd-tmpfiles-setup) &&\
    rm -f /lib/systemd/system/multi-user.target.wants/* /etc/systemd/system/*.wants/* /lib/systemd/system/local-fs.target.wants/* /lib/systemd/system/sockets.target.wants/*udev* /lib/systemd/system/sockets.target.wants/*initctl* /lib/systemd/system/basic.target.wants/* /lib/systemd/system/anaconda.target.wants/* /lib/systemd/system/plymouth* /lib/systemd/system/systemd-update-utmp*
