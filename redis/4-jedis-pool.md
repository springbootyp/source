## 第四章 JedisPool使用

### 什么是JedisPool？

Jedis实例不是线程安全的,所以不可以多个线程共用一个Jedis实例，但是创建太多的实现也不好因为这意味着会建立很多sokcet连接。JedisPool是一个线程安全的网络连接池。可以用JedisPool创建一些可靠Jedis实例，可以从池中获取Jedis实例，使用完后再把Jedis实例还回JedisPool。这种方式可以避免创建大量socket连接并且会实现高效的性能.

### 使用JedisPool

1. `JedisPool#getResource()`方法从连接池中取得一个Jedis实例， 
2. 使用Jedis实例进行正常的数据操作 
3. Jedis实例使用完后要把它再放回连接池。

### JedisPool工具类

```java
public class JedisPoolUtil {
	
	private static JedisPool jedisPool = null;

	private JedisPoolUtil() {

	}
	
	public static JedisPool getJedisPoolInstance() {
		if (null == jedisPool) {
			
			synchronized (JedisPoolUtil.class) {
				
				if (null == jedisPool) {
					JedisPoolConfig poolConfig = new JedisPoolConfig();
					// 设置最大连接数
					poolConfig.setMaxTotal(1000);
					// 设置连接池最大空闲数
					poolConfig.setMaxIdle(32);
					// 最大等待时间
					poolConfig.setMaxWaitMillis(100 * 1000);
					// 获得一个redis连接实例是否检查可用性（ping()）
					poolConfig.setTestOnBorrow(true);
					
					jedisPool = new JedisPool(poolConfig , "192.168.0.25", 6380);
				}
			}
		}
		return jedisPool;
	}
	
	public static void release(Jedis jedis) {
		if (null != jedis) {
			jedis.close();
		}
	}
	
	public static void destory(JedisPool jedisPool) {
		if (null != jedisPool) {
			jedisPool.destroy();
		}
	}
}
```

### JedisPool常用配置

JedisPool保证资源在一个可控范围内，并且提供了线程安全，但是一个合理的GenericObjectPoolConfig配置能为应用使用Redis保驾护航，下面将对它的一些重要参数进行说明和建议：

| 序号 | 参数名             | 含义                                                         | 默认值           | 使用建议                                          |
| ---- | ------------------ | ------------------------------------------------------------ | ---------------- | ------------------------------------------------- |
| 1    | maxTotal           | 资源池中最大连接数                                           | 8                |                                                   |
| 2    | maxIdle            | 资源池允许最大空闲的连接数                                   | 8                |                                                   |
| 3    | minIdle            | 资源池确保最少空闲的连接数                                   | 0                |                                                   |
| 4    | blockWhenExhausted | 当资源池用尽后，调用者是否要等待。只有当为true时，下面的maxWaitMillis才会生效 | true             | 建议使用默认值                                    |
| 5    | maxWaitMillis      | 当资源池连接用尽后，调用者的最大等待时间(单位为毫秒)         | -1：表示永不超时 | 不建议使用默认值                                  |
| 6    | testOnBorrow       | 向资源池借用连接时是否做连接有效性检测(ping)，无效连接会被移除 | false            | 业务量很大时候建议设置为false(多一次ping的开销)。 |
| 7    | testOnReturn       | 向资源池归还连接时是否做连接有效性检测(ping)，无效连接会被移除 | false            | 业务量很大时候建议设置为false(多一次ping的开销)。 |
| 8    | jmxEnabled         | 是否开启jmx监控，可用于监控                                  | true             | 建议开启，但应用本身也要开启                      |

### redis整合spring

- 导入maven依赖

  ```xml
  <!-- jedis api -->
  <dependency>
      <groupId>redis.clients</groupId>
      <artifactId>jedis</artifactId>
      <version>2.9.0</version>
  </dependency>
  
  <!-- spring redis -->
  <dependency>
      <groupId>org.springframework.data</groupId>
      <artifactId>spring-data-redis</artifactId>
      <version>1.7.5.RELEASE</version>
  </dependency>
  
  <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.9</version>
      <scope>test</scope>
  </dependency>
  
  <!-- spring core -->
  <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-core</artifactId>
      <version> 4.2.5.RELEASE</version>
  </dependency>
  
  <!-- spring 测试 -->
  <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-test</artifactId>
      <version> 4.2.5.RELEASE</version>
      <scope>provided</scope>
  </dependency>
  ```

- 配置文件

  ```properties
  # ip地址
  redis.host.ip=192.168.0.25
  # 端口号
  redis.port=6379
  # 如果有密码 
  redis.password=
  # 客户端超时时间单位是毫秒 默认是2000  
  redis.timeout=3000
  
  
  # 最大空闲数  
  redis.maxIdle=6
  # 连接池的最大数据库连接数。设为0表示无限制,如果是jedis 2.4以后用redis.maxTotal  
  #redis.maxActive=600  
  # 控制一个pool可分配多少个jedis实例,用来替换上面的redis.maxActive,如果是jedis 2.4以后用该属性  
  redis.maxTotal=20
  # 最大建立连接等待时间。如果超过此时间将接到异常。设为-1表示无限制。  
  redis.maxWaitMillis=3000
  # 连接的最小空闲时间 默认1800000毫秒(30分钟) 
  redis.minEvictableIdleTimeMillis=300000
  # 每次释放连接的最大数目,默认3 
  redis.numTestsPerEvictionRun=4
  # 逐出扫描的时间间隔(毫秒) 如果为负数,则不运行逐出线程, 默认-1  
  redis.timeBetweenEvictionRunsMillis=30000
  ```

