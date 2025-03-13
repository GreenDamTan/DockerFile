FROM ibm-semeru-runtimes:open-17.0.14_7-jdk-focal as jre-build
RUN jlink \
         --add-modules ALL-MODULE-PATH \
         --no-man-pages \
         --compress=2 \
         --output /javaruntime

FROM jenkins/jenkins:2.492.2-lts-jdk17
LABEL GreenDamTan="GreenDamTan"
LABEL maintainer="github.com/GreenDamTan"
LABEL git="github.com/GreenDamTan/DockerFile"
# 不安全环境需要在后面再把root去掉，安全环境没必要
USER root
# 减少安装包体检
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-custom && \
    echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-custom
# 改改时区，不需要的可以去掉
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone
RUN rm -rf $JAVA_HOME/*
COPY --from=jre-build /javaruntime $JAVA_HOME
ENV LC_ALL=C.UTF-8 LANGUAGE=C.UTF-8 LANG=C.UTF-8
# 需要限制内存可以加-Xmx1024m
# -Xmx1024m 限制内存 -Xtune:virtualized 虚拟化环境优化 -Xshareclasses
ENV JAVA_OPTS="$JAVA_OPTS -Xtune:virtualized -Xshareclasses -Dhudson.model.DownloadService.noSignatureCheck=true"
# 更换软件源就看需要不需要了
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources && \
    sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list.d/debian.sources &&\
    sed -i 's/http:/https:/g' /etc/apt/sources.list.d/debian.sources
# 安装busybox提供bash脚本诸如“[[]]”等写法的支持
# 安装vim供文本编辑
RUN apt-get clean &&\
    apt-get update && \
    apt-get --no-install-recommends install -y busybox vim &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* &&\
    busybox --install
# RUN rm -f /etc/apt/apt.conf.d/00-custom