# 第二章 SpringBoot 配置文件 

## 1、配置文件 

Spring Boot使用全局配置文件，配置文件名是固定的；

- application.properties
- application.yml 

配置文件作用：修改Spring Boot在底层封装好的默认值；

YAML（YAML AIN'T Markup Language）

是一个标记语言

又不是一个标记语言 

**标记语言：**

以前的配置文件；大多数使用的是 xxx.xml文件；

以数据为中心，比json、xml等更适合做配置文件

YAML：配置例子 

```yaml
server:
	port: 9000 
```

XML: 

```xml
<server>
	<port>9000</port>
</server> 
```

## 2、YAML语法 

### 1、基本语法 

k:(空格)v:表示一堆键值对（空格必须有）；

以空格的缩进来控制层级关系；只要是左对齐的一列数据，都是同一层级的 

```yaml
server:
	port: 9000
	path: /hello 
```

属性和值也是大小写敏感 

### 2、值的写法

**字面量：普通的值（数字，字符串，布尔）** 

k: v:字面直接来写；

字符串默认不用加上单引号或者双引号

"":**双引号** 不会转义字符串里的特殊字符；特殊字符会作为本身想要表示的意思

`name:"zhangsan\n lisi"` 输出：`zhangsan换行 lisi`

'':**单引号** 会转义特殊字符，特殊字符最终只是一个普通的字符串数据

`name:'zhangsan\n lisi'` 输出：`zhangsan\n lisi` 

**对象、Map（属性和值）键值对** 

k :v ：在下一行来写对象的属性和值的关系；注意空格控制缩进

对象还是k:v的方式 

```yaml
frends:
	lastName: zhangsan
	age: 20 
```

行内写法 

```yaml
friends: {lastName: zhangsan,age: 18} 
```

**数组（List、Set）:**
用-表示数组中的一个元素 

```yaml
pets:
 ‐ cat
 ‐ dog
 ‐ pig 
```

行内写法 

```yaml
pets: [cat,dog,pig] 
```

**组合变量**

多个组合到一起 

## 3、配置文件值注入 

### 1、@ConfigurationProperties

1、application.yml 配置文件 

```yaml
person:
  age: 18
  boss: false
  birth: 2017/12/12
  maps: {k1: v1,k2: 12}
  lists:
   - lisi
   - zhaoliu
  dog:
    name: wangwang
    age: 2
  last-name: wanghuahua
```

`application.properties` 配置文件（二选一） 

```properties
idea配置文件utf-8
properties 默认GBK
person.age=12
person.boss=false
person.last-name=张三
person.maps.k1=v1
person.maps.k2=v2
person.lists=a,b,c
person.dog.name=wanghuahu
person.dog.age=15
```

所以中文输出乱码，改进settings-->file encoding -->[property-->utf-8 ,勾选转成ascii] 

javaBean 

```java
/**
* 将配置文件的配置每个属性的值，映射到组件中
* @ConfigurationProperties:告诉SpringBoot将文本的所有属性和配置文件中的相关配置进行绑定；
* prefix = "person" 配置文件爱你的那个属性进行一一映射
* *
只有这个组件是容器中的组件，才能提供到容器中
*/
@Component
@ConfigurationProperties(prefix = "person")
public class Person {
    private String lastName;
    private Integer age;
    private Boolean boss;
    private Map<String,Object> maps;
    private List<Object> lists;
    private Dog dog;
```

导入配置文件处理器，以后编写配置就有提示了 

```xml
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring‐boot‐configuration‐processor</artifactId>
	<optional>true</optional>
</dependency> 
```
### 2、@Value注解

更改javaBean中的注解

```java
@Component
public class Person {
    /**
     * <bean class="Person">
     *     <property name="lastName" value="字面量/${key}从环境变量/#{spEL}"></property>
     * </bean>
     */
    @Value("${person.last-name}")
    private String lastName;
    @Value("#{11*2}")
    private Integer age;
    @Value("true")
    private Boolean boss;
```

