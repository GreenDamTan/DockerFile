FROM ibm-semeru-runtimes:open-8u332-b09-jdk-focal as builder1

FROM bitnami/elasticsearch:5.6.16
USER root
LABEL GreenDamTan="GreenDamTan"
#置换jdk
RUN rm -rf /opt/bitnami/java/*
COPY --from=builder1 /opt/java/openjdk/ /opt/bitnami/java/
#配置
COPY opt/bitnami/elasticsearch/config/* /opt/bitnami/elasticsearch/config/
COPY elasticsearch-sql-5.6.16.0.zip /tmp/
# 安装插件启用_sql接口
RUN chmod -R a+rw /opt/bitnami/elasticsearch/config && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    elasticsearch-plugin install file:///tmp/elasticsearch-sql-5.6.16.0.zip