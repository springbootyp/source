## 第三章  HQL查询语句

### 本章目标

- 掌握Query接口`重点`
- 掌握HQL的基本使用`重点`
- 理解并使用动态参数绑定实现数据查询`重点`
- HQL关联查询`重点（难点）`
- HQL子查询
- HQL命名查询`重点`

### 什么是HQL

- HQL： Hibernate Query Language，
- HQL是Hibernate专用的查询语言，这种语言和SQL看上去很像，但是不要被外表所迷惑，HQL是一种完全面向对象的语言。
- `在HQL中只能出现类和属性，不能出现数据库表和字段。`

### HQL初体验

- 使用SQL语句的查询

  ```sql
  SELECT name,pass FROM student where name like '张%';
  ```

- 使用HQL语句实现同样的功能

  ```sql
  select s.name,s.pass from Student s where name like '张%';
  ```

- `除了对类和属性的名称外，HQL对大小写并不敏感。select和SELECT是相同的。但是Student和student并不一致。`

### 执行HQL语句

- list()方法查询示例

  ```java
  session = sessionFactory.openSession();
  String hql = "from Student";
  Query query = session.createQuery(hql);
  List<Student> list = query.list();
  ```

- list方法查询时hibernate生成的sql

  ```sql
  Hibernate: 
      select
          student0_.id as id1_0_,
          student0_.name as name2_0_,
          student0_.age as age3_0_,
          student0_.gender as gender4_0_ 
      from
          t_student student0_
  Student [id=1002, name=王武, age=25, gender=男]
  Student [id=1003, name=李四, age=22, gender=女]
  ```

- iterate()方法查询示例

  ```java
  session = sessionFactory.openSession();
  String hql = "from Student";
  Query query = session.createQuery(hql);
  Iterator<Student> iterate = query.iterate();
  ```

- iterate方法查询时生成的sql

  ```sql
  Hibernate: 
      select
          student0_.id as col_0_0_ 
      from
          t_student student0_
  Hibernate: 
      select
          student0_.id as id1_0_0_,
          student0_.name as name2_0_0_,
          student0_.age as age3_0_0_,
          student0_.gender as gender4_0_0_ 
      from
          t_student student0_ 
      where
          student0_.id=?
  Student [id=1002, name=王武, age=25, gender=男]
  Hibernate: 
      select
          student0_.id as id1_0_0_,
          student0_.name as name2_0_0_,
          student0_.age as age3_0_0_,
          student0_.gender as gender4_0_0_ 
      from
          t_student student0_ 
      where
          student0_.id=?
  Student [id=1003, name=李四, age=22, gender=女]
  ```

- list()和iterate()方法都可以执行HQL语句，但两者有一些差别，通过输出的SQL语句我们可以看到`list是立即执行，将数据一次全部拿出来，会将数据放入session一级缓存中。iterate是延迟执行，查询次数为n+1次，首先将所有id拿出来，然后通过id进行查询，如果id再session一级缓存中存在，那么直接输出，如果id不存在，则去数据库再查一次。`

### HQL返回自定义列 

- 当HQL只查询一列数据时，使用当前属性的类型作为List的泛型类型。

  ```java
  String hql = "select name from Student";
  Query query = session.createQuery(hql);
  List<String> list = query.list();
  for (int i = 0; i < list.size(); i++) {
  		System.out.println(list.get(i));
  }
  ```

- 如果查询返回多个列的数据时，使用Object[]作为List的泛型类型。

  ```java
  Query query = session.createQuery(hql);
  List<Object[]> list = query.list();
  for (int i = 0; i < list.size(); i++) {
  	System.out.println(list.get(i)[0]);
  	System.out.println(list.get(i)[1]);
  }
  ```

- 当HQL返回多列时，可以使用构造器来生成查询结果

  ```java
  // 必须要在Student属性类中加上Student(name,age)的构造方法
  String hql = "select new Student(name,age) from Student";
  Query query = session.createQuery(hql);
  List<Student> list = query.list();
  ```

- 当查询返回多个列的数据时，使用List作为List的泛型类型。

  ```java
  Session session = this.sessionFactory.openSession();
  String hql = "select new List(name,age) from Student";
  Query query = session.createQuery(hql);
  List<List> list = query.list();
  ```

### HQL返回单条数据

**当HQL返回单条记录时，可以uniqueResult()方法**

```java
// 获取唯一对象
String hql = "from Student where id = 1";
Query query = session.createQuery(hql);
Student stu = (Student)query.uniqueResult();
System.out.println(stu);
```

`uniqueResult()只能返回单行记录，如果查询结果中包含多条记录，那么会抛出org.hibernate.NonUniqueResultException: query did not return a unique result: 2 异常。`

### 分页查询

