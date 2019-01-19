## 第三章     视图及REST 

### 本章目标 

- 视图和视图解析器
- 进行重定向和转发
- Spring表单标签
- REST CRUD

### 什么是视图解析器 

SpringMVC用于处理视图最重要的两个接口是ViewResolver和View。 

- ViewResolver的主要作用是把一个逻辑上的视图名称解析为一个真正的视图，SpringMVC中用于把View对象呈现给客户端的是View对象本身，而ViewResolver只是把逻辑视图名称解析为对象的View对象。 
- View接口的主要作用是用于处理视图，然后返回给客户端。

### 视图解析器的解析流程  

请求处理方法执行完成后，最终返回一个 ModelAndView对象。对于那些返回 String，View 或 ModeMap 等类型的处理方法，Spring MVC 也会在内部将它们装配成一个**ModelAndView** 对象，它包含了逻辑名和模型对象的视图。Spring MVC 借助视图解析器（ViewResolver）得到最终的视图对象（View），最终的视图可以是 JSP ，也可能是其他的文件形式的视图。对于最终究竟采取何种对象对模型数据的渲染，处理器并不关心，处理器工作重点聚焦在生产模型数据的工作上，从而实现MVC的充分解耦。

![20160313234729859](http://www.znsd.com/znsd/courses/uploads/35fe28c452365dc3d06c7536f6bd3e6d/20160313234729859.jpg)

### 视图（View）

- 视图的作用是渲染模型数据，将模型里面的数据以某种形式呈现给客户。 

- 为了实现视图模型和具体实现技术的解耦，Spring定义了一个View接口。 

  ![20170222103641618](http://www.znsd.com/znsd/courses/uploads/495ea2bc5e70a17a65925f6c378cab89/20170222103641618.jpg)

- 视图对象由视图解析器负责实例化，由于视图是无状态的，所以它们不会有线程安全问题。 

### 常用的视图实现类 

| 大类     | 视图类型                     | 说明                                                         |
| -------- | ---------------------------- | ------------------------------------------------------------ |
| URL视图  | InternalResourceView         | 将JSP资源封装成一个视图，是springmvc默认使用的视图解析器。   |
| URL视图  | JstlView                     | 如果jsp项目中导入了jstl标签的jar包，则springmvc会自动使用该视图解析器。 |
| 文档视图 | AbstractExcelView            | Excel文档视图的抽象类，该视图基于POI构造Excel文档            |
| 文档视图 | AbstractPdfVIew              | PDF文档视图的抽象类，该视图基于iText构建Pdf文档              |
| 报表视图 | ConfigurableJsperReportsView | 几个使用JasperReports报表技术的视图                          |
| 报表视图 | JasperReportsCsvView         | 几个使用JasperReports报表技术的视图                          |
| 报表视图 | JasperReportsMultiFormatView | 几个使用JasperReports报表技术的视图                          |
| 报表视图 | JasperReportsHtmlView        | 几个使用JasperReports报表技术的视图                          |
| 报表视图 | JasperReportsPdfView         | 几个使用JasperReports报表技术的视图                          |
| 报表视图 | JasperReportsXlsView         | 几个使用JasperReports报表技术的视图                          |
| JSON视图 | MapingJacksonJsonView        | 将模型通过Jackson开源框架的ObjectMapper以Json方式输出        |



### 视图解析器（ViewResolver） 

- Spring MVC为逻辑视图名的解析提供了不同的策略，可以在Spring Web上下文中配置一种或者多种解析策略，并指定他们之间的先后顺序。每一种策略对应一个具体视图解析器的实现类。
- 视图解析器的作用比较单一，将逻辑视图解析为一个具体的视图对象。
- 所有的视图解析器都必须实现ViewResolver接口。

### 常用的视图解析器实现类 

| 大类             | 视图类型                     | 说明                                                         |
| ---------------- | ---------------------------- | ------------------------------------------------------------ |
| 解析为Bean的名字 | BeanNameViewResolver         | 将逻辑视图名解析为一个Bean，Bean的id等于逻辑视图名。         |
| 解析为URL文件    | InternalResourceViewResolver | 将视图名解析为一个URL文件，一般使用该解析器将视图名映射为一个保存在WEB-INF目录下的程序文件(如JSP文件)。 |
| 解析为URL文件    | JasperReportsViewResolver    | JasperReports是一个基于Java的开源报表工具，该解析器将视图名解析为报表文件对应的URL。 |
| 模板文件视图     | FreeMarkerViewResolver       | 解析基于FreeMarker模版技术的模板文件                         |
| 模板文件视图     | VelocityViewResolver         | 解析基于Velocity模板技术的模板文件                           |
| 模板文件视图     | VelocityLayoutViewResolver   | 解析基于Velocity模板技术的模板文件                           |



### InternalResourceViewResolver

- JSP是最常用的视图技术，可以使用InternalResourceViewResolver作为视图解析器。
- 配置Spring MVC视图解析器
  - prefix：视图路径前缀
  - suffix：视图路径后缀

```xml
<!-- 配置视图解析器 将视图返回字符串解析到：/WEB-INF/view/返回值.jsp 下-->
<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
	<property name="prefix" value="/WEB-INF/view/" />
	<property name="suffix" value=".jsp" />
</bean>
```

### JstlView 

- 只要项目中引用了jstl标签，则Spring MVC会自动把视图由InternalResourceView转换为JstlView。 
- JstlView是InternalResourceView的子类。 

### 常用的视图解析器的实现类 

- 程序员可以选择一种视图解析器或混用多种视图解析器。
- 每个视图解析器都实现了Ordered接口并开放出了一个order属性，可以通过order属性设置解析器的优先级，order越小，优先级越高。
- Spring MVC会按视图解析器顺序的优先级对逻辑视图名进行解析，直到解析成功并返回视图对象，否则会抛出ServletException异常。

### 自定义视图 

- 添加一个自定义视图，实现View接口。

  ```java
  @Component  //把视图放到IOC容器里面 ，这里视图的名字就是helloView
  public class HelloView implements View {
  
  	@Override
  	public String getContentType() {
  		return "text/html";
  	}
  
  	@Override
  	public void render(Map<String, ?> model, HttpServletRequest request, HttpServletResponse response)
  			throws Exception {
  		response.getWriter().println("hello view current time : " + new Date());
  	}
  }
  ```

- 通过BeanNameViewResolver定义名称视图解析器。

  ```xml
  <!-- BeanNameViewResolver 解析器：使用视图的名字来解析视图 -->
  <bean class="org.springframework.web.servlet.view.BeanNameViewResolver">
  	<!-- order值越小优先级越高 -->
  	<!-- InternalResourceViewResolver的order值是inter的最大值，所以一般来说都是最后调用的 -->
  	<property name="order" value="100" />
  </bean>
  ```

- 设置order属性定义视图解析器的优先级，数值越小优先级越高。

  ```xml
  <!-- order值越小优先级越高 -->
  <!-- InternalResourceViewResolver的order值是inter的最大值，所以一般来说都是最后调用的 -->
  <property name="order" value="100" />
  ```

- 在Spring 配置文件中将自定义视图的包添加到自动扫描路径中。 

  ```xml
  <context:component-scan base-package="com.znsd.springmvc.view" />
  ```

- 在控制器方法上返回自定义的视图名称

  ```java
  @RequestMapping("testCustomeView")
  public String testCustomeView() {
      System.out.println("testCustomeView");
      return "helloView"; // helloView对应自定义的视图(HelloView)bean id
  }
  ```

### 关于重定向

- 一般情况下，控制器返回字符串类型的值会被当成逻辑视图名进行处理。

- 如果返回字符串中带有forward:或者redirect:前缀时，SpringMVC会将其进行特殊处理。将forward:和redirect:作为指示符，其后面字符串作为url来处理。

- 例如

  ```java
  @RequestMapping("forward")
  public String testForward() {
      return "forward:/success.jsp"; // 会完成一个到 success.jsp的转发操作。
  }
  
  @RequestMapping("redirect")
  public String testRedirect() {
      return "redirect:/success.jsp"; // 会完成一个到 success.jsp的重定向操作。
  }
  ```


### 小结 

- 常用的视图
- 常用的视图解析器
- 如何进行重定向和转发

### 使用Spring表单标签

- 通过SpringMVC表单标签可以实现将模型数据中的属性和HTML表单元素进行绑定，以实现表单数据更便携编辑和回显。

- 导入SpringMVC表单标签

  ```html
  <%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %> 
  ```

#### form标签 

使用Spring的form标签主要有两个作用 

- 它会自动的绑定来自Model中的一个属性值到当前form对应的实体对象，默认是command属性，这样我们就可以在form表单体里面方便的使用该对象的属性了； 

- 它支持我们在提交表单的时候使用除GET和POST之外的其他方法进行提交，包括DELETE和PUT等。

  ```html
  <form:form action="loginPost" method="post" commandName="user">
      <table>
          <tr>
              <td>用户名：</td>
              <td><form:input path="name" /></td>
          </tr>
          <tr>
              <td>密码：</td>
              <td><form:password path="pass" /></td>
          </tr>
          <tr>
              <td></td>
              <td><input type="submit" value="登录" /></td>
          </tr>
      </table>
  </form:form>
  ```

#### form的绑定问题 

form默认自动绑定的是Model的command属性值，那么当我的form对象对应的属性名称不是command的时候，应该怎么办呢？ 

- Spring给我们提供了一个commandName属性，我们可以通过该属性来指定我们将使用Model中的哪个属性作为form需要绑定的command对象。 

- 也可以指定modelAttribute属性也可以达到相同的效果。

  ```html
  <form:form action="/loginPost" method="post" commandName="user">    
  </form:form>
  <!-- 或者 -->
  <form:form action="/loginPost" method="post" modelAttribute="user">    
  </form:form>
  ```

#### 表单标签 

**普通标签**

- form:input：对应\<input type="text">
- form:password：对应\<input type="password" />
- form:hidden：对应\<input type="hidden" />
- form:textarea：对应\<textarea />
- form:checkbox：对应\<input type="checkbox" />
- form:radiobutton：对应\<input type="radiobutton"/>

#### 表单标签的通用属性 

SpringMVC提供了多个表单标签，用以绑定表单字段的属性值，它们共有的属性如下。 

- `path`：表单字段，对应html中的name属性，支持级联属性。
- htmlEscape：是否对表单的HTML特殊字符进行转换，默认值为true。
- cssClass：对应的css样式。
- cssErrorClass：发生错误时，对应的css样式。 

#### 支持数据绑定的表单标签

支持绑定集合数据的标签标签： 

- checkboxes：多选列表
- radiobuttons：单选列表
- select：下拉列表
  - option/options：select中的元素 

#### Radiobuttons 

form:radiobuttons：单选框组标签，用于构造多个单选框 

- path：（必填）名称，要绑定的属性。
- items：（必填）可以是一个list、String[]和Map。
- itemValue：指定radio的value值，可以使集合中bean的一个属性值。
- itemLabel：指定radio的label值。
- delimiter：多个单选框可以通过delimiter指定分隔符。

#### radiobuttons 数据绑定

**radiobuttons可以绑定数组，集合和Map。**

```java
@RequestMapping("dataBind")
public String dataBind(Map<String, Object> map) {
    //生成绑定的集合属性
    List<String> genderList = new ArrayList<String>();
    genderList.add("男");
    genderList.add("女");
    map.put("genderList", genderList);

    //生成绑定自定义类型的集合属性
    List<Role> roleList = new ArrayList<Role>();
    roleList.add(new Role(1, "管理员"));
    roleList.add(new Role(2, "老师"));
    roleList.add(new Role(3, "学生"));
    map.put("roleList", roleList);

    //User中必须包含和path同名的get和set方法，否则会报错
    User user = new User();
    user.setUsername("admin");
    user.setPassword("123");
    //绑定对象时，需要重写toString()方法才能比较值。
    user.setGender("男");
    user.setRole(new Role(3, "学生"));
    user.setAge(22);

    map.put("user", user);
    return "dataBind";
}
```

```html
<form:form action="loginPost" method="post" modelAttribute="user">
    <table>
        <tr>
            <td>用户名：</td>
            <td><form:input path="username" /></td>
        </tr>
        <tr>
            <td>密码：</td>
            <td><form:password path="password" /></td>
        </tr>
        <tr>
            <td>性别：</td>
            <td>
                <form:radiobuttons path="gender" items="${genderList}"/>
            </td>
        </tr>
        <tr>
            <td>年龄</td>
            <td>
                <form:input path="age"/>
            </td>
        </tr>
        <tr>
            <td>角色：</td>
            <td>
                <!-- 这里items表示要绑定的集合属性，如果是字符串集合，不需要指定itemValue和itemLabel，如果是自定义的集合对象，则必须指定 -->
                <form:radiobuttons path="role" itemValue="roleId" itemLabel="roleName" items="${roleList}"/>
            </td>
        </tr>
        <tr>
            <td></td>
            <td><input type="submit" value="登录" /></td>
        </tr>
    </table>
</form:form>
```

#### Errors标签 

**form:errors：显示表单组件或数据效验所对应的错误。**

- <form:errors path="*" />：显示表单中所有的错误。
- *<form:errors path="user*" />：显示所有以user为前缀的属性对应的错误。
- <form:error path="username" />：显示username表单元素的错误。 

#### 练习：表单元素 

添加用户信息 

![image](http://www.znsd.com/znsd/courses/uploads/781615309d442170166a9bfd9c53ac0e/image.png)![image](http://www.znsd.com/znsd/courses/uploads/08715bd0c84eb668d5f73128f6890571/image.png)

#### 小结 

SpringMVC中的表单标签 

- form标签
- input，password，hidden，textarea，checkbox，radiobutton
- checkboxes，radiobuttons，select

### URI：统一资源标识符（Uniform Resource Identifier)

定义：一个用于标识某一互联网资源名称的字符串。该种标识允许用户对任何（包括本地和互联网）的资源通过特定的协议进行交互操作。URI由包括确定语法和相关协议的方案所定义。

```
协议名称://域名.根域名/目录/文件名.后缀
e.g.：http://www.lxit.com/imgs/logo.jpg
```

URI由三部分组成

- 主机名

  - 域名标志的就是服务器主机名

    ```
    www.lxit.com
    ```

  - 访问的文件夹位置

    ```
    /imgs
    ```

  - 访问的文件名称

    ```
    /logo.jpg
    ```

- 标志符 

  - 有的URI指向一个资源的内部。 这种URI以“#”结束，并跟着一个[anchor](https://baike.baidu.com/item/anchor)标志符（称为片段标志符）。 

    ```
    协议://域名/目录/文件#片段标示符（例如：/a/b.php#a）
    ```

- 相对URI 

  - 相对URI不包含任何命名规范信息。它的路径通常指同一台机器上的资源。相对URI可能含有[相对路径](https://baike.baidu.com/item/%E7%9B%B8%E5%AF%B9%E8%B7%AF%E5%BE%84)（如，“..”表示上一层路径），还可能包含片段标志符

### URL(Uniform Resource Locator)  统一资源定位符 

`URL是一种具体的URI，它不仅唯一标识资源，而且还提供了定位该资源的信息。URI是一种语义上的抽象概念，可以是绝对的，也可以是相对的，而URL则必须提供足够的信息来定位，所以，是绝对的`

URL由三部分组成： 

- 第一部分是协议（或称为服务方式）
- 第二部分是存有该资源的[主机](https://baike.baidu.com/item/%E4%B8%BB%E6%9C%BA)IP地址（有时也包括[端口号](https://baike.baidu.com/item/%E7%AB%AF%E5%8F%A3%E5%8F%B7)）
- 第三部分是主机资源的具体地址。，如目录和文件名等

### REST 

- REST（Representational State Transfer）：即（资源）表现层状态传递。 
- 由Roy Fielding博士在2000年他的博士论文中提出来的一种软件架构风格。它是一种针对网络应用的设计和开发方式，可以降低开发的复杂性，提高系统的可伸缩性。 
- 资源（Resources）：网络上的一个实体，或者说网络上的一段信息。它可以是一段文本，一段歌曲，一张图片等等，可以用一个URL指向它，每个资源都有一个特定的，独一无二的URL，要访问这个资源，直接访问这个URI即可。 
- 表现层（Representation）：将资源呈现出来的形式。
- 状态转化（State Transfer）：每发出一个请求，就代表客户端和服务器一次交互。HTTP协议是一个无状态的协议，即所有的状态都保存在服务器端。客户端想要操作服务器，必须通过某些手段，让服务器发生状态转化，而这种转化是建立在表现层之上的，所以就是表现层状态转化。 

#### REST的描述 

- `用URL定位资源，用HTTP动词（GET,POST,DELETE,DETC）描述操作 `
- REST描述的是在网络中client和server的一种交互形式；REST本身不实用，实用的是如何设计 RESTful API（REST风格的网络接口） 
- Server提供的RESTful API中，URL中只使用名词来指定资源，原则上不使用动词。“资源”是REST架构或者说整个网络处理的核心。例如：web_service/studentInfo----获取学生信息
- 用HTTP协议里的动词来实现资源的添加，修改，删除等操作。即通过HTTP动词来实现资源的状态扭转 
  - GET 获取资源/POST 新建资源/PUT 更新资源/DELETE 删除资源 
- Server和Client之间传递某资源的一个表现形式，比如用JSON，XML传输文本，或者用JPG，WebP传输图片等。当然还可以压缩HTTP传输时的数据
- 用 HTTP Status Code传递Server的状态信息。比如最常用的 200 表示成功，500 表示Server内部错误等

#### REST的限制与优点 

- 客户-服务器（Client-Server）客户端服务器分离 ,
  - 提高用户界面的便携性（操作简单）
  - 通过简化服务器提高可伸缩性（高性能，低成本）
  - 允许组件分别优化（可以让服务端和客户端分别进行改进和优化）
- 无状态（Stateless）：客户端的每个请求要包含服务器所需要的所有信息 
  - 提高可见性（可以单独考虑每个请求）
  - 提高了可靠性（更容易从局部故障中修复）
  - 提高可扩展性（降低了服务器资源使用）
- 缓存（Cachable） 
  - 减少交互次数，交互的平均延迟
- 分层系统（Layered System）
  - 系统组件不需要知道与他交流组件之外的事情。封装服务，引入中间层，限制了系统的复杂性，提高可扩展性
- 统一接口（Uniform Interface）
  - 提高交互的可见性，鼓励单独改善组件
- 支持按需代码（Code-On-Demand 可选）
  - 提高可扩展性 

#### HTTP请求的四种状态

REST中规定HTTP协议中四个表示操作方式的动词： 

- GET：获取资源
- POST：新建资源
- PUT：更新资源
- DELETE：删除资源

#### REST示例 

- /user/1   HTTP GET：得到id为1的User。

- /user/1   HTTP DELETE：删除id为1的User。

- /user/1   HTTP PUT：更新id为1的User。

- /user      HTTP POST ： 新增User

- HiddenHttpMethodFilter：浏览器form表单只支持GET和POST请求，而DELETE、PUT等Method并不支持，Spring3.0添加了一个过滤器，可以将这些请求转换为标准的HTTP方法，似的支持GET、POST、PUT与DELETE请求。

  ```xml
  <!-- 配置HiddenHttpMethodFilter过滤器实现PUT，DELETE请求 -->
  <filter>
      <filter-name>HiddenHttpMethodFilter</filter-name>
      <filter-class>
          org.springframework.web.filter.HiddenHttpMethodFilter
      </filter-class>
  </filter>
  <filter-mapping>
      <filter-name>HiddenHttpMethodFilter</filter-name>
      <url-pattern>/*</url-pattern>
  </filter-mapping>
  ```

#### Get请求 

```java
/**
 * 根据id获取用户
 * @param id
 * @return
 */
@RequestMapping(value = "/user/{id}", method = RequestMethod.GET)
public String get(@PathVariable("id") Integer id) {
    System.out.println("get userId:" + id);
    return "hello";
}
```

```html
<a href="user/1">Test Rest Get</a>
```

#### POST请求 

```java
/**
 * 添加用户
 * @param user
 * @return
 */
@RequestMapping("/user")
public String post(User user) {
    System.out.println("post user=" + user);
    return "hello";
}
```

```html
<form action="user" method="post">
    <input type="submit" value="submit">
</form>
```

#### PUT和DELETE请求 

由于HTML只支持GET和POST请求，如果需要使用PUT和DELETE请求，需要做如下修改： 

- 添加过滤器HiddenHttpMethodFilter
- 发送POST请求
- 需要在POST请求中添加一个隐藏域，name="_method",value="PUT/DELETE"。
- 或者使用Springmvc的form标签也可以替代html的form标签。 

#### PUT请求 

PUT请求，PUT请求实际上是通过POST请求转换而来。 

```java
/**
 * 根据id更新用户
 * @param id
 * @return
 */
@RequestMapping(value = "/user/{id}", method = RequestMethod.PUT)
public String put(@PathVariable("id") Integer id) {
    System.out.println("put userId:" + id);
    return "hello";
}
```

```html
<form action="user/1" method="post">
    <!-- 添加隐藏域，名称为_method，value为请求方式 -->
    <input type="hidden" name="_method" value="PUT"> 
    <input type="submit" value="submit">
</form>
```

#### DELETE请求 

```java
/**
 * 根据id删除用户
 * @param id
 * @return
 */
@RequestMapping(value = "/user/{id}", method = RequestMethod.DELETE)
public String delete(@PathVariable("id") int id){
    System.out.println("delete userId:" + id);
    return "hello";
}
```

```html
<form action="user/1" method="post">
    <input type="hidden" name="_method" value="DELETE"> 
    <input type="submit" value="submit">
</form>
```

#### 小结 

- 什么是Rest风格的请求处理。
- 如何实现PUT和DELETE请求

### REST CRUD 

#### 显示所有员工信息 

- URI：emps

- 请求方式：GET

- 显示效果

  ![image](http://www.znsd.com/znsd/courses/uploads/21b66bce26b4ed4a59bbce77a5c9856e/image.png)

#### 添加员工信息 

- 显示添加页面                       添加员工信息
- URI：emp                            URI：emp
- 请求方式：GET                   请求方式：POST
- 显示效果：                          显示效果：添加完成后重定向到list

![image](http://www.znsd.com/znsd/courses/uploads/0b99f897ec18150d0cc044333341e32b/image.png)![image](http://www.znsd.com/znsd/courses/uploads/ddc10272cd0765f6cb6b5de9d1c30749/image.png)

#### 删除操作 

- URI：emp/{id}
- 请求方式：DELETE
- 删除后效果：删除对应的数据

#### 修改操作： 

- 显示修改页面 
  - URI：emp/{id}
  - 请求方式：GET
  - 显示效果：回显表单
- 修改员工信息： 
  - URI：emp
  - 请求方式：PUT
  - 显示效果：完成修改，重定向到list。

#### REST CRUD 

相关的类

- 实体类：Employee，Department。
- Handler：EmployeeHandler
- Dao：EmployeeDao，DepartmentDao。

相关的页面 

- list.jsp
- input.jsp
- edit.jsp

### 应注意的问题 

#### 提交表单是出现中文乱码，添加过滤器

```xml
<!-- 过滤中文乱码过滤器，注意，如果有多个过滤器，应该放到前面 -->
<filter>
	<filter-name>characterEncodingFilter</filter-name>
	<filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
	<init-param>
		<param-name>encoding</param-name>
		<param-value>UTF-8</param-value>
	</init-param>
	<init-param>
		<param-name>forceEncoding</param-name>
		<param-value>true</param-value>
	</init-param>
</filter>
<filter-mapping>
	<filter-name>characterEncodingFilter</filter-name>
	<url-pattern>/*</url-pattern>
</filter-mapping>
```

#### JS资源文件无法引用的问题 

- 在Springmvc配置文件中添加如下代码 

```xml
<!--将非mapping配置下的请求交给默认的Servlet来处理-->
<mvc:default-servlet-handler/>
<!--如果添加了默认servlet，mvc请求将无效，需要添加annotation-driven-->
<mvc:annotation-driven></mvc:annotation-driven>
```

- 配置了\<mvc:default-servlet-handler/>后，它会对经过DispatcherServlet的请求进行检查，如果发现没有经过映射请求，就将由WEB服务器默认的Servlet请求处理，一般WEB服务器的默认Servlet的名称都是default，若所使用的WEB服务器默认的servlet不是default，则需要通过default-servlet-name来指定。 
- 或者在web.xml中添加如下代码 

```xml
<!-- 配置将js文件交由默认的servlet处理，效果一样 -->
<servlet-mapping>  
	<servlet-name>default</servlet-name>  
	<url-pattern>*.js</url-pattern>  
</servlet-mapping>
```

#### 表单映射实体对象的问题 

select标签绑定部门，无法直接映射问dept对象，需要映射id，然后根据id转换为部门对象。 

```html
<!--前台绑定部门到下拉列表中，部门集合List<Dept>-->
部门：<form:select path="dept.id" items="${depts}" itemValue="id" itemLabel="deptName"></form:select><br><br>
```

```java
//后台获取绑定的id，然后根据id获取Dept对象存储到emp中。
public String empAdd(Employee employee) {
	// 将部门映射到dept.id属性中，然后通过id获取部门详细信息
	Dept d = deptDao.getOne(employee.getDept().getId());
	employee.setDept(d);
	employeeDao.add(employee);
	System.out.println("save: " + employee);
	return "redirect:/emps";
}
```

#### 修改操作时，提交表单的路径问题 

```html
<!--这里使用绝对路径-->
<form:form action="${pageContext.request.contextPath}/emp/${emp.id}" method="put" commandName="emp">
</form:form>
```

### 总结 

- 视图和视图解析器
- 重定向
- Spring表单标签
- REST CRUD

