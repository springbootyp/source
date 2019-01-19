## 第三章  MyBatis动态SQL及缓存

### 本章目标

- 动态SQL查询
- 缓存的使用
- 封装MyBatis Util工具类

### 什么是动态SQL

- MyBatis的强大之处便是它的动态SQL，如果你使用JDBC那么在根据不同条件查询时，拼接SQL语句是多么的痛苦。
- 比如查询一个学生信息，可以根据学生的姓名，性别，班级，年龄，学历等信息来查询，并且多个条件可以任意组合。
- 而MyBatis中集成了非常强大的 OGNL表达式，可以帮助我们解决这个问题。

### OGNL表达式

- OGNL：全名是:对象图导航语言(Object-Graph Navigation Language)的缩写，它是一种强大的表达式语言，通过他简单一致的语法，可以存取对象的任意属性，调用对象的方法，遍历整个对象的结构图。
- 在Mybatis中，OGNL可以帮助我们构建动态SQL语句。
- 用于实现动态SQL的元素主要有：
  - if
  - choose(when,otherwise)
  - where
  - set
  - foreach
- 常用操作符：
  - +，-，*，/，==，!=，||，&&
  - and，or，mod，in，notin

#### if标签的使用

- MyBatis中的动态SQL通常作为查询的条件比较多。

- if为Mybatis中的条件判断标签

  ```xml
  <select id="getStudentCondition" parameterType="com.school.entity.Student" resultMap="StudentMap">
  select * from Student where 1=1
      <if test="sname != null and sname != ''">
          <!-- and sname like '%' #{sname} '%' -->
          and sname like concat('%',#{sname},'%')
      </if>
      <if test="sex != null and sex != ''">
          and sex = #{sex}
      </if>
  </select>
  ```


### choose标签的使用

- 有些时候，我们不想用到所有的条件语句，而只想从中择其一二。

- choose标签为Mybatis中的提供多重条件判断，使用when和otherwise标签进行条件判断，多个条件中只有一个被执行。

  ```xml
  <select id="getStudentCondition" parameterType="cStudent" resultMap="StudentMap">
  select * from Student where 1=1
      <choose>
         <when test="sname != null and sname != ''">
              and sname like concat('%',#{sname},'%')
          </when>
          <when test="sex != null and sex != ''">
              and sex = #{sex}
          </when>
          <otherwise>
             and xxx
          </otherwise>
      </choose>
  </select>
  ```

### where标签

- where标签可以替代if和choose标签，不需要添加多余的where 1=1条件。当where中的条件没有一个满足时，不输出where关键字。

  ```xml
  select * from Student
  <where>
      <if test="sname != null and sname != ''">
          and sname like '%' #{sname} '%' 
      </if>
      <if test="sex != null and sex != ''">
          and sex = #{sex}
      </if>
  </where>
  ```

### set标签

- set标签主要用于在update更新值时，动态添加更新的列，如果列没有值则不添加。避免使用多余的,号。

  ```xml
  <update id="updateStudent" parameterType="com.school.entity.Student">
      update Student 
      <set>
          <if test="sname != null and sname != ''">
              sname=#{sname},
          </if>
          <if test="sex != null and sex != ''">
              sex=#{sex},
         </if>
          ……
          <if test="age &gt; 0 and age &lt; 100">
              age=#{age},
          </if>
      </set>
      where sid=#{sid}
  </update>
  ```

### foreach标签

- for标签主要用于循环集合。
- for标签可以支持的集合list、array、map

| 属性         | 描述           |
| ---------- | ------------ |
| item       | 每一次迭代结果      |
| collection | 循环集合或指定类型    |
| open       | 开始符号，可选      |
| close      | 关闭符号，可选      |
| index      | List和数组的序号可选 |

```xml
<!—- 添加多个in值 -->
<select id="selectStudentForList" parameterType="list" resultType="com.school.entity.Student">
    select * from Student where sid in
    <foreach collection="list" index="i" item="item" open="(" separator="," close=")">
         ${item}
    </foreach>
</select>
```

### 其他标签

- sql标签：用来定义常量，通过include来引用

  ```xml
  <sql id="selectStudent">
      select * from Student s
  </sql>
  <select id="getStudentAll" resultMap="StudentMap">
      <include refid="selectStudent" /> inner join Class c on s.cid = c.cid 
  </select>
  ```

- trim标签：替代set或者where

  ```xml
    <!-- 替代set标签 -->
    <!-- 
    当prefix="set"，表示在trim包裹的部分的前面添加 set。 
    当suffixOverrides=","，表示删除最后一个逗号。 
    -->
    <trim prefix="set" suffixOverrides=",">
        <if test="sname != null">sname = #{sname},</if>
    </trim>
    <!-- 替代where标签 -->
    <!--
    prefix：前缀　　　　　　
    prefixoverride：去掉第一个and或者是or
     -->
    <trim prefix="where" prefixOverrides="and|or">
        <if test="sname != null">and sname=#{sname}</if>
    </trim>
  ```

| 属性              | 描述      |
| --------------- | ------- |
| prefix          | 以什么开头   |
| suffix          | 以什么结尾   |
| prefixOverrides | 替换开头的符号 |
| suffixOverrides | 替换结尾的符号 |

### 小结

- 什么是动态SQL。
- MyBatis中常用的OGNL表达式。

### 缓存

MyBatis同大多数ORM框架一样，提供了一级缓存和二级缓存的支持。

- 一级缓存：其作用域为session范围内，当session执行flush或close方法后，一级缓存会被清空。
- 二级缓存：二级缓存和一级缓存机制相同，但是可以自定义其作用范围，如Ehcache。