```java
int pageSize = 10;
Session session = this.sessionFactory.openSession();
String countHQL = "select count(*) from Student";
// 获取总记录数
int count =  ((Long)session.createQuery(countHQL).uniqueResult()).intValue();
// 计算总页数
int totalpages = (count % pageSize == 0) ? (count / pageSize) : (count / pageSize + 1);
int pageIndex = 1;

String pageHQL = "from Student";
Query query = session.createQuery(pageHQL);
// 设置开始位置
query.setFirstResult((pageIndex - 1) * pageSize);
// 设置每页最大数
query.setMaxResults(pageSize);

List<Student> deptList = query.list();
```

### 常用HQL查询

- 查询所有字段

  ```sql
  from Student
  ```

- 给查询对象取别名

  ```sql
  from Student s
  ```

- 指定查询的列名

  ```sql
  select s.name,s.age from Student s
  ```

- 返回Object[]数组的查询

  ```sql
  select  xxx,xxx,xxx from Student -- 如果查询单个值，返回结果为Object。
  ```

- 返回List查询 select new List(xx,xx,xx) from xx

  ```java
  String hql = "select new List(xx,xx,xx) from Student";
  List<List> list = query.list();// 通过下标的方式访问数据
  ```

- 返回Map查询结果

  ```java
  select new Map(xxx,xxx,xxx) from Student;    
  List<Map> list = query.list();  // 默认采用"0"来获取列，如果取了别名可以通过别名来获取数据。
  ```

- 返回自定义类型结果

  ```sql
  select new Student(s.name,s.sex.s.address) from Student
  -- 读取方法和实体类一致。注意：添加了有参构造器后还是需要添加默认的构造器
  ```

- Distinct关键字

  ```sql
  select distinct sex from Student
  ```

- uniqueResult方法

  ```java
  Student stu = (Student)query.uniqueResult();
  ```

### where子句的使用

**比较运算**

- =，<>，<，>，>=，<=

  ```sql
  from Student where age > 20;
  ```

- HQL会将=null和<>null解析为isnull和isnot null。

  ```sql
  from Student where name = null;
  ```

- 范围运算 [not]in (值1，值2)

  ```sql
  from Student where cid in(1,2);
  ```

- between 值1 and 值2

  ```sql
  from Student where age 20 and 25;
  ```

- like通配符%

  ```sql
  from Student where name like '张%'
  ```

- and，or，not

  ```sql
  from Student where name like '张%' and age > 20;
  ```

- is [not] empty，集合是否为空

  ```sql
  from Clazz c where c.studentSet is not empty;
  ```

### 其他基本查询

- order by

  ```sql
  from Student order by name asc,age desc,id
  ```

- group by

  ```sql
  select count(s),s.cid from Student s group by s.cid;
  ```

  - sum
  - avg
  - count
  - max
  - min

- having

  ```sql
  select count(s),s.cid from Student s group by s.cid having count(s) > 30
  ```

### 学员操作——查询用户信息

需求说明

- 查询用户表中的所有记录
- 查询用户名是zhang开头的用户

### 小结

- 给查询对象获取别名
- HQL中的条件语句。
- HQL的order by，group by，having语句。
- 返回list()和返回iterate()的区别。


### 在HQL查询语句中绑定参数

- 以下HQL语句是否合适？ 

  ```java
  String hql = "from User where name ='" + name + "'";
  ```

- 分析：性能低，不安全，不能防止SQL注入。

- Hibernate提供了两种方式为hql语句传递参数

  - 根据索引传递参数
  - 根据名称传递参数

#### 索引方式传递参数

- 通过占位符的方式传递参数

  ```java
  String hql = "from Student where id = ?";
  Query query = session.createQuery(hql);
  query.setInteger(0,1); // 设置第一个?的参数
  List<Student> list = query.list();
  ```

- 通过数字占位符方式传递参数

  ```java
  String hql = "from Student where id = ?1 and name=?2";
  Query query = session.createQuery(hql);
  query.setInteger("1",1);//使用字符串"1"作为占位符
  query.setString("2", "李四");
  List<Student> list = query.list();
  ```

#### 命名方式传递参数

- 通过命名参数的方式传递参数

  ```java
  String hql = "from Student where id = :id and name = :name";
  Query query = session.createQuery(hql);
  query.setInteger("id", 1);
  query.setString("name", "李四");
  List<Student> list = query.list();
  ```

- `命名参数为hibernate4之后所新增的参数绑定方式，这种方式更加直观，更加方便，所以推荐使用这种方式。`

#### 命名方式传递集合参数

- 通过命名参数的方式传递集合类型的参数

  ```java
  Session session = this.sessionFactory.openSession();
  String hql = "from Student where id in(:ids)";
  Query query = session.createQuery(hql);
  query.setParameterList("ids", new Object[]{1, 2, 3});
  List<Student> list = query.list();
  ```

