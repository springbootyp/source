## 第二章    Linux常用命令

### 本章目标 

- Linux远程登录
- Linux常用命令
- Linux目录操作
- Linux文件操作
- vim编辑器的使用

### Linux远程连接 

- Linux一般作为服务器使用，而服务器一般在机房，你不可能在机房操作你的Linux。所以一般我们都是远程登录到我们的Linux服务器。 
- Linux是通过ssh实现远程登录的，默认的ssh端口是`22`。 
- Windows上连接远程的软件有
  - SecureRT
  - Putty
  - SSH
  - `XShell`

### 安装XShell远程工具 

- 首先下载XShell软件，然后安装打开软件。

  ![20180804153051](http://www.znsd.com/znsd/courses/uploads/65697a9fc5cac52479ff92c8b8741253/20180804153051.png)

  ![20180804153209](http://www.znsd.com/znsd/courses/uploads/81c417b8554c5d6826892c260a34c2d4/20180804153209.png)

### Linux命令 

- Linux最强大的地方在于Linux是一个完全基于字符操作的操作系统，在Linux中所有的功能都可以通过命令来完成，Linux可视化的操作的页面只是给初学者使用的，Linux中真正的高手都是在字符页面下驰骋的。
- Linux命令非常多，大概有将近4000个命令。
- Lixux命令大概分为以下几类 
  - 文件管理
  - 系统管理
  - 磁盘管理
  - 系统管理
  - 网络通讯
- 命令搜索可参考http://man.linuxde.net/

### Linux命令提示符 

Linux命令提示符，首先我们需要先搞清楚Linux命令提示符表示的含义。

```shell
[root@localhost ~]# 
```

- root：代表当前登录的用户名
- localhost：代表当前登录的服务器主机名。 
- ~：代表当前目录，（用户主目录） 
- \#：超级用户提示符，普通用户提示符是$

### Linux命令格式 

- `命令`  `选项`  `参数`

- 注意：个别命令不遵循此格式。

- 当有多个选项时，可以写在一起。例如-a –l ，可以些成-al 

  ```shell
  [root@localhost ~]# ls -al
  ```

- 简化选项和完整选项意义是完全一样的。例如：-a -all

### 基本操作

**Linux的系统相关的操作：**

- shutdown –h now：立刻关机
- shutdown –r now：立刻重启
- reboot：立刻重启
- logout：注销
- clear：清屏

**用户相关：**

- whoami：我是谁

  ```shell
  [root@localhost ~]# whoami 
  root
  ```

- su 用户名：切换到另一个用户

### 帮助命令 

- 由于Linux命令太多，有些时候容易忘记Linux的命令，可以调用Linux的帮助来查看命令的语法。 
- 帮助命令有以下几种： 
  - man 命令：显示详细的命令帮助信息。
  - help 命令：显示命令帮助信息。
  - which 命令：显示命令所在的目录。
  - where 命令：显示命令的指令文件所在的位置。

### 目录的常见操作 

- 我们知道Linux的目录结构为树形结构，最顶级目录为/，要对目录进行操作，首先我们要知道什么是相对路径，什么是绝对路径。
- 绝对路径： 由根目录开始，例如：/home/user
- 相对路径： 
  - 路径的写法，不是由 / 写起，而是相对当前所在的目录开始。例如：由 /usr/share/doc 要到 /usr/share/man 底下时，可以写成： cd ../man 这就是相对路径的写法。这里的../表示当前目录的上一级目录。
  - /：表示根目录
  - ~：表示当前家目录

### 目录的相关命令 

看几个常见的处理目录的命令吧： 

- ls: 列出目录
- cd：切换目录
- pwd：显示目前的目录
- mkdir：创建一个新的目录
- rmdir：删除一个空的目录
- rm: 移除文件或目录
- cp: 复制文件或目录
- mv：移动文件或目录

### ls查看目录 

- 查看目录的命令有两个，一个ls，一个ll，ls以list方式浏览，ll以详情方式浏览。
- ls可以添加参数 
  - -a：表示显示所有文件，包括隐藏该文件。例：ls -a
  - -l：表示以详情方式显示，和ll功能一样。例：ls -l，ls -al
  - -r：表示以反序显示，默认以文件名称升序排列。ls -r
  - -t：将按时间顺序显示。ls –t
  - -lh：将文件大小的单位进行换算。
- ls 可以查看指定的目录和支持模糊匹配。
  - ls -l /bin  ：以详情方式查看/bin目录下的文件。
  - ls –l /bin/a*：以详情方式查看/bin目录下以a开头的文件。*
  - ll /bin/*.txt：查看bin下以txt结尾的文件。

### 目录操作命令

- pwd：显示当前目录

  ```shell
  [root@localhost ~]# pwd
  /root
  ```

- cd（Change Directory）：更改目录

  - cd 相对路径/绝对路径
  - cd ..：返回上一级
  - cd -：返回上一次所在的目录。
  - cd /：返回根目录
  - cd ~：返回家目录

### mkdir创建新目录 

- 语法：mkdir [-mp] 目录名称

- 参数说明： 

  - -p：可以一次直接创建多层级目录
  - -m：配置文件的权限喔！直接配置，不需要看默认权限 (umask) 的脸色～

- 举例： 

  ```shell
  [root@localhost tmp]# mkdir test1
  [root@localhost tmp]# mkdir -p test2/1/2
  [root@localhost tmp]# 
  ```

### rmdir删除空目录 

- 语法：rmdir [–p] 目录名称

- 参数说明：-p：连同上一级目录[空目录]也一起删除。

- 实例：

  ```shell
  [root@localhost tmp]# rmdir test1/
  [root@localhost tmp]# rmdir -p test2/1/2/
  [root@localhost tmp]# 
  ```

- 如果目录不为空，则删除会失败，如果要删除非空目录，则使用rm命令进行删除。

  ```shell
  [root@localhost tmp]# rmdir test/
  rmdir: failed to remove `test/': Directory not empty
  ```

### rm删除文件或子目录 

- 语法：rm [-fir] 文件或子目录

- 参数说明： 

  - -f ：就是 force 的意思，强制删除。
  - -i ：互动模式，在删除前会询问使用者是否动作。
  - -r ：递归删除，可以删除目录和文件。

- 示例： 

  ```shell
  [root@localhost tmp]# rm -r aaa
  rm: remove regular empty file `aaa'? y
  [root@localhost tmp]# rm -i aaa 
  rm: remove regular empty file `aaa'? n
  ```

- `rm –rf / Linux自杀命令绝对不能执行`

### cp复制文件 

- 语法
  - cp [-adfilpr] 来源 目标档
  - cp [options] source1 source2 source3 .... directory
- 选项与参数： 
  - -a：此选项通常在复制目录时使用，它保留链接、文件属性，并复制目录下的所有内容。其作用等于dpR参数组合。
  - -d：复制时保留链接。这里所说的链接相当于Windows系统中的快捷方式。
  - -f：覆盖已经存在的目标文件而不给出提示。
  - -i：与-f选项相反，在覆盖目标文件之前给出提示，要求用户确认是否覆盖，回答"y"时目标文件将被覆盖。
  - -p：除复制文件的内容外，还把修改时间和访问权限也复制到新文件中。
  - -r：若给出的源文件是一个目录文件，此时将复制该目录下所有的子目录和文件。
  - -l：不复制文件，只是生成链接文件。

### 移动或重命名

- 语法：
  - mv [-if] 来源 目标档
  - mv [options] source1 source2 source3 .... directory

| 命令格式       | 运行结果                           |
| ---------- | ------------------------------ |
| mv 文件名 文件名 | 将源文件名改为目标文件名                   |
| mv 文件名 目录名 | 将文件移动到目标目录                     |
| mv 目录名 目录名 | 目标目录已存在，将源目录移动到目标目录；目标目录不存在则改名 |
| mv 目录名 文件名 | 出错                             |



### 链接命令

- 链接分为软链接(symbolic link)和硬链接(hard link)，硬链接的意思是一个档案可以有多个名称，而软链接的方式则是产生一个特殊的档案，该档案的内容是指向另一个档案的位置，类似window中的快捷方式。

- 语法：ln \[参数\] \[目标\] \[文件或目录\]

- 参数说明： -s：软链接，添加-s为创建软链接，不要则为硬链接。 

  ```shell
  [root@localhost tmp]# ln -s a.txt bb.txt
  ```

- 这里要注意：如果软链接的源文件和链接文件在同一个目录下，可以使用相对路径，但是如果不在同一个目录下，必须使用绝对路径。 

### 软链接和硬链接的区别 

**软链接：**

- 软链接以路径的形式存在，类似Window操作系统中的快捷方式
- 软链接的文件类型会被标识为l。
- 当删除软链接原始文件，软链接将无法使用。
- 软链接可以对一个不存在文件名进行链接。
- 软链接可以对目录进行链接。
- 软链接可以跨分区使用，硬链接不可以

**硬连接**

- 硬链接，以文件副本形式存在，不占用实际空间。
- 硬链接文件类型为普通文件类型。
- 删除任何一个硬链接文件不会影响另一个文件。
- 不允许给目录创建硬链接。
- 硬链接跨分区使用。

**推荐使用软链接，硬链接和原始文件区分太小，无法区分。**

### 文件相关操作

Linux系统中使用以下命令来查看文件的内容： 

- cat  由第一行开始显示文件内容
- tac  从最后一行开始显示，可以看出 tac 是 cat 的倒著写！
- nl   显示的时候，顺道输出行号！
- more 一页一页的显示文件内容
- less 与 more 类似，但是比 more 更好的是，他可以往前翻页！
- head 只看头几行
- tail 只看尾巴几行

### cat和tac 

- cat由第一行显示文件内容，tac由最后一行显示文件内容。语法完全一致。 

- 语法：cat [AbEbTv]

  ```shell
  [root@localhost tmp]# cat a
  asdflasf
  ```

- 选项与参数： 

  - -A ：相当於 -vET 的整合选项，可列出一些特殊字符而不是空白而已；
  - -b ：列出行号，仅针对非空白行做行号显示，空白行不标行号！
  - -E ：将结尾的断行字节 $ 显示出来；
  - -n ：列印出行号，连同空白行也会有行号，与 -b 的选项不同；
  - -T ：将 [tab] 按键以 ^I 显示出来；
  - -v ：列出一些看不出来的特殊字符

### more

- more一页页翻动 
- 语法：more 文件名
- 在程序运行时，可以按一下几个键：
  - enter：下翻一行
  - space：下翻一页
  - /字符串：指向下搜索指定的字符串
  - :f：立刻显示出档名以及目前显示的行数；
  - q：代表立刻离开 more ，不再显示该文件内容。
  - b 或 [ctrl]-b：代表往回翻页，不过这动作只对文件有用，对管线无用。

### less

- 翻页浏览
- 语法：less 文件名
- 在程序运行时，可以可以按一下几个键：
  - 空白键    ：向下翻动一页；
  - [pagedown]：向下翻动一页；
  - [pageup]  ：向上翻动一页；
  - /字串     ：向下搜寻『字串』的功能；
  - ?字串     ：向上搜寻『字串』的功能；
  - n         ：重复前一个搜寻 (与 / 或 ? 有关！)
  - N         ：反向的重复前一个搜寻 (与 / 或 ? 有关！)
  - q         ：离开 less 这个程序；

### head/tail

- head取出文件前面几行，tail取后面几行

- 语法：head [-n number] 文件

- 参数说明：-n：后面的number表示取的行数。

- 例： 

  ```shell
  [root@localhost tmp]# head /etc/sudo.conf
  [root@localhost tmp]# head –n 20 /etc/sudo.conf
  [root@localhost tmp]# tail /etc/sudo.conf
  [root@localhost tmp]# tail –n 20 /etc/sudo.conf
  ```


### 文件基本属性

- 使用ll命令或者ls -l浏览文件信息时，会显示文件详情。

  ![20180825170518](http://www.znsd.com/znsd/courses/uploads/d155c85e60bfc12c53f9f438f9b1d387/20180825170518.png)

- 其中drwxrwxr-x表示文件的类型和权限。第一个字母表示文件类型

> 当为[ d ]则是目录。
>
> 当为[ - ]则是文件；
>
> 若是[ l ]则表示为链接文档(link file)；
>
> 若是[ b ]则表示为装置文件里面的可供储存的接口设备(可随机存取装置)；
>
> 若是[ c ]则表示为装置文件里面的串行端口设备，例如键盘、鼠标(一次性读取装置)。

### 文件的权限

- 接下来的字符表示权限。且均为『rwx』 的三个参数的组合。其中，[ r ]代表可读(read)、[ w ]代表可写(write)、[ x ]代表可执行(execute)。 要注意的是，这三个权限的位置不会改变，如果没有权限，就会出现减号[ - ]而已。

  ![image](http://www.znsd.com/znsd/courses/uploads/bc39124ffaac58a9f1d2f7a9e93604c8/image.png)

> 从左至右用0-9这些数字来表示。
>
> 第0位确定文件类型，第1-3位确定属主（该文件的所有者）拥有该文件的权限。第4-6位确定属组（所有者的同组用户）拥有该文件的权限。第7-9位确定其他用户拥有该文件的权限。
>
> 第1、4、7位表示读权限，如果用"r"字符表示，则有读权限，如果用"-"字符表示，则没有读权限；
>
> 第2、5、8位表示写权限，如果用"w"字符表示，则有写权限，如果用"-"字符表示没有写权限；
>
> 第3、6、9位表示可执行权限，如果用"x"字符表示，则有执行权限，如果用"-"字符表示，则没有执行权限。

![20180825171655](http://www.znsd.com/znsd/courses/uploads/3c11672fb8278458642d38ca745beaf6/20180825171655.png)

- 对于每一个文件来说，它都有一个特定的拥有者，也就是对该文件具有所有权。同时Linux中，用户是按照组来进行划分的。一个用户属于一个或多个组。

- 最后一个`.`，在centos6以后添加进去的，代表ACL权限。

- 后面的3,2，代表改文件的引用计数。

- 后面两个root一个代表用户，另一个代表用户组。

- 后面1857代表的是文件夹中的文件数量，或者文件大小。

  ![20180825171903](http://www.znsd.com/znsd/courses/uploads/7957782ca45adfab40e734caed47325d/20180825171903.png)

- 后面2月24日 03:06文件最后一次修改时间。

- 最后一个是文件或目录名称，会以不同颜色修饰。

- `对于root用户来说，这些权限不起作用，root用户的权限不受限制。`

### 更改文件权限

- 使用chmod命令可以对这9个权限进行修改。修改方式有两种，一种是数字方式。

- 文件的权限字符为：『-rwxrwxrwx』，这九个权限是三个三个一组的！其中，我们可以使用数字来代表各个权限，各权限的分数对照表如下：`r:4`，`w:2`，`x:1`

- 每种身份(owner/group/others)各自的三个权限(r/w/x)分数是需要累加的，例如当权限为： [-rwxrwx---] 分数则是：

  ```
  owner = rwx = 4+2+1 = 7
  group = rwx = 4+2+1 = 7
  others= --- = 0+0+0 = 0
  ```

- 所以等一下我们设定权限的变更时，该文件的权限数字就是770

### chmod修改权限

- 语法：

> chmod[-R] xyz 文件或目录

- 参数说明：

> -R：进行递归变更，修改该目录下所有的子目录和文件。
> xyz：对应前面提到的数字权限，比如770。

- 示例：

  ```shell
  chmod 751 mydir     # 将mydir文件的权限改为drwxr-x--x
  ```

### 更改文件所属组

**chgrp：更改文件所属组**

- 语法：

> chgrp [-R] 用户组名称 文件名

- 参数：

> -R表示递归更改某个目录文件的属性，如果加上这个参数，表示该文件夹下的所有文件都会同时被修改。

- 示例：

  ```shell
  chgrp root mydir   #将mydir的用户组改为root。
  ```

### 更改文件所有者

**chown：更改文件所有者**

- 语法：

> chown [-R] 所有者 文件名

- 参数：

> -R表示递归更改某个目录文件的属性，如果加上这个参数，表示该文件夹下的所有文件都会同时被修改。

- 示例：

  ```shell
  chown root mydir  # 将mydir的所有者改为root用户。
  ```

### vi/vim编辑器

- Linux中内建了一个vim文本编辑器，通过这个编辑器，可以在Linux中编辑文件。
- vim分为三种模式：

> 命令模式：用户刚进入vim就是命令模式。
>
> 输入模式：在命令模式输入i进入输入模式。
>
> 底部命令模式：在命令模式下按`:`进入底部命令模式。

#### 命令模式

- 此状态下敲击键盘动作会被Vim识别为命令，而非输入字符。比如我们此时按下i，并不会输入一个字符，i被当作了一个命令。
- 几个常见的命令：
> i：切换到输入模式，以输入字符。
>
> x：删除当前光标所在处的字符。
>
> :：切换到底部命令模式，在最后一行输入字符。

- 命令模式只有一些最基本的命令，因此仍要依靠底线命令模式输入更多命令。

#### 输入模式

在此模式下，对文件内容进行编辑。在输入模式下可以使用以下按键：

- 字符按键以及Shift组合，输入字符
- ENTER，回车键，换行
- BACK SPACE，退格键，删除光标前一个字符
- DEL，删除键，删除光标后一个字符
- 方向键，在文本中移动光标
- HOME/END，移动光标到行首/行尾
- Page Up/Page Down，上/下翻页
- Insert，切换光标为输入/替换模式，光标将变成竖线/下划线
- ESC，退出输入模式，切换到命令模式

#### 底部命令模式

- 在命令模式下按下:（英文冒号）就进入了底线命令模式。
- 常用底部命令：
  - :w：保存
  - :q：退出，:wq保存并退出。
  - :q!：强制退出，不保存。
  - :e file：打开文件

#### 文件搜索命令

经常我们需要在系统中检索我们需要的文件，在windows中可以使用F3进行搜索。在Linux中提供了多种文件搜索方式。

- locate
- find
- grep

#### locate

- 语法:locate文件名

- locate是在后台数据库中，按文件名进行检索，速度非常快。但是最新更新的数据不一定能搜索出来。

- locate的后台数据库：/var/lib/mlocate。

- locate数据库默认一天已更新，也看使用命令手动更新更新数据库：updatedb，需要root权限。

  ```shell
  [root@localhost znsd]# locate test
  locate: can not stat () `/var/lib/mlocate/mlocate.db': No such file or directory 
  [root@localhost znsd]# updatedb 
  [root@localhost znsd]# locate test
  ```

- 如果执行locate出现locate: can not stat () `/var/lib/mlocate/mlocate.db': No such file or directory` 错误，请执行`updatedb`命令更新linux检索索引。

#### locate的配置文件

- /etc/updatedb.conf文件是locate命令搜索的配置文件，在这个文件中，定义了locate搜索的规则。
- PRUNE_BIND_MOUNTS=“yes”：表示以下配置是否有效。
- PRUNEFS=“”：表示搜索时，不搜索的文件系统。
- PRUNENAMES=“”：表示搜索时，不搜索的文件类型。
- PRUNEPATHS=“”：表示搜索时，不搜索的文件路径。

#### find

- 语法：

> find [搜索范围]\[搜索条件] 文件名

- find默认会按照完整文件名进行搜索，如果要进行模糊搜索，可以使用通配符，Linux中的通配符常用的有三种

> *：匹配任意多个字符
>
> ?：匹配任意一个字符
>
> [ ]：匹配任意一个中括号中的字符。

```shell
find /home –name a.txt             # 在/home目录下按照名称搜索a.txt
find /home –iname a.txt            # -iname指不区分文件名大小写
find /etc -name *.conf             # 在/etc目录下搜索以.conf结尾的文件。
find -user zhengcheng              # 查找属于zhengcheng的文件
find –type d/f                     # 根据文件类型查找,f普通文件，d目录。
find –mtime -1/+1                  # 查找1天以前或之后更新的文件。
find –ctime -1/+1                  # 查找1天钟以前或之后创建的文件。
```

- find相对于locate会更慢，因为find扫描硬盘进行文件搜索，但是find功能更加强大，locate只能根据文件名进行搜索，find可以添加其他的参数，也可以支持通配符搜索，但是要注意的是，使用find避免在大范围进行搜索，效率太低。

#### locate和find的区别

- 效率：find相对于locate会更慢，因为find扫描硬盘进行文件搜索。
- 功能：但是find功能更加强大，可以添加其他的参数，也可以支持通配符搜索，locate只能根据文件名进行搜索，
- 即时性：find搜索的数据是即时的，locate不是。
- 模糊匹配：find默认是精确搜索，locate是模糊搜索。

### 用户和用户组

- Linux是一个多用户多任务的系统，管理员可以添加多个用户来帮助管理Linux系统。

- 用户管理主要包括以下内容：

  - 用户的添加，修改，和删除。
  - 用户口令的管理。
  - 用户组的管理。


#### 添加用户

- 语法：

> useradd 选项 用户名

- 参数说明

> -c：comment 指定一段注释性描述。
>
> -d：目录 指定用户主目录，如果此目录不存在，则同时使用-m选项，可以创建主目录。
>
> -g：用户组 指定用户所属的用户组。
>
> -s：Shell文件 指定用户的登录Shell。
>
> -u：用户号 指定用户的用户号，如果同时有-o选项，则可以重复使用其他用户的标识号。

- 示例：

  ```shell
  useradd –u user1                  # 添加新用户 user1
  useradd –d /home/user1 –u user2   # 添加新用户，并指定用户家目录。
  ```

#### 设置用户密码

- 语法：

> passwd 选项 用户名

- 选项说明

> -l 锁定口令，即禁用账号。
>
> -u 口令解锁。
>
> -d 使账号无口令。
>
> -f 强迫用户下次登录时修改口令。

- 如果是第一次修改密码，直接输入密码即可，如果是修改密码，则需要输入旧密码。

  ```shell
  passwd user1   # 修改用户 user1的密码
  ```

#### 修改和删除用户

**修改用户**

- 语法：

> usermod 选项 用户名

- 选项说明和useradd一致。

- 实例：

  ```shell
  usermod -l newtest test   # 修改test的用户名为newtest
  usermod -G staff newuser2 # 将newuser2添加到组staff中
  ```

**删除用户**

- 语法：

> userdel 选项 用户名

- 选项说明

> -r：将用户所在的目录一起删除。

- 示例：

  ```shell
  userdel -r user1      # 删除用户 user1
  ```

#### 添加用户组

- 添加用户时，如果不指定用户组，会创建和用户名相同的一个用户组。
- 语法：

> groupadd 选项 组名

- 选项说明：

> -g GID 指定新用户组的组标识号（GID）。
>
> -o 一般与-g选项同时使用，表示新用户组的GID可以与系统已有用户组的GID相同。

- 示例：

  ```shell
  groupadd usergroup1            # 添加用户组 usergroup1
  groupadd –g 101 usergroup1     # 添加用户组 usergroup1，并指定gid
  ```

#### 删除用户组

- 语法：

> groupdel 用户组

- 示例：

  ```shell
  groupdel usergroup1      # 添加用户组 usergroup1
  ```

#### 与用户相关的文件

完成用户管理的工作有许多种方法，但是每一种方法实际上都是对有关的系统文件进行修改。

- /etc/passwd：存放用户和用户组的关系，用户对应的目录，指令集等。`以用户名:口令:用户标识号:组标识号:注释性描述:主目录:登录Shell `格式存储。
- /etc/shadow：/etc/shadow中的记录行与/etc/passwd中的一一对应，它由pwconv命令根据/etc/passwd中的数据自动产生。它的存储格式：`登录名:加密口令:最后一次修改时间:最小时间间隔:最大时间间隔:警告时间:不活动时间:失效时间:标志`
- /etc/group：用户组的所有信息都存放在/etc/group文件中，存储格式：`组名:口令:组标识号:组内用户列表`

### 总结

- 知道什么是Linux。Linux有哪些优势。
- Linux的应用领域。
- 使用虚拟机安装Linux系统。
- Linux的对目录和文件的操作。
- Linux的文件搜索。
- vim编辑器。
- 用户和用户组的操作。