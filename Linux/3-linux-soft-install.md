## 第三章   Linux的软件安装

###  本章目标

- Linux的挂载命令
- Linux的磁盘管理
- Linux中的软件安装

### 挂载

- 在Linux中，如果需要使用外接的硬盘，U盘，光盘或者一些其他的存储设备等，都需要进行挂载，挂载就是将硬件设备挂载到指定的目录下。
- 挂载命令：mount

> 如果直接输入mount会显示当前系统中，已经挂载的设备。
> 如果输入mount –a会根据/etc/fstab的内容自动挂载。

#### mount挂载命令

- 语法：

> mount [-t 文件系统]\[-o 特殊选项] 设备文件名挂载点

- 选项：

> [t 文件系统]：加入文件系统类型来指定挂载的类型，可以是ext3，ext4，iso9660等文件类型。
> [-o 特殊选项]：可以指定挂载的额外的选项。

- 示例：

  ```shell
  mount /dev
  mount –o remount,noexec /data   # 将/data目录重新挂载，并取消执行权限，这样/data目录所有内容都无法被执行。
  ```

- 参数说明：

> -V：显示程序版本
>
> -h：显示辅助讯息
>
> -v：显示较讯息，通常和 -f 用来除错。
>
> -a：将 /etc/fstab 中定义的所有档案系统挂上。
>
> -F：这个命令通常和 -a 一起使用，它会为每一个 mount 的动作产生一个行程负责执行。在系统需要挂上大量 NFS 档案系统时可以加快挂上的动作。
>
> -f：通常用在除错的用途。它会使 mount 并不执行实际挂上的动作，而是模拟整个挂上的过程。通常会和 -v 一起使用。
>
> -n：一般而言，mount 在挂上后会在 /etc/mtab 中写入一笔资料。但在系统中没有可写入档案系统存在的情况下可以用这个选项取消这个动作。
>
> -s-r：等于 -o ro
>
> -w：等于 -o rw
>
> -L：将含有特定标签的硬盘分割挂上。
>
> -U：将档案分割序号为 的档案系统挂下。
>
> -L 和 -U 必须在/proc/partition 这种档案存在时才有意义。
>
> -t：指定档案系统的型态，通常不必指定。mount 会自动选择正确的型态。
>
> -o async：打开非同步模式，所有的档案读写动作都会用非同步模式执行。
>
> -o sync：在同步模式下执行。
>
> -o atime、-o noatime：当 atime 打开时，系统会在每次读取档案时更新档案的『上一次调用时间』。当我们使用 flash 档案系统时可能会选项把这个选项关闭以减少写入的次数。
>
> -o auto、-o noauto：打开/关闭自动挂上模式。
>
> -o defaults:使用预设的选项 rw, suid, dev, exec, auto, nouser, and async.
>
> -o dev、-o nodev-o exec、-o noexec允许执行档被执行。
>
> -o suid、-o nosuid：允许执行档在 root 权限下执行。
>
> -o user、-o nouser：使用者可以执行 mount/umount 的动作。
>
> -o remount：将一个已经挂下的档案系统重新用不同的方式挂上。例如原先是唯读的系统，现在用可读写的模式重新挂上。
>
> -o ro：用唯读模式挂上。
>
> -o rw：用可读写模式挂上。
>
> -o loop=：使用 loop 模式用来将一个档案当成硬盘分割挂上系统。

#### 挂载光盘

- 建立挂载点：

  ```shell
  mkdir /mnt/cdrom
  ```

- 挂载光盘：

  ```shell
  mount –t iso9660 /dev/cdrom /mnt/cdrom
  ## 或者
  mount -o ro /dev/sr0 /mnt/cdrom
  ```

- 挂载成功后，就可以使用/mnt/cdrom进行操作，关盘只能以只读方式进行挂载。

- 卸载光盘

  ```shell
  umount /dev/sr0或者umount /mnt/cdrom
  ```

- 使用ls -l /dev/cdrom可以看到/dev/cdrom其实是/dev/sr0的软链接，一般推荐使用/dev/sr0进行挂载。

#### 挂载U盘

