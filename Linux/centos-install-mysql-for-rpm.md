## CentOS6.9下RPM方式安装mysql5.6.41

**1、mysql下载**

下载地址：https://dev.mysql.com/downloads/mysql/5.6.html 下载以下安装包（[本地下载](http://www.znsd.com/znsd/courses/uploads/3efdb78cd2fda330219a52b4ecbf8211/MySQL-server-5.6.41.zip)）：

```shell
MySQL-client-5.6.41-1.el6.x86_64.rpm
MySQL-devel-5.6.41-1.el6.x86_64.rpm
MySQL-server-5.6.41-1.el6.x86_64.rpm
```

**2、查看是否已经安装了mysql，有则移除**

```shell
rpm -qa|grep -i mysql
mysql-libs-5.1.66-2.el6_3.x86_64
yum -y remove mysql-libs*
```

**3、安装mysql5.6**

```shell
rpm -ivh MySQL-client-5.6.41-1.el6.x86_64.rpm
rpm -ivh MySQL-devel-5.6.41-1.el6.x86_64.rpm
rpm -ivh MySQL-server-5.6.41-1.el6.x86_64.rpm
cp /usr/share/mysql/my-default.cnf /etc/my.cnf
```

**4、初始化MySQL及设置密码**

```shell
/usr/bin/mysql_install_db
service mysql start
cat /root/.mysql_secret
mysql -uroot -p初始密码
set PASSWORD=PASSWORD('123456')；
exit
```

**5、开启远程访问**

```powershell
mysql -uroot -p123456
use mysql;
update user set password=password('123456') where user='root';
update user set host='%' where user='root' and host='localhost';
flush privileges;
exit
```

**6、设置开机自启动**

```shell
chkconfig mysql on
```

**7、优化my.cnf配置**

```shell
vim /etc/my.cnf
[mysqld]
port = 3306
default-storage-engine = InnoDB 
lower_case_table_names = 1 
max-connections=3000
character_set_server=utf8
[mysql] 
default-character-set=utf8
```