## 第三章  Struts2配置详解

### 本章目标

- 掌握Struts2核心配置文件`重点`
- Struts2的常量配置`重点（难点）`
- 掌握struts.xml中的各项内容`重点（难点）`
- 掌握action元素与result元素的配置

### Struts2的基本配置

Struts2的所有功能都是建立在配置上的，学会Struts2的配置非常重要，Struts2提供三个配置文件，分别是

- web.xml
- struts.xml
- struts.properties

### Struts2 的配置文件-web.xml

web.xml：核心控制器

- 需要在web.xml中进行配置
- 对框架进行初始化，以及处理所有的请求

```xml
<filter>
	<filter-name>struts2</filter-name>
	<!-- 在早期的版本中有的使用FilterDispatcher，但在Struts2.1.3版本中被废弃。 -->
	<filter-class>org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter</filter-class>
</filter>
<filter-mapping>
	<filter-name>struts2</filter-name>
	<!-- 将全部.action请求定位到指定的Struts 2过滤器中 -->
	<url-pattern>*.action</url-pattern>
</filter-mapping>
```

Struts 2.0版本的核心控制器为org.apache.struts2.dispatcher.FilterDispatcher

### Struts2配置文件基本结构

struts.xml：struts2核心配置文件

- 核心配置文件，主要负责管理Action
- 通常放在项目中的src目录下（src打成war包之后所对应的目录为WEB-INF/classes），在该目录下的struts.xml文件可以被自动加载

```xml
<struts>
  	<constant name="" value=""/>
	<package name="" namespace="" extends="">
		<action name="" class="">
			<result name=""></result>
		</action>
	</package>
</struts>
```

#### constant元素

- 配置常量，可以改变Struts 2框架的一些行为
- name属性表示常量名称，value属性表示常量值

```xml
<struts>
  	<!-- 设置字符集 -->
  	<constant name="struts.i18n.encoding" value="UTF-8"/> 	
  	<package name="" namespace="" extends="">
		<action name="" class="">
			<result name=""></result>			
		</action>
	</package>
</struts>
```

constant元素除了介绍设置字符集以外还可以通过<constant name="struts.ui.theme" value="simple"/>设置模板的风格为simple

1. 修改web.xml

   ```xml
   <!-- 在struts2过滤器中添加过滤jsp的配置 -->
   <filter-mapping>
   		<filter-name>struts2</filter-name>
   		<url-pattern>*.jsp</url-pattern>
   </filter-mapping>
   ```

2. jsp使用struts2标签

   ```html
   <%@ page language="java" contentType="text/html; charset=UTF-8"
       pageEncoding="UTF-8"%>
   <%@ taglib uri="/struts-tags" prefix="s" %>
   <html>
   <head>
   <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
   <title>register</title>
   </head>
   <body>
   	<s:form action="login.action" method="POST">
   		<s:textfield name="username" label="用户名"></s:textfield>
   		<s:password name="password" label="密码"></s:password>
   	</s:form>
   </body>
   </html>
   ```

3. 配置struts.xml文件

   ```xml
   <struts>
   	<!-- 设置struts标签主题为simple -->
   	<constant name="struts.ui.theme" value="simple"/>
   </struts>
   ```

