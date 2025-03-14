FROM debian:bookworm-20250224

LABEL GreenDamTan="GreenDamTan"
LABEL maintainer="github.com/GreenDamTan"
LABEL git="github.com/GreenDamTan/DockerFile"

ENV DEBIAN_FRONTEND=noninteractive
ENV container=docker

RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-custom && \
    echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-custom

RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources &&\
    sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list.d/debian.sources &&\
    echo "root:root"|chpasswd && \
    apt-get update &&\
    apt-get install -y --no-install-recommends ca-certificates apt-utils &&\
    apt-get clean &&\
    sed -i 's/http:/https:/g' /etc/apt/sources.list.d/debian.sources &&\
    apt-get update &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

RUN apt-get update &&\
    apt-get install -y --no-install-recommends wget curl screen vim busybox pciutils git &&\
    busybox --install &&\
    update-pciids &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

RUN apt-get update &&\
    apt-get install -y dkms build-essential libelf-dev &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*