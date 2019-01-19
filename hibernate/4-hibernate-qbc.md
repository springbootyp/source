## 第四章 QBC查询和SQL查询

### 本章目标

- 掌握QBC进行数据查询`重点`
- 掌握QBC样例查询
- 掌握QBC离线查询
- 原生SQL查询`重点`

### 什么是QBC

- QBC：Query By Criterria，是利用HibernateAPI来进行的查询。这种API封装了SQL语句的动态拼装，对查询提供了更加面向对象的功能接口。
- QBC 常用API
  - Criterria：代表一次查询。
  - Criterion：代表一个查询条件。
  - Restrictions：产生查询条件的工具类。
- 好处：在不使用SQL情况下进行查询。

### 使用Criteria查询数据

Criteria查询是Hibernate提供的一种查询方式

- 使用Criteria查询所有的学生

  ```java
  Criteria criteria = session.createCriteria(Student.class);
  List<Student> list = criteria.list();
  ```

- 添加条件，查询学生姓名为张山的

  ```java
  Criteria criteria = session.createCriteria(Student.class);
  criteria.add(Restrictions.eq("name", "张山"));
  List<Student> list = criteria.list();
  ```

### 使用Criteria查询数据——条件查询

- 比较运算

  ```java
  Restrictions.eq();
  ```

- 范围运算

  ```java
  Restrictions.in();
  ```

- 字符串模式匹配

  ```java
  Restrictions.ilike();
  ```

- 逻辑运算

  ```java
  Restrictions.between();
  ```

- 集合运算

  ```java
  Restrictions.isEmpty();
  ```

- Restrictions.eq --> equal,等于.

- Restrictions.allEq --> 参数为Map对象,使用key/value进行多个等于的比对,相当于多个Restrictions.eq 的效果

- Restrictions.gt--> great-than > 大于

- Restrictions.ge--> great-equal >= 大于等于

- Restrictions.lt--> less-than, < 小于

- Restrictions.le --> less-equal <= 小于等于

- Restrictions.between --> 对应SQL的between子句

- Restrictions.like --> 对应SQL的LIKE子句

- Restrictions.in --> 对应SQL的in子句

- Restrictions.and --> and 关系

- Restrictions.or --> or 关系

- Restrictions.isNull --> 判断属性是否为空,为空则返回true  相当于SQL的 is null

- Restrictions.isNotNull --> 与isNull相反    相当于SQL的 is not null

- Restrictions.sqlRestriction --> SQL限定的查询

- Order.asc --> 根据传入的字段进行升序排序

- Order.desc --> 根据传入的字段进行降序排序

- Restrictions.ilike --> 对应SQL的LIKE子句，可以添加匹配参数。

- MatchMode.EXACT--> 字符串精确匹配.相当于"like 'value'"

- MatchMode.ANYWHERE--> 字符串在中间匹配.相当于"like '%value%'"

- MatchMode.START--> 字符串在最前面的位置.相当于"like 'value%'"

- MatchMode.END--> 字符串在最后面的位置.相当于"like '%value'"

### 使用Criteria查询数据——条件查询

- Criterria还支持另一种条件赋值写法。

  ```java
  Criteria criteria = session.createCriteria(Student.class);
  criteria = criteria.add(Property.forName("id").le(1010));
  List<Student> list = criteria.list();
  ```

- `Property.forName()方式和前面方式基本用法是类似的，只是书写方式有些区别而已。`

### 使用Criteria查询数据——动态查询

**问题**

如何查找出符合以下条件的员工信息：

- 职位是工程师，如：job = ‘engineer’
- 工资大于2000元，如：salary> 2000
- 入职时间在2006年12月31日至2008年12月31日之间 

**分析**

- 条件最多有3个，根据用户实际输入确定
- 使用Criteria接口的add()方法加入条件
- 为了避免传递过多的参数，可以把条件封装在JavaBean中


### 学员操作——按条件查询学生信息

需求说明

- 使用Criteria查询所有学生信息
- 使用Criteria查询年龄大于21元的房屋信息
- 使用Criteria查询年龄小于20元并且注册时间在2013年5月以后的学生信息

### 排序

- Criteria查询支持连写，使代码更加简洁，使用addOrder()对集合结果进行排序。

  ```java
  List<Student> list = session.createCriteria(Student.class)
  		        .add(Restrictions.gt("age", 20))
  		        .addOrder(Order.asc("age"))
  		        .addOrder(Order.desc("id")).list();
  //先按年龄升序排序，再按编号编号排序
  ```

### 分页

和HQL查询方式一样，Criteria接口提供了设置分页的方法

- setFirstResult(int firstResult)

