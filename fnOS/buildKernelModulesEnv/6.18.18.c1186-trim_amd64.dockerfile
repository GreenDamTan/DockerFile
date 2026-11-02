FROM makedie/fnos:kernHead-baseEnv-amd64

COPY script/signforfn.sh /usr/bin/signforfn.sh

ENV BaseURL="https://download.liveupdate.fnnas.com/x86/kernel"
ENV PKG="linux-headers-6.18.18.c1186-trim_6.18.18.c1186-trim-1186_amd64.deb"
ENV dlkey="NxgGGmkvKxgVPyo4N2c2bDwLFm4="

RUN wget $(bash -c "/usr/bin/signforfn.sh ${dlkey} ${BaseURL}/${PKG}") -O ${PKG} &&\
    echo "54df432c2d4360ccca5ada0d1cea5ce22cc94cb833244861047f085ce6a1e06f  ${PKG}" | sha256sum -c - &&\
    dpkg -i ${PKG} &&\
    test -f /lib/modules/6.18.18.c1186-trim/build/Makefile &&\
    rm -f ${PKG}

ENV fake_uname_a="Linux GreenDamTan 6.18.18.c1186-trim #1186 SMP PREEMPT_DYNAMIC Fri Oct 30 08:53:15 UTC 2026 x86_64 GNU/Linux"
COPY script/uname /tmp
RUN mv -f /tmp/uname /usr/bin/uname && \
    chmod a+x /usr/bin/uname &&\
    uname -r &&\
    uname -v &&\
    uname -a
