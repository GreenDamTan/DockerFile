FROM makedie/fnos:kernHead-baseEnv

RUN PKG=linux-headers-6.12.5-trim_6.12.5-trim-10_amd64.deb &&\
    wget https://download.liveupdate.fnnas.com/x86_64/kernel/${PKG} &&\
    dpkg -i --force-all ${PKG} &&\
    rm -f ${PKG}

ENV fake_uname_a="Linux kerl-6-12-5-10 6.12.5-trim #10 SMP PREEMPT_DYNAMIC Tue Mar 11 18:01:25 CST 2025 x86_64 GNU/Linux"
COPY script/uname /tmp
RUN mv -f /tmp/uname /usr/bin/uname && \
    chmod a+x /usr/bin/uname &&\
    uname -r &&\
    uname -v &&\
    uname -a