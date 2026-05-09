FROM makedie/fnos:kernHead-baseEnv-amd64

COPY script/signforfn.sh /usr/bin/signforfn.sh

#    {
#      "packageName": "linux-headers-6.18.18-trim",
#      "version": "6.18.18-trim-570",
#      "url": "https://download.liveupdate.fnnas.com/x86_64/kernel/linux-headers-6.18.18-trim_6.18.18-trim-570_amd64.deb",
#      "sign": "f8f64dec66c70a8ba1540b04bd165615eab79f646210ddbfb15eddf06bcdb8fb",
#      "size": "8.9M",
#      "dlkey": "NxgGGmkvKxgVPyo4N2c2bDwLFm4=",
#      "installSpace": "10M",
#      "description": "headers"
#    },

ENV BaseURL="https://download.liveupdate.fnnas.com/x86_64/kernel"
ENV PKG="linux-headers-6.18.18-trim_6.18.18-trim-570_amd64.deb"
ENV dlkey="NxgGGmkvKxgVPyo4N2c2bDwLFm4="

RUN wget $(bash -c "/usr/bin/signforfn.sh ${dlkey} ${BaseURL}/${PKG}") -O ${PKG} &&\
    dpkg -i --force-all ${PKG} &&\
    rm -f ${PKG}

ENV fake_uname_a="Linux GreenDamTan 6.18.18-trim #570 SMP PREEMPT_DYNAMIC Fri May  8 07:07:34 UTC 2026 x86_64 GNU/Linux"
COPY script/uname /tmp
RUN mv -f /tmp/uname /usr/bin/uname && \
    chmod a+x /usr/bin/uname &&\
    uname -r &&\
    uname -v &&\
    uname -a