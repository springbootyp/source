## 第六章 使用分层实现业务处理

### 本章任务

- 实现所有的Web应用程序共用Tomcat中发布的一条信息
- 使用JNDI查找新闻发布系统数据源
- 使用三层实现删除学生、删除学生和单条学生显示的功能

### 本章目标

- 熟练应用JNDI查找数据源`重点（难点）`
- 掌握数据库连接池原理
- 熟练应用分层架构开发应用系统`重点`

### 为什么使用JNDI

**问题**

- 如何实现在Tomcat中发布一条信息供所有的Web应用程序使用？

**分析**

- 类似于全局变量->Application
- 但Application只用于本Web应用程序共享数据

### JNDI介绍

**什么是JNDI**

JNDI是 Java 命名与目录接口（Java Naming and Directory Interface），在J2EE规范中是重要的规范之一，不少专家认为，没有透彻理解JNDI的意义和作用，就没有真正掌握J2EE特别是EJB的知识。那么，JNDI到底起什么作用？要了解JNDI的作用，我们可以从“如果不用JNDI我们怎样做？用了JNDI后我们又将怎样做？”这个问题来探讨。没有JNDI的做法：程序员开发时，知道要开发访问MySQL数据库的应用，于是将一个对 MySQL JDBC 驱动程序类的引用进行了编码，并通过使用适当的 JDBC URL 连接到数据库。

- JNDI(Java Naming and Directory Interface)Java命名和目录接口
- 通过名称将资源与服务进行关联
- JNDI是一个目录服务，就像我们书本前面的目录一样，大家可以翻到书中的目录，比如说“第二章servlet基础。。。25页”，这就建立了一个名称和对象的关联，我们可以根据“第二章servlet基础。。。25页”这个名字，在25页找到真正的第二章内容。

### JNDI的简单应用

应用步骤

- 发布信息：修改Tomcat\conf\context.xml文件

  ```xml
  <Context>
  	<Environment name="tjndi" value="hello JNDI" type="java.lang.String" />
  </Context>
  ```

- 获取资源：使用lookup()进行查找

  ```java
  <%
  //javax.naming.Context提供了查找JNDI 的接口
  Context ctx = new InitialContext();	
  //java:comp/env/为前缀
  String testjndi = (String)ctx.lookup("java:comp/env/tjndi");
  out.println("JNDI: "+testjndi);
  %>
  ```

### 学员操作——使用JNDI

- 训练要点：使用JNDI

