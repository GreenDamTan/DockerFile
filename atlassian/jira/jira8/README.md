# jira 8

### 碎碎念

不得不说这玩意正常用的话坑一大堆，果然atlassian出品的玩意都挺可怕的

这东西更换openj9的感知极大，不信可以自己对比

有啥想整的欢迎提[issues](https://github.com/GreenDamTan/DockerFile/issues)

### 改动点

修改时区为"中国/上海"

修改运行用户为root

安装了atlassian-agent.jar插件

安装了mysql-connector-java-5.1.49-bin.jar插件，连mysql5用的，我没用到其他数据库就先只塞这个了

### 和谐！

安装过程中到了你懂的那一步

进容器里头跑一下，ABCD-1234-EFGH-5678换成你的那个

```
java -jar /opt/atlassian/jira/atlassian-agent.jar -p jira -m aaa@bbb.com -n my_name -o http://jiraIp:port -s ABCD-1234-EFGH-5678
```

然后就有码可以和谐了

### 路标

https://hub.docker.com/r/makedie/jira-software/tags

https://github.com/GreenDamTan/DockerFile/tree/main/atlassian/jira/jira8