- struts2常量

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE struts PUBLIC "-//Apache Software Foundation//DTD Struts Configuration 2.0//EN"
   "http://struts.apache.org/dtds/struts-2.0.dtd">
  <struts>
  	<!--指定Web应用的默认编码集.该属性对于处理中文请求参数非常有用,对于获取中文请求参数值,应该将该属性值设置为GBK或者GB2312; 提示:当设置该参数为GBK时,相当于调用HttpServletRequest的setCharacterEncoding方法. -->
  	<constant name="struts.i18n.encoding" value="UTF-8" />

  	<!--指定Struts 2默认的ObjectFactory Bean,该属性默认值是spring. -->
  	<constant name="struts.objectFactory" value="spring" />

  	<!--指定Spring框架的自动装配模式, 该属性的默认值是name, 即默认根据Bean的name属性自动装配. -->
  	<constant name="struts.objectFactory.spring.autoWire" value="name" />

  	<!--该属性指定整合Spring框架时,是否缓存Bean实例,该属性只允许使用true和false两个属性值,它的默认值是true.通常不建议修改该属性值. -->
  	<constant name="struts.objectFactory.spring.useClassCache"
  		value="true" />

  	<!--该属性指定处理multipart/form-data的MIME类型(文件上传)请求的框架,该属性支持cos,pell和jakarta等属性值, 
  		即分别对应使用cos的文件上传框架,pell上传及common-fileupload文件上传框架.该属性的默认值为jakarta. 注意:如果需要使用cos或者pell的文件上传方式,则应该将对应的JAR文件复制到Web应用中.例如,使用cos上传方式,则需要自己下载cos框架的JAR文件,并将该文件放在WEB-INF/lib路径下. -->
  	<constant name="struts.multipart.parser" value="jakarta" />

  	<!--该属性指定上传文件的临时保存路径,该属性的默认值是javax.servlet.context.tempdir. -->
  	<constant name="struts.multipart.saveDir" value="" />

  	<!--该属性指定Struts 2文件上传中整个请求内容允许的最大字节数. -->
  	<constant name="struts.multipart.maxSize" value="1000000000000" />

  	<!--该属性指定需要Struts 2处理的请求后缀,该属性的默认值是action,即所有匹配*.action的请求都由Struts 2处理.如果用户需要指定多个请求后缀,则多个后缀之间以英文逗号(,)隔开. -->
  	<constant name="struts.action.extension" value="do" />

  	<!--该属性设置是否通过JAR文件提供静态内容服务,该属性只支持true和false属性值,该属性的默认属性值是true. -->
  	<constant name="struts.serve.static" value="true" />

  	<!--该属性设置浏览器是否缓存静态内容.当应用处于开发阶段时,我们希望每次请求都获得服务器的最新响应,则可设置该属性为false. -->
  	<constant name="struts.serve.static.browserCache" value="true" />

  	<!--该属性设置Struts 2应用是否使用开发模式.如果设置该属性为true,则可以在应用出错时显示更多、更友好的出错提示.该属性只接受true和flase两个值,该属性的默认值是false.通常,应用在开发阶段,将该属性设置为true,当进入产品发布阶段后,则该属性设置为false. -->
  	<constant name="struts.devMode" value="false" />

  	<!--该属性设置是否每次HTTP请求到达时,系统都重新加载资源文件(允许国际化文件重载).该属性默认值是false.在开发阶段将该属性设置为true会更有利于开发,但在产品发布阶段应将该属性设置为false. 
  		提示:开发阶段将该属性设置了true,将可以在每次请求时都重新加载国际化资源文件,从而可以让开发者看到实时开发效果;产品发布阶段应该将该属性设置为false,是为了提供响应性能,每次请求都需要重新加载资源文件会大大降低应用的性能. -->
  	<constant name="struts.i18n.reload" value="false" />

  	<!--该属性指定视图标签默认的视图主题,该属性的默认值是xhtml. -->
  	<constant name="struts.ui.theme" value="simple" />

  	<!--该属性指定模板文件的后缀,该属性的默认属性值是ftl.该属性还允许使用ftl、vm或jsp,分别对应FreeMarker、Velocity和JSP模板. -->
  	<constant name="struts.ui.templateSuffix" value="ftl" />

  	<!--该属性设置当struts.xml文件改变后,系统是否自动重新加载该文件.该属性的默认值是false. -->
  	<constant name="struts.configuration.xml.reload" value="false" />

  	<!--该属性指定Struts 2应用所需要的国际化资源文件,如果有多份国际化资源文件,则多个资源文件的文件名以英文逗号(,)隔开. -->
  	<constant name="struts.custom.i18n.resources" value="nationz" />

  	<!--对于某些Java EE服务器,不支持HttpServlet Request调用getParameterMap()方法,此时可以设置该属性值为true来解决该问题.该属性的默认值是false.对于WebLogic、Orion和OC4J服务器,通常应该设置该属性为true. -->
  	<constant name="struts.dispatcher.parametersWorkaround" value="false" />

  	<!--指定是否缓存FreeMarker模版。默认值false。 -->
  	<constant name="struts.freemarker.templatesCache" value="true" />

  	<!--该属性只支持true和false两个属性值,默认值是true.通常无需修改该属性值. -->
  	<constant name="struts.freemarker.wrapper.altMap" value="true" />

  	<!--该属性指定XSLT Result是否使用样式表缓存.当应用处于开发阶段时,该属性通常被设置为true;当应用处于产品使用阶段时,该属性通常被设置为false. -->
  	<constant name="struts.xslt.nocache" value="false" />

  	<!--该属性指定Struts 2框架默认加载的配置文件,如果需要指定默认加载多个配置文件,则多个配置文件的文件名之间以英文逗号(,)隔开.该属性的默认值为struts-default.xml,struts-plugin.xml,struts.xml,看到该属性值,所以应该明白为什么Struts 
  		2框架默认加载struts.xml文件了. -->
  	<constant name="struts.configuration.files" value="struts-default.xml,struts-plugin.xml" />

  	<!--设置映射器是否总是选择完整的名称空间。该属性的默认值时false。 -->
  	<constant name="struts.mapper.alwaysSelectFullNamespace"
  		value="false" />

  	<!--设置Convention插件定位视图资源的根路径。默认值为/WEB-INF/content -->
  	<constant name="struts.convention.result.path" value="/WEB-INF/content/" />

  	<!--Convention插件以该常量指定包作为根包 -->
  	<constant name="struts.convention.action.package" value="default" />

  	<!--是否从包中搜索Action -->
  	<constant name="struts.convention.action.disableScanning"
  		value="false" />

  	<!-- 官方只说明在jboss下需要设置，情况不明 -->
  	<constant name="struts.convention.exclude.parentClassLoader"
  		value="true" />
  	<constant name="struts.convention.action.fileProtocols" value="jar,zip" />

  	<!--包括哪些jar包中的action。逗号分割字符串。 -->
  	<constant name="struts.convention.action.includeJars" value=".*?/_wl_cls_gen.*?jar(!/)?" />

  	<!--确定搜索包的路径。只要是结尾为action的包都要搜索。 -->
  	<constant name="struts.convention.package.locators" value="action" />

  </struts>
  ```

#### Struts2常量配置

- 除了可以在Struts.xml中配置常量信息外，还可以单独建立一个struts.properties文件，以key,value方式来存储常量信息。

- 系统会自动扫描struts.properties文件，不需要手动加载。

- 在src目录下新建struts.properties

  ```properties
  struts.ui.theme=simple
  ```

- struts2加载常量的顺序，后面的会覆盖掉前面的常量，最好在struts.xml中定义

  1. struts-default.xml
  2. struts-plugin.xml
  3. struts.xml
  4. struts.properties
  5. web.xml

#### Struts2配置文件 package

**package元素**

- 包的作用：简化维护工作，提高重用性
- 包可以“继承”已定义的包，并可以添加自己包的配置

**package属性**

- name：为必需的且是唯一的，用于指定包的名称

- extends：指定要继承的包，会继承包中的配置

  ```xml
  <struts>
    	<constant name="" value=""/>
  	<package name="default" namespace="/" extends="struts-default">
  		<action name="" class="">
  			<result name=""></result>			
  		</action>
  	</package>
  </struts>
  ```

**namespace**

- 每定义一个package，都可以指定一个namespace属性，用于指定该包的命名空间。Struts2通过命名空间方式来管理Action，同一个命名空间下不能有重名的Action。
- struts2不支持单个包指定命名空间，必须在package中指定，则该包下的所有Action都处于这个命名空间下。
- 命名空间只是一个级别，如果请求的URL是/admin/search/user，系统将在/admin/search命名空间下查找名为user的action，如果找到，则由该action处理请求；如果找不到，系统将会进入默认命名空间/查找名为user的action。

**struts-default.xml**

- Struts 2默认抽象包，这个包定义了struts2的基础配置，用压缩包打开struts2-core-2.x.x.jar，里面可以看到struts-default包，该包下面定义了大量的系统对象，类型定义、拦截器定义、拦截器引用定义等等，package必须要继承该包。`struts-default包在struts-default.xml文件中定义`
- 默认情况下，package都必须继承struts-default父包，这个包定义了struts的必须配置。用压缩包打开struts2-core-2.x.x.jar，里面可以看到struts-default抽象包，该包下面定义了大量的类型定义、拦截器定义、拦截器引用定义等等，这些都是配置普通的Action的基础。

**struts-plugin.xml**

- Struts2插件使用的配置文件，加载顺序：
  1. struts-default.xml
  2. struts-plugin.xml
  3. struts.xml
- Struts2插件文件都会提供一个struts-plugin.xml文件。


![20180102153126](http://www.znsd.com/znsd/courses/uploads/57c950e7096ce4883dcae0824dfa4f37/20180102153126.png)



### Struts2 Action

Action的作用：

- MVC中的控制器
- 封装处理单元
- 获取视图提交的数据

```java
public class HelloWorldAction implements Action {	
	  private String name = "";
	  private String message = "";	
	  public String execute() {
		  this.setMessage("Hello,"+this.getName()+"！");
		  return SUCCESS;
	  }
	  //...省略setter/getter方法 
}
```

`注意：如果配置文件中Action不指定class，则默认会指向ActionSupport，如果不指定method，默认会指向execute()方法。`

### Struts2 配置中的action

配置Action：

- 作用：

  action节点只是配置逻辑视图和物理视图之间的对应关系。

- 属性：

  - name：action名称，也是请求的URL
  - class：对应的action类，不是必须的，默认指向ActionSupport类。
  - method：指定要访问的action方法，默认为execute()
  - converter：指定的类型转换器

  ```xml
  <package name="default" namespace="/" extends="struts-default">
  	<action name="login" class="com.znsd.struts.action.LoginAction">
  		<result name="success">success.jsp</result>
         	<result name="input">login.jsp</result>
  		<result name="error">fail.jsp</result>
  	</action>
  </package>
  ```

- 在Struts 2中，核心控制器是Filter，Action是属于业务控制器，二者是有区别的。编写Action有两种方式，一种是实现Action接口，一种是继承ActionSupport类，但是通常都会使用集成ActionSupport类的方式来实现

#### method属性

- 好处：method属性可以实现Action中不同方法的调用

- 特点

  1. 避免动态方法调用的安全隐患
  2. 导致大量的Action配置

  ```xml
  <action name="login" class="com.znsd.struts.action.LoginAction" method="login">
  	<result name="success">success.jsp</result>
  	<result name="error">fail.jsp</result>
  </action>
  		
  <action name="register" class="com.znsd.struts.action.LoginAction" method="register">
  	<result name="success">success.jsp</result>
  	<result name="error">fail.jsp</result>
  </action>
  ```

#### 通配符映射

- 一个Web应用可能有成百上千个action声明，可以利用Struts2的通配符机制将多个相似的action简化为一个。
- 通配符规则：
  - 若存在多个匹配的Action，则精确匹配的优先级较高。
  - 若指定的Action不存在，则会尝试将这个uri和任何一个包含*的Action进行匹配。
  - *：表示uri中的占位符，可以匹配任意多个字符。
  - {n}：指定匹配的变量，{1}表示第一个，{2}第二个，依次类推。
  - {0}：表示匹配整个uri。
  - 如果匹配多个模糊的Action，则会按照先后顺序进行匹配。
  - 不能包含/字符，如果想把/字符包括在内，则需要使用**。
  - 如果需要对某个字符进行转义，使用"\";

#### Struts2 配置中的动态action

**通配符(*)的使用**

另一种形式的动态方法调用，{1}表示匹配的第一个*，{2}第二个*，一次类推。

```xml
<action name="*User" class="com.znsd.struts.action.UserAction" method="{1}">
	<result name="success">/page/user/{1}_success.jsp</result>
  	<result name="input">/page/user/{1}.jsp</result>
