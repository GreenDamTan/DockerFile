FROM makedie/fnos:kernHead-baseEnv

RUN PKG=linux-headers-6.6.38-trim_6.6.38-trim-92_amd64.deb &&\
    wget https://download.liveupdate.fnnas.com/x86_64/kernel/${PKG} &&\
    dpkg -i --force-all ${PKG} &&\
    rm -f ${PKG}

ENV fake_uname_a="Linux 6-6-38-trim-92 6.6.38-trim #92 SMP PREEMPT_DYNAMIC Tue Mar 11 17:22:50 CST 2025 x86_64 GNU/Linux"
COPY script/uname /tmp
RUN mv -f /tmp/uname /usr/bin/uname && \
    chmod a+x /usr/bin/uname &&\
    uname -r &&\
    uname -v &&\
    uname -a