|                | @ConfigurationProperties |  @Value  |
| :------------: | :----------------------: | :------: |
|      功能      |   批量注入配置文件属性   | 单个指定 |
| 松散绑定(语法) |           支持           |  不支持  |
|      spEL      |          不支持          |   支持   |
|   JSR303校验   |           支持           |  不支持  |
|    复杂类型    |           支持           |  不支持  |

> 松散语法：javaBean中last-name(或者lastName) -->application.properties中的last-name;
>
> spEL语法：#{11*2} 
>
> JSR303：@Value会直接忽略，校验规则

JSR303校验：

```java
@Component
@ConfigurationProperties(prefix = "person")
@Validated
public class Person {
    @Email
    private String lastName;
```

复杂类型栗子：

```java
@Component
public class Person {
    /**
     * <bean class="Person">
     *     <property name="lastName" value="字面量/${key}从环境变量/#{spEL}"></property>
     * </bean>
     */
    private String lastName;
    private Integer age;
    private Boolean boss;
   // @Value("${person.maps}")
    private Map<String,Object> maps;
```

以上会报错，不支持复杂类型

**使用场景分析**

	如果说，我们只是在某个业务逻辑中获取一下配置文件的某一项值，使用@Value；

如果专门编写了一个javaBean和配置文件进行映射，我们直接使用@ConfigurationProperties

举栗子：

1、编写新的Controller文件

```java
@RestController
public class HelloController {

    @Value("${person.last-name}")
    private String name;
    @RequestMapping("/hello")
    public  String sayHello(){
        return "Hello"+ name;
    }
}
```

2、配置文件

```properties
person.age=12
person.boss=false
person.last-name=李四
person.maps.k1=v1
person.maps.k2=v2
person.lists=a,b,c
person.dog.name=wanghuahu
person.dog.age=15
```

3、测试运行

访问 localhost:9000/hello

结果为`Hello 李四`

### 3、其他注解
 **@PropertySource**

作用：加载指定的properties配置文件

1、新建一个person.properties文件

```properties
person.age=12
person.boss=false
person.last-name=李四
person.maps.k1=v1
person.maps.k2=v2
person.lists=a,b,c
person.dog.name=wanghuahu
person.dog.age=15
```

2、在javaBean中加入@PropertySource注解

```java
@PropertySource(value = {"classpath:person.properties"})
@Component
@ConfigurationProperties(prefix = "person")
public class Person {
    private String lastName;
```

**@ImportResource**

作用：导入Spring配置文件，并且让这个配置文件生效

1、新建一个Spring的配置文件，bean.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="HelloService" class="com.wdjr.springboot.service.HelloService"></bean>
</beans>
```

2、编写测试类，检查容器是否加载Spring配置文件写的bean

```java
@Autowired
ApplicationContext ioc;

@Test
public void testHelloService(){
    boolean b = ioc.containsBean("HelloService");
    System.out.println(b);
}
```

> import org.springframework.context.ApplicationContext;

3、运行检测

结果为false，没有加载配置的内容

4、使用@ImportResource注解

将@ImportResource标注在主配置类上

```java
@ImportResource(locations={"classpath:beans.xml"})
@SpringBootApplication
public class SpringBoot02ConfigApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpringBoot02ConfigApplication.class, args);
    }
}
```

5、再次运行检测

结果为true

缺点：每次指定xml文件太麻烦

SpringBoot推荐给容器添加组件的方式：

1、配置类=====Spring的xml配置文件（old）

2、全注解方式@Configuration+@Bean（new）

![4.MyAppConfig](assets/4.MyAppConfig.jpg)



```java
/**
 * @Configuration：指明当前类是一个配置类；就是来代替之前的Spring配置文件
 *
 * 在配置文件中用<bean></bean>标签添加组件
 */

@Configuration
public class MyAppConfig {

    //将方法的返回值添加到容器中；容器这个组件id就是方法名
    @Bean
    public HelloService helloService01(){
        System.out.println("配置类给容器添加了HelloService组件");
        return new HelloService();
    }
}
```

```java
@Autowired
ApplicationContext ioc;