</action>
```

分析一： /addUser.action

```xml
<action name="addUser" class="com.znsd.struts.action.UserAction" method="add">
	<result name="success">/page/user/add_success.jsp</result>
  	<result name="input">/page/user/add.jsp</result>
</action>
```

分析二：/deleteUser.action

```xml
<action name="deleteUser" class="com.znsd.struts.action.UserAction" method="delete">
	<result name="success">/page/user/delete_success.jsp</result>
  	<result name="input">/page/user/delete.jsp</result>
</action>
```

`当有多个action匹配时，将按照先后顺序来决定由哪个action来处理请求。`

**动态方法调用**

- 作用：减少Action数量

- 使用：actionName!methodName.action 

- 禁用：将属性struts.enable.DynamicMethodInvocation设置为false

- 例子：

  1. 配置struts.xml文件

     ```xml
     <!-- struts.enable.DynamicMethodInvocation常量设置为true,这种方式才能使用 -->
     <constant name="struts.enable.DynamicMethodInvocation" value="true" />
     ```

  2. 配置action

     ```xml
     <action name="user" class="com.znsd.struts.action.UserAction">
       	<result name="success">success.jsp</result>
       	<result name="input">login.jsp</result>
     </action>
     ```

  3. 访问

     如果访问的是/user!add.action那么`user`是action的名字，`add`是action中的方法

`注意：官网不推荐使用这种方式,建议大家不要使用`

#### Struts2 配置中的action

- 配置默认Action

  - 没有Action匹配请求时，默认Action将被执行

  - 通过<default-action-ref />元素配置默认Action

    ```xml
    <package name="default" namespace="/" extends="struts-default">
      	<!-- 必须要放在package节点下的第一个元素 -->
      	<default-action-ref name="defaultAction"></default-action-ref>
    	<action name="defaultAction"> <!-- 省略class属性，将使用ActionSupport类 -->
           	<!-- 如果请求的Action不存在，页面跳转到index.jsp -->
    		<result>index.jsp</result>
    	</action>
    </package>
    ```

#### Struts2配置文件result

result的作用是调度视图以哪种形式体现给客户端(Action处理结束后，系统下一步将要做什么)，name的名称是对应Action中返回的逻辑名，而result则是对应工程中具体的资源的位置，这一点必须清楚。

**result**

- 实现对将逻辑视图关联到逻辑视图
- result元素的值指定对应的实际视图位置

**result属性**

- name：表示result逻辑视图名，默认的名称success
- type：表示result类型

#### Result的type属性

- result的type在struts-default.xml中定义的，可以查看struts-default.xml来查看支持哪些type属性。

  ```xml
  <result-types>
        <result-type name="chain" class="com.opensymphony.xwork2.ActionChainResult"/>
        <result-type name="dispatcher" class="org.apache.struts2.dispatcher.ServletDispatcherResult" default="true"/>
        <result-type name="freemarker" class="org.apache.struts2.views.freemarker.FreemarkerResult"/>
        <result-type name="httpheader" class="org.apache.struts2.dispatcher.HttpHeaderResult"/>
        <result-type name="redirect" class="org.apache.struts2.dispatcher.ServletRedirectResult"/>
        <result-type name="redirectAction" class="org.apache.struts2.dispatcher.ServletActionRedirectResult"/>
        <result-type name="stream" class="org.apache.struts2.dispatcher.StreamResult"/>
        <result-type name="velocity" class="org.apache.struts2.dispatcher.VelocityResult"/>
        <result-type name="xslt" class="org.apache.struts2.views.xslt.XSLTResult"/>
        <result-type name="plainText" class="org.apache.struts2.dispatcher.PlainTextResult" />
        <result-type name="postback" class="org.apache.struts2.dispatcher.PostbackResult" />
  </result-types>
  ```

| 名称             | 说明                         |
| -------------- | -------------------------- |
| chain          | Action链式处理结果类型             |
| dispatcher     | 用于指定JSP作为视图结果类型（默认）        |
| freemarker     | 用来指定使用freemarker模板作为视图结果类型 |
| httpheader     | 用户控制特殊的HTTP兴围的结果类型         |
| redirect       | 用于重定向到其它URL的结果类型           |
| redirectAction | 用于重定向到其它Action的结果类型        |
| stream         | 用于向浏览器返回一个InputStream的结果类型 |
| velocity       | 用于指定使用Velocity模版作为视图结果类型   |
| xslt           | 用于返回XML/XSLT整合的结果类型        |
| plaintext      | 用于显示某个页面的原始代码的结果类型         |

  - dispatcher：请求转发，底层调用RequestDispatcher的forward()或include()方法，dispatcher是 type属性的默认值，通常用于转向一个JSP。localtion指定JSP的位置。
  - redirect：重定向，新页面无法显示Action中的数据，因为底层调用response.sendRedirect("")方法，无法共享请求范围内的数据。参数与dispatcher用法相同。
  - redirect-action：重定向到另一个Action，参数与chain用法相同，允许将原Action中的属性指定新名称带入新Action 中，可以在Result标签中添加 <param name="b">${a} </param>，这表示原Action中的变量a的值被转给b，下一个Action可以在值栈中使用b来操作，注意如果值是中文，需要做一些编码处理，因为Tomcat默认是不支持URL直接传递中文的！
  - velocity：使用velocity模板输出结果，location指定模板的位置（*.vm）
  - xslt：使用XSLT将结果转换为xml输出。location指定*.xslt文件的位置，matchingPattern指定想要的元素模式，excludePattern指定拒绝的元素模式，支持正则表达式，默认为接受所有元素。
  - httpheader：根据值栈返回自定义的HttpHeader。status指定响应状态（就是指response.sendError(int i)重定向到500等服务器的状态页）。headers，加入到header中的值，例如： <paramname="headers.a">HelloWorld</param>。可以加多个，这些键-值组成HashMap。
  - freemaker：用freemaker模板引擎呈现视图。location指定模板（*.ftl）的位置。contentType指定以何中类型解析，默认为text/html。
  - chain：将action的带着原来的状态请求转发到新的action，两个action共享一个ActionContext。actionName指定转向的新的Action的名字。method指定转向哪个方法，namespace指定新的Action的名称空间，不写表示与原Action在相同的名称空间；skipActions指定一个使用 , 连接的Action的name组成的集合，一般不建议使用这种类型的结果。
  - stream：直接向响应中发送原始数据，通常在用户下载时使用。contentType指定流的类型，默认为 text/plain。contentLength以byte计算流的长度contentDisposition指定文件的位置，通常为filename=”文件的位置”input指定InputStream的名字，例如：imageStream，bufferSize指定缓冲区大小，默认为1024字节。

  - plaintext：以原始文本显示JSP或者HTML。location指定文件的位置charSet指定字符集。

#### Result的子元素

result还可以指定多个param子元素，每个param代表一个参数，<param />的参数名有name属性指定。

```xml
<action name="login" class="com.znsd.struts.action.LoginAction" method="login">
      <!-- 重定向到success.jsp -->
      <result name="success" type="redirect">success.jsp</result>

      <!--转发到success.jsp(默认值)-->
      <result name="input" type="dispatcher">login.jsp</result>

      <!-- 结果为"error"时，跳转至fail.jsp页面 -->
      <result name="error">fail.jsp</result>

      <!-- 重定向到另一个Action-->
      <result name="testRedirectAction" type="redirectAction">
        <param name="actionName">fail</param>
        <param name="namespace">/</param>
      </result>

      <!--转发到/fail.action页面-->
      <result name="testChain" type="chain">
        <param name="actionName">fail</param>
        <param name="namespace">/</param>
      </result>
