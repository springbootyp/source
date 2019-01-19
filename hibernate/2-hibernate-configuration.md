## 第二章  Hibernate映射文件配置

### 本章目标

掌握HIbernate映射文件的配置。`重点`

- 基本配置
- 组件映射
- 集合映射

理解Hibernate的关联映射`重点（难点）`

- 掌握双向向的多对一
- 理解inverse属性、cascade属性
- 双向的多对多映射
- 掌握外键一对一，主键一对一映射

### Hibernate映射文件配置

- Hibernate映射文件是Hibernate功能实现的核心，了解Hibernate映射文件的配置非常重要。
- 一个hibernate-mapping可以包含多个class，也就是一个映射文件可以对应多个持久化类，但是为了程序便于维护，一般一个持久化类对应一个maping文件，文件名为 类名.hbm.xml 相同。

```xml
<hibernate-mapping>
	<class />
	<class />
	……
</hibernate-mapping>
```

### hibernate-mapping相关属性

Hibernate-mapping是映射配置文件的根节点，一般设置的为全局属性，会针对该节点下所有的class起作用。

| 属性名             | 说明                                       |
| --------------- | ---------------------------------------- |
| schema          | 指定数据库的Schema名，如果指定该属性，表名会自动添加schema前缀。   |
| catalog         | 指定数据库的catalog名，如果指定该属性，表名会自动添加catalog前缀。 |
| default-cascade | 默认的级联风格，默认为none，                         |
| default-access  | 指定属性默认的访问策略，默认为property。表示以getter和setter方法访问属性，如果设置为field，则可以直接访问私有的成员变量，不推荐。 |
| default-lazy    | 设置是否默认的延迟加载策略，默认为true。                   |
| `package`       | `指定一个包的前缀，默认该包下的所有class，默认使用该前缀。`        |

### class相关属性

\<class />元素也可以指定schema、catalog、lazy来覆盖\<hibernate-mapping/>中的配置，除此之外，还包含以下属性。

| 属性名                  | 说明                                       |
| -------------------- | ---------------------------------------- |
| name                 | 必选，指定对应的类名，如果没有指定packageage属性，默认为全类名。    |
| table                | 可选，指定映射的数据库表名，如果不写，默认和类名相同。              |
| dynamic-insert       | 可选，指定动态生成insert语句，只插入哪些非空的字段。            |
| dynamic-update       | 可选，指定动态生成update语句，只更新哪些改变过的字段。           |
| mutable              | 可选，指定持久化类是可变对象还是不可变对象，默认为true。但是可以添加和删除。 |
| select-before-update | 指定在更新时先执行一次查询，默认为false，如果为true判断是否被修改过，如果被修改则更新，没有修改则不更新。 |
| where                | 可选，指定一个条件，则所有操作这个实体对象的方式都会添加这个条件。        |

### id相关属性

通常情况下，Hibernate建议为持久化类定义一个标识属性，用于唯一表示某个实例，而该标识属性需要映射到数据库表中的主键。

| 属性名    | 说明                                       |
| ------ | ---------------------------------------- |
| name   | 必选，指定对应持久类对应的属性名。                        |
| column | 可选，指定对应数据库中对应的列名，不指定与属性名相同。              |
| type   | 可选，指定数据类型，即可以是Hibernate的内建类型，也可以使java的封装类型，如果不指定该属性，则由Hibernate自行判断，通常建议指定该属性，这样会保证更好的性能。 |
| access | 可选，指定该属性的访问策略，默认是property，如果指定该属性，会覆盖\<hibernate-mapping>中的default-access属性。 |

### generator主键生成策略

generator：主键生成策略，主要负责根据不同数据库生成不同的数据类型。该属性可以指定以下选项。

