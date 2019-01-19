## 第四章 搭建SSH框架 

### 本章目标 

- 掌握Spring与Struts 2的集成`重点（难点）`
- 掌握Spring与Hibernate的集成`重点（难点）`

### SSH系统程序架构 

SSH架构 

- Struts 2 + Spring + Hibernate 
- 以Spring作为核心框架，数据持久化使用Hibernate完成，表现层使用Struts 2 
- Spring提供对象管理、面向切面编程等实用功能 
- 通过Spring提供的服务简化编码、降低开发难度、提高开发效率 

![image](http://www.znsd.com/znsd/courses/uploads/3ba3381f1fef460f1b2f18d7eb710ba4/image.png)

### 使用SSH架构开发登录功能 

**用户登录**

- 登录成功，保存当前用户到Session，根据角色跳转
- 登录失败，转发回登录页面，并提示错误信息

**用户注册**

- 注册成功，跳转到登录页面
- 注册失败，返回注册页面，并提示错误信息。

### 开发准备：添加所需的jar文件 

SSH整合体验最不好的就是添加jar包，由于三个框架所依赖的jar包非常多，其中有一些jar包可能冲突，我们应该将冲突的jar包，保留高级版本的，删掉低级版本的。 

![image](http://www.znsd.com/znsd/courses/uploads/e7fbb8906dd1852a53436a28a8ac2acf/image.png)

### Spring与Struts 2集成

**实现步骤**

- 添加struts2-spring-plugin-xxx.jar
- 按照名称匹配的原则定义业务Bean和Action中的setter方法
- 在struts.xml正常配置Action

**分析**

- Action实例如何创建？
- Spring创建的业务Bean如何注入给Action？

### 配置web.xml文件 

```xml
<!-- Struts2的配置 -->
<filter>
    <filter-name>struts2</filter-name>
    <filter-class>org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>struts2</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
<!-- Spring的配置 -->
<context-param>
    <param-name>contextConfigLocation</param-name>
    <!-- Spring配置文件的名称和路径存放位置，如果文件放置在/WEB-INF/目录下且名称为applicationContext.xml，可以不配置此项，多个文件使用“,”分割。 -->
    <param-value>classpath:spring.xml,classpath:springDao.xml</param-value>
</context-param>
<listener>
    <!-- spring 加载监听器  该监听器用于在web环境中启动Spring容器 -->
    <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
</listener>
```

### Spring整合Struts2自动装配

- Spring和Struts2整合的关键是如何让Spring来管理Struts2的Action。
- Spring的自动装配： 
  - 导入struts2-spring-plugin-2.3.24.jar包后，Struts2会将Action对象的管理交由Spring来管理。
  - Spring默认按照byname的方式进行自动装配，会自动查找Spring容器中是否有同名的bean。如果没有找到，就不执行注入。 
- 如何使用自动装配：设置\<bean>元素的autowire属性
  - autowire：自动装配类型(byName,byType)，默认为byName。
  - autowire-candidate：设值是否支持自动注入，（true,false），默认为true

### Struts 2和Spring集成的第二种方式 

spring.xml配置

```xml
<!-- 在Spring配置文件中配置Action Bean，注意scope="prototype"属性 -->
<bean id="userAction" class="com.znsd.ssh.action.UserAction" scope="prototype">
    <property name="userService" ref="userService"></property>
</bean>
```

struts.xml配置

```xml
<package name="default" namespace="/" extends="struts-default">
    <!-- 在Struts.xml中配置Action,class属性的值不再是Action类的全限定名，
  而是Spring配置文件中相应的Action Bean的名称-->
    <action name="login" class="userAction" method="login">
        <result>success.jsp</result>
        <result name="input">login.jsp</result>
    </action>
</package>
```

提示：

1. 采用此种配置方式时，Action的实例由Spring创建，Struts 2插件的工厂类只需根据Action Bean的id查找该组件使用即可
2. 此种方式可以为Action进行更灵活的配置，但代价是在Spring配置文件中需要定义很多Action Bean，增加了配置工作量，如非必需并非首选
3. 采用此种配置方式，同样需要添加struts2-spring-plugin-xxx.jar文件

### 添加编码格式过滤器 

Spring为了避免Struts2中的乱码问题，给我们提供了一个默认的编码过滤器。 

```xml
<!-- 开启编码过滤器 -->
<filter>
    <description>字符集过滤器</description>
    <filter-name>encodingFilter</filter-name>
    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
    <init-param>
        <description>字符集编码</description>
        <param-name>encoding</param-name>
        <param-value>UTF-8</param-value>
    </init-param>
</filter>
<filter-mapping>
    <filter-name>encodingFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

### 小结 

- Spring和Struts2进行整合。
- Spring开启Struts2编码过滤器。

### Spring整合Hibernate的优势 

- 通用的资源管理，直接管理Hibernate底层的DataSource，SessionFactory。
- 有效的Session管理。
- 声明式的事务管理。
- 异常包装。
- 工具类封装。

### Spring管理Hibernate配置文件 

- 在Spring中Hibernate的配置基本可以交由Spring来进行管理。
- 由于Spring的Dao层文件较为独立，所以推荐单独创建一个springdao.xml文件用来存放数据层的配置信息。

### SpringDao.xml文件

SpringDao中用到许多spring的特性，比如aop，tx，context等。所以需要导入schema头文件。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:aop="http://www.springframework.org/schema/aop"
    xmlns:p="http://www.springframework.org/schema/p"
    xmlns:tx="http://www.springframework.org/schema/tx"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-4.2.xsd
    http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.2.xsd
    http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop-4.2.xsd
    http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx-4.2.xsd">
</beans>
```

### c3p0连接池配置

- 一般项目中使用连接池进行数据库连接，这里我们选用c3p0连接池。首先添加c3p0的连接池信息。
- 首先需要导入c3p0连接池对应的驱动包。
- 当然也可以选用其他连接池信息，只需要修改对应的驱动类和参数即可。
- 连接池信息有两种配置方案：
  - 在springDao文件中配置。
  - 在hibernate.cfg.xml文件配置。

### Springdao.xml配置方案

- 在springDao文件中配置。 

```xml
<!-- 配置c3p0连接池属性 -->
<bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource" destroy-method="close">
	<property name="driverClass" value="com.mysql.jdbc.Driver" />
	<property name="jdbcUrl" value="jdbc:mysql://localhost:3306/test" />
	<property name="user" value="root" />
	<property name="password" value="root" />
	<!-- 队列中的最小连接数 -->
	<property name="minPoolSize" value="15"></property>
	<!-- 队列中的最大连接数 -->
	<property name="maxPoolSize" value="25"></property>
	<!-- 当连接耗尽时创建的连接数 -->
	<property name="acquireIncrement" value="15"></property>
	<!-- 等待时间 -->
	<property name="checkoutTimeout" value="10000"></property>
	<!-- 初始化连接数 -->
	<property name="initialPoolSize" value="20"></property>
	<!-- 最大空闲时间，超出时间连接将被丢弃 -->
	<property name="maxIdleTime" value="20"></property>
	<!-- 每隔60秒检测空闲连接 -->
	<property name="idleConnectionTestPeriod" value="60000"></property>
</bean>
```

### Hibernate连接池配置方案

- 在hibernate.cfg.xml文件配置

```xml
<session-factory>
    <!-- 数据库链接配置 -->
    <property name="hibernate.connection.driver_class">org.gjt.mm.mysql.Driver</property>
    <property name="hibernate.connection.password">root</property>
    <property name="hibernate.connection.url">jdbc:mysql://localhost:3306/test</property>
    <property name="hibernate.connection.username">root</property>
    <property name="hibernate.dialect">org.hibernate.dialect.MySQL5Dialect</property>
    <!-- c3p0连接池配置 -->
    <!-- 最大连接数 -->
    <property name="hibernate.c3p0.max_size">20</property>
    <!-- 最小连接数 -->
    <property name="hibernate.c3p0.min_size">5</property>
    <!-- 获得连接的超时时间,如果超过这个时间,会抛出异常，单位毫秒 -->
    <property name="hibernate.c3p0.timeout">120</property>
    <!-- 最大的PreparedStatement的数量 -->
    <property name="hibernate.c3p0.max_statements">100</property>
    <!-- 每隔120秒检查连接池里的空闲连接 ，单位是秒-->
    <property name="hibernate.c3p0.idle_test_period">120</property>
    <!-- 当连接池里面的连接用完的时候，C3P0一下获取的新的连接数 -->
    <property name="hibernate.c3p0.acquire_increment">2</property>
    <!-- 每次都验证连接是否可用 -->
    <property name="hibernate.c3p0.validate">true</property>
</session-factory>
```

### sessionFactory工厂配置

- Hibernate中的sessionFactory工厂，在Spring中可以交由Spring来进行维护和管理。 

```xml
<!-- session工厂由spring来管理 -->
<bean id="sessionFactory" class="org.springframework.orm.hibernate4.LocalSessionFactoryBean" >
    <!-- 数据源配置 -->
    <property name="dataSource" ref="dataSource"></property>
    <!-- 读取hibernate配置信息 -->
    <property name="configLocation" value="classpath:hibernate.cfg.xml" />
    <!-- 自动加载映射文件 *表示匹配该文件下的所有映射文件 -->
    <property name="mappingLocations">
        <list>
            <!-- Spring可以自动加载映射文件，这样非常方便。 -->
            <value>classpath:com/lxit/ssh/entities/mapper/*.hbm.xml</value>
        </list>
    </property>
</bean>
```

- hibernate.cfg.xml

```xml
<hibernate-configuration>
	<session-factory>
		<!-- 数据库方言 -->
		<property name="dialect">org.hibernate.dialect.MySQL5InnoDBDialect</property>
		<!-- 在控制台输出sql语句 -->
		<property name="show_sql">true</property>
		<!-- 格式化sql语句 -->
		<property name="format_sql">true</property>
         <!--整合spring时因为session交给spring管理了，所以不需要一下配置-->
		<!--<property name="hibernate.current_session_context_class">thread</property>-->
		<!-- 数据库生成策略 -->
		<property name="hibernate.hbm2ddl.auto">update</property>
	</session-factory>
</hibernate-configuration>
```

### 丢弃hibernate.cfg.xml配置文件的sessionFactory配置

```xml
<!-- session工厂由spring来管理 -->
<bean id="sessionFactory" class="org.springframework.orm.hibernate4.LocalSessionFactoryBean">
    <!-- 数据源配置 -->
    <property name="dataSource" ref="dataSource"></property>
    <!-- 自动加载映射文件 *表示匹配该文件下的所有映射文件 -->
    <property name="mappingLocations">
        <list>
            <!-- Spring可以自动加载映射文件，这样非常方便。 -->
            <value>classpath:com/znsd/ssh/bean/*.hbm.xml</value>
        </list>
    </property>
    <!--各种hibernate属性 -->
    <property name="hibernateProperties">
        <props>
            <!-- 方言 -->
            <prop key="hibernate.dialect">org.hibernate.dialect.MySQL5InnoDBDialect</prop>
            <prop key="hibernate.show_sql">true</prop>
            <prop key="hibernate.format_sql">true</prop>
            <prop key="hibernate.hbm2ddl.auto">update</prop>
            <prop key="hibernate.current_session_context_class">org.springframework.orm.hibernate4.SpringSessionContext</prop>
        </props>
    </property>
    <!-- 引入单个hibernate映射文件 -->
    <!-- <property name="mappingResources" value="com/znsd/ssh/bean/User.hbm.xml"></property> -->
</bean>
```

### dataSource配置文件的提取

- 添加jdbc.properties配置文件

  ```properties
  ## jdbc 连接配置
  jdbc.driver=com.mysql.jdbc.Driver
  jdbc.url=jdbc:mysql://192.168.41.10:3306/test
  jdbc.user=znsd_test
  jdbc.password=123456
  ## c3p0 数据源配置
  c3p0.minPoolSize=15
  c3p0.maxPoolSize=25
  c3p0.acquireIncrement=15
  c3p0.checkoutTimeout=10000
  c3p0.initialPoolSize=20
  c3p0.maxIdleTime=20
  c3p0.idleConnectionTestPeriod=60000
  ```

- spring加载配置文件

```xml
<!-- 通过context:property-placeholder加载配置文件 -->
<context:property-placeholder location="classpath:jdbc.properties"/>

<!-- 通过${}获取配置文件中的值 -->
<!-- 配置c3p0连接池属性 -->
<bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource" destroy-method="close">
    <property name="driverClass" value="${jdbc.driver}" />
    <property name="jdbcUrl" value="${jdbc.url}" />
    <property name="user" value="${jdbc.user}" />
    <property name="password" value="${jdbc.password}" />
    <!-- 队列中的最小连接数 -->
    <property name="minPoolSize" value="${c3p0.minPoolSize}"></property>
    <!-- 队列中的最大连接数 -->
    <property name="maxPoolSize" value="${c3p0.maxPoolSize}"></property>
    <!-- 当连接耗尽时创建的连接数 -->
    <property name="acquireIncrement" value="${c3p0.acquireIncrement}"></property>
    <!-- 等待时间 -->
    <property name="checkoutTimeout" value="${c3p0.checkoutTimeout}"></property>
    <!-- 初始化连接数 -->
    <property name="initialPoolSize" value="${c3p0.initialPoolSize}"></property>
    <!-- 最大空闲时间，超出时间连接将被丢弃 -->
    <property name="maxIdleTime" value="${c3p0.maxIdleTime}"></property>
    <!-- 每隔60秒检测空闲连接 -->
    <property name="idleConnectionTestPeriod" value="${c3p0.idleConnectionTestPeriod}"></property>
</bean>
```

### 配置事务 

- 在Hibernate中，如果实现增加、修改、删除必须使用事务处理。 

```xml
<!-- 声明式事务管理 -->
<bean id="txManager" class="org.springframework.orm.hibernate4.HibernateTransactionManager">
    <property name="sessionFactory" ref="sessionFactory"></property>
</bean>
<!-- 事务的通知方式 -->
<tx:advice id="txAdvice" transaction-manager="txManager">
    <!-- 事务规则，当切面中的方法满足规则时，所使用怎样的事务进行处理。-->
    <tx:attributes>
        <tx:method name="find*" propagation="REQUIRED" read-only="true" />
        <tx:method name="search*" propagation="REQUIRED" read-only="true" />
        <tx:method name="query*" propagation="REQUIRED" read-only="true" />

        <tx:method name="add*" propagation="REQUIRED" />
        <tx:method name="submit*" propagation="REQUIRED" />
        <tx:method name="save*" propagation="REQUIRED" />
        <tx:method name="insert*" propagation="REQUIRED" />

        <tx:method name="del*" propagation="REQUIRED" />
        <tx:method name="remove*" propagation="REQUIRED" />

        <tx:method name="update*" propagation="REQUIRED" />
        <tx:method name="modify*" propagation="REQUIRED" />

        <tx:method name="*" propagation="REQUIRED" read-only="true" />
    </tx:attributes>
</tx:advice>
```

### <tx：method>属性介绍 

- <tx:method />是Spring中事务通知类标签，这里用来定义Hibernate中的事务。
- 常用属性如下。 

| 属性         | 默认值   | 描述                                                         |
| ------------ | -------- | ------------------------------------------------------------ |
| name（必选） |          | 必选，与事务关联的方法名，通配符(*)可以用来指定一批关联到相同的事务属性的方法，如"add*"、"get*"、"select*"等。 |
| propagation  | REQUIRED | 事务传播行为                                                 |
| isolation    | DEFAULT  | 事务隔离级别                                                 |
| timeout      | -1       | 超时事件，单位为秒                                           |
| read-only    | false    | 是否只读                                                     |



### 事务传播行为 

- Spring事务传播行为有以下类型： 

| 事务传播行为类型          | 说明                                                         |
| ------------------------- | ------------------------------------------------------------ |
| PROPAGATION_REQUIRED      | 如果当前没有事务，就新建一个事务，如果已经存在一个事务中，加入到这个事务中。这是   最常见的选择。 |
| PROPAGATION_SUPPORTS      | 支持当前事务，如果当前没有事务，就以非事务方式执行。         |
| PROPAGATION_MANDATORY     | 使用当前的事务，如果当前没有事务，就抛出异常。               |
| PROPAGATION_REQUIRES_NEW  | 新建事务，如果当前存在事务，把当前事务挂起。                 |
| PROPAGATION_NOT_SUPPORTED | 以非事务方式执行操作，如果当前存在事务，就把当前事务挂起。   |
| PROPAGATION_NEVER         | 以非事务方式执行，如果当前存在事务，则抛出异常。             |
| PROPAGATION_NESTED        | 如果当前存在事务，则在嵌套事务内执行。如果当前没有事务，则执行与 PROPAGATION_REQUIRED 类似的操作。 |



### 事务隔离级别 

**数据库并发操作存在的异常情况：**

- 更新丢失
- 脏读取
- 不可重复读取
- 两次更新问题
- 幻读

**数据库隔离级别：**

- 未授权读
- 授权读取
- 可重复读
- 串行

###  Spring可以简化Hibernate编码 

- 使用HibernateTemplate来简化Hibernate编程 

```java
public void addEmployee(Employee employee) {
    Transaction tx = null;
    try {
        tx = HibernateUtil.getSession().beginTransaction();
        HibernateUtil.getSession().save(employee);
        tx.commit();
    } catch(RuntimeException re) {
        tx.rollback();
        throw re;
    } finally {
        HibernateUtil.closeSession();
    }
}
```

上面的流程化的代码仍显烦琐，可以改为一下代码，Spring的目标是使现有的Java EE技术更易用

```java
public void addEmployee(Employee employee) {
    this.getHibernateTemplate().save(employee);
}
```

### HibernateTemplate类 

- HibernateTemplate类似于前面我们定义的HibernateUtil工具类，只不过这个HibernateTemplate是基于Spring管理的，其实本身就是session的一个代理。功能更加强大。 
- 常用方法： 
  - get/load存取单条数据：

    ```java
    (Teacher)this.hibernateTemplate.get(Teacher.class, id);  
    ```

  - find/iterate查询操作：

    ```java
    (List)this.hibernateTemplate().find("from Teacher t where t.age>?", new Integer(age));  
    ```

  - save/update/saveOrUpdate/delete 保存/更新/删除操作

    ```java
    this.hibernateTemplate.save(teacher); 
    ```

### 使用HibernateDaoSupport基类 

**实现步骤**

- DAO类继承HibernateDaoSupport 
- 使用getHibernateTemplate()方法获取HibernateTemplate实例完成持久化操作

**问题**

- 如何将SessionFactory注入DAO ？
- 如何创建HibernateTemplate实例？

**分析**

- HibernateDaoSupport基类的setSessionFactory()方法 

### 实现数据层的方法 

- 使用Spring+Hibernate实现数据层的用户登录、用户注册、用户查询的方法。 
- public int login(User user);
- public String addUser(User user);
- public List\<User> getList();

### OpenSessionView模式

- Spring为我们解决Hibernate的Session的关闭与开启问题。 
- Hibernate 允许对关联对象、属性进行延迟加载，但是必须保证延迟加载的操作限于同一个 Hibernate Session 范围之内进行。如果 Service 层返回一个启用了延迟加载功能的领域对象给 Web 层，当 Web 层访问到那些需要延迟加载的数据时，由于加载领域对象的 Hibernate Session 已经关闭，这些导致延迟加载数据的访问异常

```xml
<!-- Spring开启Hibernate的OpenSessionView模式，一定要放在struts过滤器前面，否则不会生效 -->
<filter>
    <filter-name>OpenSessionInViewFilter</filter-name>
    <filter-class>org.springframework.orm.hibernate4.support.OpenSessionInViewFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>OpenSessionInViewFilter</filter-name>
    <url-pattern>*</url-pattern>
</filter-mapping>
```

### 其他配置 

- 防止内存泄漏 

  ```xml
  <!-- 防止spring内存溢出监听器 -->
  <listener>
  	<listener-class>org.springframework.web.util.IntrospectorCleanupListener</listener-class>
  </listener>
  ```

- 设置Session过期时间 

  ```xml
  <!-- 配置session超时时间，单位分钟 -->
  <session-config>
      <session-timeout>15</session-timeout>
  </session-config>
  ```

### Write operations are not allowed in read-only mode问题解决

错误原因：  这是因为Spring默认将一个名为"readOnly"的属性设置成为true，导致只能对数据库进行“读”操作，不允许进行“写”操作。 

解决： 可以使用hibernateTemplate来解决次问题，配置一个HibernateTemplate将检查读的操作属性(checkWriteOperations)设置为false

```xml
<bean id="hibernateTemplate" class="org.springframework.orm.hibernate4.HibernateTemplate">
    <property name="sessionFactory" ref="sessionFactory" />
    <property name="checkWriteOperations" value="false" />
</bean>
<bean id="userDao" class="com.znsd.ssh.dao.impl.UserDaoImpl">
    <property name="hibernateTemplate" ref="hibernateTemplate"></property>
</bean>
```

### 小结

  - 使用Spring整合Hibernate。
    - 数据库连接池
    - sessionFactory
    - HibernateTemplate
  - Spring中的事务管理
  - OpenSessionView模式
  - 防止内存泄漏
  - 设置session有效事件

### 分页处理

- 虽然HibernateTemplate帮我们集成了非常强大的功能，但是灵活性确降低了，比如要实现分页，因为没有提供setFirstResult()方法，所以无法进行分页，那么我们怎么做呢？ 
- Hibernate还支持一种回调机制。
- execute(hibernateCallback);

### 模板与回调机制

- 通过HibernateCallback实现分页功能 

```java
public List<Employee> find(final int page, final int size) {
    List result = getHibernateTemplate().execute(
        new HibernateCallback() {
            public Object doInHibernate(Session session)
                        throws HibernateException, SQLException {
                Query query = session.createQuery("from Employee");
                query.setFirstResult((page - 1) * size);
                query.setMaxResults(size);
                return query.list();
            }
        }
    );
    return result;
}
```

### 抽取BaseDao 

- 抽取常用功能接口BaseDao。

  ```java
  public interface BaseDao<T> {
  	
  	public void add(T t);
  
  	public void delete(Serializable id);
  
  	public void uodate(T t);
  
  	public T load(Serializable id);
  	
  	public T get(Serializable id);
  
  	public List<T> list();
  	
  	public List<T> list(String hql, Object[] args);
  }
  ```

- 提供实现类BaseDaoImpl实现BaseDao接口。

  ```java
  public class BaseDaoImpl<T> extends HibernateDaoSupport implements BaseDao<T> {
  
  	/**
  	 * 实体类类型(由构造方法自动赋值)
  	 */
  	private Class<?> entityClass = null;
  
  	/**
  	 * 构造方法，根据实例类自动获取实体类类型
  	 */
  	public BaseDaoImpl() {
  		entityClass = this.getSuperClassType(getClass());
  	}
  	
  	/**
  	 * 通过反射获取T的类型信息实例
  	 */
  	protected Class<?> getSuperClassType(Class<?> c) {
  		Type type = c.getGenericSuperclass();
  		if (type instanceof ParameterizedType) {
  			Type[] params = ((ParameterizedType) type).getActualTypeArguments();
  			if (!(params[0] instanceof Class)) {
  				return Object.class;
  			}
  			return (Class<?>) params[0];
  		}
  		return null;
  	}
  
  	@Override
  	public void add(T t) {
  		this.getHibernateTemplate().save(t);
  	}
  
  	@Override
  	public void delete(Serializable id) {
  		this.getHibernateTemplate().delete(this.load(id));
  	}
  
  	@Override
  	public void uodate(T t) {
  		this.getHibernateTemplate().update(t);
  	}
  
  	@Override
  	public T load(Serializable id) {
  		return (T) this.getHibernateTemplate().load(entityClass, id);
  	}
  
  	@Override
  	public List<T> list() {
  		return createCriteria().list();
  	}
  
  	@Override
  	public List<T> list(String hql, Object[] args) {
  		return (List<T>) this.getHibernateTemplate().find(hql, args);
  	}
  
  	@Override
  	public T get(Serializable id) {
  		return (T) this.getHibernateTemplate().get(entityClass, id);
  	}
  
  	/**
  	 * 创建与会话绑定的检索标准对象
  	 */
  	public Criteria createCriteria(Criterion... criterions) {
  		return this.createDetachedCriteria(criterions).getExecutableCriteria(this.currentSession());
  	}
  	
  	/**
  	 * 创建与会话无关的检索标准对象
  	 */
  	public DetachedCriteria createDetachedCriteria(Criterion... criterions) {
  		DetachedCriteria dc = DetachedCriteria.forClass(this.entityClass);
  		for (Criterion c : criterions) {
  			dc.add(c);
  		}
  		return dc;
  	}
  }
  ```
### 小结

- 使用Spring集成Hibernate的步骤是什么？
- 实现Spring和Hibernate集成中的分页。
- 抽取BaseDao类

### 总结 

- 实现Spring和Struts 2集成
- SSH框架整合的系统架构，Action、Service、Dao、SessionFactory
- 通过HibernateTemplate简化Hibernate DAO的编码
- 在Dao中使用HibernateCallback接口