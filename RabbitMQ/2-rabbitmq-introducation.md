## 第二章 RabbitMQ入门

### 1.什么叫消息队列？

- 消息（Message）是指在应用间传送的数据。消息可以非常简单，比如只包含文本字符串，也可以更复杂，可能包含嵌入对象 
- 消息队列（Message Queue）是一种应用间的通信方式，消息发送后可以立即返回，由消息系统来确保消息的可靠传递。消息发布者只管把消息发布到 MQ 中而不用管谁来取，消息使用者只管从 MQ 中取消息而不管是谁发布的。这样发布者和使用者都不用知道对方的存在 

### 2.为何用消息队列？

以常见的订单系统为例，用户点击【下单】按钮之后的业务逻辑可能包括：扣减库存、生成相应单据、发红包、发短信通知。在业务发展初期这些逻辑可能放在一起同步执行，随着业务的发展订单量增长，需要提升系统服务的性能，这时可以将一些不需要立即生效的操作拆分出来异步执行，比如发放红包、发短信通知等。这种场景下就可以用 MQ ，在下单的主流程（比如扣减库存、生成相应单据）完成之后发送一条消息到 MQ 让主流程快速完结，而由另外的单独线程拉取MQ的消息（或者由 MQ 推送消息），当发现 MQ 中有发红包或发短信之类的消息时，执行相应的业务逻辑

### 3.什么是RabbitMQ？

- 开发语言：Erlang 面向并发的编程语言
- RabbitMQ 最初起源于金融系统，用于在分布式系统中存储转发消息，在易用性、扩展性、高可用性等方面表现不俗。具体特点包括： 

1. 可靠性（Reliability）

   RabbitMQ 使用一些机制来保证可靠性，如持久化、传输确认、发布确认。

2. 灵活的路由（Flexible Routing）

   在消息进入队列之前，通过 Exchange 来路由消息的。对于典型的路由功能，RabbitMQ 已经提供了一些内置的 Exchange 来实现。针对更复杂的路由功能，可以将多个 Exchange 绑定在一起，也通过插件机制实现自己的 Exchange 。

3. 消息集群（Clustering）

   多个 RabbitMQ 服务器可以组成一个集群，形成一个逻辑 Broker 。

4. 高可用（Highly Available Queues）

    队列可以在集群中的机器上进行镜像，使得在部分节点出问题的情况下队列仍然可用。

5. 多种协议（Multi-protocol）

   RabbitMQ 支持多种消息队列协议，比如 STOMP、MQTT 等等。

6. 多语言客户端（Many Clients）

    RabbitMQ 几乎支持所有常用语言，比如 Java、.NET、Ruby 等等。

7. 管理界面（Management UI）

    RabbitMQ 提供了一个易用的用户界面，使得用户可以监控和管理消息 Broker 的许多方面。

8. 跟踪机制（Tracing）

   如果消息异常，RabbitMQ 提供了消息跟踪机制，使用者可以找出发生了什么。

9. 插件机制（Plugin System）

   RabbitMQ 提供了许多插件，来从多方面进行扩展，也可以编写自己的插件。

### 4.RabbitMQ 中的概念模型

#### 4.1消息模型

所有 MQ 产品从模型抽象上来说都是一样的过程： 消费者（consumer）订阅某个队列。生产者（producer）创建消息，然后发布到队列（queue）中，最后将消息发送到监听的消费者。 

