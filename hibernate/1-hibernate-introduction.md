## 第一章  Hibernate入门

### 回顾

- 什么是JDBC？
- 请写出使用JDBC的操作步骤

### 本章任务

- 搭建Hibernate环境
- 掌握Hibernate的常用接口和对象
- 实现对单表的增删改查的操作

### 本章目标

- 理解类和表的映射关系`重点`
- 理解持久化对象的状态及其转换`难点`
- 掌握按主键查询`重点`
- 掌握单表的增删改`重点`

### 为什么需要框架技术

**问题**

![image](http://www.znsd.com/znsd/courses/uploads/e421677c4da8bffaf17dab765a2a08bd/image.png)

- 如何更快更好地写简历？

  使用Word简历模板

- 思考：使用模板有什么好处呢？

  1. 不用考虑布局、排版等，提高效率
  2. 可专心在简历内容上
  3. 结构统一，便于人事阅读
  4. 新手也可以作出专业的简历

### 框架技术

**框架技术**

- 是一个应用程序的半成品
- 提供可重用的公共结构
- 按一定规则组织的一组组件

**分析优势**

- 不用再考虑公共问题
- 专心在业务实现上
- 结构统一，易于学习、维护
- 新手也可写出好程序

### Hibernate简介

- Hibernate是一个持久化框架。
- Hibernate是一个ORM（Object Relational Mapping 对象关系映射）框架，它是一个面向Java环境的对象/关系数据库映射工具。
- Hibernate是一个轻量级的ORM框架，完全采用普通的Java对象而不必继承Hibernate中的某个超类或者实现某个接口。
- Hibernate是面向对象的程序设计语言和关系数据库之间的桥梁，真正实现了采用面向对象的方式操作关系型数据库。

### Hibernate优势

- Hibernate会处理映射的Java类来使用XML文件，数据库表和无需编写任何一行代码。
- 提供了简单的API，用于直接从数据库中存储和检索Java对象。
- 如果有变化，数据库或任何表中的那么只需要修改XML文件的属性。
- 抽象掉不熟悉的SQL类型，并提供我们解决熟悉的Java对象。
- Hibernate不要求应用服务器进行操作。
- 操纵数据库对象的复杂关联。
- 尽量减少与智能读取策略数据库的访问。
- 提供数据的简单查询。

```java
Session session = HiberanteUtil.getSession();
Query query = session.createQuery("from User");
List<User> users =(List<User>)query.list();
```

### 支持的数据库

- Hibernate支持几乎所有主要的RDBMS（Relational Database Management System 关系型数据库管理系统）。以下是Hibernate支持的几个数据库引擎列表。
  - DB2/NT
  - MySQL
  - Oracle
  - Microsoft SQL Server Database
  - Sybase SQL Server
- 基本主流数据库都支持

### Hibernate架构图

![image](http://www.znsd.com/znsd/courses/uploads/8b726aad6448d2c8d267147a4d03e237/image.png)![image](http://www.znsd.com/znsd/courses/uploads/e59860ea49198e76f40fb946dc47a693/image.png)

**持久化层**

1. 什么叫持久化？

   上图中，分离出的持久化层封装了数据访问细节，为业务逻辑层提供了面向对象的API。持久（Persistence），即把数据（如内存中的对象）保存到可永久保存的存储设备中（如磁盘）。持久化的主要应用是将内存中的数据存储在关系型的数据库中，当然也可以存储在磁盘文件中、XML数据文件中等等。

2. 什么叫持久层？

   持久层（Persistence Layer），即专注于实现数据持久化应用领域的某个特定系统的一个逻辑层面，将数据使用者和数据实体相关联。

3. 为什么要持久化？增加持久层的作用是什么？数据库的读写是一个很耗费时间和资源的操作，当大量用户同时直接访问数据库的时候，效率将非常低，如果将数据持久化就不需要每次从数据库读取数据，直接在内存中对数据进行操作，这样就节约了数据库资源，而且加快了系统的反映速度。增加持久化层提高了开发的效率，使软件的体系结构更加清晰，在代码编写和系统维护方面变得更容易。特别是在大型的应用里边，会更有利。同时，持久化层作为单独的一层，人们可以为这一层独立的开发一个软件包，让其实现将各种应用数据的持久化，并为上层提供服务。从而使得各个企业里做应用开发的开发人员，不必再来做数据持久化的底层实现工作，而是可以直接调用持久化层提供的API。

### 使用Hibernate步骤

1. 下载并部署JAR包
2. 编写Hibernate配置文件
3. 创建持久化类和映射文件
4. 通过api操作数据库

#### 下载并部署JAR包

![20180504112832](http://www.znsd.com/znsd/courses/uploads/a13d1335daf301400895e36fe67f20ec/20180504112832.png)

- Hibernate 的官方主页是[www.hibernate.org](http://www.hibernate.org/)

- 下载hibernate-release-4.3.11.Final，最新版本为5.2(2018-05)

- Hibernate包目录结构和核心jar包

  ![20180504113952](http://www.znsd.com/znsd/courses/uploads/3b0fc6815f55f0432e2f66afc40f7eb4/20180504113952.png)

- 部署jar包

  - hibernate4.jar
  - required 目录下所有的jar包
  - 数据库驱动jar包
  - 其他项目中需要的jar包

  ![20180504114143](http://www.znsd.com/znsd/courses/uploads/06e70f5810e36297f69c3df7c576c0e4/20180504114143.png)

#### 配置hibernate

Hibernate配置文件

- 用于配置数据库连接
- 运行时所需的各种属性
- 默认文件名为"hibernate.cfg.xml"

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE hibernate-configuration PUBLIC  
    "-//Hibernate/Hibernate Configuration DTD 3.0//EN"  
    "http://hibernate.sourceforge.net/hibernate-configuration-3.0.dtd">
<hibernate-configuration>
	<session-factory>
		<!-- 配置数据库连接信息 -->
		<property name="connection.driver_class">com.mysql.jdbc.Driver</property>
		<property name="connection.url">jdbc:mysql://192.168.1.15:3306/test</property>
		<property name="connection.username">znsd_test</property>
		<property name="connection.password">123456</property>
		<!-- 数据库方言 -->
		<property name="dialect">org.hibernate.dialect.MySQL5InnoDBDialect</property>
		<!-- 在控制台输出sql语句 -->
		<property name="show_sql">true</property>
		<!-- 格式化sql语句 -->
		<property name="format_sql">true</property>
		<!-- 数据库生成策略 -->
		<!-- 数据库方言：指数据库按照那种数据库语法规则生成。 hibernate.hbm2ddl.auto：数据库生成策略 #hibernate.hbm2ddl.auto 
			create-drop：系统启东时先创建数据库，系统退出时删除数据库 #hibernate.hbm2ddl.auto create：系统启动时先删除原有数据库，再创建新的数据库 
			#hibernate.hbm2ddl.auto update：首先检测数据库是否存在，不存在则创建数据库，存在执行操作。 #hibernate.hbm2ddl.auto 
			validate：验证表结构，不会创建表 -->
		<property name="hibernate.hbm2ddl.auto">update</property>
		<!-- 配置映射文件 -->
		<!--注意配置文件名必须包含其相对于classpath 的全路径-->
		<mapping resource="com/znsd/hibernate/bean/Student.hbm.xml" />
	</session-factory>
</hibernate-configuration>
```

#### hibernate.hbm2ddl.auto 配置

- create-drop：系统启东时先创建数据库，系统退出时删除数据库
- create：系统启动时先删除原有数据库，再创建新的数据库
- update：首先检测数据库是否存在，不存在则创建数据库，存在执行操作。
- validate：验证表结构，不会创建表

#### 创建持久化类和映射文件

**定义持久化类**（也称实体类），实现java.io.Serializable 接口，添加默认构造方法

```java
import java.io.Serializable;

public class Student implements Serializable {

	private static final long serialVersionUID = 1L;

	private Integer id;
	private String name;
	private Integer age;
	private String gender;
	
	public Student() {

	}
  	// 忽略set get方法
}
```

**配置映射文件**（*.hbm.xml）

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE hibernate-mapping PUBLIC   
    "-//Hibernate/Hibernate Mapping DTD 3.0//EN"  
    "http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd">
<hibernate-mapping>
	<class name="com.znsd.hibernate.bean.Student" table="t_student">
		<id name="id" column="id">
			<generator class="assigned"></generator>
		</id>
		<property name="name" column="name"></property>
		<property name="age" column="age"></property>
		<property name="gender" column="gender"></property>
	</class>
</hibernate-mapping>
```

**向hibernate.cfg.xml文件中配置映射文件**

```xml
<hibernate-configuration>
	<session-factory>
		<!--注意配置文件名必须包含其相对于classpath 的全路径-->
		<mapping resource="com/znsd/hibernate/bean/Student.hbm.xml" />
	</session-factory>
</hibernate-configuration>
```

**单元测试**

```java
public class StudentTest {
	
	private SessionFactory sessionFactory;
	
	@Before
	public void init() {
		//创建SessionFactory对象
		//hibernate3.0版本所使用的方法
		//SessionFactory factory = cfg.buildSessionFactory();

		//hibernate4.0以上的版本才使用的方法
		Configuration cfg = new Configuration().configure("hibernate.cfg.xml");
		Properties ptr = cfg.getProperties();
		ServiceRegistry sr = new StandardServiceRegistryBuilder().applySettings(ptr).build();
		this.sessionFactory = cfg.buildSessionFactory(sr);
	}

	/**
	 * 测试添加
	 */
	@Test
	public void testAdd() {
		//使用openSession创建session对象
		Session session = this.sessionFactory.openSession();
		//使用getCurrentSession创建session对象
		//需要在hibernate.cfg.xml中添加配置信息
		//<propert yname="hibernate.current_session_context_class">thread</property>
		//Session session = factory.getCurrentSession();
		Transaction ts = session.getTransaction();
		try {
			ts.begin();
			Student student = new Student(1002, "张三", 22, "男");
			session.save(student);
			ts.commit();
		} catch (Exception e) {
			ts.rollback();
			e.printStackTrace();
		}
	}
	
	/**
	 * 测试删除
	 */
	@Test
	public void testDelete() {
		Session session = this.sessionFactory.openSession();
		Transaction ts = session.beginTransaction();
		Student student = new Student();
		student.setId(1001);
		session.delete(student);
		ts.commit();
	}
	
	/**
	 * 测试修改
	 */
	@Test
	public void testUpdate() {
		Session session = this.sessionFactory.openSession();
		Transaction ts = session.beginTransaction();
		Student student = new Student();
		student.setId(1002);
		student.setName("王武");
		student.setAge(25);
		session.update(student);
		ts.commit();
	}
	
	/**
	 * 测试查询
	 */
	@Test
	public void testQuery() {
		Session session = this.sessionFactory.openSession();
		Query query = session.createQuery(" from Student ");
		List<Student> list = query.list();
		for (int i = 0; i < list.size(); i++) {
			System.out.println(list.get(i));
		}
	}
}
```

### Hibernate对实体类的要求

- 持久化类通常建议有一个持久化标识符（ID）
- 持久化类建议使用封装类（Integer，Double等）
- 持久化类建议实现Serializable接口
- 持久化类必须满足JavaBean规范
  - 有无参的构造方法。
  - 提供了getter和setter方法
- 持久化类不能使用finnal修饰。
- 持久化类中如果使用集合，只能使用接口类型（List，SET，Map）

### Hibernate API

- Configuration类
- SessionFactory接口
- Session接口
- Transaction接口
- Query和Criteria接口

![hibernate3](http://www.znsd.com/znsd/courses/uploads/09ce5c134ef235f5bc23df329a4b738d/hibernate3.jpg)

#### Configuration类

- Configuration类负责管理Hibernate的配置信息并根据配置信息启动Hibernate。

- Hibernate配置信息有两种方式：

  1. 属性方式
  2. XML方式

- 推荐采用XML方式作为Hibernate的配置文件

  ```java
  //读取配置信息，加载默认的hibernate.cfg.xml
  Configuration cfg = new Configuration().configure();
  // 或者可以指定一个文件
  Configuration cfg = new Configuration().configure("hibernate.cfg.xml");
  ```

#### SessionFactory接口

- SessionFactory实例对应一个数据存储源。

- SessionFactory的特点：

  - 线程安全：一个SessionFactory被多个线程所共享。
  - 重量级的：SessionFactory会缓存SQL语句，映射数据等，所以一个应用程序，如果只访问一个数据库，只需建立一个SessionFactory对象即可。

  ```java
  //创建SessionFactory对象
  //hibernate3.0版本所使用的方法
  //SessionFactory factory = cfg.buildSessionFactory();
  		
  //hibernate4.0以上的版本才使用的方法
  ServiceRegistry sr = new StandardServiceRegistryBuilder().applySettings(cfg.getProperties()).build();
  SessionFactory factory = cfg.buildSessionFactory(sr);
  ```

#### Session接口

- Session（持久化管理器），它提供了和持久化相关的所有操作。

- Session的特点：

  - 线程不安全：只是对数据库的一次操作。
  - 轻量级的：它的创建和销毁不需要消耗太多的资源。
  - 一级缓存：session会保存当前工作单元的一些对象，每个session都有自己的缓存，每个缓存的对象都是相互独立的。
  - 及时关闭：通过SessionFactory打开，使用后需及时关闭

  ```java
  //使用openSession创建session对象
  Session session = factory.openSession();

  //使用getCurrentSession创建session对象
  Session session = factory.getCurrentSession()

  //需要在hibernate.cfg.xml中添加配置信息
  // <property name="hibernate.current_session_context_class">thread</property>
  ```

#### openSession和getCurrentSession的区别

- getCurrentSession在事务提交或者回滚之后会自动关闭，而openSession需要你手动关闭。如果使用openSession而没有手动关闭，多次之后会导致连接池溢出。
- openSession每次创建的都是一个新的Session对象，而getCurrentSession多次使用的是同一个Session对象。
- 推荐使用getCurrentSession创建Session对象。

#### Transaction接口

- Transaction接口是Hibernate中的事务接口。在Hibernate进行持久化操作时，必须进行事务控制。

  ```java
  //使用事务
  Transaction tx = session.beginTransaction();		
  try {
  	session.save(stu1);
  	tx.commit();                 //提交事务
  } catch (Exception e) {
  	e.printStackTrace();
  	tx.rollback();                //回滚事务
  } finally{
  	session.close();
  }
  ```

#### Query和Criteria接口

- Query和Criteria接口都是Hibernate中的查询接口。

- Query接口：包装了一个HQL（Hibernate Query Language）查询语句。

- Criteria接口：擅长执行动态查询。

  ```java
  //4、HQL语句
  String hql = "from Student";
  //5、Query对象
  Query q = (Query) session.createQuery(hql);
  List<Student> list = q.list();

  for (Student student : list) {
  	System.out.println("学生：" + student.toString());
  }
  ```

- sql查询的三种方式

  ```java
  //HQL方式
  String hql = "from User";
  Query query = session.createQuery(hql);
  List<User> list = query.list();

  /*
  //对象方式
  Criteria criteria = session.createCriteria(User.class);
  List<User> list = criteria.list();
  */

  //SQL语句方式
  String sql ="select * from users";
  Query query = session.createSQLQuery(sql).addEntity(User.class);
  List<User> list = query.list();
  ```

### Hibernate的工作机制

![image](http://www.znsd.com/znsd/courses/uploads/ff8c1522d97acb65d8f5eeb4ba579742/image.png)

### 小结

- 简述搭建Hibernate环境的步骤
- ORM指的是什么？
- Hibernate中常用的类和接口有哪些？
- Hibernate的运行过程是怎样的？

### get和load `重点`

| 方法                                       | 说      明        |
| ---------------------------------------- | --------------- |
| Object get(Class clazz, Serializable id) | 若数据不存在，返回NULL对象 |
| Object load(Class theClass, Serializable id) | 若数据不存在，系统就会抛出异常 |

- get和load都是用来根据id来获取单条记录。

- 区别：

  - get是立即加载，load是延迟加载。
  - get返回实体对象，load返回代理对象。
  - get返回实体对象如果没有该记录，会返回null。load如果没有该记录，会抛出异常。
  - get返回只能使用一级缓存，load可以使用一级和二级缓存。
  - 都是通过id获取对象，如果load只获取id则不执行查询语句。

- `由于load方式使用时，采用延迟加载机制，性能更高，所以一般情况下推荐使用load方式。`

- 测试get

  ```java
  @Test
  public void testGet() {
          Session session = this.sessionFactory.openSession();
          try {
              Object student = session.get(Student.class, 1002);
              System.out.println(student);
          } catch (Exception e) {
              e.printStackTrace();
          } finally {
              if (session != null) {
                  session.close();
              }
              if (sessionFactory != null) {
                  sessionFactory.close();
              }
          }
  }
  ```

- 测试load

  ```java
  @Test
  public void testLoad() {
  		Session session = this.sessionFactory.openSession();
  		try {
  			Object student = session.load(Student.class, 1001);
  			System.out.println(student);
  		} catch (Exception e) {
  			e.printStackTrace();
  		} finally {
  			if (session != null) {
  				session.close();
  			}
  			if (sessionFactory != null) {
  				sessionFactory.close();
  			}
  		}
  }
  ```

### Hibernate中Java对象的三种状态

1. 瞬时状态(Transient)：不曾进行过持久化，未与 session关联，不使用后会被垃圾回收。
2. 持久状态(Persistent)：当前仅与一个session关联。处于持久状态的对象在session关闭时，会将数据同步到数据库。
3. 游离状态(Detached)：也称脱管状态，已经进行过持久化，但当前未与session对象关联。

**瞬时状态 (Transient)**

当我们通过Java的new关键字来生成一个实体对象时，这时这个实体对象就处于自由状态，如下：

```java
 Student student = new Student(1001,"张三",20);
```

这时student对象就处于自由状态，为什么说Student对象处于自由状态呢？这是因为，此时Student只是通过JVM获得了一块内存空间，还并没有通过Session对象的save()方法保存进数据库，因此也就还没有纳入Hibernate的缓存管理中，也就是说Student对象现在还自由的游荡于Hibernate缓存管理之外。所以我们可以看出自由对象最大的特点就是，在数据库中不存在一条与它对应的记录。

瞬时对象特点：

- 不和 Session 实例关联
- 在数据库中没有和瞬时对象关联的记录

**持久状态 (Persistent)**

持久化对象就是已经被保存进数据库的实体对象，并且这个实体对象现在还处于Hibernate的缓存管理之中。这是对该实体对象的任何修改，都会在清理缓存时同步到数据库中。如下所示：

```java
Student student = new Student(1001,"张三",21);
tx=session.beginTransaction();
session.save(student);
student = (Student) session.load(Student.class,1001);
student.setAge(28);
tx.commit();
```

这时我们并没有显示调用session.update()方法来保存更新，但是对实体对象的修改还是会同步更新到数据库中，因为此时student对象通过save方法保存进数据库后，已经是持久化对象了，然后通过load方法再次加载它，它仍然是持久化对象，所以它还处于Hibernate缓存的管理之中，这时当执行tx.commit()方法时，Hibernate会自动清理缓存，并且自动将持久化对象的属性变化同步到到数据库中。持久的实例在数据库中有对应的记录，并拥有一个持久化标识 (identifier).

持久对象总是与 Session 和 Transaction 相关联，在一个 Session 中，对持久对象的改变不会马上对数据库进行变更，而必须在 Transaction 终止，也就是执行 commit() 之后，才在数据库中真正运行 SQL 进行变更，持久对象的状态才会与数据库进行同步。在同步之前的持久对象称为脏 (dirty) 对象。

瞬时对象转为持久对象：

1. 通过 Session 的 save() 和 saveOrUpdate() 方法把一个瞬时对象与数据库相关联，这个瞬时对象就成为持久化对象。
2. 使用 fine(),get(),load() 和 iterater() 待方法查询到的数据对象，将成为持久化对象。

持久化对象的特点：

1. 和 Session 实例关联
2. 在数据库中有和持久对象关联的记录

**游离（脱管）状态 (Detached)**

当一个持久化对象，脱离开Hibernate的缓存管理后，它就处于游离状态，游离对象和自由对象的最大区别在于，游离对象在数据库中可能还存在一条与它对应的记录，只是现在这个游离对象脱离了Hibernate的缓存管理，而自由对象不会在数据库中出现与它对应的数据记录。如下所示：

```java
Student student = new Student(1001,"张三",21);
tx=session.beginTransaction();
session.save(student);
student=(Student)session.load(Student.class, 1001);
student.setAge(28);
tx.commit();
session.close();
```

当session关闭后，Student对象就不处于Hibernate的缓存管理之中了，但是此时在数据库中还存在一条与student对象对应的数据记录，所以此时student对象处于游离态与持久对象关联的 Session 被关闭后，对象就变为脱管对象。对脱管对象的引用依然有效，对象可继续被修改。

脱管对象特点：

- 本质上和瞬时对象相同
- 只是比爱瞬时对象多了一个数据库记录标识值 id.

持久对象转为脱管对象：

- 当执行 close() 或 clear(),evict() 之后，持久对象会变为脱管对象。

瞬时对象转为持久对象：

- 通过 Session 的 update(),saveOrUpdate() 和 lock() 等方法，把脱管对象变为持久对象。

![image](http://www.znsd.com/znsd/courses/uploads/9ba0c62608191ad7e70637a6fd080ddd/image.png)

- hibernate 三种状态总结
  1. **瞬时状态：对于刚创建的一个对象，如果session中和数据库中都不存在该对象，那么该对象就是瞬时对象(Transient)**
  2. **持久化状态：瞬时对象调用save方法，或者离线对象调用update方法可以使该对象变成持久化对象，如果对象是持久化对象时，那么对该对象的任何修改，都会在提交事务时才会与之进行比较，如果不同，则发送一条update语句，否则就不会发送语句**
  3. **游离状态：离线对象就是，数据库存在该对象，但是该对象又没有被session所托管**

### 使用Hibernate CRUD部门

#### 增加部门

```java
public class DepartmentTest {
	
	private SessionFactory sessionFactory;
	
	@Before
	public void init() {
		// 1.读取配置文件
		Configuration cfg = new Configuration().configure("hibernate.cfg.xml");
		Properties ptr = cfg.getProperties();
		ServiceRegistry sr = new StandardServiceRegistryBuilder().applySettings(ptr).build();
		// 2.创建SessionFactory
		this.sessionFactory = cfg.buildSessionFactory(sr);
	}

	/**
	 * 测试添加
	 */
	@Test
	public void testAdd() {
		// 3.打开session
		Session session = this.sessionFactory.openSession();
		// 4.开始一个事务
		Transaction ts = session.beginTransaction();
		try {
			Department dept = new Department(1001, "技术部", "上海");
			// 5.持久化操作
			session.save(dept);
			// 6.提交事务
			ts.commit();
		} catch (Exception e) {
			// 6.回滚事务
			ts.rollback();
			e.printStackTrace();
		} finally {
			// 7.关闭session 
			session.close();
		}
	}
}
```

#### Hibernate更新部门操作

Hibernate提供了多种更新操作方式

- update() 如果是对一个已经存在的脱管对象进行更新使用update（）方法。
- save() 方法很是执行保存操作的，如果是对一个新的刚new出来的对象进行保存
- commit() 持久化对象会在关闭时自动提交到数据库
- merge() 执行完更新操作会返回一个持久化状态对象。可以二次操作。
- saveorupdate() 这个方法是更新或者插入，有主键就执行更新，如果没有主键就执行插入。

几种更新方法的区别：

- save()，如果对象是持久化状态，调用save()会进行更新操作。如果处于临时状态，会执行添加操作。如果处于脱管状态，调用save()方法会抛出异常。
- update()，如果对象处于持久化状态，调用update()会进行更新操作，如果处于临时状态，也会执行更新操作。如果处于脱管状态，调用update()方法为更新操作。
- saveOrUpdate()：如果对象是持久化状态，调用saveOrUpdate()会进行更新操作。如果是临时状态，判断是否有id，如果没有为添加操作；如果有为更新操作。
- close()：如果对象处于持久化状态，session关闭时，会自动将对象保存到数据库中。

```java
public void testUpdate() {
		Session session = this.sessionFactory.openSession();
		Transaction ts = session.beginTransaction();
		Department dept = (Department) session.load(Department.class, 1001);
		dept.setName("测试部");
		session.update(dept);// 修改操作
		ts.commit();
}
```

#### 删除部门

`注意：`增、删、改操作一定要在事务环境中完成2. 修改、删除数据时，需要先加载数据

```java
public void testDelete() {
		Session session = this.sessionFactory.openSession();
		Transaction ts = session.beginTransaction();
		Department dept = (Department) session.load(Department.class, 1001);
		session.delete(dept); // 删除操作
		ts.commit();
}
```

### 学员操作—搭建Hibernate环境

需求说明

- 在eclipse中为租房系统创建工程，导入Hibernate jar包
- 创建Hibernate配置文件hibernate.cfg.xml
- 创建用户表对应的持久化类User和映射文件User.hbm.xml

### 小结

- get和load有什么区别？
- Hibernate中Java对象的三种状态是什么？
- Java对象三种状态之间是如何转换的？

### 总结

- 简述搭建Hibernate环境的步骤
- Hibernate中常用的类和接口有哪些？
- Hibernate的运行过程是怎样的？
- get和load有什么区别？
- Hibernate中Java对象的三种状态是什么？
- Java对象三种状态之间是如何转换的？