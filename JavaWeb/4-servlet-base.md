## 第四章 Servlet基础

### 本章任务

- 使用Servlet实现用户登录
- 编写Servlet类，获取初始化参数
- 编写Servlet类，获取系统上下文参数

![image](http://www.znsd.com/znsd/courses/uploads/b6f149f13f2cf18ee3b381494b5b7d6d/image.png)![image](http://www.znsd.com/znsd/courses/uploads/2267eecfffc1700680e5f8a9c924e928/image.png)![image](http://www.znsd.com/znsd/courses/uploads/1a1a051572e20e9b9e9f528857f95b45/image.png)![image](http://www.znsd.com/znsd/courses/uploads/9d2c12f52a884adb081f26ee887f94da/image.png)

### 本章目标

- 掌握Servlet的生命周期`重点`
- 了解Servlet API的常用接口和类
- 掌握Servlet的部署和配置`重点`
- 会使用Servlet处理用户请求`重点（难点）`

### 为什么需要Servlet

- 使用JSP技术如何编写服务器动态网页？

  ![20180126164853](http://www.znsd.com/znsd/courses/uploads/36f80b9377d7987245f0b94a55b15bff/20180126164853.png)

- 在JSP技术出现之前如何编写服务器动态网页？

  ![20180126164934](http://www.znsd.com/znsd/courses/uploads/972f477557587c156210522ee928d9ea/20180126164934.png)

### 什么是Servlet 

Java Servlet 是运行在 Web 服务器或应用服务器上的程序，它是作为来自 Web 浏览器或其他 HTTP 客户端的请求和 HTTP 服务器上的数据库或应用程序之间的中间层。使用 Servlet，您可以收集来自网页表单的用户输入，呈现来自数据库或者其他源的记录，还可以动态创建网页。

Java Servlet 通常情况下与使用 CGI（Common Gateway Interface，公共网关接口）实现的程序可以达到异曲同工的效果。但是相比于 CGI，Servlet 有以下几点优势：

- 性能明显更好。
- Servlet 在 Web 服务器的地址空间内执行。这样它就没有必要再创建一个单独的进程来处理每个客户端请求。
- Servlet 是独立于平台的，因为它们是用 Java 编写的。
- 服务器上的 Java 安全管理器执行了一系列限制，以保护服务器计算机上的资源。因此，Servlet 是可信的。
- Java 类库的全部功能对 Servlet 来说都是可用的。它可以通过 sockets 和 RMI 机制与 applets、数据库或其他软件进行交互。

### JSP与Servlet的区别

- `JSP在编译之后就是一个Servlet,但是两者的创建方式不一样.`
- Servlet完全是JAVA程序代码构成，擅长于流程控制和事务处理，通过Servlet来生成动态网页很不直观.
- JSP由HTML代码和JSP标签构成，可以方便地编写动态网页.因此在实际应用中采用Servlet来控制业务流程，而采用JSP来生成动态网页.

```java
package com.znsd.servlet;

import java.io.IOException;
import java.io.PrintWriter;

// 导入所 需的包
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class HelloWorldServlet extends HttpServlet { // 继承HttpServlet类

	private static final long serialVersionUID = 1L;

	// 处理get请求的方法
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	// 处理post请求的方法
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Servlet输出HTML标签和内容
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		// 将数据发送给客户端
		out.println("<html>");
		out.println("  <head><title>Servlet</title></head>");
		out.println("  <body>");
		out.println("你好，欢迎来到Servlet世界");
		out.println("  </body>");
		out.println("</html>");
		out.close();
	}
}
```

![20180126165951](http://www.znsd.com/znsd/courses/uploads/1bd3389ec0cc4a9e4a23fc1fb58dada0/20180126165951.png)

先回忆第一章JSP 执行过程，然后说明JSP被翻译成.JAVA，这个.JAVA到底是什么样子呢？打开环境，新建一个JSP,运行后，再观看此.java文件上，如Test.jsp在运行时首先解析成一个Java类Test_jsp.java，而这个Test_jsp.java继承于org.apache.jasper.runtime.HttpJspBase类，而HttpJspBase又是继承自HttpServlet的类，由此可以得出一个结论，就是JSP在运行时会被Web容器翻译为一个Servlet

![servlet-arch](http://www.znsd.com/znsd/courses/uploads/6d42f33d5f1d451158533f05196470c6/servlet-arch.jpg)

### Servlet体系结构

![103032142](http://www.znsd.com/znsd/courses/uploads/63540e741df25a0bd777eabc0109e600/103032142.jpg)

### Servlet接口

- Servlet概述：定义了所有Servlet需要实现的方法
- Servlet接口的常用方法

| 方法名称                                     | 功能描述                                     |
| ---------------------------------------- | ---------------------------------------- |
| public void init(ServletConfig config)   | 由 servlet 容器调用，用于完成Servlet对象在处理客户请求前的初始化工作 |
| public  void service(ServletRequest   req, ServletResponse  res) | 由 servlet 容器调用，用来处理客户端的请求                |
| public  void  destroy()                  | 由 servlet 容器调用，释放Servlet对象所使用的资源         |
| public ServletConfig getServletConfig()  | 返回ServletConfig  对象，该对象包含此 servlet 的初始化和启动参数。返回的 ServletConfig 对象是传递给  init() 方法的对象 |
| public String getServletInfo()           | 返回有关 servlet 的信息，比如作者、版本和版权。返回的字符串是纯文本，而不是任何种类的标记（比如 HTML、XML，等等） |

### ServletConfig接口

ServeltConfig概述

- 在Servlet初始化过程中获取配置信息
- 一个Servlet只有一个ServletConfig对象

ServletConfig的常用方法

| 方法名称                                     | 功能描述                        |
| ---------------------------------------- | --------------------------- |
| public String getInitParameter(String name) | 获取web.xml中设置的以name命名的初始化参数值 |
| public ServletContext getServletContext( ) | 返回Servlet的上下文对象引用           |

### GenericServlet抽象类

- GenericServlet概述：提供了Servlet与ServletConfig接口的默认实现方法
- GenericServlet的常用方法

| 方法名称                                     | 功能描述                                     |
| ---------------------------------------- | ---------------------------------------- |
| public  void init(ServletConfig config)  | 调用Servlet接口中的init()方法。此方法还有一无参的重载方法，其功能与此方法相同 |
| public String getInitParameter(Stringname) | 返回名称为name的初始化参数的值                        |
| public ServletContext getServletContext() | 返回ServletContext对象的引用                    |

### HttpServlet抽象类

- HttpServlet概述
  - 继承于GenericServlet
  - 处理HTTP协议的请求和响应
- HttpServlet的常用方法

| 方法名称                                     | 功能描述                                     |
| ---------------------------------------- | ---------------------------------------- |
| public void service(ServletRequest req, ServletResponse res) | 调用GenericServlet类中service()方法的实现         |
| public void service(HttpServletRequest   req, HttpServletResponseres) | 接收HTTP  请求，并将它们分发给此类中定义的 doXXX 方法        |
| public void doXXX(HttpServletRequest  req,HttpServletResponse res) | 根据请求方式的不同，分别调用相应的处理方法，例如doGet()、doPost()等 |

### ServletRequest接口

- ServletRequest概述：u获取客户端的请求数据
- ServletRequest的常用方法

| 方法名称                                     | 功能描述             |
| ---------------------------------------- | ---------------- |
| public Object getAttribute(String name)  | 获取名称为name的属性值    |
| public void setAttribute(String name,  Object object) | 在请求中保存名称为name的属性 |
| public void removeAttribute(String name) | 清除请求中名字为name的属性  |

### HttpServletRequest接口

- HttpServletRequest概述：除了继承ServletRequest接口中的方法，还增加了一些用于读取请求信息的方法
- HttpServletRequest的常用方法

| 方法名称                              | 功能描述                                     |
| --------------------------------- | ---------------------------------------- |
| public String getContextPath()    | 返回请求URI中表示请求上下文的路径，上下文路径是请求URI的开始部分      |
| public Cookie[ ]  getCookies()    | 返回客户端在此次请求中发送的所有cookie对象                 |
| public HttpSession   getSession() | 返回和此次请求相关联的session，如果没有给客户端分配session，则创建一个新的session |
| public String  getMethod()        | 返回此次请求所使用的HTTP方法的名字，如GET、POST            |

### ServletResponse接口

- ServletResponse概述：u向客户端发送响应数据
- ServletResponse接口的常用方法

| 方法名称                                     | 功能描述                           |
| ---------------------------------------- | ------------------------------ |
| public PrintWriter   getWriter()         | 返回PrintWrite对象，用于向客户端发送文本      |
| public String  getCharacterEncoding()    | 返回在响应中发送的正文所使用的字符编码            |
| public void  setCharacterEncoding()      | 设置发送到客户端的响应的字符编码               |
| public void  setContentType(String type) | 设置发送到客户端的响应的内容类型，此时响应的状态属于尚未提交 |

### HttpServletResponse接口

- HttpServletResponse概述：除了继承ServletResponse接口中的方法，还增加了新的方法
- HttpServletResponse的常用方法

| 方法名称                                     | 功能描述                                |
| ---------------------------------------- | ----------------------------------- |
| public void  addCookie(Cookie  cookie)   | 增加一个cookie到响应中，这个方法可多次调用，设置多个cookie |
| public void  addHeader(String name,String value) | 将一个名称为name，值为value的响应报头添加到响应中       |
| public void  sendRedirect(String  location) | 发送一个临时的重定向响应到客户端，以便客户端访问新的URL       |
| public void  encodeURL(String url)       | 使用session  ID对用于重定向的URL进行编码         |

### Servlet的生命周期

- 图解Servlet的生命周期

  ![20180126171821](http://www.znsd.com/znsd/courses/uploads/f685d6deb212c3cdf3ebbc30da8a77a8/20180126171821.png)

- 生命周期的各个阶段

  - 实例化 ：Servlet 容器创建 Servlet 的实例
  - 初始化 ：该容器调用init() 方法
  - 请求处理  ：如果请求Servlet，则容器调用 service()方法
  - 服务终止  ：销毁实例之前调用destroy() 方法

- Servlet生命周期详解

Servlet是运行在Servlet容器（有时候也叫Servlet引擎，是web服务器和应用程序服务器的一部分，用于在发送的请求和响应之上提供网络服务，解码基于MIME的请求，格式化基于MIME的响应。常用的tomcat、jboss、weblogic都是Servlet容器）中的，其生命周期是由容器来管理。Servlet的生命周期通过java.servlet.Servlet接口中的init（）、service（）、和destroy（）方法表示。Servlet的生命周期有四个阶段：加载并实例化、初始化、请求处理、销毁。

- **加载并实例化**

​      Servlet容器负责加载和实例化Servelt。当Servlet容器启动时，或者在容器检测到需要这个Servlet来响应第一个请求时，创建Servlet实例。当Servlet容器启动后，Servlet通过类加载器来加载Servlet类，加载完成后再new一个Servlet对象来完成实例化。

- **初始化**

​      在Servlet实例化之后，容器将调用init（）方法，并传递实现ServletConfig接口的对象。在init（）方法中，Servlet可以部署描述符中读取配置参数，或者执行任何其他一次性活动。在Servlet的整个生命周期类，init（）方法只被调用一次。

- **请求处理**

​      当Servlet初始化后，容器就可以准备处理客户机请求了。当容器收到对这一Servlet的请求，就调用Servlet的service（）方法，并把请求和响应对象作为参数传递。当并行的请求到来时，多个service（）方法能够同时运行在独立的线程中。通过分析ServletRequest或者HttpServletRequest对象，service（）方法处理用户的请求，并调用ServletResponse或者HttpServletResponse对象来响应。 

- **销毁**

​      一旦Servlet容器检测到一个Servlet要被卸载，这可能是因为要回收资源或者因为它正在被关闭，容器会在所有Servlet的service（）线程之后，调用Servlet的destroy（）方法。然后，Servlet就可以进行无用存储单元收集清理。这样Servlet对象就被销毁了。这四个阶段共同决定了Servlet的生命周期。

![20150628211705937](http://www.znsd.com/znsd/courses/uploads/61d9cbba36d666e7e620790e08293d44/20150628211705937.jpg)

### Servlet的应用

- 创建Servlet：实现doPost()或doGet()方法
- 配置Servlet编辑部署描述文件web.xml（添加\<servlet>和\<servlet-mapping>）
- 启动Tomcat，访问Servlet

### 学员操作——实现用户登录

- 训练要点

  - 编写Servlet
  - 配置Servlet，实现Servlet的编译和部署

- 需求说明：

  编写Servlet，验证用户登录，如果用户名与密码都为“admin”则验证通过，跳转欢迎页面，否则弹出提示信息“用户名或密码错误，请重新输入！”，点击“确定”后跳转至登录页面

  ![image](http://www.znsd.com/znsd/courses/uploads/0c5c426bfb0a8dffb02ee674aa159a95/image.png)![image](http://www.znsd.com/znsd/courses/uploads/07b278296a4a58f6b2c7b4867500d4e6/image.png)

- 实现思路

  1. 建立Web应用配置web.xml
  2. 编写Servlet继承自HttpServlet
  3. 配置web.xml
  4. 启动Tomcat，访问Servlet

### 获取Servlet初始化参数-1

- Servlet初始化参数配置

  ```xml
  <servlet>
  		<servlet-name>HelloWorldServlet</servlet-name>
  		<servlet-class>com.znsd.servlet.HelloWorldServlet</servlet-class>
  		<init-param>
  			<!-- 参数名称 -->
  			<param-name>initParam</param-name>
  			<!-- 参数值 -->
  			<param-value>hello servlet</param-value>
  		</init-param>
  	</servlet>
  	<servlet-mapping>
  		<servlet-name>HelloWorldServlet</servlet-name>
  		<url-pattern>/helloWorld</url-pattern>
  	</servlet-mapping>
  ```

  ​

- 之前可以通过doPost()或doGet()获取表单提交的数据，我们也可以预先对Servelt进行初始化设置，进行过渡本知识点。并带学员回顾前面讲的ServeltConfig接口的作用以及是通过实现的getInitParameter(Stringname)方法来获取初始化参数

### 获取Servlet初始化参数-2

- 获取初始化参数

  ```java
   public void doGet(HttpServletRequest request, 
                        HttpServletResponse response)
                     throws ServletException, IOException {
          System.out.println("处理请求时,doGet()方法被调用。");
     		// 根据参数名称进行读取  
          String initParam = getInitParameter("initParam");
          System.out.println(initParam);
   }

  ```

  ![image](http://www.znsd.com/znsd/courses/uploads/57700a41b8e2c3cdd279c30e2ebb81e8/image.png)

### 学员操作——获取初始化参数

- 需求说明：编写Servlet，并设置Servlet初始化参数，然后调用Servlet，在控制台输出显示“欢迎XXX”
- 提示：
  - 修改web.xml配置的初始化参数，添加\<init-param>元素，并设定参数名称及参数值
  - 编写Servlet继承自HttpServlet，在doGet()方法中获取初始化参数，输出到控制台显示

### ServletContext接口

- ServletContext概述：获取Servlet上下文
- ServletContext的常用方法

| 方法名称                                     | 功能描述                                     |
| ---------------------------------------- | ---------------------------------------- |
| public String getInitParameter(String name) | 获取名称为name的系统范围内的初始化参数值，系统范围内的初始化参数可以在部署描述符中使用\<context-param>元素定义 |
| public void setAttribute(String name,  Object object) | 设置名称为name的属性                             |
| public Object getAttribute(String name)  | 获取名称为name的属性                             |
| public String  getRealPath(String path)  | 返回参数所代表目录的真实路径                           |
| public void log(String message)          | 记录一般日志信息                                 |

### 获取Servlet上下文参数

- 配置Servlet上下文

  ```xml
  <context-param>
  		<!-- 初始化参数的名字 --> 
  		<param-name>contextParam</param-name>
  		<!-- 初始化参数的值  -->
  		<param-value>Hello Servlet context</param-value>
  </context-param>
  ```

- 读取Servlet上下文

  ```java
  public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
  		System.out.println("处理请求时，doGet()方法被调用。");
  		String initParam = getInitParameter("initParam");
  		System.out.println(initParam);
  		
  		String contextParam = this.getServletContext().getInitParameter("contextParam");
  		System.out.println("Servlet初始化参数" + initParam);
  		System.out.println("系统初始化参数" + contextParam);
  }

  ```

#### context-param和init-param区别

web.xml里面可以定义两种参数：

- application范围内的参数，存放在servletcontext中，在web.xml中配置如下：这种参数可以在servlet里面可以通过getServletContext().getInitParameter("contextParam")得到

  ```xml
  <context-param>
             <param-name>contextParam</param-name>
             <param-value>avalible during application</param-value>
  </context-param>
  ```

- servlet范围内的参数，只能servlet中获取，一般用在init()方法中，这种参数只能在servlet的init()方法中通过this.getInitParameter("param1")取得

  ```xml
  <servlet>
      <servlet-name>MainServlet</servlet-name>
      <servlet-class>com.wes.controller.MainServlet</servlet-class>
      <init-param>
         <param-name>param1</param-name>
         <param-value>avalible in servlet init()</param-value>
      </init-param>
      <load-on-startup>0</load-on-startup>
  </servlet>
  ```

- \<context-param>的作用:

1. 启动一个WEB项目的时候,容器(如:Tomcat)会去读它的配置文件web.xml.读两个节点: \<listener>\</listener> 和 \<context-param>\</context-param>
2. 紧接着,容器创建一个ServletContext(上下文),这个WEB项目所有部分都将共享这个上下文.
3. 容器将\<context-param>\</context-param>转化为键值对,并交给ServletContext
4. 容器创建\<listener>\</listener>中的类实例,即创建监听
5. 在监听中会有contextInitialized(ServletContextEvent args)初始化方法,在这个方法中获得ServletContext = ServletContextEvent.getServletContext();context-param的值 = ServletContext.getInitParameter("context-param的键");
6. 得到这个context-param的值之后,你就可以做一些操作了.注意,这个时候你的WEB项目还没有完全启动完成.这个动作会比所有的Servlet都要早.换句话说,这个时候,你对\<context-param>中的键值做的操作,将在你的WEB项目完全启动之前被执行.
7. 举例.你可能想在项目启动之前就打开数据库.那么这里就可以在\<context-param>中设置数据库的连接方式,在监听类中初始化数据库的连接.
8. 这个监听是自己写的一个类,除了初始化方法,它还有销毁方法.用于关闭应用前释放资源.比如说数据库连接的关闭.

### 学员操作——获取系统上下文参数

- 需求说明：编写Servlet，并设置系统初始化参数，部署运行输出显示“系统的初始化参数是：Thisis System’s parameter”

  ![image](http://www.znsd.com/znsd/courses/uploads/544fd43e568d15970e6bd479a730dddb/image.png)

### 使用Servlet实现控制器

- 通过servlet实现控制器流程图

![image](http://www.znsd.com/znsd/courses/uploads/094f9cb0a568dac156faee8fab8ea025/image.png)

- 代码实现

  ```java
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
  			throws ServletException, IOException {
  		
  		String opt = request.getParameter("opt");

  		UserService userService = new UserServiceImpl();
  		String contextPath = request.getContextPath();
  		if (opt.equals("list")) {// 查找所有用户
  			List<User> list = userService.getAllUser();
  			request.setAttribute("list", list);
  			request.getRequestDispatcher(contextPath + "/user/list.jsp").forward(request, response);
  		}
  }
  ```

  main.jsp

  ```html
  <style>
  #iframeTop {
  	width: 100%;
  	height: 70px;
  }

  #iframeLeft {
  	width: 15%;
  	height: 700px;
  	float: left;
  }

  #iframeContent {
  	width: 84%;
  	height: 700px;
  }
  </style>
  <body>

  	<iframe id="iframeTop" name="iframeTop" frameborder="1" src="top.html"></iframe>
  	<iframe id="iframeLeft" name="iframeLeft" frameborder="1" src="left.html"></iframe>
  	<iframe id="iframeContent" name="iframeContent" frameborder="1" src="content.html"></iframe>

  </body>
  ```

  top.html

  ```html
  <body>
  深圳市智能时代产业园
  </body>
  ```

  left.html

  ```html
  <body>
    <div>
        <ul>
            <li><a href="add.html" target="iframeContent">用户添加</a></li>
            <li><a href="query.html" target="iframeContent">用户查询</a></li>
            <li><a href="update.html" target="iframeContent">用户删除</a></li>
            <li><a href="delete.html" target="iframeContent">用户修改</a></li>
        </ul>
    </div>
  </body>
  ```

  content.html

  ```html
  <body>
  content
  </body>
  ```

### 学员操作—学生管理系统

- 需求说明：创建一个Servlet作为控制器，管理学生操作

### 总结

- Servlet的应用

  - 创建Servlet：实现doPost()或doGet()方法
  - 配置Servlet：编辑部署描述文件web.xml
  - 启动Tomcat，访问Servlet

- Servlet初始化参数配置

  ```xml
  <init-param>
  	<param-name>initParam</param-name>
      <param-value>Hello Servlet</param-value>
  </init-param>
  ```

  ```java
  String param = getInitParameter("initParam");
  ```

  ​

- Servle上下文参数配置

  ```xml
  <web-app>
      <context-param>
          <param-name>contextParam</param-name>
          <param-value>Hello Servlet</param-value>
      </context-param>
      <!--省略其他配置-->
  </web-app>
  ```

  ```java
  String param = getServletContext().getInitParameter("contextParam");
  ```

  ​