| 属性名       | 说明                                                         |
| ------------ | ------------------------------------------------------------ |
| increment    | 为long、short、int主键生成唯一标识。                         |
| identity     | 在DB2、MySql、SqlServer、Sybase等提供identity主键支持的数据库中适用。标识符类型为long、short、int。 |
| sequence     | 在DB2、Oracle等提供sequence支持的数据库中适用。标识符类型为long、short、int。 |
| hilo/seqhilo | 使用一个高/低算法来高效的生成long、short、int类型的标识符。seq为支持序列的数据库，hilo为一般数据库。 |
| guid         | 在MySql或SqlServer中生成一个GUID字符串。                     |
| `assigned`   | 手动分配标识符，如果不指定generator元素时采用的默认策略。    |
| `native`     | 根据底层数据库自动选择identity、sequence或者hilo中的一个。   |
| foreign      | 直接使用另一个关联对象的标识符属性值。                       |

### property相关属性

Hibernate使用property来映射普通属性，常用属性如下。

| 属性名           | 说明                                     |
| ------------- | -------------------------------------- |
| name          | 必填，指定持久化类的属性名称。                        |
| column        | 可选，指定持久化属性对应的数据库字段名。                   |
| type          | 可选，指定该属性的数据类型。                         |
| update/insert | 指定生成update或insert语句时，是否包含该字段。默认值为true。 |
| access        | 指定访问该属性的策略，作用和id中一致。                   |
| lazy          | 指定该属性是否启动延迟加载，默认为false。                |
| unique        | 是否为该属性所映射的数据列添加唯一约束。                   |
| not-null      | 是否为该属性所映射的数据列添加非空约束。                   |
| index         | 是否为该属性所映射的数据列添加索引。                     |
| length        | 指定所映射数据列的长度。                           |
| sacle         | 指定所映射数据列的小数位数，对浮点类型有效。                 |

### Hibernate中的数据类型

在指定id和property时，数据类型type属性的值有如下几种：

- hibernate基本类型：integer、string、character、date、float、timestamp、binary、serializable、object、blob。
- Java全限定类名：java.lang.String、java.util.Date、java.lang.Interge等。作用和上面完全一致。
- 一个可序列化的Java类的类名。
- 用户自定义的类名

### Hibernate的组件

- 组件：是指Hibernate映射的属性不是基本数据类型，而是一个复合类型，用户自定义的类型。
- Student类中包含了一个地址属性，地址属性为一个自定义类型。

```java
public class Student {
    private Address address;   //封装一个自定义类型
}
```

```java
public class Address {
	private String province;  //省份
	private String city;      //城市
	private String region;    //区
}
```

### 组件标签

- 为了映射组件属性，Hibernate提供了\<component/>标签，每个\<component />映射一个组件属性。
- \<component />常见属性如下：

| 属性名    | 说明                   |
| ------ | -------------------- |
| name   | 必选，指定对应持久类对应的属性名。    |
| class  | 必选，指定属性对应的自定义类型完整类名。 |
| insert | 被映射的字段是否出现在insert中。  |
| update | 被映射的字段是否出现在update中。  |

```xml
<!-- 映射组件 -->
<component name="address" class="com.znsd.hibernate.entitys.Address">
	<property name="province"/>
	<property name="city" type="string" />
  	<property name="region" type="string" />
</component>
```

### 映射集合属性

- 在实体类中，集合属性也是非常常见的，一般通过封装集合属性的方式来实现，集合属性一般分为：
  - 数组
  - List集合
  - Set集合
  - Map集合
- Hibernate中持久类中所封装的集合属性，必须是集合接口List<T> ，不能是集合的实现子类ArrayList\<T> 。

### 集合的相关属性

- 因为集合属性都需要保存到另一个数据表中，所以保存集合属性的数据表必须包含一个外键列，用于参照到主键列。
- 映射集合属性常用属性如下：

| 属性名    | 说明               |
| ------ | ---------------- |
| name   | 必填，对应集合属性的名称。    |
| table  | 指定保存集合属性的表名      |
| schema | 指定数据表的Schema的名称。 |

### 集合映射需要用到的标签

