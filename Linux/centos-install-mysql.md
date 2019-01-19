## Linux CentOS6.9下编译安装MySQL 5.6.39

### 一、编译安装MySQL前的准备工作

​    安装编译源码所需的工具和库

```shell
yum install make cmake gcc gcc-c++ bison-devel ncurses-devel autoconf automake
```

### 二、设置MySQL用户和组

​    新增mysql用户组

```shell
groupadd mysql
```

​    新增mysql用户

```shell
useradd -r -g mysql mysql
```

### 三、新建MySQL所需要的目录

​    新建mysql安装目录

```shell
mkdir -p /usr/local/mysql
```

新建mysql数据库数据文件目录

```shell
mkdir -p /data/mysqldb
```

### 四、下载MySQL源码包并解压

```shell
wget  http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.39.tar.gz 
tar -zxv -f mysql-5.6.39.tar.gz 
cd mysql-5.6.39
```

### 五、编译安装MySQL

（mysql从5.5版本开始，不再使用./configure编译，而是使用cmake编译器，具体的cmake编译参数可以参考mysql官网文档<http://dev.mysql.com/doc/refman/5.5/en/source-configuration-options.html>

```shell
cmake \

-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \

-DMYSQL_UNIX_ADDR=/usr/local/mysql/mysql.sock \

-DDEFAULT_CHARSET=utf8 \

-DDEFAULT_COLLATION=utf8_general_ci \

-DWITH_MYISAM_STORAGE_ENGINE=1 \

-DWITH_INNOBASE_STORAGE_ENGINE=1 \

-DWITH_ARCHIVE_STORAGE_ENGINE=1 \

-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \

-DWITH_MEMORY_STORAGE_ENGINE=1 \

-DWITH_READLINE=1 \

-DENABLED_LOCAL_INFILE=1 \

-DMYSQL_DATADIR=/data/mysqldb \

-DMYSQL_USER=mysql \

-DMYSQL_TCP_PORT=3306 \

-DENABLE_DOWNLOADS=1

```

| CMAKE_INSTALL_PREFIX=dir_name                                | 设置mysql安装目录                                            |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| -DMYSQL_UNIX_ADDR=file_name                                  | 设置监听套接字路径，这必须是一个绝对路径名。默认为/tmp/mysql.sock |
| -DDEFAULT_CHARSET=charset_name                               | 设置服务器的字符集。 缺省情况下，MySQL使用latin1的（CP1252西欧）字符集。cmake/character_sets.cmake文件包含允许的字符集名称列表。 |
| -DDEFAULT_COLLATION=collation_name                           | 设置服务器的排序规则。                                       |
| -DWITH_INNOBASE_STORAGE_ENGINE=1  -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1  -DWITH_PERFSCHEMA_STORAGE_ENGINE=1 | 存储引擎选项：  MyISAM，MERGE，MEMORY，和CSV引擎是默认编译到服务器中，并不需要明确地安装。  静态编译一个存储引擎到服务器，使用-DWITH_engine_STORAGE_ENGINE= 1  可用的存储引擎值有：ARCHIVE, BLACKHOLE, EXAMPLE, FEDERATED, INNOBASE (InnoDB), PARTITION (partitioning support), 和PERFSCHEMA (Performance Schema) |
| -DMYSQL_DATADIR=dir_name                                     | 设置mysql数据库文件目录                                      |
| -DMYSQL_TCP_PORT=port_num                                    | 设置mysql服务器监听端口，默认为3306                          |
| -DENABLE_DOWNLOADS=bool                                      | 是否要下载可选的文件。例如，启用此选项（设置为1），cmake将下载谷歌所使用的测试套件运行单元测试。 |

`注：重新运行配置，需要删除CMakeCache.txt文件`

编译源码

```shell
make
```

​     安装

```shell
make install
```

### 六、修改mysql目录所有者和组

​    修改mysql安装目录 

```shell
cd /usr/local/mysql 
chown -R mysql:mysql .
```

​    修改mysql数据库文件目录

```shell
cd /data/mysqldb 
chown -R mysql:mysql .
```

### 七、初始化mysql数据库

```shell
cd /usr/local/mysql 
scripts/mysql_install_db --user=mysql --datadir=/data/mysqldb
```

### 八、复制mysql服务启动配置文件

```shell
cp /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf
```

### 九、复制mysql服务启动脚本

```shell
cp support-files/mysql.server /etc/init.d/mysqld
```

### 十、把mysql加入PATH路径

```shell
vi /etc/profile 
PATH=/usr/local/mysql/bin:/usr/local/mysql/lib:$PATH
export PATH
```

```
source /etc/profile
```

### 十一、启动mysql服务

```shell
service mysqld start 
Starting MySQL.. SUCCESS!
```

### 十二、检查mysql服务是否启动

```shell
 netstat -tnl|grep 3306
 mysql -u root -p
```

**密码为空，如果能登陆上，则安装成功。**

### 十三、修改MySQL用户root的密码

```mysql
mysqladmin -u root password '123456'
```

### 十四、允许mysql远程登录

```mysql
GRANT ALL PRIVILEGES ON *.* TO root@"%" IDENTIFIED BY "123456"; 
flush privileges;
```

**十五、创建指定权限的用户**

```mysql
grant select,insert,update,delete on *.* to test1@"%" Identified by "abc";  
```

**十六、分配指定权限给指定用户访问数据库**

```mysql
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, CREATE TEMPORARY TABLES, DROP, INDEX, ALTER, LOCK TABLES, REFERENCES ON `databaseName`.* TO 'user'@'192.168.41.21';
```

**十七、刷新权限**

```mysql
FLUSH PRIVILEGES;
```

