# Jenkins

本镜像基于[jenkins/jenkins](https://hub.docker.com/r/jenkins/jenkins)进行个性化定制

更换了原始的jdk为[ibm-semeru-runtimes](https://hub.docker.com/_/ibm-semeru-runtimes)的openj9减少内存使用

修改时区为“中国/上海”，默认运行用户为root规避权限问题

添加了busybox、vim软件包

vim这玩意懂得都懂，连进容器改配置的大有人在，没这玩意会挨骂的。什么垃圾容器连个编辑器都没有！

busybox这玩意是用来支持一些shell的写法，比如说if [[ true == false]]之类的。

启动命令示例为

```shell
docker run -d -v jenkins_home:/var/jenkins_home -p 8080:8080 -p 50000:50000 --restart=on-failure makedie/jenkins:2.346.1-lts-jdk-11.0.11_9-openj9-0.26.0
```

jenkins_home应改为具体的宿主机目录，你喜欢的话比如"/var/jenkins_home"这样也行

具体的tag应根据hub中自行选择，不应使用空或latest，应如上述"2.346.1-lts-jdk-11.0.11_9-openj9-0.26.0"显式指定

推荐使用lts版本的Jenkins，与jdk11搭配使用，也提供了"2.346.1-lts-jdk-17.0.3_7-openj9-0.32.0"使用jdk17的，但不推荐使用

其他没啥特别的了，可以参考[Jenkins官方的镜像文档](https://github.com/jenkinsci/docker/blob/master/README.md)

有啥想整的欢迎提[issues](https://github.com/GreenDamTan/DockerFile/issues)

### 路标

https://hub.docker.com/repository/docker/makedie/jenkins/tags

https://github.com/GreenDamTan/DockerFile/tree/main/Jenkins