**VMware Workstation 10序列号** 

DG1QH-FHHEJ-A8YTX-G8YX3-5ALCH

MA491-6NL5Q-AZAM0-ZH0N2-AAJ5A

5A6F6-88247-XZH59-HL0Q6-8CD2V

HF6QX-20187-2Z391-522NH-9AELT

5F29M-48312-8ZDF9-A8A5K-2AM0Z

**VMware Workstation 14序列号**

AA702-81D8N-0817Y-75PQT-Q70A4

YC592-8VF55-M81AZ-FWW5T-WVRV0

FC78K-FKED6-H88LZ-0QPEE-QP8X6

UV1H2-AKWD2-H8EJZ-GGMEE-PCATD

AC310-0VG0P-M88CQ-YWY5Z-QPRG0

## CentOS系统时间同步

```shell

    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    
    ntpdate us.pool.ntp.org
    
    # 没有安装ntpdate的可以yum一下:，已经安装就不用执行了
    yum install -y ntpdate

    # 加入定时计划任务，每隔10分钟同步一下时钟
    crontab -e
    
    0-59/10 * * * * /usr/sbin/ntpdate us.pool.ntp.org | logger -t NTP

```