- 命名参数传递like参数

  ```java
  String hql = "from Student where name like :name";
  Query query = session.createQuery(hql);
  query.setString("name", "王%");
  List<Student> list = query.list();
  ```

### 实现动态查询

**问题**

- 查找出符合以下条件的员工信息：
  - 职位是店员，如：job= "CLERK"
  - 工资大于1000元，如：salary> 1000
  - 入职时间在1981年4月1日至1985年9月9日之间 

**分析**

- 条件最多有3个
- 条件个数不确定
- 动态设置查询参数的方式

### 学员操作——查询学生信息

需求说明：查询学生系统中符合以下条件的学生信息：

- 标题中包括"张"字样
- 年龄大于20岁
- 姓名是李阳
- 最近一个月内注册的学生信息
- 按班级信息查询

### 学员操作——分页显示学生信息

需求说明：在上机练习1的基础上，按以下要求，显示输出学生系统的学生信息。

- 每页输出3条记录
- 每条记录显示学生的姓名和电话

### 小结

- 使用HQL查询，参数绑定形式有哪几种？
- 绑定各种类型参数的方法有哪些？
- 查询最新添加的前5条学生信息

### HQL联接查询

**Hibernate支持两种连接查询**

- 一种使用.方式(隐式)

  ```java
  String hql = "from Student s where s.clazz.name = '1班'";
  Query query = session.createQuery(hql);
  List<Student> list = query.list();
  ```

- 另一种使用联接关键字(显式)

  ```java
  String hql = "from Student inner join fetch s.clazz";
  Query query = session.createQuery(hql);
  List<Student> list = query.list();
  ```

- `隐式联接会转换为交叉联接，显示联接会转换为对应的inner join,left join,right jion联接，性能更高`。

- HQL支持的联接类型

| 联接类型   | HQL语法                                    | 适用范围                               |
| ------ | ---------------------------------------- | ---------------------------------- |
| 内联接    | inner join 或 join                        | 适用于有关联关系的持久化类，并且在映射文件中对这种关联关系中作了映射 |
| 迫切内联接  | inner join fetch或 join  fetch            |                                    |
| 左外联接   | left outer join或 left join               |                                    |
| 迫切左外联接 | left outer join fetch或 left join  fetch  |                                    |
| 右外联接   | right outer join 或right  join            |                                    |
| 迫切右外联接 | right outer join fetch 或 right  join fetch |                                    |
| 完整外联接  | full outer join 或full join               |                                    |

#### 内联接

- Hibernate的内联接语法如下

  ```sql
  from Entity inner join [fetch] Entity.property
  ```

- 例子

  ```java
  // Query query = session.createQuery("from Student d inner join fetch d.cls s");
  // 忽略fetch 关键字，我们得到的结果集中，每行数据都是一个Object 数组，加上fetch我们得到的是具体类的类型
  Query query = session.createQuery("from Student d inner join d.cls s");
  List result = query.list();
  Iterator it = result.iterator();
  while(it.hasNext()){
    	Object[] results = (Object[]) it.next();
    	System.out.println("数据的类型：");
    	for (int i=0;i<results.length;i++){
      	System.out.println(results[i]);
    	}
  }
  ```

