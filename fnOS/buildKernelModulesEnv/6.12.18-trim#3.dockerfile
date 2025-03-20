FROM makedie/fnos:kernHead-baseEnv

RUN PKG=linux-headers-6.12.18-trim_6.12.18-trim-3_amd64.deb &&\
    wget https://download.liveupdate.fnnas.com/x86_64/kernel/${PKG} &&\
    dpkg -i --force-all ${PKG} &&\
    rm -f ${PKG}

ENV fake_uname_a="Linux fake-env 6.12.18-trim #3 SMP PREEMPT_DYNAMIC Fri Mar 14 18:19:59 CST 2025 x86_64 GNU/Linux"
COPY script/uname /tmp
RUN mv -f /tmp/uname /usr/bin/uname && \
    chmod a+x /usr/bin/uname &&\
    uname -r &&\
    uname -v &&\
    uname -a