- 创建spring整合redis配置文件spring-redis.xml

  ```xml
  <beans xmlns="http://www.springframework.org/schema/beans"
  	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  	xmlns:c="http://www.springframework.org/schema/c"
  	xmlns:context="http://www.springframework.org/schema/context"
  	xmlns:lang="http://www.springframework.org/schema/lang"
  	xmlns:tx="http://www.springframework.org/schema/tx"
  	xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
  		http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.2.xsd
  		http://www.springframework.org/schema/lang http://www.springframework.org/schema/lang/spring-lang-4.2.xsd
  		http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx-4.2.xsd">
  
  	<!--1,如果你有多个数据源需要通过<context:property-placeholder管理，且不愿意放在一个配置文件里，那么一定要加上ignore-unresolvable=“true" -->
  	<context:property-placeholder location="classpath:redis.properties" ignore-unresolvable="true" />
  
  	<!--2,注意新版本2.3以后，JedisPoolConfig的property name，不是maxActive而是maxTotal，而且没有maxWait属性-->
  	<!-- redis连接池配置 -->
  	<bean id="jedisPoolConfig" class="redis.clients.jedis.JedisPoolConfig">
  		<!--最大空闲数 -->
  		<property name="maxIdle" value="${redis.maxIdle}" />
  		<!--连接池的最大数据库连接数 -->
  		<property name="maxTotal" value="${redis.maxTotal}" />
  		<!--最大建立连接等待时间 -->
  		<property name="maxWaitMillis" value="${redis.maxWaitMillis}" />
  		<!--逐出连接的最小空闲时间 默认1800000毫秒(30分钟) -->
  		<property name="minEvictableIdleTimeMillis"
  			value="${redis.minEvictableIdleTimeMillis}" />
  		<!--每次逐出检查时 逐出的最大数目 如果为负数就是 : 1/abs(n), 默认3 -->
  		<property name="numTestsPerEvictionRun"
  			value="${redis.numTestsPerEvictionRun}" />
  		<!--逐出扫描的时间间隔(毫秒) 如果为负数,则不运行逐出线程, 默认-1 -->
  		<property name="timeBetweenEvictionRunsMillis"
  			value="${redis.timeBetweenEvictionRunsMillis}" />
  	</bean>
  
  	<!--redis连接工厂 -->
  	<bean id="jedisConnectionFactory" class="org.springframework.data.redis.connection.jedis.JedisConnectionFactory" destroy-method="destroy">
  		<property name="poolConfig" ref="jedisPoolConfig"></property>
  		<!--IP地址 -->
  		<property name="hostName" value="${redis.host.ip}"></property>
  		<!--端口号 -->
  		<property name="port" value="${redis.port}"></property>
  		<!--如果Redis设置有密码 -->
  		<!-- <property name="password" value="${redis.password}" /> -->
  		<!--客户端超时时间单位是毫秒 -->
  		<property name="timeout" value="${redis.timeout}"></property>
  	</bean>
  
  	<!-- redis操作模板，这里采用尽量面向对象的模板 -->
      <bean id="redisTemplate" class="org.springframework.data.redis.core.RedisTemplate">
          <property name="connectionFactory" ref="jedisConnectionFactory" />
          <!-- 指定redis中key-value的序列化方式（此处省略） -->
      </bean>
      
      <bean id="redisUtil" class="com.znsd.jedis.util.RedisUtil">
      	<property name="redisTemplate" ref="redisTemplate"></property>
      </bean>
  </beans>
  ```

- RedisUtil工具类

  ```java
  public class RedisUtil {
  
  	private RedisTemplate<String, Object> redisTemplate;
  
  	/*
  	 * 如果使用注解注入RedisTemplate对象，则不需要该setter方法
  	 */
  	public void setRedisTemplate(RedisTemplate<String, Object> redisTemplate) {
  		this.redisTemplate = redisTemplate;
  	}
  
  	/**
  	 * String类型缓存获取
  	 * 
  	 * @param key 键
  	 * @return 值
  	 */
  	public Object get(String key) {
  		return key == null ? null : redisTemplate.opsForValue().get(key);
  	}
  
  	/**
  	 * String类型缓存保存
  	 * 
  	 * @param key   键
  	 * @param value 值
  	 * @return true：成功；false：失败
  	 */
  	public boolean set(String key, Object value) {
  		try {
  			if (!StringUtils.isEmpty(key) && null != value) {
  				redisTemplate.opsForValue().set(key, value);
  				return true;
  			}
  		} catch (Exception e) {
  			e.printStackTrace();
  		}
  		return false;
  	}
  
  	// ... ...
  
  }
  ```

- 整合junit测试

  ```java
  //使用junit4进行测试
  @RunWith(SpringJUnit4ClassRunner.class)
  //加载配置文件
  @ContextConfiguration(locations = {"classpath:spring/spring-redis.xml"})
  public class RedisUtilTest {
  
  	@Autowired
  	private RedisUtil redisUtil;
  	
  	@Test
  	public void testSet() {
  		User user = new User(1, "张三", "123");
  		System.out.println(redisUtil.set("k1", "v111111"));
  		System.out.println(redisUtil.set("user", user));
  	}
  	
  	@Test
  	public void testGet() {
  		System.out.println("k1:" + redisUtil.get("k1"));
  		System.out.println("user:" + redisUtil.get("user"));
  	}
  }
  ```

- 运行测试方法

  ![20180907110502](http://www.znsd.com/znsd/courses/uploads/150a215d43992f02c404e94a8b4762e1/20180907110502.png)