# Nginx在Liunx中安装



1.yum install Nginx

2.yum list | grep nginx

3.rpm -qa nginx 

4.rpm -ql nginx-1.12.2-2.el7.x86_64

5.安装路径 /usr/sbin/nginx

配置文件/etc/nginx/nginx.conf

```

```



```java
 
/etc/logrotate.d/nginx
/etc/nginx/fastcgi.conf
/etc/nginx/fastcgi.conf.default
/etc/nginx/fastcgi_params
/etc/nginx/fastcgi_params.default
/etc/nginx/koi-utf
/etc/nginx/koi-win
/etc/nginx/mime.types
/etc/nginx/mime.types.default
/etc/nginx/nginx.conf
/etc/nginx/nginx.conf.default
/etc/nginx/scgi_params
/etc/nginx/scgi_params.default
/etc/nginx/uwsgi_params
/etc/nginx/uwsgi_params.default
/etc/nginx/win-utf
/usr/bin/nginx-upgrade
/usr/lib/systemd/system/nginx.service
/usr/lib64/nginx/modules
/usr/sbin/nginx
/usr/share/doc/nginx-1.12.2
/usr/share/doc/nginx-1.12.2/CHANGES
/usr/share/doc/nginx-1.12.2/README
/usr/share/doc/nginx-1.12.2/README.dynamic
/usr/share/doc/nginx-1.12.2/UPGRADE-NOTES-1.6-to-1.10
/usr/share/licenses/nginx-1.12.2
/usr/share/licenses/nginx-1.12.2/LICENSE
/usr/share/man/man3/nginx.3pm.gz
/usr/share/man/man8/nginx-upgrade.8.gz
/usr/share/man/man8/nginx.8.gz
/usr/share/nginx/html/404.html
/usr/share/nginx/html/50x.html
/usr/share/nginx/html/index.html
/usr/share/nginx/html/nginx-logo.png
/usr/share/nginx/html/poweredby.png
/usr/share/vim/vimfiles/ftdetect/nginx.vim
/usr/share/vim/vimfiles/indent/nginx.vim
/usr/share/vim/vimfiles/syntax/nginx.vim
/var/lib/nginx
/var/lib/nginx/tmp
/var/log/nginx




6.开启服务 sytemctl start nginx		或者  Nginx  直接启动
7.systemctl status nginx  
8.测试 
	netstat -antp
	重启 systemctl restart nginx
9.文件路径
	/usr/share/nginx/html
10.vi index.html
11 关闭服务 
	systemctl stop nginx
	
注意点，如果是直接通过Nginx 命令进行启动的话，是不能够用systemctl 命令去结束的。 具体表现为命令执行成功，但是进程不会被销毁
可以通过nginx -s stop  或者  kill 进程
	

12.当然Nginx可以配置很多东西
	列如什么ssl ，虚拟主机，解析引擎
	
	
	
	























```

