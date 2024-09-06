FROM ubuntu:22.04 as builder1
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /data
USER root
RUN apt update &&\
    apt install -y --no-install-recommends ca-certificates
RUN apt install -y --no-install-recommends acpica-tools chrpath doxygen g++-multilib libasound2-dev libcap-dev \
    libcurl4-openssl-dev libdevmapper-dev libidl-dev libopus-dev libpam0g-dev \
    libpulse-dev libqt5opengl5-dev libqt5x11extras5-dev qttools5-dev libsdl1.2-dev libsdl-ttf2.0-dev \
    libssl-dev libvpx-dev libxcursor-dev libxinerama-dev libxml2-dev libxml2-utils \
    libxmu-dev libxrandr-dev make nasm python3-dev python2-dev qttools5-dev-tools \
    texlive texlive-fonts-extra texlive-latex-extra unzip xsltproc \
    default-jdk libstdc++5 libxslt1-dev linux-kernel-headers makeself \
    mesa-common-dev subversion yasm zlib1g-dev glslang-tools \
    libc6-dev-i386 lib32stdc++6 libtpms-dev
RUN apt install -y --no-install-recommends git wget bzip2
RUN wget https://download.virtualbox.org/virtualbox/7.0.20/VirtualBox-7.0.20.tar.bz2 &&\
    tar xf VirtualBox-7.0.20.tar.bz2
RUN mkdir -p vbox-kvm &&\
    cd vbox-kvm &&\
    git init &&\
    git remote add origin https://github.com/cyberus-technology/virtualbox-kvm.git &&\
    git fetch origin 1c0683c1b8769ff9f6bd0b5d78ed0b5966339681 &&\
    git reset --hard FETCH_HEAD &&\
    cd ..
RUN git config --global user.name "GreenDamTan" &&\
    git config --global user.email "4781595+GreenDamTan@users.noreply.github.com" &&\
    git config --global init.defaultBranch master &&\
    git config --global gc.auto 0
RUN cd VirtualBox-7.0.20 &&  \
    git init && \
    git add * && \
    git commit -m "VirtualBox vanilla code" && \
    git am ../vbox-kvm/patches/*.patch
RUN cd VirtualBox-7.0.20 &&\
    pwd &&\
    chmod +x configure &&\
    ./configure --with-kvm --disable-kmods --disable-docs --disable-hardening --disable-java
RUN ln -snf /bin/bash /bin/sh
RUN cd VirtualBox-7.0.20 &&\
    source ./env.sh && kmk
RUN cd VirtualBox-7.0.20 &&\
    tree out/