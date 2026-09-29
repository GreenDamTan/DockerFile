FROM makedie/fnos:kernHead-baseEnv-amd64

COPY script/signforfn.sh /usr/bin/signforfn.sh
#    {
#      "packageName": "linux-headers-6.18.18.c1126-trim",
#      "version": "6.18.18.c1126-trim-1126",
#      "url": "https://download.liveupdate.fnnas.com/x86/kernel/linux-headers-6.18.18.c1126-trim_6.18.18.c1126-trim-1126_amd64.deb",
#      "sign": "ab41cc6c836c1edbe6a1e5727e624ffe3b3adfaa39c67366914ae0f378ecc05b",
#      "size": "9.08M",
#      "dlkey": "NxgGGmkvKxgVPyo4N2c2bDwLFm4=",
#      "installSpace": "10M",
#      "description": "linux-headers"
#    },

ENV BaseURL="https://download.liveupdate.fnnas.com/x86/kernel"
ENV PKG="linux-headers-6.18.18.c1126-trim_6.18.18.c1126-trim-1126_amd64.deb"
ENV dlkey="NxgGGmkvKxgVPyo4N2c2bDwLFm4="

RUN wget $(bash -c "/usr/bin/signforfn.sh ${dlkey} ${BaseURL}/${PKG}") -O ${PKG} &&\
    dpkg -i ${PKG} &&\
    test -f /lib/modules/6.18.18.c1126-trim/build/Makefile &&\
    rm -f ${PKG}

ENV fake_uname_a="Linux GreenDamTan 6.18.18.c1126-trim #1126 SMP PREEMPT_DYNAMIC Wed Sep 16 02:05:34 UTC 2026 x86_64 GNU/Linux"
COPY script/uname /tmp
RUN mv -f /tmp/uname /usr/bin/uname && \
    chmod a+x /usr/bin/uname &&\
    uname -r &&\
    uname -v &&\
    uname -a
