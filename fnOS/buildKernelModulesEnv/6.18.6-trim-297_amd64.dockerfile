FROM makedie/fnos:kernHead-baseEnv-amd64

RUN PKG=linux-headers-6.18.6-trim_6.18.6-trim-297_amd64.deb &&\
    wget https://download.liveupdate.fnnas.com/arm/kernel/${PKG} &&\
    dpkg -i --force-all ${PKG} &&\
    rm -f ${PKG}

ENV fake_uname_a="Linux GreenDamTan 6.18.6-trim #297 SMP PREEMPT_DYNAMIC Fri Mar 1 01:02:03 UTC 2026 x86_64 GNU/Linux"
COPY script/uname /tmp
RUN mv -f /tmp/uname /usr/bin/uname && \
    chmod a+x /usr/bin/uname &&\
    uname -r &&\
    uname -v &&\
    uname -a