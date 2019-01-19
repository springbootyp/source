## 第一章    Linux系统介绍 

### 本章目标 

- 了解什么是Linux
- 安装虚拟机VMware-workstation
- 安装ContoS6操作系统
- 了解的目录结构

### 什么是操作系统 

- 我们都知道计算机是由一堆硬件来组成的，为了有更好的控制这些硬件如何工作，于是就有了操作系统。    

  ![image](http://www.znsd.com/znsd/courses/uploads/49fb87038c291ff6c669a6fd7d0c9661/image.png)

### 常见的操作系统 

- 所谓的操作系统就是管理电脑硬件与软件程序，所有的软件都是基于操作系统程序的基础上去开发的。

- 其实操作系统种类是很多的，用工业用的，商业用的，个人用的，涉及的范围很广。这里我只介绍我们平时电脑常见的操作系统都有哪些。 

![2a3b00040c2904e7ced0](http://www.znsd.com/znsd/courses/uploads/1a1396728cf4bb1c36819f1d47b08bc5/2a3b00040c2904e7ced0.jpg)

### Unix 

- [UNIX](http://baike.baidu.com/item/unix)[操作系统](http://baike.baidu.com/item/unix)（尤尼斯），是一个强大的多用户、多任务操作系统，支持多种处理器架构，按照操作系统的分类，属于分时操作系统。
  
- 最早由KenThompson、Dennis Ritchie和Douglas McIlroy于1969年在AT&T的贝尔实验室开发。目前它的商标权由国际开放标准组织所拥有，只有符合单一UNIX规范的UNIX系统才能使用UNIX这个名称，否则只能称为类UNIX（UNIX-like）。 
  
- KenThompson(肯·汤普森)
  
![image](http://www.znsd.com/znsd/courses/uploads/de4ae495b48e4d44f9f60f998129a88e/image.png)
    
- Dennis Ritchie(丹尼斯·里奇)
  
![image](http://www.znsd.com/znsd/courses/uploads/f7ff2fdff3a9138d2104db2a35d693be/image.png)
    
- Douglas McIlroy(道格拉斯·麦克罗伊) 
  
![image](http://www.znsd.com/znsd/courses/uploads/1e256cf98089ccd050f7e2bd5bc76865/image.png)

### Unix家谱 

Unix在开发的过程中，衍生出了各种各样的版本。  
  - AIX：是IBM开发的一套UNIX操作系统。
  - Solaris：是SUN公司研制的类Unix操作系统。直至2013年，Solaris的最新版为 Solaris 11。
  - HP-UX：是惠普公司以SystemV为基础所研发成的类UNIX操作系统。
  - IRIX：由硅谷图形公司以System V与BSD延伸程序为基础所发展成的UNIX操作系统，IRIX可以在SGI公司的RISC型电脑上运行，即是采行32位、64位MIPS架构的SGI工作站、服务器。
  - Xenix：是一种UNIX操作系统，可在个人电脑及微型计算机上使用。该系统由微软公司在1979年从美国电话电报公司获得授权，为Intel处理器所开发。
  - A/UX：是苹果公司所开发的UNIX操作系统，此操作系统可以在该公司的一些麦金塔电脑（Macintosh）上运行，最末（或说最新）的一套A/UX是在Macintosh II、Quadra及Centris等系列的电脑上运行。
    
  UNIX操作系统是商业版，需要收费，价格比Microsoft Windows正版要贵一些。不过UNIX也有免费版的，例如：NetBSD等类似UNIX版本。 


### Linux

  - Linux操作系统最初只是由芬兰人李纳斯·托瓦兹（Linus Torvalds）在赫尔辛基大学上学时出于个人爱好而编写的。
  - Linux是一套免费使用和自由传播的类Unix操作系统，是一个基于POSIX和UNIX的多用户、多任务、支持多线程和多CPU的操作系统。它能运行主要的UNIX工具软件、应用程序和网络协议。它支持32位和64位硬件。Linux继承了Unix以网络为核心的设计思想，是一个性能稳定的多用户网络操作系统。
    
### Linux主要特征 

  - 一切皆文件：是指系统中所有都由文件构成，包括硬件，命令，操作系统，进程等等。
  - 完全免费： Linux是一款免费的操作系统，用户可以通过网络或其他途径免费获得，并可以任意修改其源代码。
  - 完全兼容POSIX1.0标准：在Linux下通过相应的模拟器运行常见的DOS、Windows的程序。
  - 多用户、多任务：Linux支持多用户，各个用户对于自己的文件设备有自己特殊的权利，保证了各用户之间互不影响。
  - 良好的界面：Linux同时具有字符界面和图形界面。
  - 支持多种平台：Linux可以运行在多种硬件平台上，如具有x86、680x0、SPARC、Alpha等处理器的平台。此外Linux还是一种嵌入式操作系统，可以运行在掌上电脑、机顶盒或游戏机上。

### Linux的应用领域 

主要应用领域包括3个方面：

- 桌面应用领域： 众所周知，Window是桌面应用领域中的霸主，但是随着Linux图形页面的发展和应用软件的发展，Linux在桌面应用方面也显著提高。事实也证明Linux已经能够满足基本办公，娱乐，和信息交流的基本需求。不过，由于Linux入门的门槛比Windows要高，所以Linux桌面市场占有率并不高。 
- `u高端服务器领域：`：由于Linux内核具有稳定性、开放源代码等特点，另外，使用者不必支付大笔的使用费用。因此在不同操作系统相互竞争的情况下，企业只需要掌握Linux技术并配合系统整合与网络等技术，便能够享有低成本、高可靠性的网络环境。目前在服务器领域Linux市场占有率已经超过50%。
- 嵌入式应用领域： 在通常情况下，嵌入式及信息家电的操作系统支持所有的运算功能，但是需要根据实际应用对其内核进行定制和裁剪，以便为专用的硬件提供驱动程序，并且在此基础上进行应用开发。目前，能够支持嵌入式的常见操作系统有Palm OS、嵌入式Linux和Windows CE。 

### Linux操作系统 

- 严格来讲，Linux这个词本身只表示Linux内核，但实际上人们已经习惯了用Linux来形容整个基于Linux内核的操作系统。 
- 由于Linux免费开源，所以导致Linux的各种衍生版本非常混乱，市面上有好几百款发行版，而且每个版本的侧重点都不一样，这里只列举几种[常见的](http://os.51cto.com/art/201307/404309.htm)[Linux](http://os.51cto.com/art/201307/404309.htm)[发行版](http://os.51cto.com/art/201307/404309.htm)。 

![image](http://www.znsd.com/znsd/courses/uploads/fa8050a4b242284a6f94e37e36da0d4b/image.png)

- Linux各种发行版
  - Red Hat: http://www.redhat.com
  - Fedora: http://fedoraproject.org/ 
  - Mandriva: http://www.mandriva.com 
  - Novell SuSE: http://www.novell.com/linux/ 
  - Debian: http://www.debian.org/ 
  - Slackware: http://www.slackware.com/ 
  - Gentoo: http://www.gentoo.org/ 
  - Ubuntu: http://www.ubuntu.com/ 
  - CentOS: http://www.centos.org/ 
- 红帽子Redhat：1999年IBM与红帽公司建立了合作伙伴关系，以确保Redhat在IBM及其上正确运行。这也是第一款收费版本的Linux，另外红帽公司的Redhat的Linux认证在业界也是非常有名的。
- CentOS：是一款企业级Linux发行版，它使用红帽企业级Linux中的免费源代码重新构建而成。所以说CentOS是Redhat孪生兄弟也不为过，如果你想体验Redhat的企业级服务，又不想付费，可以考虑实施CentOS。
- Ubuntu：Ubuntu是Debian的一款衍生版，也是当今最受欢迎的免费操作系统。Ubuntu侧重于它在个人市场的应用，在服务器、云计算、甚至一些运行Ubuntu Linux的移动设备上很常见。

### 安装Linux 

- 我们使用centos6.9来做为Linux的教学演示。这个版本和Redhat的使用方式基本上是一致的。 

- 我们可以在centos的官方网站上下载对应版本的操作系统。

- 目前官网上提供三个版本的Centos下载，DVDI SO为普通版本，Everything ISO为完整版本，Minimal ISO为精简版本。 

  ![20180804110416](http://www.znsd.com/znsd/courses/uploads/010add1823c1a092a22273d081d979ca/20180804110416.png)

### 虚拟机（VMware）

- 由于目前处于学习阶段，不推荐在真实计算机上安装Linux，推荐使用虚拟机安装Linux，这样不会影响原有的操作系统。
- VMware是目前在Windows中最流行，也是最强大的虚拟机，可以虚拟出很多各种系统，便于我们学习和工作。 
- 虚拟机安装步骤请参考[vmware安装教程](https://blog.csdn.net/qq_32786873/article/details/78725247)

### 创建虚拟镜像

- 安装完成后，启动虚拟机。 

- 添加虚拟镜像文件，设置虚拟机参数。 

- 参考[VMware虚拟机添加镜像](https://blog.csdn.net/pugongyinglhl/article/details/53463448)

  ![image](http://www.znsd.com/znsd/courses/uploads/52713f48e808fc199f1778209b179696/image.png)

### 安装CentOS 版

- 虚拟机创建好以后，设置光盘为CentOS.iso镜像文件。然后启动虚拟机。 

- 虚拟机安装CentOS的步骤请参考：[VMware安装CentOS](https://blog.csdn.net/sl1992/article/details/52871418)

  ![20180804111415](http://www.znsd.com/znsd/courses/uploads/2992793681fa33bf8b4455b32d5cafbc/20180804111415.png)

### 系统分区

- 磁盘分区： 磁盘分区是指将硬盘划分为多个逻辑分区，磁盘一旦划分成数个分区，这样可以将各种文件分门别类存储在不同的分区中。
- 分区类型（MBR）
  - 主分区：最多只有4个
  - 扩展分区： 
    - 扩展分区也是主分区，只能有一个，主分区加扩展分区最多4个。 
    - 扩展不能写入数据，只能包括逻辑分区。
  - 逻辑分区： 用来存放数据的分区。 

### 格式化

格式化（format）：指对磁盘或磁盘中的分区（partition）进行初始化的一种操作，这种操作通常会导致现有的磁盘或分区中所有的文件被清除。格式化通常分为低级格式化和高级格式化。

- 高级格式化：又称逻辑格式化，它是指根据用户选定的文件系统（如FAT12、FAT16、FAT32、NTFS、EXT2、EXT3、EXT4等），在磁盘的特定区域写入特定数据，以达到初始化磁盘或磁盘分区、清除原磁盘或磁盘分区中所有文件的一个操作。高级格式化包括对主引导记录中分区表相应区域的重写、根据用户选定的文件系统，在分区中划出一片用于存放文件分配表、目录表等用于文件管理的磁盘空间，以便用户使用该分区管理文件。
- 低级格式化：低级格式化（Low-Level Formatting）又称低层格式化或物理格式化（Physical Format），对于部分硬盘制造厂商，它也被称为初始化（initialization）。多数情况下，提及低级格式化，往往是指硬盘的填零操作。

### 分区格式

分区格式目前主要分为以下几种：

- FAT16：这是MS－DOS和最早期的Win 95操作系统中最常见的磁盘分区格式，能支持最大为2GB的分区。
- FAT32：这种格式采用32位的文件分配表，使其对磁盘的管理能力大大增强，突破了FAT16对每一个分区的容量只有2GB的限制。单个分区最大容量为124.55GB，单个文件最大支持4GB。
- NTFS：的优点是安全性和稳定性极其出色，在使用中不易产生文件碎片。它能对用户的操作进行记录，通过对用户权限进行非常严格的限制，使每个用户只能按照系统赋予的权限进行操作，充分保护了系统与数据的安全。
- Linux：它的除了支持常用的FAT32、FAT16、NTFS等分区外，还支持它特有的分区格式。Linux分区主要有两种，一种是Linux Native主分区，一种是Linux Swap交换分区。这两种分区格式的安全性与稳定性极佳，结合Linux操作系统后，死机的机会大大减少。但是，目前支持这一分区格式的操作系统只有Linux。

### Linux的设备文件名 

Linux的设备命名规则如下表： 

| 硬件              | 设备英文名           |
| ----------------- | -------------------- |
| IDE硬盘           | /dev/hd[a-d]         |
| SCSI/SATA/USB硬盘 | /dev/sd[a-p]         |
| 光驱              | /dev/cdrom或/dev/hdc |
| 软盘              | /dev/fd[0-1]         |
| 打印机(25针)      | /dev/lp[0-2]         |
| 打印机(USB)       | /dev/usb/lp[0-15]    |
| 鼠标              | /dev/mouse           |



### Linux分区命名 

- 在Windows中，硬盘分区命名是按照大写字母设置盘符，但是在Linux中命名规则是完全不同的。 
- /dev/hda1：hd表示IDE接口的硬盘，a表示第一块硬盘，1表示第一个分区。`这里注意，由于主分区占据了前面1-4的分区位，所以第一个逻辑分区是从5开始的。`
- /dev/sda1：SD表示SCSI接口的硬盘或者SATA接口的硬盘， a表示第一块硬盘，1表示第一个分区。  

### 挂载

- Linux下分区不称为分区，叫做挂载，分完区后必须要进行挂载，Linux采用的是树形结构的文件系统，所以分区必须挂载到指定的目录下，才能进行文件的存取。
- 必须挂载的分区： 
  - /：跟分区
  - swap：交换分区，相当于Windows里面的虚拟内存。一般内存的2倍。
- 推荐挂载的分区： /boot：引导分区，推荐200-500MB。

### Linux目录结构 

- 了解Linux目录结构对于学习Linux非常重要。进入linux根目录输入ls命令。

  ```shell
  [root@localhost /]# cd /
  [root@localhost /]# ls
  bin   data  etc   lib    lost+found  misc  net  proc  sbin     srv  tmp  var
  boot  dev   home  lib64  media       mnt   opt  root  selinux  sys  usr  zookeeper.out
  [root@localhost /]# 
  ```

| 目录                                                         | 描述                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| /                                                            | 第一层次结构的根、整个文件系统层次结构的[根目录](http://zh.wikipedia.org/wiki/%E6%A0%B9%E7%9B%AE%E5%BD%95)。 |
| /bin/                                                        | 需要在[单用户模式](http://zh.wikipedia.org/w/index.php?title=%E5%8D%95%E7%94%A8%E6%88%B7%E6%A8%A1%E5%BC%8F&action=edit&redlink=1)可用的必要命令（[可执行文件](http://zh.wikipedia.org/wiki/%E5%8F%AF%E6%89%A7%E8%A1%8C%E6%96%87%E4%BB%B6)）；面向所有用户，例如：[cat](http://zh.wikipedia.org/wiki/Cat_(Unix))、[ls](http://zh.wikipedia.org/wiki/Ls)、[cp](http://zh.wikipedia.org/wiki/Cp_(Unix))，和/usr/bin类似。 |
| [/boot/](http://zh.wikipedia.org/w/index.php?title=/boot/&action=edit&redlink=1) | [引导程序](http://zh.wikipedia.org/wiki/%E5%BC%95%E5%AF%BC%E7%A8%8B%E5%BA%8F)文件，例如：[kernel](http://zh.wikipedia.org/wiki/%E5%86%85%E6%A0%B8)、[initrd](http://zh.wikipedia.org/wiki/Initrd)；时常是一个单独的分区[[6\]](http://zh.wikipedia.org/wiki/%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9F%E5%B1%82%E6%AC%A1%E7%BB%93%E6%9E%84%E6%A0%87%E5%87%86#cite_note-6) |
| **/dev/**                                                    | 必要[设备](http://zh.wikipedia.org/wiki/%E8%AE%BE%E5%A4%87%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9F), 例如：, [/dev/null](http://zh.wikipedia.org/wiki/dev/null). |
| **/etc/**                                                    | 特定主机，系统范围内的[配置文件](http://zh.wikipedia.org/w/index.php?title=%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6&action=edit&redlink=1)。关于这个名称目前有争议。在贝尔实验室关于UNIX实现文档的早期版本中，/etc 被称为[/etcetra 目录](http://zh.wikipedia.org/w/index.php?title=Et_cetera&action=edit&redlink=1)，[[7\]](http://zh.wikipedia.org/wiki/%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9F%E5%B1%82%E6%AC%A1%E7%BB%93%E6%9E%84%E6%A0%87%E5%87%86#cite_note-7)这是由于过去此目录中存放所有不属于别处的所有东西（然而，FHS限制/etc存放静态配置文件，不能包含二进制文件）。[[8\]](http://zh.wikipedia.org/wiki/%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9F%E5%B1%82%E6%AC%A1%E7%BB%93%E6%9E%84%E6%A0%87%E5%87%86#cite_note-8)自从早期文档出版以来，目录名称已被以各种方式重新称呼。最近的解释包括[反向缩略语](http://zh.wikipedia.org/w/index.php?title=%E5%8F%8D%E5%90%91%E7%BC%A9%E7%95%A5%E8%AF%AD&action=edit&redlink=1)如："可编辑的文本配置"（英文 "Editable Text Configuration"）或"扩展工具箱"（英文 "Extended Tool Chest")。[[9\]](http://zh.wikipedia.org/wiki/%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9F%E5%B1%82%E6%AC%A1%E7%BB%93%E6%9E%84%E6%A0%87%E5%87%86#cite_note-9) |
| /etc/opt/                                                    | /opt/的配置文件                                              |
| /etc/X11/                                                    | [X_Window系统](http://zh.wikipedia.org/wiki/X_Window%E7%B3%BB%E7%BB%9F)(版本11)的配置文件 |
| /etc/sgml/                                                   | [SGML](http://zh.wikipedia.org/wiki/SGML)的配置文件          |
| /etc/xml/                                                    | [XML](http://zh.wikipedia.org/wiki/XML)的配置文件            |
| **/home/**                                                   | 用户的[家目录](http://zh.wikipedia.org/wiki/%E5%AE%B6%E7%9B%AE%E5%BD%95)，包含保存的文件、个人设置等，一般为单独的分区。 |
| /lib/                                                        | /bin/ and /sbin/中二进制文件必要的[库](http://zh.wikipedia.org/wiki/%E5%BA%93)文件。 |
| /media/                                                      | 可移除媒体(如[CD-ROM](http://zh.wikipedia.org/wiki/CD-ROM))的挂载点 (在FHS-2.3中出现)。 |
| /lost+found                                                  | 在ext3文件系统中，当系统意外崩溃或机器意外关机，会产生一些文件碎片在这里。当系统在开机启动的过程中fsck工具会检查这里，并修复已经损坏的文件系统。当系统发生问题。可能会有文件被移动到这个目录中，可能需要用手工的方式来修复，或移到文件到原来的位置上。 |
| /mnt/                                                        | 临时[挂载](http://zh.wikipedia.org/w/index.php?title=%E6%8C%82%E8%BD%BD&action=edit&redlink=1)的文件系统。比如cdrom,u盘等，直接插入光驱无法使用，要先挂载后使用 |
| /opt/                                                        | 可选[应用软件](http://zh.wikipedia.org/wiki/%E5%BA%94%E7%94%A8%E8%BD%AF%E4%BB%B6)[包](http://zh.wikipedia.org/wiki/%E8%BD%AF%E4%BB%B6%E5%8C%85)。 |
| **/proc/**                                                   | 虚拟[文件系统](http://zh.wikipedia.org/wiki/%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9F)，将[内核](http://zh.wikipedia.org/wiki/%E5%86%85%E6%A0%B8)与[进程](http://zh.wikipedia.org/wiki/%E8%BF%9B%E7%A8%8B)状态归档为文本文件（系统信息都存放这目录下）。例如：uptime、 network。在Linux中，对应[Procfs](http://zh.wikipedia.org/wiki/Procfs)格式挂载。该目录下文件只能看不能改（包括root） |
| /root/                                                       | [超级用户](http://zh.wikipedia.org/wiki/%E8%B6%85%E7%BA%A7%E7%94%A8%E6%88%B7)的[家目录](http://zh.wikipedia.org/wiki/%E5%AE%B6%E7%9B%AE%E5%BD%95) |
| **/sbin/**                                                   | 必要的系统二进制文件，例如： init、 ip、 mount。sbin目录下的命令，普通用户都执行不了。 |
| /srv/                                                        | 站点的具体[数据](http://zh.wikipedia.org/wiki/%E6%95%B0%E6%8D%AE)，由系统提供。 |
| /tmp/                                                        | 临时文件(参见 /var/tmp)，在系统重启时目录中文件不会被保留。  |
| /usr/                                                        | 默认软件都会存于该目录下。用于存储只读用户数据的第二层次；包含绝大多数的([多](http://zh.wikipedia.org/wiki/%E5%A4%9A%E7%94%A8%E6%88%B7))用户工具和应用程序。 |
| **/var/**                                                    | 变量文件——在正常运行的系统中其内容不断变化的文件，如日志，脱机文件和临时电子邮件文件。有时是一个单独的分区。如果不单独分区，有可能会把整个分区充满。如果单独分区，给大给小都不合适。 |

![1038183-20170505222921226-1482326382](http://www.znsd.com/znsd/courses/uploads/7202f5267d0d62195fcb74dc59a02658/1038183-20170505222921226-1482326382.png)

### 总结 

- 知道什么是Linux。Linux有哪些优势。
- Linux的应用领域有哪些？
- Linux的分区规则。
- 了解使用虚拟机安装Linux系统。
- 了解Linux的目录和作用。