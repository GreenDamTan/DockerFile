FROM makedie/fnos:kernHead-baseEnv-amd64

COPY script/signforfn.sh /usr/bin/signforfn.sh
#    {
#      "packageName": "linux-headers-6.18.18.c952-trim",
#      "version": "6.18.18.c952-trim-952",
#      "url": "https://download.liveupdate.fnnas.com/x86_64/kernel/linux-headers-6.18.18.c952-trim_6.18.18.c952-trim-952_amd64.deb",
#      "sign": "092740cc176c82cde0d098f4658930ff6252377fab28f60e4ebd249788414def",
#      "size": "8.9M",
#      "dlkey": "NxgGGmkvKxgVPyo4N2c2bDwLFm4=",
#      "installSpace": "10M",
#      "description": "headers"
#    },

ENV BaseURL="https://download.liveupdate.fnnas.com/x86_64/kernel"
ENV PKG="linux-headers-6.18.18.c952-trim_6.18.18.c952-trim-952_amd64.deb"
ENV dlkey="NxgGGmkvKxgVPyo4N2c2bDwLFm4="

RUN wget $(bash -c "/usr/bin/signforfn.sh ${dlkey} ${BaseURL}/${PKG}") -O ${PKG} &&\
    dpkg -i --force-all ${PKG} &&\
    rm -f ${PKG}

ENV fake_uname_a="Linux GreenDamTan 6.18.18.c952-trim #952 SMP PREEMPT_DYNAMIC Tue Jul 21 07:39:35 UTC 2026 x86_64 GNU/Linux"
COPY script/uname /tmp
RUN mv -f /tmp/uname /usr/bin/uname && \
    chmod a+x /usr/bin/uname &&\
    uname -r &&\
    uname -v &&\
    uname -a
