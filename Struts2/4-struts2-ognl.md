

## 第四章  OGNL与Struts标签库

### 本章目标

- 掌握OGNL表达式`重点`
- 掌握Struts2标签库`重点（难点）`

### OGNL简介

什么是OGNL（ Object Graph Navigation Language 对象图导航语言）

- 它是一个开源项目，取代页面中Java脚本，用来获取和设置Java对象的属性以及调用对象的方法。简化数据访问。
- 和EL作用一样，但功能更为强大 。

在Struts2中集成了OGNL表达式语言，在前台页面上可以非常方便的来获取Action中的属性数据，并且不需要考虑类型转换问题

### OGNL的优势

- 支持对象方法调用。
- 支持类静态的方法调用和值访问。
- 支持赋值操作和表达式串联。
- 访问ActionContext上下文对象。
- 操作集合对象。

### OGNL的结构

- 访问ActionContext对象 

  ![20180103151346](http://www.znsd.com/znsd/courses/uploads/f7d2121a5144bd5accb974ba83fec0c0/20180103151346.png)

值栈中内容可以直接访问，访问非值栈对象需添加#前缀，如果访问ValueStack中的元素，可以不加#。

### Struts2下使用OGNL

#### OGNL的基本用法

- 访问OGNL上下文，"#"相当于ActionContext.getContext()；
  - \#session.username：访问session中的username。
  - \#application.count：访问application中的count。
  - username：直接获取值栈中的数据。
- 过滤集合数据
  - \#list.{? #this > 30}，获取list集合中大于30的所有数据。
- 构造集合
  - List集合：#{'foo1'，'foo2'，'foo3'}
  - Map集合：#{'foo1':'bar1', 'foo2':'bar2'}

#### Struts2下使用OGNL

访问非值栈对象（\#的使用）

| 非值栈对象       | 访问方式                                     | 等价访问方式                                   |
| ----------- | ---------------------------------------- | ---------------------------------------- |
| application | #application.username  #application['username'] | application.getAttribute("username")     |
| session     | #session.username  #session['username']  | session.getAttribute("userName")         |
| request     | #request.username  #request['username']  | request.getAttribute("username")         |
| parameters  | #parameters.username  #parameters['username'] | request.getParameter("username")         |
| attr        | #attr.username  #attr['username']        | 按pageContext–>request–>session–>application顺序查找 |

#### Struts2下使用OGNL

访问非值栈对象

```html
<%-- 标签将一个值赋给指定范围的变量  (如果是字符串需要加单引号)--%>
<s:set name="username" value="'test'" scope="request"></s:set>
<s:set name="age" value="20" scope="session"></s:set>
<s:set name="count" value="10" scope="application"></s:set>

<%-- <s:property>标签用于输出指定对象的属性值 --%>
#request.username:<s:property value="#request.username"/><br/>
#session.age:<s:property value="#session.age"/><br/>
#application.count:<s:property value="#application.count"/><br/>
#attr.count:<s:property value="#attr.count"/><br/>

<s:set name="like1" value="'sss'"></s:set>
<s:set name="like2" value="'ccc'"></s:set>

#like1:<s:property value="like1"/><br/>
#like2:<s:property value="like2"/><br/>
#request.like2:<s:property value="#request.like2"/><br/>
```

### 常用的OGNL访问操作-list

- 定义List列表

  ```html
  <!-- list -->
  <s:set name="testList" value="{'saa','b','c','d'}"></s:set>
  ```

- 访问List列表

  ```html
  <s:property value="#testList[0]"/>
  <s:property value="#testList.size"/>
  ```

### 常用的OGNL访问操作

OGNL可以对集合元素进行过滤

- `?`：获取符合条件的集合。
- `^`：获取符合条件的第一条数据。
- `$`：获取符合条件的最后一条数据。

```html
<s:set name="list" value="{20,30,40,50}"></s:set>
<!-- 获取list集合中大于30的数据: -->
<s:property value="#list.{? #this > 30}"/><br/>
<!-- 获取list集合中大于30的第一条: -->
<s:property value="#list.{^ #this > 30}"/><br/>
<!-- 获取list集合中大于30的最后一条: -->
<s:property value="#list.{$ #this > 30}"/><br/>
```

### 常用的OGNL访问操作-Map

- 语法

  ```java
   #{key1:value1,key2:value2,key3:values3,..., keyN:valueN }
  ```

- 示例

  ```html
  <s:set name="foods" value="#{'key1':'food1','key2':'food2'}"></s:set>
  ```

- 访问Map

  ```html
  <s:property value="#foods['key1']"/>
  ```

### 常用的OGNL访问操作

- 支持访问静态成员：

  - @完整类名@静态feild（修饰符必须要为public）
  - @完整类名@静态方法(参数)

- 要想再OGNL中访问常量必须将配置中打开。

  ```properties
  struts.ognl.allowStaticMethodAccess=true
  ```

- 例子

  ```html
  <!-- 访问常量 -->
  <s:property value="@com.znsd.struts.action.OgnlAction@SSS"/><br/>
  <!-- 访问Math类中的随机数静态方法 -->
  <s:property value="@java.lang.Math@random()"/>
  ```

### Value Stack

- Struts2在xwork基础上增加了ValueStack的概念，Action的实例会被存放到值栈中。
- 值栈(ValueStack)由Struts2框架创建的存储区域，具有栈的特点
- OGNL可以直接访问值栈
  - 按照从上到下的顺序
  - 靠近栈顶的同名属性
  - 会被读取
- Stack Context：是Struts2的上下文对象。而ValueStack只是StackContext的一个根属性而已。访问StackContext成员需要添加#。
- ValueStack：值栈，Struts2新增的数据存储空间，用来存储Action相关的属性。访问ValueStack可以省略#。

![image](http://www.znsd.com/znsd/courses/uploads/3ee956a6b389c9fa400810ebcf9f96cb/image.png)

### 常用的OGNL访问操作

- 访问JavaBean

  ```java
  public class Address implements Serializable {

  	private String province; // 省
  	private String city; // 城市
  	private String region;// 区
    	// 忽略set、get方法
  }
  ```

  ```java
  public class User implements Serializable {

  	private String name; // 姓名
  	private Integer age; // 年龄
  	private Address address; // 地址
    	// 忽略set、get方法
  }
  ```

  ```java
  public String execute() throws Exception {
        user = new User();
        user.setName("张三");
        user.setAge(20);
        Address address = new Address();
        address.setProvince("湖南省");
        address.setCity("永州市");
        address.setRegion("冷水滩区");
        user.setAddress(address);
        return SUCCESS;
  }
  ```

  ```html
  user.name:<s:property value="user.name"/><br/>
  user.age:<s:property value="user.age"/><br/>
  user.address.city:<s:property value="user.address.city"/><br/>
  ```

- 查看ActionContext中的数据

  使用\<s:debug />查看数据，ActionContext的组成

  - 值栈-ValueStack
  - 非值栈-StackContext

![20180103205705](http://www.znsd.com/znsd/courses/uploads/92898e3c74784d023d131ca49c521705/20180103205705.png)

###  OGNL使用应注意的问题

**访问Bean的属性**

- Bean的类型必须遵循JavaBean规范，必须具有无参构造
- setter/getter方法符合JavaBean规范

**访问集合对象**

- 可以使用属性名[index]的方式访问列表和数组
- 可以使用属性名[key]的方式访问Map对象
- 使用size或者length获取集合长度

### 小结

- OGNL访问非ValueStack对象。
- OGNL过滤集合数据。
- OGNL访问ValueStack属性。

### Struts2标签

Struts2提供了大量标签来实现表示层页面，Struts2的标签相比JSTL标签功能要强大的多。Struts2将标签全部定义在URI为"/struts-tags"的空间下，大致可以分为三类：

- UI标签：用于生成HTML元素的标签。
  - 表单标签：用于生成HTML表单元素。
  - 非表单标签：用于生成页面上的树，Tab页邓标签。
- 非UI标签：用于数据访问，逻辑控制等标签。
  - 流程控制标签：用于实现分支、循环等流程控制标签。
  - 数据访问：用于输出ValueStatck中的值，国际化等标签。
- Ajax标签：用于AJAX支持的标签。

![20180104102308](http://www.znsd.com/znsd/courses/uploads/79e1325dab28e2745c1700fdb5a49c7e/20180104102308.png)

### 使用Struts2标签

- 导入Struts2标签库

  ```html
  <%@ taglib prefix="s" uri="/struts-tags" %>
  ```

- 使用标签

  ```html
  <s:set name="age" value="10" scope="request"/>
  <s:property value="#request.age"/>
  ```

#### 数据访问标签

常用数据访问标签

| 标   签    | 说    明             |
| -------- | ------------------ |
| debug    | 生成一个调试链接           |
| set      | 设置一个新变量            |
| property | 用于输出某个值            |
| url      | 生成一个URL地址          |
| action   | 直接在JSP页面调用一个Action |
| bean     | 创建一个JavaBean对象     |
| include  | 引入一个Servlet或者JSP页面 |
| date     | 格式化一个日期            |

#### set标签

- set标签：用于将某个值放入指定范围内。

- 属性：

  - name：可选属性，指定变量的名称。
  - value：可选属性，指定变量的值。必须再加一个''。
  - scope：可选属性，指定放置的位置，application，session，request，page和action，action为默认值。action为放入StackContext。

  ```html
  <s:set name="name" value="'zhangsan'" scope="session" />
  ```

#### property标签

- property标签用于输出value指定的值。
- 属性：
  - value：可选属性，指定要输出的值，如果没有指定该属性，则默认输出ValueStack栈顶的值。
  - default：可选属性，如果输出的值为null，则显示default属性指定的值。
  - escape：可选属性，指定是否escape HTML代码，默认为true。

```html
<s:property value="name" />
```

#### URL标签

- 用于生成一个URL地址，可以通过param子元素指定参数。
- 属性：
  - value属性：表示指定生成URL的地址。
  - encode：可选，指定是否对参数进行编码。默认为true。
  - <s:param />表示需要传递的参数信息
    - name属性：表示传递的参数名称
    - value属性：表示传递参数所具有的值，字符串必须再加一个`''`

```html
<s:url value="login.action">
	<s:param name="username" value="'sss'"></s:param>
	<s:param name="password" value="123"></s:param>
</s:url>
```

#### Action标签

- action标签允许直接调用Action。
- 属性：
  - var：可选属性，如果定义该属性，action将被放入ValueStack。
  - name：必填属性，指定调用哪个Action。
  - namespace：可选属性，指定调用Action的namespace。
  - executeResult：可选属性，指定是否在本页面显示Action。默认为false。
  - ignoreContextParams：指定本页面中是否需要传入参数。

```html
<s:action name="testOgnl" namespace="/" executeResult="true" />
```

#### include标签

- 引入一个JSP页面，也可以通过param指定参数
- 属性
  - value：必填，指定要引入的Servlet或者JSP页面。

```html
<s:include value="login.jsp"></s:include>
<s:include value="login.jsp">
	<s:param name="aaa" value="111"></s:param>
</s:include>
<!-- 另一个页面获取值 -->
<span>${param.aaa}</span>
```

#### bean标签

- 创建一个JavaBean的实例
- 属性
  - name：必填，指定JavaBean的类名。
  - var：可选属性，如果定义该属性，bean将被放入ValueStack。

```html
<!-- 定义bean -->
<s:bean name="com.znsd.struts2.Address" var="address">
  	<!-- 调用set方法设置值 -->
	<s:param name="province" value="'湖南省'"></s:param>
	<s:param name="city" value="'永州市'"></s:param>
	<s:param name="region" value="'冷水滩区'"></s:param>
</s:bean>

address.province：<s:property value="#address.province"/><br/>
address.city：<s:property value="#address.city"/><br/>
address.region：<s:property value="#address.region"/><br/>
address.toString：<s:property value="#address.toString()"/>
```

#### date标签

- 格式化输出日期，还可以计算指定日期和当前日期之差。
- 属性：
  - format：可选，指定格式进行日期格式化。
  - nice：可选，该属性只有true和false两个值，用于指定是否输出指定日期与当前时间的时差，默认是false
  - name：必填，表示当前需要格式化的日期。
  - var：可选，如果指定了该属性，格式化后的字符串将被放入Stack Context和request中。

```html
<!-- 定义个date -->
<s:bean var="now" name="java.util.Date"></s:bean>
<!-- 格式化date -->
<s:date name="#now" format="yyyy-MM-dd HH:mm:ss"/>
```

#### 控制标签

常用控制标签

| 标   签                     | 说    明      |
| ------------------------- | ----------- |
| \<s:if>\</s:if>           | if条件结构      |
| \<s:elseif>\</s:elseif>   | else if条件结构 |
| \<s:else>\</s:else>       | else结构      |
| \<s:iterator>\</iterator> | 循环结构        |

#### if结构标签

- 条件语句结构

- 语法：

  ```html
  <s:if test="表达式">
  标签体
  </s:if>
  <s:else if test="表达式">
  标签体
  </s:elseif>
  <s:else>
  标签体
  </s:else>
  ```

- 例子

  ```html
  <s:set name="condition" value="2"></s:set>
  <s:if test="#condition>55">
  	大于55
  </s:if>
  <s:elseif test="#condition>10">
  	大于10
  </s:elseif>
  <s:else>
  	都不满足
  </s:else>
  ```
#### iterator标签

- 用于对集合进行迭代。
- 属性：
  - value：可选，value指定被迭代的集合。
  - id：可选，指定集合元素的id。
  - status：可选，指定迭代变量。

```html
<!-- 迭代list -->
<s:set name="testList" value="{'aaa','bbb','ccc'}"></s:set>
<s:iterator id="name" value="#testList">
	<s:property value="name"/>
</s:iterator><br/>

<!-- 迭代map -->
<s:iterator value="#{'key1':'value1','key2':'value2'}">
	<s:property value="key"/>
	<s:property value="value"/>
</s:iterator>
```

#### 表单标签

常用表单标签

| 标   签                             | 说    明 |
| --------------------------------- | ------ |
| \<s:form>…\</s:form>              | 表单标签   |
| \<s:textfield>…\</s:  textfield > | 文本输入框  |
| \<s:password>…\</s:  password >   | 密码输入框  |
| \<s:textarea>…\</s:  textarea >   | 文本域输入框 |
| \<s:radio>…\</s:  radio >         | 单选按钮   |
| \<s:checkbox>…\</s:  checkbox >   | 多选框    |
| \<s:submit />                     | 提交标签   |
| \<s:reset />                      | 重置标签   |
| \<s:hidden />                     | 隐藏域标签  |

使用Form表单更简单，布局更方便，自带提示信息。

```html
<s:form action="login.action" method="POST" namespace="/">
	<s:textfield name="username" label="用户名"></s:textfield>
	<s:password name="password" label="密码"></s:password>
	<!-- value是选中的 -->
	<s:select list="#{'1':'博士','2':'硕士',3:'大学',4:'高中'}" name="edu" label="学历" value="3"></s:select>
	<!-- 必须有name -->
	<s:checkbox name="like" label="吃饭"></s:checkbox>
	<s:checkbox name="like" label="喝酒"></s:checkbox>
	<s:checkbox name="like" label="打游戏"></s:checkbox>
	<!-- 多个checkbox -->
	<%-- <s:checkboxlist list="{'吃饭','喝酒','玩游戏'}" label="爱好" name="like"></s:checkboxlist> --%>
	<s:checkboxlist list="#{1:'java',2:'c++',3:'ruby',4:'c#'}" label="编程语言" name="language"></s:checkboxlist>
	
	<!-- 如果action中sex有值则默认会选中 -->
	<s:radio list="{'男','女'}" name="sex" value="#request.sex"></s:radio>
	
	<s:textarea rows="10" cols="50" label="备注" name="remark"></s:textarea>
	
	<s:submit value="提交"></s:submit>
</s:form>
```

更改默认主题风格

```xml
<struts>
  	<!-- 设置用户界面主题，默认值为xhtml风格 -->
	<constant name="struts.ui.theme" value="simple"/>
</struts>
```

#### 高级表单标签

| 标   签         | 说    明         |
| ------------- | -------------- |
| select        | 用于生成一个下拉列表     |
| radio         | 生成多个单选框        |
| checkboxlist  | 一次创建多个复选框      |
| doubleselect  | 生成一个级联列表       |
| updownselecet | 生成一个可以上下移动的列表框 |

```html
<s:set var="list" value="{'zhangsan','lisi','wangwu','zhaoliu'}" />
	<s:set var="stu_map" value="#{'zhangsan':'张三今年20岁','lisi':'李四今年22岁','wangwu':'王五今年长胖了','zhaoliu':'赵六今年长瘦了'}" />
	<h2>下拉列表</h2>
	<s:select list="#list" label="用户列表"></s:select>
	<s:select list="#stu_map" label="用户列表"></s:select>
	<h2>单选按钮</h2>
	<s:radio name="myradio1" list="#list"></s:radio><br>
	<s:radio name="myradio2" list="#stu_map" listKey="key" listValue="value" value="lisi" />
	<h2>复选按钮</h2>
	<s:checkboxlist name="mycheckbox1" list="#list" /><br>
	<s:checkboxlist name="mycheckbox1" list="#stu_map" listKey="key" listValue="value" value="lisi" />
```

#### 非表单标签

主要在页面中生成一些信息

| 标   签         | 说    明                     |
| ------------- | -------------------------- |
| actionerror   | 返回getActionError()的错误信息    |
| actionmessage | 返回getActionMessages()的提示信息 |
| fielderror    | 返回表单的验证错误信息                |

### 小结

- Struts2标签分类
- 控制标签
- 表单标签
- 非表单标签

### 总结

- OGNL表达式
- Struts2标签