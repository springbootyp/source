## 第五章 spring事务管理 

### 本章目标

- 掌握Spring的声明式事务`重点（难点）`
- 掌握Spring的编程式事务`重点（难点）`

### Spring事务 

**什么是事务？**

- 比如你去ATM机取1000块钱，大体有两个步骤：首先输入密码金额，银行卡扣掉1000元钱；然后ATM出1000元钱。这两个步骤必须是要么都执行要么都不执行。如果银行卡扣除了1000块但是ATM出钱失败的话，你将会损失1000元；如果银行卡扣钱失败但是ATM却出了1000块，那么银行将损失1000元。所以，如果一个步骤成功另一个步骤失败对双方都不是好事，如果不管哪一个步骤失败了以后，整个取钱过程都能回滚，也就是完全取消所有操作的话，这对双方都是极好的 
- 事务就是用来解决类似问题的。`事务是一系列的动作，它们综合在一起才是一个完整的工作单元，这些动作必须全部完成，如果有一个失败的话，那么事务就会回滚到最开始的状态，仿佛什么都没发生过一样。   在企业级应用程序开发中，事务管理必不可少的技术，用来确保数据的完整性和一致性?`

### 事务的四大特性：ACID

- 原子性（Atomicity）：事务是一个原子操作，由一系列动作组成。事务的原子性确保动作要么全部完成，要么完全不起作用
- 一致性（Consistency）：一旦事务完成（不管成功还是失败），系统必须确保它所建模的业务处于一致的状态，而不会是部分完成部分失败。在现实中的数据不应该被破坏 
- 隔离性（Isolation）：可能有许多事务会同时处理相同的数据，因此每个事务都应该与其他事务隔离开来，防止数据损坏 
- 持久性（Durability）：一旦事务完成，无论发生什么系统错误，它的结果都不应该受到影响，这样就能从任何系统崩溃中恢复过来。通常情况下，事务的结果被写到持久化存储器中

### 事务传播行为 

Spring事务传播行为有以下类型： 

| 事务传播行为类型          | 说明                                                         |
| ------------------------- | ------------------------------------------------------------ |
| PROPAGATION_REQUIRED      | 如果当前没有事务，就新建一个事务，如果已经存在一个事务中，加入到这个事务中。这是   最常见的选择。 |
| PROPAGATION_SUPPORTS      | 支持当前事务，如果当前没有事务，就以非事务方式执行。         |
| PROPAGATION_MANDATORY     | 使用当前的事务，如果当前没有事务，就抛出异常。               |
| PROPAGATION_REQUIRES_NEW  | 新建事务，如果当前存在事务，把当前事务挂起。                 |
| PROPAGATION_NOT_SUPPORTED | 以非事务方式执行操作，如果当前存在事务，就把当前事务挂起。   |
| PROPAGATION_NEVER         | 以非事务方式执行，如果当前存在事务，则抛出异常。             |
| PROPAGATION_NESTED        | 如果当前存在事务，则在嵌套事务内执行。如果当前没有事务，则执行与 PROPAGATION_REQUIRED 类似的操作。 |



### 事务隔离级别 

**数据库并发操作存在的异常情况：**

- 更新丢失：两个并发事务同时更新同一条数据，数据最终以第二次更新事务为准，第一次更新没有得到体现。 
- 脏读：脏读发生在一个事务读取了另一个事务改写但尚未提交的数据时。如果改写在稍后被回滚了，那么第一个事务获取的数据就是无效的
- 不可重复读取：不可重复读发生在一个事务执行相同的查询两次或两次以上，但是每次都得到不同的数据时。这通常是因为另一个并发事务在两次查询期间进行了更新 
- 幻读：幻读与不可重复读类似。它发生在一个事务（T1）读取了几行数据，接着另一个并发事务（T2）插入了一些数据时。在随后的查询中，第一个事务（T1）就会发现多了一些原本不存在的记录

**数据库隔离级别： **

- 未授权读
- 授权读取
- 可重复读
- 串行

### 隔离级别 

| 隔离级别                   | 说明                                                         |
| -------------------------- | ------------------------------------------------------------ |
| ISOLATION_DEFAULT          | 使用后端数据库默认的隔离级别                                 |
| ISOLATION_READ_UNCOMMITTED | 最低的隔离级别，允许读取尚未提交的数据变更，可能会导致脏读、幻读或不可重复读 |
| ISOLATION_READ_COMMITTED   | 允许读取并发事务已经提交的数据，可以阻止脏读，但是幻读或不可重复读仍有可能发生 |
| ISOLATION_REPEATABLE_READ  | 对同一字段的多次读取结果都是一致的，除非数据是被本身事务自己所修改，可以阻止脏读和不可重复读，但幻读仍有可能发生 |
| ISOLATION_SERIALIZABLE     | 最高的隔离级别，完全服从ACID的隔离级别，确保阻止脏读、不可重复读以及幻读，也是最慢的事务隔离级别，因为它通常是通过完全锁定事务相关的数据库表来实现的 |



