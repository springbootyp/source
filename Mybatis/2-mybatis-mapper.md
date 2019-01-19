## 第二章  MyBatis映射文件

### 本章目标

- MyBatis映射文件的配置
- MyBatis面向接口编程
- SQL语句配置
- 关联映射查询

### MyBatis映射文件

- MyBatis真正的核心是在映射文件，由于它的异常强大，如果拿它和相同功能的JDBC代码相比，你会发现它省掉了将近95%的代码。
- MyBatis有以下几个顶级元素
  - \<select>：映射查询语句
  - \<insert>：映射插入语句
  - \<update>：映射修改语句
  - \<delete>：映射删除语句
  - \<sql>：可以被其它sql语句重用的sql语句。
  - \<resultMap>：是最复杂也是最强大的元素，用来和数据库表和实体类进行映射。
  - \<cache>：给定命名空间的缓存配置。
  - \<cache-ref>：其它命名空间缓存配置的引用。

#### select

- select是Mybatis最常用的元素之一，使用select也非常简单。

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

  <mapper namespace="StudentMapper">

  	<!-- id为查询的名称，一个映射文件中，必须是唯一的。 --> 
  	<!-- resultType返回类型为学生映射类型 -->
  	<!-- parameterType 接收一个int类型的参数 -->
  	<!-- #{id}表示占位符，会接收parameter传递过来的参数。 -->
  	
  	<select id="selectStudentAll" parameterType="int"  resultType="Student">
  		select * from student where id = #{id}
  	</select>

  </mapper>
  ```

#### select常用的属性

select 元素有很多属性允许你配置，来决定每条语句的作用细节。

| 属性            | 说明                                       |
| ------------- | ---------------------------------------- |
| id            | 在命名空间中唯一的表示                              |
| parameterType | 传入这个sql语句的参数类的完全限定名或者别名。                 |
| resultType    | 期待sql返回的类型的完全限定名或别名。                     |
| resultMap     | 返回外部resultMap格式的类型。                      |
| flushCache    | 如果设置为true，则只要语句被调用会清空缓存，默认为false。        |
| userCache     | 如果设置为true，则会将本条语句的结果写入二级缓存，默认值select为true。 |
| timeout       | 等待数据库的返回时间，默认值为unset，依赖驱动                |
| statementType | STATEMENT，PREPARED 或 CALLABLE 的一个。这会让 MyBatis 分别使用 Statement，PreparedStatement 或 CallableStatement，默认值：PREPARED。 |

#### Mybatis传参方式

MyBatis中的\#{}与${}

- \#{}传参：\#{}传递的参数实际上是通过`占位符`去传入到`已经预编译好的SQL`中去的，传入的数据以对象的方式来解析

```xml
<select id="getStudentByName" parameterType="java.lang.String" resultType="Student">
	select * from student where name = #{name}
</select>
```

```sql
-- 实现拦截器输出的预编译SQL
select * from student where name = ? 
```

- \${}传参：直接`将参数拼接成完整的SQL`去DBMS中编译执行的，传入的值是什么就当做什么表示，`容易造成SQL注入。当参数为表名、列名等数据库对象时必须使用${}`

```xml
<select id="getStudentByName2" parameterType="Student" resultType="Student">
	select * from student where name = ${name}
