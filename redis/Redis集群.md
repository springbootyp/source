# Redis集群

* 创建集群服务器存放目录

  ```shell
  mkdir /usr/local/redis-cluster
  ```

* 将redis安装目录复制至新建目录下

  ```shell
  cp -r redis/bin redis-cluster/redis1
  ```

* 将redis编译后的src目录下的redis-trib.rb复到制redis-cluster目录里面

  ```
  cp /usr/local/src/redis-5.0.3/src/redis-trib.rb /usr/local/redis-cluster/ 
  ```

* 为复制的redis服务设置配置文件，每个服务都有一个配置文件

  ```shell
  daemonize yes 
  bind 127.0.0.1
  Port 7001
  logfile "./redis-7001.log"
  databases 1
  protected-mode no
  pidfile /var/run/redis_7001.pid
  cluster-enabled yes
  ```

* 安装 ruby ：redis集群运行的环境

  ```shell
  # yum 安装需要联网
  yum -y install ruby rubygems
  #查看安装版本，centos6默认安装的ruby是1.8.7版本，执行以下命令更新ruby版本至2.2以上
  ruby -v
  #更新ruby版本至2.2以上
  yum install centos-release-scl-rh　
  #yum 安装ruby2.3
  yum install rh-ruby23  -y
  #
  scl  enable  rh-ruby23 bash
  # 安装redis
  gem install redis
  ```

* 至每个redis服务目录下 逐个启动Redis

  ```shell
  ./redis-server redis_配置文件.conf
  ```

* 将所有redis服务集群

  ```shell
  redis-cli --cluster create 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 127.0.0.1:7006 --cluster-replicas 1
  ```

  ``` shell
  #使用 redis-trib.rb 命令搭建集群
  ./redis-trib.rb create --replicas 1 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 127.0.0.1:7006
  ```

##### 常用命令

```shell
# 查看集群的信息
cluster info 
# 列出集群当前已知的所有节点
cluster nodes 
# 添加主节点
redis-trib.rb add-node 127.0.0.1:7008(新节点) 127.0.0.1:7001（任一老节点）
# 添加从节点
redis-trib.rb add-node --slave --master-id 主节点id 127.0.0.1:7008(新节点) 127.0.0.1:7001（任一老节点）
# 查看集群的信息
redis-trib.rb check 127.0.0.1：7001

```

##### 代码中 使用

```properties
# 在application.properties中配置redis参数
spring.redis.host=192.168.108.130
spring.redis.port=6379
spring.redis.database=0
# 连接池
spring.redis.pool.max-idle=8
spring.redis.pool.min-idle=0
spring.redis.pool.max-active=8
spring.redis.pool.max-wait=1
# 集群的所有节点： 127.0.0.1：7001，127.0.0.1：7002
spring.redis.cluster.nodes=127.0.0.1：7001，127.0.0.1：7002
# 哨兵节点
spring.redis.sentinel.nodes=127.0.0.1：26379
# 哨兵名字
spring.redis.sentinel.master=mymaster
```

```java
@Configuration
public class MongoDBConfig {
	@Value("${spring.redis.pool.max-idle}")
	private int poolMaxIdle;
	@Value("${spring.redis.pool.min-idle}")
	private int poolMinIdle;
	@Value("${spring.redis.pool.max-active}")
	private int poolMinActive;
	@Value("${spring.redis.pool.max-wait}")
	private int poolMaxWait;
	@Value("${spring.redis.host}")
	private String host;
	@Value("${spring.redis.port}")
	private int port;
	
	@Value("${spring.redis.sentinel.nodes}")
	private String sentinelNodes;
	@Value("${spring.redis.sentinel.master}")
	private String sentinelName;
	@Value("${spring.redis.cluster.nodes}")
	private String clusterNodes;

	
	
	@Bean
    @SuppressWarnings({ "rawtypes", "unchecked" })
    public RedisTemplate<String, String> redisTemplate(RedisConnectionFactory redisFactory){
        RedisTemplate template = new StringRedisTemplate(redisFactory);
        // 反序列化设置
        Jackson2JsonRedisSerializer jackson2JsonRedisSerializer = new Jackson2JsonRedisSerializer(Object.class);
        ObjectMapper om = new ObjectMapper();
        om.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        om.enableDefaultTyping(ObjectMapper.DefaultTyping.NON_FINAL);
        jackson2JsonRedisSerializer.setObjectMapper(om);
        template.setValueSerializer(jackson2JsonRedisSerializer);
        template.afterPropertiesSet();
        // 序列化参数设置
        template.setKeySerializer(new StringRedisSerializer());
        template.setHashKeySerializer(new StringRedisSerializer());
        template.setHashValueSerializer(new GenericJackson2JsonRedisSerializer());
        template.setValueSerializer(new GenericJackson2JsonRedisSerializer());
        // 设置连接工厂
        template.setConnectionFactory(redisFactory);
        // 开启事物
        template.setEnableTransactionSupport(true);
        return template;
    }
	
    @Bean
	public  JedisPool JedisPoolFactory() {
		JedisPoolConfig poolConfig = new JedisPoolConfig();
		poolConfig.setMaxIdle(poolMaxIdle);
		poolConfig.setMaxTotal(1000);
		poolConfig.setMaxWaitMillis(poolMaxWait * 1000);
		JedisPool jp = new JedisPool(poolConfig, host, port);
		return jp;
	}
    
    @Bean
    public RedisSentinelConfiguration redisSentinelConfiguration(){
        RedisSentinelConfiguration configuration = new RedisSentinelConfiguration();
        // 根据sentinel的配置生成sentinelConfiguration
        String sentinels[] = sentinelNodes.split(",");
        for(int i=0;i<sentinels.length;i++) {
        	configuration.addSentinel(new RedisNode(sentinels[i].split(":")[0], Integer.parseInt(sentinels[i].split(":")[1])));
        }
        configuration.setMaster(sentinelName);
        return configuration;
    }

    @Bean
    public JedisConnectionFactory jedisConnectionFactory() {
    	// 创建Redis连接时，加上sentinel哨兵设置
        JedisConnectionFactory factory = new JedisConnectionFactory(redisSentinelConfiguration());
        factory.setHostName(host);
        factory.setPort(port);
        factory.setDatabase(0);
        return factory;
    }
    // 集群配置JedisCluster,在Dao类中注入JedisCluster对象便可操作redis服务
    @Bean
    public JedisCluster jedisCluster() {
    	String nodes[] = clusterNodes.split(",");
    	Set<HostAndPort> nodeSet = new HashSet<HostAndPort>();
    	for(int i=0;i<nodes.length;i++) {
    		nodeSet.add(new HostAndPort(nodes[i].split(":")[0], Integer.parseInt(nodes[i].split(":")[1])));
    	}
    	return new JedisCluster(nodeSet);
    }
}
```