- 查看U盘的设备名，U盘的设备名是不固定的，和硬盘一样。

  ```shell
  fdisk –l
  ```

- 在mnt下创建usb目录

  ```shell
  mkdir /mnt/usb
  ```

- 挂载U盘

  ```shell
  mount –t vfat /dev/sdb1 /mnt/usb
  ```

- `注意`：Linux默认是不支持NTFS文件系统的，如果需要支持，需要另外安装插件ntfs-3g。详细操作可参考https://www.cnblogs.com/zzy-frisrtblog/p/5973464.html

#### 查看硬盘使用状况

- 使用mount /dev/sdb1 /home将sdb1挂载到/home目录下。

- df –h查看硬盘使用情况和挂载情况

  ![20180827115537](http://www.znsd.com/znsd/courses/uploads/a10222d0b8f3ae1b21d5cadbc27a7355/20180827115537.png)

#### 磁盘管理

- df：查看磁盘的使用状况

- 语法：

  ```shell
  df [选项]
  ```

- 选项

> l：仅显示本地磁盘信息
>
> a：显示所有文件系统的磁盘使用情况。
>
> h：以1024进制计算最合适的单位显示磁盘容量。
>
> H：以1000进制计算最合适的单位显示磁盘容量。
>
> T：显示磁盘分区类型。
>
> t：显示指定类型文件系统的磁盘分区。
>
> x：不显示指定类型文件系统的磁盘分区。

#### 磁盘控件

- du：显示磁盘中文件或目录的大小

- 语法：

  ```shell
  du [-ahskm] 文件或目录名称
  ```

- 选项：

> -a ：列出所有的文件与目录容量，因为默认仅统计目录底下的文件量而已。
>
> -h ：以人们较易读的容量格式 (G/M) 显示；
>
> -s ：列出总量而已，而不列出每个各别的目录占用容量；
>
> -S ：不包括子目录下的总计，与 -s 有点差别。
>
> -k ：以 KBytes 列出容量显示；
>
> -m ：以 MBytes 列出容量显示；

#### 挂载新硬盘

- 在使用Linux时，有时候需要添加新的硬盘。关闭虚拟机，添加一个10G的新硬盘。

  ![image](http://www.znsd.com/znsd/courses/uploads/4f92d36bff2899ff4264e855e4fb801e/image.png)

- 然后启动Linux，切换到root用户下，使用fdisk –l，查看分区信息，这里会多出一块sdb硬盘，但是未建立分区。

  ![image](http://www.znsd.com/znsd/courses/uploads/f7d5da797e2a6590179b0d3cb932bdc9/image.png)

#### fdisk分区工具

- 新硬盘要使用，还必须对硬盘进行分区。
- fdisk是Linux中内置的分区工具

> fdisk –l：显示当前系统中所有分区信息。

- fdisk还可以支持对磁盘进行分区。

> 使用fdisk /dev/sdb 对新添加的磁盘进行分区。

#### 分区命令

- 使用fdisk /dev/sdb进行分区，会打开Linux分区工具，输入m显示分区命令菜单。

  ```shell
  [root@localhost ~]# fdisk 
  
  fdisk: Usage:
   fdisk [options] <disk>    change partition table
   fdisk [options] -l <disk> list partition table(s)
   fdisk -s <partition>      give partition size(s) in blocks
  
  Options:
   -b <size>                 sector size (512, 1024, 2048 or 4096)
   -c                        switch off DOS-compatible mode
   -h                        print help
   -u <size>                 give sizes in sectors instead of cylinders
   -v                        print version
   -C <number>               specify the number of cylinders
   -H <number>               specify the number of heads
   -S <number>               specify the number of sectors per track
  
  : Success
  ```

- 菜单命令：

> d：删除分区表
>
> n：添加新的分区表
>
> l：显示分区列表
>
> w：写入分区列表

#### 格式化命令

- mkfs：对磁盘进行格式化

- 语法：

  ```shell
  mkfs [-t 文件系统格式] 设别名称
  ```

- 选项：

> -t：可以接文件系统格式，如ext2,ext3,ext4等，系统支持才有效。

- 示例：

  ```shell
  mkfs.ext4 /dev/hdc1
  # 或者
  mkfs –t ext4 /dev/dbc1
  ```

- 如果不带参数，则使用ext2格式进行格式化。详细操作可参考https://blog.csdn.net/hanpengyu/article/details/7475645


#### 小结

- Linux的挂载命令
- Linux的磁盘分区命令

### Linux软件安装

- 在Window里面的软件安装，基本都是有图形页面，基本也都很简单，大多数软件都是下一步下一步就可以搞定。
- 但是在Linux中，软件安装基本都是在字符页面下进行操作的，所以安装软件也必须学会常用的安装命令。
- Linux中软件安装一般分为一下几种：

1. tar包的管理。
2. rpm命令管理。
3. yum在线命令管理。
4. 源码包管理。
5. 脚本安装包。

#### 软件包的管理

- 在Linux中大部分的软件都是直接可以查看到源码，也就是将源码打包成了tar.gz文件。这类文件解压之后，使用安装的批处理命令就可以安装。

- 解压命令：

  ```shell
  tar -zxvf test.tar.gz    #将test.tar.gz解压到当前目录。
  tar –czvf test.tar.gz /soft/test  #将test.tar.gz解压到/soft/test目录。
  ```

- 一般的批处理命令：

  ```shell
  install.pl         #运行./install.pl
  setup.sh         #运行setup.sh
  ```

#### RPM包的安装

- RPM包是Linux中对安装文件进行打包后的二进制文件，很多软件都提供rpm安装版本，rpm安装包非常方便。

- rpm包的优点：

  安装方便，只通过几个命令就可以实现包的安装、升级、查询和卸载。

- rpm包的缺点：

  rpm包是经过编译的，所以不在能看到源代码，功能也不如源码包灵活，有些包安装具有依赖性。

#### rpm包在哪？

- 在Linux的系统光盘中提供了大量rpm安装包，很多rpm包直接在光盘的packages目录下。

- RPM包的命名规则：

  ```shell
  java-1.7.0-openjdk-1.7.0.75-2.5.4.2.el7_0.x86_64.rpm
  ```

- java：软件包名称
- 1.7.0：对应的版本
- openjdk：子软件包名称
- 1.7.0.75：子软件包版本
- 2.5.4.2：小版本
- el7_0：适合Linux的版本redhat7.0
- x86_64：适合的Linux平台
- .rpm：rpm后缀名

#### rpm包的依赖性  

- 树形依赖：

  a—>b—>c

- 环形依赖：

  a—>b—>c—>a

- 模块依赖：

  是指依赖另一个包中的某一个文件，一般以so.2结尾的文件，可以通过网站：[www.rpmfind.net](http://www.rpmfind.net/)来进行查询。

#### RPM的安装

- 语法：

  ```shell
  rpm –ivh 包全名
  ```

- 选项：

  ```shell
  -i：install安装
  -v：verbose显示详细信息。
  -h：hash显示进度。
  ```

- 示例：

  ```shell
  rpm –ivh java-1.7.0-openjdk-1.7.0.75-2.5.4.2.el7_0.x86_64.rpm
  ```

#### RPM的升级和卸载

- 升级

  ```shell
  语法：rpm –Uvh 包全名
  选项：-U：update升级
  ```

- 卸载

  ```shell
  语法：rpm –e 包名
  选项：-e：erase卸载
  ```

#### RPM包的查询

- rpm –q 包名：查询是否安装。
- rpm –qa：查询已经安装的RPM包。
- rpm –qa | grep tomcat：查询tomcat相关的包是否安装
- rpm –qi 包名：查询软件包的详细信息
- rpm –qup 全包名：查询未安装包的详细信息。
- rpm –ql 包名：查询软件包的安装位置。
- rpm –qf 文件名：查询文件属于哪一个RPM包。
- rpm –qr 全包名：查询一个包所依赖的rpm包。
- rom –qrp 全包名：查询一个未安装的rpm所依赖的包。

#### RPM包默认安装位置

RPM包默认安装的位置。

| 目录名         | 说明                         |
| -------------- | ---------------------------- |
| /etc           | 配置文件的安装位置。         |
| /usr/bin       | 可执行的命令文件的安装位置。 |
| /usr/lib       | 程序所使用的函数库的位置。   |
| /usr/share/doc | 基本软件手册的位置。         |
| /usr/share/man | 帮助文件的为位置。           |

#### RPM包的验证

- 可以验证rpm的安装包是否被修改过。
- rpm –V 包名
- 验证信息的8个内容如下：

1. S：文件大小被改变。
2. M：文件类型或文件权限是否被改变
3. 5：文件MD5效验是否被改变
4. D：设备的主从代码是否被改变。
5. L：文件路径是否被改变。
6. U：文件所有者是否被改变。
7. G：文件用户组是否被改变。
8. T：文件的修改事件是否被改变。

#### RPM验证文件类型

RPM的验证的文件类型有如下几种：

- C：配置文件。
- d：普通文件。
- g：“鬼”文件，很少见，就是该文件不应该被rpm包包含。
- L：授权文件。
- r：描述文件。

#### yum安装

- 在前面使用rpm安装是，rpm包的各种依赖性让人觉得要崩溃了。如果所有的rpm包都是手动安装的，那么rpm包使用的难度太大了。
- 所以Linux的给我们提供了一种yum在线安装的办法来解决这个问题，yum在线安装其本质还是rpm安装，只是在线安装时，会自动帮我们下载所依赖的其他rpm包，这样极大的简化了我们的安装过程。让Linux中的软件安装变得更加简单方便。
- 由于yum使用非常方便redhat的yum服务是需要付费的。

#### yum源文件

- 在/etc/yum.repos.d/CentOS-Base.repo是yum的核心文件。在这个文件夹中有这样几个文件。

| 名称       | 说明                                                         |
| ---------- | ------------------------------------------------------------ |
| [base]     | 容器名称，一定要放在[]中。                                   |
| name       | 容器说明，可以自己随便填写。                                 |
| mirrorlist | 镜像站点，这个可以注释掉。                                   |
| baseurl    | 我们yum源服务器的地址，默认使用的是CentOS官方的yum服务器地址，如果你觉得速度慢，可以修改为国内的地址。 |
| enabled    | 此容器是否生效，如果不写或者enabled=1都是生效的，写成enabled=0就是不生效。 |
| gpgcheck   | 如果是1是指RPM的数字证书生效，为0则不生效。                  |
| gpgkey     | 数字证书的公钥文件保存位置。不用修改。                       |

#### 国内知名的yum源

- 由于CentOS服务器是在国外，所以很多时候下载都比较慢，我们可以配置国内的yum源，速度会快很多。
- 推荐几个国内比较好的yum源：
  - <http://mirrors.163.com/>   网易
  - [https://](https://lug.ustc.edu.cn/wiki/mirrors/help/centos)[lug.ustc.edu.cn/wiki/mirrors/help/centos](https://lug.ustc.edu.cn/wiki/mirrors/help/centos)  中科大
  - [http://](http://mirrors.sohu.com/help/centos.html)[mirrors.sohu.com/help/centos.html](http://mirrors.sohu.com/help/centos.html) 搜狐

- yum源的修改方法。

> 1. 首先备份CentOS-Base.repo
>
>    ```shell
>    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
>    ```
>
> 2. 下载对应版本的CentOS-Base.repo, 放入/etc/yum.repos.d/
>
>    ```shell
>    # CentOS 5
>    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-5.repo
>    # CentOS 6
>    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
>    # CentOS 7
>    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
>    ```
>
> 3. 运行yum makecache生成缓存
>
>    ```shell
>    yum makecache
>    ```

#### 光盘yum源配置

- 我们知道yum源需要连接网络，那么如果没有网络怎么办呢？由于我们的rpm包在光盘中都有，我们可以直接使用光盘中的包作为我们的本地yum源。
- 配置光盘yum源步骤：

> - 挂载centos的安装文件。
>
>   ```shell
>   mount /dev/sr0 /mnt/cdrom
>   ```
>
> - 使默认的CentOS-Base.repo源失效。改名
>
>   ```shell
>   mv CentOS-Base.repo CentOS-Base.repo.bak
>   ```
>
> - 修改CentOS-Media.repo文件。
>
>   ```shell
>   修改 baseurl=file:///mnt/cdrom
>   设置 enabled=1
>   ```

#### yum命令

- yum list：查询yum源中的所有的rpm包。
- yum search 关键字：搜索服务器上所有和关键字相关的包。
- yum -y install 包名：安装指定的rpm包，-y自动应答。
- yum update 包名：更新指定的rpm包。
- yum remove 包名：删除指定的rpm包。
- yum check-update：列出可以更新的软件包清单。
- yum clear packages：清除缓存目录下的软件包。
- yum clear headers：清除缓存目录下的headers。
- yum clear oldheaders：清除缓存目录下的headers。
- yum clear [all]：清除缓存目录下的所有内容。

#### rpm和源码安装的区别

- rpm包安装会安装到指定的目录，源码安装到特定的目录。
- rpm安装后可以提供rpm –e进行卸载，源码安装后需要手动删除文件夹尽心卸载。
- rpm是第三方进行打包，源码是本机进行打包，更灵活，效率更高。
- 一般推荐使用源码打包方式进行安装。

#### tar压缩命令

- 独立命令，一次命令中只能包含其中一个

  ```shell
  -c: 建立压缩档案
  -x：解压
  -	t：查看内容
  -r：向压缩归档文件末尾追加文件
  -u：更新原压缩包中的文件
  ```

- 可选命令

  ```shell
  -z：有gzip属性的
  -v：显示所有过程
  ```

- -f: 使用文档名字，这个参数是最后一个参数，后面只能接文档名

- 例如：解压

  ```shell
  tar –zxvf jdk-8u151-linux-i586.tar.gz
  ```

### 安装开发软件

- 安装jdk
- 安装tomcat
- 安装mysql

#### 安装JDK

- 从oracle官网下载JDK的linux版本：

  ```shell
  jdk-8u151-linux-i586.tar.gz
  ```

- 通过ftp上传到linux系统中

- 使用tar命令解压安装包

  ```shell
  tar –zxvf jdk-8u151-linux-i586.tar.gz
  ```

- 配置环境变量

  ```shell
  vim /etc/profile
  ```

- 设置JAVA_HOME/PATH/CLASSPATH

  ```shell
  export JAVA_HOME=/usr/local/java
  export JRE_HOME=/usr/local/java/jre
  export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib:CLASSPATH
  export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH 
  ```

- 重新编译环境变量,使配置生效

  ```shell
  source /etc/profile
  ```

- 终端验证安装是否成功：

  ```shell
  java -version
  ```

#### 安装mysql

- 下载rpm安装包：[https://](https://dev.mysql.com/downloads/mysql/5.6.html)[dev.mysql.com/downloads/mysql/5.6.html](https://dev.mysql.com/downloads/mysql/5.6.html)

  ```shell
  MySQL-client-5.6.33-1.el6.x86_64.rpm 
  MySQL-devel-5.6.33-1.el6.x86_64.rpm 
  MySQL-server-5.6.33-1.el6.x86_64.rpm 
  ```

- 查看是否已经安装了mysql，有则卸载

  ```shell
  rpm –qa | grep -i mysql     #（查看是否安装了mysql）
  yum -y remove mysql-libs*   #（卸载mysql）
  ```

- 安装mysql5.6

  ```shell
  rpm -ivh MySQL-client-5.6.33-1.el6.x86_64.rpm #再安装devel、server包
  cp /usr/share/mysql/my-default.cnf /etc/my.cn
  ```

- 初始化MySQL及设置密码

  ```shell
  /usr/bin/mysql_install_db
  service mysql start
  cat /root/.mysql_secret    #（查看原始密码）
  mysql -uroot –p原始密码     #（登陆mysql）
  set PASSWORD=PASSWORD('123456')；
  exit
  ```

- 开启远程访问

  ```shell
  mysql -uroot -p123456
  use mysql;
  update user set password=password('123456') where user='root';
  update user set host='%' where user='root' and host='localhost';
  flush privileges;
  exit
  ```

- 设置开机自启动

  ```shell
  chkconfig mysql on
  ```

### 总结

- Linux的挂载命令
- Linux的磁盘管理
- Linux中的软件安装