</action>
```

#### Result配置动态Action

动态结果：配置时不知道执行后的结果是哪一个，运行时才知道哪个结果作为视图显示给用户

```java
public class DynamicResultAction extends ActionSupport {

	private static final long serialVersionUID = 1L;

	private String nextDispose;
	private String username;

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getNextDispose() {
		return nextDispose;
	}

	public void setNextDispose(String nextDispose) {
		this.nextDispose = nextDispose;
	}

	public String login() {
		if ("1".equals(this.username)) {
			nextDispose = "manage";
		} else {
			nextDispose = "common";
		}
		return "success";
	}
}
```

```xml
<package name="default" namespace="/" extends="struts-default">
	<action name="dynamicResult" class="com.znsd.struts.action.DynamicResultAction" method="login">
      	<!-- ${nextDispose}表示调用Action中的getNextDispose方法，获取下一个处理页面的信息 -->
    	<result type="redirectAction">${nextDispose}</result>
    </action>
    <action name="manage" class="com.znsd.struts.action.MangeAction">
        <result>successManage.jsp</result>
    </action>
    <action name="common" class="com.znsd.struts.action.CommonAction">
        <result>successCommon.jsp</result>
    </action>
</package>
```

#### 全局结果

全局结果可以实现同一个包中多个action共享一个结果

```xml
<package name="default" namespace="/" extends="struts-default">
  	<!-- 全局结果位于package元素内 -->
	<global-results>
		<result name="globalError">globalError.jsp</result>
		<result name="globalSuccess">globalSuccess.jsp</result>
	</global-results>
  
  	<action name="global" class="com.znsd.struts.action.GlobalAction">
      	<!-- 就近原则，如果配置了局部的result就用局部的，没有配置就用全局的 -->
		<result name="globalError">privateError.jsp</result>
	</action>
