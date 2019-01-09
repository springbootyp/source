# Node js Liunx 安装

### 4.3.1 Centos部署node.js

（1）将node官网下载的node-v8.11.1-linux-x64.tar.xz 上传至服务器

（2）解压xz文件

```
xz -d node-v8.11.1-linux-x64.tar.xz

```

（3）解压tar文件

```
tar -xvf node-v8.11.1-linux-x64.tar
```

（4）目录重命名

```
mv node-v8.11.1-linux-x64 node
```

（5）移动目录到/usr/local下

```
mv node /usr/local/
```

（6）配置环境变量

```
vi /etc/profile
```

填写以下内容

```
#set for nodejs  
export NODE_HOME=/usr/local/node  
export PATH=$NODE_HOME/bin:$PATH
```

执行命令让环境变量生效

```
source /etc/profile

```

查看node版本看是否安装成功

```
node -v
```

### 