- \<key />：用来映射当前持久类的主键。key的相关属性如下：

| 属性名       | 说明                       |
| --------- | ------------------------ |
| column    | 必填，生成新表中的外键，引用当前类的主键。    |
| on-delete | 可选，指定外键约束是否打开数据库级别的级联删除。 |
| not-null  | 可选，指定外键列是否有非空约束。         |
| unique    | 可选，指定外键列是否具有唯一约束。        |

#### 数组映射

- 数组的标签：\<array />
- 数组的特征：有序，通过下标访问。
- \<array />所包含的子标签如下：

| 属性名              | 说明                     |
| ---------------- | ---------------------- |
| \<key  />        | 映射集合属性数据表的外键列。         |
| \<list-index  /> | 用于映射数组的下标列，用于保存数组的下标值。 |
| \<element  />    | 映射保存集合元素的数据列，需要指定type。 |

```xml
<!-- 封装数组对象 -->
<array name="myArray" table="myarray">
	<key column="id" />
	<list-index column="arrayindex" />
	<element column="arrayvalue" type="string" />
</array>
```

#### List集合映射

- 由于List的本质也是数组，所以映射方式和数组基本一致。
- List的标签：\<list />
- List集合的特征：有序的，通过下标访问。
- \<list/>标签的所包含的子标签如下：

| 属性名              | 说明                     |
| ---------------- | ---------------------- |
| \<key  />        | 映射集合属性数据表的外键列。         |
| \<list-index  /> | 映射集合属性数据表的集合索引列。       |
| \<element  />    | 映射保存集合元素的数据列，需要指定type。 |

```xml
<!-- 封装List对象 -->
<list name="myList" table="mylist">
	<key column="id" />
	<list-index column="listindex" />
	<element column="listvalue" type="string" />
</list>
```

在学生实体中添加List\<String> like集合来存储学生爱好信息。

```java
public class Student implements Serializable {
    
	private List<String> like;

	public List<String> getLike() {
		return like;
	}

	public void setLike(List<String> like) {
		this.like = like;
	}
}
```

在学生映射文件中添加\<list>标签映射集合属性。

```xml
<list name="like" table="student_like">
    <key column="student_id" />
    <!-- 使用list添加会在数据库表中生成一个position的列，用来保存存储的索引信息。 -->
    <list-index column="position"></list-index>
    <element column="like_name" type="string" />
</list>
```



#### Set集合映射

- Set集合是使用来保存无序的，不可重复的集合数据。Hibernate提供\<Set/>标签来映射集合属性。
- Set集合特征：无序的，唯一的。
- Set标签的所包含的子标签如下：

| 属性名           | 说明                     |
| ------------- | ---------------------- |
| \<key  />     | 映射集合属性数据表的外键列。         |
| \<element  /> | 映射保存集合元素的数据列，需要指定type。 |

```xml
<!-- 封装Set对象 -->
<set name="mySet" table="myset">
	<key column="id" />
	<element column="setvalue" type="string" />
</set>
```


在学生实体中添加Set\<String> like集合来存储学生爱好信息。

```java
public class Student implements Serializable {

	private Set<String> like;

	public Set<String> getLike() {
		return like;
	}

	public void setLike(Set<String> like) {
		this.like = like;
	}
```

在学生映射文件中添加\<Set>标签映射集合属性。

```xml
<set name="like" table="student_like">
    <key column="student_id" />
    <element column="like_name" type="string" />
</set>
```

#### Map集合映射

- Map集合是使用来key和value来保存数据的，所以在映射Map集合数据时，需要指定key和value值。Hibernate提供\<Map/>标签来映射Map集合属性。
- Map集合特征：key是无序的，唯一的，value是无序，不唯一的。
- Map标签的所包含的子标签如下：

| 属性名           | 说明                     |
| ------------- | ---------------------- |
| \<key  />     | 映射集合属性数据表的外键列。         |
| \<map-key  /> | 映射Map集合的key值，需要指定type。 |
| \<element  /> | 映射保存集合元素的数据列，需要指定type。 |