</package>
```



### 异常处理

#### 传统的异常处理

传统的Web页面捕获异常处理

```java
try{
    //异常代码
}catch(XxxException e1){
    forward("/error.jsp");
}catch(XxxException e2){
    forward("/error.jsp");
}……
```

#### Struts的异常处理

- 异常处理
  - 在Action中，我们不需要处理异常，可以直接抛出交由Struts2来处理。
  - Struts2中的异常通过<exception-mapping />来完成。
- 属性：
  - exception：所需要捕获的异常类型
  - result：出现异常时，系统所返回的异常处理的视图。
- 位置：
  - 全局异常处理：作为<global-exception-mappings>元素的子元素配置。
  - 局部异常处理：作为<action>元素的子元素配置。

```xml
<package name="default" namespace="/" extends="struts-default">
  	<global-results>
			<result name="globalError">globalError.jsp</result>
			<result name="globalSuccess">globalSuccess.jsp</result>
	</global-results>
	<!-- 全局方式 -->
	<global-exception-mappings>
		<exception-mapping result="globalError" exception="java.lang.Exception"></exception-mapping>
	</global-exception-mappings>
  	<action name="testException" class="com.znsd.struts.action.ExceptionAaction">
		<!-- 局部方式-->
		<exception-mapping result="privateError" exception="java.lang.NullPointerException"></exception-mapping>
		<exception-mapping result="classCastError" exception="java.lang.ClassCastException"></exception-mapping>
	</action>
</package>
```

跳转到指定的异常jsp可以通过\<s:property>标签来获取

```html
<s:property value="exceptionStack"/>      
<s:property value="exception.message"/>
```

### include模块化配置文件

如果将所有的action都配置在一个struts.xml中，那么会显得非常臃肿，非常不适合维护。可以将action分布到多个xml文件中，然后通过include标签引入到struts.xml核心配置文件中。

- 在struts.xml文件中加入<include file="struts-student.xml"></include>标签

```xml
<struts>
	<package name="default" namespace="/" extends="struts-default">		
	</package>
	
	<include file="struts-student.xml"></include>
</struts>
```

- 新建struts-student.xml文件

```xml
<struts>
	<package name="default" namespace="/student" extends="struts-default">
		<action name="add" class="com.znsd.struts.action.StudentAction">
			<result>/success.jsp</result>
		</action>
	</package>
</struts>
```



### 总结

- struts.xml文件是Struts2的核心配置文件
- Struts的常量
- Package配置
- Action配置
- Result的结果类型
- 异常处理
- 模块化配置文件