- setMaxResult(int maxResult)

  ```java
  List<Student> list = session.createCriteria(Student.class)
  		        .add(Restrictions.isNotNull("age"))
  		        .addOrder(Order.desc("age"))
  		        .setFirstResult(2)
  		        .setMaxResults(4).list();
  //查询出年龄最大的两名员工
  ```

  ​

### 查询唯一对象

- Query和Criteria接口执行查询语句的方法

| 方法             | 说明                     | Query | Criteria |
| -------------- | ---------------------- | ----- | -------- |
| list()         | 返回List集合               | 支持    | 支持       |
| iterate()      | 返回Iterator迭代器，只查询出ID值。 | 支持    | 不支持      |
| uniqueResult() | 返回唯一对象                 | 支持    | 支持       |

```java
Student student = (Student) session.createCriteria(Student.class)
		        .add(Restrictions.isNotNull("age"))
		        .addOrder(Order.desc("age"))
		        .setMaxResults(1)
		        .uniqueResult();
//查询年龄最大的学生
```

### 关联查询

- Criteria接口提供了createCriteria()和createAlias()方法建立内连接， createAlias()并不是创建一个新的criterial对象，只是为原有对象取一个别名。

  ```java
  List<Student> list = session.createCriteria(Student.class)
  		        .add(Restrictions.ilike("name", "王", MatchMode.ANYWHERE)) // 查询学生姓名like王
  		        .createCriteria("cls")
  		        .add(Restrictions.eq("clsName", "1班").ignoreCase()) .list(); // 班级为1班
  ```

  ```java
  List<Student> list = session.createCriteria(Student.class, "s")
  		        .createAlias("cls", "c") // cls 为student类中的cls属性
  		        .add(Restrictions.ilike("s.name", "张", MatchMode.ANYWHERE))
  		        .add(Restrictions.eq("c.clsName", "1班").ignoreCase()).list();
  ```

  ​

### 学员操作——按条件查询员工信息

需求说明

- 分页显示所有员工信息，并按创建时间降序排序
- 查询员工工资大于1500元的员工信息，并分页显示，按工资升序、创建时间降序排序

### 投影查询

- 投影查询实际上是一种基于列的运算，通常用于投影指定的列。还可以完成SQL语句中常用的分组、组筛选等功能。

- Hibernate通过setProjectior设置投影的列，也可以使用Projections.projectionList()来设置多个列。

  ```java
  List<String> list = session.createCriteria(Classes.class)
  		        .setProjection(Property.forName("clsName"))
  		        .list();
  ```

  ```java
  List<Object[]> list = session
  				.createCriteria(Student.class)
  		        .setProjection(Projections.projectionList()
                      .add(Property.forName("name"))
                      .add(Property.forName("age")))
  		       .list();
  ```

### 分组查询

- 在Criteria中使用投影来实现分组统计功能

| 方法              | 说明    |
| --------------- | ----- |
| groupProperty() | 分组    |
| rowCount( )     | 统计记录数 |
| sum()           | 统计总和  |
| avg()           | 统计平均值 |
| max()           | 获取最大值 |
| min()           | 获取最小值 |

```java
List<Object[]> list = session
				.createCriteria(Student.class)
				.setProjection(Projections.projectionList()
						.add(Projections.rowCount())
						.add(Projections.groupProperty("cls"))) // 按班级分组查询学生
				.list();
```

### 样例查询

- 什么是样例查询？

  样例查询是在criterria中传递一个有值的对象，hibernate会自动根据这些有值的对象属性自动生成sql语句，非常方便。

  ```java
  Student student = new Student();
  		student.setName("张山");
  		//student.setGender("男");
  		List<Student> list = session.createCriteria(Student.class)
  		        .add(Example.create(student)).list();
  ```

- 使用样例查询时要注意，如果使用的是基本类型，比如int，hibernate会当这个属性是有值的，所以推荐实体类尽量使用封装类型。

### 离线查询

- 使用session的建议：
  - 最晚打开，最早关闭。
  - 不要长时间打开session。
  - 不要在跨用户使用session。
- 离线查询需要使用DetachedCriteria类。

#### DetachedCriteria

```java
DetachedCriteria dc = DetachedCriteria.forClass(Student.class, "s")
		        .createAlias("s.cls", "c")
		        .add(Restrictions.eq("c.clsName", "1班"))
		        .add(Restrictions.ilike("s.name", "张", MatchMode.ANYWHERE));
		List<Student> list = dc.getExecutableCriteria(session).list(); // 离线查询是在执行时传入session。
```

```java
DetachedCriteria avgSalary = DetachedCriteria
				.forClass(Student.class, "s")
				.setProjection(Property.forName("age").avg()); // 年龄求平均
			List<Student> list = session.createCriteria(Student.class)
			        .add(Property.forName("age").gt(avgSalary)).list(); // 大于平均年龄
```

