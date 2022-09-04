FROM debian:bullseye-20220822 as builder1
RUN sed -i 's|^deb http://ftp.debian.org|deb https://mirrors.ustc.edu.cn|g' /etc/apt/sources.list &&\
    sed -i 's|^deb http://security.debian.org|deb https://mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list &&\
    sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list &&\
    sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list
COPY systemctl3.py /usr/bin/systemctl
RUN chmod +x /usr/bin/systemctl &&\
    apt update &&\
    apt install -y wget python3 &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*
CMD /usr/bin/systemctl&&bash