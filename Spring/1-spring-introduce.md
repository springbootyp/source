## 第一章  Spring初体验

### 本章目标

- 理解Sping机制`重点`
- 搭建Spring开发环境
- Bean的常用配置

### 为什么要学习Spring

- 在前面的课程中，我们已经学习了Struts2和Hibernate框架，也可以使用Struts2和Hibernate来开发一个应用程序，那么我们为什么还要学习Spring框架呢？
- 学习Spring的几个理由：
  - Hibernate是一个ORM框架，Struts2是一个MVC框架，虽然可以用来开发应用，但是代码之间的耦合度过高，各层之间的依赖较强，可扩展性不强。可以说没有Spring那么Struts2和Hibernate缺乏真正的灵魂，Spring是将二者整合的核心控制框架。
  - 在技术发展的过程中，Struts2和Hibernate都出现了很多类似的同类型的框架，可替代性也非常强。而Spring从2003年发展至今，还没有出现能替代它的技术存在。

### 传统分层架构的缺陷

传统MVC项目中，代码的调用都是通过硬编码的方式来实现的，依赖性较强，耦合度较高，不利于程序的扩展。

![image](http://www.znsd.com/znsd/courses/uploads/6a24595d2dc3be716c3d4b3768c4f91a/image.png)

### Java应用之间的依赖关系

- JAVA应用中各组件之间存在着大量的A组件依赖B组件的场景。代码耦合度较高，不利于项目的扩展和维护。
- 对于这种依赖场景，可以有三种解决方案：
  - A组件创建B组件对象，再调用B组件的方法。A组件和B组件耦合性过高。
  - A组件通过工厂模式创建B组件对象，再调用B组件的方法。A组件和B组件的工厂耦合。
  - A、B组件都有一个“容器”来管理，容器将A组件传给B组件，A组件直接调用B组件的方法。彻底解耦。

### 什么是Sping

**Spring到底是什么呢？**

Spring实际上是一个“超级Bean工厂”，也可以称Spring是一个“容器”，这个容器用来管理所有的对象的。

**Spring的优点**

- 解决各层之间的硬编码耦合(类名直接调用)，让各组件之间已“面向接口”方式编程。
- 能解决像事务，权限控制等具有通用性质，横切性质的处理逻辑。
- Sping提供了大量的简化操作，大大的提高了程序员的开发效率。

### Spring之父

Spring 作者 Rod Johnson

- SpringFramework创始人,interface21 CEO
- 丰富的c/c++背景，丰富的金融行业背景
- 1996年开始关注Java服务器端技术
- Servlet2.4和JDO2.0专家组成员
- 2002年著写《Expoert one-on-oneJ2EE设计与开发》，改变了Java世界
- 技术主张：技术以实用为本
- 音乐学博士

![63d0f703918fa0ecf02c6612269759ee3c6ddbc2](http://www.znsd.com/znsd/courses/uploads/e8b22399150b2cb97ce50f1bf9c77343/63d0f703918fa0ecf02c6612269759ee3c6ddbc2.jpg)

### Spring的架构

Spring 框架是一个分层架构，由 7 个定义良好的模块组成。Spring 模块构建在核心容器之上，核心容器定义了创建、配置和管理 bean 的方式，如图所示。

![image](http://www.znsd.com/znsd/courses/uploads/95b0b12bc11a6ad491bad34b6c15b121/image.png)

组成 Spring 框架的每个模块（或组件）都可以单独存在，或者与其他一个或多个模块联合实现。每个模块的功能如下：

- **Core （核心容器）**：核心容器提供 Spring 框架的基本功能。核心容器的主要组件是 `BeanFactory`，它是工厂模式的实现。`BeanFactory` 使用*控制反转* （IOC） 模式将应用程序的配置和依赖性规范与实际的应用程序代码分开。
- **Spring Context（Spring 上下文）**：Spring 上下文是一个配置文件，向 Spring 框架提供上下文信息。Spring 上下文包括企业服务，例如 JNDI、EJB、电子邮件、国际化、校验和调度功能。
- **Spring AOP**：通过配置管理特性，Spring AOP 模块直接将面向方面的编程功能集成到了 Spring 框架中。所以，可以很容易地使 Spring 框架管理的任何对象支持 AOP。Spring AOP 模块为基于 Spring 的应用程序中的对象提供了事务管理服务。通过使用 Spring AOP，不用依赖 EJB 组件，就可以将声明性事务管理集成到应用程序中。
- **Spring DAO**：JDBC DAO 抽象层提供了有意义的异常层次结构，可用该结构来管理异常处理和不同数据库供应商抛出的错误消息。异常层次结构简化了错误处理，并且极大地降低了需要编写的异常代码数量（例如打开和关闭连接）。Spring DAO 的面向 JDBC 的异常遵从通用的 DAO 异常层次结构。
- **Spring ORM**：Spring 框架插入了若干个 ORM 框架，从而提供了 ORM 的对象关系工具，其中包括 JDO、Hibernate 和 iBatis SQL Map。所有这些都遵从 Spring 的通用事务和 DAO 异常层次结构。
- **Spring Web 模块**：Web 上下文模块建立在应用程序上下文模块之上，为基于 Web 的应用程序提供了上下文。所以，Spring 框架支持与 Jakarta Struts 的集成。Web 模块还简化了处理多部分请求以及将请求参数绑定到域对象的工作。
- **Spring MVC 框架**：MVC 框架是一个全功能的构建 Web 应用程序的 MVC 实现。通过策略接口，MVC 框架变成为高度可配置的，MVC 容纳了大量视图技术，其中包括 JSP、Velocity、Tiles、iText 和 POI。

### Spring IOC

IOC（控制反转/依赖注入）的基本概念是：不创建对象，但是描述创建它们的方式。在代码中不直接与对象和服务连接，但在配置文件中描述哪一个组件需要哪一项服务。容器 （在 Spring 框架中是 IOC 容器） 负责将这些联系在一起。在典型的 IOC 场景中，容器创建了所有对象，并设置必要的属性将它们连接在一起，决定什么时间调用方法。

- Spring IOC是Spring中最核心的部分，是以Bean的方式来组织和管理Java应用中的各种组件，提供配置层次的解耦。
- 所有的Bean都由SpringBeanFactory根据配置文件生成管理。
- ApplicationContext是BeanFactory的加强版，提供了更多的功能，如自动创建，国际化等。

### Spring AOP

- Spring AOP也是Spring的核心技术，AOP擅长处理一些具有横切性质的系统服务，如事务管理，安全检查，缓存等。
- Spring并没有提供完整的AOP实现，Spring侧重于AOP实现与Spring IOC容器之间的整合，因此Spring AOP通常和SpringIOC一起使用。

### Spring Web

- Spring Web提供一套基于Spring的MVC框架，相比Struts2更加方便，更加灵活。
- 同时也支持与主流的其他技术和框架集成，支持WebStocket，Servlet，
  Struts2等框架。
- Spring支持各种主流的表现层技术，如Velocity，XSTL等等。

### Spring Data Access

- Spring对传统JDBC进行了封装，能以更简单的方式进行持久化操作。
- Srping对各种主流的ORM框架提供了非常良好的支持。并以模版的形式提供了一致的支持。
- Spring对提供了良好的Dao层支持，帮助开发人员实现自己的Dao组件。
- Spring对事务的支持。

`总体来说，Spring框架是一个用来管理和组织其他框架的一套框架，使得其他框架可以更好的在一起进行工作，从而提高开发人员的开发效率。`

### Hello,Spring!

编写HelloSpring类，

- 输出“Hello,Spring!”
- “Spring”通过Spring注入到HelloSpring类中

开发Spring程序的步骤：

- 添加Spring到项目中
- 编写配置文件
- 编写代码获取HelloSpring实例

### Spring框架介绍

- 我们使用spring-framework-4.2.5.RELEASE-dist版本进行授课。
- Spring目录结构
  - docs：Spring的帮助文档
  - libs：Spring的jar包目录。
  - scheme：Spring的scheme约束文件目录。
- 需要用到的Spring的jar包


  - spring-aop-4.2.5.RELEASE.jar
  - spring-aspects-4.2.5.RELEASE.jar
  - spring-beans-4.2.5.RELEASE.jar
  - spring-context-4.2.5.RELEASE.jar
  - spring-context-support-4.2.5.RELEASE.jar
  - spring-core-4.2.5.RELEASE.jar
  - spring-expression-4.2.5.RELEASE.jar

### Spring配置文件

- 添加Spring配置文件，名字可以随意命名。

- 首先添加spring文件的头。

- 配置一个bean文件映射，指定id和class属性。

  - id表示实例名称，用于在应用程序中进行反射出对象。
  - class表示实例的类名，必须是完整类名。

- bean有一个子属性property，表示对实例成员进行赋初始值。

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
  	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  	xsi:schemaLocation="http://www.springframework.org/schema/beans
          http://www.springframework.org/schema/beans/spring-beans.xsd">

  	<!-- 通过bean元素声明需要Spring创建的实例。 -->
  	<bean id="helloWorld" class="com.znsd.spring.test.HelloSpring">
  		<property name="message" value="Hello World!" />
  	</bean>
  </beans>
  ```

### 代码实现

- 在代码中需要通过ApplicationContext接口来读取Spring的配置文件，可以自己指定名称，多个配置文件，可以指定为数组。

- ClassPathXmlApplicationContext为ApplicationContext的实现类，用来从根目录开始读取xml格式的配置文件信息。

- 然后通过getBean("id")，来读取配置的实例对象。

  ```java
  public static void main(String[] args) {
  	// 通过ClassPathXmlApplicationContext实例化Spring的上下文
  	ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
  	// 通过ApplicationContext的getBean()方法，根据id来获取bean的实例
  	HelloSpring helloSpring = (HelloSpring) context.getBean("helloWorld");
  	System.out.println(helloSpring.getMessage());
  }
  ```

### 加载多个配置文件

- Spring支持同时加载多个bean.xml文件。

  ```java
  // 通过ClassPathXmlApplicationContext实例化Spring的上下文
  // 可以指定多个配置文件名称。
  ApplicationContext context = new ClassPathXmlApplicationContext("beas1.xml","beas2.xml",....);
  ```

  ```java
  // 通过ClassPathXmlApplicationContext实例化Spring的上下文
  // 可以指定多个配置文件名称。
  ApplicationContext context = new ClassPathXmlApplicationContext(new String[]{"beas1.xml","beas2.xml"});
  ```

### 加载资源文件

加载制定的资源文件

- classpath:从类的根目录开始加载

  ```java
  public static void main(String[] args) {
  	// 通过ClassPathXmlApplicationContext实例化Spring的上下文
  	ApplicationContext context = new ClassPathXmlApplicationContext("classpath:applicationContext.xml");
  	// 通过ApplicationContext的getBean()方法，根据id来获取bean的实例
  	HelloSpring helloSpring = (HelloSpring) context.getBean("helloWorld");
  	System.out.println(helloSpring.getMessage());
  }
  ```

- ftp:从网络加载，基于FTP协议。

- http:从网络加载，基于HTTP协议。

  ```java
  Resource resource = context.getResource("classpath:abc.txt");
  try {
    	InputStream in = resource.getInputStream();
    	int tmp = 0;
    	while ((tmp = in.read()) != -1) {
      	System.out.print((char)tmp);
    	}
  } catch (IOException e) {
    	e.printStackTrace();
  }
  ```

### 练习—Hello Spring！

- 用Spring在控制台打印出Hello Spring！
- 用Spring显示当前时间对象。

### 小结

- 为什么要学习Spring框架。
- Spring框架有什么优势。

### Spring容器

- Spring容器其实就是一个超级工厂，它负责所有对象的创建。

- BeanFactory：延迟初始化bean中的所有类。Bean容器的父接口。

- ApplicationContext：会与初始化bean中的scope=singleton的bean对象。

  - ClassPathXmlApplicationContext：ApplicationContext的子类，从加载类的根目录进行查找，相对路径。
  - FileSystemXmlApplicationContext：ApplicationContext的子类，从绝对路径进行进行查找。

  ![20180412155041](http://www.znsd.com/znsd/courses/uploads/de1e2f375ce3b39fc8245de0f77070a8/20180412155041.png)

### BeanFactory和ApplicationContext有什么区别？

BeanFactory 可以理解为含有bean集合的工厂类。BeanFactory 包含了种bean的定义，以便在接收到客户端请求时将对应的bean实例化。BeanFactory还能在实例化对象的时生成协作类之间的关系。此举将bean自身与bean客户端的配置中解放出来。BeanFactory还包含了bean生命周期的控制，调用客户端的初始化方法（initialization methods）和销毁方法（destruction methods）。从表面上看，application context如同bean factory一样具有bean定义、bean关联关系的设置，根据请求分发bean的功能。但application context在此基础上还提供了其他的功能。提供了支持国际化的文本消息统一的资源文件读取方式已在监听器中注册的bean的事件，以下是两种较常见的 ApplicationContext 实现方式：

1. ClassPathXmlApplicationContext：从classpath的XML配置文件中读取上下文，并生成上下文定义。应用程序上下文从程序环境变量中取得。ApplicationContext context = new ClassPathXmlApplicationContext("bean.xml");
2. FileSystemXmlApplicationContext ：由文件系统中的XML配置文件读取上下文。ApplicationContext context = new FileSystemXmlApplicationContext("bean.xml");

### Bean简介

- 什么是Bean？：bean 是一个被实例化，组装，并通过Spring IoC 容器所管理的对象。

- Spring将所有组件都当做bean来进行管理，所有的对象都处于Spring的管理中。
- Spring负责管理和维护所有的Bean，用户无需关心Bean的实例化。
- 开发Spring主要做两件事

  - 创建Bean
  - 配置Bean
- Spring的本质就是根据XML管理Java代码。将Java代码耦合提升到XML配置中。

### Bean的常用配置项

| 属性                | 描述                                       |
| ----------------- | ---------------------------------------- |
| class             | 这个属性是强制性的，并且指定用来创建 bean 的 bean 类。        |
| id                | 这个属性指定唯一的 bean 标识符。在基于 XML 的配置元数据中，你可以使用 ID 和/或 name 属性来指定 bean 标识符。 |
| scope             | 这个属性指定由特定的 bean 定义创建的对象的作用域。             |
| lazy-init         | 延迟初始化的 bean 告诉 IoC 容器在它第一次被请求时，而不是在启动时去创建一个  bean 实例。 |
| init-method 方法    | 在 bean 的所有必需的属性被容器设置之后，调用回调方法。           |
| destroy-method 方法 | 当包含该 bean 的容器被销毁时，使用回调方法。                |
| constructor-arg标签 | 它是用来注入依赖关系的，并会在后面的章节中进行讨论。               |
| properties标签      | 它是用来注入依赖关系的，并会在后面的章节中进行讨论。               |
| autowire          | 它是用来注入依赖关系的，并会在后面的章节中进行讨论。               |

### Bean的初始化

- 默认情况下Spring容器中的所有Bean元素都会在ApplicationContext创建时默认被加载。
- 可以通过lazy-init属性指定持久化类是否启用延迟加载。默认为false。

### Bean的作用范围

在指定一个Bean时，需要指定该bean的作用范围。

| 作用域            | 描述                                       |
| -------------- | ---------------------------------------- |
| singleton      | 该作用域将 bean 的定义的限制在每一个 Spring  IoC 容器中的一个单一实例(默认)。 |
| prototype      | 该作用域将单一 bean 的定义限制在任意数量的对象实例。            |
| request        | 该作用域将 bean 的定义限制为 HTTP 请求。只在web项目中有效。    |
| session        | 该作用域将 bean 的定义限制为 HTTP 会话。只在web项目中有效。    |
| global-session | 该作用域将 bean 的定义限制为全局 HTTP 会话，在跨多个站点共享session时中有效。 |

- singleton  每次获取的bean都是相同的对象

  ```xml
  <!-- 通过bean元素声明需要Spring创建的实例。 -->
  <bean id="helloWorld" class="com.znsd.spring.test.HelloSpring" scope="singleton">
  	<property name="message" value="Hello World!" />
  </bean>
  ```

  ```java
  // 通过ClassPathXmlApplicationContext实例化Spring的上下文
  ApplicationContext context = new ClassPathXmlApplicationContext("classpath:applicationContext.xml", "applicationContext.xml");
  // 通过ApplicationContext的getBean()方法，根据id来获取bean的实例
  HelloSpring helloSpring = (HelloSpring) context.getBean("helloWorld");
  System.out.println("1:" + helloSpring);

  helloSpring = (HelloSpring) context.getBean("helloWorld");
  System.out.println("2:" + helloSpring);
  ```

  ```html
  1:com.znsd.spring.test.HelloSpring@10ab905
  2:com.znsd.spring.test.HelloSpring@10ab905
  ```

- prototype  每次获取的bean都是不同的对象

  ```xml
  <!-- 通过bean元素声明需要Spring创建的实例。 -->
  <bean id="helloWorld" class="com.znsd.spring.test.HelloSpring" scope="prototype">
  	<property name="message" value="Hello World!" />
  </bean>
  ```

  ```java
  // 通过ClassPathXmlApplicationContext实例化Spring的上下文
  ApplicationContext context = new ClassPathXmlApplicationContext("classpath:applicationContext.xml", "applicationContext.xml");
  // 通过ApplicationContext的getBean()方法，根据id来获取bean的实例
  HelloSpring helloSpring = (HelloSpring) context.getBean("helloWorld");
  System.out.println("1:" + helloSpring);

  helloSpring = (HelloSpring) context.getBean("helloWorld");
  System.out.println("2:" + helloSpring);
  ```

  ```html
  1:com.znsd.spring.test.HelloSpring@10ab905
  2:com.znsd.spring.test.HelloSpring@ac3a89
  ```

### Bean的生命周期

**第一种设置初始化和销毁方法**

- 定义：在配置文件中定义bean。

- 初始化：使用ApplicationContext加载配置文件时。

  - 实现InitialzingBean接口，覆盖afterPropertiesSet方法。

- 销毁：销毁bean对象。

  - 实现DisposableBean接口，覆盖destory()方法。

  ```java
  public class HelloWorld implements InitializingBean, DisposableBean {

  	@Override
  	public void afterPropertiesSet() throws Exception {
  		System.out.println("HelloSpring.afterPropertiesSet() 创建bean之前执行的方法");
  	}

  	@Override
  	public void destroy() throws Exception {
  		System.out.println("HelloSpring.destroy() 销毁bean执行的方法");
  	}
  }
  ```

  ```xml
  <bean id="hello" class="com.znsd.spring.test.HelloWorld"></bean>
  ```

  ```java
  @Test
  public void test() {
  	// 通过ClassPathXmlApplicationContext实例化Spring的上下文
  	AbstractApplicationContext context = new ClassPathXmlApplicationContext("classpath:applicationContext.xml");
  	// 通过ApplicationContext的getBean()方法，根据id来获取bean的实例
  	HelloWorld helloSpring = (HelloWorld) context.getBean("hello");
  	System.out.println(helloSpring);
  	// 销毁context
  	context.close();
  }
  ```

**第二种设置初始化和销毁方法**

- 设置bean的init-method属性配置初始化方法。

- 设置bean的destory-method配置销毁方法。

  ```java
  public class BeanLifecycle {

  	public void init() throws Exception {
  		System.out.println("BeanLifecycle.init() 创建bean之前执行的方法");
  	}

  	public void destroy() throws Exception {
  		System.out.println("BeanLifecycle.destroy() 销毁bean执行的方法");
  	}
  }
  ```

  ```xml
  <bean id="beanLifecycle" class="com.znsd.spring.test.BeanLifecycle" init-method="init" destroy-method="destroy"></bean>
  ```

**第三种配置全局的初始化和销毁的方法**

- beans标签的default-init-method和default-destroy-method

  ```java
  public class BeanLifecycle {

  	public void defaultInit() throws Exception {
  		System.out.println("BeanLifecycle.defaultInit() 创建bean之前执行的方法");
  	}
  	
  	public void defaultDestroy() throws Exception {
  		System.out.println("BeanLifecycle.defaultDestroy() 销毁bean执行的方法");
  	}
  }
  ```

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
  	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  	xsi:schemaLocation="http://www.springframework.org/schema/beans
          http://www.springframework.org/schema/beans/spring-beans.xsd" default-init-method="defaultInit" default-destroy-method="defaultDestroy">
  	<bean id="beanLifecycle" class="com.znsd.spring.test.BeanLifecycle"></bean>
  </beans>
  ```

`注意初始化方法会在bean初始化时执行，如果bean的scope是prototype，那么会在每一次bean初始化时都会执行，如果是singleton，那么只在第一次初始化时执行。而scope为singleton的bean的destroy方法则是在容器关闭时执行，而**scope为prototype的bean是不会执行destroy方法的**，这是spring设计使然，要特别注意。`

### init-method和构造函数的区别

init-method是对象属性完成赋值之后（调用过setter方法之后），而构造函数对象赋值之前。

### Bean的声明周期行为

![image](http://www.znsd.com/znsd/courses/uploads/3b586c8644d5356afc8a6eeac03135a5/image.png)

### 总结

- Spring环境搭建
- ApplicationContext容器
- 常用bean配置项
- bean作用范围
- bean生命周期