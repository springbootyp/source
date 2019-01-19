## CentOS6 源码安装 Redis

1、检查安装依赖程序

```shell
yum install gcc-c++
yum install -y tcl
yum install wget
```

2、获取安装文件或点击[下载](http://www.znsd.com/znsd/courses/uploads/95de8741b251b7ae69615e6a59059974/redis-stable.tar.gz)

```shell
wget http://download.redis.io/releases/redis-stable.tar.gz
```

3、解压文件

```shell
tar -xzvf redis-stable.tar.gz
mv redis-stable /usr/local/redis
```

4、进入目录

```shell
cd /usr/local/redis
```

5、编译安装

```shell
make
make install
```

6、设置配置文件路径

```shell
mkdir -p /etc/redis
cp redis.conf/etc/redis
```

7、修改配置文件

```shell
vi /etc/redis/redis.conf
仅修改： daemonize yes （no-->yes）
```

8、启动

```shell
/usr/local/bin/redis-server /etc/redis/redis.conf
```

9、查看启动

```shell
ps -ef | grep redis 
```

10、使用客户端

```shell
redis-cli
>set name david
OK
>get name
"david"
```

11.关闭客户端

```shell
redis-cli shutdown
```

12、开机启动配置

```shell
echo "/usr/local/bin/redis-server /etc/redis/redis.conf &" >> /etc/rc.local
```

开机启动要配置在 `rc.local` 中，而 `/etc/profile` 文件，要有用户登录了，才会被执行。