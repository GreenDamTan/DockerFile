FROM bitnami/git:2.37.0-debian-11-r4 as builder1
ENV path="/tmp/noname"
RUN mkdir -p $path &&\
    cd $path &&\
    #git init &&\
    #git remote add origin https://github.com/libnoname/noname.git && \
    # v1.10.17.1
    #git fetch origin d8ac61bba9435f56de06ce83c29f7ea65f83eb4e &&\
    #git reset --hard FETCH_HEAD &&\
    git clone --depth 1 https://github.com/libnoname/noname.git &&\
    rm -rf $path/.git
FROM nginx:1.27.4
USER root
LABEL maintainer="GreenDamTan"
LABEL version="v1.10.17.1"
COPY --from=builder1 /tmp/noname/* /usr/share/nginx/html
RUN sed -e "s/return alert(globalText.SERVICE_WORKER_NOT_SUPPORT);//g" -i /usr/share/nginx/html/game/game.js
COPY nginx.conf /etc/nginx/
COPY conf.d/* /etc/nginx/conf.d/
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
    echo "Asia/Shanghai" > /etc/timezone
#CMD ["/usr/sbin/nginx","-c","/etc/nginx/nginx.conf"] \
CMD ["/usr/sbin/nginx"]