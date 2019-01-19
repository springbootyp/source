## 第八章 过滤器与监听器

### 本章任务

- 通过Filter实现权限控制。
- 通过Filter实现中文乱码处理。
- 使用监听器统计在线人数

### 本章目标

- 掌握Filter过滤器的使用`重点（难点）`
- 掌握监听器Listener的使用

### 什么是过滤器

- Filter也称之为过滤器，可以认为是Servlet的一种“加强版”，它主要用于对用户的请求request进行预处理，也可以对Response进行后处理，类似现实版的“门卫”。
- Filter有如下几种用处：
  1. 在request到达Servlet之前，拦截request。
  2. 根据需要检查request，也可以修改request的头和数据。
  3. 在response到达客户端之前，拦截response。
  4. 根据需要检查response，也可以修改response的头和数据。

### 过滤器的工作方式

![20180228103426](http://www.znsd.com/znsd/courses/uploads/ceab666fd47393874a31a50bbac30333/20180228103426.png)

### Filter介绍

Servlet API中提供了一个Filter接口，开发web应用时，如果编写的Java类实现了这个接口，则把这个java类称之为过滤器Filter。

### 认识过滤器

- Filter接口只有三个方法：

  1. doFilter：执行过滤的方法
  2. init：执行初始化的方法
  3. destory：执行销毁的方法

  ![image](http://www.znsd.com/znsd/courses/uploads/6aa865f77ead2416a888acf1fa62bf7f/image.png)

### 实现过滤器

- 创建一个过滤器，实现3个过滤器方法

  ```java
  public class TestFilter implements Filter {

  	@Override
  	public void init(FilterConfig arg0) throws ServletException {
  		System.out.println("过滤器初始化TestFilter.init()");
  	}

  	@Override
  	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
  		
  		System.out.println("请求执行之前");
  		
  		chain.doFilter(request, response);
  		
  		System.out.println("请求执行之后");
  	}

  	@Override
  	public void destroy() {
  		System.out.println("销毁资源");
  	}
  }

  ```

- 在web.xml中添加过滤器配置信息

  ```xml
  <filter>
      <!-- 过滤器名称 -->
      <filter-name>TestFilter</filter-name>
      <!-- 过滤器类完整类名 -->
      <filter-class>com.znsd.filter.TestFilter</filter-class>
      <!-- 初始化参数 -->
      <init-param>
        <param-name>key</param-name>
        <param-value>value</param-value>
      </init-param>
  </filter>
  <filter-mapping>
      <!-- 过滤器名称，必须和前面名称一致 -->
      <filter-name>TestFilter</filter-name>
      <!-- 过滤器路径，/*表示项目中所有文件 -->
      <url-pattern>/*</url-pattern>
  </filter-mapping>
  ```
  ![20180228105802](http://www.znsd.com/znsd/courses/uploads/9b4918e37a3028e91f86ba98dbf6288f/20180228105802.png)

- web.xml配置各节点说明

  >  - 
  >    \<filter> 指定一个过滤器。
  >    - `<filter-name>`用于为过滤器指定一个名字，该元素的内容不能为空。
  >    - `<filter-class>`元素用于指定过滤器的完整的限定类名。
  >    - `<init-param>`元素用于为过滤器指定初始化参数，它的子元素`<param-name>`指定参数的名字，`<param-value>`指定参数的值。
  >    - 在过滤器中，可以使用`FilterConfig`接口对象来访问初始化参数。
  >  - 
  >    \<filter-mapping> 元素用于设置一个 Filter 所负责拦截的资源。一个Filter拦截的资源可通过两种方式来指定：Servlet 名称和资源访问的请求路径
  >    - `<filter-name>`子元素用于设置filter的注册名称。该值必须是在`<filter>`元素中声明过的过滤器的名字
  >    - `<url-pattern>`设置 filter 所拦截的请求路径(过滤器关联的URL样式)
  >
  >    - `<servlet-name>`指定过滤器所拦截的Servlet名称。
  >    - `<dispatcher>`指定过滤器所拦截的资源被 Servlet 容器调用的方式，可以是`REQUEST`,`INCLUDE`,`FORWARD`和`ERROR`之一，默认`REQUEST`。用户可以设置多个`<dispatcher>`子元素用来指定 Filter 对资源的多种调用方式进行拦截。
  >
  >  - 
  >    \<dispatcher> 子元素可以设置的值及其意义
  >    - `REQUEST`：当用户直接访问页面时，Web容器将会调用过滤器。如果目标资源是通过RequestDispatcher的include()或forward()方法访问时，那么该过滤器就不会被调用。
  >    - `INCLUDE`：如果目标资源是通过RequestDispatcher的include()方法访问时，那么该过滤器将被调用。除此之外，该过滤器不会被调用。
  >    - `FORWARD`：如果目标资源是通过RequestDispatcher的forward()方法访问时，那么该过滤器将被调用，除此之外，该过滤器不会被调用。
  >    - `ERROR`：如果目标资源是通过声明式异常处理机制调用时，那么该过滤器将被调用。除此之外，过滤器不会被调用。

### 过滤器的生命周期

Filter和Servlet一样，Filter的创建和销毁也是由WEB服务器负责。

- 实例化：在应用启动的时候就进行装载Filter类。
- 初始化(init)：创建好实例后，调用init()方法。
- 过滤(doFilter)：请求资源时执行过滤方法，每次请求时都会被执行。
- 销毁(destory)：关闭服务器时销毁资源。

`注意：`和servlet一样，init()和destory()方法只会执行一遍。

### 使用多个过滤器

- Web 应用程序可以根据特定的目的定义若干个不同的过滤器。假设您定义了三个过滤器 *TestFilter* 和 *FirstFilter*和*SecendFilter*。您需要创建一个如下所述的不同的映射，其余的处理与上述所讲解的大致相同：

  ```xml
  <filter>
  		<filter-name>TestFilter</filter-name>
  		<filter-class>com.znsd.filter.TestFilter</filter-class>
  		<init-param>
  			<param-name>key</param-name>
  			<param-value>value</param-value>
  		</init-param>
  	</filter>
  	
  	<filter>
  		<filter-name>FirstFilter</filter-name>
  		<filter-class>com.znsd.filter.FirstFilter</filter-class>
  		<init-param>
  			<param-name>key</param-name>
  			<param-value>value</param-value>
  		</init-param>
  	</filter>
  	
  	<filter>
  		<filter-name>SecendFilter</filter-name>
  		<filter-class>com.znsd.filter.SecendFilter</filter-class>
  		<init-param>
  			<param-name>key</param-name>
  			<param-value>value</param-value>
  		</init-param>
  	</filter>
  	
  	<filter-mapping>
  		<filter-name>TestFilter</filter-name>
  		<url-pattern>/*</url-pattern>
  	</filter-mapping>
  	
  	<filter-mapping>
  		<filter-name>FirstFilter</filter-name>
  		<url-pattern>/*</url-pattern>
  	</filter-mapping>
  	
  	<filter-mapping>
  		<filter-name>SecendFilter</filter-name>
  		<url-pattern>/*</url-pattern>
  	</filter-mapping>
  ```

### 多个过滤器的应用顺序

web.xml 中的 filter-mapping 元素的顺序决定了 Web 容器应用过滤器到 Servlet 的顺序。若要反转过滤器的顺序，您只需要在 web.xml 文件中反转 filter-mapping 元素即可。例如，上面的实例将先应用 LogFilter，然后再应用 AuthenFilter，但是下面的实例将颠倒这个顺序：

```xml
<filter-mapping>
	<filter-name>SecendFilter</filter-name>
	<url-pattern>/*</url-pattern>
</filter-mapping>

<filter-mapping>
	<filter-name>FirstFilter</filter-name>
	<url-pattern>/*</url-pattern>
</filter-mapping>
```

### 实现乱码过滤器

- 在前面的课程中，我们要过滤页面乱码，必须在每一个servlet中使用request.setCharEncoding()方法来设置编码格式。这样比较麻烦，也不容易维护。下面我们通过过滤器来统一设置请求的编码格式。

### 实现乱码处理过滤器

- 设置全局过滤器进行编码格式设置

  ```java
  public class CharacterEncodingFilter implements Filter {

  	private FilterConfig config = null;
  	
  	@Override
  	public void init(FilterConfig filterConfig) throws ServletException {
  		this.config = filterConfig; // 获取config用来读取配置文件的初始化参数
  	}

  	@Override
  	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
  			throws IOException, ServletException {

  		// 获取配置参数
  		String encodingName = config.getInitParameter("encodingName");
  		if (encodingName == null) {
  			encodingName = "utf-8";
  		}
  		
  		// 设置编码格式
  		request.setCharacterEncoding(encodingName);
  		response.setContentType("text/html;charset=" + encodingName);
  		response.setCharacterEncoding(encodingName);

  		// 执行下面的处理
  		chain.doFilter(request, response);
  	}
  	
  	@Override
  	public void destroy() {

  	}
  }
  ```

- 创建好过滤器之后，需要在web.xml中添加过滤器配置信息。

  ```xml
  <filter>
  	<filter-name>CharacterEncodingFilter</filter-name>
  	<filter-class>com.znsd.filter.CharacterEncodingFilter</filter-class>
  	<init-param>
  		<param-name>encodingName</param-name>
  		<!-- 默认的编码格式 -->
  		<param-value>UTF-8</param-value>
  	</init-param>
  </filter>
  	
  <filter-mapping>
  	<filter-name>CharacterEncodingFilter</filter-name>
  	<!-- 所有文件都会经过过滤器 -->
  	<url-pattern>/*</url-pattern>
  </filter-mapping>
  ```

### 权限控制

- 如果需要对特定文件夹的访问控制，我们也可以通过过滤器来实现对特定文件夹的访问控制。

- 例如：网站一般后台的页面文件都放置在admin文件夹中，这个文件夹中的页面，用户必须要登录之后才能访问。当用户未登录时，或者没有权限时，禁止用户访问。

- 参考代码

  ```java
  @Override
  public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
  			throws IOException, ServletException {

  		HttpServletRequest rq = (HttpServletRequest) request;
  		//获取session中保存的用户角色
  		HttpSession session = rq.getSession();
  		String role = (String) session.getAttribute("role");

  		//如有是manager角色则放行，否则转回登录页面
  		if(role != null && role.equals("manager")){
  			chain.doFilter(request, response);
  		}else{
  			rq.getRequestDispatcher("/login.jsp").forward(request, response);
  		}
  }
  ```

  ```xml
  <!-- 设置ammin权限过滤器 -->
  <filter>
  		<filter-name>RoleFilter</filter-name>
  		<filter-class>com.znsd.filter.RoleFilter</filter-class>
  </filter>
  <filter-mapping>
  		<filter-name>RoleFilter</filter-name>
  		<url-pattern>/admin/*</url-pattern>
  </filter-mapping>
  ```

### 过滤器适用场合

- 通过控制对chain.doFilter的方法的调用，来决定是否需要访问目标资源。比如：权限控制，判断用户是否具有访问权限。
- 通过在调用chain.doFilter方法之前，做些处理来达到某些目的。比如：解决全局中文乱码的问题。
- 通过在调用chain.doFilter方法之后，做些处理来达到某些目的。比如：图像转换，日志记录等。

### 使用过滤器的注意事项

- filter-mapping标签中servlet-name与url-pattern。Filter不仅可以通过url-pattern来指定拦截哪些url匹配的资源。而且还可以通过servlet-name来指定拦截哪个指定的servlet(专门为某个servlet服务了,servlet-name对应Servlet的相关配置)
- filter-mapping标签中dispatcher。指定过滤器所拦截的资源被 Servlet 容器调用的方式，可以是request，include,forward,error之一，默认request。用户可以设置多个\<dispatcher> 子元素用来指定 Filter 对资源的多种调用方式进行拦截。

### 小结

- 过滤器的作用？
- 实现乱码的处理
- 实现权限过滤？

### 监听器（Listener）

- 监听器
  - 当web程序运行时，web程序内部会产生各种事件：如服务启动，服务停止，session开始，session结束，用户请求到达等。
  - 实际上，Servlet提供了大量监听器来监听Web服务器的内部事件，从而允许当web内部事件发生时能被接受到。

### 实现监听器的步骤

实现步骤：

- 定义Listener实现类
- 通过Annotation或在web.xml中配置Listerner。

### 监听器接口

servlet规范中为每种事件监听器都定义了相应的接口，在编写事件监听器程序时只需实现这些接口就可以了。

| 名称                              | 说明                         |
| ------------------------------- | -------------------------- |
| ServletContextListener          | 用于监听web应用的启动和关闭            |
| ServletContextAttributeListener | 用于监听ServletContext范围内属性的改变 |
| ServletRequestListener          | 用于监听用户的请求                  |
| ServletRequestAttributeListener | 用于监听ServletRequest范围内属性的改变 |
| HttpSessionListener             | 用于监听用户session的开始和结束        |
| HttpSessionAttributeListener    | 用于监听HttpSession内属性的改变      |

### ServletContextListener

- 监听服务的启动和关闭，ServletContextListener中只有两个方法，一个启动，一个销毁方法。实现即可。

1. 用户请求到底，被初始化时触发该方法

   ```java
   public void requestInitialized(ServletRequestEvent sre) {
     
   }
   ```

2. 用户请求结束，被销毁时触发该方法

   ```java
   public void requestDestroyed(ServletRequestEvent sre) {
     
   }
   ```

- 例子ContextListenerTest

  ```java
  public class ContextListenerTest implements ServletContextListener {

  /**
   * 服务器启动的方法
   */
  public void contextInitialized(ServletContextEvent arg0) {
  	System.out.println("ContextListenerTest.contextInitialized()服务启动啦，可以做一些初始化工作了");
  }

  /**
   * 服务器销毁的方法
   */
  public void contextDestroyed(ServletContextEvent arg0) {
  	System.out.println("ContextListenerTest.contextDestroyed()服务关闭啦，可以做一些销毁工作了");
  }
  }
  ```

`注意：`一般实现ServletContextListener做一些全局变量的初始化和销毁工作。

### 添加配置文件

```xml
<!-- 实现监听器的配置 -->
<listener>
	<!-- 添加监听器实现类的完整路径即可-->
	<listener-class>com.znsd.listener.ContextListenerTest</listener-class>
</listener>
```

### ServletContextAttributeListener

- 用于监听application内的属性变化，实现该接口需要实现如下三个方法。

  1. 向application对象中添加值得时候触发

     ```java
     public void attributeAdded(ServletContextAttributeEventscab){
       
     }
     ```

  2. 从application对象中移除值得时候触发

     ```java
     public void attributeRemoved(ServletContextAttributeEvent scab){
       
     }
     ```
  3. 修改application对象中值得时候触发

     ``` java
     public void attributeReplaced(ServletContextAttributeEvent scab){
       
     }
     ```

- 例子ServletContextAttributeListenerTest

  ```java
  public class ServletContextAttributeListenerTest implements ServletContextAttributeListener {

      public void attributeAdded(ServletContextAttributeEvent event)  {
      	System.out.println("添加的值是：" + event.getName() + ":" + event.getValue());
      }

      public void attributeRemoved(ServletContextAttributeEvent event)  {
      	System.out.println("移除的值是：" + event.getName() + ":" + event.getValue());
      }

      public void attributeReplaced(ServletContextAttributeEvent event)  { 
      	System.out.println("修改的值是：" + event.getName() + ":" + event.getValue());
      }
  }
  ```


### HttpSessionListener

- 用于监听session的创建和销毁，实现该接口监听需要实现如下两个方法。

  1. Session创建时触发

     ```java
     public void sessionCreated(HttpSessionEvent se) {
       
     }
     ```

  2. Session销毁时触发

     ```java
     public void sessionDestroyed(HttpSessionEvent se) {
       
     }
     ```

- 具体功能实现参考ServletRequestListener实现方式。

### HttpSessionAttributeListener

- 用于监听Session属性的变化，创建，修改，移除，实现该接口需要实现该接口的三个方法。

  1. 添加属性时触发

     ```java
     public void attributeAdded(HttpSessionBindingEvent se) {
       
     }
     ```

  2. 添加属性时触发

     ```java
     public void attributeRemoved(HttpSessionBindingEvent se) {
       
     }
     ```

  3. 添加属性时触发

     ```java
     public void attributeReplaced(HttpSessionBindingEvent se) {
       
     }
     ```

- 例子HttpSessionAttributeListenerTest

  ```java
  public class HttpSessionAttributeListenerTest implements HttpSessionAttributeListener {

  	public void attributeAdded(HttpSessionBindingEvent e) {
  		System.out.println("session添加的值是：" + e.getName() + ":" + e.getValue());
  	}

  	public void attributeRemoved(HttpSessionBindingEvent e) {
  		System.out.println("session移除的值是：" + e.getName() + ":" + e.getValue());
  	}

  	public void attributeReplaced(HttpSessionBindingEvent e) {
  		System.out.println("session修改的值是：" + e.getName() + ":" + e.getValue());
  	}
  }
  ```

### 其它接口

  - HttpSessionActivationListener 在跨项目中传递session时使用
  - HttpSessionBindingListener 从监听范围上比较，HttpSessionListener设置一次就可以监听所有session，HttpSessionBindingListener通常都是一对一的。

### 综合练习

  需求说明：

  - 统计网站的在线人数，总访问人数。
  - 显示当前在线人员的IP地址，当前所访问的页面。
  - 保存访问人员的访问数据，获取访问人员的浏览器版本，IP地址和访问时间，并写入MySql数据库中，同一个IP地址一天只统计一次。

  参考例子：

  首先需要自定义一个监听器OnlineListener,在该监听器中，实现了两个监听器接口：ServletContextListener和HttpSessionListener。重写其中的方法contextInitialized,contextDestroyed,sessionCreated,sessionDestroyed方法。

  1. 首先需要在web.xml中配置listener

     ```xml
     <listener>
         <listener-class>com.znsd.listener.OnlineListener</listener-class>
     </listener>
     ```

  2. 编写com.znsd.listener.OnlineListener.java

     ```java
     public class OnlineListener implements ServletContextListener, HttpSessionListener {
     	
     	private static ServletContext context;

     	@Override
     	public void contextInitialized(ServletContextEvent e) {
     		// 服务器启动时，往ServletContext中写入connter参数
     		Integer count = new Integer(0);
     		context = e.getServletContext();
     		context.setAttribute("counter", count);
     	}

     	@Override
     	public void contextDestroyed(ServletContextEvent e) {
     	}

     	@Override
     	public void sessionCreated(HttpSessionEvent e) {
     		// 创建一个新的session的时候激活此方法，即产生一个新的用户，counter加1
     		int num = ((Integer) context.getAttribute("counter")).intValue();
     		context.setAttribute("counter", new Integer(num + 1));
     	}

     	@Override
     	public void sessionDestroyed(HttpSessionEvent e) {
     		// 销毁一个session时激活此方法，即用户退出时，counter减1
     		int num = ((Integer) context.getAttribute("counter")).intValue();
     		context.setAttribute("counter", new Integer(num - 1));
     	}
     }
     ```

  3. 测试页面

     ```html
     <%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
     <!DOCTYPE HTML>
     <html>
     <head>
     <title>统计当前在线用户数</title>
     <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
     </head>
     <body>
     	当前在线人数：<%=application.getAttribute("counter")%>
     </body>
     </html>
     ```

### 总结

- 过滤器的作用。
- 过滤器实现乱码的处理。
- 过滤器实现权限控制。
- 监听器的作用。
- 常用的JSP监听器有哪些？作用是什么？

### 作业

- 过滤器的作用？
- 实现过滤器的步骤？
- 过滤器的配置信息包括哪些？
- 监听器的作用？常用的监听器有哪些？