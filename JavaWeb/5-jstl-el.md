## 第五章 JSTL和EL

### 回顾及作业点评

- 如何使用Servlet实现转发？
- 如何使用Servlet实现重定向？

### 本章目标

- 理解并会使用EL表达式`重点`
- 理解并会使用常用的JSTL标签`重点（难点）`

### 为什么需要EL

JavaBean在JSP中的局限

- 在JSP页面中嵌入大量的Java代码

- 获取JavaBean属性必须要实例化

- 实现了JSP页面中的`代码复用`（基于标签库原理，重复率较高的代码块支持复用，提高效率）

- 书写JSP页面时`可读性更强`（长得很像xml，方便前端查看和参与开发）

- 强制类型转化

  ```java
  <%	
      Employee employee = (Employee)request.getAttribute("employee");
      Computer comp = employee.getComputer();
      String manufacturer = comp.getManufacturer();
  %>
  ```

- 解决办法：使用EL表达式简化

### EL表达式简介

- 什么是EL：ExpressionLanguage（表达式语言）
- EL的功能：替代JSP页面中的复杂代码
- EL的特点：自动转换类型（EL得到某个数据时可以自动转换类型 ）
- 使用简单 

### EL表达式语法-1

EL表达式语法：

```html
${EL exprission }
```

- 使用变量名获取值
- 获取对象的属性值
- 获取集合

### EL表达式语法6-2

- 使用变量名获取值

```html
${变量名}
```

```html
<%  request.setAttribute("username","LiYang"); %>
姓名: ${username}
```

- 变量属性范围名称

| 属性范围        | EL中的名称                                   |
| ----------- | ---------------------------------------- |
| page        | pageScope,例如${pageScope.username}，表示在page范围内查找username变量，找不到返回Null |
| request     | requstScope                              |
| session     | sessionScope                             |
| application | applicationScope                         |

### EL表达式语法-3

获取对象的属性值

- 点操作符

  ```html
  ${user.name}
  ```

- [ ]操作符

  ```html
  ${user["name"]}
  ```

  ```java
  <%	
      User user = (User )request.getAttribute("user");
      user.getName();
  %>
  ```

- 注意：

  1. :说明之前用<%%>是如何获取request当中的属性值
  2. 用EL表达式如何实现（两种方式）
  3. [ ]与.运算符EL 提供“.“和“[ ]“两种运算符来存取数据。当要存取的属性名称中包含一些特殊字符，如.或?等并非字母或数字的符号，就一定要使用“[ ]“。例如：\${user.My-Name}应当改为${user["My-Name"] }如果要动态取值时，就可以用“[ ]“来做，而“.“无法做到动态取值。例如：\${sessionScope.user[data]}中data 是一个变量
  4. 在JavaBean中需要有相应的方法才能用EL表达式这样取值。
  5. 强调${user["name"]}中的引号不能丢

### EL表达式语法-4

获取集合－List

```java
<%
	List<String> names = new ArrayList<String>();
	names.add("zhangsan");
	names.add("lisi");
	
	request.setAttribute("names", names);
%>

<!-- 使用EL表达式输出姓名 -->
姓名:${names[0]}<br>
姓名:${names[1]}<br>
```

