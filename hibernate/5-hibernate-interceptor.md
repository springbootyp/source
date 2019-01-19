## 第五章    过滤器与拦截器 

### 本章目标 

- 过滤器`重点`
- 拦截器`重点（难点）`

### 过滤器

- Hibernate给我们提供了一种针对某个类或者集合使用预先定义的过滤条件（filter criteria）的功能。
- 过滤器用法有点类似数据库中的视图，只是视图是在数据库端定义，而过滤器是在应用程序端定义。
- 过滤条件相当于定义一个类似集合上的”where”属性的条件，但是过滤器可以带参数。

### 使用过滤器的步骤 

- 使用过滤器分为三个步骤： 
  1. 定义过滤器，使用\<filter-def />定义过滤器。
  2. 使用过滤器，使用\<filter />应用过滤器。
  3. 代码中通过session启用过滤器。
- \<fileter-def />是hibernate-mapping的子元素
- \<filter />是class、集合元素的子元素。

### 使用过滤器 

- 定义过滤器

```xml
<hibernate-mapping>
	<class name="com.znsd.hibernate.bean.Student" table="t_student">
		<id name="id" column="id">
			<generator class="assigned"></generator>
		</id>
		<property name="name" column="name"></property>
		<property name="age" column="age"></property>
		<property name="gender" column="gender"></property>
		<!-- 使用过滤器 -->
		<filter name="nameFilter" condition="name = :name"></filter>
	</class>
	<!-- 定义过滤器 -->
	<filter-def name="nameFilter">
		<filter-param name="name" type="string"/>
	</filter-def>
</hibernate-mapping>
```

- 调用过滤器

```java
Session session = sessionFactory.openSession();
// 调用过滤器
session.enableFilter("nameFilter").setParameter("name", "张山");
Query query = session.createQuery("from Student");
List<Student> list = query.list();
for (int i = 0; i < list.size(); i++) {
    System.out.println(list.get(i));
}
```

`注意：conditon属性时一个SQL风格的where子句，因此condition属性指定的是表名和列名。`

### 过滤器的适用场合 

上面的代码中使用了过滤器，并为过滤器设置了合适的参数，通常来说，当某个查询条件使用的非常频繁，那么我们可以将该条件设置为过滤器；如果只是临时的数据筛选，还是使用常规查询比较好。

### 小结 

- 过滤器的作用？
- 使用过滤器的步骤？
- 过滤器的标签。

### 拦截器 

与Struts2拦截器一样，Hibernate中也提供了拦截器功能；设置拦截器后，相应的操作都会先穿过一层层相应的拦截器，让拦截器执行预处理或善后处理。 

![image](http://www.znsd.com/znsd/courses/uploads/7c6663d1e591be9c8959e36454ca5527/image.png)

### 拦截器接口 

- 要实现拦截器，需要实现Interceptor接口，重写所有方法。由于方法比较多，通常推荐继承EmptyInterceptor类。 
- 常用方法说明： 
  - onLoad：加载持久化实体时调用。
  - onSave：保存数据的时候调用，数据还没有保存到数据库。
  - onFlushDirty：更新数据时调用，但数据还没有更新到数据库。
  - onDelete：当删除实体时被调用。
  - preFlush：持久化所做修改之前调用。
  - postFlush：持久化所做修改之后调用。

### 我的第一个拦截器 

- 继承EmptyInterceptor类，重写方法，演示拦截器的执行过程。 

```java
public class TestInterceptor extends EmptyInterceptor {

	@Override
	public boolean onLoad(Object entity, Serializable id, Object[] state, String[] propertyNames, Type[] types)
			throws CallbackException {
		System.out.println("TestInterceptor.onLoad() 加载持久化实体时调用");
		return false;
	}


	@Override
	public boolean onSave(Object entity, Serializable id, Object[] state, String[] propertyNames, Type[] types)
			throws CallbackException {
		System.out.println("TestInterceptor.onLoad() 保存数据的时候调用，数据还没有保存到数据库。");
		return false;
	}

	@Override
	public boolean onFlushDirty(Object entity, Serializable id, Object[] currentState, Object[] previousState,
			String[] propertyNames, Type[] types) throws CallbackException {
		System.out.println("TestInterceptor.onLoad() 更新数据时调用，但数据还没有更新到数据库。");
		return false;
	}
	
	@Override
	public void onDelete(Object entity, Serializable id, Object[] state, String[] propertyNames, Type[] types) {
		System.out.println("TestInterceptor.onDelete() 当删除实体时被调用");
		super.onDelete(entity, id, state, propertyNames, types);
	}
	
	@Override
	public void preFlush(Iterator entities) {
		System.out.println("TestInterceptor.preFlush() 持久化所做修改之前调用");
		super.preFlush(entities);
	}

	@Override
	public void postFlush(Iterator entities) throws CallbackException {
		System.out.println("TestInterceptor.postFlush() 持久化所做修改之后调用");
	}
}
```

### 拦截器配置 

拦截器配置分为两种 

- 拦截器配置分为两种 

```java
Configuration cfg = new Configuration().configure();
//全局配置
cfg.setInterceptor(new TestInterceptor());
```

- 局部拦截器配置：通过Session进行配置。 

```java
//局部配置
session = factory.withOptions().interceptor(new MyInterceptor()).openSession();
```

### 拦截器实现添加日期默认值 

- 在保存学生数据时，通过拦截器对日期类型进行默认值检查。
- 思路分析 
  - 通过重写onSave()方法。
  - 对保存的实体类的日期进行赋值。
  - 调用父类的super.save()方法进行保存。

```java
public class AutoUpdateTimeInterceptor extends EmptyInterceptor {

	/*
     * entity - POJO对象
     * id - POJO对象的主键
     * state - POJO对象的每一个属性所组成的集合(除了ID)
     * propertyNames - POJO对象的每一个属性名字组成的集合(除了ID)
     * types - POJO对象的每一个属性类型所对应的Hibernate类型组成的集合(除了ID)
     */
	@Override
	public boolean onSave(Object entity, Serializable id, Object[] state, String[] propertyNames, Type[] types) {
		if (entity instanceof Student) {
			for (int i = 0; i < propertyNames.length; i++) {
				
				if ("createTime".equals(propertyNames[i])) {
					// 如果字段是createTime则将当前时间设置为默认值
					state[i] = new Date();
					return true;
				}
			}
		}
		return false;
	}
}
```

### 使用拦截器应注意的问题 

使用拦截器应注意的问题。 

- 拦截器是针对所有保存操作的，所以如要要进行操作，需要对保存的持久类对象的类型进行检查。 
- 如果保存操作返回false，则拦截器操作将会失效。 

### 小结 

- 拦截器和过滤器的区别？
- 拦截器常用方法。