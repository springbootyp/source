## 第二章  IoC依赖注入

### 本章目标

- 理解什么是IoC和DI。`重点`
- 理解构造注入
- 理解不同数据类型的注入方法
- 掌握p命名空间注入
- Bean自动装配

### 什么是IOC和DI

- IoC（Inversion of Control）称为控制反转，对于spring框架来说，就是由spring来负责控制对象的生命周期和对象间的关系。
- 控制反转还有一个名字叫做DI（Dependency Injection），中文意思叫依赖注入。

### 为什么使用依赖注入（DI）

1.  **动态替换Bean依赖对象，程序更灵活**：替换Bean依赖对象，无需修改源文件：应用依赖注入后，由于可以采用配置文件方式实现，从而能随时动态的替换Bean的依赖对象，无需修改java源文件；
2.  **更好实践面向接口编程，代码更清晰**：在Bean中只需指定依赖对象的接口，接口定义依赖对象完成的功能，通过容器注入依赖实现；
3.  **更好实践优先使用对象组合，而不是类继承**：因为IoC容器采用注入依赖，也就是组合对象，从而更好的实践对象组合。
4.  **增加Bean可复用性**：依赖于对象组合，Bean更可复用且复用更简单；
5.  **降低Bean之间耦合**：由于我们完全采用面向接口编程，在代码中没有直接引用Bean依赖实现，全部引用接口，而且不会出现显示的创建依赖对象代码，而且这些依赖是由容器来注入，很容易替换依赖实现类，从而降低Bean与依赖之间耦合；
6.  **代码结构更清晰**：要应用依赖注入，代码结构要按照规约方式进行书写，从而更好的应用一些最佳实践，因此代码结构更清晰。

### IoC的执行原理

- IoC的一个重点是在系统运行中，动态的向某个对象提供它所需要的其他对象。这一点是通过DI（Dependency Injection，依赖注入）来实现的。
- 比如对象A需要操作数据库，以前我们总是要在A中自己编写代码来获得一个Connection对象，有了 spring我们就只需要告诉spring，A中需要一个Connection，至于这个Connection怎么构造，何时构造，A不需要知道。在系统运行时，spring会在适当的时候制造一个Connection，然后像打针一样，注射到A当中，这样就完成了对各个对象之间关系的控制。这就是依赖注入。
- Spring中的依赖注入主要通过反射来实现的，通过反射读取xml文件中配置的实体对象的类名。然后反射出需要的对象。

### 依赖注入的方式

Spring中依赖注入主要分为三种方式

- 设值注入（set注入）：通过setter方法对属性进行注入
- 构造注入：通过构造方法对属性进行注入
- p:属性注入：通过p:属性对属性进行注入

### 设值（set）注入

通过property元素调用setter方法。

- name：属性名称
- type：属性类型

type类型：

- 基本类型及其包装类、String、Date等类型，直接使用value属性，或者value元素传入值。
- 引用类型：用ref属性、嵌套bean传入值。
- List、Set、Map等集合以及数组使用对应的标签进行注入。

### 基本类型注入

创建学生对象，初始化学生属性。

- Student

  - name
  - age
  - sex

  ```java
  public class Student {

  	private String name;
  	private int age;
  	private String sex;
    	// set注入必须要有set、get方法
  }
  ```

  ```xml
  <bean id="student" class="com.znsd.spring.ioc.Student">
  	<property name="name" value="张三"></property>
  	<property name="age" value="20"></property>
  	<property name="sex" value="男"></property>
  </bean>
  ```

  ```java
  @Test
  public void test1() {
  	ApplicationContext act = new ClassPathXmlApplicationContext("applicationContext.xml");
  	Student student = (Student) act.getBean("student");
  	System.out.println(student);
  }
  ```

### 复合类型注入

复合类型注入用ref属性、嵌套bean传入值。

```xml
<bean id="studentDao" class="com.znsd.spring.ioc.dao.StudentDao"></bean>
<bean id="studentService" class="com.znsd.spring.ioc.service.StudentServiceImpl">
	<property name="studentDao" ref="studentDao"></property>
</bean>
```

```java
@Test
public void test2() {
	ApplicationContext act = new ClassPathXmlApplicationContext("applicationContext.xml");
	StudentServiceImpl studentServiceImpl = (StudentServiceImpl) act.getBean("studentService");
	System.out.println(studentServiceImpl.getStudentDao());
}
```

