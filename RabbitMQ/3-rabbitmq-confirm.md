## 第三章 RabbitMQ 消息确认机制

### 1. 概述

- 在Rabbitmq中我们可以通过持久化来解决因为服务器异常而导致丢失的问题,除此之外我们还会遇到一个问题:生产者将消息发送出去之后,消息到底有没有正确到达 Rabbit服务器我们是不知道的（即Rabbit服务器不会反馈任何消息给生产者）也就是默认的情况下是不知道消息有没有正确到达;
- 导致的问题:消息到达服务器之前丢失,那么持久化也不能解决此问题,因为消息根本就没有到达Rabbit服务器!
- **RabbitMQ** 为我们提供了两种方式
  1. 通过AMQP事务机制实现，这也是AMQP协议层面提供的解决方案；
  2. 通过将channel设置成confirm模式来实现；

### 2. 事务机制

#### 2.1 AMQP事务机制

- RabbitMQ中与事务机制有关的方法有三个

1. **txSelect()** 用于将当前channel设置成transaction模式
2. **txCommit()** 用于提交事务
3. **txRollback()** 用于回滚事务

- 在通过txSelect开启事务之后，我们便可以发布消息给broker代理服务器了，如果txCommit提交成功了，则消息一定到达了broker了，如果在txCommit执行之前broker异常崩溃或者由于其他原因抛出异常，这个时候我们便可以捕获异常通过txRollback回滚事务了。

- 关键代码：

  ```java
  channel.txSelect();
  channel.basicPublish("", QUEUE_NAME, null, msg.getBytes());
  channel.txCommit();
  ```

- 生产者

  ```java
  public class Send {
  	
  	private static final String TX_QUEUE_NAME = "test_tx_queue";
  
  	public static void main(String[] args) throws IOException, TimeoutException {
  		
  		Connection connection = ConnectionUtil.getConnection();
  		
  		Channel channel = connection.createChannel();
  		
  		channel.queueDeclare(TX_QUEUE_NAME, false, false, false, null);
  		
  		channel.txSelect();
  		
  		try {
  			String msg = "hello tx message";
  			channel.basicPublish("", TX_QUEUE_NAME, null, msg.getBytes());
  			// int i = 1 / 0;
  			channel.txCommit();
  			
  			System.out.println("send msg: " + msg);
  		} catch (Exception e) {
  			channel.txRollback();
  			e.printStackTrace();
  		}
  		
  		channel.close();
  		connection.close();
  		
  	}
  }
  ```

- 消费者

  ```java
  public class Reciver {
  
  	private static final String TX_QUEUE_NAME = "test_tx_queue";
  
  	public static void main(String[] args) throws IOException, TimeoutException {
  		
  		Connection connection = ConnectionUtil.getConnection();
  		
  		Channel channel = connection.createChannel();
  		
  		channel.queueDeclare(TX_QUEUE_NAME, false, false, false, null);
  		
  		channel.basicConsume(TX_QUEUE_NAME, true, new DefaultConsumer(channel) {
  			@Override
  			public void handleDelivery(String consumerTag, Envelope envelope, BasicProperties properties, byte[] body)
  					throws IOException {
  				
  				System.out.println("reciver msg: " + new String(body, "UTF-8"));
  			}
  		});
  	}
  }
  ```

- 此种模式还是很耗时的,采用这种方式`降低了Rabbitmq的消息吞吐量`

### 3. Confirm模式

#### 3.1 概述

上面我们介绍了RabbitMQ可能会遇到的一个问题，即生成者不知道消息是否真正到达消息队列，随后通过AMQP协议层面为我们提供了事务机制解决了这个问题，但是采用事务机制实现会降低RabbitMQ的消息吞吐量，那么我们需要用到Confirm模式来解决这个问题。

#### 3.2 开启confirm模式的方法

- `注意：`已经在 **transaction** 事务模式的 **channel** 是不能再设置成 **confirm** 模式的，即这两种模式是不能共存的。

- 生产者通过调用channel的confirmSelect方法将channel设置为confirm模式

  ```java
  // 生产者通过调用channel的confirmSelect方法将channel设置为confirm模式
  channel.confirmSelect();
  ```

- 开启confirm有**三种编程模式**

1. 普通confirm模式：每发送一条消息后，调用waitForConfirms()方法，等待服务器端confirm。实际上是一种串行confirm了。
2. 批量confirm模式：每发送一批消息后，调用waitForConfirms()方法，等待服务器端confirm。
3. 异步confirm模式：提供一个回调方法，服务端confirm了一条或者多条消息后Client端会回调这个方法。

##### 3.2.1 普通confirm模式

```java
/* 从连接中创建通道 */
Channel channel = connection.createChannel();
channel.queueDeclare(QUEUE_NAME , false , false , false , null );
//生产者通过调用channel的confirmSelect方法将channel设置为confirm模式
channel.confirmSelect();
String msg = "Hello QUEUE !";
channel.basicPublish("", QUEUE_NAME , null ,msg.getBytes());

if (!channel.waitForConfirms()){
	System. out .println("send message failed.");
} else {
	System. out .println(" send messgae ok ...");
}
```

##### 3.2.2 批量**confirm**模式

批量confirm模式稍微复杂一点，客户端程序需要定期（每隔多少秒）或者定量（达到多少条）或者两则结合起来
publish消息，然后等待服务器端confirm, 相比普通confirm模式，批量极大提升confirm效率，但是问题在于一旦
出现confirm返回false或者超时的情况时，客户端需要将这一批次的消息全部重发，这会带来明显的重复消息数
量，并且，当消息经常丢失时，批量confirm性能应该是不升反降的。

