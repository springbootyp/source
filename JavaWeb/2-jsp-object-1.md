## 第二章 JSP数据交互（一）

### 回顾与作业点评

- 在JSP页面中计算两个数的和，将结果输出显示：

  ```html
  <%@ page language="java" contentType="text/html; charset=UTF-8"
      pageEncoding="UTF-8"%>
  <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>计算求和</title>
  </head>
  <body>

  <%
  	int i = 4, j = 5;
  	int result = i + j;
  %>

  <%-- <%=result%> --%>
  <%--  使用jsp内置对象讲表达式"<%=result%>"替换成out对象输出 --%>
  <% out.print(result); %>
  </body>
  </html>
  ```

### 本章任务

- 实现在JSP页面中获取注册信息
- 实现企业邮箱登录验证功能

### 本章目标

- 熟练应用request对象获取用户请求`重点`
- 熟练应用response对象处理响应`重点`
- 熟练应用转发与重定向控制页面跳转`重点（难点）`
- 掌握session的原理及应用`重点`
- 掌握include指令的应用

### 什么是JSP内置对象

- JSP内置对象是 Web容器创建的一组对象

- JSP内置对象的名称是JSP的保留字,JSP内置对象是可以直接在JSP页面使用的对象，无需使用“new”，直接使用。然后简单介绍out对象

  ```java
  <%
  int[] value = {60, 70, 80};
      for (int i : value) {
          out.println(i);
  		//没有出现new关键 字，但却可以使用out对象
      } 
  %>
  ```

### 常用的JSP内置对象

JSP中一共预先定义了9个这样的对象，分别为：request、response、session、application、out、pagecontext、config、page、exception

### 1、request对象

request 对象是 javax.servlet.httpServletRequest类型的对象。 该对象代表了客户端的请求信息，主要用于接受通过HTTP协议传送到服务器的数据。（包括头信息、系统信息、请求方式以及请求参数等）。request对象的作用域为一次请求。

### 2、response对象

response 代表的是对客户端的响应，主要是将JSP容器处理过的对象传回到客户端。response对象也具有作用域，它只在JSP页面内有效。

### 3、session对象

session 对象是由服务器自动创建的与用户请求相关的对象。服务器为每个用户都生成一个session对象，用于保存该用户的信息，跟踪用户的操作状态。session对象内部使用Map类来保存数据，因此保存数据的格式为 “Key/value”。 session对象的value可以使复杂的对象类型，而不仅仅局限于字符串类型。

### 4、application对象

 application 对象可将信息保存在服务器中，直到服务器关闭，否则application对象中保存的信息会在整个应用中都有效。与session对象相比，application对象生命周期更长，类似于系统的“全局变量”。

### 5、out 对象

out 对象用于在Web浏览器内输出信息，并且管理应用服务器上的输出缓冲区。在使用 out 对象输出数据时，可以对数据缓冲区进行操作，及时清除缓冲区中的残余数据，为其他的输出让出缓冲空间。待数据输出完毕后，要及时关闭输出流。

### 6、pageContext 对象

pageContext 对象的作用是取得任何范围的参数，通过它可以获取 JSP页面的out、request、reponse、session、application 等对象。pageContext对象的创建和初始化都是由容器来完成的，在JSP页面中可以直接使用 pageContext对象。

### 7、config 对象

config 对象的主要作用是取得服务器的配置信息。通过 pageConext对象的 getServletConfig() 方法可以获取一个config对象。当一个Servlet 初始化时，容器把某些信息通过 config对象传递给这个 Servlet。 开发者可以在web.xml 文件中为应用程序环境中的Servlet程序和JSP页面提供初始化参数。

### 8、page 对象

page 对象代表JSP本身，只有在JSP页面内才是合法的。 page隐含对象本质上包含当前 Servlet接口引用的变量，类似于Java编程中的 this 指针。

### 9、exception 对象

