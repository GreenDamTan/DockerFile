FROM makedie/fnos:kernHead-baseEnv-amd64

RUN PKG=linux-headers-6.18.18-trim_6.18.18-trim-427_amd64.deb &&\
    wget https://download.liveupdate.fnnas.com/arm/kernel/${PKG} &&\
    dpkg -i --force-all ${PKG} &&\
    rm -f ${PKG}

ENV fake_uname_a="Linux GreenDamTan 6.18.18-trim #427 SMP PREEMPT_DYNAMIC Wed Apr 1 01:44:44 UTC 2026 x86_64 GNU/Linux"
COPY script/uname /tmp
RUN mv -f /tmp/uname /usr/bin/uname && \
    chmod a+x /usr/bin/uname &&\
    uname -r &&\
    uname -v &&\
    uname -a