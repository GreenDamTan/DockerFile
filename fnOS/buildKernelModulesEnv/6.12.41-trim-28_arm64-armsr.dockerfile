FROM makedie/fnos:kernHead-baseEnv-arm64

RUN PKG=linux-headers-6.12.41-trim_6.12.41-trim-28_arm64-armsr.deb &&\
    wget https://download.liveupdate.fnnas.com/arm/kernel/${PKG} &&\
    dpkg -i --force-all ${PKG} &&\
    rm -f ${PKG}

ENV fake_uname_a="Linux GreenDamTan 6.12.41-trim #1 SMP Tue Dec 23 03:32:00 UTC 2025 aarch64 GNU/Linux"
COPY script/uname /tmp
RUN mv -f /tmp/uname /usr/bin/uname && \
    chmod a+x /usr/bin/uname &&\
    uname -r &&\
    uname -v &&\
    uname -a