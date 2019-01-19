## 安装Memcached

[Memcached](http://memcached.org/)是一个高性能的分布式缓存系统，进入[下载页面](http://memcached.org/downloads)下载最新稳定版本。或者，可以通过`wget`下载：

```shell
# wget http://memcached.org/latest
```

安装Memcached之前，需要安装libevent-devel依赖：

```shell
# yum -y install libevent-devel
```

解压并安装：

```shell
# tar -zxvf memcached-1.x.x.tar.gz
# cd memcached-1.x.x
# ./configure && make && make test && sudo make install
```

启动`memcached`运行命令：

```shell
# memcached -d -uroot -m 1024 -P /var/memcached/run/memcached.pid
```

这里`-d`参数表示开启守护线程，`-u`参数指定用户，`-m`参数指定分配给`memcached`的内存大小。更多启动参数如下：

```shell
-d 选项是启动一个守护进程
-m 是分配给Memcache使用的内存数量，单位是MB，这里是1024MB，默认是64MB
-u 是运行Memcache的用户，这里是root
-l 是监听的服务器IP地址，默认应该是本机
-p 是设置Memcache监听的端口，默认是11211，最好是1024以上的端口
-c 选项是最大运行的并发连接数，默认是1024，这里设置了10240，按照你服务器的负载量来设定
-P 是设置保存Memcache的pid文件位置
-h 打印帮助信息
-v 输出警告和错误信息
-vv 打印客户端的请求和返回信息
```

查看端口状态：

```shell
[root@chenllcentos bin]# netstat -ntlp | grep memcached
tcp        0      0 0.0.0.0:11211               0.0.0.0:*                   LISTEN      2222/memcached      
tcp        0      0 :::11211                    :::*                        LISTEN      2222/memcached      

```

在集群环境中，Tomcat需要访问缓存服务器读取并更新Session信息，因此缓存服务器需要对`11211`端口放行：

```shell
# vi /etc/sysconfig/iptables
```

添加如下内容：

```shell
# 放行Memcached端口
-A INPUT -m state --state NEW -m tcp -p tcp --dport 11211 -j ACCEPT
```

重启`iptables`：

```shell
# service iptables restart
```

停止`memcached`通过`kill`命令：

```shell
# kill `cat /var/memcached/run/memcached.pid`
```