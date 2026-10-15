FROM makedie/fnos:kernHead-baseEnv-amd64

COPY script/signforfn.sh /usr/bin/signforfn.sh
#    {
#      "packageName": "linux-headers-6.18.18.c1168-trim",
#      "version": "6.18.18.c1168-trim-1168",
#      "url": "https://download.liveupdate.fnnas.com/x86/kernel/linux-headers-6.18.18.c1168-trim_6.18.18.c1168-trim-1168_amd64.deb",
#      "sign": "af3f58725ffa8f45889ef84fc9c4b77953f06e21e9f31defaeac8ef08916ef85",
#      "size": "9.08M",
#      "dlkey": "NxgGGmkvKxgVPyo4N2c2bDwLFm4=",
#      "installSpace": "10M",
#      "description": "linux-headers"
#    },

ENV BaseURL="https://download.liveupdate.fnnas.com/x86/kernel"
ENV PKG="linux-headers-6.18.18.c1168-trim_6.18.18.c1168-trim-1168_amd64.deb"
ENV dlkey="NxgGGmkvKxgVPyo4N2c2bDwLFm4="

RUN wget $(bash -c "/usr/bin/signforfn.sh ${dlkey} ${BaseURL}/${PKG}") -O ${PKG} &&\
    dpkg -i ${PKG} &&\
    test -f /lib/modules/6.18.18.c1168-trim/build/Makefile &&\
    rm -f ${PKG}

ENV fake_uname_a="Linux GreenDamTan 6.18.18.c1168-trim #1168 SMP PREEMPT_DYNAMIC Tue Oct 13 11:20:25 UTC 2026 x86_64 GNU/Linux"
COPY script/uname /tmp
RUN mv -f /tmp/uname /usr/bin/uname && \
    chmod a+x /usr/bin/uname &&\
    uname -r &&\
    uname -v &&\
    uname -a
