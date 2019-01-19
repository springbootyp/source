## 第一章 Redis安装使用

### NoSQL概述

> NoSQL = not only SQL，即非关系型数据库。随着互联网web2.0（web1.0是由系统向用户展示内容。web2.0就是用户主动获取并产生内容。web3.0是个性化内容的获取）网站的兴起，传统的关系数据库在应付web2.0网站，特别是超大规模和高并发的SNS类型的web2.0纯动态网站已经显得力不从心，暴露了很多难以克服的问题，而非关系型的数据库则由于其本身的特点得到了非常迅速的发展。NoSQL数据库的产生就是为了解决大规模数据集合多重数据种类带来的挑战，尤其是大数据应用难题，包括超大规模数据的存储。

### 传统单机 MySQL 瓶颈

![WX20180909-154453_2x](http://www.znsd.com/znsd/courses/uploads/d9efa1369b88d8399d9c230b0a776236/WX20180909-154453_2x.png)

1. 数据量的总大小，一个机器1放不下，单表数据达到500万时MySQL性能低
2. 数据的索引(B + Tree) 一个机器的内存放不下时
3. 访问量（读写混合）一个实例不能承受

### 为什么需要NoSQL

今天我们可以通过第三方平台（如：Baidu,Google,Facebook等）可以很容易的访问和抓取数据。用户的个人信息，社交网络，地理位置，用户生成的数据和用户操作日志已经成倍的增加。`我们如果要对这些用户数据进行挖掘，那SQL数据库已经不适合这些应用了，`NoSQL数据库的发展能很好的处理这些大数据。和传统的关系型数据库相比，NoSQL具有以下的优势：

- high performance ，高并发读写，动态页面展示与交互，比如微博点赞评论等操作，实时统计在线人数排行榜等
- huge storage，海量数据的高效存储和访问，大型网站的用户登录系统
- high scalability && high availability，高可扩展性和高可用性

### 主流的NoSQL产品有哪些

- redis

> - 优势，快速查询
>
> - 劣势，存储数据缺少结构化

- mongodb

> - 优势，数据结构要求不严格
> - 劣势，查询性能并非特别高，缺少统一查询的语法

### Redis简介

![redis_opt](http://www.znsd.com/znsd/courses/uploads/5fa5ec565e4566db857a266438c2faf1/redis_opt.jpg)

- REmote DIctionary Server(Redis) 是一个由Salvatore Sanfilippo写的key-value存储系统。
- 它是一个开源的使用ANSI C语言编写、支持网络、可基于内存亦可持久化的日志型、Key-Value数据库，并提供多种语言的API。
- Redis通常被称为数据结构服务器，因为值（value）可以是 字符串(String), 哈希(Map), 列表(list), 集合(sets) 和 有序集合(sorted sets)等类型。
- Redis 官网：<https://redis.io/> 
- Redis中文网站：http://www.redis.cn
- Redis 在线测试工具：<http://try.redis.io/> 

### 诞生背景

- 诞生于互联网时代、大数据时代。

- 从2010年3月15日起，Redis的开发工作由VMware主持。从2013年5月开始，Redis的开发由Pivotal赞助。

### Redis 特点

-  Redis支持数据的持久化，可以将内存中的数据保持在磁盘中，重启的时候可以再次加载进行使用。
-  Redis不仅仅支持简单的key-value类型的数据，同时还提供list，set，zset，hash等数据结构的存储。
-  Redis支持数据的备份，即master-slave模式的数据备份。

### Redis的应用场景

- 缓存
- 网站访问统计
- 任务队列
- 数据过期处理
- 应用排行榜
- 分布式集群架构中的session分离

### 安装

- 准备linux环境；

- 官网https://redis.io/ 下载redis4.0.6版本；

- 上传至linux；

- 解压安装，按官网download页面给出的步骤安装；    

下载：

```shell
[root@localhost ~]# cd /usr/local/src/
[root@localhost src]# wget http://download.redis.io/releases/redis-4.0.6.tar.gz
```

解压：

```shell
[root@localhost src]# tar -zxf redis-4.0.6.tar.gz 
[root@localhost src]# ll
total 1688
drwxrwxr-x. 6 root root    4096 Dec  4  2017 redis-4.0.6
-rw-r--r--. 1 root root 1723533 Dec  4  2017 redis-4.0.6.tar.gz
```

编译：

```shell
[root@localhost redis-4.0.6]# make
# 如果编译失败请先下载编译依赖，编译成功不需要执行以下命令
yum install wget make gcc tcl
```

安装：

```shell
# 将redis安装到/usr/local/redis目录
[root@localhost redis-4.0.6]# make PREFIX=/usr/local/redis install
# 进入redis安装目录
[root@localhost redis-4.0.6]# cd /usr/local/redis/bin/
[root@localhost bin]# ll
total 35432
-rwxr-xr-x. 1 root root 5597214 Aug 30 05:34 redis-benchmark
-rwxr-xr-x. 1 root root 8314825 Aug 30 05:34 redis-check-aof
-rwxr-xr-x. 1 root root 8314825 Aug 30 05:34 redis-check-rdb
-rwxr-xr-x. 1 root root 5736370 Aug 30 05:34 redis-cli
lrwxrwxrwx. 1 root root      12 Aug 30 05:34 redis-sentinel -> redis-server
-rwxr-xr-x. 1 root root 8314825 Aug 30 05:34 redis-server
# 如果出现以上文件说明redis安装成功了
```

运行：

```shell
[root@localhost bin]# ./redis-server 
```

使用内置的客户端命令redis-cli进行使用：

```shell
[root@localhost bin]# ./redis-cli
127.0.0.1:6379> set foo bar
OK
127.0.0.1:6379> get foo
"bar"
127.0.0.1:6379> 
```

修改redis配置文件

```shell
# 复制redis.conf文件到/etc目录
[root@localhost redis-4.0.6]# cp /usr/local/src/redis-4.0.6/redis.conf /etc/redis.conf
# 编辑redis.conf文件
[root@localhost ~]# vim /etc/redis.conf 
# 设置redis为后台启动进程，将daemonize no 改为 daemonize yes
daemonize yes 
# 修改绑定的主机地址，将#bind 127.0.0.1改成自己的ip地址，去掉"#"号
bind 192.168.41.22
```

关闭redis服务，重新运行

```shell
[root@localhost bin]# ./redis-cli shutdown
# 重新启动redis加载指定的配置文件
[root@localhost bin]# ./redis-server /etc/redis.conf 
```

将redis-server和redis-cli命令加入环境变量

```shell
vim /etc/proflie
# 在最后一行加入
export PATH=/usr/local/redis/bin:$PATH 
```

使其立即生效

```shell
source /etc/proflie
```

**如果不想手动编辑redis.conf文件可以通过redis提供的服务工具生成**`这部分可以不执行`

```shell
[root@localhost ~]# cd /usr/local/src/redis-4.0.6/utils
[root@localhost utils]# ./install_server.sh 
Welcome to the redis service installer
This script will help you easily set up a running redis server

Please select the redis port for this instance: [6379] 
Selecting default: 6379
Please select the redis config file name [/etc/redis/6379.conf] 
Selected default - /etc/redis/6379.conf
Please select the redis log file name [/var/log/redis_6379.log] 
Selected default - /var/log/redis_6379.log
Please select the data directory for this instance [/var/lib/redis/6379] 
Selected default - /var/lib/redis/6379
Please select the redis executable path [] /usr/local/redis/bin/redis-server
Selected config:
Port           : 6379
Config file    : /etc/redis/6379.conf
Log file       : /var/log/redis_6379.log
Data dir       : /var/lib/redis/6379
Executable     : /usr/local/redis/bin/redis-server
Cli Executable : /usr/local/redis/bin/redis-cli
Is this ok? Then press ENTER to go on or Ctrl-C to abort.
Copied /tmp/6379.conf => /etc/init.d/redis_6379
Installing service...
Successfully added to chkconfig!
Successfully added to runlevels 345!
Starting Redis server...
Installation successful!

# 启动redis
[root@localhost utils]# service redis_6379 start
Starting Redis server...
# 查看redis是否启动
[root@localhost utils]# service redis_6379 status
Redis is running (23804)
# 关闭redis
[root@localhost utils]# service redis_6379 stop
Stopping ...
Redis stopped
```


### Jedis-java访问

java连接Jar

- jedis-2.1.0.jar 
- commons-pool-1.6.jar

maven依赖下载

```xml
<dependency>
  <groupId>redis.clients</groupId>
  <artifactId>jedis</artifactId>
  <version>2.9.0</version>
</dependency>
```

创建项目并测试

```java
public static void main(String[] args) {
    Jedis jedis = null;
    try {
        jedis = new Jedis("192.168.41.22", 6379);
        // 连接测试
        System.out.println(jedis.ping());
        //设置 redis 字符串数据
        jedis.set("znsdkey", "www.znsd.com");
        // 获取存储的数据并输出
        System.out.println("redis 存储的字符串为: "+ jedis.get("znsdkey"));
    } finally {
        if (jedis != null) {
            jedis.close();
        }
    }
}
```


注：若出现连接失败异常请关闭linux防火墙

```shell
# 查看系统版本
cat /etc/redhat-release

# 产看防火墙
service iptables status

# 停止防火墙
service iptables stop

# 启用防火墙
service iptables start
```

### 基本命令

- redis所有命令可参考http://redisdoc.com网站

```shell
set key value 赋值
```

```shell
get key 取值
```

```shell
select index 切换库(下标从0开始)
```

```shell
dbsize 查看当前库key的数据
```

```shell
flushdb 清空当前库
```

```shell
flushall 清空所有库
```

```shell
keys * 查看所有key (keys后面参数可以用表达式代替)
 	?    匹配一个字符
    *    匹配任意个（包括0个）字符
    []   匹配括号间的任一个字符，可以使用 "-" 符号表示一个范围，如 a[b-d] 可以匹配 "ab","ac","ad"
    \x   匹配字符x，用于转义符号，如果要匹配 "?" 就需要使用 \?
```

```shell
exists key  判断一个键值是否存在(如果存在，返回整数类型 1 ，否则返回 0)
```

```shell
del key [key.....] 可以删除一个或多个键，返回值是删除的键的个数
```

```shell
type key 返回值可能是 string(字符串类型) hash(散列类型) list(列表类型) set(集合类型) zset(有序集合类型)
```

```shell
move key db 当前库就没有了，被移除了
```

```shell
expire key time(秒) 为给定的key设置过期时间
```

```shell
ttl key 查看还有多少秒过期，-1表示永不过期，-2表示已过期
```