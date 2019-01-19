## 第六章      Spring注解

### 本章目标

- 掌握注解的基本用法 `重点（难点）`
- 掌握常用注解标签

### 为什么使用注解

- 目前越来越多的主流框架都支持注解，同样Spring也支持基于注解的"零配置"。 
- 注解相比XML的优势：
  - 它可以充分利用 Java 的反射机制获取类结构信息，这些信息可以有效减少配置的工作。
  - 注释和 Java 代码位于一个文件中，更加便于维护。
- `注意：必须在Spring 2.5版本后才能使用注解。`

### 使用注解实现IoC 

**注解方式将Bean的定义信息和Bean实现类结合在一起，Spring提供的注解有**

- @Component：一个普通的Bean类。
- @Repository  ：用于标注持久层DAO类
- @Service  ：用于标注业务层类
- @Controller  ：用于标注控制器类

**示例**

```java
// 与在XML配置文件中编写<bean id="userDao" class="dao.impl.UserDao" /> 等效
@Repository("userDao")  // Spring有默认的命名策略，使用非限定类名，第一个字母小写，也可以在注解中使用value属性指定组件的名称。
public class UserDao implements IDao {
    
}
```

### 搜索Bean类

- 我们配置好了Bean就可以了吗? 

- 既然我们不在使用Spring配置文件来配置任何Bean的实例，那么我们需要在Spring中使用\<context:componect-scan/>来指定要检索某个路径下的Java类。 

- <context:componect-scan />的常用属性：base-package：指定要扫描的基类包，Spring容器会扫描这个基类包下和子包中的所有的类。如果包含多个包使用","隔开。

  ```xml
  <beans
  	xmlns="http://www.springframework.org/schema/beans"
  	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  	xmlns:p="http://www.springframework.org/schema/p"
  	xmlns:context="http://www.springframework.org/schema/context"
  	xsi:schemaLocation="http://www.springframework.org/schema/beans 
  	http://www.springframework.org/schema/beans/spring-beans-4.1.xsd
  	http://www.springframework.org/schema/context 
  	http://www.springframework.org/schema/context/spring-context-4.1.xsd">

  	<!-- 指定要扫描的某个文件夹中的Bean -->
  	<context:component-scan base-package="com.znsd.service,com.znsd.dao" />
  </beans>
  ```

#### 搜索过滤条件1-1 

**Spring提供两个子标签进行条件过滤。**

- \<content:include-filter />：只检索指定的规则
- \<content:exclude-filter />：排除指定的规则
- 这两个标签的属性是一致的 
  - type：表示过滤的类型
  - expression：表示过滤的表达式。

| 类别         | 表达式                                      | 说明                                       |
| ---------- | ---------------------------------------- | ---------------------------------------- |
| annotation | org.springframework.stereotype.Repository | 所有标注了@Repository的类，该类型采用目标类是否标注了某个注解进行过滤 |
| assinable  | com.lxit.XxxService                      | 所有继承或扩展了XxxService的类，该类型采用目标是否继承或者扩展了某个类进行过滤。 |
| aspectj    | com.lxit.*Service                        | 所有类名以Service结尾的类以及继承它或扩展它的类，该类型采用aspectj表示式进行过滤。 |
| regex      | com\.lxit\.Service                       | 所有com.lxit.Service包下的类，该类型采用正则表达式进行过滤。   |
| custom     | com.lxit.XxxtypeFilter                   | 采用XxxTypeFilter进行过滤，通过代码方式定义过滤规则，该类必须实现org.springframework.core.type.typeFilter接口。 |



#### 搜索过滤条件1-2 

过滤条件

```xml
<context:component-scan base-package="com.lxit.ssh" resource-pattern="repository/*.class">
    <!-- 表示不接受@Respository修饰的类 -->
    <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Repository"/>
</context:component-scan>
```

```xml
<context:component-scan base-package="com.lxit.ssh" resource-pattern="repository/*.class" 
    use-default-filters="false">
    <!-- 使用<context:include-filter />时，必须将系统默认的过滤器关闭。-->
    <!-- 表示只接受@Respository修饰的类 -->
    <context:include-filter type="annotation" expression="org.springframework.stereotype.Repository"/>
</context:component-scan>
```

### 组件装配 注解。

<context:component-scan />元素还会自动注册一个AutowiredAnnotationBeanPostProcessor实例（后置处理器），该实例可以自动装配有`@Autowired、@Resource、`@Inject修饰的属性。

#### @Autowired注解 

- @Autowired注解默认按类型装配（这个注解是属于spring的），默认情况下必须要求依赖对象必须存在，如果要允许null 值，可以设置它的required属性为false，如：@Autowired(required=false) ，如果我们想使用名称装配可以结合@Qualifier注解进行使用`@Autowired() @Qualifier("baseDao")`
- 构造器，普通字段（非public属性），一切具有参数的方法都可以应用@Autowired注解。 
- 默认情况下，所有使用@Autowired注解的属性都需要被设置，当Spring找不到匹配的Bean来装配属性时，会抛出异常。若想某个属性允许不被设置，可以将其required属性设置为false。
- @Autowired注解放在数组或集合的属性上时，Spring容器会将所有匹配的bean进行自动装载。
- @Autowired注解放在Map上时，若该Map的键值为String，那么Spring会自动将所有匹配的bean进行自动加载，此时key为类的名称。 