### 小结

- Restrictions类的作用是什么？
- Criteria接口是否有uniqueResult()方法？
- Criteria查询如何对查询结果排序？
- setFirstResult()方法的作用是什么？
- Criteria查询如何实现关联？
- groupProperty()方法的作用是什么？
- 什么是样例查询？有什么作用？
- DetachedCriteria有什么作用？

### 学员操作——统计查询学生信息

需求说明

- 使用Projections统计各个班级学生的平均年龄
- 使用Projections统计各个班级的平均年龄，并按平均年龄升序排序
- 使用DetachedCriteria查询所有学生信息

### 原生SQL查询

- 除了提供HQL和QBC查询以外，Hibernate还支持原生的SQL查询，原生SQL查询性能更加高，也更加灵活。

- 原生SQL查询是使用底层数据库的SQL特性，来生成一些特殊的查询语句

  ```java
  // 使用SQLQuery对象
  Query query = session
  			    .createSQLQuery("select * from t_student where NAME like :sname and clsId = :clsId")
  				.addEntity(Student.class)
  				.setString("sname", "%张%")
  				.setString("clsId", "2");
  			List<Student> list = query.list();
  ```

### 本地SQL 查询

Hibernate 对本地SQL查询提供了内置的支持

- Session的createSQLQuery()方法返回SQLQuery对象
- SQLQuery接口继承了Query接口
- SQLQuery接口的addEntity()方法将查询结果集中的关系数据映射为对象
- 通过命名查询实现本地SQL查询
  - 使用\<sql-query>元素定义本地SQL查询语句
  - 与\<class>元素并列
  - 以<![CDATA[SQL]]>方式保存SQL语句
  - 通过Session对象的getNamedQuery()方法获取该查询语句

```xml
<!-- 命名查询中使用sql，不推荐使用，影响跨数据库-->
<sql-query name="getStudentByName">
		<return alias="student" class="com.znsd.hibernate.bean.Student"	/>
		<![CDATA[
		SELECT student.id,
	       student.name,
	       student.age,
	       student.gender,
	       classes.id as clsId,
	       classes.name as clsName
	  FROM t_student student
	       LEFT OUTER JOIN t_classes classes ON classes.id = student.clsId 
	  where student.name = :name]]>
	</sql-query>
```

```java
@Test
public void testQuery15() {
		Session session = this.sessionFactory.openSession();
		
		Query query = session
				.getNamedQuery("getStudentByName")
				.setString("name", "张山");
		List<Student> list = query.list();
		
		for (Student s : list) {
			System.out.println(s.getCls().getClsName());
		}
}
```

### 练习——本地SQL的使用

- 需求说明：使用本地SQL查询，查询学生信息以及所在的班级信息

### 命名查询

- \<query>元素用于定义一个HQL查询语句，它和\<class>元素并列

- 以<![CDATA[HQL]]>方式保存HQL语句

- 在程序中通过Session对象的getNamedQuery()方法获取该查询语句

  ```xml
  <query name="getStudentByGender">
        <query-param name="gender" type="string"/>
        <![CDATA[
         from Student where gender = :gender
        ]]>
  </query>
  ```

  ```java
  @Test
  public void testQuery16() {
    	Session session = this.sessionFactory.openSession();
    	Query query = session
      	.getNamedQuery("getStudentByGender")
      	.setString("gender", "女");
    	List<Student> list = query.list();

    	for (Student s : list) {
      	System.out.println(s);
    	}
  }
  ```

### 命名查询

- 命名查询语句是在映射文件中定义字符串形式的查询语句

- 原生SQL查询语句的命名查询

  ```xml
  <sql-query name="getStudentByName2">
  		<return alias="student" class="com.znsd.hibernate.bean.Student"	/>
  		<![CDATA[
  		SELECT {student.*}
  	  FROM t_student student
  	       LEFT OUTER JOIN t_classes classes ON classes.id = student.clsId 
  	  where student.name = :name and student.age = :age]]>
  </sql-query>
  ```

  ```java
  @Test
  public void testQuery17() {
  	Session session = this.sessionFactory.openSession();
  		
  	Query query = session
  			.getNamedQuery("getStudentByName2")
  			.setString("name", "张山")
  			.setInteger("age", 21);
  	List<Student> list = query.list();
  	
  	for (Student s : list) {
  		System.out.println(s);
  	}
  }
  ```

### 总结

- Criteria查询是Hibernate提供的一种查询方式。
- Criteria接口提供的分页查询方法和Query接口的相同，主要是setFirstResult()方法和setMaxResult()方法。
- Criteria查询和HQL查询都支持连接查询，需要注意的是Criteria只支持内连接和迫切左外连接。
- 原生SQL查询。原生SQL命名查询。