FROM makedie/fnos:kernHead-baseEnv-amd64

COPY script/signforfn.sh /usr/bin/signforfn.sh
#
#    {
#      "packageName": "linux-headers-6.18.18.c788-trim",
#      "version": "6.18.18.c788-trim-788",
#      "url": "https://download.liveupdate.fnnas.com/x86_64/kernel/linux-headers-6.18.18.c788-trim_6.18.18.c788-trim-788_amd64.deb",
#      "sign": "55642068036f969b82b4c866a608801fc41fb1648f17154888b6db8ec26460c2",
#      "size": "8.9M",
#      "dlkey": "NxgGGmkvKxgVPyo4N2c2bDwLFm4=",
#      "installSpace": "10M",
#      "description": "headers"
#    },

ENV BaseURL="https://download.liveupdate.fnnas.com/x86_64/kernel"
ENV PKG="linux-headers-6.18.18.c788-trim_6.18.18.c788-trim-788_amd64.deb"
ENV dlkey="NxgGGmkvKxgVPyo4N2c2bDwLFm4="

RUN wget $(bash -c "/usr/bin/signforfn.sh ${dlkey} ${BaseURL}/${PKG}") -O ${PKG} &&\
    dpkg -i --force-all ${PKG} &&\
    rm -f ${PKG}

ENV fake_uname_a="Linux GreenDamTan 6.18.18.c788-trim #788 SMP PREEMPT_DYNAMIC Fri Jun 12 01:42:14 UTC 2026 x86_64 GNU/Linux"
COPY script/uname /tmp
RUN mv -f /tmp/uname /usr/bin/uname && \
    chmod a+x /usr/bin/uname &&\
    uname -r &&\
    uname -v &&\
    uname -a