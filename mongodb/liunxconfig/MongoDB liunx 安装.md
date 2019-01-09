# MongoDB liunx 安装

### Linux下安装：

##### 下载：

```
curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.0.6.tgz
```

##### 解压：

```
tar -zxvf mongodb-linux-x86_64-3.0.6.tgz
```

 将解压包拷贝到指定目录

```
mv  mongodb-linux-x86_64-3.0.6/ /usr/local/mongodb
```

##### 配置path

 在/etc/profile文件中添加path

```
export PATH=<mongodb-install-directory>/bin:$PATH
```

##### 创建数据库目录

```
mkdir -p /data/db
/data/db 是 MongoDB 默认的启动的数据库路径(--dbpath)
```

##### 运行 MongoDB

```
$ ./mongod	-f mongod.conf(可以指定配置文件)
```

##### MongoDB Shell

```
进入到安装的bin目录执行
./mongo	查询库 show dbs
```

#### MongoDB.Conf

```java
bind_ip_all=true
port = 27017                        # 实例运行在27017端口（默认）
dbpath = /znsd/mongodb/mongodb-linux-x86_64-4.0.4/data/db      # 数据文件夹存放地址（db要预先创建）
logpath = /znsd/mongodb/mongodb-linux-x86_64-4.0.4/mongodb.log    # 日志文件地址
logappend = true                   # 启动时 添加还是重写日志文件
auth = false
fork = true
oplogSize=2048
```