![python-one](http://www.znsd.com/znsd/courses/uploads/d6311d434dc129456e6f29a021c62fa4/python-one.png)

P:消息的生产者

C:消息的消费者

红色：队列

#### 4.2RabbitMQ 基本概念

上面只是最简单抽象的描述，具体到 RabbitMQ 则有更详细的概念需要解释。上面介绍过 RabbitMQ 是 AMQP 协议的一个开源实现，所以其内部实际上也是 AMQP 中的基本概念： 

![5015984-367dd717d89ae5db](http://www.znsd.com/znsd/courses/uploads/5e0388d2524fff3f4d1f69983e723371/5015984-367dd717d89ae5db.png)

1. Message

   消息，消息是不具名的，它由消息头和消息体组成。消息体是不透明的，而消息头则由一系列的可选属性组成，这些属性包括routing-key（路由键）、priority（相对于其他消息的优先权）、delivery-mode（指出该消息可能需要持久性存储）等。

2. Publisher

   消息的生产者，也是一个向交换器发布消息的客户端应用程序。

3. Exchange

   交换器，用来接收生产者发送的消息并将这些消息路由给服务器中的队列。

4. Binding

   绑定，用于消息队列和交换器之间的关联。一个绑定就是基于路由键将交换器和消息队列连接起来的路由规则，所以可以将交换器理解成一个由绑定构成的路由表。

5. Queue

   消息队列，用来保存消息直到发送给消费者。它是消息的容器，也是消息的终点。一个消息可投入一个或多个队列。消息一直在队列里面，等待消费者连接到这个队列将其取走。

6. Connection

   网络连接，比如一个TCP连接。

7. Channel

   信道，多路复用连接中的一条独立的双向数据流通道。信道是建立在真实的TCP连接内地虚拟连接，AMQP 命令都是通过信道发出去的，不管是发布消息、订阅队列还是接收消息，这些动作都是通过信道完成。因为对于操作系统来说建立和销毁 TCP 都是非常昂贵的开销，所以引入了信道的概念，以复用一条 TCP 连接。

8. Consumer

   消息的消费者，表示一个从消息队列中取得消息的客户端应用程序。

9. Virtual Host

   虚拟主机，表示一批交换器、消息队列和相关对象。虚拟主机是共享相同的身份认证和加密环境的独立服务器域。每个 vhost 本质上就是一个 mini 版的 RabbitMQ 服务器，拥有自己的队列、交换器、绑定和权限机制。vhost 是 AMQP 概念的基础，必须在连接时指定，RabbitMQ 默认的 vhost 是 / 。

10. Broker

   表示消息队列服务器实体。

###  5.java操作队列

#### 5.1简单队列

- 创建maven项目导入rabbitmq依赖jar包

  ```xml
  <dependencies>
      <dependency>
          <groupId>com.rabbitmq</groupId>
          <artifactId>amqp-client</artifactId>
          <version>4.0.2</version>
      </dependency>
  
      <dependency>
          <groupId>org.slf4j</groupId>
          <artifactId>slf4j-api</artifactId>
          <version>1.7.10</version>
      </dependency>
  
      <dependency>
          <groupId>org.slf4j</groupId>
          <artifactId>slf4j-log4j12</artifactId>
          <version>1.7.5</version>
      </dependency>
  
      <dependency>
          <groupId>log4j</groupId>
          <artifactId>log4j</artifactId>
          <version>1.2.17</version>
      </dependency>
  
      <dependency>
          <groupId>junit</groupId>
          <artifactId>junit</artifactId>
          <version>4.11</version>
      </dependency>
  
      <dependency>
          <groupId>org.springframework.amqp</groupId>
          <artifactId>spring-rabbit</artifactId>
          <version>1.7.5.RELEASE</version>
      </dependency>
  
  </dependencies>
  
  <build>
      <plugins>
          <plugin>
              <groupId>org.apache.maven.plugins</groupId>
              <artifactId>maven-compiler-plugin</artifactId>
              <configuration>
                  <source>1.7</source>
                  <target>1.7</target>
              </configuration>
          </plugin>
      </plugins>
  </build>
  ```

- 创建获取MQ连接的工厂类

  ```java
  import java.io.IOException;
  import java.util.concurrent.TimeoutException;
  
  import com.rabbitmq.client.Connection;
  import com.rabbitmq.client.ConnectionFactory;
  
  public class ConnectionUtil {
  
  	/**
  	 * 获取RabbitMQ连接对象
  	 * @return
  	 */
  	public static Connection getConnection() {
  		
  		ConnectionFactory factory = new ConnectionFactory();
  		// 设置服务器地址
  		factory.setHost("192.168.41.11");
  		// 设置服务器用户名
  		factory.setUsername("user_mmr");
  		// 设置服务器密码
  		factory.setPassword("123");
  		// 设置服务器端口
  		factory.setPort(5672);
  		// 设置虚拟名称
  		factory.setVirtualHost("/vhost_mmr");
  		
  		try {
  			// 创建连接对象
  			return factory.newConnection();
  		} catch (IOException | TimeoutException e) {
  			e.printStackTrace();
  		}
  		return null;
  	}
  }
  ```

- 生产者发送数据到消息队列

  ```java
  public class Send {
  
  	public static final String TEST_SIMPLE_QUEUE = "test_simple_queue";
  
  	public static void main(String[] args) throws IOException, TimeoutException {
  		
  		// 获取一个连接对象
  		Connection connection = ConnectionUtil.getConnection();
  	
  		// 从连接对象中获取一个连接渠道
  		Channel channel = connection.createChannel();
  		
  		// 声明一个队列
  		channel.queueDeclare(TEST_SIMPLE_QUEUE, false, false, false, null);
  		
  		// 需要发送的消息
  		String msg = "hello world rabbitmq";
  		
  		// 第一个参数是exchangeName(默认情况下代理服务器端是存在一个""名字的exchange的,
  		// 因此如果不创建exchange的话我们可以直接将该参数设置成"",如果创建了exchange的话
  		// 我们需要将该参数设置成创建的exchange的名字),第二个参数是路由键
  		channel.basicPublish("", TEST_SIMPLE_QUEUE, null, msg.getBytes());
  		
  		// 关闭连接对象
  		channel.close();
  		connection.close();
  	}
  }
  ```

- 通过RabbitMQ后台可查看发送过的消息

  ![20180817215005](http://www.znsd.com/znsd/courses/uploads/b0444638020c5a93b598bf474e554023/20180817215005.png)

- 消费者消费

  ```java
  public class Reciver {
  	
  	public static final String TEST_SIMPLE_QUEUE = "test_simple_queue";
  
  	public static void main(String[] args) throws IOException, ShutdownSignalException, ConsumerCancelledException, InterruptedException {
  		
  		// 创建连接
  		Connection connection = ConnectionUtil.getConnection();
  		
  		// 创建频道
  		Channel channel = connection.createChannel();
  		
  		Consumer consumer = new DefaultConsumer(channel) {
  		      @Override
  		      public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties, byte[] body)
  		          throws IOException {
  		        String message = new String(body, "UTF-8");
  		        System.out.println(" [x] Received '" + message + "'");
  		      }
  		    };
  		    channel.basicConsume(TEST_SIMPLE_QUEUE, true, consumer);
  		
  		// oldReciverAPI(channel);
  	}
  
  	private static void oldReciverAPI(Channel channel) throws IOException, InterruptedException {
  		// 老版本API调用方式，不推荐使用
  		QueueingConsumer consumer = new QueueingConsumer(channel);
  		
  		channel.basicConsume(TEST_SIMPLE_QUEUE, true, consumer);
  		
  		while (true) {
  			
  			Delivery delivery = consumer.nextDelivery();
  			String msg = new String(delivery.getBody());
  			
  			System.out.println("msg : " + msg);
  		}
  	}
  }
  ```

#### 5.2简单 队列的不足

耦合性较高：生产者和消费者一一对应（如果想要实现一个生产者对应多个消费者，不满足），队列名修改的时候，需要生产者和消费者同时修改。 

### 6.Work Queues（工作队列）

#### 6.1 什么是工作队列？

工作队列是用来将耗时的任务分发给多个消费者（工作者），主要解决这样的问题：处理资源密集型任务，并且还要等他完成。有了工作队列，我们就可以将具体的工作放到后面去做，将工作封装为一个消息，发送到队列中，一个工作进程就可以取出消息并完成工作。如果启动了多个工作进程，那么工作就可以在多个进程间共享。

#### 6.2 队列模型

![image](http://www.znsd.com/znsd/courses/uploads/ac138c9a2340669973bc3552c993cac9/image.png) 

#### 6.3 为什么会出现工作队列

- 我们应用程序在是使用消息系统的时候,一般生产者 P 生产消息是毫不费力的(发送消息即可),而消费者接收完消息后的需要处理,而且消费者往往和业务相关，处理会耗费一定的时间,这时候,就有可能导致很多消息堆积在队列里面,一个消费者有可能不够用情况。

- 使用任务队列的优点之一就是可以轻易的并行工作。如果我们积压了好多工作，我们可以通过增加工作者（消费者）来解决这一问题，使得系统的伸缩性更加容易。

#### 6.4 简单工作队列

- 生产者

  ```java
  public class Send {
  
  	private static final String QUEUE_NAME = "test_work_queue";
  
  	public static void main(String[] args) throws IOException, InterruptedException, TimeoutException {
  		// 获取链接对象
  		Connection connection = ConnectionUtil.getConnection();
  		
  		// 获取渠道
  		Channel channel = connection.createChannel();
  		// 声明队列
  		channel.queueDeclare(QUEUE_NAME, false, false, false, null);
  		
  		for (int i = 0; i < 50; i++) {
  			String msg = "msg: " + i;
  			
  			System.out.println("send: msg " + msg);
  			// 发送消息
  			channel.basicPublish("", QUEUE_NAME, null, msg.getBytes());
  			Thread.sleep(i * 20);
  		}
  
  		// 关闭对象
  		channel.close();
  		connection.close();
  	}
  }
  ```

- 消费者1

  ```java
  public class Reciver1 {
  	
  	private static final String QUEUE_NAME = "test_work_queue";
  
  	public static void main(String[] args) throws IOException {
  		// 获取链接对象
  		Connection connection = ConnectionUtil.getConnection();
  		// 创建渠道
  		Channel channel = connection.createChannel();
  		
  		// 声明队列
  		channel.queueDeclare(QUEUE_NAME, false, false, false, null);
  		
  		Consumer consumer = new DefaultConsumer(channel) {
  			
  			// 一旦有消息会出发该方法
  			@Override
  			public void handleDelivery(String consumerTag, Envelope envelope, BasicProperties properties, byte[] body)
  					throws IOException {
  
  				String msg = new String(body, "UTF-8");
  				System.out.println("reciver1 msg :" + msg);
  				
  				try {
                      // 处理完成休眠两秒
  					Thread.sleep(2000);
  				} catch (InterruptedException e) {
  					e.printStackTrace();
  				}
  			}
  		};
  		
  		boolean autoAck = true;
  		channel.basicConsume(QUEUE_NAME, autoAck, consumer);
  		
  	}
  }
  
  ```

- 消费者2

  ```java
  public class Reciver2 {
  	
  	private static final String QUEUE_NAME = "test_work_queue";
  
  	public static void main(String[] args) throws IOException {
  		// 获取链接对象
  		Connection connection = ConnectionUtil.getConnection();
  		// 创建渠道
  		Channel channel = connection.createChannel();
  		
  		// 声明队列
  		channel.queueDeclare(QUEUE_NAME, false, false, false, null);
  		
  		Consumer consumer = new DefaultConsumer(channel) {
  			
  			// 一旦有消息会出发该方法
  			@Override
  			public void handleDelivery(String consumerTag, Envelope envelope, BasicProperties properties, byte[] body)
  					throws IOException {
  
  				String msg = new String(body, "UTF-8");
  				System.out.println("reciver2 msg :" + msg);
  				
  				try {
                      // 处理完消息休眠1秒
  					Thread.sleep(1000);
  				} catch (InterruptedException e) {
  					e.printStackTrace();
  				}
  			}
  		};
  		
  		boolean autoAck = true;
  		channel.basicConsume(QUEUE_NAME, autoAck, consumer);
  		
  	}
  }
  ```

- 测试结果：消费者1和消费者2处理的消息都是一样的，消费者1处理的消息都是奇数，消费者2都是偶数，这种方式叫做｀轮询｀（round-robin），结果是不管谁忙谁闲，都不会多发或者小发消息，永远都是你一个我一个的轮流来处理。

#### 6.5 Fair dispatch（公平分发）

#####  6.5.1 轮询分发的问题 

虽然上面的分配法方式也可以，但是有个问题就是：比如：

- 现在有 2 个消费者，所有的偶数的消息都是繁忙的，而奇数则是轻松的。按照轮询的方式，偶数的任务交给了第一个消费者，所以一直在忙个不停。奇数的任务交给另一个消费者，则立即完成任务，然后闲得不行。
- 为了解决这个问题，我们使用`basicQos( prefetchCount = 1)`方法，来限制RabbitMQ只发不超过 1 条的消息给同一个消费者。当消息处理完毕后，有了反馈ack，才会进行第二次发送。(也就是说需要手动反馈给Rabbitmq )还有一点需要注意，使用公平分发，必须关闭自动应答，改为手动应答。

![image](http://www.znsd.com/znsd/courses/uploads/ab0745936d44122334810320bc2b24e0/image.png)

##### 6.5.2 公平分发实例

- 生产者和消费着需要同时设置Qos

  ```java
  // 获取渠道
  Channel channel = connection.createChannel();
  // 声明队列
  channel.queueDeclare(QUEUE_NAME, false, false, false, null);
  
  // 每个消费者发送确认消息之前，消息队列不发送下一个消息给消费者，每次只处理一个消息，
  // 用来限制发送个同一个消费者不能超过1个消息
  int prefetchCount = 1;
  channel.basicQos(prefetchCount);
  ```

- 两个消费者需要`手动回执消息`，并且将`自动应答模式改为手动应答`

  ```java
  @Override
  public void handleDelivery(String consumerTag, Envelope envelope, BasicProperties properties, byte[] body)
      throws IOException {
  
      String msg = new String(body, "UTF-8");
      System.out.println("reciver1 msg :" + msg);
  
      try {
          Thread.sleep(2000);
      } catch (InterruptedException e) {
          e.printStackTrace();
      } finally {
          // 手动回执消息
          channel.basicAck(envelope.getDeliveryTag(), false);
      }
  }
  // 自动应答改成false
  boolean autoAck = false;
  channel.basicConsume(QUEUE_NAME, autoAck, consumer);
  ```

- 测试结果：消费者2要比消费着1处理的消息要多实现一个`能者多劳的效果`

#### 6.6 Message acknowledgment（消息应答）

- 执行一个任务可能需要花费几秒钟，如果一个消费者在执行任务过程中宕掉了，基于现在的代码，`一旦RabbitMQ将消息分发给了消费者，就会从内存中删除，`在这种情况下，如果杀死正在执行任务的消费者，会丢失正在处理的消息，也会丢失已经分发给这个消费者但尚未处理的消息。

- 为了确保消息不会丢失，RabbitMQ支持消息应答。消费者发送一个消息应答，告诉RabbitMQ这个消息已经接收并且处理完毕了。RabbitMQ可以删除它了。

- 消息应答是**默认打开**的。我们明确地把它们关掉了`（autoAck=true）`。现在将应答打开，一旦我们完成任务，消费者会自动发送消息应答。

  ```java
  // 自动应答改成false
  boolean autoAck = false;
  channel.basicConsume(QUEUE_NAME, autoAck, consumer);
  ```

  ```java
  channel.basicQos(1);//保证一次只分发一个
  ```

- 另外还需要在消费者中`设置手动回执消息`，在消息处理过程中，人为让一个消费者挂掉，然后会看到剩下的任务都会被另外的消费者执行。

  ```java
  // 手动回执消息
  channel.basicAck(envelope.getDeliveryTag(), false);
  ```

#### 6.7 Message durability（消息持久化）

- 我们已经了解了如何确保即使消费者死亡，任务也不会丢失。但是`如果RabbitMQ服务器停止`，我们的任务仍将会丢失。当RabbitMQ退出或者崩溃，将会丢失队列和消息。为了保证消息不被丢失，我们必须把“队列”和“消息”设为持久化。

  ```java
  // 设置消息持久化
  boolean durable = true;
  channel.queueDeclare("test_work_queue", durable, false, false, null);
  ```

- 如果直接将程序里面的false改成true程序会出现异常

  ```java
  channel error; protocol method: #method<channel.close>(reply-code=406, reply-text=PRECONDITION_FAILED - inequivalent arg 'durable' for queue 'test_queue_work'
  ```

- RabbitMQ不允许使用不同的参数设定重新定义已经存在的队列，并且会向尝试如此做的程序返回一个错误。一个快速的解决方案就是声明一个不同名字的队列，比如task_queue。

### 7.Publish/Subscribe（订阅模式 ）

#### 7.1 消息模型

我们之前学习的都是一个消息只能被一个消费者消费,那么如果我想发一个消息 能被多个消费者消费,这时候怎么

办? 这时候我们就得用到了消息中的发布订阅模型

![python-three-overall](http://www.znsd.com/znsd/courses/uploads/a0aac04b8403ed89ec61850bf6b571ea/python-three-overall.png)

#### 7.2 解读

1. 一个生产者，多个消费者
2. 每一个消费者都有自己的一个队列
3. 生产者没有将消息直接发送到队列，而是发送到了交换机(转发器)
4. 每个队列都要绑定到交换机
5. 生产者发送的消息，经过交换机，到达队列，实现，一个消息被多个消费者获取的目的

#### 7.3 java实例

- 生产者

  ```java
  public class Send {
  
  	private static final String EXCHANGE_NAME = "test_exchange_fanout";
  
  	public static void main(String[] args) throws IOException, TimeoutException {
  		Connection connection = ConnectionUtil.getConnection();
  		
  		Channel channel = connection.createChannel();
  		
  		// 声明交换机
  		channel.exchangeDeclare(EXCHANGE_NAME, "fanout"); //指定分发类型为fanout
  		
  		// 发送消息
  		String msg = "hello ps";
  		channel.basicPublish(EXCHANGE_NAME, "", null, msg.getBytes());
  		System.out.println("发送消息：" + msg);
  		
  		channel.close();
  		connection.close();
  	}
  }
  ```

- 生产者发送完消息可以在rabbitmq后台中查看到，但是消息丢失了!因为交换机没有存储消息的能力,在rabbitmq中只有队列存储消息的能力,所以就会丢失。

  ![WX20180911-105747_2x](http://www.znsd.com/znsd/courses/uploads/72206e2dcb05dd3ec48982534f5e5d7e/WX20180911-105747_2x.png)

- 消费者：创建两个消费者，在消费者代码中通过channel.queueBind方法绑定队列

  ```java
  private static final String SMS_QUEUE_NAME = "sms_queue_name";
  private static final String EXCHANGE_NAME = "test_exchange_fanout";
  ...
  // 声明队列
  channel.queueDeclare(SMS_QUEUE_NAME, false, false, false, null);
  // 绑定队列到交换机
  channel.queueBind(SMS_QUEUE_NAME, EXCHANGE_NAME, "");
  ...
  ```

- 测试结果，一个消息可以被多个消费者获取，并且可以在后台查看exchange绑定队列的个数和解绑功能

  ![WX20180911-111320_2x](http://www.znsd.com/znsd/courses/uploads/4862dd2c2cebe137ffebf9a938dce11b/WX20180911-111320_2x.png)

### 8.三种Exchange模式

Exchange模式共包含三种，有`订阅`、`路由`和`通配符`三种模式，之所以放在一起介绍，是因为这三种模式都是用了Exchange交换机，消息没有直接发送到队列，而是发送到了交换机，经过队列绑定交换机到达队列。

#### 8.1 订阅模式(Fanout Exchange)

- 一个生产者，多个消费者，每一个消费者都有自己的一个队列，生产者没有将消息直接发送到队列，而是发送到了交换机，每个队列绑定交换机，生产者发送的消息经过交换机，到达队列，实现一个消息被多个消费者获取的目的。
- 需要注意的是，如果将消息发送到一个没有队列绑定的exchange上面，那么该消息将会丢失，这是因为在rabbitMQ中exchange不具备存储消息的能力，只有队列具备存储消息的能力。

![image](http://www.znsd.com/znsd/courses/uploads/0574625c10e4713bc7a835c8e99072c3/image.png)

- 消息模型图

![python-three-overall](http://www.znsd.com/znsd/courses/uploads/a0aac04b8403ed89ec61850bf6b571ea/python-three-overall.png)

#### 8.2 路由模式(Direct Exchange)

- 这种模式添加了一个路由键，生产者发布消息的时候添加路由键，消费者绑定队列到交换机时添加键值，这样就可以接收到需要接收的消息。

![image](http://www.znsd.com/znsd/courses/uploads/670a5929272701437c23f6ddfed0cb70/image.png)

- 路由模式模型图

![image](http://www.znsd.com/znsd/courses/uploads/c6d810f741e34a747a7d1d667c010f84/image.png)

- 生产者

  ```java
  public class Send {
  
  	private static final String EXCHANGE_NAME = "test_exchange_direct";
  
  	public static void main(String[] args) throws IOException, TimeoutException {
  		Connection connection = ConnectionUtil.getConnection();
  		
  		Channel channel = connection.createChannel();
  		
  		// 声明交换机
  		channel.exchangeDeclare(EXCHANGE_NAME, "direct"); //指定分发类型为direct
  		
  		// 发送消息
  		String msg = "hello direct";
  		// 指定路由key
  		String routingKey = "error";
  		
  		channel.basicPublish(EXCHANGE_NAME, routingKey, null, msg.getBytes());
  		System.out.println("发送消息：" + msg);
  		
  		channel.close();
  		connection.close();
  	}
  }
  ```

- 消费者1

  ```java
  public class Reciver1 {
  	
  	private static final String SMS_QUEUE_NAME = "sms_queue_name";
  	
  	private static final String EXCHANGE_NAME = "test_exchange_direct";
  
  	public static void main(String[] args) throws IOException {
  		Connection connection = ConnectionUtil.getConnection();
  		
  		Channel channel = connection.createChannel();
  		
  		// 声明队列
  		channel.queueDeclare(SMS_QUEUE_NAME, false, false, false, null);
  		
  		channel.basicQos(1);
  		
  		// 指定路由key
  		String routingKey = "error";
  		// 绑定队列到交换机
  		channel.queueBind(SMS_QUEUE_NAME, EXCHANGE_NAME, routingKey);
          //...
      }
  ```

- 消费者2同时绑定多个routingKey

  ```java
  public class Reciver2 {
  	
  	private static final String SMS_QUEUE_NAME = "email_queue_name";
  	
  	private static final String EXCHANGE_NAME = "test_exchange_direct";
  
  	public static void main(String[] args) throws IOException {
  		Connection connection = ConnectionUtil.getConnection();
  		
  		Channel channel = connection.createChannel();
  		
  		channel.basicQos(1);
  		
  		// 声明队列
  		channel.queueDeclare(SMS_QUEUE_NAME, false, false, false, null);
  		
  		// 绑定队列到交换机
  		channel.queueBind(SMS_QUEUE_NAME, EXCHANGE_NAME, "info");// 绑定路由key
  		channel.queueBind(SMS_QUEUE_NAME, EXCHANGE_NAME, "error");// 绑定路由key
  		channel.queueBind(SMS_QUEUE_NAME, EXCHANGE_NAME, "warning");// 绑定路由key
          // ...
      }
  }
  ```

- 测试：**先运行两个消费者，在运行生产者。如果没有提前将队列绑定到交换机，那么直接运行生产者的话，消息是不会发到任何队列里的**

- 两个队列消费者设置的路由不一样，接收到的消息就不一样。路由模式下，决定消息向队列推送的主要取决于路由，而不是交换机了。

- 该模式必须设置交换机，且声明路由模式：

  ```java
  channel.exchangeDeclare(EXCHANGE_NAME, "direct");
  ```

#### 8.3 通配符模式（Topic Exchange）

- 基本思想和路由模式是一样的，只不过路由键支持模糊匹配，符号`“#”`匹配一个或多个词，符号`“*”`匹配不多不少一个词

  ![image](http://www.znsd.com/znsd/courses/uploads/5826e96f198b51ef9c0dcf9305e06cf2/image.png)

- 队列模型图

  ![image](http://www.znsd.com/znsd/courses/uploads/5d99034b8fdc4a17224f4b3cd8c66f9c/image.png)

- 生产者

  ```java
  public class Send {
  
  	private static final String EXCHANGE_NAME = "test_exchange_topic";
  
  	public static void main(String[] args) throws IOException, TimeoutException {
  		Connection connection = ConnectionUtil.getConnection();
  		
  		Channel channel = connection.createChannel();
  		
  		// 声明交换机
  		channel.exchangeDeclare(EXCHANGE_NAME, "topic"); //指定分发类型为topic
  		
  		// 发送消息
  		String msg = "商品操作";
  		// topic指定路由key
  		channel.basicPublish(EXCHANGE_NAME, "goods.update", null, msg.getBytes());
  		System.out.println("发送消息：" + msg);
  		
  		channel.close();
  		connection.close();
  	}
  }
  ```

- 消费者1

  ```java
  public class Reciver1 {
  	
  	private static final String SMS_QUEUE_NAME = "queue_name_topic_1";
  	
  	private static final String EXCHANGE_NAME = "test_exchange_topic";
  
  	public static void main(String[] args) throws IOException {
  		Connection connection = ConnectionUtil.getConnection();
  		
  		Channel channel = connection.createChannel();
  		
  		// 声明队列
  		channel.queueDeclare(SMS_QUEUE_NAME, false, false, false, null);
  		
  		channel.basicQos(1);
  		
  		// 绑定队列到交换机
  		channel.queueBind(SMS_QUEUE_NAME, EXCHANGE_NAME, "goods.update");
          // ...
      }
  }
  ```

- 消费者2

  ```java
  public class Reciver2 {
  	
  	private static final String SMS_QUEUE_NAME = "queue_name_topic_2";
  	
  	private static final String EXCHANGE_NAME = "test_exchange_topic";
  
  	public static void main(String[] args) throws IOException {
  		Connection connection = ConnectionUtil.getConnection();
  		
  		Channel channel = connection.createChannel();
  		
  		channel.basicQos(1);
  		
  		// 声明队列
  		channel.queueDeclare(SMS_QUEUE_NAME, false, false, false, null);
  		
  		// 绑定路由key
  		// 绑定队列到交换机
  		channel.queueBind(SMS_QUEUE_NAME, EXCHANGE_NAME, "goods.#");// topic模式
          // ...
      }
  }
  ```

- 测试结果;  消费者1是按需索取，并没有使用通配符模式，而是用的完全匹配，消费者2使用通配符模式，这样以goods.开头的消息都会全部接收。