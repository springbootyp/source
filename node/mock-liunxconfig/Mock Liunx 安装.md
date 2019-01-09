# Mock Liunx 安装

### 4.3.4 本地部署easy-mock

（1）项目下载地址：  https://github.com/easy-mock/easy-mock

（2）将easy-mock-dev.zip上传至服务器

（3）安装zip 和unzip 

```
yum install zip unzip

```

（4）解压

```
unzip easy-mock-dev.zip

```

（3）进入其目录，安装依赖

```
npm install

```

（4）执行构建

```
npm run build

```

（5）启动

```
npm run start

```

（6）打开浏览器  http://192.168.184.131:7300

![](H:/%E5%AD%A6%E4%B9%A0%E8%B5%84%E6%96%99/%E8%A7%86%E9%A2%91/%E9%A1%B9%E7%9B%AE%E8%A7%86%E9%A2%91/%E5%8D%81%E6%AC%A1%E6%96%B9/%E5%89%8D%E7%AB%AF/%E5%89%8D%E7%AB%AF%E5%BC%80%E5%8F%91%E8%B5%84%E6%BA%90/%E8%AE%B2%E4%B9%89%EF%BC%88MD%EF%BC%89/image/2-9.png)



### 异常

```
npm 一个神坑

当前npm版本 5.6.0 
node版本8.11.3

在使用 vue create paascloud-uac-web的时候报错

npm ERR! Unexpected end of JSON input while parsing near '...ostcss-modules-values'

npm ERR! A complete log of this run can be found in:
npm ERR!     /Users/liuzhaoming/.npm/_logs/2018-06-28T12_11_20_108Z-debug.log
command failed: npm install --loglevel error --registry=https://registry.npm.taobao.org --disturl=https://npm.taobao.org/dist

尝试使用 vue ui解决 无效 
卸载 node 无效 
mac 卸载node的方式

sudo rm -rf /usr/local/{bin/{node,npm},lib/node_modules/npm,lib/node,share/man/*/node.*}
1
最后清除npm cache问题解决, 这里记录一下, 希望能帮到有缘人

npm cache clean --force
--------------------- 
作者：liu_zhaoming 
来源：CSDN 
原文：https://blog.csdn.net/liu_zhaoming/article/details/80848639 
版权声明：本文为博主原创文章，转载请附上博文链接！
```