@Test
public void testHelloService(){
    boolean b = ioc.containsBean("helloService01");
    System.out.println(b);
}
```

 *容器这个组件id就是方法名* 

## 4、配置文件占位符

#### 1、随机数

```properties
${random.value} 、${random.int}、${random.long}
${random.int(10)}、${random.int[100,200]}
```

#### 2、获取配置值

```properties
person.age=${random.int}
person.boss=false
person.last-name=张三${random.uuid}
person.maps.k1=v1
person.maps.k2=v2
person.lists=a,b,c
person.dog.name=${person.last-name}'s wanghuahu
person.dog.age=15
```

存在以下两种情况

没有声明`person.last-name`会报错，新声明的需要加默认值

```properties
person.age=${random.int}
person.boss=false
person.last-name=张三${random.uuid}
person.maps.k1=v1
person.maps.k2=v2
person.lists=a,b,c
person.dog.name=${person.hello:hello}'s wanghuahu
person.dog.age=15
```

结果：输出`hello's wanghuahua`

## 5、Profile

### 1、多Profile文件

我们在主配置文件编写的时候，文件名可以是 application-{profile}.properties/yml

- application.properties
- application-dev.properties
- application-prod.properties

默认使用application.properties

application.properties配置文件指定

```properties
spring.profiles.active=dev
```

### 2、YAML文档块

```yaml
server:
  port: 8081
spring:
  profiles:
    active: dev

---

server:
  port: 9000
spring:
  profiles: dev

---
server:
  port: 80
spring:
  profiles: prod

```

### 3、激活指定profile

1、在配置文件中激活

2、命令行：

--spring.profiles.active=dev

![5.comandLine](assets/5.comandLine.jpg)

优先级大于配置文件

打包 成jar后

`java -jar spring-boot-02-config-0.0.1-SNAPSHOT.jar --spring.profiles.active=dev`

虚拟机参数

`-Dspring.profiles.active=dev`

## 6、加载配置文件位置

SpringBoot启动扫描以下位置的application.properties或者application.yml文件作为Spring boot的默认配置文件

- file:./config/
- file./
- classpath:/config/
- classpath:/

优先级从高到低顺序，高优先级会覆盖低优先级的相同配置；互补配置

也可以通过spring.config.location来改变默认配置

> ```
> server.servlet.context-path=/boot03
> ```

注：spring boot1x 是server.context.path=/boot02



![7.priority](assets/7.priority.jpg)

还可以通过spring.config.location来改变配置文件的位置

项目打包好了以后，可以使用命令行参数的形式，启动项目的时候来指定配置文件的新位置；指定配置文件和默认的配置文件会共同起作用，互补配置

`java -jar spring-boot-config-02-0.0.1-SNAPSHOT.jar --spring.config.location=E:/work/application.properties`

运维比较有用，从外部加载，不用修改别的文件

## 7.引入外部配置

**SpringBoot也可以从以下位置加载配置；优先级从高到低；高优先级覆盖低优先级，可以互补**

1. 命令行参数

   java -jar spring-boot-config-02-0.0.1-SNAPSHOT.jar --server.port=9005 --server.context-path=/abc

   中间一个空格

2. 来自java:comp/env的JNDI属性

3. java系统属性（System.getProperties()）

4. 操作系统环境变量

5. RandomValuePropertySource配置的random.*属性值

    

   **优先加载profile,    由jar包外到jar包内**

6. **jar包外部的application-{profile}.properties或application.yml(带Spring.profile)配置文件**

7. **jar包内部的application-{profile}.properties或application.yml(带Spring.profile)配置文件**

8. **jar包外部的application.properties或application.yml(带Spring.profile)配置文件**

9. **jar包内部的application.properties或application.yml(不带spring.profile)配置文件**

    

10. @Configuration注解类的@PropertySource

11. 通过SpringApplication.setDefaultProperties指定的默认属性

