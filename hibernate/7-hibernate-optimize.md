## 第六章    Hibernate性能优化

### 本章目标 

- 对Hibernate进行性能优化`重点`
- 理解Hibernate缓存`难点`
- 掌握Hibernate的数据批量操作
- 掌握Hibernate的c3p0连接池配置`重点`

### 如何对Hibernate进行性能优化 

- 数据库设计
- HQL优化
- 配置参数
- 方法使用
- 缓存管理

### HQL 优化

#### HQL 优化3-1

- `避免or操作 `

- where 子句包含or 操作，执行时不使用索引，`可以使用in条件来替换`

  ```sql
  from Student where student_id = '1000' or student_id = '1001'
  ```

- 改成

  ```sql
  from Student where student_id in ('1001','1000')
  ```

#### HQL 优化3-2

- `避免使用not `

- where 子句包含not 关键字，执行时该字段的索引失效 ，`使用比较运算符替换not`

  ```sql
  from Student as s where not (s.age > 18)
  ```

- 改成

  ```sql
  from Student as s where s.age <= 18
  ```

#### HQL 优化3-3

- 避免like的特殊形式：查询时，尽可能少使用like 
- 避免having子句：尽可能在where 子句中指定条件
- 避免使用distinct：在不要求或允许冗余时，应避免使用distinct

### Hibernate缓存 

- 缓存是计算机领域的概念，它介于应用程序和永久性数据存储源之间 

- 当我们频繁访问数据库时，尤其像Hibernate持久层框架，会导致数据库访问性能降低，因此我们期望有一种机制能提供一个"缓存空间"，我们将需要的数据复制到这个"缓存空间"，当数据查询时，我们先在这个"缓存空间"里找，如果没有，我们再去数据库查找，这样就减少了与数据库的访问，从而提高了数据库访问性能，这就是缓存机制。

