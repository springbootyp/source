## CentOS6 安装jdk配置环境变量

1、解压或安装jdk

```shell
tar zxf jdk-8u181-linux-x64.tar.gz
mv jdk1.8.0_181 /usr/local/java
```

2、配置环境变量

```shell
vim /etc/profile
```

```shell
export JAVA_HOME=/usr/local/java
export JRE_HOME=/usr/local/java/jre
export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib:CLASSPATH
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH
```

3、重新加载环境变量

```shell
source /etc/profile
```