FROM bitnami/git:2.37.0-debian-11-r4 as builder1
ENV path="/tmp/noname"
RUN mkdir -p $path &&\
    cd $path &&\
    git init &&\
    git remote add origin https://github.com/libccy/noname.git && \
    # v1.9.114.3.1
    git fetch origin 623971df34c6480737c4fedca3635acb9264c66b &&\
    git reset --hard FETCH_HEAD &&\
    rm -rf $path/.git
FROM nginx:1.21
USER root
LABEL maintainer="GreenDamTan"
LABEL version="v1.9.122.3"
COPY nginx.conf etc/nginx/
COPY conf.d/* etc/nginx/conf.d/
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
    echo "Asia/Shanghai" > /etc/timezone
COPY --from=builder1 /tmp/noname /usr/share/nginx/html