- 生成的sql

  ![20180522165833](http://www.znsd.com/znsd/courses/uploads/003996353dea5b295647ecbb3f19871f/20180522165833.png)

#### 左外联接

- Hibernate的左外联接语法如下

  ```sql
  from Entity left join [fetch] Entity.property
  ```

- 例子

  ```java
  Query query = session.createQuery("from Student d left join fetch d.cls s");
  List result = query.list();
  for (Object o : result) {
  	Student student = (Student) o;
  	System.out.println(student.getName() + "所在班级" + student.getCls().getName());
  }
  ```

- 生成的sql

  ```sql
  Hibernate: 
      select
          student0_.id as id1_1_0_,
          classes1_.id as id1_0_1_,
          student0_.name as name2_1_0_,
          student0_.age as age3_1_0_,
          student0_.gender as gender4_1_0_,
          student0_.clsId as clsId5_1_0_,
          classes1_.name as name2_0_1_ 
      from
          t_student student0_ 
      left outer join
          t_classes classes1_ 
              on student0_.clsId=classes1_.id
  王武所在班级1班
  李四所在班级1班
  王武所在班级1班
  22所在班级2
  ```

#### 右外联接

- Hibernate的右外联接语法如下

  ```sql
  from Entity right join [fetch] Entity.property
  ```

- 例子

  ```java
  Query query = session.createQuery("from Student d right join fetch d.cls s");
  List result = query.list();
  for (Object o : result) {
  	Student student = (Student) o;
  	System.out.println(student.getName() + "所在班级" + student.getCls().getName());
  }
  ```

- 生成的sql

  ```sql
  Hibernate: 
      select
          student0_.id as id1_1_0_,
          classes1_.id as id1_0_1_,
          student0_.name as name2_1_0_,
          student0_.age as age3_1_0_,
          student0_.gender as gender4_1_0_,
          student0_.clsId as clsId5_1_0_,
          classes1_.name as name2_0_1_ 
      from
          t_student student0_ 
      right outer join
          t_classes classes1_ 
              on student0_.clsId=classes1_.id
  王武所在班级1班
  李四所在班级1班
  王武所在班级1班
  22所在班级2
  ```

#### 练习——联接查询的使用

需求说明：

- inner join fetch的使用
- 查询班级下面的所有学生信息

### 多态查询

- HQL语句被设计成能理解多态查询，from后跟持久化类名，不仅会查询出该持久化类的全部实例，还会查询该类的子类的全部对象。

  ```java
  //查询Object，返回所有持久化类对象
  String hql = "from java.lang.Object o";
  List<Object> list = session.createQuery(hql).list();
  System.out.println(Arrays.toString(list.toArray()));
  ```

### 批量更新，删除

- 前面已经hibernate给我们提供了update和delete来实现增加和删除，但是当批量修改时，会比较麻烦，而且效率比较低，hql中也可以使用update和delete来实现批量更新和删除。

  ```java
  Transaction ts = session.beginTransaction();
  String hql = "update Student set name = :name where id=:id";
  Query query = session.createQuery(hql);
  query.setInteger("id", 1);
  query.setString("name", "888888");
  int count = query.executeUpdate();
  ts.commit();
  ```

- 删除操作也更新类似。直接将hql语句换成delete即可

  ```java
  Transaction ts = session.beginTransaction();
  String hql = "delete Student where id<:id";
  Query query = session.createQuery(hql);
  query.setInteger("id", 1004);
  int count = query.executeUpdate();
  ts.commit();
  ```

- `使用hql语句方式是不支持级联操作，所以这里一定要注意。更新之后缓存也没有被更新，所以这种操作要谨慎。`

### HQL子查询

如果在子查询中操作集合，HQL提供了一组操纵集合的函数和属性：

- size()函数和size属性：获得集合中元素的数量

- minIndex()函数和minIndex属性：对于建立了索引的集合获得最小索引值（关于集合索引参考第一部分映射值类型集合）

- minElement()函数和minElement属性：对于包含基本类型的元素集合，获得集合中值最小的元素

- maxElement()函数和maxElement属性：对于包含基本类型元素的集合，获得集合中值最大的元素

- element()函数：获得集合中所有元素

  ```sql
  -- 查询订单数大于0的客户
  From Customer c where size(c.orders)>0;
  -- 或者
  From Customer c where c.orders.size>0;
  ```

  ​

### 命名查询

- 命名查询是值将hql语句些在Xxxx.hbm.xml配置文件中。然后在类中可以直接调用，这样更加方便hql语句的复用。

- 通过命名查询实现HQL查询的步骤

  - 使用\<sql-query>元素定义本地SQL查询语句
  - 与\<class>元素并列
  - 以<![CDATA[SQL]]>方式保存SQL语句
  - 通过Session对象的getNamedQuery()方法获取该查询语句

- 在映射文件中定义字符串形式的查询语句。

- 通过\<query/>标签定义hql查询，必须指定一个不重复的name。

- 查询语句必须使用<![CDATA[HQL]]>标签包起来，避免出现特殊字符错误。比如< >。

  ```xml
  <hibernate-mapping>
      <class name="cn.jbit.hibernatedemo.entity.Emp" table="emp">
          ......
      </class>
      <query name="findStudentByName">
      <![CDATA[
          from Student where username = :name
       ]]>
      </query>
  </hibernate-mapping>
  ```

### 调用命名查询

- 调用命名查询，直接使用session.getNamedQuery()来调用，和普通hql语句用法完全一致。

  ```java
  Query query =session.getNamedQuery("findStudentByName"); 
  query.setString("name", "张三");
  List<Person> list = query.list();
  ```

### 学员操作——完成注册和登录

- 需求说明：在学生系统中，按要求实现以下功能：登录、注册
- 实现思路
  - 页面使用JSP技术负责显示
  - Servlet负责接收请求并给予响应
  - 业务逻辑层由JavaBean完成
  - DAO层使用Hibernate完成
- 完成时间：25分钟

### 小结

- HQL联接查询有几种方式？
- 在映射文件中如何定义命名查询？
- 如何使用本地SQL查询？

### 总结

- HQL（Hibernate Query Language）是面向对象的查询语句
- 执行HQL语句可以采用两种方式：
  - list()方法
  - iterator()方法
- HQL语句中绑定参数的形式有两种：
  - 按参数位置绑定
  - 按参数名字绑定
- HQL支持投影查询、参数查询、分页查询等功能。
- HQL子查询，联接查询