#### @Autowired装配 

- 使用@Autowired注解实现byBean的自动装配，默认按类型匹配，可以使用@Qualifier指定Bean的名称

- 可以放在属性上，对类的成员变量进行标注 

  ```java
  @Service("userService") 
  public class UserService implements IUserService { 
  	@Autowired
  	@Qualifier("userDao")
  	private IDao dao; 
  }
  ```

- 也可以放在方法上，对方法的入参进行标注

  ```java
  @Service("userService") 
  public class UserService implements IUserService { 
  	private IDao dao;
  	@Autowired
  	public void setDao(IDao dao) {
  	   this.dao = dao;
  	}
  }
  ```

#### @Resource

- @Resource 的作用相当于 @Autowired，只不过 @Autowired 默认按 byType 自动注入,byType找不到对应的bean，然后再按照byName的方式注入，而@Resource默认安照名称进行装配，名称可以通过name属性进行指定，   如果没有指定name属性，当注解写在字段上时，默认取字段名进行按照名称查找，如果注解写在setter方法上默认取属性名进行装配。 当找不到与名称匹配的bean时才按照类型进行装配。但是需要注意的是，如果name属性一旦指定，就只会按照名称进行装配。

- @Resource 有两个属性是比较重要

  - name ：指定自动注入的名称
  - type：注入类型，byName或者byType，默认byName。 

  ```java
  @Service("userService") 
  public class UserService implements IUserService { 
  	private IDao dao;
  	@Resource(name="userDao")
  	public void setDao(IDao dao) {
  	   this.dao = dao;
  	}
  }
  ```

#### @Inject 

@Inject注解使用方式和@Autowired一样，也是根据类型匹配进行注入，只是@Inject没有reqired属性。所以建议使用@Autowired注解。 

### @Autowired和@Resource的区别

- **@Autowired与@Resource都可以用来装配bean. 都可以写在字段上,或写在setter方法上。**
- @Autowired默认**按类型装配**（这个注解是属业spring的），默认情况下必须要求依赖对象必须存在，如果要允许null值，可以设置它的required属性为false，如：@Autowired(required=false) ，如果我们想使用名称装配可以结合@Qualifier注解进行使用，如下：

```java
@Autowired()
@Qualifier("userDao")
private UserDao userDao;
```

- @Resource **是JDK1.6支持的注解**，**默认按照名称进行装配**，名称可以通过name属性进行指定，如果没有指定name属性，当注解写在字段上时，默认取字段名，按照名称查找，如果注解写在setter方法上默认取属性名进行装配。当找不到与名称匹配的bean时才按照类型进行装配。但是需要注意的是，如果name属性一旦指定，就只会按照名称进行装配。

### Action层注解2-1 

- Web.xml中增加自动扫描action的配置 