</select>
```

```sql
-- 实现拦截器输出的预编译SQL
select * from student where name = 1
```



#### insert、update、delete

- 数据变更语句 insert，update和 delete 的实现非常接近。

- 插入学生信息

  ```xml
  <insert id="addStudent" parameterType="Student">
  	insert into student(name, pass, sex, address) values(#{name}, #{pass}, #{sex}, #{address})
  </insert>
  ```

- 批量插入学生信息

  ```xml
  <insert id="batchAddStudent" parameterType="java.util.List">
  	insert into student(name, pass, sex, address) values
  	<foreach collection="list" item="s" index="index" separator=",">
  		(#{s.name}, #{s.pass}, #{s.sex}, #{s.address})
  	</foreach>
  </insert>
  ```

- 更新学生信息 

  ```xml
  <update id="updateStudent" parameterType="Student">
  	update student set name = #{name}, pass = #{pass}, sex = #{sex}, address = #{address} where id = #{id}
  </update>
  ```

- 删除学生信息 

  ```xml
  <delete id="deleteStudent" parameterType="int">
  	delete from student where id = #{id}
  </delete>
  ```


#### 实现insert、update、delete

- 通过测试类调用

  ```java
  @Test
  public void testAddStudent() {
      SqlSession sqlSession = sqlSessionFactory.openSession();
      Student student = new Student();
      student.setName("100");
      student.setPass("1");
      student.setSex("男");
      sqlSession.insert("StudentMapper.addStudent", student);
      sqlSession.commit(); // 增加、修改、删除必须使用事务。
      sqlSession.close();
  }
  ```

### 注解方式实现映射

- Mybatis中除了使用XML映射文件以外，还提供注解方式实现映射。
- 提供映射功能的注解：
  - @Select
  - @Insert
  - @Update
  - @Delete

#### MyBatis中注解的使用

- 使用注解可以直接将映射文件中的sql语句通过注解的方式实现。

  ```java
  public interface StudentMapper { // 新建接口

  	@Select("select * from student")
  	public List<Student> selectStudentAll();
  	
  	@Select("select * from student where id = #{id}")
  	public Student findById(Integer id);
  	
  	@Insert("insert into student(name, pass, sex, address) values(#{name}, #{pass}, #{sex}, #{address})")
  	public int addStudent(Student student);
  	
  	@Update("update student set name=#{name}, pass=#{pass}, sex=#{sex}, address=#{address} where id=#{id}")
  	public int updateStudent(Student student);
  	
  	@Delete("delete from student where id = #{id}")
  	public int deleteById(int id);
  }
  ```

  ```xml
  <mappers>
      <!-- 使用注解需要使用class来映射注解接口 -->
      <mapper class="com.lxit.mybatis.mapper.StudentMapper"/>
  </mappers>
  ```

  ```java
  @Test
  public void testStudentList() {
      SqlSession sqlSession = sqlSessionFactory.openSession();
      List<Student> studentList = sqlSession.selectList("selectStudentAll");
      for (Student student : studentList) {
        System.out.println(student);
      }
  }
  ```

- 使用注解虽然更加方便，但是配置复杂sql语句时较为复杂。所以很多时候采用两种相结合的方式。

### Mybatis接口编程

- 添加接口类StudentMapper

  ```java
  public interface StudentMapper {

  	public List<Student> selectStudentAll();

  	public Student findById(int sid);

  	public int addStudent(Student student);

  	public int updateStudent(Student student);

  	public int deleteStudent(int id);
  }
  ```

- 接口实现类必须与映射文件中的namespace同名。映射文件的insert,update,delete,selelct标签的ID作为接口的实现类。

  ```xml
  <mapper namespace="com.znsd.mybatis.mapper.StudentMapper"></mapper>
  ```

  ​

- 测试类通过session.getMapper(StudentMapper.class)创建接口对象，然后调用接口方法。

```xml
<mapper namespace="com.znsd.mybatis.mapper.StudentMapper">

	<select id="selectStudentAll" resultType="Student">
		select * from student
	</select>
	
	<select id="findById" parameterType="java.lang.Integer" resultType="Student">
		select * from student where id = #{id}
	</select>

	<insert id="addStudent" parameterType="Student">
		insert into student(name, pass, sex, address) values(#{name}, #{pass}, #{sex}, #{address})
	</insert>
	
	<update id="updateStudent" parameterType="Student">
		update student set name = #{name}, pass = #{pass}, sex = #{sex}, address = #{address} where id = #{id}
	</update>
	
	<delete id="deleteStudent" parameterType="int">
		delete from student where id = #{id}
	</delete>
</mapper>
```

```xml
<mappers>
		<mapper resource="com/znsd/mybatis/mapper/StudentMapper.xml"/>
</mappers>
```



```java
@Test
public void testStudentList() {
    SqlSession sqlSession = sqlSessionFactory.openSession();
    StudentMapper studentMapper = sqlSession.getMapper(StudentMapper.class);
    List<Student> studentList = studentMapper.selectStudentAll();
    for (Student student : studentList) {
      System.out.println(student);
    }
}
```

`更加推荐使用这种方式，调用时使用的接口类型，接口的实现配置在XML中。`



### 小结

- Mybatis中实现CRUD的三种方式
  - 纯XML方式实现
  - 接口+注解方式实现
  - 接口+XML方式实现


### Maping映射

**存在的问题**

- 当数据库表中的字段和实体类不同时。
- 当出现多表联合查询时。

**如果使用resultType，实体类必须和表中的字段完全对应，如果不对应发现无法获取值。解决办法有两个：**

- 为查询出的列名取一个别名，与实体类书名名相同。
- `为表添加实体和表的映射文件。`

### ResultMap标签介绍

**ResultMap的常用子标签**

- id：映射主键。
- result：映射普通列。
- association：复杂结果映射。
- collection：复杂类型的集合映射。
- constructor：构造函数注入。

### Mapping映射

- 添加一个班级表

  ```sql
  CREATE TABLE `class` (
    `c_id` int(11) NOT NULL AUTO_INCREMENT,
    `c_name` varchar(20) DEFAULT NULL,
    PRIMARY KEY (`c_id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
  ```

- 添加resultMap映射文件

  ```xml
  <!-- 添加resultMap映射文件 -->
  <resultMap type="com.znsd.mybatis.entity.Clazz" id="ClzzMap">
  	<id property="id" column="c_id"/>
  	<result property="name" column="c_name"/>
  </resultMap>
  ```

- 使用resultMap指定映射文件id

  ```xml
  <select id="selectClazzAll" resultMap="ClzzMap">
        select * from Class
  </select>
  ```

### 关系映射

- 在数据库中，许多数据是分布在多个表中的，有时候需要将多个表的数据关联起来进行查询。那么在ORM框架中，我们需要处理数据表的映射关系。
- 常见的映射关系
  - 一对一
  - 一对多
  - 多对多

#### 一对一:嵌套结果

- 嵌套结果：使用联接查询的方式一次获取两个表中的数据。

- 通过一个丈夫对应一个妻子来实现：

- 实现步骤：

  - 添加丈夫和妻子表，妻子表通过外键引用丈夫的主键。

    ```sql
    -- 创建丈夫表
    CREATE TABLE `husband` (
      `husbandId` int(11) NOT NULL AUTO_INCREMENT,
      `husbandName` varchar(20) DEFAULT NULL,
      PRIMARY KEY (`husbandId`)
    ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
    ```

    ```sql
    -- 创建妻子表，妻子表中有对丈夫的引用
    CREATE TABLE `wife` (
      `wifeId` int(11) NOT NULL AUTO_INCREMENT,  
      `wifeName` varchar(20) DEFAULT NULL,
      `husbandId` int(11) NOT NULL,
      PRIMARY KEY (`wifeId`),
      KEY `fk_husbandId` (`husbandId`),
      CONSTRAINT `fk_husbandId` FOREIGN KEY (`husbandId`) REFERENCES `husband` (`husbandId`)
    ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

    ```

  - 插入测试数据。

    ```sql
    -- 插入测试数据
    INSERT INTO `husband` VALUES ('1', '郭靖');
    INSERT INTO `husband` VALUES ('2', '杨过');
    INSERT INTO `husband` VALUES ('3', '洪七公');

    INSERT INTO `wife` VALUES ('1', '黄蓉', '1');
    INSERT INTO `wife` VALUES ('2', '小龙女', '2');
    ```

  - 创建实体类，在丈夫实体类中引用妻子的实体对象。反之亦然。

    ```java
    public class Husband implements Serializable {

    	private Integer husbandId;
    	private String husbandName;

    	private Wife wife;
      
      	// 忽略set get方法
    }
    ```

    ```java
    public class Wife implements Serializable {

    	private Integer wifeId;
    	private String wifeName;

    	private Husband husband;
      
      	// 忽略set get方法
    }
    ```

    ​

  - 添加映射文件，通过\<association />实现映射关系。

    ```xml
    <!--丈夫类中添加妻子的实体对象，映射文件如下-->
    <resultMap type="com.znsd.mybatis.entity.Husband" id="HusbandMap">
    	<id property="husbandId" column="husbandId"/>
    	<result property="husbandName" column="husbandName"/>
    	
    	<association property="wife" javaType="com.znsd.mybatis.entity.Wife">
    		<!-- 丈夫一对一妻子 -->
    		<id property="wifeId" column="wifeId"/>
    		<result property="wifeName" column="wifeName"/>
    		<!-- 妻子一对一丈夫 -->
    		<result property="husband.husbandId" column="husbandId"/>			
    		<result property="husband.husbandName" column="husbandName"/>			
    	</association>
    </resultMap>
    	
    <select id="selectList" resultMap="HusbandMap">
    	select h.*, w.* from husband h inner join wife w on h.husbandId = w.husbandId 
    </select>
    ```



#### 一对一:嵌套查询

- 嵌套查询：通过多次执行SQL来获取查询结果。

  ```xml
  <!--妻子类中添加丈夫的实体对象，映射文件如下-->
  <resultMap type="com.znsd.mybatis.entity.Wife" id="WifeMap">
  	<id property="wifeId" column="wifeId"/>
  	<result property="wifeName" column="wifeName"/>
  		
  	<association property="husband" column="husbandId" select="com.znsd.mybatis.mapper.HusbandMapper.selectHusbandOne">
  	</association>
  </resultMap>

  <select id="selectAllWife" resultMap="WifeMap">
  	select * from wife
  </select>

  <!-- 通过 husbandId 查找一个husband对象提供给association中的select节点名称使用-->
  <select id="selectHusbandOne" parameterType="java.lang.Integer" resultType="com.znsd.mybatis.entity.Husband">
  	select * from husband where husbandId = #{husbandId}
  </select>
  ```

  ​

#### 练习：一对一映射

- 实现银行卡和身份证的一对一关联映射。
- 思路分析：
  - 创建身份证和银行卡表
  - 银行卡引用身份证主键
  - 建立映射关系

#### 多对一嵌套结果

- 通过学生和班级关系演示多对一映射

- 学生类中添加班级的引用

- 创建班级表

  ```sql
  CREATE TABLE `clazz` (
    `clsid` int(11) NOT NULL AUTO_INCREMENT,
    `clsname` varchar(20) NOT NULL,
    PRIMARY KEY (`clsid`)
  );
  ```

- 创建学生表，学生表中有对班级的引用

  ```sql
  CREATE TABLE `student` (
    `sid` int(11) NOT NULL AUTO_INCREMENT,
    `sname` varchar(20) NOT NULL,
    `sex` varchar(10) NOT NULL,
    `age` int(11) NOT NULL,
    `clsid` int(11) NOT NULL, -- 所在班级id
    PRIMARY KEY (`sid`)
  );
  ```

- 插入测试数据

  ```sql
  insert  into `clazz`(`clsid`,`clsname`) values 
  (1,'1701'),
  (2,'1702'),
  (3,'1703');

  insert  into `student`(`sid`,`sname`,`sex`,`age`,`clsid`) values 
  (1,'郭靖','男',20,1),
  (2,'黄蓉','女',18,1),
  (3,'杨过','男',17,2),
  (4,'小龙女','女',16,2);
  ```

- 创建班级类

  ```java
  public class Clazz implements Serializable {

  	private Integer id;

  	private String name;
    
    	// 忽略set get方法
  }
  ```

- 创建学生类

  ```java
  public class Student implements Serializable {
  	private Integer id;
  	private String name;
  	private String sex;
  	private Integer age;
  	private Clazz clazz; // 所在班级对象
    
    	// 忽略set get 方法
  }
  ```

- StudentMapper.xml文件

  ```xml
  <!-- 学生实体类中引用班级对象 -->
  <resultMap type="com.znsd.mybatis.entity.Student" id="StudentMap">
  	<id property="id" column="sid"/>
  	<result property="name" column="sname"/>
  	<result property="sex" column="sex"/>
  	<result property="age" column="age"/>

    	<!-- 多对一映射班级信息 -->
  	<association property="clazz" javaType="com.znsd.mybatis.entity.Clazz">
  		<id property="id" column="clsid"/>
  		<result property="name" column="clsname"/>
  	</association>
  </resultMap>

  <select id="selectStudentAll" resultMap="StudentMap">
  	select s.*, c.* from student s inner join clazz c on s.clsid = c.clsid
  </select>
  ```

#### 多对一嵌套查询

- 嵌套查询，通过多次执行sql语句

  ```xml
  <!-- 映射班级属性 -->
  <association property="clazz" column="clsid" select="com.znsd.mybatis.mapper.ClazzMapper.findById">
  </association>

  <!-- 查询班级信息 -->
  <select id="selectStudentAll" resultMap="StudentMap">
  	select * from student
  </select>

  <!-- 在ClazzMapper.xml中配置的读取单个班级信息的select语句 -->
  <resultMap type="com.znsd.mybatis.entity.Clazz" id="ClzzMap">
  	<id property="id" column="clsid"/>
  	<result property="name" column="clsname"/>
  </resultMap>
  <select id="findById" resultMap="ClzzMap">
  	select * from clazz where clsid = #{clsid}
  </select>
  ```

#### 练习：多对一映射

- 实现学生和班级的多对一映射
- 思路分析：
  - 创建学生和班级表
  - 学生引用班级主键
  - 建立映射关系

#### 一对多：嵌套结果

- 通过学生和班级演示嵌套查询

  ```xml
  <!-- 班级映射文件 -->
  <resultMap type="com.znsd.mybatis.entity.Clazz" id="ClssMap">
  	<id property="id" column="clsid"/>
  	<result property="name" column="clsname"/>
  		
  	<!-- 班级类中添加学生类的集合 -->
  	<collection property="studentList" ofType="com.znsd.mybatis.entity.Student" column="cid">
  		<id property="id" column="sid"/>
  		
  		<id property="id" column="sid"/>
  		<result property="name" column="sname"/>
  		<result property="sex" column="sex"/>
  		<result property="age" column="age"/>
  	</collection>
  </resultMap>

  <select id="selectClazzAll" resultMap="ClssMap">
  	select * from clazz c left join student s on c.clsid = s.clsid 
  </select>
  ```

#### 一对多：嵌套查询

- 通过学生和班级演示嵌套查询，会生成多条SQL语句

  ```xml
  <!-- 班级映射文件 -->
  <resultMap type="com.znsd.mybatis.entity.Clazz" id="ClssMap">
  	<id property="id" column="clsid"/>
  	<result property="name" column="clsname"/>
  		
  	<!-- 班级类中添加学生类的集合 -->
  	<collection property="studentList" ofType="com.znsd.mybatis.entity.Student" column="clsid" 
  	select="com.znsd.mybatis.mapper.StudentMapper.selectByClssId"></collection>
  </resultMap>

  <!-- 根据ID查询班级信息 -->
  <select id="selectClzzOne" resultMap="ClssMap" parameterType="int">
  	select * from clazz where clsid = #{clsid} 
  </select>
  ```

  ```xml
  <resultMap type="com.znsd.mybatis.entity.Student" id="StudentMap">
  	<id property="id" column="sid"/>
  	<result property="name" column="sname"/>
  	<result property="sex" column="sex"/>
  	<result property="age" column="age"/>
  </resultMap>
  <!-- 根据班级ID查询学生列表信息 -->
  <select id="selectByClssId" parameterType="int" resultMap="StudentMap">
  	select * from student where clsid = #{clsid}
  </select>
  ```

#### 嵌套结果和嵌套查询的区别

- 嵌套查询一次将多个表的数据查询出来，嵌套结果通过多次查询获取查询结果。
- 配置文件不同，嵌套查询需要定义额外的映射，嵌套结果需要定义外键列，和查询的select方法。
- 嵌套查询不支持延迟加载，嵌套结果支持延迟加载。fetchType="lazy"

#### 小结

- MyBatis中映射文件的作用？
- 一对一映射。
- 多对一映射。
- 一对多映射。
- 嵌套结果和嵌套查询的区别

### 总结

- MyBatis是支持普通SQL查询，存储过程和高级映射的优秀持久层框架
- 在MyBatis的配置文件中配置全局的参数、数据连接和SQL映射文件的位置，并可以为结果类型映射别名
- 在SQL映射文件中为提供了select、insert、update、delete等元素实现SQL语句的映射，结果类型的映射可以使用resultMap和resultType，但不能同时使用