- 需求说明：在Tomcat中发布一条信息供所有的Web应用程序使用

  ![image](http://www.znsd.com/znsd/courses/uploads/254e04524671f7202fe1ec46aead1cb7/image.png)

### 为什么使用连接池

**传统数据库连接方式的不足**

JDBC连接数据库的方式是一种比较传统的连接方式，这种连接方式在执行过程中，需要经常与数据库建立连接，并且在使用后再关闭连接，释放资源。可想而知，频繁的连接和释放操作必然要耗费很多系统资源，而且容易引发异常，因而需要有一种新的技术来弥补它的不足，这就是连接池（Connection Pool）技术。

- 需要经常与数据库建立连接

- 在访问结束后必须要关闭连接释放资源

- 当并发访问数量较大时，网站速度收到极大影响

- 系统的安全性和稳定性相对较差

  ![20180131171656](http://www.znsd.com/znsd/courses/uploads/8541385663dd677ec6231a9ff4f2f00d/20180131171656.png)

### 生活中的连接池

- 普通电话 ----建立连接，等待回应

  ![20180131171916](http://www.znsd.com/znsd/courses/uploads/611ae5d403244b7e4557fd1459ed3952/20180131171916.png)

- 热线电话 ----已建立连接

  ![20180131171950](http://www.znsd.com/znsd/courses/uploads/f2d6c45b5774bef3affe7f162966cfee/20180131171950.png)

在我们日常生活中经常拨打热线电话（如 10086），热线电话对外是相同的号码，允许同时接入多个电话，但是当所有的接入都在工作，再有电话打入的时候就需要进行等待，直到其中有一个接入出现空闲。

### 连接池技术工作原理

- 连接池中的连接：连接池是由容器提供的，用来管理池中连接对象

  ![20180131172113](http://www.znsd.com/znsd/courses/uploads/a0fdb23378dee90386d2b54a0776091e/20180131172113.png)

### 数据源简介

**数据源（DataSource）**

- javax.sql.DataSource负责建立与数据库的连接
- 从Tomcat的数据源获得连接
- 把连接保存在连接池中

![20180131172255](http://www.znsd.com/znsd/courses/uploads/17d5f0061d27c1c628aec74cfb22d866/20180131172255.png)

**如何获得DataSource对象**

- 数据源由Tomcat提供

- 使用JNDI获得DataSource引用

  ![20180131172455](http://www.znsd.com/znsd/courses/uploads/dfb798f434418ef9ca85db1db02cae03/20180131172455.png)

### 访问数据源

- 使用连接池实现数据库连接

  1. 配置context.xml文件
  2. 配置web.xml文件
  3. 添加数据库驱动文件
  4. 进行代码编写，实现查找数据源

- Tomcat的conf/context.xml中的配置

  ```xml
  <Resource name="jdbc/student" auth="Container" type="javax.sql.DataSource"
  		maxActive="100" maxIdle="30" maxWait="10000" username="znsd_test" password="123456"
  		driverClassName="com.mysql.jdbc.Driver"
  		url="jdbc:mysql://192.168.1.15:3306/test"></Resource>
  ```

| 属性名称      | 说明                      |
| --------- | ----------------------- |
| name      | 指定Resource的JNDI名称       |
| auth      | 指定管理Resource的Manager    |
| type      | 指定Resource所属的Java类      |
| maxActive | 指定连接池中处于活动状态的数据库连接的最大数目 |
| maxIdle   | 指定连接池中处于空闲状态的数据库连接的最大数目 |
| maxWait   | 指定连接池中的连接处于空闲的最长时间      |

- 添加数据库驱动文件：把数据库驱动的.jar文件，加入到Tomcat的lib中

- 应用程序的web.xml文件的配置：在web.xml中配置\<resource-ref>

  ```xml
  <resource-ref>
  	<!-- 指定JNDI的名字，与<Resource>元素中的name一致 -->
  	<res-ref-name>jdbc/student</res-ref-name>
  	<!-- 指定引用资源的类名，与<Resource>元素中的type一致 -->
  	<res-type>javax.sql.DataSource</res-type>
  	<!-- 指定管理所引用资源的Manager与<Resource>元素中的auth一致 -->
  	<res-auth>Container</res-auth>
  </resource-ref>
  ```

- 访问数据源

  ```java
  import java.sql.Connection;
  import java.sql.SQLException;

  import javax.naming.Context;
  import javax.naming.InitialContext;
  import javax.naming.NamingException;
  import javax.sql.DataSource;

  public class BaseDao {
  	
  	public Connection getConnection() {
  		Context ctx = null;
  		Connection conn = null;
  		try {
  			ctx = new InitialContext();
  			// 获取与逻辑名相关联的数据源对象
  			DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/student");
  			conn = ds.getConnection();
  		} catch (SQLException exception) {
  			exception.printStackTrace();
  		} catch (NamingException namingException) {
  			namingException.printStackTrace();
  		}
  		return conn;
  	}
  }
  ```

### 小结

使用连接池实现数据库连接

- 配置context.xml文件`Tomcat的conf文件夹下`
- 配置web.xml文件`与context.xml指定的名称一致`
- 添加数据库驱动文件`加入到Tomcat的lib中`
- 进行代码编写，实现查找数据源`lookup()参数的写法`

总结每一步的注意事项后，再说明另一种配置的方法，也可以在本项目的META-INF文件夹下添加context.xml文件，进行配置。并说明两者的区别

### 学员操作——使用连接池实现数据库连接

- 训练要点
  - 连接池的配置
  - 通过JNDI查找数据源连接数据库
- 需求说明：修改学生系统，通过JNDI查找数据源，实现数据库的访问
- 实现思路
  1. 配置/tomcat安装目录/conf/context.xml文件
  2. 配置/WebContent/WEB-INF/web.xml文件
  3. 在lib目录中添加数据库驱动jar文件
  4. 在BaseDao中获取数据连接方法中编写代码，实现查找数据源

### 为什么需要分层

- JSP开发时分两层的弊端，随着业务的改变，数据访问层要不断的修改代码

  ![image](http://www.znsd.com/znsd/courses/uploads/6f895a84ad2231def040d1aa60709301/image.png)

- 数据层只访问数据库不做处理，举例删除学生信息，业务改变了还要不停的修改数据层的弊端，引出三层。

### 三层模式

- 三层模式的划分

- MVC：model ,views,controller

- 表示层：主要用来处理客户请求，以及与业务逻辑层进行交互。jsp,servlet,velocity,freemark

  ![20180131202643](http://www.znsd.com/znsd/courses/uploads/8bcb0b4ae9d5817620b401dc15e54ded/20180131202643.png)

### 层与层之间的关系

![20180131202757](http://www.znsd.com/znsd/courses/uploads/2d6727b1b32fbc836e5b2bdf7e707a9a/20180131202757.png)

### 分层的实现

![20180131202850](http://www.znsd.com/znsd/courses/uploads/6d7f968490f3e19443b3a4220dd15b79/20180131202850.png)

### 分层实现删除学生信息

- 编写业务逻辑控制接口

  ```java
  public interface StudentService {

  	public List<Student> getAll();

  	public void add(Student student);

  	public void delete(Integer id);

  	public void update(Student student);
  }
  ```

- 编写业务逻辑控制接口的实现

  ```java
  public class StudentServiceImpl implements StudentService {
  	
  	private StudentDao studentDao;
  	
  	public StudentServiceImpl() {
  		studentDao = new StudentDaoImpl();
  	}

  	@Override
  	public List<Student> getAll() {
  		return studentDao.getAll();
  	}

  	@Override
  	public void add(Student student) {
  		studentDao.add(student);
  	}

  	@Override
  	public void delete(Integer id) {
  		// 如果学号为空直接返回
  		if (id == null || id <= 0) {
  			return;
  		}
  		studentDao.delete(id);
  	}

  	@Override
  	public void update(Student student) {
  		studentDao.update(student);
  	}
  }
  ```

- 修改控制页面

  ```java
  <%
  		String opr = request.getParameter("opr");
  		//省略其他操作代码
  		if (opr.equals("del")) {
  			String id = request.getParameter("id");
  			StudentService studentService = new StudentServiceImpl();
  			int result = studentService.delete(Integer.parseInt(id));
  			if (result == 1) {
  	%>
  	<script type="text/javascript">
  		alert("已经成功删除学生，点击确认返回原来页面");
  		location.href = "topic_ control.jsp?opr=list";
  	</script>
  	<%
  			} else if (result == 0) {//省略删除失败提示代码
  				%>
  				<script type="text/javascript">
  					alert("删除失败");
  					location.href = "studentList.jsp";
  				</script>
  				<%	
  			}
  		}
  %>
  ```

### 学员操作——使用三层架构修改删除学生

- 训练要点：使用三层构架
- 需求说明：修改删除新闻主题功能，使之符合三层构架
- 实现思路
  1. 编写业务逻辑控制接口
  2. 编写实现业务逻辑控制接口的类
  3. 修改控制页面

### 分层原则

- 上层依赖其下层，依赖关系不跨层
  1. 表示层不能直接访问数据访问层
  2. 上层调用下层的结果，取决于下层的实现
- 下一层不能调用上一层
- 下一层不依赖上一层
  1. 上层的改变不会影响下一层
  2. 下层的改变会影响上一层得到的结果
- 在上一层中不能出现下一层的概念
  1. 分工明确，各司其职

### 小结

1. 职责划分清晰
2. 无损替换
3. 复用代码
4. 降低了系统内部的依赖程度

![20180131205015](http://www.znsd.com/znsd/courses/uploads/f701b1fc5a657ea4ba0cdbb503b26996/20180131205015.png)

- 分层开发的特点
  - 下层不知道上层的存在
    1. 仅完成自身的功能
    2. 不关心结果如何使用
  - 每一层仅知道其下层的存在，忽略其他层的存在
    1. 只关心结果的取得
    2. 不关心结果的实现过程
    3. JSTL通常会与EL表达式合作实现JSP页面的编码

### 学员操作—使用三层架构写学生系统

- 需求说明：学生系统，使之符合三层构架

### 总结

- JNDI的全称：Java 命名与目录接口（Java Naming and Directory Interface）
- Tomcat中配置数据源的步骤如下
  1. 配置context.xml文件
  2. 配置web.xml文件
  3. 添加数据库驱动文件
  4. 进行代码编写，实现查找数据源
- 搭建三层架构基本框架的步骤如下
  1. 表示层：用于用户展示与交互
  2. 业务逻辑层：提供对业务逻辑处理的封装
  3. 数据访问层：数据的增、删、改、查操作