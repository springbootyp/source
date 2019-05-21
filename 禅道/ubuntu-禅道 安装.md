禅道：9.8.1开源版本

环境： Ubuntu 16.04.1 LTS (GNU/Linux 4.4.0-91-generic x86_64)

#### 安装过程

1.登录服务器



![img](https:////upload-images.jianshu.io/upload_images/10055699-8acffd5620614f20.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/481/format/webp)

登录服务器

2.在禅道官网找到安装包链接并在服务器内下载之[禅道9.8.1](https://link.jianshu.com?t=http%3A%2F%2Fdl.cnezsoft.com%2Fzentao%2F9.8.1%2FZenTaoPMS.9.8.1.zbox_64.tar.gz)



![img](https:////upload-images.jianshu.io/upload_images/10055699-56c407184ab06e2b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/700/format/webp)

  下载安装包

3.ls查看安装包



![img](https:////upload-images.jianshu.io/upload_images/10055699-5342ee667dfa33d2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/700/format/webp)

  ls查看安装包  

4.一键解压安装，若安装过程显示无权限则在命令前加sudo



![img](https:////upload-images.jianshu.io/upload_images/10055699-8e046716f7e1654a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/700/format/webp)

解压安装到/opt文件夹下

5.若出现下图中的内容，则说明安装成功了



![img](https:////upload-images.jianshu.io/upload_images/10055699-96ce9c72d69f98e7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/701/format/webp)

安装成功

6./opt/zbox/zbox start 启动，无权限情况下需要加sudo



![img](https:////upload-images.jianshu.io/upload_images/10055699-43d67c2a29cfdfb0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/701/format/webp)

启动

7.访问服务器ip即可自定向到禅道平台



![img](https:////upload-images.jianshu.io/upload_images/10055699-3a67b07f8d35a884.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/704/format/webp)

  访问

8.默认管理员admin/123456登录开源版后进行平台初始化的设置，包括人员及平台名的修改等信息



![img](https:////upload-images.jianshu.io/upload_images/10055699-4d45ba07ff520981.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/943/format/webp)

初始化设置



#### 修改禅道配置命令

执行/opt/zbox/zbox start 命令开启Apache和Mysql。

执行/opt/zbox/zbox stop 命令停止Apache和Mysql。

执行/opt/zbox/zbox restart 命令重启Apache和Mysql。

可以使用/opt/zbox/zbox -h命令来获取关于zbox命令的帮助。

其中 -ap参数 可以修改Apache的端口，-mp参数 可以修改Mysql的端口。（比如**：/opt/zbox/zbox -ap 8080**）

因为我们一般会用到80和3306，所以启动的时候尽量修改成其他端口启动



![img](https:////upload-images.jianshu.io/upload_images/10055699-ac47ab3f45b8da37.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/697/format/webp)

8081端口访问，数据库使用3307端口