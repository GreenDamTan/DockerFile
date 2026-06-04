FROM debian:bookworm-20260518

LABEL GreenDamTan="GreenDamTan"
LABEL maintainer="github.com/GreenDamTan"
LABEL git="github.com/GreenDamTan/DockerFile"

ENV DEBIAN_FRONTEND=noninteractive
ENV container=docker

RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-custom && \
    echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-custom

RUN echo "root:root"|chpasswd && \
    apt-get update &&\
    apt-get install -y --no-install-recommends ca-certificates apt-utils &&\
    apt-get install -y --no-install-recommends wget curl screen vim busybox pciutils git python3 &&\
    apt-get install -y dkms build-essential libelf-dev bc cpio libpopt0 rsync bison flex dwarves ruby libncurses-dev libssl-dev lzma devscripts debhelper dh-dkms ccache &&\
    apt-get install -y libncurses5-dev libncursesw5-dev &&\
    busybox --install &&\
    update-pciids &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*