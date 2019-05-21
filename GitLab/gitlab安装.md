# GitLab安装

​	<https://blog.csdn.net/qq_32106647/article/details/81586506>

1. sudo apt install ca-certificates postfix

2. curl https://packages.gitlab.com/gpg.key 2> /dev/null | sudo apt-key add - &>/dev/null

3. /etc/apt/sources.list.d/gitlab-ce.list

4. ```
   deb https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/ubuntu xenial main
   ```

5. ```
   sudo apt-get update
   ```

6. ```
   sudo apt-get install gitlab-ce
   ```

7. service postfix start

8. sudo gitlab ctl reconfigure

9. sudo gitlab-ctl status



​	安装git 的客户端

​	1.apt install git

​	2.git --version

​	3.

1. 速冻gitlab-ctl