![20180127103438](http://www.znsd.com/znsd/courses/uploads/9b7b343b56dcbb0dd9edb77ca9a0dbbd/20180127103438.png)

### EL表达式语法-5

获取集合－Map

```java
<%
    Map<String, String> names = new HashMap<String, String>();
    names.put("one","LiYang");
    names.put("two","WangHua");
    request.setAttribute("names",names);
%>
姓名：${names.one}<br/>
姓名：${names["two"] }<br/>
```

![20180127103805](http://www.znsd.com/znsd/courses/uploads/fe33b8bfb6d6ed932230ce97ab016105/20180127103805.png)

### EL表达式语法-6

- 语法：${  EL exprission }

- 关系操作符

- 逻辑操作符Empty操作符

  - 变量 a不存在，则${empty a}返回的结果为true
  - \${not empty a}或${!empty a}返回的结果为false

  ​

| 逻辑操作符     | 说明   | 示例                                | 结果    |
| --------- | ---- | --------------------------------- | ----- |
| &&(或and)  | 逻辑与  | 如果A为true，B为false，则A&&B(或A and B)  | false |
| \|\|(或or) | 逻辑或  | 如果A为true，B为false，则A\|\|B(或A or B) | true  |
| ! (或not)  | 逻辑非  | 如果A为true，则!A (或not A)             | false |

| 关系操作符   | 说明   | 示例                                       | 结果          |
| ------- | ---- | ---------------------------------------- | ----------- |
| ==(或eq) | 等于   | ${23==5}或${23 eq 5}  ${"a" =="a"}或${"a"  eq "a"} | false  true |
| !=(或ne) | 不等于  | ${23!=5}或${23 ne 5}                      | true        |
| <(或lt)  | 小于   | ${23<5}或${23 lt 5}                       | false       |
| >(或gt)  | 大于   | ${23>5}或${23 gt 5}                       | true        |
| <=(或le) | 小于等于 | ${23<=5}或${23 le 5}                      | false       |
| >=(或ge) | 大于等于 | ${23>=5}或${23 ge 5}                      | ture        |

`重点为关系操作符，常用的是等于和不等于，注意Empty操作符的使用`

### EL隐式对象

- EL隐式对象

![20180127105320](http://www.znsd.com/znsd/courses/uploads/9bf9b1d5334c9625deed5c03c76c7c9c/20180127105320.png)

- EL隐式对象介绍

| 对象名称             | 说   明                   |
| ---------------- | ----------------------- |
| pageScope        | 返回页面范围的变量名，这些名称已映射至相应的值 |
| requestScope     | 返回请求范围的变量名，这些名称已映射至相应的值 |
| sessionScope     | 返回会话范围的变量名，这些名称已映射至相应的值 |
| applicationScope | 返回应用范围内的变量，并将变量名映射至相应的值 |
| param            | 返回客户端的请求参数的字符串值         |
| paramValues      | 返回映射至客户端的请求参数的一组值       |
| pageContext      | 提供对用户请求和页面信息的访问         |

### EL表达式的综合应用

- 注册信息的读取和显示

  ![20180127143733](http://www.znsd.com/znsd/courses/uploads/18b368c7932893f6d822a7e6721cd4d1/20180127143733.png)![20180127143800](http://www.znsd.com/znsd/courses/uploads/91d22cd90131675a4c34760e9a18ea8b/20180127143800.png)

### 学员操作——使用EL实现问卷调查 

需求说明：

- 户输入昵称、所在城市，并且以多选的方式让用户选择所使用的开发语言，然后使用EL表达式显示在页面上

- 昵称和所在城市使用param对象输出

- 完成时间：30分钟

  ![image](http://www.znsd.com/znsd/courses/uploads/0066c0f34519cdebfe56386e7d9eadd7/image.png)![image](http://www.znsd.com/znsd/courses/uploads/a3bc247affd65485e6c95e56d29e5fdf/image.png)

### 为什么使用JSTL

- EL表达式可以简化JSP页面代码，但是如果需要进行逻辑判断怎么办？
- EL表达式可以访问JavaBean的属性，但是并不能实现在JSP中进行逻辑判断，因而要使用JSTL标签。

### 什么是JSTL

什么是JSTL：

- JSP标准标签库（JavaServerPages Standard Tag Library）
- JSTL通常会与EL表达式合作实现JSP页面的编码

JSTL的有点：

![20180127144118](http://www.znsd.com/znsd/courses/uploads/723a9062096f08c0346495611ee87640/20180127144118.png)

### JSTL的环境搭建

使用JSTL的步骤

- 在工程中引用JSTL的两个jar包和标签库描述符文件

- 在JSP页面添加taglib指令

- 使用JSTL标签

  ```html
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
  ```

### JSTL标准标签库介绍

JSTL标准标签库内的标签

![1333357659_8131](http://www.znsd.com/znsd/courses/uploads/365104c749e24da56334af6437ecd469/1333357659_8131.jpg)

### 通用标签

#### set

set标签用于设置指定范围内的变量值

- 将value值存储到范围为scope的变量variable中

  ```html
  <c:set var="variable" value="v" scope="scope"/>
  ```

- 将value值设置到对象的属性中

  ```html
  <c:set value="value" target="target" property="property" />
  ```

  ```java
  <%
      User user = new User(); 
      request.setAttribute("user", user);
  %>
  <c:set target="${user}" property="name" value="defaultName " />
  ```

#### out

out：计算表达式并将结果输出显示

- 不指定默认值

  ```html
  <c:out value="value" />
  ```

- 指定默认值

  ```html
  <c:out value="value" default="default" />
  ```

  ```html
  <%
      User user = new User(); 
      request.setAttribute("user", user);
  %>
  <c:set target="${user}" property="name" value="defaultName " />
  <c:out value="${user.name}" default="noUserName" />
  ```

- 说明：

  1. 说明\<c:out>标签，类似于JSP中的<%=%>
  2. 然后再说它可以指定默认值，这是比<%=%>强大的地方
  3. 说明指定默认值有什么好处

- 使用out计算表达式并将结果输出显示

  ```html
  <c:out value="${10*20}"></c:out>
  ```

- 转义特殊字符

  ```html
  <p>${"<a href='http://www.baidu.com'>百度</a>"}</p>
  <p>
      <c:out escapeXml="true" value="<a href='http://www.baidu.com'>百度</a>"/>
  </p>
  <c:out value="<a href='http://www.baidu.com'>百度</a>"/>
  ```

  ​

#### remove：

remove：删除指定范围内的变量

```html
<!-- 设置之前应该是空值 -->
设置变量之前的值是：msg=<c:out value="${msg}" default="null"/>
<!-- 给变量msg设值 -->
<c:set var="msg" value="Hello ACCP!" scope="page"></c:set>
<!-- 此时msg的值应该是上面设置的"已经不是空值了" -->
设置新值以后：msg=<c:out value="${msg}"></c:out><br>
<!-- 把 msg变量从page范围内移除-->
<c:remove var="msg" scope="page"/>
<!-- 此时msg的值应该显示null -->
移除变量msg以后：msg=<c:out value="${msg}" default="null" />
```

![image](http://www.znsd.com/znsd/courses/uploads/8d53b0376859bee7118f2a81dbce8700/image.png)

#### 小结

通用标签的使用

- 引入使用核心标签的指令

  ```html
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
  ```

- set 标签用于给变量设置值和作用范围（scope= "page|request|session|application" ）

  ```html
  <c:set var= "example" value="${100+1}" scope="session"  />	
  ```

- out 标签在页面上显示信息或变量值 

  ```html
  <c:out value="${example}"/>
  ```

- remove 标签用于删除作用域内的变量

  ```html
  <c:remove var= "example" scope="session"/>
  ```

### 条件标签

#### if

- if：实现Java语言中if语句的功能

  ```html
  <!--  test:判断条件表达式返回true/false -->
  <!-- var:该变量用于保存返回的true/false  -->
  <!-- scope:指定var变量的作用域    -->
  <c:if   test="codition"    var="name"    scope="applicationArea" >
  	…
  </c:if>
  ```

- 条件标签的应用

  ```html
  <c:set var="isLogin" value="${empty sessionScope.user}" />
  <c:if test="${isLogin}">
  …登录表单
  </c:if>
  <c:if test="${! isLogin}">
  已经登录！
  </c:if>
  ```

#### choose

choose：实现Java语言中if-else if-else语句的功能

```html
<c:choose>
	<c:when test="condition">
		主体内容
 	</c:when>
	<c:otherwise>
		主体内容
	</c:otherwise>
</c:choose >
```

### 迭代标签

#### forEach

forEach是for循环语句的变体，实现集合对象(可以是list、数组等)的处理 

-  forEach：实现对集合中对象的遍历

  ```html
  <%
  	List<String> strs = new ArrayList<String>();
  	strs.add("test1");
  	strs.add("test2");
  	strs.add("test3");
  	request.setAttribute("strs", strs);
  %>
  <c:forEach items="${strs}" var="name" varStatus="status">
  	<c:out value="${name}"></c:out>
  </c:forEach>
  ```

  - end指定迭代到集合的第几位结束
  - items指定要遍历的集合对象
  - step指定循环的步长
  - var指定当前成员的引用
  - varStatus属性用于存放var引用的成员的相关信息，如索引`index`,`count`,`first`,`last`等
  - begin指定从集合的第几位开始

- 通过迭代标签显示商品列表

  ```html
  <%
  	List products = GoodsDao.getAllProducts();
  	request.setAttribute("products", products);
  %>

  <!-- 循环输出商品信息 -->
  <c:forEach var="product" items="${requestScope.products}" varStatus="status">
  <!-- 如果是偶数行，为该行换背景颜色 -->
      <tr <c:if test="${status.index % 2 == 1 }">style="background-color:rgb(219,241,212);"</c:if>>
          <td>${product.name }</td>
          <td>${product.area }</td>
          <td>${product.price }</td>
      </tr>
  </c:forEach>
  ```

- 通过迭代标签遍历Map

  ```html
  <%
      Map<String,String> map=new HashMap<String,String>();
      map.put("tom", "美国");
      map.put("lily", "英国");
      map.put("jack","中国");
      request.setAttribute("map", map);
  %>
  <c:forEach var="entry" items="${map}">
       ${entry.key}
       ${entry.value}<p>
  </c:forEach>
  ```

  ![image](http://www.znsd.com/znsd/courses/uploads/97b1283332d5b43b273079a481cbc239/image.png)

-  forEach：指定迭代的次数

  ```html
  <c:forEach begin="1" end="5" step= "2">
  	<c:out value="*"></c:out>
  </c:forEach>
  ```

  ```java
  <!-- 等价于 -->
  for (int item = begin; item <= end; item += step) {
  	${item}
  }
  ```

  ​

  ![image](http://www.znsd.com/znsd/courses/uploads/66cb9cf6aa58c40c633ea6df56068d21/image.png)

### 学员操作—简化查询学生信息

- 训练要点：
  - 使用JSTL迭代标签循环所有栏目
  - 使用EL表达式逐项输出学生信息
- 需求说明：使用JSTL和EL把学生信息显示在页面上
- 实现思路：
  - 用数据库访问层取得所有栏目信息
  - 使用JSTL迭代标签和EL表达式输出这些学生信息

### 总结

- EL表达式的语法有两个要素：$和 {}
- EL表达式可以使用“.”或者“[]”操作符在相应的作用域中取得某个属性的值
- JSTL核心标签库中常用的标签有如下三类。
  1. 通用标签；\<c:set>、\<c:out>、\<c:remove>
  2. 条件标签；\<c:if>、\<c:choose>、\<c:when>、\<c:otherwise>
  3. 迭代标签：\<c:forEach>
- EL表达式与JSTL标签结合使用，可以减少JSP中嵌入的Java代码，有利于程序的维护和扩展