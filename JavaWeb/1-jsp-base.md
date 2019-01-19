## 第一章 动态网页开发基础

### 本课目标

- 使用JSP实现Web站点开发
- 使用Servlet实现程序业务控制

### 相关课程回顾

- JDBC包括哪些类和接口，作用是什么？
- JDBC连接数据库的步骤是什么？
- CSS中选择器包括几种？
- 常用的样式属性。

### 本章任务

- 实现Tomcat的手动部署和发布Web应用

- 实现页面输出显示闰年个数

- 使用Eclipse部署和发布Web应用

  ![image](http://www.znsd.com/znsd/courses/uploads/68482325575f48a931207579c860ca02/image.png)
  ![image](http://www.znsd.com/znsd/courses/uploads/cfc57992e4fe4bfe8dc171c63a195158/image.png)
  ![image](http://www.znsd.com/znsd/courses/uploads/e0443540b374d469915b3976213c8ba3/image.png)

### 本章目标

- 了解B/S结构的基本概念`重点（难点）`
- 掌握手动创建和运行Web项目`重点`
- 掌握JSP页面元素的内容`重点`
- 掌握使用Eclipse创建和运行Web项目
- 了解Web程序的调试与排错
- 掌握include的用法

### 什么是动态网页

![日常生活中的动态网页，根据不同的输入(或操作)，返回不同的网页](http://www.znsd.com/znsd/courses/uploads/a564d7c99570ea30e10f0349b493ba20/image.png)

- 动态网页：网页文件里包含了程序代码，通过后台数据库与WEB服务器的信息交互，由后台数据库提供实时数据更新和数据查询服务。
- 通俗的讲：动态就是里面的内容可以在不影响页面的情况下更改，以不变应万变。静态就是整个版面像一幅画一样如果要修改就要全部修改好再重新上传。

### 为什么需要动态网页

- 假如淘宝网是静态网站，就无法实现搜索、购买、登录等交互功能，无法对静态页面的内容进行实时更新

![20180123103703](http://www.znsd.com/znsd/courses/uploads/6f654beb1267e591bea61898e51339dc/20180123103703.png)

#### 静态网页

在网站设计中，纯粹HTML（标准通用标记语言下的一个应用）格式的网页通常被称为“静态网页”，静态网页是标准的HTML文件，它的文件扩展名是.htm、.html，可以包含文本、图像、声音、FLASH动画、客户端脚本和ActiveX控件及JAVA小程序等。静态网页是网站建设的基础，早期的网站一般都是由静态网页制作的。静态网页是相对于动态网页而言，是指没有后台数据库、不含程序和不可交互的网页。静态网页相对更新起来比较麻烦，适用于一般更新较少的展示型网站。容易误解的是静态页面都是htm这类页面，实际上静态也不是完全静态，他也可以出现各种动态的效果，如GIF格式的动画、FLASH、滚动字幕等。

#### 动态网页

动态网站并不是指具有动画功能的网站，而是指网站内容可根据不同情况动态变更的网站，一般情况下动态网站通过数据库进行架构。 动态网站除了要设计网页外，还要通过数据库和编程序来使网站具有更多自动的和高级的功能。动态网站体现在网页一般是以asp，jsp，php，aspx等结束，而静态网页一般是HTML（标准通用标记语言的子集）结尾，动态网站服务器空间配置要比静态的网页要求高，费用也相应的高，不过动态网页利于网站内容的更新，适合企业建站。动态是相对于静态网站而言。

#### 两者区别

1. 网页制作使用的制作语言：静态网页使用语言：超文本标记语言（标准通用标记语言的一个应用）; 动态网页使用语言：超文本标记语言+ASP或超文本标记语言+PHP或超文本标记语言+JSP等。
2. 程序是否在服务器端运行，是重要标志。在服务器端运行的程序、网页、组件，属于动态网页，它们会随不同客户、不同时间，返回不同的网页， ASP、PHP、JSP、ASPnet、CGI等。运行于客户端的程序、网页、插件、组件，属于静态网页，例如 html 页、Flash、JavaScript、VBScript等等，它们是永远不变的。

#### 静态网页缺点

- 任何个性化或交互都会运行在客户端之上。
- 没有自动化的工具，维护大量的静态页面文件是不现实的。
- 无法充分支持用户/客户的需求（外观选择，浏览器的支持，Cookie）。
- 不支持PHP等语言进行服务器端运算.
- 不支持数据库,因此不能在服务器端储存如用户信息.

### 常用的动态网页技术

- ASP（Active Server Page）

  **ASP技术**是基于.NET平台的一种动态网页技术。它有非常强大的后台处理能力，但却有一些安全性、稳定性、跨平台性的问题。ASP只支持Windows平台，对Linux、Unix不支持。

- PHP（Hypertext Preprocessor）

  PHP原始为Personal Home Page的缩写，已经正式更名为（外文名:PHP: Hypertext Preprocessor，中文名：“超文本预处理器”）是一种通用开源脚本语言。语法吸收了C语言、Java的特点，利于学习，使用广泛，主要适用于Web开发领域。PHP是HTML内嵌式的语言，这一点类似于ASP，并且PHP可以跨平台。但PHP的数据库接口不规范。但是对每种数据库接口的开发都不同极大地加重了开发者的负担，并且缺少企业级应用的支持。

- JSP/Servlet（Java Server Page）

  **JSP技术**在基于java的平台上广泛地使用，是进行Java web开发的一种核心组件。JSP页面由HTML代码和嵌入在其中的Java脚本组成。JSP可以一次编写，到处运行。这一点JSP比PHP技术更有优势，在不同的系统平台上运行，代码不用做任何修改。

### 如何实现动态网页

![要掌握这一切，我们首先需要了解B/S技术](http://www.znsd.com/znsd/courses/uploads/a564d7c99570ea30e10f0349b493ba20/image.png)

- 百度如何保存业务数据？
- 百度如何实现业务数据的动态显示？

### 为什么学习B/S技术

- CS：即Client/Server（客户机/服务器）结构，C/S结构在技术上很成熟，它的主要特点是交互性强、具有安全的存取模式、网络通信量低、响应速度快、利于处理大量数据。但是该结构的程序是针对性开发，变更不够灵活，维护和管理的难度较大。通常只局限于小型局域网，不利于扩展。并且，由于该结构的每台客户机都需要安装相应的客户端程序，分布功能弱且兼容性差，不能实现快速部署安装和配置，因此缺少通用性，具有较大的局限性。要求具有一定专业水准的技术人员去完成。


- C/S程序有那些

  ![20180123105031](http://www.znsd.com/znsd/courses/uploads/025d0374a09ebdd79b5b46d6d19cd204/20180123105031.png)

- B/S程序有哪些

  ![20180123105552](http://www.znsd.com/znsd/courses/uploads/0fb2980e88449b6d62601ddc05247d12/20180123105552.png)

- C/S与B/S的不同。何种情况应该用C/S架构，何种情况用B/S架构。它们之间的优缺点是什么。日常生活中哪个是C/S架构的，哪个又是B/S架构的。

### 什么是B/S技术

- BS：即Browser/Server（浏览器/服务器）结构，就是只安装维护一个服务器（Server），而客户端采用浏览器（Browse）运行软件。B/S结构应用程序相对于传统的C/S结构应用程序是一个非常大的进步。 B/S结构的主要特点是分布性强、维护方便、开发简单且共享性强、总体拥有成本低。但数据安全性问题、对服务器要求过高、数据传输速度慢、软件的个性化特点明显降低，这些缺点是有目共睹的，难以实现传统模式下的特殊功能要求。例如通过浏览器进行大量的数据输入或进行报表的应答、专用性打印输出都比较困难和不便。此外，实现复杂的应用构造有较大的困难。


- BS程序中的数据库服务器不是必需的，简单的应用可能会用同一个服务器。用户通过浏览器访问应用程序，它是基于Internet的产物。

![20180123105741](http://www.znsd.com/znsd/courses/uploads/353316e09c0de7fbe960de598f5b32ca/20180123105741.png)

### CS与BS的比较

| 对象   | 硬件环境                       | 客户端要求            | 软件安装                     | 升级和维护                     | 安全性                                      |
| ---- | -------------------------- | ---------------- | ------------------------ | ------------------------- | ---------------------------------------- |
| C/S  | 用户固定，并且处于相同区域，要求拥有相同的操作系统。 | 客户端的计算机电脑配置要求较高。 | 每一个客户端都必须安装和配置软件.        | C/S每一个客户端都要升级程序。可以采用自动升级。 | 一般面向相对固定的用户群，程序更加注重流程，它可以对权限进行多层次校验，提供了更安全的存取模式，对信息安全的控制能力很强。一般高度机密的信息系统采用C/S结构适宜。 |
| B/S  | 要有操作系统和浏览器，与操作系统平台无关。      | 客户端的计算机电脑配置要求较低。 | 可以在任何地方进行操作而不用安装任何专门的软件。 | 不必安装及维护                   | 一般面向相对固定的用户群，程序更加注重流程，它可以对权限进行多层次校验，提供了更安全的存取模式，对信息安全的控制能力很强。一般高度机密的信息系统采用C/S结构适宜。 |

#### B/S技术的工作原理

- 如：去百度搜索某关键字、去淘宝购物等。

![20180123114443](http://www.znsd.com/znsd/courses/uploads/dfbb56bed008a9e92727cc04b1d68f9e/20180123114443.png)

### URL

- URL：Uniform Resource Locator的缩写，代表“统一资源定位符”，即我们常说的网址URL是唯一能识别Internet上具体的计算机、目录或文件夹位置的命名约定

- 组成

  ```js
  http://localhost:8080/news/index.html
  // http 协议部分 
  // localhost:8080 主机IP地址:端口号
  // news 项目名称
  // index.html 项目资源地址
  ```

### Tomcat服务器简介

- Tomcat官网http://tomcat.apache.org/


- Tomcat是Apache 软件基金会（Apache Software Foundation）的Jakarta 项目中的一个核心项目，由Apache、Sun和其他一些公司及个人共同开发而成。由于有了Sun 的参与和支持，最新的Servlet 和JSP 规范总是能在Tomcat 中得到体现，Tomcat 5支持最新的Servlet 2.4 和JSP 2.0 规范。因为Tomcat 技术先进、性能稳定，而且免费，因而深受Java 爱好者的喜爱并得到了部分软件开发商的认可，成为目前比较流行的Web 应用服务器。

- Tomcat 服务器是一个免费的开放源代码的Web 应用服务器，属于轻量级应用服务器，在中小型系统和并发访问用户不是很多的场合下被普遍使用，是开发和调试JSP 程序的首选。另外Tomcat是一个Servlet和JSP容器，独立的Servlet容器是Tomcat的默认模式。不过，Tomcat处理静态HTML的能力不如Apache服务器。目前Tomcat最新版本为9.0

- Tomcat最初是由Sun的软件构架师詹姆斯·邓肯·戴维森开发的。后来他帮助将其变为开源项目，并由Sun贡献给Apache软件基金会。由于大部分开源项目O'Reilly都会出一本相关的书，并且将其封面设计成某个动物的素描，因此他希望将此项目以一个动物的名字命名。因为他希望这种动物能够自己照顾自己，最终，他将其命名为Tomcat（英语公猫或其他雄性猫科动物）。而O'Reilly出版的介绍Tomcat的书籍（ISBN 0-596-00318-8）[1]的封面也被设计成了一个公猫的形象。而Tomcat的Logo兼吉祥物也被设计成了一只公猫。

  ![20180123201833](http://www.znsd.com/znsd/courses/uploads/511b7c3f1b5557f50e246b04c9c0b11a/20180123201833.png)

### Tomcat服务器应用

**解压缩版本Tomcat的安装**

- 添加系统变量，名称为CATALINA_HOME
- 设置值为Tomcat的安装目录

**启动和停止Tomcat服务器**

- 进入CATALINA_HOME/bin目录，找到startup.bat启动tomcat

**Tomcat服务启动检测**

- 在IE浏览器（或者其他浏览器）地址栏中输入  

- http://localhost:端口号

- 页面进入到Tomcat启动成功界面

  ![20180123202452](http://www.znsd.com/znsd/courses/uploads/445eb9923f692996c30952b50ebd7b5a/20180123202452.png)

### Tomcat的目录结构

![5499281-debf22122769ba90](http://www.znsd.com/znsd/courses/uploads/dcee4ff83dbf3b35f5f7c4c80296d6ce/5499281-debf22122769ba90.png)

| 目录         | 说明                               |
| ---------- | -------------------------------- |
| `/bin`     | 存放各种平台下用于启动和停止Tomcat的脚本文件        |
| `/conf`    | 存放Tomcat服务器的各种配置文件               |
| /lib       | 存放Tomcat服务器所需的各种JAR文件            |
| /logs      | 存放Tomcat的日志文件                    |
| /temp      | Tomcat运行时用于存放临时文件                |
| `/webapps` | 当发布Web应用时，默认情况下会将Web应用的文件存放于此目录中 |
| /work      | Tomcat把由JSP生成的Servlet放于此目录下      |

- conf是用来存放tomcat的配置文件。
- server.mxl：代表的服务器的相关配置。
- content.xml：内容配置。配置连接池信息。
- web.xml：配置站点信息。（所有站点默认的配置）
- tomcat-user.xml：权限配置

### Tomcat的端口配置

- 通过配置文件server.xml修改Tomcat端口号，Tomcat端口号默认使用的是`8080`端口

```xml
<Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
<!-- http://localhost:8080 -->
```

```xml
<Connector port="6060" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
<!-- http://localhost:6060 -->
```

### 常用默认端口

| 应用         | 端口   |
| ---------- | ---- |
| Oracle     | 1521 |
| SQL Server | 1433 |
| MySQL      | 3306 |
| Tomcat     | 8080 |
| 浏览器        | 80   |
| SSH        | 22   |

### 学员操作——配制和启动Tomcat

#### 练习

- 需求说明：使用压缩版Tomcat，配置环境变量、启动、停止Tomcat，并访问Tomcat主页面,之后再修改修改端口号并测试

#### 提示

- 添加系统变量，名称为CATALINA_HOME
- 配置文件server.xml修改Tomcat端口号

![20180123202452](http://www.znsd.com/znsd/courses/uploads/445eb9923f692996c30952b50ebd7b5a/20180123202452.png)

完成时间：10分钟

### 设计Web项目的目录结构

![20180123204001](http://www.znsd.com/znsd/courses/uploads/a5b91c5e6b3bd658d33c960766e7ea9a/20180123204001.png)

- **NewsManager** 是创建的项目名字，这个名字自己可以随便创建，只要符合命名规则。
- **src** 源程序，也就是你写的 java 代码。
- **JRE System Library** 指Java SE 的常用库文件集合，也就是 jar 包
- **Apache Tomcat v7.0** 是指这个项目所依赖的服务器（Tomcat）的目录。
- **Web App Libraries** 是自己导入的项目依赖 jar 包，Web App Libraries 下的所有 jar 包都可以在本地的项目名\WebContent\WEB-INF\lib 中找到。如果你直接在WEB-INF/lib文件夹下，copy 一个 jar 包，刷新一下，会自动编译到 Web App Library 中
- **build：**eclipse新建的 Dynamic web project 默认是将类编译在 build 文件夹下。可以在本地的**项目名\build\classes** 下查看。
- **WebContent**一般我们用 Eclipse 的时候创建一个 Web Project，就会生成 WebContent 文件夹，用 MyEclipse 的时候创建一个 Web Project，就会生成 WebRoot 文件夹，这两个文件夹作用一样只是名称不同而已。WebContent 用来存放 JSP，JS，CSS，图片等文件，**是项目访问的默认路径，也是工程的发布文件夹，发布时会把该文件夹发布到 tomcat 的 webapps 里**
- **META-INF：**存放一些 meta information 相关的文件的这么一个文件夹, 一般来说尽量不要自己手工放置文件到这个文件夹。
- **WEB-INF：**WEB-INF 目录是一个专用区域， 容器不能把此目录中的内容提供给用户。这个目录下的文件只供容器使用，里面包含不应该由客户直接下载的资源。**Web 容器要求在你的应用程序中必须有 WEB-INF 目录。WEB-INF 中包含着发布描述符（也就是 web.xml 文件）, 一个 classes 目录和一个 lib目录, 以及其它内容。注意： 如果你的 Web 应用程序中没有包含这个目录, 它可能将无法工作 。**
- **web.xml：**发布描述符(deployment descriptors)是 J2EE Web 应用程序不可分割的一部分(也就是说是它的最小部分, 必不可缺的一部分)。它们在应用程序发布之后帮助管理 Web 应用程序的配置。
- **WEB-INF/classes** 目录，编译后的 Java类，src目录下的所有java或者其他资源文件（如xml、properties文件）打包发布之后可在该文件夹找到
- **WEB-INF/lib** 目录，该目录中的 jar 包是运行时环境下使用的 jar 包, 所谓运行时环境下使用的 jar 包,就是说你在运行你的项目的时候所需要使用的 jar 包的集合。

### 配置访问页面

- 通过配置文件web.xml修改访问起始页

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns="http://java.sun.com/xml/ns/javaee"
	xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
	id="WebApp_ID" version="2.5">
  	<display-name>test</display-name>
	<welcome-file-list>
		<welcome-file>index.html</welcome-file>
		<welcome-file>index.htm</welcome-file>
		<welcome-file>index.jsp</welcome-file>
		<welcome-file>default.html</welcome-file>
		<welcome-file>default.htm</welcome-file>
		<welcome-file>default.jsp</welcome-file>
	</welcome-file-list>
</web-app>
```

- 假定在web应用(test)下存在一个index.jsp页面，输入http://localhost:8080/test 地址时，web容器会默认调用index.jsp页面 ，搜索次序是从上往下查找，如果找不到会出现404错误代码

### 创建、部署和发布项目

手动部署和发布项目步骤

- 编写Web应用的代码
- 在webapps目录下创建应用文件目录
- 将创建的页面复制到应用目录下
- 启动Tomcat服务并进行访问

### 学员操作——手动创建Web项目

- 需求说明：手动创建一个简单的Web项目，实现项目发布，并能通过浏览器输入网址访问

- 完成时间：15分钟

  ![20180123210256](http://www.znsd.com/znsd/courses/uploads/db1f566139b8533b1e01e8b9767fc279/20180123210256.png)

### 什么是JSP

- JSP (Java Server Pages) 是java服务页面
- 可以在HTML中嵌入Java脚本代码

```html
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>输出当前日期</title>
</head>
<body>
	你好，今天是
	<%
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String currentDateStr = dateFormat.format(new Date());
	%>
	<%=currentDateStr%>
</body>
</html>
```

![image](http://www.znsd.com/znsd/courses/uploads/c0597129e3ae422a19f03cc7e24878bf/image.png)

### JSP中的page指令

- 通过设置内部的多个属性定义整个页面的属性

- 语法：

  ```html
  <%@ page 属性1="属性值" 属性2="属性值1,属性值2"… 属性n="属性值n"%>
  ```

- 常用属性

| 属性          | 描述                        | 默认值                    |
| ----------- | ------------------------- | ---------------------- |
| language    | 指定JSP页面使用的脚本语言            | java                   |
| import      | 通过该属性来引用脚本语言中使用到的类文件      | 无                      |
| contentType | 用来指定JSP页面所采用的编码方式         | text/html,  ISO-8859-1 |
| errorPage   | 用来指定一个出现异常进入的JSP 页面       | 空                      |
| isErrorPage | 表示当前页是否可以作为其他 JSP 页面的错误页面 | false                  |

### JSP中的小脚本与表达式

- 在JSP页面中计算两个数的和，将结果输出显示

```html
<!-- 指令 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>计算求和</title>
</head>
<body>
<!-- 小脚本（可写一些业务逻辑、条件判断、运算等） -->
<%
	int i = 4, j = 5;
	int result = i + j;
%>
<!-- 表达式 （输出到页面的结果）-->
<%=result%>
</body>
</html>
```

### 学员操作——计算从1加到100之和

- 训练要点：小脚本与表达式

- 需求说明：编写JSP页面，计算1加到100之和

  ![20180124093044](http://www.znsd.com/znsd/courses/uploads/0c3fefb7a75f234c23994c671a058470/20180124093044.png)

完成时间：20分钟

### JSP中的声明

JSP页面中定义方法

- 语法：

  ```html
  <%! Java代码%>
  ```

- 例子：

  ```html
  <%@page import="java.util.Date"%>
  <%@page import="java.text.SimpleDateFormat"%>
  <%@page import="java.text.DateFormat"%>
  <%@ page language="java" contentType="text/html; charset=UTF-8"
      pageEncoding="UTF-8"%>
  <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Insert title here</title>
  </head>
  <body>

  <%!
  	String formateDate(Date date) {
  		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
  		return dateFormat.format(date);
  	}
  %>
  格式化日期：<%=formateDate(new Date())%>
  </body>
  </html>
  ```

### JSP中的注释

- HTML的注释

  ```html
  <!-- html注释-->
  ```

- JSP注释

  ```html
  <%-- JSP注释 --%>
  ```

- 在JSP中java代码中的注释（其实就是java代码的注释）

  ```html
  <% //单行注释 %> 
  <%  /*多行注释 */ %>
  ```

`注意：`

- HTML注释：在客户端浏览器中可以查看。
- JSP注释：只能在JSP页面中查看，页面显示之后不能看到
- java代码注释：在生成的.java源码中查看。

### 小结

总结JSP页面元素

- 静态内容：HTML静态文本
- 指 令：以"<%@" 开始，以"%>" 结束
- 小脚本：<%Java代码%>
- 表达式：<%=Java表达式%>
- 声明：<%! 方法%>
- 注释 ：\<!-- 客户端可以查看到-->，<%-- 客户端不能查看到--%>

### 学员操作-计算闰年个数

- 训练要点：方法和注释

- 需求说明：编写JSP页面，计算2000—2018年中存在几个闰年

- 提示：闰年条件

  1. 年份能被4整除
  2. 不能被100整除
  3. 能被400整除。

  ![20180124095517](http://www.znsd.com/znsd/courses/uploads/f8de615805d12d390dc110b423f4c034/20180124095517.png)

### JSP执行过程 2-1

- Web容器处理JSP文件请求需要经过3个阶段

  1. 翻译阶段（将jsp文件翻译成java代码）
  2. 编译阶段
  3. 执行阶段

  ![20180124100029](http://www.znsd.com/znsd/courses/uploads/e41e458b66ebcdd29d5fd53b66adb9c0/20180124100029.png)

- Tomcat首先会把JSP生成的Servlet（java）代码并放于CATALINA_HOME/work目录下，然后找到所在的项目就可以找到编译后的jsp文件

### JSP执行过程 2-2

- 第一次请求之后，Web容器可以重用已经编译好的字节码文件

  ![20180124100518](http://www.znsd.com/znsd/courses/uploads/dee3830f8aac807a2616c85bfe78dc3b/20180124100518.png)

- `注意：`如果对JSP文件进行了修改，Web容器会重新对JSP文件进行翻译和编译 

### 使用集成开发工具创建Web项目

1. 创建新项目File->New->Dynamic Web Project
2. 给新项目命名
3. 目录结构，在WebContent目录下创建js、css、jsp文件测试

### 部署Web项目

#### 配置Tomcat

1. Window->Preferences->Servers->Runtime Environments
2. 点击Add按钮添加Tomcat版本及选择安装路径
3. 指定Tomcat运行Java的运行环境

#### 部署Web项目

1. 运行Eclipse项目
2. 选择需要部署的项目
3. 选择Tomcat服务器并确认

### 学员操作—使用集成工具创建Web项目

- 需求说明：在页面显示当前系统时间，要求使用Eclipse创建Dynamic Web项目

  ![20180124102441](http://www.znsd.com/znsd/courses/uploads/e58c0d67195ca4bbea72078c9083751c/20180124102441.png)

完成时间：15分钟

### 导入Web项目

- 将完成的项目导入到Eclipse中。

- File->Import->General->Existing Project into Workspace->select root directory->finish

  ![image](http://www.znsd.com/znsd/courses/uploads/b0e000462efadac90f72cc2d419ce59f/image.png)![image](http://www.znsd.com/znsd/courses/uploads/1e50080c9cb2a718dc52ee36e485f910/image.png)

### Web程序的调试与排错

![20180124103849](http://www.znsd.com/znsd/courses/uploads/0d0babe97bbade28fc8e258cae2f387d/20180124103849.png)

#### 常见错误：未启动Tomcat

- 错误现象

  ![image](http://www.znsd.com/znsd/courses/uploads/9e3919c457994191b86055e408a9d87a/image.png)

- 排错方法：检查Tomcat服务能否正确运行

- 排除错误：

  - 启动Tomcat服务
  - 如果控制台上显示Tomcat服务已启动，观察端口号是否与预期端口号一致，按照实际端口号重新运行

#### 常见错误：未部署Web应用

- 错误现象

  ![image](http://www.znsd.com/znsd/courses/uploads/8da283b95041bf7a0c0abc1ac97da1c2/image.png)

- 排错方法：检查Web应用是否正确部署

#### 常见错误：URL输入错误

- 错误现象

  ![20180124104600](http://www.znsd.com/znsd/courses/uploads/8651afcbfad0c550545af80d68559090/20180124104600.png)

- 排错方法：检查URL

  ```js
  http://localhost:6060/test/index.jsp
  ```

- 排除错误：使用正确的URL

#### 常见错误：目录不能被引用

- 错误现象

  ![image](http://www.znsd.com/znsd/courses/uploads/abd735f57add83baa375abf6b4c35c3f/image.png)

- 排错方法：检查文件的存放位置

- `META-INF，WEB-INF文件夹下的内容无法对外发布`

- 排除错误：把index.html文件拖至WebContent文件夹

### include指令2-1

- 在一个网页中，头部，尾部，左侧导航栏一般都是相同的，有没有办法避免冗余代码的出现？
- 可以将一些共性的内容写入一个单独的文件中，然后通过include指令引用该文件

### include指令2-2

- 创建头部页面文件 top.jsp

- 在后台首页面中使用include指令引用登录验证文件

- 静态包含

  ```html
  <%@ include file="top.jsp"%>  
  ```

- 动态包含

  ```html
  <jsp:include page="top.jsp" />
  ```

- `注意：`

  - jsp:include（动态包含）：这种会编译成两个独立的class，里面的资源无法共享。（先编译再包含）
  - include（静态包含）：这种会将两个页面编译成一个class，里面的资源可以共享。（先包含再编译）

### include指令2-3

**静态include和动态include的区别？**

- 相同点：都会将页面引入到另一个页面中。
- 不同点：
  - 静态include会将引用的jsp文件和当前的jsp文件生成为一个class文件，所以jsp中的变量是可以互相访问，两个页面中应尽量避免命名冲突。
  - 动态include会生成两个完全不同的class文件，所以jsp中的变量不可以互相访问。
  - 静态包含不能传参
- 适用场合：
  - 静态include不会检查所含文件的变化，适用于包含静态页面，直接将内容先包含后处理。
  - 动态include总是会检查所含文件中的变化，适合用于包含动态页面，并且可以带参数，先编译之后再进行处理。

### 学员操作——练习静态包含和动态包含

- 训练要点：使用include
- 需求说明：使用include指令引用头部、底部文件

完成时间：15分钟

### 总结 2-1

- 动态网页
- URL的组成部分
- 手动部署Web应用的步骤

### 总结 2-2

- JSP技术：在HTML中嵌入Java脚本语言
- JSP页面组成部分
- 两种include的区别？

### 作业

- B/S和C/S结构有什么优缺点？
- URL包括哪几个部分？
- 画图说明JSP的请求过程是什么样的？
- JSP页面元素包括哪些？
- 静态include和动态include有什么区别？分别适用什么场合？