```java
/* 从连接中创建通道 */
Channel channel = connection.createChannel();
channel.queueDeclare(QUEUE_NAME, false, false, false, null);

//生产者通过调用channel的confirmSelect方法将channel设置为confirm模式
channel.confirmSelect();
String msg = "Hello QUEUE !";

for ( int i = 0; i < 10; i++) {
	channel.basicPublish("", QUEUE_NAME , null ,msg.getBytes());
}

if (!channel.waitForConfirms()){
	System. out .println("send message failed.");
} else {
	System. out .println(" send messgae ok ...");
}
```

##### 3.2.3 异步**confirm**模式

Channel对象提供的ConfirmListener()回调方法只包含deliveryTag（当前Chanel发出的消息序号），我们需要自己为每一个Channel维护一个unconfirm的消息序号集合，每publish一条数据，集合中元素加 1 ，每回调一次handleAck方法，unconfirm集合删掉相应的一条（multiple=false）或多条（multiple=true）记录。从程序运行效率上看，这个unconfirm集合最好采用有序集合SortedSet存储结构。实际上，SDK中的waitForConfirms()方法也是通过SortedSet维护消息序号的。

```java
public class SendAync {
	
	private static final String QUEUE_NAME = "QUEUE_simple_confirm_aync";

	public static void main(String[] args) throws IOException, TimeoutException {
		/* 获取一个连接 */
		Connection connection = ConnectionUtil.getConnection();
		/* 从连接中创建通道 */
		Channel channel = connection.createChannel();
		channel.queueDeclare(QUEUE_NAME, false, false, false, null);
		
		//生产者通过调用channel的confirmSelect方法将channel设置为confirm模式
		channel.confirmSelect();
		
		final SortedSet<Long> confirmSet = Collections.synchronizedSortedSet(new TreeSet<Long>());
		
		channel.addConfirmListener(new ConfirmListener() {
			
			//每回调一次handleAck方法，unconfirm集合删掉相应的一条（multiple=false）或多条（multiple=true）记录。
			@Override
			public void handleAck(long deliveryTag, boolean multiple) throws IOException {
				if (multiple) {
					System.out.println("--multiple--");
					confirmSet.headSet(deliveryTag + 1).clear();// 用一个SortedSet, 返回此有序集合中小于end的所有元素。
				} else {
					System.out.println("--multiple false--");
					confirmSet.remove(deliveryTag);
				}
			}

			@Override
			public void handleNack(long deliveryTag, boolean multiple) throws IOException {
				System.out.println("Nack, SeqNo: " + deliveryTag + ", multiple:" + multiple);
				if (multiple) {
					confirmSet.headSet(deliveryTag + 1).clear();
				} else {
					confirmSet.remove(deliveryTag);
				}
			}
		});
		
		String msg = "Hello QUEUE !";
		
		while (true) {
			long nextSeqNo = channel.getNextPublishSeqNo();
			channel.basicPublish("", QUEUE_NAME, null, msg.getBytes());
			confirmSet.add(nextSeqNo);
		}
	}
}
```

### 4. RabbitMQ整合spring

- maven依赖

  ```xml
  <dependency>
      <groupId>org.springframework.amqp</groupId>
      <artifactId>spring-rabbit</artifactId>
      <version>1.7.5.RELEASE</version>
  </dependency>
  ```

- Spring配置文件

  ```xml
  <beans xmlns="http://www.springframework.org/schema/beans"
  	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  	xmlns:rabbit="http://www.springframework.org/schema/rabbit"
  	xsi:schemaLocation="http://www.springframework.org/schema/rabbit 
  	http://www.springframework.org/schema/rabbit/spring-rabbit-1.4.xsd 
  	http://www.springframework.org/schema/beans 
  	http://www.springframework.org/schema/beans/spring-beans-4.0.xsd">
  	
  	<!-- 1.定义RabbitMQ的连接工厂 -->
  	<rabbit:connection-factory id="connectionFactory" host="192.168.0.24" port="5672"
  		username="user_mmr" password="123" virtual-host="/vhost_mmr" />
  		
  	<!-- 2.定义Rabbit模板,指定连接工厂以及定义exchange -->
  	<rabbit:template id="amqpTemplate" connection-factory="connectionFactory" />
  	
  	<!-- MQ的管理,包括队列、交换器 声明等 -->
  	<rabbit:admin connection-factory="connectionFactory" />
  	
  	<!-- 定义队列,自动声明 -->
  	<rabbit:queue name="myQueue" auto-declare="true" durable="true" />
  
  	<!-- 定义交换器,自动声明 -->
  	<rabbit:fanout-exchange name="fanoutExchange" auto-declare="true">
  		<rabbit:bindings>
  			<rabbit:binding queue="myQueue" />
  		</rabbit:bindings>
  	</rabbit:fanout-exchange>
  	
  	<!-- 队列监听 -->
  	<rabbit:listener-container connection-factory="connectionFactory">
  		<rabbit:listener ref="foo" method="listen" queue-names="myQueue" />
  	</rabbit:listener-container>
  	
  	<!-- 消费者 -->
  	<bean id="foo" class="com.znsd.rabbitmq.spring.MyConsumer" />
  </beans>
  ```

- 生产者

  ```java
  public class SpringProducer {
  
  	public static void main(String[] args) throws InterruptedException {
  		AbstractApplicationContext ctx = new ClassPathXmlApplicationContext("classpath:context.xml");
  		// RabbitMQ模板
  		RabbitTemplate template = ctx.getBean(RabbitTemplate.class); // 发送消息
  		template.convertAndSend("Hello, world!");
  		Thread.sleep(1000);// 休眠1秒
  		ctx.destroy(); // 容器销毁
  	}
  }
  ```

- 消费者

  ```java
  public class MyConsumer {
  
  	public void listen(String foo) {
  		System.out.println("消费者：" + foo);
  	}
  }
  ```
