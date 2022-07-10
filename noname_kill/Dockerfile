FROM bitnami/git:2.37.0-debian-11-r4 as builder1
ENV path="/tmp/noname"
RUN mkdir -p $path &&\
    cd $path &&\
    git init &&\
    git remote add origin https://github.com/libccy/noname.git && \
    # v1.9.114.3.1
    git fetch origin db168ea5e03e6200ab94ed5dceaf4b114066ac1f &&\
    git reset --hard FETCH_HEAD
FROM nginx:1.21
USER root
LABEL maintainer="GreenDamTan"
COPY nginx.conf etc/nginx/
COPY conf.d/* etc/nginx/conf.d/
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
    echo "Asia/Shanghai" > /etc/timezone
COPY --from=builder1 /tmp/noname /usr/share/nginx/html