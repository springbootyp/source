## 第三章 JSP数据交互（二）

### 回顾

- 如何实现转发？
- 如何实现重定向？
- 何时选择转发与何时选择重定向？

### 本章任务

- 实现网页计数器功能
- 实现简化用户登录

### 本章目标

- 掌握application的原理及应用
- 熟练应用JSP对象的作用域`重点（难点）`
- 掌握cookie的原理及应用`重点`

### application

### JSP内置对象application-1

- 统计网站访问次数

  ![20180125152621](http://www.znsd.com/znsd/courses/uploads/9a25a6dfe057e89e6cdf1bd1b56a8e56/20180125152621.png)

#### JSP内置对象application-2

- **简介：**application是应用程序对象，当Web服务器启动时，Web服务器会自动创建一个application对象。application对象一旦创建，它将一直存在，直到Web服务器关闭。
- **生命周期：**一个Web应用程序启动后，将会自动创建一个application对象，而且在整个应用程序的运行过程中只有一个application对象，也即所有访问该网站的客户都共享一个application对象。它的生命周期从Web服务器启动，直到Web服务器关闭。application的存活范围比request和session都要大。只要服务器没有关闭，application对象中的数据就会一直存在，在整个服务器的运行过程当中，application对象只有一个，它会被所有的用户共享。
- **作用范围：**application对象是一个应用程序级的对象，它作用于当前Web应用程序，也即作用于当前网站，所有访问当前网站的客户都共享一个application对象。不管哪个客户来访问网站A，也不管客户访问网站A下哪个页面文件，都可以对网站A的application对象进行操作，因为，所有访问网站A的客户都共用一个application对象。当在application对象中存储数据后，所有访问网站A的客户都能够对其进行访问，实现了多客户之间的数据共享。
- application对象的常用方法

| 方法名称                                     | 说  明               |
| ---------------------------------------- | ------------------ |
| void  setAttribute(String key,Object value) | 以key/value的形式保存对象值 |
| Object  getAttribute(String key)         | 通过key获取对象值         |
| void removeAttribute(String name)        | 根据属性名称删除对应的属性      |
| String  getRealPath(String path)         | 返回相对路径的真实路径        |
| Enumeration getAttributeNames()          | 获取所有的属性名称          |
| String getContextPath()                  | 获取当前Web应用程序的根目录    |
| String getInitParameter(String name)     | 根据初始化参数名称，获取初始化参数值 |

#### JSP内置对象application-3

- 统计网站访问次数的实现

  ```java
  <%
  	// 统计页
  	Integer count = (Integer)application.getAttribute("count");
  	if (count != null) {
  		count = count + 1;
  	} else {
  		count = 1;
  	}
  	application.setAttribute("count", count);
  %>
  ```

  ```java
  <%
  	// 显示页
  	Integer i = (Integer) application.getAttribute("count");
  	out.print("您好：你是第" + i + "个访问本网站的用户");
  %>
  ```

#### 学员操作——实现网页计数器功能

- 训练要点：application的应用

- 需求说明：实现网站计数器的功能，在网页中显示访问的人数统计

  ![20180125152621](http://www.znsd.com/znsd/courses/uploads/9a25a6dfe057e89e6cdf1bd1b56a8e56/20180125152621.png)

- 实现思路

  1. 取出application中原始计数器的值
  2. 断计数器的值，若存在则累加1；不存在则设置为1
  3. 使用application保存计数器
  4. 页面显示计算器的值

### exception

- exception对象表示的就是JSP引擎在执行代码过程中抛出的种种异常,只有在page指令中设置isErrorPage="true"的页面中才能使用。
- exception对象常用方法

| 方法名                          | 描述            |
| ---------------------------- | ------------- |
| String getMessage()          | 返回描述异常的消息     |
| String toString()            | 返回关于异常的简短描述消息 |
| void printStackTrace()       | 显示异常及其栈轨迹     |
| Throwable FillInStackTrace() | 重写异常的执行栈轨迹    |

- 例子

test.jsp

```html
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" errorPage="error.jsp"%>
<!--用page指令指定错误页面-->
<body>
<%
	Integer a = Integer.parseInt("abcd");
%>
</body> 
```

error.jsp

```html
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true"%>
<!-- 只有指定isErrorPage="true"才能使用exception内置对象 -->
<body>
服务器正忙，请稍后再试！
<br>

<%=exception.getMessage()%><br>  
<%=exception.getLocalizedMessage()%><br>  
<%=exception.toString()%><br>  
<%=exception.fillInStackTrace()%><br>  
</body>
```

- 总结

1. exception内置对象用来处理JSP文件执行时发生的所有错误和异常。
2. exception对象和Java的所有对象一样，都具有系统的继承结构，exception对象几乎定义了所有异常情况，这样的exception对象和常见的错误有所不同，所谓错误，指的是在程序运行中由于系统内存不足，在Web服务器中不能处理计算机本身的问题。
3. 与错误不同，exception指的是Web应用程序所能够识别并能够处理的问题。在Java中，利用名为“try/catch”的关键字来处理异常情况，如果在JSP页面中出现没有捕捉到的异常，就会生成exception对象，并把这个exception对象传送到在page指令中设定的错误页面中，然后在错误提示页面中处理相应的exception对象。exception对象只有在错误页面（在页面指令里有isErrorPage=true的页面）才可以使用。

### 小结

JSP常用内置对象

| 内置对象名称        | 说明                         |
| ------------- | -------------------------- |
| out对象         | 用于向客户端输出数据                 |
| request对象     | 主要用于处理客户端请求的数据信息           |
| response对象    | 用于响应客户端请求并向客户端输出信息         |
| session对象     | 用于记录会话状态的相关信息              |
| application对象 | 类似于系统的全局变量，用于实现Web应用中的资源共享 |

#### 对象的作用域

#### 作用域范围的分类

1. page：在一个页面范围内
2. request：在一次服务器请求范围内
3. session：在一次会话范围内
4. application：在一个应用服务器范围内

#### page作用域

- page作用域指本JSP页面的范围

- pageContext.setAttribute(key,value)

- pageContext.getAttribute(key)

- one.jsp

  ```java
  <%
  	pageContext.setAttribute("name", "admin");
  %>

  <strong>
  	testOne:<%=pageContext.getAttribute("name")%>
  </strong>

  <br>

  <%
  	pageContext.include("tow.jsp");
  %>
  ```

- tow.jsp

  ```java
  <strong>
  	testTow:<%=pageContext.getAttribute("name")%>
  </strong>
  ```

  ![20180125155147](http://www.znsd.com/znsd/courses/uploads/82a80375dbe911cbbb0b4137e072f4ae/20180125155147.png)

#### request作用域

- request作用域内的对象则是与客户端的请求绑定在一起

  ```java
  <%
      // testOne.jsp
  	request.setAttribute("name", "admin");
  	request.getRequestDispatcher("testTow.jsp").forward(request, response);
  	// 也可以使用RequestDispatcher对象的include()方法与pageContext对象的include()方法实现相同的效果。
  %>
  ```

  ```java
  <!-- testTwo.jsp -->
  <strong>
  	testTow:<%=request.getAttribute("name")%>
  </strong>
  ```

  ![20180125155639](http://www.znsd.com/znsd/courses/uploads/1a4579133fb724c5d54b8db4c6f101f0/20180125155639.png)

#### session作用域

- session对象作用域：一次会话

  ```java
  <%
  	// testOne.jsp
  	request.setAttribute("name", "admin");
  	session.setAttribute("name", "session admin");
  	response.sendRedirect("testTow.jsp");
  %>
  ```

  ```java
  <!-- testTwo.jsp -->
  <strong>
  	request:<%=request.getAttribute("name")%><br>
  	session:<%=session.getAttribute("name")%>
  </strong>
  ```

  ![20180125160235](http://www.znsd.com/znsd/courses/uploads/af9282fa2be5536e2afe3673cf8a7c39/20180125160235.png)

#### application作用域

- application的作用域：面对整个Web应用程序

  ```java
  <%
  	// testOne.jsp
  	request.setAttribute("name", "admin");
  	session.setAttribute("name", "session admin");
  	application.setAttribute("name", "application admin");
  	response.sendRedirect("testTow.jsp");
  %>
  ```

  ```java
  <!-- testTwo.jsp -->
  <strong>
  	request:<%=request.getAttribute("name")%><br>
  	session:<%=session.getAttribute("name")%><br>
  	application:<%=application.getAttribute("name")%>
  </strong>
  ```

  ![20180125160531](http://www.znsd.com/znsd/courses/uploads/912c84e25dc276ce650e00fd03bf04ae/20180125160531.png)

#### 小结

- 对象的作用域

| 名称            | 说  明                         |
| ------------- | ---------------------------- |
| page范围        | 在一个页面范围内有效，通过pageContext对象访问 |
| request范围     | 在一个服务器请求范围内有效                |
| session范围     | 在一次会话范围内容有效                  |
| application范围 | 在一个应用服务器范围内有效                |

### cookie

#### 生活中的cookie

- 系统会自动记录已经浏览过的视频

  ![image](http://www.znsd.com/znsd/courses/uploads/48177900b74d3f445cc895364ab10bdd/image.png)

- 视频网站查看观看不同视频，系统会自动记录已经浏览过的视频，历史记录 。“浏览过的视频 ”用之前学过的任何一个对象（application，session, …）保存都不合适，并分析说明为什么不合适，没有达到哪种需求，session似乎很接近。


#### cookie的简介

- cookie是Web服务器保存在`客户端`的一系列文本信息
- cookie的作用
  - 对特定对象的追踪
  - 统计网页浏览次数
  - 简化登录
- 安全性能：容易信息泄露

#### 在JSP中使用cookie

- 创建cookie对象

  ```java
  Cookie newCookie = new Cookie(String key,Object value);
  ```

- 写入cookie

  ```java
  response.addCookie(newCookie);
  ```

- 读取cookie

  ```java
  Cookie[] cookies = request.getCookies();
  ```

#### cookie对象的常用方法

- cookie对象的常用方法

| 方法名称                        | 说   明                  |
| --------------------------- | ---------------------- |
| void setMaxAge(int expiry)  | 设置cookie的有效期，以秒为单位     |
| void setValue(String value) | 在cookie创建后，对cookie进行赋值 |
| String getName()            | 获取cookie的名称            |
| String getValue()           | 获取cookie的值             |
| String getMaxAge()          | 获取cookie的有效时间，以秒为单位    |

#### Cookie与Session的区别（了解即可，不用详解）

**Session是什么**

**用途**

1. Session可以记录用户的登录与行为数据，即记录下用户目前访问服务器上的那些内容，状态是什么，而考虑到这些数据用户修改的随意性很大，并没有必要直接存储在数据库中。
2. 在用户执行刷新操作时，即再次访问服务器时，可以直接根据Session，打开用户上次访问时网页的状态（如用户输入的表单内容等等），为用户带来更优的体验，提供个性化服务。
3. 用户的session信息非常关键，它记录了用户在进入页面、查看结果、点击结果以及后继的操作（比如翻页、加购物车等）。只有通过session信息才能把用户的行为联系起来，构建出完整的模型，因此从海量数据中把每一个用户所有session的操作都完整地挖掘出来非常重要。

> Session其实就是会话变量的保存地，只要是能使用变量的地方，都能使用 Sesion 变量。比如可以用来 计数、存储临时信息、甚至还可以存储DataTable，只要你的服务器的内存足够大就行。 简单通俗的讲session就是象一个临时的容器 来存放这些临时的东西 从你登陆开始就保存在session里 当然你可以自己设置它的有效时间和页面  举个简单的例子 我们做一个购书的JSP网站 顾客买书的时候会挑选出一些书 但是在付钱之前还可以修改,所以不能存到数据库 就可以先保存在session里 等到确认了以后再放入数据库...

**定义**

> 在WEB开发中，服务器可以为每个用户浏览器创建一个会话对象（session对象），注意：一个浏览器独占一个session对象(默认情况下)。因此，在需要保存用户数据时，服务器程序可以把用户数据写到用户浏览器独占的session中，当用户使用浏览器访问其它程序时，其它程序可以从用户的session中取出该用户的数据，为用户服务。 需要注意：新开的浏览器窗口会生成新的Session，但子窗口除外。子窗口会共用父窗口的Session。例如，在链接上右击，在弹出的快捷菜单中选择"在新窗口中打开"时，子窗口便可以访问父窗口的Session。需要注意：只有访问JSP、Servlet等程序时才会创建Session，只访问HTML、IMAGE等静态资源并不会创建Session

**Session和cookie的区别与联系**

> 具体来说cookie机制采用的是在客户端保持状态的方案，而session机制采用的是在服务器端保持状态的方案。两者存储的都是用户登录信息，操作行为等等的数据。

- cookie是把用户的数据写在用户本地浏览器上, 其他网站也可以扫描使用你的cookie，容易泄露自己网站用户的隐私，而且一般浏览器对单个网站站点有cookie数量与大小的限制。
- Session是把用户的数据写在用户的独占session上，存储在服务器上，**一般只将session的id存储在cookie中**。但将数据存储在服务器对服务器的成本会高。
- session是由服务器创建的，开发人员可以在服务器上通过request对象的getsession方法得到session
- 一般情况，登录信息等重要信息存储在session中，其他信息存储在cookie中

**session的实现原理**

服务器会为每一个访问服务器的用户创建一个session对象，并且把session对象的id保存在本地cookie上，只要用户再次访问服务器时，带着session的id，服务器就会匹配用户在服务器上的session，根据session中的数据，还原用户上次的浏览状态或提供其他人性化服务。

**例子**

control.jsp

```java
<%
	request.setCharacterEncoding("UTF-8");
	String name = request.getParameter("name");
	String pwd = request.getParameter("pwd");
	
	// 用户登录成功将用户名保存在cookie，之后跳转到welcome.jsp页面
	if(name.equals("admin") && pwd.equals("0")) {
		//response.sendRedirect("welcome.jsp"); // 跳转至欢迎页面
		
		// 创建cookie对象
		Cookie cookie = new Cookie("username", name);
		// cookie的有效时间，以秒为单位
		cookie.setMaxAge(5 * 60);
		response.addCookie(cookie);
		
		session.setAttribute("name", name);
		response.sendRedirect("welcome.jsp");
	} else {
		request.getRequestDispatcher("login.jsp").forward(request, response);
	}
%>
```

login.jsp

```java
<%
	// 获取所有cookie
	Cookie[] cookies = request.getCookies();
	for (Cookie cookie : cookies) {
		// 判断cookie是否存在username
		if ("username".equals(cookie.getName())) {
			// 如果存在直接重定向到欢迎页面
			response.sendRedirect("welcome.jsp");
		}
	}
%>
```


#### 学员操作——简化用户登录

- 训练要点：cookie的应用
- 需求说明：
  - 用户第一次登录时需要输入用户名和密码
  - 在5分钟内，无需再次登录则直接显示欢迎页面

![image](http://www.znsd.com/znsd/courses/uploads/809a395691d642c8f80999b1f8d4ad1f/image.png)

- 实现思路
  1. 用户登录后，创建cookie保存用户信息
  2. 设置cookie的有效期为5分钟
  3. 在登录页循环遍历cookie数组，判断是否存在指定名称的cookie，若存在则直接跳转至欢迎页面
- 提示：使用setMaxAge(5*60)设置cookie的有效期`写入Cookie之前一定要放在重定向或者转发之前`

#### 小结

cookie与session的对比

- session
  - 保存在`服务器`端用户信息
  - session中保存的是`Object`类型
  - 随会话的结束而将其存储的数据`销毁`
  - 保存`重要`的信息
- cookie
  - 在`客户端`保存用户信息
  - cookie保存的是 `String`类型
  - cookie可以`长期`保存在客户端
  - 保存`不重要`的用户信息

### JavaBean

#### 为什么需要JavaBean

- JavaBean的优势
  - 解决代码重复编写，减少代码冗余
  - 功能区分明确
  - 提高了代码的维护性
- 在之前的开发中，为了分离页面中的HTML代码和Java代码，解决在维护和修改上的困难，我们将一些负责完成业务逻辑、数据显示等操作的代码编写一些类来封装，这样只需几行代码调用类中的方法，就可以实现所需的功能。采用这种方式不但能够使代码复用，还能使数据显示和业务逻辑分开，这实际上就是使用JavaBean组件来实现的

![image](http://www.znsd.com/znsd/courses/uploads/29d6fd2d1eba799177548326d302c983/image.png)

#### JavaBean及其分类

从JavaBean的功能上可以分为

- 封装数据
- 封装业务

![20180126155630](http://www.znsd.com/znsd/courses/uploads/ab57053daa72a4684b342c13d4859a7c/20180126155630.png)

#### 封装数据的JavaBean

- 封装数据的JavaBean

  ```java
  public class Comment {
    	  // 将属性声明为私有属性
        private String cid;	   	// 用户名
        private String cnid;  		// 邮编
        private String ccontent;	// 电话
        // 忽略set get方法
    
    	  // 无参的公有构造方法
        public Comment () {
          
        }
    
    	  // 公有的设置属性值方法setXxx( )
        public void setCid(String cid) {
          	this. cid= cid;
        }
    	  // 公有的获取属性值方法getXxx( )
        public String getCid() {
          	return cid;
        }
  }
  ```

#### JavaBean的应用

- 在JSP页面中导入JavaBean

  ```html
  <!-- 引入JavaBean -->
  <%@ page import="com.znsd.jsp.bean.UserBean" %>
  <%
  	// 使用JavaBean
  	UserBean bean = new UserBean();
  	bean.setUsername("admin");
  %>
  ```

- JavaBean就像在Java程序中编写类，实例化后就可以使用其

### jsp七大动作

jsp动作（action）是指在运行期间的命令，常见的有：

- jsp:useBean
  - jsp:setProperty
  - jsp:getProperty
- jsp:include
- jsp:forward
  - jsp:param
- jsp:plugin

#### 1.include 

include 动态包含(分别编译):用jsp:include动作实现，它总是会检查所含文件中的变化，适合用于包含动态页面，并且可以带参数。flush属性: 用true ，表示页面可刷新。默认为false;`在使用include命令时除非该命令被执行到，否则它是不会被Tomcat等JSP Engine编译。`

```html
<jsp: include page="included.jsp" flush="true" />
```

#### 2.useBean

useBean动作(jsp页面使用javaBean的第二种方式)，作用域默认为page(本页面有效)

```html
<jsp:useBean id="对象名" class="包名.类名" scope="作用范围(page/request/application/session)"/>
```

scope属性用于指定JavaBean实例对象所**存储的域范围**，其取值只能是page、request、session和application四个值中的一个，其默认值是page。 

```html
<jsp:useBean id="currentDate" class="java.util.Date" scope="request" />
<%=currentDate.toString() %>
```

1. 当scope=application时，我们浏览date.jsp，这时显示出了系统时间。可是不管我们怎么刷新，另外打开一个浏览器，甚至换台机 器，它显示的时间始终不变，都是当初的时间(即bean刚创建时得到的系统时间)，因为scope=application，所以JavaBean的实例在内存中只有一份，此时只要不重新启动WEB服务，输出不会变化。  
2. 当scope=session时，浏览date.jsp，刷新时显示也不会变化。可是当我们重新打开一浏览器，即一个新的session，系统便再次创建JavaBean的实例，取得当前系统时间，这时将得到正确的时间。同样，再次刷新新打开的页面，显示也不会变化。  
3. 当scope=page/request时，不断刷新页面将不断得到当前系统时间。 

#### 3.getProperty

getProperty动作(name为useBean动作中的id).从对象中取出属性值：

```html
<jsp:getProperty name="javaBean对象" property="javaBean对象属性名" />
```

#### 4.setProperty

setProperty动作(name为useBean动作中的id):

- 为对象设置属性值：

```html
<jsp:setProperty name="javaBean对象" property="javaBean对象属性名" value="值"/>
```

- 为对象设置属性值：

```html
<jsp:setProperty property="javaBean对象属性名" name="javaBean对象" param="username"/>
```



#### 5.param

param动作：传递参数，到达跳转页面可以通过 request.getParameter("参数名")方式取出参数值

```html
<jsp:include page="转向页面的url" >
    <jsp:param name="参数名1" value="参数值1"></jsp:param>
	<jsp:param name="参数名2" value="参数值2"></jsp:param>
</jsp:include>
```

或:

```html
<jsp:forward page="转向页面的url">
	<jsp:param name="参数名1" value="参数值1"></jsp:param>
	<jsp:param name="参数名2" value="参数值2"></jsp:param
</jsp:forward>
```

#### 6.forward

forward动作:跳转页面

```html
<jsp:forward page="login.jsp" />
```

#### 7.plugin

plugin动作:\<jsp:plugin>:用于指定在客户端运行的插件，不常用

### 总结 

- 对象的作用域
- JSP如何实现数据库访问
- session与cookie
- jsp七大动作