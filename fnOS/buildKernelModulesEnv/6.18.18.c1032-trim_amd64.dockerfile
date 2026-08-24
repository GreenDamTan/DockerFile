FROM makedie/fnos:kernHead-baseEnv-amd64

COPY script/signforfn.sh /usr/bin/signforfn.sh
#    {
#      "packageName": "linux-headers-6.18.18.c1032-trim",
#      "version": "6.18.18.c1032-trim-1032",
#      "url": "https://download.liveupdate.fnnas.com/x86_64/kernel/linux-headers-6.18.18.c1032-trim_6.18.18.c1032-trim-1032_amd64.deb",
#      "sign": "3d6bda0528084e232396c6720ac91c861fdc5db4a8af1fc5519c25a06fdc73e7",
#      "size": "8.9M",
#      "dlkey": "NxgGGmkvKxgVPyo4N2c2bDwLFm4=",
#      "installSpace": "10M",
#      "description": "headers"
#    },

ENV BaseURL="https://download.liveupdate.fnnas.com/x86_64/kernel"
ENV PKG="linux-headers-6.18.18.c1032-trim_6.18.18.c1032-trim-1032_amd64.deb"
ENV dlkey="NxgGGmkvKxgVPyo4N2c2bDwLFm4="

RUN wget $(bash -c "/usr/bin/signforfn.sh ${dlkey} ${BaseURL}/${PKG}") -O ${PKG} &&\
    dpkg -i --force-all ${PKG} &&\
    rm -f ${PKG}

ENV fake_uname_a="Linux GreenDamTan 6.18.18.c1032-trim #1032 SMP PREEMPT_DYNAMIC Fri Aug 21 01:49:29 UTC 2026 x86_64 GNU/Linux"
COPY script/uname /tmp
RUN mv -f /tmp/uname /usr/bin/uname && \
    chmod a+x /usr/bin/uname &&\
    uname -r &&\
    uname -v &&\
    uname -a
