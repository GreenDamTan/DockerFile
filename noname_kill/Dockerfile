FROM bitnami/git:2.37.0-debian-11-r4 as builder1
ENV path="/tmp/noname"
RUN mkdir -p $path &&\
    cd $path &&\
    git init &&\
    git remote add origin https://github.com/libccy/noname.git && \
    # v1.10.15.1
    git fetch origin aac337d9af8913795928d7d66abf4967a0bfda71 &&\
    git reset --hard FETCH_HEAD &&\
    rm -rf $path/.git
FROM nginx:1.21
USER root
LABEL maintainer="GreenDamTan"
LABEL version="v1.10.15.1"
COPY --from=builder1 /tmp/noname /usr/share/nginx/html
COPY nginx.conf /etc/nginx/
COPY conf.d/* /etc/nginx/conf.d/
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
    echo "Asia/Shanghai" > /etc/timezone
#CMD ["/usr/sbin/nginx","-c","/etc/nginx/nginx.conf"] \
CMD ["/usr/sbin/nginx"]