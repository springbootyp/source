## 第三章 AOP-面向切面编程

### 本章目标

- 理解什么是AOP`重点（难点）`
- 理解使用aspectJ实现增强
- 掌握使用Schema实现定义增强`重点（难点）`
- 掌握使用注解定义增强`重点（难点）`

### 为什么需要AOP

- 当需要为N个模块添加一个通用用的业务处理的时候。比如事务处理，日志，权限控制等等。

  ![20180414095750](http://www.znsd.com/znsd/courses/uploads/4ba8904fd0358837a49e72e3a1460a43/20180414095750.png)

  ![20180414095639](http://www.znsd.com/znsd/courses/uploads/de181c55551e8d88ca7e50f5e85926ff/20180414095639.png)

### 什么是AOP

- AOP(Aspect Oriented Programming)：面向切面编程，通过预编译方式和运行期动态代理实现程序功能的统一维护的一种技术。
- AOP是对OOP（面向对象编程）的补充，是软件开发中的一个热点，也是Spring框架中的一个重要内容。我们知道面向对象编程是从上往下的把系统拆分成若干个类，如`Web`项目中常见的`Action`、`Service`、`Dao`等分层。但是面向对象编程对于从左到右的水平抽象十分无力，类似于日志、权限等系统级功能的代码会重复的出现在任何地方。简单的说，面向切面编程可以把系统里一些分散的重复代码集中在一起，抽象成一个切面。
- 利用AOP可以对业务逻辑的各个部分进行隔离，从而使得业务逻辑各部分之间的耦合度降低，提高程序的可重用性，同时提高了开发的效率。
- `AOP`在`Spring`中主要是通过动态代理实现的，具体实现也分为两种：`JDK动态代理`和`CGLIB动态代理`。其中`JDK动态代理`是基于接口代理，`CGLIB动态代理`是基于继承代理。 

### 动态代理

在正式进入Spring AOP的源码实现前，我们需要准备一定的基础也就是面向切面编程的核心——动态代理。 动态代理实际上也是一种结构型的设计模式，JDK中已经为我们准备好了这种设计模式，不过这种JDK为我们提供的动态代理有2个缺点：

1. **只能代理实现了接口的目标对象；**
2. **基于反射，效率低** 

鉴于以上2个缺点，于是就出现了第二种动态代理技术——CGLIB（Code Generation Library）。这种代理技术一是不需要目标对象实现接口（这大大扩展了使用范围），二是它是基于字节码实现（这比反射效率高）。当然它并不是完全没有缺点，**因为它不能代理final方法**（因为它的动态代理实际是生成目标对象的子类）。 

Spring AOP中生成代理对象时既可以使用JDK的动态代理技术，也可以使用CGLIB的动态代理技术，本章首先对这两者动态代理技术做简要了解，便于后续源码的理解。 

### 基于jdk动态代理实现

- 定义动态代理接口

```java
public interface UserService {

	public void save(User user);
	
	public void delete(Integer id);
}
```

- 动态代理接口实现类

```java
public class UserServiceImpl implements UserService {

	@Override
	public void save(User user) {
		System.out.println("save user!");
	}

	@Override
	public void delete(Integer id) {
		System.out.println("user delete");
	}
}
```

- 代理类

```java
public class LogInvocationHandler implements InvocationHandler {

	// 这个就是我们要代理的真实对象
	private Object target;

	// 构造方法，给我们要代理的真实对象赋初值
	public LogInvocationHandler(Object target) {
		this.target = target;
	}

	@Override
	public Object invoke(Object object, Method m, Object[] args) throws Throwable {
		
		// 在代理真实对象前我们可以添加一些自己的操作，比如记录日志、统计方法执行的时间
		System.out.println("method invoke start...");
		// 当代理对象调用真实对象的方法时，其会自动的跳转到代理对象关联的handler对象的invoke方法来进行调用
		Object result = m.invoke(target, args);
		// 在代理真实对象后我们也可以添加一些自己的操作
		System.out.println("method invoke end!");
		
		return result;
	}
}
```

- 测试

```java
public static void main(String[] args) {
    // 我们要代理的真实对象
    UserService userService = new UserServiceImpl();

    // 我们要代理哪个真实对象，就将该对象传进去，最后是通过该真实对象来调用其方法的
    LogInvocationHandler logInvocationHandler = new LogInvocationHandler(userService);

    /*
		 * 通过Proxy的newProxyInstance方法来创建我们的代理对象，我们来看看其三个参数
		 * 第一个参数userService.getClass().getClassLoader()，我们这里使用userService这个类的ClassLoader对象来加载我们的代理对象
		 * 第二个参数userService.getClass().getInterfaces()，我们这里为代理对象提供的接口是真实对象所实行的接口，表示我要代理的是该真实对象，这样我就能调用这组接口中的方法了
		 * 第三个参数handler， 我们这里将这个代理对象关联到了上方的 InvocationHandler这个对象上
		 */
    UserService userServiceProxy = (UserService) Proxy.newProxyInstance(userService.getClass().getClassLoader(),
                                                                        userService.getClass().getInterfaces(), logInvocationHandler);

    //查看userServiceProxy对象的类型
    System.out.println(userServiceProxy.getClass().getName());

    userServiceProxy.save(new User());
    userServiceProxy.delete(1);
}
```

![20180710214154](http://www.znsd.com/znsd/courses/uploads/0095d37ed428245277c71712a6b34342/20180710214154.png)

### AOP机制

- 使用AOP依然需要修改所有的方法，只不过这个由Spring框架完成。
- AOP在两个时机修改所有方法：
  - 在编译Java代码时，也称为编译时增强。（静态织入）（AspectJ）
  - 在运行时动态修改类，生成新类，也称为运行时增强。（动态织入）（Spring AOP）
- 使用静态织入的方式性能要高于动态织入，但是动态织入更加方便。

### AOP的一些术语

- 目标（Target）：没有被修改的对象，也是被aspectj横切的对象。
- 切面（Aspect）：一个关注点的模块化，这个关注点可能会横切多个对象。事务管理是J2EE应用中一个关于横切面很好的例子。它是一个抽象的概念，从软件的角度来说是指在应用程序不同模块中的某一个领域或方面。由pointcut 和advice组成。
- 切入点（Pointcut）：是一个或一组基于正则表达式，会选取程序中的某些我们感兴趣的执行点，或者说是程序执行点的集合。（例如，当执行某个特定名称的方法时）
- 连接点（Joinpoint）：通过pointcut选取出来的集合中的具体的一个执行点，通俗有点就是需要被织入的方法.
- 通知（Advice）：在选取出来的JoinPoint上要执行的操作、逻辑，织入的代码。

### AOP的通知类型

AOP通知类型主要有以下五种

| 通知类型    | 关键子             | 描述                     |
| ------- | --------------- | ---------------------- |
| 前置通知    | before          | 在一个方法执行之前，执行通知。        |
| 后置通知    | after           | 在一个方法执行之后，不考虑结果，执行通知。  |
| 后置返回通知  | After-returning | 在一个方法执行之后，考虑返回结果，执行通知。 |
| 环绕通知    | around          | 在一个方法执行之前和之后，执行通知。     |
| 抛出异常后通知 | throwing        | 在一个方法执行之后并抛出异常时，执行通知。  |

- *前置通知（Before advice）*：在某连接点之前执行的通知，但这个通知不能阻止连接点之前的执行流程（除非它抛出一个异常）。
- *后置通知（After returning advice）*：在某连接点正常完成后执行的通知：例如，一个方法没有抛出任何异常，正常返回。
- *异常通知（After throwing advice）*：在方法抛出异常退出时执行的通知。
- *最终通知（After (finally) advice）*：当某连接点退出的时候执行的通知（不论是正常返回还是异常退出）。
- *环绕通知（Around Advice）*：包围一个连接点的通知，如方法调用。这是最强大的一种通知类型。环绕通知可以在方法调用前后完成自定义的行为。它也会选择是否继续执行连接点或直接返回它自己的返回值或抛出异常来结束执行。

### AOP的实现步骤

- Eclipse编写AspectJ的步骤：
- AspectJ:“a seamless aspect-oriented extension to the Javatm programminglanguage”（一种基于Java平台的面向切面编程的语言）。Aspectj能做什么干净的模块化横切关注点（也就是说单纯，基本上无侵入），如错误检查和处理，同步，上下文敏感的行为，性能优化，监控和记录，调试支持，多目标的协议
  - 安装aspectJ插件。
  - 创建AspectJ项目，如果已经创建了项目，可以使用Convert aspectJ Project将项目转换为aspectJ项目。
  - 添加aspectj文件，后缀名为file.aj
  - 编写需要横切的目标对象  pointcut
  - 编写要织入的代码（before：方法执行之前after：方法执行之后。around：方法执行之前和之后）
  - 运行aspectJ项目

### aspectJ初体验

- 添加aspectJ插件，创建AspectDemo.aj文件

- 定义pointcut切入点

- 使用before()、after()、around()通知规则

  ```java
  public aspect AspectDemo {
  
  	/**
  	 * *表示通配符，这里表示匹配任意返回值..表示匹配任意参数
  	 */
  	pointcut HelloWorldPointCut() : execution(* com.znsd.spring.aop.HelloWorld.main(..));
  
  	pointcut BeforePointCut() : execution(* com.znsd.spring.aop.HelloWorld.main(..));
  
  	/**
  	 * after表示切入的位置,HelloWorldPointCut名称必须一致
  	 * 为com.znsd.spring.aop.HelloWorld.main方法定义切面方法。
  	 */
  	after() : HelloWorldPointCut(){
  		System.out.println("aspect Hello world");
  	}
  	
  	/**
  	 * 方法执行之前
  	 */
  	before() : BeforePointCut() {
  		System.out.println("aspect before execute");
  	}
  }
  ```

- execution表达式说明

  ```java
  //匹配UserDaoImpl类中的所有方法
  execution(* com.znsd.dao.UserDaoImpl.*(..))
  
  //匹配UserDaoImpl类中的所有公共的方法
  execution(public * com.znsd.dao.UserDaoImpl.*(..))
  
  //匹配UserDaoImpl类中的所有公共方法并且返回值为int类型
  execution(public int com.znsd.dao.UserDaoImpl.*(..))
  
  //匹配UserDaoImpl类中第一个参数为int类型的所有公共的方法
  execution(public * com.znsd.dao.UserDaoImpl.*(int , ..))
  ```

### AOP代理

- AOP代理：AOP框架修改原来代码之后创建的对象，它的方法即回调了目标对象的方法，也包含了增强处理的代码。

- AOP代理作为目标对象的替代品，包含目标对象的全部方法，而且这些方法都添加了增强处理。

  ![image](http://www.znsd.com/znsd/courses/uploads/6ee60dca471b4d786c7d5b94c21ae82e/image.png)

### 小结

- 什么是AOP？
- 使用AOP有什么好处？
- aspectJ实现AOP的步骤？

### Spring AOP

- Spring当中已经集成了AOP功能，所以实现起来也更加简单。
- Spring实现AOP的步骤：
  - 导入对应的jar包。
  - 添加一个aspect类，（普通类）。
  - 添加aop配置信息。

### Spring AOP依赖的jar包

要使用Spring AOP需要导入依赖的jar包

- aspectjrt.jar
- aspectjweaver.jar
- aspectjtools.jar
- org.aspectj.matcher.jar
- aopalliance.jar

### Spring AOP的配置

Spring中使用AOP有两种方式

- 基于XML配置

- 基于注解的配置

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
  	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:aop="http://www.springframework.org/schema/aop"
  	xsi:schemaLocation="http://www.springframework.org/schema/beans
      http://www.springframework.org/schema/beans/spring-beans-4.0.xsd 
      http://www.springframework.org/schema/aop 
      http://www.springframework.org/schema/aop/spring-aop-4.0.xsd ">

  	<aop:config>
  	    <!--定义一个aspect-->
  	    <aop:aspect id="myAspect" ref="aBean">
  	    <!--定义一个切入点-->
  	    <aop:pointcut id="businessService“ 
  	        expression="execution(* com.xyz.myapp.service.*.*(..))"/>
  	        <!--定义一个插入规则-->
  	        <aop:after pointcut-ref=" businessService" method=“method" />    </aop:aspect>
  	</aop:config>
  	<bean id="aBean" class="...">
  	...
  	</bean>
  </beans>
  ```

  ​

### 怎样使用AOP 

**示例**

使用Spring AOP实现系统日志功能

- 业务介绍：将业务逻辑层方法的调用信息输出到控制台
- AOP思路：分别编写业务逻辑代码和“增强”代码，运行时再组装

**实现步骤**

1. 在项目中添加所需的jar文件
2. 编写业务逻辑接口和实现类，编码时无须关心“其他”功能

- StudentService

  ```java
  public interface StudentService {

  	int add(Student student);

  	int select();
  }
  ```

- StudentServiceImpl

  ```java
  public class StudentServiceImpl implements StudentService {

  	@Override
  	public int add(Student student) {
  		System.out.println("学生添加");
  		return 0;
  	}

  	@Override
  	public int select() {
  		System.out.println("学生查询");
  		return 0;
  	}

  }
  ```

**添加AOP日志处理类**

- 编写增强代码

  ```java
  public class LogAspect {

  	public void addLog() {
  		System.out.println("添加日志处理");
  	}
  }
  ```

**配置AOP**

- 添加spring.xml配置文件

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
  	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
  	xmlns:aop="http://www.springframework.org/schema/aop"
  	xsi:schemaLocation="http://www.springframework.org/schema/beans
      http://www.springframework.org/schema/beans/spring-beans-4.2.xsd 
      http://www.springframework.org/schema/aop 
      http://www.springframework.org/schema/aop/spring-aop-4.2.xsd ">
  	
  	<!-- 定义bean -->
  	<bean id="studentService" class="com.znsd.spring.student.service.impl.StudentServiceImpl"></bean>
  	<!-- AOP配置 -->
  	<!-- 添加Aspect的bean -->
  	<bean id="logAspect" class="com.znsd.spring.student.aop.LogAspect"></bean>
  	<aop:config>
  		<!-- 定义一个pointcut -->
  		<aop:pointcut id="servicePoint" expression="execution(* com.znsd.spring.student.service.*.*(..))"/>
  		<!-- 定义aspect，引用生成的aspectBean 并指定pointcut 和 method-->
  		<aop:aspect id="aspect" ref="logAspect">
  			<aop:after pointcut-ref="servicePoint" method="addLog"/>
  		</aop:aspect>
  	</aop:config>
  </beans>
  ```

**测试运行**

- 添加测试类

  ```java
  public class Main {

  	public static void main(String[] args) {
  		ApplicationContext ac = new ClassPathXmlApplicationContext("spring.xml");
  		// 获取业务Bean
  		StudentService service = (StudentService) ac.getBean("studentService");
  		service.add(null);
  		service.select();
  	}
  }
  ```

- 在业务方法执行前后，成功添加了日志功能

  ![20180416111654](http://www.znsd.com/znsd/courses/uploads/e956b33d0d7f3085a6090e312a05ca9e/20180416111654.png)

### AOP配置标签

- \<aop:before …>：在目标方法调用之前织入。
- \<aop:after…>：在目标方法调用之后织入。
- \<aop:after-throwing..>：抛出异常时织入。
- \<aop:after-returning…>：在目标方法成功执行之后织入。
- \<aop:around…>：在目标方法调用之前和调用之后织入。

### 学员操作——使用Spring AOP记录日志

- 需求说明：使用前置增强和后置增强对业务方法的执行过程进行日志记录
- 完成时间：25分钟

### 异常抛出增强2-1

- 异常抛出增强的特点是在目标方法抛出异常时织入增强处理，但是异常处理一般会需要获取异常参数。

  ```java
  public class ExceptionAspect {

  	public void addExceptionLog(Exception e) {
  		System.out.println("发生异常，写入日志：" + e.getMessage());
  	}
  }
  ```

### 异常抛出增强2-2

- 在配置文件中添加异常处理的aspect。使用<aop:after-throwing来进行异常织入。

  ```xml
  <bean id="exceptionAspect" class="com.znsd.spring.student.aop.ExceptionAspect"></bean>
  <aop:config>
  		<!-- 定义一个pointcut -->
  		<aop:pointcut id="servicePoint" expression="execution(* com.znsd.spring.student.service.*.*(..))"/>
  		<!-- 定义aspect，引用生成的aspectBean 并指定pointcut 和 method-->
  		<aop:aspect id="aspect2" ref="exceptionAspect">
  			<aop:after-throwing pointcut-ref="servicePoint" method="addExceptionLog" throwing="e"/>
  		</aop:aspect>
  	</aop:config>
  ```

  ![20180416163900](http://www.znsd.com/znsd/courses/uploads/0f0fcc306b938a793bbc6fd8e90db648/20180416163900.png)

### 环绕增强2-1

- 环绕增强在目标方法的前后都可以织入增强处理
- 环绕增强是功能最强大的增强处理，Spring把目标方法的控制权全部交给了它
- 在环绕增强处理中，可以获取或修改目标方法的参数、返回值，可以对它进行异常处理，甚至可以决定目标方法是否执行

### 环绕增强 2-2

- 定义环绕增强

  ```java
  public class AroundLogger {
  	
  	public Object aroundLogger(ProceedingJoinPoint jp) throws Throwable {
  		System.out.println("进入方法-环绕通知");
  		Object o = jp.proceed();
  		System.out.println("退出方法-环绕通知");
  		return o;
  	}
  }
  ```

- 在Spring配置文件中进行定义

  ```xml
  <bean id="aroundLogger" class="com.znsd.spring.student.aop.AroundLogger"></bean>
  <aop:config>
  		<!-- 定义一个pointcut -->
  		<aop:pointcut id="servicePoint" expression="execution(* com.znsd.spring.student.service.*.*(..))"/>
  		
  		<!-- 定义aspect，引用生成的aspectBean 并指定pointcut 和 method-->
  		<!-- 环绕通知 -->
  		<aop:aspect id="aspect3" ref="aroundLogger">
  			<aop:around pointcut-ref="servicePoint" method="aroundLogger"/>
  		</aop:aspect>
  	</aop:config>
  ```

  ![20180416165501](http://www.znsd.com/znsd/courses/uploads/c28b2ab3f47216a074829589ab76d394/20180416165501.png)

### 学员操作——定义环绕配置切面

- 需求说明：使用Schema方式定义前置增强（包含连接点信息）和后置增强（包含连接点信息和返回值），对业务方法的执行过程进行日志记录
- 完成时间：20分钟

### 小结

- Spring AOP的实现步骤
- Spring AOP的配置标签。
- 前置增强、后置增强、环绕增强。
- 可以通过Schema形式将POJO的方法配置成切面
- 所用标签包括\<aop:aspect>、\<aop:before>、\<aop:after-returning>、\<aop:around>、\<aop:after-throwing>、\<aop:after>等

### 使用注解定义增强3-1

- AspectJ是一个面向切面的框架，它扩展了Java语言，定义了AOP 语法，能够在编译期提供代码的织入
- @AspectJ是AspectJ 5新增的功能，使用JDK5.0 注解技术和正规的AspectJ切点表达式语言描述切面
- Spring通过集成AspectJ实现了以注解的方式定义增强类，大大减少了配置文件中的工作量
- 使用@AspectJ，首先要保证所用的JDK 是5.0或以上版本
- 将Spring的asm模块添加到类路径中，以处理@AspectJ中所描述的方法参数名

### 使用注解定义增强3-2

实现步骤

- 在项目中添加SpringAOP相关的jar文件

- 使用注解定义前置增强和后置增强实现日志功能

  ```java
  @Aspect
  public class StudentServiceLogger {

  	/**
  	 * 定义前置增强
  	 */
  	@Before("execution(* com.znsd.spring.student.service.*.*(..))")
  	public void before() {
  		System.out.println("方法进入之前-前置通知");
  	}
  	
  	/**
  	 * 定义后置增强
  	 */
  	@AfterReturning("execution(* com.znsd.spring.student.service.*.*(..))")
  	public void after() {
  		System.out.println("方法执行之后-后置通知");
  	}
  }
  ```

- 编写Spring配置文件，织入注解定义的增强

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
  	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
  	xmlns:aop="http://www.springframework.org/schema/aop"
  	xsi:schemaLocation="http://www.springframework.org/schema/beans
      http://www.springframework.org/schema/beans/spring-beans-4.2.xsd 
      http://www.springframework.org/schema/aop 
      http://www.springframework.org/schema/aop/spring-aop-4.2.xsd ">
  	
  	<!-- 定义bean -->
  	<bean id="studentService" class="com.znsd.spring.student.service.impl.StudentServiceImpl"></bean>
  	<!-- 定义包含注解的增强类的实例 -->
  	<bean class="com.znsd.spring.student.aop.StudentServiceLogger"></bean>
  	<!-- 织入使用注解定义的增强，需要引入aop命名空间 -->
  	<aop:aspectj-autoproxy />
  </beans>
  ```

### 使用注解定义增强 3-3

```java
@Aspect
public class StudentServiceLogger {

	/**
	 * 定义前置增强
	 */
	@Before("execution(* com.znsd.spring.student.service.*.*(..))")
	public void before(JoinPoint jp) {
		System.out.println("调用" + jp.getTarget() + "的" + jp.getSignature().getName() + "方法，参数" + Arrays.toString(jp.getArgs()));
	}
	
	/**
	 * 定义后置增强
	 */
	@AfterReturning(pointcut = "execution(* com.znsd.spring.student.service.*.*(..))", returning = "returnValue")
	public void after(JoinPoint jp, Object returnValue) {
		System.out.println("调用 " + jp.getTarget() + " 的 " + jp.getSignature().getName() + " 方法。方法返回值：" + returnValue);
	}
}
```

### 学员操作——使用注解实现日志增强

- 需求说明：使用注解方式定义前置增强（包含连接点信息）和后置增强（包含连接点信息和返回值），对业务方法的执行过程进行日志记录
- 完成时间：20分钟

### 使用注解定义其他增强类型

- 定义异常抛出增强

  ```java
  @Aspect
  public class ErrorLogger {

  	/**
  	 * RuntimeException中的参数名要和throwing的值一致
  	 * @param jp
  	 * @param e
  	 */
  	@AfterThrowing(pointcut = "execution(* com.znsd.spring.student.service.impl.StudentServiceImpl.*(..))", throwing = "e")
  	public void afterThrowing(JoinPoint jp, RuntimeException e) {
  		System.out.println(jp.getSignature().getName() + " 方法发生异常：" + e);
  	}
  }
  ```

- 定义环绕增强

  ```java
  @Aspect
  public class AroundLogger {

  	@Around("execution(* com.znsd.spring.student.service.impl.StudentServiceImpl.*(..))")
  	public Object aroundLogger(ProceedingJoinPoint jp) throws Throwable {
  		System.out.println("调用 " + jp.getTarget() + " 的 " + jp.getSignature().getName() + " 方法。方法入参："
  				+ Arrays.toString(jp.getArgs()));
  		try {
  			Object result = jp.proceed();
  			System.out.println("调用 " + jp.getTarget() + " 的 " + jp.getSignature().getName() + " 方法。方法返回值：" + result);
  			return result;
  		} catch (Throwable e) {
  			System.out.println(jp.getSignature().getName() + " 方法发生异常：" + e);
  			throw e;
  		}
  	}
  }
  ```

	 定义最终增强	

  ```java
  @Aspect
  public class AfterLogger {

  	@After("execution(* com.znsd.spring.student.service.impl.StudentServiceImpl.*(..))")
  	public void afterLogger(JoinPoint jp) {
  		System.out.println(jp.getSignature().getName() + " 方法结束执行。");
  	}
  }
  ```

  @AspectJ还提供了一种最终增强类型，无论方法抛出异常还是正常退出，该增强都会得到执行，类似于异常处理机制中finally块的作用，一般用于释放资源

### 小结

- 使用注解方式定义切面可以简化配置工作量
- 常用注解有@Aspect、@Before、@AfterReturning、@Around、@AfterThrowing、@After等
- 通过在配置文件中添加\<aop:aspectj-autoproxy />元素，就可以启用对于@AspectJ注解的支持

### 总结

- Spring提供的增强处理类型包括：前置增强、后置增强、环绕增强、异常抛出增强、最终增强等
- 使用注解方式定义切面可以简化配置工作量，通过在配置文件中添加\<aop:aspectj-autoproxy />元素启用对于@AspectJ注解的支持。常用的注解有@Aspect、@Before、@AfterReturning、@Around、@AfterThrowing、@After等。
- 也可以通过Schema形式将POJO的方法配置成切面，所用标签包括\<aop:aspect>、\<aop:before>、\<aop:after-returning>、\<aop:around>、\<aop:after-throwing>、\<aop:after>等