- Hibernate的缓存一般分为3类： 

  - 一级缓存：Hibernate默认的缓存机制，它属于Session级别的缓存机制，也就是说Session关闭，缓存数据消失。 

  - 二级缓存：属于SessionFactory级别的缓存，二级缓存是全局性的，应用中的所有Session都共享这个二级缓存。 

    二级缓存默认是关闭的，一旦开启，当我们需要查询数据时，会先在一级缓存查询，没有就去二级缓存，还没有，再去数据库，因此缓存机制大大提高了数据库的访问性能。 

  - 查询缓存

  ![image](http://www.znsd.com/znsd/courses/uploads/2159fa5d879be570ff7071f96a6aa383/image.png)

#### Hibernate一级缓存 

- Session内的缓存即一级缓存，由Hibernate来维护，用户无法关闭一级缓存。 
- 当用户使用save(),update(),saveOrupdate(),get(),load(),list(), iterate()时，系统会自动将持久化对象写入到一级缓存。 
- Session为应用程序提供了管理缓存的方法: 
  - flush()
  - evict(Object o)
  - clear()

#### 一级缓存管理

- 演示两个get方法
- 演示evict()和clear()方法
- 演示跨session的两个get方法
- 演示list()和iterate()方法
- 演示save()和get()方法

### 批量处理数据

- 一级缓存并不一定一定能提高性能，有些时候可能也会降低性能。
- 批量处理数据是指在一个事务场景中处理大量数据。
- Hibernate提供了进行批量处理数据的方法：
  - 使用Session进行批量操作
  - 使用HQL进行批量操作
  - 使用JDBC API进行批量操作

### Hibernate中的批量插入 

- 有些时候，使用hibernate需要批量添加数据，一下代码使用hibernate进行批量插入。 

  ```java
  Session session = sessionFactory.openSession();
  Transaction tx = session.beginTransaction();
  for ( int i=0; i<100000; i++ ) {
      Employee employee = new Employee(.....);
      session.save(employee);
  }
  tx.commit();
  session.close();
  ```

- Hibernate会将所有持久对象添加到缓存，如果插入大量数据有可能导致内存溢出。 

- 所以在进行批量插入时，需要进行资源的释放。

  ```java
  Session session = SessionFactory.openSession();
  Transaction tx = session.beginTransaction();
  for ( int i=0; i<100000; i++ ) {
      Employee employee = new Employee(.....);
      session.save(employee);
      // 每次插入20条记录时就释放session保存到数据库
      if(i%20==0){
   		session.flush();
   		session.clear();
      }
  }
  tx.commit();
  session.close();
  ```

- `使用批量插入方式，需要在配置文件中添加hibernate.jdbc.batch_size设置批量操作数。`

#### Hibernate二级缓存 

- 一级缓存无法实现跨session的数据共享。
- 二级缓存是进程或集群范围内的缓存，可以被多个的Session共享
- 二级缓存是第三方缓存，可配置的插件
- 常用二级缓存插件：

| 插件名称   | 缓存实现类                                                   |
| ---------- | ------------------------------------------------------------ |
| EHCache    | org.hibernate.cache.EhCacheProvider(已过期)   org.hibernate.cache.ehcache.EhCacheRegionFactory |
| OSCache    | org.hibernate.cache.OSCacheProvider                          |
| SwarmCache | org.hibernate.cache.SwarmCacheProvider                       |
| JBossCache | org.hibernate.cache.TreeCacheProvider                        |



#### 使用二级缓存的步骤  

1. 选择合适的缓存插件，配置其自带的配置文件。

2. 选择需要使用二级缓存的持久化类，设置它的二级缓存的并发访问策略。

   ```xml
   <!-- 启动二级缓存，默认为启动 -->
   <property name="hibernate.cache.use_second_level_cache">true</property>
   <!-- 启动二级缓存ehcache插件 -->
   <property name="hibernate.cache.region.factory_class">org.hibernate.cache.ehcache.EhCacheRegionFactory</property>
   ```

#### 二级缓存配置 

在实体类中配置缓存有两种方式

1. 直接在实体类映射文件添加\<cache />标签进行配置

   ```xml
   <hibernate-mapping>
   	<class name="com.znsd.hibernate.model.Student" table="t_student">
            <!--读写缓存-->
   		<cache usage="read-write"/>
       </class>
   </hibernate-mapping>
   ```

2. 在hibernate.cfg.xml文件中进行配置。（`推荐使用`）

   ```xml
   <hibernate-configuration>
   	<session-factory>
   		<mapping resource="com/znsd/hibernate/model/Student.hbm.xml" />
            <!--必须要放在映射文件之后，否则会报错-->
   		<class-cache usage="read-write" class="com.znsd.hibernate.model.Student"/>
   	</session-factory>
   </hibernate-configuration>
   ```

#### 二级缓存配置属性 

@cache注解用来设置二级缓存： 

- usage：指定缓存策略，可选的策略包括 

  - read-only：只读策略。
  - read-write：读写策略`常用`。
  - nonstrict-read-write：非严格读写。
  - transactional：事务缓存。

- include:是否缓存延迟加载的属性。

  - all：缓存所有对象。
  - no-lazy：表示不存在延迟加载属性。

- region：指定缓存在配置文件中的名称。

  ```java
  @Entity
  @Table(name = "t_student")
  @Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
  public class Student implements Serializable {
      @Id
  	@GeneratedValue
  	private Integer id;
  	private String name;
  	private Integer age;
      // 忽略set、get方法
  }
  ```

  

#### EhCache配置文件中缓存参数

- \<diskStore path="java.io.tmpdir"/>  配置硬盘上缓存路径 
- \<cache>标签配置说明
  - name:缓存名称
  - maxElementsInMemory：缓存对象的数量
  - eternal：是否为永久的,false为结束后清空。
  - timeToLiveSeconds：缓存的对象可以被缓存多少秒。
  - timeToIdleSecond：缓存的对象多少秒没有使用就会清理。
  - overflowToDisk：溢出时是否存储在硬盘上，配合前面path属性。

```xml
<cache name="sampleCache1"
        maxElementsInMemory="10000"
        eternal="false"
        timeToIdleSeconds="300"
        timeToLiveSeconds="600"
        overflowToDisk="true"
        />
```

#### 一级缓存和二级缓存的区别 

**一级缓存**

- 一级缓存是hibernate自带缓存，由系统进行维护和管理。
- 一级缓存生命周期为session范围。
- 当session关闭时，一级缓存中的内容会被清空。

**二级缓存**

- 二级缓存是基于第三方，需要另外引入jar包。
- 由用户手动配置和维护二级缓存。
- 二级缓存生命周期为sessionFactory范围。
- 当sessionFactory关闭时，二级缓存中的内容会被清空。

### Hibernate缓存——查询缓存

- 查询是数据库技术中最常用的操作，Hibernate为查询提供了查询缓存，用来提高查询速度，优化查询性能。

- 查询缓存依赖于二级缓存，要使用查询缓存必须先开启二级缓存。

  ```xml
  <!-- 启动查询缓存 -->
  <property name="hibernate.cache.use_query_cache">true</property>
  ```

- 在代码中也必须手动启动查询缓存

  ```java
  query.setCacheable(true);
  ```

- 查询缓存测试

  ```java
  @Test
  	public void testQueryCache() {
  		Session session = sessionFactory.getCurrentSession();
  		session.beginTransaction();
  		
  		List<Student> students = session.createQuery("from Student").setCacheable(true).list();
  
  		List<Student> students2 = session.createQuery("from Student").setCacheable(true).list();
  		
  		session.getTransaction().commit();
  	}
  ```

  ![20180627212935](http://www.znsd.com/znsd/courses/uploads/53829d8ca158d7f7211821baa65ba2c9/20180627212935.png)

  ![20180627213158](http://www.znsd.com/znsd/courses/uploads/3b409bc20fe20940a6c0e8d78988c8f1/20180627213158.png)

### 学员操作——Hibernate缓存 

需求说明 

- 在测试类中完成批量插入50条学生信息
- 在学生系统Web应用中，在两次请求中按同一主键值查找学生信息，应只执行一条select语句
- 在学生系统Web应用中，在两次请求中查询年龄小于20的的学生信息，应只执行一条select语句

提示 

- 按步骤配置二级缓存和查询缓存

### 学员操作——批量处理数据

需求说明 

使用HQL语句批量修改学生信息的年龄，所有学生年龄大于20岁的，性别改成女。 

### 小结 

- Hibernate一级缓存的作用
- Hibernate二级缓存和一级缓存的区别
- 请说出使用查询缓存的步骤
- 批量添加数据。

### 数据连接池 

连接池技术是提高数据访问的一个必备技术，Hibernate中可以支持多种连接池技术。 

- 默认连接池
- JNDI连接池
- c3p0
- proxool

### c3p0连接池配置

采用c3p0方式配置连接池 

```xml
<!-- c3p0连接池类 -->
<property name="connection.provider_class">org.hibernate.c3p0.internal.C3P0ConnectionProvider</property>
<!-- 最大连接数 -->    
<property name="c3p0.max_size">20</property>
<!-- 初始连接数 -->    
<property name="c3p0.min_size">5</property>
<!-- 数据库连接对象最大持有时间（以秒为单位） -->    
<property name="c3p0.timeout">120</property>
<!-- 最大可缓存数据库语句对象，设为0则不缓存 -->
<property name="c3p0.max_statements">100</property>
<!-- 在连接空闲多少秒后，检查连接 --> 
<property name="c3p0.idle_test_period">120</property>
<!-- 当连接池耗尽并接到获得连接的请求，则新增加连接的数量 -->
<property name="c3p0.acquire_increment">2</property>
<!-- 是否检查联接 -->
<property name="c3p0.validate">false</property>
```

### 总结

- Session管理缓存的方法：
  - evict()
  - clear()方法。
- 批量处理的方法： 
  - 通过HQL进行批量操作
  - 通过JDBC API进行批量操作
  - 通过Session进行批量操作。
- HQL支持各种各样的连接查询 