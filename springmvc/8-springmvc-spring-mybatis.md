## 第八章     SSM集成 

### 本章目标 

- 搭建Spring + SpringMVC + MyBatis集成环境。 

### 搭建步骤 

**手动导入jar包**

- spring+springmvc的jar包
- mybatisjar包
- mybatis-spring-1.3.1.jar
- c3p0的jar包
- log4j的jar包
- jstl的jar包
- jacksonjar包
- 数据库的jar的包
- Common-fileupload

**Maven依赖**

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<groupId>com.znsd.ssm</groupId>
	<artifactId>ssm-web</artifactId>
	<packaging>war</packaging>
	<version>0.0.1-SNAPSHOT</version>
	<name>ssm-web Maven Webapp</name>
	<url>http://maven.apache.org</url>

	<distributionManagement>
		<snapshotRepository>
			<id>nexus-snapshots</id>
			<name>Snapshots</name>
			<url>http://192.168.41.16:8081/nexus/content/repositories/snapshots/</url>
		</snapshotRepository>
		<repository>
			<id>nexus-releases</id>
			<name>Releases</name>
			<url>http://192.168.41.16:8081/nexus/content/repositories/releases/</url>
		</repository>
	</distributionManagement>

	<!-- 依赖属性定义 -->
	<properties>
		<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
		<spring.version>4.2.3.RELEASE</spring.version>
		<javassist.version>3.11.0.GA</javassist.version>
		<aspectj.version>1.5.3</aspectj.version>
		<asm.version>3.2</asm.version>
		<cglib.version>2.2.2</cglib.version>
		<jackson.version>1.9.13</jackson.version>
		<mybatis.version>3.2.8</mybatis.version>
		<mybatis-spring.version>1.2.2</mybatis-spring.version>
		<mysql-jdbc.version>5.0.8</mysql-jdbc.version>
		<hessian.version>4.0.38</hessian.version>
		<druid.version>1.0.12</druid.version>
		<slf4j.version>1.6.1</slf4j.version>
		<logback.version>1.1.2</logback.version>
		<commons-codec.version>1.3</commons-codec.version>
	</properties>

	<dependencies>
		<dependency>
			<groupId>commons-codec</groupId>
			<artifactId>commons-codec</artifactId>
			<version>${commons-codec.version}</version>
		</dependency>

		<!-- spring begin -->
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-core</artifactId>
			<version>${spring.version}</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-aop</artifactId>
			<version>${spring.version}</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-beans</artifactId>
			<version>${spring.version}</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-aspects</artifactId>
			<version>${spring.version}</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-expression</artifactId>
			<version>${spring.version}</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-jdbc</artifactId>
			<version>${spring.version}</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-jms</artifactId>
			<version>${spring.version}</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-context</artifactId>
			<version>${spring.version}</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-context-support</artifactId>
			<version>${spring.version}</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-orm</artifactId>
			<version>${spring.version}</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-oxm</artifactId>
			<version>${spring.version}</version>
		</dependency>
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-tx</artifactId>
			<version>${spring.version}</version>
		</dependency>
		<!-- spring end -->

		<!-- javassist -->
		<dependency>
			<groupId>javassist</groupId>
			<artifactId>javassist</artifactId>
			<version>${javassist.version}</version>
		</dependency>

		<!-- aspectj -->
		<dependency>
			<groupId>aspectj</groupId>
			<artifactId>aspectjweaver</artifactId>
			<version>${aspectj.version}</version>
		</dependency>

		<!-- asm -->
		<dependency>
			<groupId>asm</groupId>
			<artifactId>asm</artifactId>
			<version>${asm.version}</version>
		</dependency>
		<dependency>
			<groupId>cglib</groupId>
			<artifactId>cglib</artifactId>
			<version>${cglib.version}</version>
		</dependency>

		<!-- json -->
		<dependency>
			<groupId>com.fasterxml.jackson.core</groupId>
			<artifactId>jackson-core</artifactId>
			<version>2.9.0</version>
		</dependency>
		<dependency>
			<groupId>com.fasterxml.jackson.core</groupId>
			<artifactId>jackson-annotations</artifactId>
			<version>2.9.0</version>
		</dependency>
		<dependency>
			<groupId>com.fasterxml.jackson.core</groupId>
			<artifactId>jackson-databind</artifactId>
			<version>2.9.0</version>
		</dependency>

		<!-- mybatis -->
		<dependency>
			<groupId>org.mybatis</groupId>
			<artifactId>mybatis</artifactId>
			<version>${mybatis.version}</version>
		</dependency>
		<dependency>
			<groupId>org.mybatis</groupId>
			<artifactId>mybatis-spring</artifactId>
			<version>${mybatis-spring.version}</version>
		</dependency>
		<dependency>
			<groupId>mysql</groupId>
			<artifactId>mysql-connector-java</artifactId>
			<version>${mysql-jdbc.version}</version>
		</dependency>

		<!-- spring mvc -->
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-webmvc</artifactId>
			<version>${spring.version}</version>
		</dependency>

		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-web</artifactId>
			<version>${spring.version}</version>
		</dependency>

		<!-- jsp servlet -->
		<dependency>
			<groupId>javax.servlet</groupId>
			<artifactId>servlet-api</artifactId>
			<version>2.5</version>
			<scope>provided</scope>
		</dependency>
		<dependency>
			<groupId>javax.servlet.jsp</groupId>
			<artifactId>jsp-api</artifactId>
			<version>2.1</version>
			<scope>provided</scope>
		</dependency>
		<dependency>
			<groupId>jsptags</groupId>
			<artifactId>pager-taglib</artifactId>
			<version>2.0</version>
		</dependency>
		<dependency>
			<groupId>jstl</groupId>
			<artifactId>jstl</artifactId>
			<version>1.2</version>
		</dependency>
		<dependency>
			<groupId>taglibs</groupId>
			<artifactId>standard</artifactId>
			<version>1.1.2</version>
		</dependency>

		<!-- junit -->
		<dependency>
			<groupId>junit</groupId>
			<artifactId>junit</artifactId>
			<version>4.11</version>
			<scope>test</scope>
		</dependency>

		<!-- alibaba 数据源 -->
		<dependency>
			<groupId>com.alibaba</groupId>
			<artifactId>druid</artifactId>
			<version>${druid.version}</version>
		</dependency>

		<!-- log -->
		<dependency>
			<groupId>org.slf4j</groupId>
			<artifactId>slf4j-api</artifactId>
			<version>${slf4j.version}</version>
		</dependency>
		<dependency>
			<groupId>org.slf4j</groupId>
			<artifactId>jcl-over-slf4j</artifactId>
			<version>${slf4j.version}</version>
		</dependency>
		<dependency>
			<groupId>ch.qos.logback</groupId>
			<artifactId>logback-classic</artifactId>
			<version>${logback.version}</version>
		</dependency>
		<dependency>
			<groupId>ch.qos.logback</groupId>
			<artifactId>logback-core</artifactId>
			<version>${logback.version}</version>
		</dependency>
        <dependency>
			<groupId>commons-fileupload</groupId>
			<artifactId>commons-fileupload</artifactId>
			<version>1.3.3</version>
		</dependency>
        <dependency>
			<groupId>commons-io</groupId>
			<artifactId>commons-io</artifactId>
			<version>2.3</version>
		</dependency>
	</dependencies>
	
	<build>
		<finalName>ssm-web</finalName>

		<plugins>
			<!-- 编译插件，默认使用jdk1.8 -->
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-compiler-plugin</artifactId>
				<version>2.3.2</version>
				<configuration>
					<source>1.8</source>
					<target>1.8</target>
					<encoding>UTF-8</encoding>
				</configuration>
			</plugin>
			<!-- 使用utf-8编码处理资源文件 -->
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-resources-plugin</artifactId>
				<version>2.4.3</version>
				<configuration>
					<encoding>UTF-8</encoding>
				</configuration>
			</plugin>
		</plugins>
	</build>