[官方文档](https://docs.spring.io/spring-boot/docs/2.0.1.RELEASE/reference/htmlsingle/#boot-features-external-config)

## 8、自动配置

配置文件到底怎么写？

[Spring的所有配置参数](https://docs.spring.io/spring-boot/docs/2.0.1.RELEASE/reference/htmlsingle/#common-application-properties)

自动配置原理很关键

### 1、自动配置原理

1）、SpringBoot启动的时候加载主配置类，开启自动配置功能，@EnableAutoConfiguration

2）、@EnableAutoConfiguration 作用：

- 利用AutoConfigurationImportSelector给容器中导入一些组件？
- 可以查看selectImports()方法的内容
- 获取候选的配置

```java
List<String> configurations = this.getCandidateConfigurations(annotationMetadata, attributes);
```


- 扫描类路径下的
```java
  SpringFactoriesLoader.loadFactoryNames(）
  扫描所有jar包类路径下的 MATA-INF/spring.factories
  把扫描到的这些文件的内容包装成properties对象
  从properties中获取到EnableAutoConfiguration.class类（类名）对应的值，然后把他们添加到容器中
```
将类路径下 MATE-INF/spring.factories里面配置的所有的EnableAutoConfiguration的值加入到了容器中；

3）、每一个自动配置类进行自动配置功能；

4）、以**HttpEncodingAutoConfiguration** 为例

```java
@Configuration //表示是一个配置类，以前编写的配置文件一样，也可以给容器中添加组件
@EnableConfigurationProperties({HttpEncodingProperties.class})//启动指定类的Configurationproperties功能；将配置文件中的值和HttpEncodingProperties绑定起来了；并把HttpEncodingProperties加入ioc容器中
@ConditionalOnWebApplication//根据不同的条件，进行判断，如果满足条件，整个配置类里面的配置就会失效，判断是否为web应用；
(
    type = Type.SERVLET
)
@ConditionalOnClass({CharacterEncodingFilter.class})//判断当前项目有没有这个类，解决乱码的过滤器
@ConditionalOnProperty(
    prefix = "spring.http.encoding",
    value = {"enabled"},
    matchIfMissing = true
)//判断配置文件是否存在某个配置 spring.http.encoding，matchIfMissing = true如果不存在也是成立，即使不配置也生效
public class HttpEncodingAutoConfiguration {
   //给容器添加组件，这个组件的值需要从properties属性中获取
    private final HttpEncodingProperties properties;
	//只有一个有参数构造器情况下，参数的值就会从容器中拿
    public HttpEncodingAutoConfiguration(HttpEncodingProperties properties) {
        this.properties = properties;
    }

    @Bean
    @ConditionalOnMissingBean
    public CharacterEncodingFilter characterEncodingFilter() {
        CharacterEncodingFilter filter = new OrderedCharacterEncodingFilter();
        filter.setEncoding(this.properties.getCharset().name());
        filter.setForceRequestEncoding(this.properties.shouldForce(org.springframework.boot.autoconfigure.http.HttpEncodingProperties.Type.REQUEST));
        filter.setForceResponseEncoding(this.properties.shouldForce(org.springframework.boot.autoconfigure.http.HttpEncodingProperties.Type.RESPONSE));
        return filter;
    }

```

5）、所有在配置文件中能配置的属性都是在xxxProperties类中封装着；配置文件能配置什么就可以参照某个功能对应的这个属性类

```java
@ConfigurationProperties(prefix = "spring.http.encoding")//从配置文件中的值进行绑定和bean属性进行绑定
public class HttpEncodingProperties {
```

根据当前不同条件判断，决定这个配置类是否生效？

一旦这个配置类生效；这个配置类会给容器添加各种组件；这些组件的属性是从对应的properties中获取的，这些类里面的每个属性又是和配置文件绑定的



### 2、所有的自动配置组件

每一个xxxAutoConfiguration这样的类都是容器中的一个组件，都加入到容器中；

作用：用他们做自动配置

```properties
# Auto Configure
org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
org.springframework.boot.autoconfigure.admin.SpringApplicationAdminJmxAutoConfiguration,\
org.springframework.boot.autoconfigure.aop.AopAutoConfiguration,\
org.springframework.boot.autoconfigure.amqp.RabbitAutoConfiguration,\
org.springframework.boot.autoconfigure.batch.BatchAutoConfiguration,\
org.springframework.boot.autoconfigure.cache.CacheAutoConfiguration,\
org.springframework.boot.autoconfigure.cassandra.CassandraAutoConfiguration,\
org.springframework.boot.autoconfigure.cloud.CloudAutoConfiguration,\
org.springframework.boot.autoconfigure.context.ConfigurationPropertiesAutoConfiguration,\
org.springframework.boot.autoconfigure.context.MessageSourceAutoConfiguration,\
org.springframework.boot.autoconfigure.context.PropertyPlaceholderAutoConfiguration,\
org.springframework.boot.autoconfigure.couchbase.CouchbaseAutoConfiguration,\
org.springframework.boot.autoconfigure.dao.PersistenceExceptionTranslationAutoConfiguration,\
org.springframework.boot.autoconfigure.data.cassandra.CassandraDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.cassandra.CassandraReactiveDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.cassandra.CassandraReactiveRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.cassandra.CassandraRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.couchbase.CouchbaseDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.couchbase.CouchbaseReactiveDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.couchbase.CouchbaseReactiveRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.couchbase.CouchbaseRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.elasticsearch.ElasticsearchAutoConfiguration,\
org.springframework.boot.autoconfigure.data.elasticsearch.ElasticsearchDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.elasticsearch.ElasticsearchRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.jpa.JpaRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.ldap.LdapDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.ldap.LdapRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.mongo.MongoDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.mongo.MongoReactiveDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.mongo.MongoReactiveRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.mongo.MongoRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.neo4j.Neo4jDataAutoConfiguration,\
org.springframework.boot.autoconfigure.data.neo4j.Neo4jRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.solr.SolrRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration,\
org.springframework.boot.autoconfigure.data.redis.RedisReactiveAutoConfiguration,\
org.springframework.boot.autoconfigure.data.redis.RedisRepositoriesAutoConfiguration,\
org.springframework.boot.autoconfigure.data.rest.RepositoryRestMvcAutoConfiguration,\
org.springframework.boot.autoconfigure.data.web.SpringDataWebAutoConfiguration,\
org.springframework.boot.autoconfigure.elasticsearch.jest.JestAutoConfiguration,\
org.springframework.boot.autoconfigure.flyway.FlywayAutoConfiguration,\
org.springframework.boot.autoconfigure.freemarker.FreeMarkerAutoConfiguration,\
org.springframework.boot.autoconfigure.gson.GsonAutoConfiguration,\
org.springframework.boot.autoconfigure.h2.H2ConsoleAutoConfiguration,\
org.springframework.boot.autoconfigure.hateoas.HypermediaAutoConfiguration,\
org.springframework.boot.autoconfigure.hazelcast.HazelcastAutoConfiguration,\
org.springframework.boot.autoconfigure.hazelcast.HazelcastJpaDependencyAutoConfiguration,\
org.springframework.boot.autoconfigure.http.HttpMessageConvertersAutoConfiguration,\
org.springframework.boot.autoconfigure.http.codec.CodecsAutoConfiguration,\
org.springframework.boot.autoconfigure.influx.InfluxDbAutoConfiguration,\
org.springframework.boot.autoconfigure.info.ProjectInfoAutoConfiguration,\
org.springframework.boot.autoconfigure.integration.IntegrationAutoConfiguration,\
org.springframework.boot.autoconfigure.jackson.JacksonAutoConfiguration,\
org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration,\
org.springframework.boot.autoconfigure.jdbc.JdbcTemplateAutoConfiguration,\
org.springframework.boot.autoconfigure.jdbc.JndiDataSourceAutoConfiguration,\
org.springframework.boot.autoconfigure.jdbc.XADataSourceAutoConfiguration,\
org.springframework.boot.autoconfigure.jdbc.DataSourceTransactionManagerAutoConfiguration,\
org.springframework.boot.autoconfigure.jms.JmsAutoConfiguration,\
org.springframework.boot.autoconfigure.jmx.JmxAutoConfiguration,\
org.springframework.boot.autoconfigure.jms.JndiConnectionFactoryAutoConfiguration,\
org.springframework.boot.autoconfigure.jms.activemq.ActiveMQAutoConfiguration,\
org.springframework.boot.autoconfigure.jms.artemis.ArtemisAutoConfiguration,\
org.springframework.boot.autoconfigure.groovy.template.GroovyTemplateAutoConfiguration,\
org.springframework.boot.autoconfigure.jersey.JerseyAutoConfiguration,\
org.springframework.boot.autoconfigure.jooq.JooqAutoConfiguration,\
org.springframework.boot.autoconfigure.jsonb.JsonbAutoConfiguration,\
org.springframework.boot.autoconfigure.kafka.KafkaAutoConfiguration,\
org.springframework.boot.autoconfigure.ldap.embedded.EmbeddedLdapAutoConfiguration,\
org.springframework.boot.autoconfigure.ldap.LdapAutoConfiguration,\
org.springframework.boot.autoconfigure.liquibase.LiquibaseAutoConfiguration,\
org.springframework.boot.autoconfigure.mail.MailSenderAutoConfiguration,\
org.springframework.boot.autoconfigure.mail.MailSenderValidatorAutoConfiguration,\
org.springframework.boot.autoconfigure.mongo.embedded.EmbeddedMongoAutoConfiguration,\
org.springframework.boot.autoconfigure.mongo.MongoAutoConfiguration,\
org.springframework.boot.autoconfigure.mongo.MongoReactiveAutoConfiguration,\
org.springframework.boot.autoconfigure.mustache.MustacheAutoConfiguration,\
org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration,\
org.springframework.boot.autoconfigure.quartz.QuartzAutoConfiguration,\
org.springframework.boot.autoconfigure.reactor.core.ReactorCoreAutoConfiguration,\
org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration,\
org.springframework.boot.autoconfigure.security.servlet.UserDetailsServiceAutoConfiguration,\
org.springframework.boot.autoconfigure.security.servlet.SecurityFilterAutoConfiguration,\
org.springframework.boot.autoconfigure.security.reactive.ReactiveSecurityAutoConfiguration,\
org.springframework.boot.autoconfigure.security.reactive.ReactiveUserDetailsServiceAutoConfiguration,\
org.springframework.boot.autoconfigure.sendgrid.SendGridAutoConfiguration,\
org.springframework.boot.autoconfigure.session.SessionAutoConfiguration,\
org.springframework.boot.autoconfigure.security.oauth2.client.OAuth2ClientAutoConfiguration,\
org.springframework.boot.autoconfigure.solr.SolrAutoConfiguration,\
org.springframework.boot.autoconfigure.thymeleaf.ThymeleafAutoConfiguration,\
org.springframework.boot.autoconfigure.transaction.TransactionAutoConfiguration,\
org.springframework.boot.autoconfigure.transaction.jta.JtaAutoConfiguration,\
org.springframework.boot.autoconfigure.validation.ValidationAutoConfiguration,\
org.springframework.boot.autoconfigure.web.client.RestTemplateAutoConfiguration,\
org.springframework.boot.autoconfigure.web.embedded.EmbeddedWebServerFactoryCustomizerAutoConfiguration,\
org.springframework.boot.autoconfigure.web.reactive.HttpHandlerAutoConfiguration,\
org.springframework.boot.autoconfigure.web.reactive.ReactiveWebServerFactoryAutoConfiguration,\
org.springframework.boot.autoconfigure.web.reactive.WebFluxAutoConfiguration,\
org.springframework.boot.autoconfigure.web.reactive.error.ErrorWebFluxAutoConfiguration,\
org.springframework.boot.autoconfigure.web.reactive.function.client.WebClientAutoConfiguration,\
org.springframework.boot.autoconfigure.web.servlet.DispatcherServletAutoConfiguration,\
org.springframework.boot.autoconfigure.web.servlet.ServletWebServerFactoryAutoConfiguration,\
org.springframework.boot.autoconfigure.web.servlet.error.ErrorMvcAutoConfiguration,\
org.springframework.boot.autoconfigure.web.servlet.HttpEncodingAutoConfiguration,\
org.springframework.boot.autoconfigure.web.servlet.MultipartAutoConfiguration,\
org.springframework.boot.autoconfigure.web.servlet.WebMvcAutoConfiguration,\
org.springframework.boot.autoconfigure.websocket.reactive.WebSocketReactiveAutoConfiguration,\
org.springframework.boot.autoconfigure.websocket.servlet.WebSocketServletAutoConfiguration,\
org.springframework.boot.autoconfigure.websocket.servlet.WebSocketMessagingAutoConfiguration,\
org.springframework.boot.autoconfigure.webservices.WebServicesAutoConfiguration

```

### 3、精髓：

1）、SpringBoot启动会加载大量的自动配置类

2）、我们看我们需要的功能有没有SpringBoot默认写好的默认配置类；

3）、如果有在看这个自动配置类中配置了哪些组件；（只要我们要用的组件有，我们需要再来配置）

4）、给容器中自动配置添加组件的时候，会从properties类中获取属性。我们就可以在配置文件中指定这些属性的值

xxxAutoConfiguration:自动配置类；

给容器中添加组件

xxxProperties:封装配置文件中的属性；

跟之前的Person类一样，配置文件中值加入bean中

### 4、细节

#### 1、@Conditional派生注解 

> 利用Spring注解版原生的@Conditional作用

作用：必须是@Conditional指定的条件成立，才给容器中添加组件，配置配里面的所有内容才生效；

| @Conditional派生注解            | 作用（判断是否满足当前指定条件）                |
| ------------------------------- | ----------------------------------------------- |
| @ConditionalOnJava              | 系统的java版本是否符合要求                      |
| @ConditionalOnBean              | 容器中存在指定Bean                              |
| @ConditionalOnMissBean          | 容器中不存在指定Bean                            |
| @ConditionalOnExpression        | 满足spEL表达式                                  |
| @ConditionalOnClass             | 系统中有指定的类                                |
| @ConditionalOnMissClass         | 系统中没有指定的类                              |
| @ConditionalOnSingleCandidate   | 容器中只有一个指定的Bean,或者这个Bean是首选Bean |
| @ConditionalOnProperty          | 系统中指定的属性是否有指定的值                  |
| @ConditionalOnResource          | 类路径下是否存在指定的资源文件                  |
| @ConditionalOnWebApplication    | 当前是web环境                                   |
| @ConditionalOnNotWebApplication | 当前不是web环境                                 |
| @ConditionalOnJndi              | JNDI存在指定项                                  |

#### 2、自动配置报告

自动配置类必须在一定条件下生效

我们可以通过启用debug=true属性，配置文件，打印自动配合报告，这样就可以知道自动配置类生效

```properties
debug=true
```

自动配置报告

```java
============================

CONDITIONS EVALUATION REPORT
============================


Positive matches:（启动的，匹配成功的）
-----------------

   CodecsAutoConfiguration matched:
      - @ConditionalOnClass found required class 'org.springframework.http.codec.CodecConfigurer'; @ConditionalOnMissingClass did not find unwanted class (OnClassCondition)
        ......
        
 Negative matches:（没有启动的，没有匹配成功的）
-----------------

   ActiveMQAutoConfiguration:
      Did not match:
         - @ConditionalOnClass did not find required classes 'javax.jms.ConnectionFactory', 'org.apache.activemq.ActiveMQConnectionFactory' (OnClassCondition)
.....
```