### 嵌套Bean方式

- 嵌套Bean不是直接定义在\<beans />，而是定义在\<property../>或者\<constructor-arg.../>中。

- 嵌套Bean和外层Bean配置方式基本完全一致。

- 嵌套Bean不需要id属性。

  ```xml
  <bean id="studentService" class="com.znsd.spring.ioc.service.StudentServiceImpl">
  	<!-- 使用内部Bean创建属性对象 -->
  	<property name="studentDao">
  		<bean class="com.znsd.spring.ioc.dao.StudentDao"/>
  	</property>
  </bean>
  ```

### 复合类型注入

- 如何开发一个打印机？

- 打印机功能的实现依赖于墨盒和纸张

- 步骤：
  1. 定义墨盒和纸张的接口标准

  2. 使用接口标准开发打印机

  3. 组装打印机

  4. 运行打印机

     ![image](http://www.znsd.com/znsd/courses/uploads/e8e68981209197e6415a759feb2b9175/image.png)

- 我们知道，在实际生活中，打印机一般有黑色墨盒和彩色墨盒两种，还可以根据放入纸张的大小判断打印的每行字符数量，每页多少行，打多少页等。

- 定义墨盒接口

  ```java
  /**
   * 墨盒接口
   */
  public interface Ink {

  	/**
  	 * 定义打印采用的颜色的方法。 
  	 * @return 返回打印采用的颜色
  	 */
  	String getColor();

  }
  ```

- 彩色墨盒实现类

  ```java
  /**
   * 彩色墨盒接口实现类
   */
  public class ColorInk implements Ink {

  	/**
  	 * 打印采用彩色
  	 */
  	@Override
  	public String getColor() {
  		return "彩色墨盒";
  	}
  }
  ```

- 灰色墨盒实现类

  ```java
  /**
   * 灰色墨盒
   */
  public class GreyInk implements Ink {

  	/**
  	 * 打印采用灰色
  	 */
  	@Override
  	public String getColor() {
  		return "灰色墨盒";
  	}
  }
  ```

- 定义纸张接口

  ```java
  /**
   * 纸张接口
   */
  public interface Paper {

  	public String getName();
  }
  ```

- A4纸实现类

  ```java
  /**
   * A4纸张实现类
   */
  public class A4Paper implements Paper {

  	@Override
  	public String getName() {
  		return "一张A4纸";
  	}
  }
  ```

- B5纸实现类

  ```java
  /**
   * B5纸
   */
  public class B5Paper implements Paper {

  	@Override
  	public String getName() {
  		return "一张B5纸";
  	}
  }
  ```

- 打印机

  ```java
  /**
   * 打印机
   */
  public class Printer {

  	private Ink ink; // 墨盒
  	private Paper paper; // 纸张

  	public Ink getInk() {
  		return ink;
  	}

  	public void setInk(Ink ink) {
  		this.ink = ink;
  	}

  	public Paper getPaper() {
  		return paper;
  	}

  	public void setPaper(Paper paper) {
  		this.paper = paper;
  	}

  	public void print() {
  		System.out.println("使用" + ink.getColor() + "颜色在" + paper.getName() + "内容打印:\n" + content);
  	}
  }
  ```

- spring xml 配置文件

  ```xml
  <beans>
  	<!-- 彩色墨盒 -->
  	<bean id="colorInk" class="com.znsd.spring.ioc.ColorInk"></bean>
  	<!-- 灰色墨盒 -->
  	<bean id="greyInk" class="com.znsd.spring.ioc.GreyInk"></bean>
  	<!-- A4纸 -->
  	<bean id="a4Paper" class="com.znsd.spring.ioc.A4Paper"></bean>
  	<bean id="b5Paper" class="com.znsd.spring.ioc.B5Paper"></bean>
  	<!-- 打印机 -->
  	<bean id="printer" class="com.znsd.spring.ioc.Printer">
  		<property name="ink" ref="colorInk"></property>
  		<property name="paper" ref="a4Paper"></property>
  	</bean>
  </beans>
  ```

- 打印机测试类

  ```java
  @Test
  public void testPrint() {
  	ApplicationContext act = new ClassPathXmlApplicationContext("applicationContext.xml");
  	Printer printer = (Printer) act.getBean("printer");
  	printer.print("几位轻量级容器的作者曾骄傲地对我...");
  }
  ```

`通过Spring的配置，可以像更换打印机的墨盒和打印纸一样地更换程序组件。这就是依赖注入带来的魔力！！`

### 学员操作——实现打印机功能

需求说明：

- 自己动手实现打印机功能
- 使用SpringIoC实现墨盒和纸张的灵活替换

`重点是让学员练习Spring IoC，千万不要把时间浪费在打印机的业务实现上，偏离主题`

### 学员练习--嵌套Bean实现打印机功能

- 通过嵌套Bean方式实现打印机功能。

### 集合注入

使用Spring注入集合属性

- \<list>：注入List集合和数组。
- \<set>：注入Set集合。
- \<props>：注入property集合，以字符串为key和value的集合。
- \<map>：注入Map集合，key和value可以为任意类型。

#### List集合

List集合注入配置

- 普通属性

  ```xml
  <property name="addressList">
       <list>
           <value>湖南</value>
           <value>湖北</value>
           <value>江西</value>
           <value>广东</value>
       </list>
  </property>
  ```

- 复合属性

  ```xml
  <property name="addressList">
        <list>
             <ref bean="address1"/>
             <ref bean="address2"/>
             <value>广东</value>
        </list>
  </property>
  ```

#### Set集合

Set集合配置

- 普通属性

  ```xml
  <property name="addressList">
      <set>
          <value>湖南</value>
          <value>湖北</value>
          <value>江西</value>
          <value>广东</value>
      </set>
  </property>
  ```

- 复合属性

  ```xml
  <property name="addressList">
        <set>
             <ref bean="address1"/>
             <ref bean="address2"/>
             <value>广东</value>
        </set>
  </property>
  ```

#### Property集合

Property集合配置

- 普通属性

  ```xml
  <property name="addressProp">
      <props>
           <prop key="one">湖南</prop>
           <prop key="two">湖北</prop>
           <prop key="three">广东</prop>          
      </props>
  </property>
  ```

  ​

#### Map集合

Map集合配置

- 普通属性

  ```xml
  <property name="addressMap">
  	<map>
          <entry key="1" value="湖南"/>
          <entry key="2" value="湖北"/>
          <entry key="3" value="广东"/>
      </map>
  </property>
  ```

- 复合属性

  ```xml
  <property name="addressMap">
      <map>
  		<entry key="one" value="湖南"/>
          <entry key ="two" value-ref="address1"/>
          <entry key ="three" value-ref="address2"/>
      </map>
  </property>
  ```

#### 注入null值和空字符串

- 注入null值

  ```xml
  <bean id="student" class="com.znsd.spring.test.Student">
  	<property name="name"><null/></property>
  </bean>
  ```

- 注入空字符串

  ```xml
  <bean id="student" class="com.znsd.spring.test.Student">
  	<property name="name" value=""></property>
  </bean>
  ```

  ​

### 练习—为班级注入学生集合

为班级对象注入学生集合，使用list、set、property、map方式进行注入

### 构造注入

#### 创建带参构造函数

- Spring提供了多种依赖注入的手段，除了通过属性的setter访问器，还可以通过带参构造方法实现依赖注入

- 创建带参构造函数

- `注意：`编写带参构造方法后，Java虚拟机不再提供默认的无参构造方法，为了保证使用的灵活性，建议自行添加一个无参构造方法

  ```java
  public class UserServiceImpl implements UserService {

  	private UserDao userDao;

  	/**
  	 * 无参构造方法
  	 */
  	public UserServiceImpl() {
  		
  	}
  	
  	/**
  	 * 用于为dao 属性赋值的构造方法 
  	 * @param userDao
  	 */
  	public UserServiceImpl(UserDao userDao) {
  		this.userDao = userDao;
  	}
  	
  	// 省略其他业务方法
  }
  ```

#### 配置\<constructor-arg>

`注意`

1. 一个\<constructor-arg>元素表示构造方法的一个参数，且使用时不区分顺序。

2. 通过\<constructor-arg>元素的index 属性可以指定该参数的位置索引，位置从0 开始。

3. \<constructor-arg>元素还提供了type 属性用来指定参数的类型，避免字符串和基本数据类型的混淆。

   ```xml
   <!-- 定义UserDao对象，并指定id为userDao -->
   <bean id="userDao" class="com.znsd.spring.dao.impl.UserDaoImpl"></bean>
   <!-- 定义UserService对象，并指定id为userService -->
   <bean id="userService" class="com.znsd.spring.service.impl.UserServiceImpl">
   	<!-- 通过定义的单参构造方法为userService的dao属性赋值 -->
   	<constructor-arg>
   		<!-- 引用id为userDao的对象为构造方法传参 -->
   		<ref bean="userDao"/>
   	</constructor-arg>
   </bean>
   ```

#### 对比设值注入和构造注入

- 设置注入

  ```xml
  <bean id="people" class="com.znsd.spring.People">
  	<property name="name" value="张三"/> <!-- 设值注入 -->
  	<property name="school" ref="school"/> <!-- 设值注入 -->
  	<property name="age" value="20"/>
  </bean>
  <bean id="school" class="com.znsd.spring.School" />
  ```

- 构造注入

  ```xml
  <bean id="people1" class="com.znsd.spring.People">
  	<!-- 构造注入，index=0表示构造器的第一个参数 -->
  	<constructor-arg index="0" value="张三" />
  	<constructor-arg index="1" ref="school1" /> <!-- 构造注入 -->
  	<constructor-arg index="2" value="20"/>
  </bean>
  <bean id="school1" class="com.znsd.spring.School" />
  ```

在开发过程中，这两种注入方式都是非常常用的。Spring也同时支持两种依赖注入方式：设值注入和构造注入。 **这两种依赖注入的方式，并没有绝对的好坏，只是适应的场景有所不同。**相比之下，设值注入有如下优点：

- 设值注入需要该Bean包含这些属性的setter方法
- 与传统的JavaBean的写法更相似，程序开发人员更容易理解、接收。通过setter方法设定依赖关系显得更加只管。
- 对于复杂的依赖关系，如果采用构造注入，会导致构造器国语臃肿，难以阅读。Spring在创建Bean实例时，需要同时实例化器依赖的全部实例，因而导致性能下降。而使用设值注入，则能避免这些问题
- 尤其是在某些属性可选的情况况下，多参数的构造器显得更加笨重

构造注入也不是绝对不如设值注入，在某些特定的场景下，构造注入比设值注入更加优秀。构造注入有以下优势：

- 构造注入需要该Bean包含带有这些属性的构造器
- 构造注入可以在构造器中决定依赖关系的注入顺序，优先依赖的优先注入。例如，组件中其他依赖关系的注入，常常要依赖于DataSrouce的注入。采用构造注入，可以在代码中清晰的决定注入顺序。
- 对于依赖关系无需变化的Bean，构造注入更有用处。因为没有Setter方法，所有的依赖关系全部在构造器内设定。因此，无需担心后续的代码对依赖关系产生破坏。
- 依赖关系只能在构造器中设定，则只有组件的创建者才能改变组件的依赖关系。对组件的调用者而言，组件内部的依赖关系完全透明，更符合高内聚的原则。

**`建议：采用以设值注入为主，构造注入为辅的注入策略。对于依赖关系无需变化的注入，尽量采用构造注入；而其他的依赖关系的注入，则考虑采用设值注入。`**

![image](http://www.znsd.com/znsd/courses/uploads/a4f9e233fad0c99974a2a95b77235c60/image.png)

#### 学员操作——使用构造注入

使用构造注入实现学生注入所在班级、学校信息

### 使用p命名空间注入属性值

- `语法：` p 命名空间的特点是使用属性而不是子元素的形式配置Bean的属性，从而简化了配置代码

- 对于直接量（基本数据类型、字符串）属性：p:属性名="属性值"对于引用Bean的属性：p:属性名-ref="Bean的id"

- 加入p配置约束

  ```xml
  xmlns:p="http://www.springframework.org/schema/p"
  ```

- 使用

  ```xml
  <!-- 普通属性 -->
  <bean id="user" class="com.znsd.spring.User" p:username="张三" p:age="20" p:email="zhangsan@qq.com"></bean>
  <!-- 复合属性 -->
  <bean id="userService" class="com.znsd.spring.service.impl.UserServiceImpl" p:userDao-ref="userDao" />
  ```

#### 学员操作——使用p命名空间注入直接量

使用构造注入实现学生注入所在班级、学校信息

`提示：` 注入直接量的语法：p:属性名="属性值"，需要加上set方法

#### 学员操作——使用p命名空间注入Bean

需求说明：

- 编写用户DAO接口，声明添加用户的方法，并编写其实现类，不必实现具体数据库操作
- 编写用户业务接口UserService，实现用户添加操作
- 编写UserService接口的实现类，添加UserDao引用及相关的setter方法
- 使用p命名空间为业务Bean注入DAO对象

`提示：` 注入Bean类型的语法：p:属性名-ref="Bean的id"

### 小结

**注入直接量**

- 使用\<value>标签实现
- 注意特殊字符的处理

**引用Bean**

- 使用\<ref>标签实现
- 注意bean属性和local 属性的区别

**使用内部Bean**

```xml
<property name="dao">
      <bean  class="dao.impl.UserDao" />
</property>
```

**注入集合类型的属性**

- 分别使用\<list>、\<set>、\<map>、\<props>标签实现

**注入null和空字符串值**

- 使用\<null/>注入null值
- 使用\<value>\</value>注入空字符串值

### Bean自动装配

- Spring可以在不使用ref下进行自动装配，可以大量减少引用的代码，可以使用元素的autowire属性进行自动装配，Spring默认情况下是关闭自动装配的。

| 属性值         | 描述                                       |
| ----------- | ---------------------------------------- |
| no          | 这是默认的设置，它意味着没有自动装配，你应该使用显式的bean引用来连线。你不用为了连线做特殊的事。在依赖注入章节你已经看到这个了。 |
| byName      | 由属性名自动装配。Spring  容器看到在 XML 配置文件中 bean 的自动装配的属性设置为 byName。然后尝试匹配，并且将它的属性与在配置文件中被定义为相同名称的  beans 的属性进行连接。 |
| byType      | 由属性数据类型自动装配。Spring  容器看到在 XML 配置文件中 bean 的自动装配的属性设置为 byType。然后如果它的类型匹配配置文件中的一个确切的  bean 名称，它将尝试匹配和连接属性的类型。如果存在不止一个这样的  bean，则一个致命的异常将会被抛出。 |
| constructor | 类似于 byType，但该类型适用于构造函数参数类型。如果在容器中没有一个构造函数参数类型的 bean，则一个致命错误将会发生。 |
| autodetect  | Spring首先尝试通过 constructor 使用自动装配来连接，如果它不执行，Spring  尝试通过 byType 来自动装配。 |

#### byName

- byName规则是指通过名字注入依赖关系。

- 假如BeanA的实现包含setB()方法，而Spring的配置刚好包含id为b的Bean，则Spring容器会将b实例注入到BeanA中，如果容器中没有名字匹配的Bean，Spring则不会做任何事情。

  ```xml
  <bean id="userDao" class="com.znsd.spring.dao.impl.UserDaoImpl"></bean>
  <!--byName根据名字自动装配userDao-->
  <bean id="userService" class="com.znsd.spring.service.impl.UserServiceImpl" autowire="byName"/>
  ```

#### byType

- byType规则，根据类型匹配来注入依赖关系。

- 假如A实例有setB()方法，而Spring配置文件中恰有一个类型B的Bean实例，容器为A注入类型匹配的Bean实例，如果容器中没有一个类型为B的实例，则什么都不会发生；但如果容器中有多个B的实例，则抛出异常。

  ```xml
  <bean id="userDao" class="com.znsd.spring.dao.impl.UserDaoImpl"></bean>
  <!--byName根据名字自动装配userDao-->
  <bean id="userService" class="com.znsd.spring.service.impl.UserServiceImpl" autowire="byType"/>
  ```

#### constructor

- constructor：这种规则和byType很相似，但它应用于构造参数。

- Spring 容器看作beans，在 XML配置文件中 beans 的 autowire 属性设置为 constructor。然后，它尝试把它的构造函数的参数与配置文件中 beans 名称中的一个进行匹配和连线。如果找到匹配项，它会注入这些bean，否则，它会抛出异常。

- 例如，在配置文件中，如果一个beanA 定义设置为通过构造函数自动装配，而且它有一个带有 beanB类型的参数之一的构造函数，那么 Spring 就会查找定义名为 beanA 的 bean，并用它来设置构造函数的参数。你仍然可以使用\<constructor-arg> 标签连接其余属性。下面的例子将说明这个概念。

  ```xml
  <bean id="userDao" class="com.znsd.spring.dao.impl.UserDaoImpl"></bean>
  <!--constructor需要写构造方法来自动装配userDao-->
  <bean id="userService" class="com.znsd.spring.service.impl.UserServiceImpl" autowire="constructor"/>
  ```

### 总结

- 设值注入
- 构造注入
- 使用p命名空间注入
- 注入不同的数据类型
- 自动装配