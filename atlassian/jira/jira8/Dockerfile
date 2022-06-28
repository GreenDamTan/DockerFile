FROM adoptopenjdk:11.0.11_9-jdk-openj9-0.26.0-focal as jre-build
RUN jlink \
         --add-modules ALL-MODULE-PATH \
         --no-man-pages \
         --compress=2 \
         --output /javaruntime

FROM atlassian/jira-software:8.22.4-ubuntu-jdk11
USER root
LABEL GreenDamTan="GreenDamTan"
# 时区不改浑身不爽
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone
ENV TZ="Asia/Shanghai"
# java -jar /opt/atlassian/jira/atlassian-agent.jar -p jira -m aaa@bbb.com -n my_name -o http://jiraIp:port -s ABCD-1234-EFGH-5678
COPY atlassian-agent.jar /opt/atlassian/jira/
# 用于连接mysql5数据库
COPY mysql-connector-java-5.1.49-bin.jar /opt/atlassian/jira/atlassian-jira/WEB-INF/lib/
RUN echo 'export CATALINA_OPTS="-javaagent:/opt/atlassian/jira/atlassian-agent.jar ${CATALINA_OPTS}"' >> /opt/atlassian/jira/bin/setenv.sh
# 测试环境内存小，换个阳间一点的jdk
RUN rm -rf $JAVA_HOME/*
COPY --from=jre-build /javaruntime $JAVA_HOME