![2062729-5db625158ece8c7a](http://www.znsd.com/znsd/courses/uploads/f498ad05a06c26e30d87b058148c5cea/2062729-5db625158ece8c7a.png)

### 一级缓存

- 默认情况下，MyBatis中的一级缓存是开启的。下面测试一级缓存。

  ```java
  StudentMapper mapper = session.getMapper(StudentMapper.class);
  Student stu1 = mapper.selectOne(1);
  System.out.println(stu1);

  // 执行两次查询，第二次查询并没有向数据库中发送sql语句。
  Student stu2 = mapper.selectOne(1);
  System.out.println(stu2);
  ```

### 清除一级缓存

一级缓存作用范围在当前session中有效，sesion会在以下情况下清除缓存。

- 不同session缓存失效
- 调用clearCache()
- 当执行了CRD方法后
- close()/commit()

### 二级缓存

MyBatis中使用二级缓存也非常简单，只需要在对应的mapper映射文件中使用\<cache />标签开启二级缓存即可。

- 映射语句文件中的所有 select 语句将会被缓存。
- 映射语句文件中的所有 insert,update 和delete 语句会刷新缓存。
- 缓存会使用 LeastRecently Used(LRU,最近最少使用的)算法来收回。
- 根据时间表(比如 noFlush Interval,没有刷新间隔), 缓存不会以任何时间顺序来刷新。
- 缓存会存储列表集合或对象(无论查询方法返回什么)的1024 个引用。
- 缓存会被视为是 read/write(可读/可写)的缓存,意味着对象检索不是共享的,而且可以安全地被调用者修改,而不干扰其他调用者或线程所做的潜在修改。

```java
StudentMapper mapper = session.getMapper(StudentMapper.class); // 二级缓存的实体类，必须实现了Serializable接口。
Student stu1 = mapper.selectOne(1);
System.out.println(stu1);
session.close(); // 二级缓存在不同session之间缓存时，前面的session对象必须调用comit()或close()之后才有效果。
session = factory.openSession();
StudentMapper mapper2 = session.getMapper(StudentMapper.class);
Student stu2 = mapper2.selectOne(1);
System.out.println(stu2);
```

### 二级缓存的属性

- \<cache/>标签常见属性

```xml
<cache eviction="FIFO" flushInterval="60000" size="512"
  readOnly="true"/>
```

| 属性            | 说明                                       |
| ------------- | ---------------------------------------- |
| eviction      | 缓存的回收策略。      LRU：最近最少使用的，移除长时间不使用的缓存。（默认）      FIFO：先进先出，按缓存进入的顺序移除它们。       SOFT：软引用，移除基于垃圾回收器状态和软引用规则的对象。       WEAK：弱引用，更积极地移除基于垃圾收集器状态和弱引用规则的对象。 |
| flushInterval | 缓存的刷新间隔，默认情况下不刷新。                        |
| size          | 设置可以缓存对象的数量。默认为1024                      |
| readOnly      | 设置缓存是否是只读。默认为false                       |

### 全局二级缓存

**配置二级缓存的步骤**

- MyBatis的全局cache配置

  ```xml
  <settings>
      <setting name="cacheEnabled" value="true"/>
  </settings>
  ```

- 在Mapper XML文件中设置缓存，默认情况下是没有开启缓存的

  ```xml
  <cache eviction="FIFO" flushInterval="60000" size="512" readOnly="true"/>
  ```

- 在Mapper XML文件配置支持cache后，如果需要对个别查询进行调整，可以单独设置cache

  ```xml
  <select id="selectAll" resultType=" Student" 
          useCache="true">
  ```

### 获取插入后的自动增长主键

- 获取插入后的自动增长列的值

  ```xml
  <insert id="addStudent" parameterType="com.school.entity.Student" useGeneratedKeys="true" keyProperty="sid"> <!-- 查询后的结果保存到sid中 -->
  insert into Student (sname,sex,age,address) values(#{sname},#{sex},${age},#{address})
  </insert>
  ```

### 练习：一级缓存和二级缓存

- 练习一级缓存和二级缓存的使用。

### 升级MyBatisUtil工具类

```java
public class MyBatisUtil {

	private static final String MYBATIS_CONFIG_XML = "mybatis-config.xml";
	private static SqlSessionFactory sqlSessionFactory;
	private static ThreadLocal<SqlSession> sessionThreadLocal = new ThreadLocal<SqlSession>();
	
	static {
		
		try {
			// 加载mybatis配置文件
			InputStream inputStream = Resources.getResourceAsStream(MYBATIS_CONFIG_XML);
			sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
		} catch (IOException e) {
			e.printStackTrace();
			throw new ExceptionInInitializerError("加载sessionFactory异常，请检查mybatis-config.xml文件");
		}
	}
	
	/**
	 * 获取session对象
	 * @return
	 */
	public static SqlSession getSession() {
		// sessionThreadLocal的get()方法根据当前线程返回其对应的线程内部变量，
		// 也就是我们需要的Session，多线程情况下共享数据库链接是不安全的。
		// ThreadLocal保证了每个线程都有自己的Session。
		SqlSession session = sessionThreadLocal.get();
		if (session == null) {
			session =sqlSessionFactory.openSession();
			sessionThreadLocal.set(session);
		}
		return session;
	}
	
	/**
	 * 关闭当前线程对象
	 */
	public static void closeSession() {
		SqlSession session = sessionThreadLocal.get();
		if (session != null) {
			session.close();
		}
		sessionThreadLocal.set(null);
	}
}
```

**MyBatis核心类生命周期和管理**

- SqlSessionFactoryBuilder
- SqlSessionFactory
- SqlSession

### 学员操作——SqlSession的工具类

- 需求说明：使用SqlSession的工具类改造上机练习3的实现方法

### 总结

- 在SQL映射文件中使用if、choose、where、set实现动态SQL的映射.
- MyBatis中一级缓存和二级缓存