exception 对象的作用是显示异常信息，只有在包含 isErrorPage="true" 的页面中才可以被使用，在一般的JSP页面中使用该对象将无法编译JSP文件。

### request

#### JSP内置对象request-1

**问题** 如何实现学员的注册功能？

- 注册信息包括：用户名、密码、信息来源

- 页面提交后，显示学员输入的数据

  ![image](http://www.znsd.com/znsd/courses/uploads/8317de3f6a3a7b3a0e7def551fc45cfd/image.png)![image](http://www.znsd.com/znsd/courses/uploads/a4cda230b057edee909c043ac6946934/image.png)

- 要想实现此功能，那就需要用到了request内置对象的某些方法来获取请求数据

#### JSP内置对象request-2

- request对象主要用于处理客户端请求

  ![20180125094123](http://www.znsd.com/znsd/courses/uploads/a736344f5671294832c6fb9d8e954291/20180125094123.png)

#### JSP内置对象request-3

| 方法名称                                     | 说明                                       |
| ---------------------------------------- | ---------------------------------------- |
| String  getParameter(String name)        | 根据表单组件名称获取提交数据                           |
| String[] getParameterValues(String name) | 获取表单组件对应多个值时的请求数据                        |
| void  setCharacterEncoding(String charset) | 指定每个请求的编码                                |
| RequestDispatcher getRequestDispatcher(String path) | 返回一个RequestDispatcher对象，该对象的forward( )方法用于转发请求 |

#### JSP内置对象request-4

- 学员注册页面

```html
<form name="form1" method="post" action="reginfo.jsp">
	<table border="0" align="center">
			<tr>
				<td>用户名</td>
				<td><input type="text" name="name"></td>
			</tr>
			<tr>
				<td>密码</td>
				<td><input type="password" name="pwd"></td>
			</tr>
			<tr>
				<td>信息来源</td>
				<td><input type="checkbox" name="channel" value="报刊">报刊
					<input type="checkbox" name="channel" value="网络">网络 <input
					type="checkbox" name="channel" value="朋友推荐"> 朋友推荐 <input
					type="checkbox" name="channel" value="电视"> 电视</td>
			</tr>
			<tr>
				<td>
					<input type="submit" value="注册">
				</td>
				<td>
					<input type="submit" value="重置">
				</td>
			</tr>
	</table>
</form>
```

#### JSP内置对象request-5

- 信息读取显示页面

```java
<%
	String name = request.getParameter("name");
	String pwd = request.getParameter("pwd");
	String[] channels = request.getParameterValues("channel");
	
	out.println("name:" + name);
	out.println("pwd:" + pwd);
	
	if (channels != null) {
		for (String channel : channels) {
			out.println("channel:" + channel);
		}
	}
%>
```

![image](http://www.znsd.com/znsd/courses/uploads/b50940f69c140b6ebda8f3e1477bffaf/image.png)

- 为什么我们输入的中文都是乱码显示？

#### 在页面设置支持中文字符的字符集

- 乱码处理方式一`（以GET方式提交数据时）`

  ```java
  <%
  	//读取用户名和密码
  	String name = request.getParameter("name");
  	//对请求数据进行字符编码
  	name = new String(name.getBytes("ISO-8859-1"), "utf-8");
  %>
  ```

- 乱码处理方式`（以POST方式提交数据时）`

  ```java
  <%	
  	//设置读取请求信息的字符编码为UTF-8
  	request.setCharacterEncoding("utf-8");	
  	//读取用户名和密码
  	String name = request.getParameter("name");
  	String pwd = request.getParameter("pwd");
  %>
  ```

- 乱码处理方式三`（以GET方式提交数据时）`

  ```xml
  <!--在Tomcat目录结构\conf\server.xml中设置字符集-->
  <Connector port="8080" protocol="HTTP/1.1"                              connectionTimeout="20000"
   redirectPort="8443" URIEncoding="UTF-8"
   />
  ```

  ![20180125100407](http://www.znsd.com/znsd/courses/uploads/88df3b227988de4575673d8f2268b3d4/20180125100407.png)

#### 学员操作—获取注册信息

**需求说明**

- 通过表单提交注册信息
- 使用request对象获取表单提交数据
- 将获取的数据输出显示

**提示**

- 用request.getParameter( )方法获取提交的数据

### response

#### JSP内置对象response-1

- response对象用于响应客户请求并向客户端输出信息

- response对象常用方法

  - void sendRedirect (String location)：将请求重新定位到一个不同的URL，即页面重定向:

  ![20180125100717](http://www.znsd.com/znsd/courses/uploads/1160d83678a956239f36f71e06cc12fa/20180125100717.png)

#### JSP内置对象response-2

- 根据业务逻辑实现

  ![20180125101341](http://www.znsd.com/znsd/courses/uploads/42af4d9332290f111fbe279e4c56b23e/20180125101341.png)

- control.jsp

  ```java
  <%
  	request.setCharacterEncoding("UTF-8");
  	String name = request.getParameter("name");
  	String pwd = request.getParameter("pwd");
  	
  	if(name.equals("admin") && pwd.equals("0")) {
  		response.sendRedirect("welcome.jsp"); // 跳转至欢迎页面
  	}
  %>
  ```

#### JSP内置对象response-3

- 页面实现跳转了，请求的信息是否也一起转移呢？
- 那么如何才能实现页面跳转后，请求信息不丢失呢？
- `使用转发取代重定向实现页面跳转`
- “如果希望当登录成功后，在欢迎页面显示登录用户的名称怎么办？”

#### 页面的转发

- 转发的作用：在多个页面交互过程中实现请求数据的共享

- 转发的实现：RequestDispatcher对象.forward()方法

  ```java
  <%
  	RequestDispatcher rd = request.getRequestDispatcher("welcome.jsp");
  	rd.forward(request,response); // 将当前接收的用户请求，发送给服务器的其他资源使用
  %>
  ```

- 强调转发的作用，提醒两者间的区别。

#### 重定向与转发的区别

区别一：

- 重定向时浏览器上的网址改变
- 转发是浏览器上的网址不变

区别二：

- 重定向实际上产生了两次请求
- 转发只有一次请求
- 重定向：发送请求 -->服务器运行-->响应请求，返回给浏览器一个新的地址与响应码-->浏览器根据响应码，判定该响应为重定向，自动发送一个新的请求给服务器，请求地址为之前返回的地址-->服务器运行-->响应请求给浏览器
- 转发：发送请求 -->服务器运行-->进行请求的重新设置，例如通过request.setAttribute(name,value)-->根据转发的地址，获取该地址的网页-->响应请求给浏览器

区别三：

- 重定向时的网址可以是任何网址
- 转发的网址必须是本站点的网址

![重定向转发原理图](http://www.znsd.com/znsd/courses/uploads/2c5af0d65577ecf3c8564c693e672945/25.png)

#### 小结

**转发**

- 转发是在服务器端发挥作用，通过forward()将提交信息在多个页面间进行传递
- 客户端浏览器的地址栏不会显示出转向后的地址

**重定向**

- 重定向是在客户端发挥作用，通过请求新的地址实现页面转向
- 在地址栏中可以显示转向后的地址

#### 学员操作—实现登录验证功能

需求说明

- 用户通过JSP页面输入用户名和密码
- 如果用户名为admin，密码为123456，在欢迎页面显示“你好：admin！”
- 如果验证登录失败，则返回登录页面重新登录

### session

#### 什么是会话

- 一个会话就是浏览器与服务器之间的一次通话，包含浏览器与服务器之间的多次请求、响应过程。

- session是JSP内置对象，与浏览器一一对应

  ![20180125102901](http://www.znsd.com/znsd/courses/uploads/ceaded3dcb7ed2c8c292b9634416ba0d/20180125102901.png)

#### JSP内置对象session

session对象常用方法：

| 方法名称                                     | 说明                         |
| ---------------------------------------- | -------------------------- |
| void setAttribute(String key,Object value) | 以key/value的形式保存对象值         |
| Object getAttribute(String key)          | 通过key获取对象值                 |
| void invalidate()                        | 设置session对象失效              |
| String getId()                           | 获取sessionid                |
| void setMaxInactiveInterval(int interval) | 设定session的非活动时间            |
| int getMaxInactiveInterval()             | 获取session的有效非活动时间(以秒为单位)   |
| void removeAttribute(String key)         | 从session中删除指定名称(key)所对应的对象 |

#### session与窗口的关系

**问题**

- 一个session对应一个窗口，那么通过超链接打开的窗口是否也是新的session呢？

**分析**

- 每个session对象都与浏览器一一对应，重新开启一个浏览器，相当于重新创建一个session对象（版本不同可能有所差别）
- 通过超链接打开的新窗口，新窗口的session与其父窗口的session相同

#### 使用session实现访问控制-1

- 在后台系统中，增加访问控制功能，如果用户已经登录直接访问管理页面，否则跳转到登录页面
- 管理员界面
  1. 从session中提取该用户信息
  2. 如果用户信息存在，显示管理员界面内容
  3. 如果用户信息不存在，跳转到登录页面
- 登录处理页面
  1. 获得登录信息
  2. 查询数据库，判断该用户是否注册
  3. 如果该用户已注册，在session中保存该用户的登录信息
  4. 如果session中保存该用户的登录信息就跳转到管理员界面

#### 使用session实现访问控制-2

登录页面

```html
<form name="form1" method="post" action="control.jsp">
	<table border="0" align="center">
		<tr>
			<td>用户名</td>
			<td><input type="text" name="name"></td>
		</tr>
		<tr>
			<td>密码</td>
			<td><input type="password" name="pwd"></td>
		</tr>
		<tr>
			<td>
				<input type="submit" value="登录">
			</td>
		</tr>
	</table>
</form>
```

#### 使用session实现访问控制-3

控制页面

```java
<%
	request.setCharacterEncoding("UTF-8");
	String name = request.getParameter("name");
	String pwd = request.getParameter("pwd");
	
	if(name.equals("admin") && pwd.equals("0")) { // 如果登录成功保存用户信息并重定向至欢迎页面
		session.setAttribute("name", name); // 在session中存放用户登录信息
      	//设置session过期时间
		session.setMaxInactiveInterval(10*60);
		response.sendRedirect("welcome.jsp");
	}
%>
```

#### 使用session实现访问控制-4

管理界面

```java
<%
	String name = (String) session.getAttribute("name");
	if (name == null || name.equals("")) {
		response.sendRedirect("login.jsp");
	}
%>
```

#### 学员操作—实现系统访问控制

- 需求说明：用户在未登录的情况下直接访问则管理页面跳转登录页面，如果已经登录则直接访问
- 提示：session.getAttribute(String key)方法的返回值是一个Object，必须进行强制类型转换

#### session对象的失效

- 手动设置失效：invalidate()

- 超时失效

  - 通过setMaxInactiveInterval( )方法,单位是`秒`

    ```java
    <%
    	session.setAttribute("login","admin"); 
    	session.setMaxInactiveInterval(600); 
    	response.sendRedirect("admin.jsp"); 
    %>
    ```

  - 通过设置项目的web.xml或Tomcat目录/conf/web.xml 文件，单位是`分钟`，一般使用项目的方式，`如果需要永久不失效则设置为0`

    ```xml
    <session-config>
        <session-timeout>10</session-timeout>
    </session-config>
    ```

### 总结

- 内置对象：由Web容器加载的一组类的实例
- request与response对象
  - request处理客户端请求
  - response响应客户请求
- 会话对象session：可以保持每个用户的会话信息，为不同的用户保存自己的数据, 存储在客户端
- 转发与重定向以及区别