### Spring事务结构图 

- Spring事务结构图

![image](http://www.znsd.com/1705/restaurantSystem/uploads/8cab863fae621884c363ee9f381f5050/image.png)

![20131212094707828](http://www.znsd.com/1705/restaurantSystem/uploads/93dd422210e8ca4763c950e0a7d90bb3/20131212094707828.jpg)

- 事务超时

  为了使应用程序很好地运行，事务不能运行太长的时间。因为事务可能涉及对后端数据库的锁定，所以长时间的事务会不必要的占用数据库资源。事务超时就是事务的一个定时器，在特定时间内事务如果没有执行完毕，那么就会自动回滚，而不是一直等待其结束 

- 回滚规则 

  事务五边形的最后一个方面是一组规则，这些规则定义了哪些异常会导致事务回滚而哪些不会。默认情况下，事务只有遇到运行期异常时才会回滚，而在遇到检查型异常时不会回滚,但是你可以声明事务在遇到特定的检查型异常时像遇到运行期异常那样回滚。同样，你还可以声明事务遇到特定的异常不回滚，即使这些异常是运行期异常。 

### 编程式事务 

**编程式和声明式事务的区别**

- Spring提供了对编程式事务和声明式事务的支持，编程式事务允许用户在代码中精确定义事务的边界，而声明式事务（基于AOP）有助于用户将操作与事务规则进行解耦。   简单地说，编程式事务侵入到了业务代码里面，但是提供了更加详细的事务管理；而声明式事务由于基于AOP，所以既能起到事务管理的作用，又可以不影响业务代码的具体实现 

**如何实现编程式事务**

- Spring提供两种方式的编程式事务管理，分别是：使用TransactionTemplate和直接使用PlatformTransactionManager 

### 使用TransactionTemplate  

- 配置事务管理器

```xml
<!-- 配置事务管理器 -->
<bean id="txManager" class="org.springframework.orm.hibernate4.HibernateTransactionManager">
    <property name="sessionFactory" ref="sessionFactory" />
</bean>
```

- 配置事务模版

```xml
<!-- 事务模版 -->
<bean id="transactionTemplate" class="org.springframework.transaction.support.TransactionTemplate">
    <property name="transactionManager" ref="txManager"></property>
    <property name="isolationLevelName" value="ISOLATION_DEFAULT"></property>
    <property name="timeout" value="30"></property>
</bean>
```

- 代码控制事务

```java
public class UserServiceImpl implements UserService {
    
    private UserDao userDao;
    private LogDao logDao;
    private TransactionTemplate transactionTemplate;
    
    @Override
    public void save(User user) {
        transactionTemplate.execute(new TransactionCallback<Object>() {

            @Override
            public Object doInTransaction(TransactionStatus status) {
                System.out.println("TransactionStatus===" + status);
                try {
                    userDao.save(user);
                    Log log = new Log();
                    log.setMessage("用户添加");
                    log.setCreateTime(new Date());
                    //int i = 1/0;
                    logDao.save(log);
                } catch (Exception e) {
                    status.setRollbackOnly();
                    e.printStackTrace();
                }
                return user;
            }
        });
    }
}
```

### 声名式事务Annotation实现

- 配置事务

  ```xml
  <!-- 配置事务管理器 -->
  <bean id="txManager" class="org.springframework.orm.hibernate4.HibernateTransactionManager">
      <property name="sessionFactory" ref="sessionFactory" />
  </bean>
  <!-- 把事务管理器交给注解驱动来完成 -->
  <tx:annotation-driven transaction-manager="txManager"/>
  ```

- 通过@Transaction注解开启事务

  ```java
  @Transactional(propagation = Propagation.REQUIRED)
  @Override
  public void save(User user) {		
      userDao.save(user);
      Log log = new Log();
      log.setMessage("用户添加");
      log.setCreateTime(new Date());
      int i = 1/0;
      logDao.save(log);
  }
  ```

### 声明式事务xml实现  

配置事务

```xml
<!-- 配置事务 -->
<bean id="txManager" 
    class="org.springframework.orm.hibernate4.HibernateTransactionManager">
    <property name="sessionFactory" ref="sessionFactory" />
</bean>
```

AOP切面拦截事务

```xml
<!-- AOP切面拦截事务 -->
<aop:config>
    <aop:pointcut id="serviceMethod"
        expression="execution(* com.lxit.ssh.service.*.*.*(..))" />
    <aop:advisor advice-ref="txAdvice" pointcut-ref="serviceMethod" />
</aop:config>
```

事务的通知方式

```xml
<!-- 事务的通知方式 -->
<tx:advice id="txAdvice" transaction-manager="txManager">
    <tx:attributes>
        <!-- read-only 事务为只读，一般查询数据可把该属性设置为true，可以提升效率 -->
    	<tx:method name="find*" propagation="REQUIRED" read-only="true" />
    	<tx:method name="search*" propagation="REQUIRED" read-only="true" />
    	<tx:method name="query*" propagation="REQUIRED" read-only="true" />
		<!-- propagation为事务的传播属性，常用为REQUIRED：如果当前线程有事务就直接使用当前事务，没有就创建一个事务 -->
    	<tx:method name="add*" propagation="REQUIRED" />
    	<tx:method name="submit*" propagation="REQUIRED" />
    	<tx:method name="save*" propagation="REQUIRED" />
		<tx:method name="insert*" propagation="REQUIRED" />
    </tx:attributes>
</tx:advice>
```

### <tx：method>属性介绍

- <tx:method />是Spring中事务通知类标签，这里用来定义Hibernate中的事务
- 常用属性如下。

| 属性         | 默认值   | 描述                                                         |
| ------------ | -------- | ------------------------------------------------------------ |
| name（必选） |          | 必选，与事务关联的方法名，通配符(*)可以用来指定一批关联到相同的事务属性的方法，如"add*"、"get*"、"select*"等。 |
| propagation  | REQUIRED | 事务传播行为                                                 |
| isolation    | DEFAULT  | 事务隔离级别                                                 |
| timeout      | -1       | 超时事件，单位为秒                                           |
| read-only    | false    | 是否只读                                                     |



###  Spring JDBC Template 使用

#### 概述

Spring JDBC是Spring所提供的持久层技术，它的主要目的降低JDBC API的使用难度，以一种更直接、更简洁的方式使用JDBC API。 使用Spring JDBC，我们仅仅需要做那些和业务相关的DML操作的事，将主要精力集中在业务上，而将获取资源、Statement创建、释放资源以及异常处理等繁杂乏味的工作交给Spring JDBC。

#### 使用使用Spring JDBC

**JdbcTemplate主要提供以下五类方法：**

1. execute方法：可以用于执行任何SQL语句，一般用于执行DDL语句；
2.  update方法及batchUpdate方法：update方法用于执行新增、修改、删除等语句；
3. batchUpdate方法用于执行批处理相关语句；
4.  query方法及queryForXXX方法：用于执行查询相关语句； 
5. call方法：用于执行存储过程、函数相关语句。 

**在Spring配配置那文件中配置DAO一般分为4个步骤**

1. 定义DataSource
2. 定义JdbcTemplate
3. 声明一个抽象的Bean，以便所有的DAO复用配置JdbcTemplate属性的配置（使用注解的方式更加方便）
4. 配置具体的DAO（使用注解的方式更加方便）

**用户操作列子**

- 配置JdbcTemplate 

  ```xml
  <bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
      <property name="dataSource" ref="dataSource"></property>
  </bean>
  ```

- 在DAO类中注入JdbcTemplate 

  ```xml
  <bean id="userDao" class="com.znsd.transaction.dao.impl.UserDaoJDBCTemplateImpl">
      <property name="jdbcTemplate" ref="jdbcTemplate"></property>
  </bean>
  ```

  ```java
  public class UserDaoImpl implements UserDao {
  
  	private JdbcTemplate jdbcTemplate;
  	// 通过set注入将jdbcTemplate注入给UserDaoImpl
  	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
  		this.jdbcTemplate = jdbcTemplate;
  	}
  }
  ```

- 添加操作

  ```java
  @Override
  public int save(User user) {
      return this.jdbcTemplate.update("insert into t_user(username, password) values(?, ?)", user.getUsername(), user.getPassword());
  }
  ```

- 删除操作

  ```java
  @Override
  public int delete(Integer id) {
      return this.jdbcTemplate.update("delete from t_user where id = ?", id);
  }
  ```

- 修改操作

  ```java
  @Override
  public int update(User user) {
      return this.jdbcTemplate.update("update t_user set username = ?, password = ? where id = ?", user.getUsername(), user.getPassword(), user.getId());
  }
  ```

- 查询操作

  ```java
  @Override
  public List<User> list(User user) {
      RowMapper<User> rowMapper = new BeanPropertyRowMapper<User>(User.class);
      return this.jdbcTemplate.query("select id, username, password from t_user", rowMapper);
  }
  ```

- 查询单列操作

  ```java
  @Override
  public Integer count(User user) {
      // queryForObject 模板方法针对的结果集是“一列”的时候，并且支持的是常见类型（Integer.class）
      return this.jdbcTemplate.queryForObject("select count(*) from t_user", Integer.class);
  }
  ```

- 根据id获取对象操作

  ```java
  @Override
  public User get(Integer id) {
      RowMapper<User> rowMapper = new BeanPropertyRowMapper<User>(User.class);
      List<User> users = this.jdbcTemplate.query("select id, username, password from t_user where id = ? limit 1", rowMapper, id);
      if (users != null && users.size() > 0) {
          return users.get(0);
      }
      return null;
  }
  ```

- 添加并返回主键

  ```java
  @Override
  public int saveRetrieveId(User user) {
      PreparedStatementCreator psc = new PreparedStatementCreator() {
  
          @Override
          public PreparedStatement createPreparedStatement(Connection connection) throws SQLException {
              PreparedStatement ps = connection.prepareStatement("insert into t_user(username, password) values(?, ?)", new String[]{"id"});
              ps.setString(1, user.getUsername());
              ps.setString(2, user.getPassword());
              return ps;
          }
      };
      KeyHolder generatedKeyHolder = new GeneratedKeyHolder();
      this.jdbcTemplate.update(psc , generatedKeyHolder);
      return generatedKeyHolder.getKey().intValue();
  }
  ```

- 批量操作

  ```java
  @Override
  public int[] batchSave(final List<User> users) {
      int[] updateCounts = this.jdbcTemplate.batchUpdate(
          "insert into t_user(username, password) values(?, ?)",
          new BatchPreparedStatementSetter() {
              public void setValues(PreparedStatement ps, int i) throws SQLException {
                  ps.setString(1, users.get(i).getUsername());
                  ps.setString(2, users.get(i).getPassword());
              }
  
              public int getBatchSize() {
                  return users.size();
              }
          });
      return updateCounts;
  }
  ```


#### jdbcTemplate 事务配置

- xml方式声明事务配置

  ```xml
  <!--spring声明式事务管理控制 -->
  <!--配置事务管理器类 -->
  <bean id="txManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
      <property name="dataSource" ref="dataSource" />
  </bean>
  
  <!--配置事务增强（如何管理事务，只读、读写...）-->
  <tx:advice id="txAdvice" transaction-manager="txManager">
      <tx:attributes>
          <tx:method name="add*" propagation="REQUIRED" />
          <tx:method name="save*" propagation="REQUIRED" />
          <tx:method name="del*" propagation="REQUIRED" />
          <tx:method name="remove*" propagation="REQUIRED" />
          <tx:method name="update*" propagation="REQUIRED" />
          <tx:method name="change*" propagation="REQUIRED" />
          <tx:method name="modify*" propagation="REQUIRED" />
  
          <tx:method name="query*" propagation="REQUIRED" read-only="true" />
          <tx:method name="list*" propagation="REQUIRED" read-only="true" />
          <tx:method name="select*" propagation="REQUIRED" read-only="true" />
      </tx:attributes>
  </tx:advice>
  
  <!--aop配置，拦截哪些方法（切入点表达式，拦截上面的事务增强）-->
  <aop:config>
      <aop:pointcut id="productServiceMethods"
                    expression="execution(* com.znsd.transaction.service.impl.*.*(..))" />
      <aop:advisor advice-ref="txAdvice" pointcut-ref="productServiceMethods" />
  </aop:config>
  ```

- 注解方式声明事务配置

  ```xml
  <!--事务管理器类-->
  <bean id="txManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
      <property name="dataSource" ref="dataSource"/>
  </bean>
  
  <!--开启注解扫描-->
  <context:component-scan base-package="com.znsd.transaction.service"/>
  
  <!--注解方式实现事务-->
  <tx:annotation-driven transaction-manager="txManager"/>
  ```

  ```java
  @Transactional
  public void save(Student student){
      this.studentDao.save(student);
      int i = 1/0;
      this.studentDao.save(student);
  }
  ```

- 如果@Transactional应用到方法上，该方法使用事务；应用到类上，类的方法使用事务，定义到父类上，执行父类的方法时使用事务；

- @Transactional事务的属性

  ```java
  @Transactional(
      readOnly = false, //读写事务
      timeout = -1 ,     //事务的超时时间，-1为无限制
      noRollbackFor = ArithmeticException.class, //遇到指定的异常不回滚
      isolation = Isolation.DEFAULT, //事务的隔离级别，此处使用后端数据库的默认隔离级别
      propagation = Propagation.REQUIRED //事务的传播行为
  )
  ```

  