## Hibernate 课程

### hibernate入门课程大纲：

1. 概念介绍：持久化、ORM对象关系映射
   - 持久化：由运行在系统内存中瞬时的数据，转换成持久状态的数据的过程叫做持久化。
   - ORM(Object Rallitional Mapping):对象关系映射，数据库与JAVA应用程序实体对象的对应关系
2. DEMO环境搭建
   - a:导入required jar包
   - b:配置hibernate.cfg.xml配置文件
   - c:新建实体类:提供无参构造函数、set/get方法、实现Serializable接口
   - d:实体类映射文件配置:xxx.hbm.xml
3. 常用接口与类介绍
   - Configuration：hibernate 初始化配置信息
   - SessionFactory：对应一个数据源
   - Session：与数据库的一次对话
   - Transaction：hibernate事务管理
   - Query：HQL查询语句
   - Criteria：Hibernate对象查询--动态查询
4. load与get
   - load:延迟加载(返回的是代理对象，只有实际使用时才会执行数据库查询)，不存在时抛出异常
   - get:立即加载，返回的实例对象
5. openSession与getCurrentSession
   - openSession：每次new一个Session，需要手工关闭，否则容易造成数据库连接溢出
   - getCurrentSession：从当前线程中获取绑定的session，事务提交或者回滚时自动关闭session

------

### hibernate映射关系课程大纲：

1：配置节点介绍：

	a:<hibernate-mapping/>
	b:<class/>
	c:<id/>：主键生成策略
2：组件配置
```xml
<hibernate-mapping>
<class name="com.lxit.hibernate.demo.component.Student" table="Student">
	<id name="id" column="id">
		<generator class="native">
		</generator>
	</id>
	<property name="name" column="name"></property>
	<property name="age" column="age"></property>
	<!-- 组件对象包含的字段直接映射到本(Student)对象，并在本表(student表)增加组件包含的字段 -->
	<component name="addr" class="com.lxit.hibernate.demo.component.Address" insert="true" update="true">
		<property name="province" />
		<property name="city" type="string" />
	</component>
</class>
</hibernate-mapping>
```
3：集合映射配置
List:
```xml
<hibernate-mapping>
<class name="com.lxit.hibernate.demo.setfiled.Classes" table="Classes">	
    <id name="c_id" column="c_id">
        <generator class="native"></generator>
    </id>		
    <property name="c_name" column="c_name"></property>
    <list name="stuList" table="student">
    	<!-- 关联list对应的table中的关联字段 -->
    	<key column="c_id"/>
    	<!-- list的序列值 -->
    	<index column="classes_index"></index>
    	<!-- 从关联表中读取的字段-->
    	<!-- <element column="name" type="string"/>  -->
     	<one-to-many class="com.lxit.hibernate.demo.setfiled.Student"/>
    </list>
</class>
</hibernate-mapping>
```
Array:
Map:
Set:

4:一对一、一对多、多对一映射关系配置
a:双向一对一外键关联
```xml
<class name="com.lxit.hibernate.demo.entity.onetone.Student" table="student">	
	<id name="s_id" column="s_id">
		<generator class="native" />
	</id>
	<property name="name" column="name" />
	<property name="age" column="age" />
	<many-to-one name="addr" column="a_id" unique="true" />
</class>
```
```xml
<class name="com.lxit.hibernate.demo.entity.onetone.Address" table="address">
	<id name="a_id" column="a_id">
		<generator class="native" />
	</id>
	<property name="province" column="province" />
	<property name="city" column="city" />
	<one-to-one name="stu" property-ref="addr" class="com.lxit.hibernate.demo.entity.onetone.Student"/>
</class>
```
b:单向一对一外键关联
```xml
<class name="com.lxit.hibernate.demo.entity.onetone.Student" table="student">	
	<id name="s_id" column="s_id">
		<generator class="native" />
	</id>
	<property name="name" column="name" />
	<property name="age" column="age" />
	<many-to-one name="addr" column="a_id" unique="true" />
</class>
```
```xml
<class name="com.lxit.hibernate.demo.entity.onetone.Address" table="address">
	<id name="a_id" column="a_id">
		<generator class="native" />
	</id>
	<property name="province" column="province" />
	<property name="city" column="city" />
</class>
```
c:双向一对一主键关联
```xml
<class name="com.lxit.hibernate.demo.entity.onetone.Student" table="student">
	<id name="s_id" column="s_id">
		<generator class="foreign" >
			<param name="property">addr</param>
		</generator>
	</id>
	<property name="name" column="name" />
	<property name="age" column="age" />
	<one-to-one name="addr" constrained="true" />
</class>
```
```xml
<class name="com.lxit.hibernate.demo.entity.onetone.Address" table="address">
	<id name="a_id" column="a_id">
		<generator class="native" />
	</id>
	<property name="province" column="province" />
	<property name="city" column="city" />
	<one-to-one name="stu"/>
</class>
```


------



## 多对一

多的一方持有对象，一的一方持有集合

```xml
<many-to-one name="一方的对象" class=" 一方的类" column="外键的列名" />
```

### 一对多

```xml
<set name="属性">
	<key column="外键列名" />
	<one-to-many class="多方的类路径" />
</set>
```

### 多对多

```xml
<set name="属性" table="中间表名">
	<key column="外键列名[]" />
	<many-to-many class="另外多的一方的类路径" column="外键列名[]" />
</set>
```

`注意：多对多通过中间表关联，且中间表不能够写实体类和实体映射文件`

### 基于外键的多对一关联映射

采用<many-to-one>标签，指定多的一端的unique=true，这样就限制了多段的多重性为一。

```xml
<many-to-one name="属性名" column="外键列名" unique="true"></many-to-one>
```

### 双向一对一关联映射

需要在一端添加\<one-to-one>标签，用property-ref来指定反向属性引用

```xml
<one-to-one name="属性名" property-ref="主控端的属性ID"></one-to-one>
```

### 基于主键的一对一关联映射

- 单向一对一

主控端在生成主键策略时，选择foreign方式。

```xml
<id name="id">
	<generator class="foreign">
		<param name="property">引用的被控端的属性</param>
	</generator>
</id>
```
- 通过one-to-one来设置一对一映射,constrained表示告诉当前主键，你的值采用另一个表中的主键的值，当前主键对于有关系的另一个表来说就是外键。

```xml
<one-to-one name="被控端的属性" constrained="true"></one-to-one>
```

- 双向一对一，需要在实体类中添加双方的引用

```xml
<one-to-one name="被控端的属性"></one-to-one>
```