```xml
<!-- 封装Map对象 -->
<map name="myMap" table="mymap">
	<key column="id" />
	<map-key column="mapkey" type="string" />
	<element column="mapvalue" type="string" />
</map>
```

在学生实体中添加Map\<String, String> map集合来存储学生爱好信息。

```java
public class Student implements Serializable {

	private Map<String, String> map;

	public Map<String, String> getMap() {
		return map;
	}

	public void setMap(Map<String, String> map) {
		this.map = map;
	}
}
```

在学生映射文件中添加\<Map>标签映射集合属性。

```xml
<map name="map" table="student_like">
    <key column="student_id"></key>
    <map-key column="like_key" type="string"></map-key>
    <element column="like_name" type="java.lang.String"></element>
</map>
```

### 练习：组件的映射

组件映射

![20180511204525](http://www.znsd.com/znsd/courses/uploads/251b8f431113773107ce8166a152d836/20180511204525.png)

### 学员操作——组件映射

需求说明：

- 创建CUSTOMER表，表中有电话（TEL）、年龄（AGE）、姓氏（FIRSTNAME）、名字（LASTNAME）字段。
- 创建Customer类，类中有电话（tel）、年龄（age）、姓名（name）属性，其中name属性是Name类型；创建Name类，类中有姓氏（firstname）、名字（lastname）属性。
- CUSTOMER表中的FIRSTNAME和LASTNAME字段与Customer类中的name属性对应。
- 保存Customer对象，并按主键加载Customer对象，打印tel，age，name属性。

### 练习：集合属性映射

练习集合属性的封装：

- 封装数组
- 封装List
- 封装Set
- 封装Map

### 小结

- hibernate-mapping的常用配置属性。
- class的常用配置属性。
- id生成策略。
- property常用属性。
- type支持的数据类型。
- 映射组件。
- 映射集合类型的数据。

### Hibernate中的关系映射

- 客观世界中的对象很少是孤立存在的，例如个人和身份证，学生和班级，老师与学生，用户和订单等等。
- 关联关系主要分为以下几种:
  - 一对一映射
    - 基于外键映射
    - 基于主键映射
  - 一对多映射：（单向）双向一对多映射
  - 多对多映射：（单向）双向多对多映射

#### 外键双向一对一关联

- 按照外键映射：通过外键方式引用主表中的主键，并且设置外键属性为唯一属性。

```sql
CREATE TABLE `wife` (
  `wife_id` int(11) NOT NULL AUTO_INCREMENT,
  `wife_name` varchar(50) NOT NULL,
  PRIMARY KEY (`wife_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

CREATE TABLE `husband` (
  `husband_id` int(11) NOT NULL AUTO_INCREMENT,
  `husband_name` varchar(50) NOT NULL,
  `wife_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`husband_id`),
  KEY `fk_wife` (`wife_id`),
  CONSTRAINT `fk_wife` FOREIGN KEY (`wife_id`) REFERENCES `wife` (`wife_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
```

#### 外键双向一对一映射

- 演示丈夫和妻子之间实现`单`向一对一映射

- 实现步骤：

  - 在Husband类中添加Wife对象的引用。

  - 在Husband.hbm.xml中使用\<many-to-one/>，并wife_id列名。

    ```xml
    <many-to-one name="属性名" unique="true" column="wife_id"/>
    ```

- 例子

```java
/**
 * 丈夫类
 */
public class Husband implements Serializable {

	private static final long serialVersionUID = 1L;

	private Integer husbandId; // 丈夫id
	private String husbandName; // 丈夫姓名
	private Wife wife; // 妻子对象
    // 忽略set、get方法
}
```

```java
/**
 * 妻子类
 */
public class Wife implements Serializable {

	private Integer wifeId; // 妻子id
	private String wifeName; // 妻子姓名
}
```

Husband.hbm.xml

```xml
<hibernate-mapping>
	<class name="com.znsd.hibernate.model.Husband" table="husband">
		<id name="husbandId" column="husband_id">
			<generator class="native"></generator>
		</id>
		<property name="husbandName" column="husband_name"></property>
		<many-to-one name="wife" unique="true" column="wife_id"></many-to-one>
	</class>
</hibernate-mapping>
```

wife.hbm.xml

```xml
<hibernate-mapping>
	<class name="com.znsd.hibernate.model.Wife" table="wife">        
		<id name="wifeId" column="wife_Id">
			<generator class="native"></generator>
		</id>
		<property name="wifeName" column="wife_name"></property>
	</class>
</hibernate-mapping>
```

测试添加

```java
@Test
public void testAdd() {
    Wife wife = new Wife();
    wife.setWifeName("王武妻子");

    Husband husband = new Husband();
    husband.setHusbandName("王武");
    husband.setWife(wife);

    Session session = HibernateUtil.getSessionFactory().getCurrentSession();
    session.beginTransaction();

    session.save(wife);
    session.save(husband);

    session.getTransaction().commit();
}
```

测试查询

```java
@Test
public void testLoad() {
    Session session = HibernateUtil.getSessionFactory().getCurrentSession();
    session.beginTransaction();

    Husband husband = (Husband) session.load(Husband.class, 1);
    System.out.println(husband.getWife().getWifeName());

    session.getTransaction().commit();
}
```

`注意：`实体类中不能重写toString方法，可能会造成内存溢出

#### 主键双向一对一关联

- 按照主键映射：主键关联映射是两个表中的主键共享一个值，从表中的主键是从主表中获取得到。
- 通过一个丈夫对应一个妻子演示主键双向一对一关系。

#### 主键双向一对一映射

- 演示丈夫和妻子之间实现双向一对一映射：实体类中的代码和外键双向一对一一致。

- 实现步骤：

  - 在Wife类中的添加Husband对象的引用。

  - 在Wife.hbm.xml中使用\<one-to-one/>

    ```xml
    <one-to-one name="引用的被控端的属性" property-ref="wife" cascade="all"/>
    ```

- 实现代码

  在Wife类中添加Husband对象属性

  ```java
  public class Wife implements Serializable {

  	private Integer wifeId;
  	private String wifeName;

  	private Husband husband; // 添加husband属性
  ｝
  ```
  在wife.hbm.xml中添加one-to-one配置

  ```xml
  <hibernate-mapping>
  	<class name="com.znsd.hibernate.model.Wife" table="wife">
  		<id name="wifeId" column="wife_Id">
  			<generator class="native"></generator>
  		</id>
  		<property name="wifeName" column="wife_name"></property>
  		
           <!-- 添加妻子双向关联的属性配置 -->
  		<one-to-one name="husband" class="com.znsd.hibernate.model.Husband" property-ref="wife" cascade="all"></one-to-one>
  	</class>
  </hibernate-mapping>
  ```
  测试通过妻子找到丈夫

  ```java
  @Test
  public void testLoad() {
      Session session = HibernateUtil.getSessionFactory().getCurrentSession();
      session.beginTransaction();

      Wife wife2 = (Wife) session.load(Wife.class, 1);
      System.out.println(wife2.getHusband().getHusbandName());

      session.getTransaction().commit();
  }
  ```

#### 学员操作——配置一对一关联关系

需求说明：假定汽车（Car）和车位（Carport）之间是一对一关联关系。

- 创建Car类和Carport类。Car类具有number属性（汽车的车牌号）和brand属性（汽车的品牌）。Carport类具有location属性（位置）和size属性（大小）。
- 创建CAR表和CARTPORT表，在CAR表的主键上创建外键，引用CARTPORT表的主键。按照主键映射方式配置Car类和Carport类之间的一对一关系。把Carport对象和Car对象保存到数据库；然后再从数据库中加载一个Carport对象，打印与它关联的Car对象。
- 完成时间：15分钟

### 关联关系

类与类之间最普遍的关系就是关联关系

- 单向的关联：一方包含另一方的引用，不能相互访问。

- 双向的关联：双方都包含对方的引用，可以互相访问。

  ![20180521172907](http://www.znsd.com/znsd/courses/uploads/b1e49bf144ae1ea37fe0200d785fa047/20180521172907.png)

#### 单向多对一关联关系

- 演示Emp和Dept的多对一单向关联

- 实现步骤：

  - 封装实体类：Emp中添加Dept的引用

    ````java
    public class Employee implements Serializable {

    	private Integer id;
    	private String name;
    	private Integer age;

    	private Dept dept;
      
      	// 忽略set、get方法
    }
    ````

    ```java
    public class Dept implements Serializable {

    	private Integer id;
    	private String name;
      
      	// 忽略set、get方法
    }
    ```

  - 添加配置文件在Emp.hbm.xml中添加`\<many-to-one name="一方的对象" class="一方的类" column="外键的列名"/>`

    ```xml
    <hibernate-mapping>
    	<class name="com.znsd.hibernate.bean.Employee" table="employee">
    		<id name="id" column="id">
    			<!-- 根据数据库自动选择id生成策略 -->
    			<generator class="native"></generator>
    		</id>
    		<property name="name" column="name"></property>
          	<property name="age" column="age"></property>
    		<many-to-one name="dept" class="com.znsd.hibernate.bean.Dept" column="deptId" />
    	</class>
    </hibernate-mapping>
    ```

  - 测试添加员工

    ```java
    @Test
    public void testAdd() {
    	  //创建一个会话对象 
    	  Session session = this.sessionFactory.openSession();
          //开启会话事务
          Transaction ts = session.beginTransaction();

          //创建dept对象，并保存
          Dept dept = new Dept();
          dept.setName("开发部门");
          System.out.println(session.save(dept));

          //创建employee对象，并保存  
          Employee employee = new Employee();
          employee.setName("王武");
          employee.setAge(20);
          employee.setDept(dept);
          System.out.println(session.save(employee));

          //提交事务，修改数据库
          ts.commit();		
    }
    ```

#### 双向一对多关联关系

- 配置Dept和Emp 的一对多双向关联

  ```java
  public class Dept implements Serializable {

  	private Integer id;
  	private String name;

  	private Set<Employee> emps = new HashSet<Employee>(); // 部门所有员工
    	// 忽略set、get方法
  }
  ```

  ```xml
  <hibernate-mapping>
  	<class name="com.znsd.hibernate.bean.Dept" table="dept">
  		<id name="id" column="id">
  			<generator class="native"></generator>
  		</id>
  		<property name="name" column="name"></property>
  		<set name="emps">
  			<!-- 部门Id列名 -->
  			<key column="deptId"></key>
  			<one-to-many class="com.znsd.hibernate.bean.Employee" />
  		</set>
  	</class>
  </hibernate-mapping>
  ```

- 测试查询

  ```java
  @Test
  public void testQuery() {
  	Session session = this.sessionFactory.openSession();
  	Query query = session.createQuery(" from Dept ");
  	List<Dept> list = query.list();
  	for (int i = 0; i < list.size(); i++) {
  		Dept dept = list.get(i);
  		System.out.println("person name:" + dept.getName() + "的部门人数：" + dept.getEmps().size());
  	}
  }
  ```

  ​

### cascade(级联)属性

- 级联在编写触发器时经常用到，触发器的作用是当 主控表信息改变时，用来保证其关联表中数据同步更新。若对触发器来修改或删除关联表相记录，必须要删除对应的关联表信息，否则，会存有脏数据。所以，适当的做法是，删除主表的同时，关联表的信息也要同时删除，在hibernate中，只需设置cascade属性值即可。


- 在Hibernate中如何实现添加Dept级联添加Emp？
- 思路分析：
  - 建立从Dept到Emp的一对多关联
  - 在\<set>标签中配置cascade属性

| cascade属性值  | 描述                                       |
| ----------- | ---------------------------------------- |
| none        | 当Session操纵当前对象时，忽略其他关联的对象。它是cascade属性的默认值 |
| save-update | 当通过Session的save()、update()及saveOrUpdate()方法来保存或更新当前对象时，级联保存所有关联的新建的瞬时状态的对象，并且级联更新所有关联的游离状态的对象。 |
| delete      | 当通过Session的delete()方法删除当前对象时，会级联删除所有关联的对象。 |
| all         | 包含save-update，delete的行为。                 |

### \<set>元素的inverse属性

**inverse属性指定了关联关系中的方向**

Inverse是hibernate双向关系中的基本概念。inverse的真正作用就是指定由哪一方来维护之间的关联关系。当一方中指定了“inverse=false”（默认），那么那一方就有责任负责之间的关联关系，说白了就是**hibernate如何生成Sql来维护关联的记录**！ 

- inverse设置为false，则为主动方，由主动方负责维护关联关系，默认是false 。
- inverse设置为true，不负责维护关联关系。

1. 建议inverse设置为true
2. 在建立两个对象的双向关联时，应该同时修改关联两端的对象的相应属性

- 当invest设置为false（默认值）

  ```xml
  <set name="emps" cascade="all" inverse="false">
    	<!-- 部门id列名 -->
    	<key column="deptId"></key>
    	<one-to-many class="com.znsd.hibernate.bean.Employee" />
  </set>
  ```

  ```java
  @Test
  public void testAdd() {
  		//创建一个会话对象 
  		Session session = this.sessionFactory.openSession();
  		try {
  			//开启会话事务
  			Transaction ts = session.beginTransaction();
  			
  			Dept dept = new Dept();
  			dept.setName("测试部门");

  			Employee employee = new Employee();
  			employee.setName("张三");
  			employee.setAge(22);
  			//employee.setDept(dept);

  			Employee employee2 = new Employee();
  			employee2.setName("李四");
  			employee2.setAge(22);
  			//employee2.setDept(dept);
  			
  			Set<Employee> emps = new HashSet<Employee>();
  			emps.add(employee);
  			emps.add(employee2);
  			
  			dept.setEmps(emps);
  			
  			session.saveOrUpdate(dept);
  			
  			//提交事务，修改数据库
  			ts.commit();
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

  ![20180521212708](http://www.znsd.com/znsd/courses/uploads/e951ef3013bfa3aad32b17a15c24d6cb/20180521212708.png)

- invest设置为true

  ```xml
  <set name="emps" cascade="all" inverse="true">
    	<!-- 部门id列名 -->
    	<key column="deptId"></key>
    	<one-to-many class="com.znsd.hibernate.bean.Employee" />
  </set>
  ```

  ![20180521212859](http://www.znsd.com/znsd/courses/uploads/e3d1f7db43cc9e8e8c6ac5d3298f8b5d/20180521212859.png)

### 学员操作——配置多对一单向关联

**需求说明**

配置街道到区县多对一单向关联，并完成以下持久化操作：

- 添加区县
- 添加街道，设置该街道属于某区县
- 修改街道，把该街道调到某区县
- 删除某街道

### 学员操作——配置一对多双向关联

**需求说明**

- 配置区县到街道的双向的一对多
- 添加区县级联添加该区县下的两个街道
- 设置区县的inverse属性值为true，修改某区县，从该区县中移走某一街道。
- 设置区县的\<set>元素的order-by属性为：按照街道编号倒叙排序

### 双向多对多关联关系

- 配置Project和Employee的多对多双向关联

- Project

  ```java
  public class Project implements Serializable {
  
  	private Integer projectId;
  	private String projectName;
  	private Set<Employee> employees = new HashSet<Employee>();
  }
  ```

- Employee

  ```java
  public class Employee implements Serializable {
  
  	private Integer employeeId;
  	private String employeeName;
  	private Set<Project> projects = new HashSet<Project>();
  }
  ```

- 双向多对多关联关系Project.hbm.xml配置文件

  ```xml
  <hibernate-mapping>
  	<class name="com.znsd.hibernate.model.Project" table="t_project">
  		<id name="projectId" column="project_Id">
  			<generator class="native"></generator>
  		</id>
  		<property name="projectName" column="project_name"></property>
  		<set name="employees" table="t_project_employee" cascade="save-update">
  			<key column="project_id">
  			</key>
  			<many-to-many class="com.znsd.hibernate.model.Employee" column="employee_id"></many-to-many>
  		</set>
  	</class>
  </hibernate-mapping>
  ```

- Emp.hbm.xml配置文件

  ```xml
  <hibernate-mapping>
  	<class name="com.znsd.hibernate.model.Employee" table="t_employee">
  		<id name="employeeId" column="employee_Id">
  			<generator class="native"></generator>
  		</id>
  		<property name="employeeName" column="employee_name"></property>
  		
  		<set name="projects" table="t_project_employee" cascade="save-update">
  			<key column="employee_id"></key>
  			<many-to-many class="com.znsd.hibernate.model.Project" column="project_id"></many-to-many>
  		</set>
  	</class>
  </hibernate-mapping>
  ```

- 测试project类

  ```java
  	/**
  	 * 测试查询
  	 */
  	@Test
  	public void testQuery() {
  		Session session = this.sessionFactory.openSession();
  		Query query = session.createQuery(" from Project ");
  		List<Project> list = query.list();
  		for (int i = 0; i < list.size(); i++) {
  			Project project = list.get(i);
  			System.out.println("person name:" + project.getProname() + "的项目人数：" + project.getEmployees().size());
  		}
  	}

  	/**
  	 * 测试get
  	 */
  	@Test
  	public void testGet() {
  		Session session = this.sessionFactory.openSession();
  		try {
  			Project project = (Project) session.get(Project.class, 2);
  			System.out.println(project.getProname() + "emp:" + project.getEmployees().size());
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

- 测试添加

  ```java
  @Test
  public void testAdd() {
    //创建一个会话对象 
    Session session = this.sessionFactory.openSession();
    try {
      //开启会话事务
      Transaction ts = session.beginTransaction();

      Project project = new Project();
      project.setProname("测试project");

      Emp employee = new Emp();
      employee.setEmpname("张三");
      employee.getProjects().add(project);
      session.save(employee);

      Emp employee2 = new Emp();
      employee2.setEmpname("李四");
      employee2.getProjects().add(project);
      session.save(employee2);

      project.getEmployees().add(employee);
      project.getEmployees().add(employee2);

      session.save(project);
      //提交事务，修改数据库
      ts.commit();
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

### 学员操作——配置多对多关联

  **需求说明**

  - 创建项目和员工表，配置项目与员工的多对多的关系
  - 添加项目的同时添加员工
  - 把某员工加入到另一项目组
  - 项目结项时，把该项目标记为结项，并把员工从该项目中移走。

### 小结

  - 请说明cascade属性的作用
  - inverse属性的值有哪些？
  - 双向多对一，一对多。
  - 双向多对多。
  - 双向一对一。

### 总结1

  - hibernate-mapping的常用配置属性。
  - class的常用配置属性。
  - id生成策略。
  - property常用属性。
  - type支持的数据类型。
  - 映射组件。
  - 映射集合类型的数据。

### 总结2 

  - 对象间关联分为一对一，一对多、多对一和多对多等多种情况，关联是有方向的，可以是双向的关联。
  - Hibernate通过配置的方式，将对象间的关联关系映射到数据库上，方便完成多表的持久化操作。
  - \<set>节点的inverse属性描述了由哪一方负责维系关联关系；cascade属性描述了级联操作的规则。