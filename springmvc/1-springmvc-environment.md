## 第一章     Spring MVC环境搭建 

### 本章目标

- 使用Spring MVC搭建Web项目
- 注解方式
- 接口方式

### Spring MVC概述 

- Spring MVC为展现层提供的基于MVC设计理念的优秀Web框架，是目前最主流的MVC框架之一。
- Spring3.0后全面超越了Struts2，称为最优秀的MVC框架。
- Spring MVC通过一套MVC注解，让POJO称为处理请求的控制器，无需实现任何接口。
- 支持REST风格的Web请求。采用了松散耦合可插拔组件结构，比其它MVC框架更具扩展性和灵活性。

### 搭建Spring MVC环境

- 基于接口方式搭建MVC环境：通过实现Controllor接口实现MVC
- 基于注解方式搭建MVC环境 ：在Spring 3.0以后的版本中，使用注解方式极大的简化了传统MVC配置的，灵活性和可维护性也得到大大的提高。`推荐使用注解方式。 `

### HelloWolrd

- 步骤：
- 1、导入jar包
- 2、在web.xml中配置DispacherServlet
- 3、加入Spring MVC配置文件。
- 4、编写请求处理器，并标示为处理器
- 5、添加视图，并添加视图解析器

#### 导入jar包

**Spring MVC需要的最核心的jar包**

- commons-logging.jar
- spring-aop.jar
- spring-beans.jar
- spring-context.jar
- spring-core.jar
- spring-expression.jar
- spring-web.jar
- spring-webmvc.jar

#### 修改配置文件 

- 在web.xml中配置DispacherServlet，DispacherServlet默认加载/WEB-INF/\<servlet-name>-servlet.xml下的Spring配置文件，可以通过contextConfigLocation更改配置文件路径。

  ```xml
  <servlet>
  	<servlet-name>dispatcherServlet</servlet-name>
  	<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
  	<init-param>
           <!-- SpringMVC配置文件路径 -->
  		<param-name>contextConfigLocation</param-name>
  		<param-value>classpath:springmvc.xml</param-value>
  	</init-param>
      <!-- 启动时自动加载配置文件 -->
  	<load-on-startup>1</load-on-startup>
  </servlet>
  <servlet-mapping>
  	<servlet-name>dispatcherServlet</servlet-name>
  	<url-pattern>/</url-pattern>
  </servlet-mapping>
  ```

#### 创建请求处理类 

- 添加一个HelloWorld类，使用注解修饰类和方法。 

  ```java
  @Controller // 修饰类为一个控制器
  public class HelloWorld {	
  	@RequestMapping("/hello") // 修饰方法（或类）的请求路径
  	public String hello(){
  		System.out.println("hello spring mvc");
  		return "hello";
  	}
  }
  ```

#### Spring MVC配置文件

- 配置Spring MVC自动扫描包的路径 

  ```xml
  <!-- 配置Spring MVC自动扫描的路径 -->
  <context:component-scan base-package="com.znsd.controller" />
  ```

- 配置视图解析器，解析方式为

  ```xml
  <!-- 配置视图解析器 将视图返回字符串解析到：/WEB-INF/view/返回值.jsp 下-->
  <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
  	<!-- 视图前缀 -->
  	<property name="prefix" value="/WEB-INF/view/" />
  	<!-- 视图后置 -->
  	<property name="suffix" value=".jsp" />
  </bean>
  ```

#### 添加视图

- 在WEB-INF下添加view文件夹用来存放jsp页面。

  ![image](http://www.znsd.com/pengxiang/dining/uploads/e7da2b17cdd05e2f637504eb453ed362/image.png)

#### 运行结果

- 输入地址显示页面 

  ![image](http://www.znsd.com/pengxiang/dining/uploads/263001dc465e0afebf0bfa9553361869/image.png)

### 接口方式实现MVC 

- 添加控制器类实现Controllor接口，返回一个ModelAndView对象。 

  ```java
  public class HelloWorld implements Controller{
  	@Override
  	public ModelAndView handleRequest(HttpServletRequest req, HttpServletResponse res) throws Exception {
  		System.out.println("HelloWorld");
  		return new ModelAndView("hello");
  	}
  }
  ```

- Spring 配置文件中添加访问路径，和映射。 

  ```xml
  <!-- name：代表访问路径 class：指定控制器类 -->
  <bean name="/helloworld" class="com.znsd.controller.HelloWorld" />
  ```

### 总结 

- 注解方式实现MVC
- 接口方式实现MVC