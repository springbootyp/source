# MongoDB in SpringBoot

​	Springboot整合mongodb

MongoDB独特的数据处理方式，可以将热点数据加载到内存，所以查询会非常快，直接从内存中读取数据。

MongoDB的集群架构、FailOver机制(故障备援，主服务器故障自动选举出新的主服务器)充分的体现了MongoDB的高扩展性及高可用特性！

缺点：

​	1：没有事务机制，mongodb本身没有事务处理能力，程序出错无法回滚数据。

​	2：锁机制：同时大量的查询、更新、写入操作可能会造成mongodb自动进行lock，从而造成纯种堆积。

##### 应用场景

* MongoDB适合业务系统中有大量“低价值”数据的场景及对事务要求不高的业务场景
* 对高可用性要求高的业务场景
* 应对大数据量的业务场景，对数据扩展性要求高、数据结构不明确的场景
* 一般用来做缓存框架、日志记录、存储静态数据、等查询频繁修改少的场景

##### springboot整合

* 引入依赖jar包

  ```xml
  <dependencies>
      <dependency> 
          <groupId>org.springframework.boot</groupId>
          <artifactId>spring-boot-starter-data-mongodb</artifactId>
      </dependency> 
  </dependencies>
  ```

* application.properties中配置mongodb库：

  ```xml
  #单台服务配置
  spring.data.mongodb.uri=mongodb://name:pass@localhost:27017/test
  #集群服务配置
  spring.data.mongodb.uri=mongodb://user:pwd@ip1:port1,ip2:port2/database
  ```

* Dao持久层引入MongoTemplate操作对象来操作数据库

  ```java
  public class UserDaoImpl implements UserDao{
  	
  	@Autowired
      private MongoTemplate mongoTemplate;
  
  	@Override
  	public List<User> getAll() {
  		return mongoTemplate.findAll(User.class);
  	}
  	
  
  	@Override
  	public User getByName(String name) {
  		Query query = new Query(Criteria.where("name").is(name));
  		return mongoTemplate.findOne(query, User.class);
  	}
  
  }
  ```



##### 集群 in springboot

* 配置数据源

  ```java
  @Configuration
  public class MongoDBConfig {
  
  	@Primary
  	@Bean(name = "primaryMongoTemplate")
  	public MongoTemplate primaryMongoTemplate() throws Exception {
  		return new MongoTemplate(primaryFactory());
  	}
  
  	@Bean(name="secondaryMongoTemplate")
  	public MongoTemplate secondaryMongoTemplate() throws Exception {
          return new MongoTemplate(secondaryFactory());
  	}
  
  	@Bean
      @Primary
  	public MongoDbFactory primaryFactory() throws Exception {
  		MongoClientURI mc = new MongoClientURI("mongodb://192.168.108.130:27017/test");
  		return new SimpleMongoDbFactory(mc);
  	}
  
  	@Bean
  	public MongoDbFactory secondaryFactory() throws Exception {
  		MongoClientURI mc = new MongoClientURI("mongodb://192.168.108.130:27017/test");
  		return new SimpleMongoDbFactory(mc);
  	}
  }
  ```

* Dao注入：查询使用从服务、修改使用主服务

  ```java
  @Repository
  public class UserDaoImpl implements UserDao{
  	
  	@Resource(name="primaryMongoTemplate")
      private MongoTemplate primaryMongoTemplate;
  	
  	@Resource(name="secondaryMongoTemplate")
  	private MongoTemplate secondMongoTemplate;
  
  	@Override
  	public List<User> getAll() {
  		return secondMongoTemplate.findAll(User.class);
  	}
  	@Override
  	public User getByName(String name) {
  		Query query = new Query(Criteria.where("name").is(name));
  		return secondMongoTemplate.findOne(query, User.class);
  	}
  	@Override
  	public void save(User user) {
  		primaryMongoTemplate.save(user);
  	}
  }
  ```





​	