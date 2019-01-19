## 第一章 Linux下载安装RabbitMQ

### Erlnag安装 

#### 安装Erlang版本要求

- Erlang安装需要对应各自的版本http://www.rabbitmq.com/which-erlang.html

  ![20180817165302](http://www.znsd.com/znsd/courses/uploads/d1fe15ce79495bdc666503d2443f77c2/20180817165302.png)

#### Erlang安装 

**1.目录准备** 

```shell
cd /usr/local/src/
mkdir rabbitmq
cd rabbitmq
```

**2.添加仓库地址** 

为了减少安装的错误我们使用yum仓库安装,类似于maven

```shell
vi /etc/yum.repos.d/rabbitmq-erlang.repo
```

 CentOS 7: 

```shell
[bintray-rabbitmq-server]
name=bintray-rabbitmq-rpm
baseurl=https://dl.bintray.com/rabbitmq/rpm/rabbitmq-server/v3.7.x/el/7/
gpgcheck=0
repo_gpgcheck=0
enabled=1
```

CentOS 6:

```shell
[bintray-rabbitmq-server]
name=bintray-rabbitmq-rpm
baseurl=https://dl.bintray.com/rabbitmq/rpm/rabbitmq-server/v3.7.x/el/6/
gpgcheck=0
repo_gpgcheck=0
enabled=1
```

**3.安装erlang** 

```shell
sudo yum install erlang
```

![20180817170007](http://www.znsd.com/znsd/courses/uploads/a593397b87887b5a9f70299ccdba4944/20180817170007.png)

**4.安装验证**

```shell
erl
```

![20180817170157](http://www.znsd.com/znsd/courses/uploads/ceea710578d750f4f3c0d1f293173815/20180817170157.png)

### 安装RabbitMQ

- 去官网下载RabbitMQ安装的版本http://www.rabbitmq.com/install-rpm.html RabbitMQ-Server使用是分linux版本的,我们可以使用cat /etc/issue或者cat /etc/redhat-release命令查看linux版本

```shell
[root@localhost rabbitmq]# cat /etc/issue
CentOS release 6.9 (Final)
Kernel \r on an \m
```

![20180817170538](http://www.znsd.com/znsd/courses/uploads/4ff8af00400c2fd4142e3c8973367209/20180817170538.png)

- [下载](https://dl.bintray.com/rabbitmq/all/rabbitmq-server/3.7.2/rabbitmq-server-3.7.2-1.el6.noarch.rpm)并通过ftp工具上传到rabbitmq目录

- 安装RabbitMQ

  ```shell
  rpm --import https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc
  yum -y install rabbitmq-server-3.7.7-1.el6.noarch.rpm
  ```

  ![20180817173006](http://www.znsd.com/znsd/courses/uploads/dbc90f24a5cf0837fdb0ee4ff3792e13/20180817173006.png)

- 启动/停止RabbitMQ命令

  ```shell
  service rabbitmq-server start
  service rabbitmq-server stop
  service rabbitmq-server restart
  ```

- 启动成功

  ```shell
  [root@localhost rabbitmq]# service rabbitmq-server start
  Starting rabbitmq-server: SUCCESS
  rabbitmq-server.
  ```

- 设置开机启动

  ```shell
  chkconfig rabbitmq-server on
  ```

- 设置配置文件

  ```shell
  cd /etc/rabbitmq/
  cp /usr/share/doc/rabbitmq-server-3.7.7/rabbitmq.config.example /etc/rabbitmq/
  mv rabbitmq.config.example rabbitmq.config
  ```

- 开启远程用户访问`注意要去掉后面的逗号。`

  ```shell
  vim /etc/rabbitmq/rabbitmq.config
  ## 将 %%{loopback_users, []},
  ## 改成 {loopback_users, []}
  ```

- 开启web界面管理工具

  ```shell
  rabbitmq-plugins enable rabbitmq_management
  service rabbitmq-server restart
  ```

- 输入ip地址加端口号（15672）访问

  ![20180817173932](http://www.znsd.com/znsd/courses/uploads/f39e020695f7425f3eec4e8471ebacbb/20180817173932.png)

- 登录RabbitMQ，默认用户命和密码为`guest`

  ![20180817174041](http://www.znsd.com/znsd/courses/uploads/e3859373eda9642eec16e7df3f2a49d1/20180817174041.png)

- 如果访问不了请关闭Linux防火墙

  ```shell
  service iptables stop
  ```

### 设置RabbitMQ远程ip登录（可选）

由于账号guest具有所有的操作权限，并且又是默认账号，出于安全因素的考虑，guest用户只能通过localhost登陆使用，并建议修改guest用户的密码以及新建其他账号管理使用rabbitmq。这里我们以创建个test帐号，密码123456为例，创建一个账号并支持远程ip访问

- 创建账号

```shell
rabbitmqctl add_user test 123456
```

- 设置用户角色

```shell
rabbitmqctl  set_user_tags  test  administrator
```

- 设置用户权限

```shell
rabbitmqctl set_permissions -p "/" test ".*" ".*" ".*"
```

- 设置完成后可以查看当前用户和角色(需要开启服务)

```shell
rabbitmqctl list_users
```

这是你就可以通过其他主机的访问RabbitMQ的Web管理界面了，访问方式，浏览器输入：`serverip:15672`。其中serverip是RabbitMQ-Server所在主机的ip。