</project>
```

### 添加log4j配置文件

- 由于MyBatis依赖与log4j输出sql语句信息，所以需要配置log4j配置文件。 

  ```properties
  #设置输出级别和输出位置
  log4j.rootLogger=debug,Console
  #设置控制台相关的参数
  log4j.appender.Console=org.apache.log4j.ConsoleAppender  
  log4j.appender.Console.layout=org.apache.log4j.PatternLayout  
  log4j.appender.Console.layout.ConversionPattern=%d [%t] %-5p [%c] - %m%n  
  #设置MyBatis的输出内容
  log4j.logger.java.sql.ResultSet=INFO  
  log4j.logger.org.apache=INFO  
  log4j.logger.java.sql.Connection=DEBUG  
  log4j.logger.java.sql.Statement=DEBUG  
  log4j.logger.java.sql.PreparedStatement=DEBUG
  ```

### 配置web.xml 

- 添加SpringMVC核心控制器DispatcheerServlet配置信息

  ```xml
  <!-- 配置SpringMVC的处理请求的Servlet -->
  <servlet>
      <servlet-name>dispatcherServlet</servlet-name>
      <servlet-class>
          org.springframework.web.servlet.DispatcherServlet
      </servlet-class>
      <init-param>
          <param-name>contextConfigLocation</param-name>
          <param-value>classpath:springmvc.xml</param-value>
      </init-param>
      <!-- 表示系统启动时自动加载这个servlet -->
      <load-on-startup>1</load-on-startup>
  </servlet>
  <servlet-mapping>
      <servlet-name>dispatcherServlet</servlet-name>
      <url-pattern>/</url-pattern>
  </servlet-mapping>
  ```

### 添加编码过滤器 

- 添加乱码过滤器，避免提交时出现乱码。

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

### 添加put和delete请求 

- 支持put和delete请求

  ```xml
  <!-- 设置是否支持put和delete请求 -->
  <filter>
      <filter-name>HiddenHttpMethodFilter</filter-name>
      <filter-class>org.springframework.web.filter.HiddenHttpMethodFilter</filter-class>
  </filter>
  <filter-mapping>
      <filter-name>HiddenHttpMethodFilter</filter-name>
      <url-pattern>/*</url-pattern>
  </filter-mapping>
  ```

### 配置springmvc.xml 

- 添加springmvc的配置文件，设置自动扫描包路径，静态资源处理，视图解析器等。 

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
  	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:context="http://www.springframework.org/schema/context"
  	xmlns:mvc="http://www.springframework.org/schema/mvc"
  	xmlns:tx="http://www.springframework.org/schema/tx"
  	xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
          http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.2.xsd
          http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc-4.2.xsd
          http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx-4.2.xsd">
      
  <!-- 自动扫描基包，将类加载到Spring容器中 -->
  <context:component-scan base-package="com.znsd.ssm" />
  
  <!-- 视图解析器：将逻辑视图转发到对应的物理视图 -->
  <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
      <property name="prefix" value="/WEB-INF/views/" />
      <property name="suffix" value=".jsp" />
  </bean>
  
  <!-- 将静态资源交由tomcat来处理 -->
  <mvc:default-servlet-handler />
  
  <!-- 注册类型转换器 -->
  <mvc:annotation-driven />
  ```

### 配置文件上传

- 配置文件上传组件。 

  ```xml
  <!-- 配置文件上传组件 -->
  <bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
      <!-- 指定默认的编码格式 -->
      <property name="defaultEncoding" value="UTF-8" />
      <!-- 指定允许上传的文件大小，单位Byte -->
      <property name="maxUploadSize" value="512000" />
  </bean>
  ```

### 配置druid连接池信息

- 配置c3p0连接池信息 

  ```xml
  <!-- 加载properties配置文件 -->
  <context:property-placeholder location="classpath:jdbc.properties" />
  
  <!-- druid数据源 -->
  <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource"
        init-method="init" destroy-method="close">
      <!-- 基本属性 url、user、password -->
      <property name="driverClassName" value="${jdbc.driver}" />
      <property name="url"
                value="jdbc:mysql://${jdbc.host}:${jdbc.port}/${jdbc.dbname}?characterEncoding=UTF-8&amp;zeroDateTimeBehavior=convertToNull&amp;noAccessToProcedureBodies=true" />
      <property name="username" value="${jdbc.user}" />
      <property name="password" value="${jdbc.password}" />
      <!-- 配置初始化大小、最小、最大 -->
      <property name="initialSize" value="1" />
      <property name="minIdle" value="1" />
      <property name="maxActive" value="20" />
      <!-- 配置获取连接等待超时的时间 -->
      <property name="maxWait" value="60000" />
      <!-- 配置间隔多久才进行一次检测，检测需要关闭的空闲连接，单位是毫秒 -->
      <property name="timeBetweenEvictionRunsMillis" value="${jdbc.pool.timeBetweenEvictionRunsMillis}" />
      <!-- 配置一个连接在池中最小生存的时间，单位是毫秒 -->
      <property name="minEvictableIdleTimeMillis" value="${jdbc.pool.minEvictableIdleTimeMillis}" />
      <property name="validationQuery" value="SELECT 'x'" />
      <property name="testWhileIdle" value="true" />
      <property name="testOnBorrow" value="false" />
      <property name="testOnReturn" value="false" />
      <!--如果是Oracle的话需要配置一下参数 -->
      <!-- 打开PSCache，并且指定每个连接上PSCache的大小 -->
      <!--<property name="poolPreparedStatements" value="true" /> -->
      <!--<property name="maxPoolPreparedStatementPerConnectionSize" value="20" 
     /> -->
      <!-- 配置监控统计拦截的filters -->
      <property name="filters" value="stat" />
  </bean>
  ```

- jdbc.properties文件

  ```properties
  ##jdbc\u914D\u7F6E##
  jdbc.driver=com.mysql.jdbc.Driver
  jdbc.dbname=test
  jdbc.port=3306
  jdbc.host=192.168.41.10
  jdbc.user=znsd_test
  jdbc.password=123456
  jdbc.pool.minPoolSize=5
  jdbc.pool.maxPoolSize=30
  jdbc.pool.initialPoolSize=5
  jdbc.pool.maxIdleTime=60
  jdbc.pool.timeBetweenEvictionRunsMillis=60000
  jdbc.pool.minEvictableIdleTimeMillis=300000
  ```

### 配置sqlSessionFactory 

- MyBatis中使用sqlSessionFactory来生产session对象，和Hibernate中相似，也可以交由spring来管理。 

- 设置扫描的映射文件和dao包 

  ```xml
  <!-- mybatis session 工厂 -->
  <bean id="sessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
      <property name="dataSource" ref="dataSource" />
      <property name="mapperLocations">
          <list>
              <value>classpath*:/mybatis-mapping/*.xml</value>
          </list>
      </property>
      <!-- 指定mybatis的配置文件(可有可无) -->
    	<property name="configLocation" value="classpath:mybatis.xml"></property>
  </bean>
  <!-- mybatis接口 -->
  <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
      <!-- mybatis 接口包（如果有多个可以用,逗号隔开） -->
      <property name="basePackage" value="com.znsd.ssm" />
      <property name="sqlSessionFactoryBeanName" value="sessionFactory" />
      <property name="annotationClass" value="org.springframework.stereotype.Repository" />
  </bean>
  ```

### Mybatis映射文件 

- 在SSM中，可以省略mybatis配置文件，也可以添加，只不过需要在sqlSessionFactory中配置configLocation属性即可。

  ```xml
  <?xml version="1.0" encoding="UTF-8" ?>
  <!DOCTYPE configuration
    PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-config.dtd">
  <configuration>
  	<!-- 取别名，这个必须按照一定的顺序配置 -->
  	<typeAliases>
  		<!-- 将这个包下面的所有的类全部倒入进来，明明规则就是类名首字母小写 -->
  		<package name="com.lxit.ssm.entities"/>
  		<!-- 指定单独一个类的别名 -->
  		<!-- <typeAlias type="com.lxit.ssm.entities.Student" alias="stu"/> -->
  	</typeAliases>
  </configuration>
  ```

### 配置事务 

- 在Spring里面，可以通过AOP来管理事务，非常强大。

  ```xml
  <!-- 定义事务管理器（声明式的事务） -->
  <bean id="txManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
      <property name="dataSource" ref="dataSource" />
  </bean>
  
  <!-- 事务的通知方式 -->
  <tx:advice id="txAdvice" transaction-manager="txManager">
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

### 实现查询学生列表信息 

- 使用SSM来查询学生列表信息
- 获取学生列表的json格式数据

![image](http://www.znsd.com/znsd/courses/uploads/56373c802bee9f584535d7c0c9274325/image.png)

### 添加实体类 

- 学生实体类 

  ```java
  public class Student implements Serializable {
  
  	private Integer id;
  	private String name;
  	private String password;
  	private String gender;
  	private String address;
  	private Clazz clazz;
  
  	// 省略getter和setter方法
  }
  ```

### 映射文件 

- StudentDao接口 

  ```java
  @Repository
  public interface StudentDao {
  	public List<Student> selectList();
  }
  ```

- 映射文件StudentMapper.xml 

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
  <mapper namespace="com.znsd.ssm.dao.StudentDao">
  
  	<resultMap id="BaseResultMap" type="com.znsd.ssm.bean.Student">
  		<id column="id" property="id" jdbcType="INTEGER" />
  		<result column="name" property="name" jdbcType="VARCHAR" />
  		<result column="password" property="password" jdbcType="VARCHAR" />
  		<result column="gender" property="gender" jdbcType="VARCHAR" />
  		<result column="c_id" property="clazz.classId" jdbcType="INTEGER" />
  	</resultMap>
  	
  	<select id="selectList" resultMap="BaseResultMap">
  		select * from t_student
  	</select>
  
  </mapper>
  ```

### Service层 

- StudentService代码

  ```java
  public interface StudentService {
  	public List<Student> selectList();
  }
  ```

- StudentService实现类

  ```java
  @Service
  public class StudentServiceImpl implements StudentService {
  
  	@Resource
  	private StudentDao studentDao;
  	
  	@Override
  	public List<Student> selectList() {
  		return this.studentDao.selectList();
  	}
  }
  ```

### Controller层 

- 由控制器层将数据返回对应的视图，输出json格式的数据。 

  ```java
  @Controller
  @RequestMapping("student")
  public class StudentController {
  
  	@Autowired
  	private StudentService service;
  
  	@RequestMapping("/list")
  	public String getStudentList(Map<String, Object> map) {
  		List<Student> studentList = service.selectList();
  		map.put("studentList", studentList);
  		return "studentList";
  	}
  
  	@ResponseBody
  	@RequestMapping("/json")
  	public List<Student> getlistJson() {
  		List<Student> list = service.selectList();
  		return list;
  	}
  }
  ```

### View视图层 

- 显示学生列表 

  ```html
  <table width="500" border="1">
      <tr>
          <td>id</td>
          <td>name</td>
          <td>pass</td>
          <td>sex</td>
      </tr>
      <c:forEach items="${studentList}" var="stu">
          <tr>
              <td>${stu.id}</td>
              <td>${stu.name}</td>
              <td>${stu.password}</td>
              <td>${stu.gender}</td>
          </tr>
      </c:forEach>
  </table>
  ```

### 练习：实现学生信息列表

- 实现学生信息查询，并返回json格式

  ![image](http://www.znsd.com/znsd/courses/uploads/24dba4ed2f445ae2cbaa7715d7d1e70f/image.png)![image](http://www.znsd.com/znsd/courses/uploads/41017b508e20e4457963255e9a9b9e2e/image.png)

### 总结 

- SSM整合