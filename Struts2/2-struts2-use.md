## 第二章  Struts 2初体验

### 本章任务

- 使用Struts2实现用户登录
- 使用session保存用户信息
- 使用Struts2数据校验登录信息
- 使用Struts2实现用户信息列表显示

### 本章目标

- 掌握Struts2的执行过程`重点`
- 能够使用Struts2框架开发简单应用`重点（难点）`
- 掌握Struts2获取ServletAPI`重点`

### 什么是Strus2

Strus2是一套前端开源的MVC框架，用来帮用户处理一些前端通用的操作。比如：

- 参数绑定（通过request.getParameter获取参数。）
- 类型转换
- 数据效验
- 国际化
- 文件上传

Struts2提供了以上还有跟多的功能，从而大大提高程序员的开发效率，让程序员将更多的时间集中到核心业务代码上。

### Struts2 优势

- 由出色稳定的框架Struts1和WebWork框架整合而来，吸取了两大框架的优点。Struts 2 不只是 Struts 1 的版本升级，而是一个完全重写的 Struts 架构。它是以WebWork 框架为基础的，目标是提供一个建立在 Struts 上加强和改进的框架来**使开发人员更容易进行 web 开发**。

- 提高了开发效率和规范性。

- 更好的实现了MVC架构。

- 更强大的标签库支持。

- 直接支持Ajax技术。

- 非常方便的与其它框架进行整合。

### Struts2下载

