## 第一章  MyBatis入门

### 本章任务

- 搭建MyBatis环境
- 实现对单表的增删改操作
- 实现映射查询

### 本章目标

- 理解核心类的作用域和生命周期
- 掌握SQL映射文件的编写
- 掌握单表的增删改

### ORM框架

几种常用的数据库的存取技术。

- JDBC：Java原生的数据库操作API，需要编写大量底层代码。
- Hibernate：对JDBC进行的包装，使用HQL代替SQL语句，可以根据方言生成多种数据库语言，功能非常强大。
- MyBatis：也是一种非常流行的ORM框架，它是介于JDBC和Hibernate之间的一种轻量级ORM框架。有着运行效率高，学习成本低，代码可重用性强等特点。

### MyBatis介绍![image](http://www.znsd.com/znsd/courses/uploads/e0c47ec0da8e82456c0bc875fce370b7/image.png)

- MyBatis本是[apache](http://baike.baidu.com/view/28283.htm)的一个开源项目[iBatis](http://baike.baidu.com/view/628102.htm), 2010年这个项目由apache software foundation 迁移到了google
  code，并且改名为MyBatis。2013年11月迁移到Github。
- MyBatis是支持定制化 SQL、存储过程以及高级映射的优秀的持久层框架。MyBatis避免了几乎所有的 JDBC 代码和手动设置参数以及获取结果集。MyBatis可以对配置和原生Map使用简单的XML 或注解，将接口和 Java 的POJOs(Plain Old Java Objects,普通的 Java对象)映射成数据库中的记录。
- MyBatis参考资料官网：[http](http://www.mybatis.org/mybatis-3/zh/index.html)[://www.mybatis.org/mybatis-3/zh/index.html](http://www.mybatis.org/mybatis-3/zh/index.html)

![20180109082033](http://www.znsd.com/znsd/courses/uploads/d4d85b5f5868a01aa2d8b2a82cc4bc50/20180109082033.png)

### MyBatis的优势

- 开源的优秀的持久层框架
- SQL语句与代码分离
- 面向配置的编程
- 良好支持复杂数据映射动态SQL

### MyBatis开发步骤

使用MyBatis的开发步骤：

- 添加需要的jar包
- 编写配置文件
- 创建实体类和数据库接口
- 创建Sql映射文件
- 创建数据库接口的实现类
- 编写测试代码

### MyBatis jar包

- 下载mybatis3.4.5版本

- mybatis-3.4.5.jar：核心jar包

  ![20180109082304](http://www.znsd.com/znsd/courses/uploads/888e03e8a0803fb8e24f780722bd21e6/20180109082304.png)

- lib中是MyBatis所有依赖的jar包。

  ![20180109082413](http://www.znsd.com/znsd/courses/uploads/7521dc2d47dc9e621d5f2363d0fd2afc/20180109082413.png)

### 演示数据库

- 新建MySql数据库school

- 新建学生表Student

  ```sql
  CREATE TABLE `student` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(20) DEFAULT NULL,
    `pass` varchar(20) DEFAULT NULL,
    `sex` varchar(2) DEFAULT NULL,
    `address` varchar(100) DEFAULT NULL,
    PRIMARY KEY (`id`)
  )
  ```

  ```sql
  insert  into `student`(`id`,`name`,`pass`,`sex`,`address`) values 
  (1,'杨过','123123','男','深圳福田'),
  (2,'小龙女','123123','女','深圳宝安'),
  (3,'郭靖','123123','男','深圳罗湖'),
  (4,'黄蓉','123123','女','深圳宝安');
  ```

### MyBatis简单示例 

1. 添加核心配置文件mybatis-config.xml

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN" 
   "http://mybatis.org/dtd/mybatis-3-config.dtd">
   <configuration>
   	<environments default="development">
   		<environment id="development">
   			<!-- 使用事务 -->
   			<transactionManager type="JDBC" />
   			<!-- 数据源配置 -->
   			<dataSource type="POOLED">
   				<property name="driver" value="com.mysql.jdbc.Driver" />
   				<property name="url" value="jdbc:mysql://localhost:3306/school" />
   				<property name="username" value="root" />
   				<property name="password" value="root" />
   			</dataSource>
   		</environment>
   	</environments>
   	<!-- 载入映射文件 -->
   	<mappers>
   		<mapper resource="com/znsd/mybatis/entity/StudentMapper.xml" />
   	</mappers>
   </configuration>
   ```

   ​

2. 编写实体类和实体类映射文件

   ```java
   public class Student implements Serializable {

   	private static final long serialVersionUID = 7878728635426714364L;

   	private Integer id;
   	private String name;
   	private String pass;
   	private String sex;
   	private String address;

   	public Integer getId() {
   		return id;
   	}

   	public void setId(Integer id) {
   		this.id = id;
   	}

   	public String getName() {
   		return name;
   	}

   	public void setName(String name) {
   		this.name = name;
   	}

   	public String getPass() {
   		return pass;
   	}

   	public void setPass(String pass) {
   		this.pass = pass;
   	}

   	public String getSex() {
   		return sex;
   	}

   	public void setSex(String sex) {
   		this.sex = sex;
   	}

   	public String getAddress() {
   		return address;
   	}

   	public void setAddress(String address) {
   		this.address = address;
   	}
   }
   ```

   ```xml
   <?xml version="1.0" encoding="UTF-8" ?>
   <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
   "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
   <mapper namespace="StudentMapper">

   	<select id="selectStudentAll" resultType="com.znsd.mybatis.entity.Student">
   		select * from student
   	</select>

   </mapper>
   ```

3. 添加测试类

   ```java
   public class StudentTest {

   	private SqlSessionFactory sqlSessionFactory;
   	
   	@Before
   	public void init() throws IOException {
   		InputStream inStream = Resources.getResourceAsStream("mybatis-config.xml");
   		sqlSessionFactory = new SqlSessionFactoryBuilder().build(inStream); 
   	}
   	
   	@Test
   	public void testStudentList() {
   		SqlSession sqlSession = sqlSessionFactory.openSession();
   		List<Student> studentList = sqlSession.selectList("StudentMapper.selectStudentAll");
   		for (Student student : studentList) {
   			System.out.println(student);
   		}
   	}
   }
   ```

### 添加日志输出

- 由于MyBatis日志依赖log4j，所以我们还需要添加log4j配置文件。

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

### 学员操作-查询用户信息

- 需求说明：使用MyBatis实现查询所有学生信息，要求按用户编号查询指定的用户记录。
- 使用selectList()方式实现。
- 完成时间：15分钟

### 小结

- MyBatis的优缺点有哪些？
- MyBatisSQL映射文件和Hibernate映射文件有什么不同？
- resultType的作用是什么？

### MyBatis的配置文件

- 通过前面简单的MyBatis案例，大家应该了解到了MyBatis框架的基本结构，和Hibernate一样，MyBatis包含了一个核心配置文件和映射文件。
  - 核心配置文件(conf.xml)：包含了对Mybatis的核心配置，包含连接池信息，事务，加载映射文件，参数设置等配置。
  - 映射文件(StudentMapper.xml）：主要实现实体对象对数据库的映射，关联关系，Sql语句等。

### 核心配置文件

- 核心配置文件中常见的配置标签

| 标签                | 说明                                 |
| ----------------- | ---------------------------------- |
| \<environments /> | 配置环境                               |
| \<properties />   | 一些外部属性，这些属性可以被替换                   |
| \<settings />     | Mybatis中极为重要的调整设置，会改变Mybatis的默认行为。 |
| \<typeAliases  /> | 为Java类型设置一个别名，它只和xml配置有关。          |
| \<mappers  />     | 映射器，加载MyBatis的映射文件。                |
| \<plugins />      | 插件，Mybatis允许用户在映射的某一点进行拦截。         |

#### 环境配置

- Mybatis可以通过\<environments/>配置多种环境，比如开发环境、测试环境和生产环境等。
- 不过要记住，尽管可以配置多个环境，但是SqlSessionFactory对象只能加载一个。如果你需要同时连接多个数据库，需要创建多个SqlSessionFactory实例。

```xml
	<!-- 设置默认的环境id，必须是下面配置的id -->
	<environments default="development">
		<environment id="development">
			<!-- 设置事务管理器 -->
			<transactionManager type="JDBC" />
			<!-- 数据源配置 -->
			<dataSource type="POOLED">
				<property name="driver" value="com.mysql.jdbc.Driver" />
				<property name="url" value="jdbc:mysql://localhost:3306/school" />
				<property name="username" value="root" />
				<property name="password" value="root" />
			</dataSource>
		</environment>
	</environments>
```

#### SqlSessionFactory加载环境

- 创建SqlSessionFactory时，可以指定环境名称。

  ```java
  SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(reader, environment);
  ```

- 当然，如果不指定，会加载\<environments />标签的default属性设置的环境配置。

  ```java
  SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(reader);
  ```

#### 事务管理

- 在 MyBatis\<transactionManager/>来进行事务的设置，其中有两种类型的事务管理器。

  1. JDBC：这个配置就是直接使用了 JDBC 的提交和回滚设置，它依赖于从数据源得到的连接来管理事务范围。

  2. MANAGED：这个配置几乎没做什么。它从来不提交或回滚一个连接，而是让容器来管理事务的整个生命周期（比如JEE 应用服务器的上下文）。 默认情况下它会关闭连接，然而一些容器并不希望这样，因此需要将closeConnection 属性设置为 false来阻止它默认的关闭行为。

     ```xml
     <transactionManager type="MANAGED">
         <property name="closeConnection" value="false"/>
     </transactionManager>
     ```

  `如果你正在使用 SpringMyBatis，则没有必要配置事务管理器， 因为 Spring 模块会使用自带的管理器来覆盖前面的配置。`

#### 数据源

- \<dataSource/>使用标准的 JDBC 数据源接口来配置JDBC 连接对象的资源。有三种数据源类型
  1. UNPOOLED：这个数据源的实现只是每次被请求时打开和关闭连接。
  2. POOLED：这种数据源的实现利用“池”的概念将JDBC 连接对象组织起来， 避免了创建新的连接实例时所必需的初始化和认证时间。
  3. JNDI：使用JNDI在外部配置数据源。

#### POOLED连接池属性

| 属性名                           | 说明                                       |
| ----------------------------- | ---------------------------------------- |
| poolMaximumActiveConnections  | 在任意时间可以存在的活动（也就是正在使用）连接数量，默认值：10         |
| poolMaximumIdleConnections    | 任意时间可能存在的空闲连接数。                          |
| poolMaximumCheckoutTime       | 在被强制返回之前，池中连接被检出（checked out）时间，默认值：20000 毫秒（即 20 秒） |
| poolTimeToWait                | 如果获取连接花费的相当长的时间，它会给连接池打印状态日志并重新尝试获取一个连接（避免在误配置的情况下一直安静的失败），默认值：20000 毫秒（即 20 秒）。 |
| poolPingQuery                 | 发送到数据库的侦测查询，用来检验连接是否处在正常工作秩序中并准备接受请求。默  认是"NO PING QUERY SET"，这会导致多数数据库驱动失败时带有一个恰当的错误消息。 |
| poolPingEnabled               | 是否启用侦测查询。若开启，也必须使用一个可执行的 SQL 语句设置poolPingQue  ry 属性（最好是一个非常快的 SQL），默认值：false。 |
| poolPingConnectionsNotUsedFor | 配置 poolPingQuery 的使用频度。这可以被设置成匹配具体的数据  库连接超时时间，来避免不必要的侦测，默认值：0 |

#### properties

- properties为外部属性，比如数据库连接信息可以配置到一个单独的properties文件中，然后在xml中进行引入。

- 添加一个db.properties文件

  ```properties
  driver=com.mysql.jdbc.Driver
  url=jdbc:mysql://localhost:3306/test
  username=root
  password=root
  ```

  ```xml
  <properties resource="jdbc.properties"></properties>
  <dataSource type="POOLED">
      <property name="driver" value="${driver}" />
      <property name="url" value="${url}" />
      <property name="username" value="${username}" />
      <property name="password" value="${password}" />
  </dataSource>
  ```

#### Setting配置

- setting是指定MyBatis的一些全局配置属性，这是MyBatis中极为重要的调整设置，它们会改变MyBatis的运行时行为，所以我们需要清楚的知道这些属性的作用及默认值

| 属性名                                      | 说明                                       |
| ---------------------------------------- | ---------------------------------------- |
| cacheEnabled:true/false                  | 该配置影响的所有映射器中配置的缓存的全局开关                   |
| lazyLoadingEnabled:true/false            | 延迟加载的全局开关。当开启时，所有关联对象都会延迟加载。  特定关联关系中可通过设置fetchType属性来覆盖该项的开关状态 |
| aggressiveLazyLoading:true/false         | 当启用时，对任意延迟属性的调用会使带有延迟加载属性的对象完整加载；反之，每种属性将会按需加载。 |
| multipleResultSetsEnabled:true/false     | 是否允许单一语句返回多结果集（需要兼容驱动）                   |
| useColumnLabel:true/false                | 使用列标签代替列名。不同的驱动在这方面会有不同的表现，  具体可参考相关驱动文档或通过测试这两种不同的模式来观察所用驱动的结果 |
| useGeneratedKeys:true/false              | 允许 JDBC 支持自动生成主键，需要驱动兼容。 如果设置为 true  则这个设置强制使用自动生成主键 |
| autoMappingBehavior:NONE,  PARTIAL, FULL | 指定 MyBatis  应如何自动映射列到字段或属性。 NONE  表示取消自动映射；PARTIAL 只会自动映射没有定义嵌套结果集映射的结果集。  FULL 会自动映射任意复杂的结果集（无论是否嵌套） |
| defaultStatementTimeout                  | 设置超时时间，它决定驱动等待数据库响应的秒数                   |
| logImpl:LOG4J/NO_LOGGING                 | 指定 MyBatis 所用日志的具体实现，未指定时将自动查找           |
| proxyFactory:CGLIB  \| JAVASSIST         | 指定 Mybatis 创建具有延迟加载能力的对象所用到的代理工具         |



#### 映射器

- 通常MyBatis中将映射关系（非必须）和SQL语句写入到映射文件中，在配置文件中需要手动进行加载映射文件。
- 加载映射文件使用\<mappers/>进行加载。Mybatis中有4种加载方式。
  1. 使用resource，加载classpath路径进行加载。
  2. 使用url路径进行加载。
  3. 使用class进行加载，注解方式。
  4. 使用package进行加载，注解方式。

#### 加载映射文件XML方式

- resource方式

  ```xml
  <!-- 使用resource方式加载映射文件-->
  <mappers>
      <mapper resource="org/mybatis/builder/AuthorMapper.xml"/>
      <mapper resource="org/mybatis/builder/BlogMapper.xml"/>
      <mapper resource="org/mybatis/builder/PostMapper.xml"/>
  </mappers>
  ```

- url方式

  ```xml
  <!-- 使用url方式进行加载-->
  <mappers>
      <mapper url="file:///var/mappers/AuthorMapper.xml"/>
      <mapper url="file:///var/mappers/BlogMapper.xml"/>
      <mapper url="file:///var/mappers/PostMapper.xml"/>
  </mappers>
  ```

- class方式

  ```xml
  <!-- 加载class类-->
  <mappers>
      <mapper class="org.mybatis.builder.AuthorMapper"/>
      <mapper class="org.mybatis.builder.BlogMapper"/>
      <mapper class="org.mybatis.builder.PostMapper"/>
  </mappers>

  ```

- url方式

  ```xml
  <!-- 加载某个包下的所有class文件-->
  <mappers>
      <package name="org.mybatis.builder"/>
  </mappers>
  ```

  ​

### 别名的使用

- 之前，我们在sql映射xml文件中的引用实体类时，需要写上实体类的全类名(包名+类名)，如下：

  ```xml
  <select id="selectStudentAll" resultType="com.znsd.mybatis.entity.Student">
  	select * from student
  </select>
  ```

- 在mybatis-config.xml文件中\<configuration>\</configuration>标签中添加如下配置：

  ```xml
  <!-- 必须按照标签的顺序进行配置，放在environments节点上面 -->
  <typeAliases>
  	<typeAlias type="com.znsd.mybatis.entity.Student" alias="Student"/>
  </typeAliases>
  ```

- 这样在resultType中就可以直接使用Student类型了。

  ```xml
  <select id="selectStudentAll" resultType="Student">
  		select * from student
  </select>
  ```

- \<typeAliases/>也可以引入某个包，这样使用该包下所有的类时就不需要添加前缀了

  ```xml
  <typeAliases>
      <!--也可以引入某个包，这样使用该包下所有的类时就不需要添加前缀了-->
      <package name="com.znsd.mybatis.entity" />
  </typeAliases>
  ```

### 小结

MyBatis常用属性的配置

- 环境配置
- 数据源配置
- 映射文件加载方式

### 总结

- MyBatis环境搭建。
- 使用MyBatis开发的步骤。
- MyBatis配置文件。

