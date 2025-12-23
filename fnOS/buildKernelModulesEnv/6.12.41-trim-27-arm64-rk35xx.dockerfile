FROM makedie/fnos:kernHead-baseEnv-arm64

RUN PKG=linux-headers-6.12.41-trim_6.12.41-trim-27_arm64-rk35xx.deb &&\
    wget https://download.liveupdate.fnnas.com/arm/kernel/${PKG} &&\
    dpkg -i --force-all ${PKG} &&\
    rm -f ${PKG}

ENV fake_uname_a="Linux GreenDamTan 6.12.41-trim #1 SMP PREEMPT Mon Dec 22 06:37:23 UTC 2025 aarch64 GNU/Linux"
COPY script/uname /tmp
RUN mv -f /tmp/uname /usr/bin/uname && \
    chmod a+x /usr/bin/uname &&\
    uname -r &&\
    uname -v &&\
    uname -a