- Struts官方地址：http://struts.apache.org/

  ![20171229100353](http://www.znsd.com/znsd/courses/uploads/8046670454a1a7f8ca771f622fcac437/20171229100353.png)

- 本书选取Struts2.3版本进行讲解（现在最新版本Struts 2.5.14 2017-11-23发布）

- Struts 2 目录结构

  ![20171229100700](http://www.znsd.com/znsd/courses/uploads/412dcbaf30b48e49076361f638733007/20171229100700.png)

  1. apps目录：Struts2示例应用程序
  2. docs目录：Struts2指南、向导、API文档
  3. lib目录：Struts 2的发行包及其依赖包
  4. src目录：Struts 2项目源代码

### Struts2初体验

- 使用Struts2实现：输入用户姓名，然后输出欢迎信息

![20171229105029](http://www.znsd.com/znsd/courses/uploads/4bbc7c22f8eca4dfb6b82fd8e95dcb6c/20171229105029.png)![20171229105129](http://www.znsd.com/znsd/courses/uploads/7cb37218f20b50698b08b48c1fea7578/20171229105129.png)

- 使用Struts2 开发程序的基本步骤
  - 加载Struts2类库
  - 配置web.xml文件
  - 开发视图层页面
  - 开发控制层Action
  - 配置struts.xml文件
  - 部署、运行项目
- Struts2 类库

| 文件名                        | 说   明                 |
| -------------------------- | --------------------- |
| struts2-core-xxx.jar       | Struts 2框架的核心类库       |
| xwork-core-xxx.jar         | XWork类库，Struts 2的构建基础 |
| ognl-xxx.jar               | Struts 2使用的一种表达式语言类库  |
| freemarker-xxx.jar         | Struts 2的标签模板使用类库     |
| javassist-xxx.GA.jar       | 对字节码进行处理              |
| commons-fileupload-xxx.jar | 文件上传时需要使用             |
| commons-io-xxx.jar         | Java IO扩展             |
| commons-lang-xxx.jar       | 包含了一些数据类型的工具类         |

- 配置web.xml

```xml
<filter>
	<filter-name>struts2</filter-name>
	<!-- 在早期的版本中有的使用FilterDispatcher，但在Struts2.1.3版本中被废弃。 -->
	<filter-class>org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter</filter-class>
</filter>
<filter-mapping>
	<filter-name>struts2</filter-name>
	<!-- 将全部.action请求定位到指定的Struts 2过滤器中 -->
	<url-pattern>*.action</url-pattern>
</filter-mapping>
```
- 编写helloWorld.jsp

```html
<div>
  	<h1>
      	<!-- 输出显示语句 -->
    	${message}
  	</h1>
</div>	
<div>
  	<form action="helloWorld.action" method="post">
    	请输入姓名：<input type="text" name="name"/>
    	<input type="submit" value="提交">
  	</form>
</div>
```
- 编写HelloWorldAction

```java
public class HelloWorldAction implements Action { // 这里可以实现Action接口，也可以继承ActionSupport类。哪么为什么需要提供两个实现方式呢？

	private String name; // 用户输入的姓名
	private String message; // 向用户显示的信息

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	@Override
	public String execute() throws Exception {
		// 根据用户输入的姓名,进行"Hello World,XXXX"的封装
		this.setMessage("Hello World " + getName());
		// 处理完毕,返回导航结果的逻辑名
		return "success";
	}
}
```

Action中方法的返回值是一个字符串类型的逻辑名，Struts 2提供了若干固定使用的逻辑名，同时也允许自定义逻辑名。不管如何定义逻辑名，`都必须要与struts.xml配置文件中的Result元素的name属性保持一致`。

1. 在项目的src文件夹下配置Struts2配置文件（struts.xml）

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE struts PUBLIC
       "-//Apache Software Foundation//DTD Struts Configuration 2.0//EN"
       "http://struts.apache.org/dtds/struts-2.0.dtd">

   <struts>
   	<!-- 规定语法 -->
   	<package name="default" namespace="/" extends="struts-default">
   		<!-- 与form表单的action属性值对应，也就是我们的请求路径 -->
   		<action name="helloWorld" class="com.znsd.struts.action.HelloWorldAction">
   			<!-- success与Action返回字符串对应 -->
   			<result name="success">helloWorld.jsp</result>
   		</action>
   	</package>
   </struts>
   ```

### Struts2开发小结

开发Struts2应用的基本环节

1. 确认环境
   - 是否添加了Struts2框架支持文件
   - 是否配置了Filter
2. 实现功能
   - 编写Action类
3. 配置struts.xml文件
4. 编写视图

### Struts2的请求过程

![image](http://www.znsd.com/znsd/courses/uploads/9c23f32583be8036376d6f6e5607a234/image.png)

1. 用户发送请求到服务器的某些资源的请求（即页面）。
2. StrutsPrepareAndExecuteFilter 查看请求，然后确定适当的动作。
3. 配置的拦截功能，适用于如验证，文件上传等。
4. 所选的动作会执行，以执行所请求的操作。
5. 同样，配置的拦截器做任何后期处理，如果需要的话。
6. 最后其结果由视图准备，并且将结果返回给用户。

### Struts2工作原理

![2011082712263217](http://www.znsd.com/znsd/courses/uploads/789914ea11a05e21d2b67effbd152ed6/2011082712263217.png)

1. 客户端初始化一个指向Servlet容器（例如Tomcat）的请求
2. 这个请求经过一系列的过滤器（Filter）（这些过滤器中有一个叫做ActionContextCleanUp的可选过滤器，这个过滤器对于Struts2和其他框架的集成很有帮助，例如：SiteMesh Plugin） 
3. 接着FilterDispatcher（现已过时）被调用，FilterDispatcher询问ActionMapper来决定这个请是否需要调用某个Action 
4. 如果ActionMapper决定需要调用某个Action，FilterDispatcher把请求的处理交给ActionProxy 
5. ActionProxy通过Configuration Manager询问框架的配置文件，找到需要调用的Action类 
6. ActionProxy创建一个ActionInvocation的实例。
7. ActionInvocation实例使用命名模式来调用，在调用Action的过程前后，涉及到相关拦截器（Intercepter）的调用。 
8. 一旦Action执行完毕，ActionInvocation负责根据struts.xml中的配置找到对应的返回结果。返回结果通常是（但不总是，也可 能是另外的一个Action链）一个需要被表示的JSP或者FreeMarker的模版。在表示的过程中可以使用Struts2 框架中继承的标签。在这个过程中需要涉及到ActionMapper

### 小结

- 什么是MVC模式，有什么优缺点
- Struts2的基本用法
- Struts2的处理流程

### Struts2初体验-2

1. 如何使用Struts2实现用户登录验证

   ![20171229113556](http://www.znsd.com/znsd/courses/uploads/4610433529b31c3e6acd99e73e5b6457/20171229113556.png)

2. 开发控制层Action LoginAction

   ```java
   public class LoginAction implements Action {

   	private String username;
   	private String password;

   	public String getUsername() {
   		return username;
   	}

   	public void setUsername(String username) {
   		this.username = username;
   	}

   	public String getPassword() {
   		return password;
   	}

   	public void setPassword(String password) {
   		this.password = password;
   	}

   	@Override
   	public String execute() throws Exception {
   		if ("admin".equals(username) && "0".equals(password)) {
   			return "success";
   		}
   		return "error";
   	}
   }
   ```

3. 配置Struts2配置文件（struts.xml）

   ```xml
   <!-- 放在package节点下面，一个package可以对应多个action -->
   <action name="login" class="com.znsd.struts.action.LoginAction">
   		<!-- 结果为"success"时，跳转至success.jsp页面 -->
   		<result name="success">success.jsp</result>
   		<!-- 结果为"error"时，跳转至fail.jsp页面 -->
   		<result name="error">fail.jsp</result>
   </action>
   ```

   ​

### 学员操作-添加用户登录

- 需求说明：使用Struts2框架实现用户登录
- 在LoginAction中获得用户名及密码并对其合法性进行验证
- 配置struts.xml文件，用户登录成功和失败跳转的页面
- 完成时间25分钟

### Struts2访问Servlet API 

- `问题：`如果登录成功后，如何使用session保存用户信息？
- Struts 2提供了三种访问Servlet API的方式
  1. 与Servlet API解耦的访问方式：更利于单元测试，操作不方便。
  2. 与Servlet API耦合的访问方式：获取完整的对象，操作更方便。
  3. 使用工具类访问API，仍然与Action耦合。

#### 1.解耦方式访问Servlet API

- Struts2提供了一个com.opensymphony.xwork2.ActionContext类，可以通过该类来访问ServletAPI，ActionContext是Action的上下文，Struts2自动在其中保存了一些在Action执行过程中所需的对象，比如session, parameters, locale等。Struts2会根据每个执行HTTP请求的线程来创建对应的ActionContext，即一个线程有一个唯一的ActionContext。因此，使用者可以使用静态方法ActionContext.getContext()来获取当前线程的ActionContext，也正是由于这个原因，使用者不用去操心让Action是线程安全的。
- 无论如何，ActionContext都是用来存放数据的。Struts2本身会在其中放入不少数据，而使用者也可以放入自己想要的数据。ActionContext本身的数据结构是映射结构，即一个Map，用key来映射value。所以使用者完全可以像使用Map一样来使用它，或者直接使用Action.getContextMap()方法来对Map进行操作。

下面是ServletAPI常见的方法。

| 方法名                                  | 说   明                               |
| ------------------------------------ | ----------------------------------- |
| Object get(Object key)               | 通过使用值的键进行查找，返回当前ActionContext中存储的值。 |
| put(key, value)                      | 通过使用值的键进行添加到ActionContext中          |
| Map getApplication()                 | 返回Map对象，类似application对象             |
| static ActionContext getContext()    | 静态方法，获取系统的ActionContext()对象         |
| Map getParameters()                  | 返回Map对象，获取所有的请求参数                   |
| Map getSession()                     | 返回Map对象，类似Session对象                 |
| void setApplication(Map application) | 传入一个Map对象，用来设置application的属性和值。     |
| void setSession(Map session)         | 传入一个Map对象，用来设置session的属性和值。         |

`注意：解耦方式访问的并不是真正的api对象，只是一个Map集合。`

- get

  ```java
  Map<String, Object> requestMap = (Map<String, Object>)ActionContext.getContext().get("request");
  ```

- put

  ```java
  ActionContext.getContext().put("name", "test");
  String name = (String) ActionContext.getContext().get("name");
  System.out.println(name);
  ```

- getApplication

  ```java
  Map<String, Object> application = ActionContext.getContext().getApplication();
  System.out.println(application);
  ```

- getContext

  ```java
  ActionContext.getContext();
  ```

- getParameters

  ```java
  Map<String, Object> params = ActionContext.getContext().getParameters();
  ```

- getSession

  ```java
  // 获取session
  Map<String, Object> session = ActionContext.getContext().getSession();
  // 设置session
  session.put("user", "admin");
  // 校验key user是否存在
  String user = (String) ServletActionContext.getRequest().getSession().getAttribute("user");
  System.out.println(user);
  ```

- setApplication

  ```java
  Map<String, Object> applicationMap = new HashMap<String, Object>();
  applicationMap.put("a1", "1");
  applicationMap.put("a2", "2");
  ActionContext.getContext().setApplication(applicationMap);
  String b = (String) ActionContext.getContext().getApplication().get("a1");
  System.out.println(b);
  ```

- setSession

  ```java
  Map<String, Object> sessionMap = new HashMap<String, Object>();
  sessionMap.put("s1", "1");
  sessionMap.put("s2", "2");
  ActionContext.getContext().setSession(sessionMap);
  // 获取session
  Map<String, Object> session = ActionContext.getContext().getSession();
  ```

#### 解耦方式访问Servlet API-2

解耦：解耦的方式意味着Action可以摆脱Servlet容器的束缚，可以直接访问所需要的对象。而这些对象被定义成了Map类型，以key-value的形式进行读取。struts2将request、session以及application的方法对象都保存在ActionContext中。

```java
public class LoginAction implements Action {

	private String username;
	private String password;

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	@Override
	public String execute() throws Exception {
		if ("admin".equals(username) && "0".equals(password)) {
			// 从ActionContext中 获取session
			Map<String, Object> sessionMap = ActionContext.getContext().getSession();
			// 以key/value形式保存数据
			sessionMap.put("currentUser", username);
			return "success";
		}
		return "error";
	}
}
```

#### 解耦方式访问Servlet API-3

```html
<body>
	<!-- 从session中读取数据 -->
	${sessionScope.currentUser}：登录成功 
</body>
```

在页面显示时候，使用EL表达式可以直接取出session作用域中的数据，这一点与之前在JSP学习中的一样

#### 解耦方式访问Servlet API-4

访问request对象。

```java
Map<String, Object> request = (Map<String, Object>) ActionContext.getContext().get("request");
String name = (String) request.get("username");
System.out.println(name);
```



### 2.耦合方式操作ServletAPI

- 虽然Struts2提供了解耦方式操作Servlet API，但是毕竟不是真正直接操作api对象，在使用上不太方便。
- Struts2还提供耦合方式操作API，提供一下接口。

| 接口名                 | 说   明                                    |
| ------------------- | ---------------------------------------- |
| ServletContextAware | 实现该接口，必须实现setServletContext方法，可以直接访问ServeletContext实例。 |
| ServletRequestAware | 实现该接口，必须实现setServletRequest方法，可以直接访问用户请求的HttpServletRequest对象。 |
| ServletReponseAware | 实现该接口，必须实现setServletResponse方法，可以直接访问HttpServletResponse对象。 |
| SessionAware        | 实现该接口，必须实现setSession方法，可以访问关联Session对象的Map集合。 |

- 耦合方式操作ServletAPI使用

  1. ServletContextAware

     将当前Action实现ServletRequestAware接口，并重写setServletRequest方法，将参数赋给全局request对象。

     ```java
     public class LoginAction implements Action,ServletContextAware {

       	private ServletContext servletContext;
       
     	@Override
     	public void setServletContext(ServletContext context) {
     		this.servletContext = context;
     	}
     }
     ```

  2. ServletRequestAware

     ```java
     public class LoginAction implements Action, ServletRequestAware {

     	private HttpServletRequest request;

     	@Override
     	public String execute() throws Exception {
     		System.out.println(request.getParameter("username"));		
     	}

     	@Override
     	public void setServletRequest(HttpServletRequest request) {
     		this.request = request;
     	}
     }
     ```

  3. ServletResponseAware

     ```java
     public class LoginAction implements Action, ServletResponseAware {

     	private HttpServletResponse response;

     	@Override
     	public void setServletResponse(HttpServletResponse response) {
     		this.response = response;
     	}
     }
     ```

  4. SessionAware

     ```java
     public class LoginAction implements Action, SessionAware {

     	private Map<String, Object> session;

     	@Override
     	public String execute() throws Exception {
     		System.out.println(session);
     	}

     	@Override
     	public void setSession(Map<String, Object> session) {
     		this.session = session;
     	}
     }
     ```

### 3.工具类访问Servlet API

除了上面两种方式以外，Struts2还提供ServletActionContext工具类来访问ServletAPI。
ServletActionContext提供一下几个静态方法访问API。

| 方法名                                      | 说   明                   |
| ---------------------------------------- | ----------------------- |
| static PageContext getPageContext()      | 获取PageContext对象         |
| static HttpServletRequest getRequest()   | 获取HttpServletRequest对象  |
| static HttpServletResponse getResponse() | 获取HttpServletResponse对象 |
| static ServletContext getServletContext() | 获取ServletContext对象      |

```java
public class LoginAction implements Action {

	@Override
	public String execute() throws Exception {
		// 获取PageContext对象  
		PageContext page = ServletActionContext.getPageContext();
       	// 获取HttpServletRequest对象  
		HttpServletRequest request = ServletActionContext.getRequest();
      	// 获取HttpServletResponse对象  
		HttpServletResponse response = ServletActionContext.getResponse();
      	// 获取ServletContext对象
		ServletContext context = ServletActionContext.getServletContext();
		
		String name = (String) request.getParameter("username");		
	}
}
```

`注意：`采用耦合的方式访问Servlet API的方式，就是依靠ServletActionContext来进行获取，对象的使用也与之前学习的方式类似。在实际的应用开发建议采用解耦的方式，这样更加灵活。

### 学员操作-session保存数据

- 需求说明：
  1. 用户登录成功后，使用session保存用户信息
  2. 在登录成功后读取用户名显示
- 提示：
  1. 在LoginAction中获得用户名及密码并对其合法性进行验证
  2. 使用三种方式来获取session对象

### 总结

- Action的实现方式
  1. 实现Action接口
  2. 继承Action接口实现类ActionSupport类
- Struts 2中提供了解耦和耦合三种方式实现对Servlet API的访问
  1. 解耦方式访问
  2. 耦合方式访问
  3. 工具类方式访问