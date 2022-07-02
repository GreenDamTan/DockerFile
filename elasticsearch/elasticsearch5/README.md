# **elasticsearch5**

### 碎碎念

我知道，**elasticsearch5**这玩意是真的旧。但确实有在用这玩意的。

这个repo中的是作为单节点master运行的。集群的话得改配置，不过也没人用这么旧的东西搭集群吧。

相关的config在 [这里](https://github.com/GreenDamTan/DockerFile/tree/main/elasticsearch/elasticsearch5/opt/bitnami/elasticsearch/config) 可以自行调整修改。想搞成集群也不是不行，测试而已没必要。

### 改动点

更换时区为“中国/上海”

更换jdk为ibm-semeru-runtimes:open-8u332-b09-jdk-focal，减少内存使用，不过es走-Xmx的内存一定打满的

更换默认运行用户为root，顺便说一句新版es不允许root运行，这个版本还是可以的

安装插件elasticsearch-sql，不得不说这玩意真的是好用 "http://127.0.0.1:9200/_sql?sql=select%20*%20from%20%20xxxxxxxxx*" 这样就能查数据了，用sql语句哦！不过不支持distinct之类的。

### dockerhub

dockerhub在https://hub.docker.com/r/makedie/elasticsearch/tags