```xml
<!-- Struts2的配置 -->
<filter>
    <filter-name>struts2</filter-name>
    <filter-class>org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter</filter-class>
    <init-param>
        <param-name>actionPackages</param-name>
        <param-value>com.znsd.ssh.action</param-value>
    </init-param>
</filter>
<filter-mapping>
    <filter-name>struts2</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

- 导入struts2-convention-plugin-XXX.jar 

- 注解声明ACTION类：使用@Actions或者继承ActionSupport类或使用@Controller 

  ```java
  @Controller("userAction") // action声明
  @ParentPackage("struts-default") // 默认父包
  @Scope("prototype") // 多例
  @Namespace("/") // 命名空间
  public class UserAction {
      
  }
  ```

- `ACTION层使用注解，ACTION类所在的包名路径必须是：struts/struts2/action/actions`

### Action层注解2-2

注解定义action处理方法

```java
@Action(value = "login", results = {
    @Result(name = "success", location = "/success.jsp"),
    @Result(name = "input", location = "/login.jsp")
})
public String login() {
    System.out.println("user:" + this.user);

    User user = this.userService.login(this.user.getUsername(), this.user.getPassword());
    if (user != null) {
        this.user = this.userService.findById(user.getId());
        return "success";
    }
    return "input";
}
```

### Action使用JSON 

- 导入依赖包：struts2-json-plugin-xxx.jar 

- Action类必须指定ParentPackage为：json-default：@ParentPackage(value = "json-default")

- 为Action类增加Map<String,Object>类型的属性 ：private Map<String, Object> dataMap; 

- 通过Annotation对Action类的相关方法进行JSON的注解 

  ```java
  @Action(
      className = "userAction", 
      value = "/login",  
      results = @Result(type = "json", params = {  
              "noCache", "true",         // 是否启用缓存   
              "contentType", "text/html",// 设置响应的内容类型  
              "root", "dataMap",         // 设置根对象  
              "ignoreHierarchy", "true"  // 忽略基类  
  	})
  )
  ```

### Service层注解 

- 注解定义Service 

  ```java
  @Service("userService")
  public class UserServiceImpl implements UserService {
      
  }
  ```

### Dao层注解

- 使用@Repository定义Dao 

  ```java
  @Repository("userDao")
  public class UserDaoImpl implements UserDao {

  	@Resource(name = "hibernateTemplate")
  	private HibernateTemplate hibernateTemplate;
      
      @Override
  	public User login(String username, String password) {
  		System.out.println(username);
  		List<User> userList = (List<User>) myHibernateTemplate
  				.find("from User where username = ? and password = ?", new Object[] { username, password });
  		if (userList != null && userList.size() > 0) {
  			return userList.get(0);
  		}
  		return null;
  	}
  }
  ```

### 事务注解 

- 使用@Transactional声明事务处理

- `配置文件中声明使用注解管理事务：<tx:annotation-driven transaction-manager="txManager" />`

  ```xml
  <tx:annotation-driven transaction-manager="txManager" />
  ```

- 代码中使用@Transactional注解

  ```java
  @Service("userService")
  @Transactional(
  	propagation = Propagation.REQUIRED, 
  	timeout = 10, 
  	isolation = Isolation.DEFAULT
  )
  public class UserServiceImpl implements UserService {
  	
  }
  ```

### 其它注解 

- 使用@Scope注解指定Bean的作用域 

  ```java
  @Scope("prototype") 
  @Service("userBiz") 
  public class UserBiz implements IUserBiz {
      
  }
  ```

- @PostConstruct初始化

  ```java
  @PostConstruct
  public void init(){

  }
  ```

- @PreDestroy销毁

  ```java
  @PreDestroy
  public void destory(){
      
  }
  ```

- 由于默认情况下，Bean的声明周期和ApplitiaonContext相同，所以使用AbstractorApplicationContext.registerShutdown()方法来销毁Bean。

- @Lay 使用延迟加载 

  ```java
  @Lazy(true)
  public class UserBiz implements IUserBiz {
      
  }
  ```

### 学员操作——使用注解实现IoC

- 需求说明： 改造JBOA的登录模块，使用注解完成Bean的定义和装配
- 完成时间：15分钟 

### 泛型依赖注入

Spring4.x中添加了一个叫泛型依赖注入的注入方式，非常方便，可以极大的简化我们一些基本的功能的编写。 

![image](http://www.znsd.com/1705-01/1705-OneGroup-diningRoot/uploads/689ab1d16a83eee6ad46b5b39c302b47/image.png)

### 使用注解实现事务处理 3-1

- 在Spring配置文件中配置事务管理类，并添加对注解配置的事务的支持

  ```xml
  <bean id="txManager"
  			class="org.springframework.orm.hibernate4.HibernateTransactionManager">
  	<property name="sessionFactory" ref="sessionFactory" />
  </bean>
  <tx:annotation-driven transaction-manager="txManager" />
  ```

- 使用@Transactional为方法添加事务支持 

  ```java
  public class EmployeeServiceImpl implements EmployeeService {
   	
  	@Transactional(readOnly=true)
  	public Employee login(Employee employee) throws Exception {
  		
  	}
  }
  ```

### 使用注解实现事务处理 3-2

| 属性          | 类型              | 说明                                       |
| ----------- | --------------- | ---------------------------------------- |
| propagation | 枚举型：Propagation | 可选的传播性设置。使用举例：   @Transactional(   propagation=Propagation.REQUIRES_NEW) |
| isolation   | 枚举型：Isolation   | 可选的隔离性级别。使用举例：   @Transactional(   isolation=Isolation.READ_COMMITTED) |
| readOnly    | 布尔型             | 是否为只读型事务。使用举例：@Transactional(readOnly=true) |
| timeout     | int型（以秒为单位）     | 事务超时。使用举例：Transactional(timeout=10)      |



### 使用注解实现事务处理 3-3 

| 属性                     | 类型                            | 说明                                       |
| ---------------------- | ----------------------------- | ---------------------------------------- |
| rollbackFor            | 一组 Class 类的实例，必须是Throwable的子类 | 一组异常类，遇到时 必须 回滚。使用举例：@Transactional(   rollbackFor={SQLException.class})，多个异常用逗号隔开 |
| rollbackForClassName   | 一组 Class 类的名字，必须是Throwable的子类 | 一组异常类名，遇到时 必须 回滚。使用举例：@Transactional(   rollbackForClassName={   "SQLException"})，多个异常用逗号隔开 |
| noRollbackFor          | 一组 Class 类的实例，必须是Throwable的子类 | 一组异常类，遇到时 必须不 回滚                         |
| noRollbackForClassName | 一组 Class 类的名字，必须是Throwable的子类 | 一组异常类名，遇到时 必须不 回滚                        |



### 学员操作——使用注解实现事务处理 

- 需求说明： 改造JBOA的添加报销单流程，使用注解实现声明式事务处理
- 完成时间：15分钟 