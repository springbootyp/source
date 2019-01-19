## 第六章  拦截器、上传、下载与Ajax

### 本章目标

- 掌握Struts2架构
- 掌握Struts2拦截器`重点`
- 掌握Struts2权限验证
- 掌握Struts2框架的文件上传和下载`重点（难点）`
- 掌握Struts2中实现Ajax

### Struts2架构剖析 

拦截器体系是Struts2的重要组成部分，我们可以将Struts2想象为一个空壳，而大量的拦截器完成了该框架的大部分工作。例如：

- 参数封装
- 类型转换
- 输入效验
- 异常处理
- 文件上传
- 等等……

![struts2](http://www.znsd.com/znsd/courses/uploads/789914ea11a05e21d2b67effbd152ed6/2011082712263217.png)

1. 客户端向Servlet容器（如Tomcat）提交一个请求
2. 请求经过一系列过滤器（如ActionContextCleanUp过滤器等）
3. 核心控制器被调用，询问ActionMapper来决定请求是否需要调用某个Action
4. 如果ActionMapper决定需要调用某个Action，核心控制器把控制权委派给ActionProxy（备注：JSP请求无需调用Action）
5. ActionProxy通过Configuration Manager询问框架的配置文件（struts.xml），找到需调用的Action类
6. ActionProxy创建一个ActionInvocation的实例
7. ActionInvocation负责调用Action，在此之前会依次调用所有配置的拦截器
8. Action执行完毕，ActionInvocation负责根据结果码字符串在struts.xml的配置中找到对应的返回结果
9. 拦截器被再次执行
10. 过滤器被再次执行

### Struts  2核心接口和类

| 名称               | 作用                               |
| ---------------- | -------------------------------- |
| ActionMapper     | 根据请求的URI查找是否存在对应Action调用         |
| ActionMapping    | 保存调用Action的映射信息，如namespace、name等 |
| ActionProxy      | 在XWork和真正的Action之间充当代理           |
| ActionInvocation | 表示Action的执行状态，保存拦截器、Action实例     |
| Interceptor      | 在请求处理之前或者之后执行的Struts 2组件         |

### Struts执行流程简图

![20180108101146](http://www.znsd.com/znsd/courses/uploads/5b710f8de045e3f49786a395e4f3d0f6/20180108101146.png)

### 为什么需要拦截器

- 早期MVC框架将一些通用操作写死在核心控制器中，致使框架灵活性不足、可扩展性降低 
- Struts 2将核心功能放到多个拦截器中实现，拦截器可自由选择和组合，增强了灵活性，有利于系统的解耦。

### 什么是拦截器

拦截器，在AOP（Aspect-Oriented Programming）中用于在某个方法或字段被访问之前，进行拦截然后在之前或之后加入某些操作。拦截是AOP的一种实现策略。在Webwork的中文文档的解释为——拦截器是动态拦截Action调用的对象。它提供了一种机制可以使开发者可以定义在一个action执行的前后执行的代码，也可以在一个action执行前阻止其执行。同时也是提供了一种可以提取action中可重用的部分的方式。

拦截器链（Interceptor Chain，在Struts 2中称为拦截器栈Interceptor Stack）。拦截器链就是将拦截器按一定的顺序联结成一条链。在访问被拦截的方法或字段时，拦截器链中的拦截器就会按其之前定义的顺序被调用。

- Struts 2大多数核心功能是通过拦截器实现的，每个拦截器完成某项功能
- 拦截器方法在Action执行之前或者之后执行
- 拦截器栈
  - 从结构上看，拦截器栈相当于多个拦截器的组合
  - 在功能上看，拦截器栈也是拦截器 
- 拦截器与过滤器原理很相似

### Struts 2自带拦截器 

- params拦截器：负责将请求参数设置为Action属性
- servletConfig拦截器 ：将源于Servlet API的各种对象注入到Action
- fileUpload拦截器：对文件上传提供支持
- exception拦截器：捕获异常，并且将异常映射到用户自定义的错误页面
- validation拦截器 ：调用验证框架进行数据验证
- workflow拦截器：调用Action类的validate()，执行数据验证

### 拦截器工作原理

Struts 2的拦截器实现相对简单。当请求到达Struts 2的ServletDispatcher时，Struts 2会查找配置文件，并根据其配置实例化相对的拦截器对象，然后串成一个列表（list），最后一个一个地调用列表中的拦截器，如图1所示。

![image](http://www.znsd.com/znsd/courses/uploads/a244a8e41046618c6e11c8a2ffb3cbda/image.png)

- 三阶段执行周期：
  1. 做一些Action执行前的预处理
  2. 将控制交给后续拦截器或返回结果字符串
  3. 做一些Action执行后的处理

### 拦截器中的标签

查看struts-default.xml中可以查看拦截器配置信息。

```xml
<!--拦截器根节点-->
<interceptors>
    <!--定义拦截器-->
    <interceptor name="拦截器名" class="拦截器类"/>
    <!--定义拦截器栈-->
    <interceptor-stack name="拦截器栈">
          <!--拦截器栈中引用的拦截器-->
          <interceptor-ref name="引用的拦截器名"/>
    </interceptor-stack>
</interceptors>
<!--设置默认拦截器-->
<default-interceptor-ref name="拦截器栈名"/>

```

### Struts2默认拦截器栈 

- struts-default.xml中定义一个defaultStack拦截器栈，并将其指定为默认拦截器
- 只要在定义包的过程中继承struts-default包，那么defaultStack将是默认的拦截器。
- 默认情况下，当Action中没有指定拦截器时，默认拦截器将会起作用，如果手动指定了拦截器，那么默认拦截器将会失效（和构造方法类似），必须手动添加默认拦截器。

### 为什么要开发自定义拦截器

- 拦截器相当于JSP中的Filter，都是对请求的数据进行处理。
- 拦截器是独立于Action单独执行的，所以当我们需要开发需要跨多个Action的一些通用代码时，就可以使用拦截器来实现。
- 例如：日志记录，权限等。

### 自定义拦截器

1. 实现Interceptor接口

   - void init()：初始化拦截器所需资源

   - void destroy()：释放在init()中分配的资源

   - String intercept(ActionInvocation ai) throws Exception

     实现拦截器功能，利用ActionInvocation参数获取Action状态，返回结果码（result）字符串。

2. 继承AbstractInterceptor类（`推荐使用`）

   - 提供了init()和destroy()方法的空实现
   - 只需要实现intercept方法即可

### 拦截器简单应用

实现一个拦截器时可以实现Interceptor接口或者继承AbstractInterceptor类，AbstractInterceptor类是Interceptor接口的实现类，类似于ActionSupport类和Action接口的关系。一般情况下只需要继承AbstractInterceptor类然后重写其中的intercept()方法。

- 拦截器示例

  ```java
  public class TestInterceptor implements Interceptor { // 实现Interceptor接口

  	private static final long serialVersionUID = 1L;

  	@Override
  	public void destroy() {
  		System.out.println("TestInterceptor.destroy()");
  	}

  	@Override
  	public void init() {
  		System.out.println("TestInterceptor.init()");
  	}

  	// 重写intercept()
  	@Override
  	public String intercept(ActionInvocation invocation) throws Exception {
  		// 预处理工作
  		long startTime = System.currentTimeMillis();
  		System.err.println("拦截器执行前");
  		
  		// 执行后续拦截器或Action
  		String result = invocation.invoke(); // 执行Action操作
  		
  		// 后续处理工作
  		System.err.println("拦截器执行后");
  		long endTime = System.currentTimeMillis();
  		
  		System.out.println("拦截器执行耗时：" + (endTime - startTime));
  		
  		//返回结果字符串
  		return result;
  	}
  }
  ```

- 拦截器的简单配置

  ```xml
  <package name="default" namespace="/" extends="struts-default">
  		<!-- 定义拦截器 -->
  		<interceptors>
  			<!-- 定义单个拦截器 -->
  			<interceptor name="test" class="com.znsd.struts.interceptor.TestInterceptor"></interceptor>
  		</interceptors>
  		
  		<action name="test" class="com.znsd.struts.action.TestAction">
  			<result>success.jsp</result>
  			<result name="input">register.jsp</result>
  			<!-- 引用拦截器 -->
  			<interceptor-ref name="test"></interceptor-ref>
  			<!-- 当添加自定义拦截器以后，必须再配置defaultStack拦截器栈。 -->
  			<interceptor-ref name="defaultStack"></interceptor-ref>
  		</action>
  </package>
  ```

  拦截器的配置需要使用的元素标签\<interceptors>和\<interceptor>，interceptors可以同时配置多个拦截器，interceptor指定一个拦截器的配置，name属性是拦截器的名称，class是拦截器的包名加类名，配置后之后再与Action实现关联。

- 配置多个拦截器

  配置语法

  ```xml
  <package name="packName" extends="struts-default" namespace="/manage">
  	<interceptors>
  		<!-- 定义拦截器 -->
  		<interceptor name="interceptorName" class="interceptorClass" />
  		<!-- 定义拦截器栈 -->
  		<interceptor-stack name="interceptorStackName">
  			<!--指定引用的拦截器-->
  			<interceptor-ref name="interceptorName|interceptorStackName" />
  		</interceptor-stack>
  	</interceptors>
  	<!--定义默认的拦截器引用-->
  	<default-interceptor-ref name="interceptorName|interceptorStackName" />
  	<action name="actionName" class="actionClass">
  	  <!--为Action指定拦截器引用-->
  		<interceptor-ref name="interceptorName|interceptorStackName" />
  		<!--省略其他配置-->
  	</action>
  </package>

  ```

  配置实例

  ```xml
  <package name="default" namespace="/" extends="struts-default">
  	<!-- 定义拦截器 -->
  	<interceptors>
  		<!-- 定义单个拦截器 -->
  		<interceptor name="test" class="com.znsd.struts.interceptor.TestInterceptor"></interceptor>
  		<interceptor name="test1" class="com.znsd.struts.interceptor.TestInterceptor"></interceptor>		
  		<interceptor-stack name="testInterceptorStack">
  			<interceptor-ref name="test"></interceptor-ref>
  			<interceptor-ref name="test1"></interceptor-ref>
  		</interceptor-stack>
  	</interceptors>	
  	<action name="test" class="com.znsd.struts.action.TestAction">
  		<result>success.jsp</result>
  		<result name="input">register.jsp</result>
  		<!-- 引用拦截器 -->
  		<interceptor-ref name="testInterceptorStack"></interceptor-ref>
  		<!-- 当添加自定义拦截器以后，必须再配置defaultStack拦截器栈。 -->
  		<interceptor-ref name="defaultStack"></interceptor-ref>
  	</action>
  </package>
  ```

  ​

### 判断用户是否登录

- 权限验证拦截器

  ```java
  public class AuthorizationInterceptor extends AbstractInterceptor {

  	private static final long serialVersionUID = -2267354848421466058L;

  	@Override
  	public String intercept(ActionInvocation invocation) throws Exception {
  		Map<String, Object> sessionMap = invocation.getInvocationContext().getSession();
  		User user = (User) sessionMap.get("session_user");
  		if (user == null) {
  			return "login";
  		}
  		return invocation.invoke();
  	}
  }
  ```

  ​

- 在配置文件中定义拦截器并引用它

  ```xml
  <package name="default" namespace="/" extends="struts-default">
  	<interceptors>
  		<!-- 定义验证拦截器 -->
  		<interceptor name="authorization" class="com.znsd.struts.interceptor.AuthorizationInterceptor"></interceptor>
  				
  		<!--定义拦截器栈-->
  		<interceptor-stack name="myInterceptorStack">
  			<interceptor-ref name="defaultStack"></interceptor-ref>
  			<interceptor-ref name="authorization"></interceptor-ref>
  		</interceptor-stack>
  	</interceptors>
  	<!-- 定义默认拦截器  -->
  	<!-- 因为包含在默认拦截器内，所以Action中无需再引用权限拦截器 -->
  	<default-interceptor-ref name="myInterceptorStack"></default-interceptor-ref>
  </package>
  ```

- 添加了权限验证拦截器后，发现提交的login.action也无法访问了。

### 添加拦截器参数

- 对权限拦截器提供允许访问的Action，提供一个参数AllowAction。

  ```xml
  <interceptors>
    	<!-- 定义验证拦截器 -->
    	<interceptor name="authorization" class="com.znsd.struts.interceptor.AuthorizationInterceptor"></interceptor>

    	<!--定义拦截器栈-->
    	<interceptor-stack name="myInterceptorStack">
      	<interceptor-ref name="defaultStack"></interceptor-ref>
      	<interceptor-ref name="authorization">
            	<!-- 添加允许访问的action -->
        		<param name="allowAction">doLogin</param>
      	</interceptor-ref>
    	</interceptor-stack>
  </interceptors>
  ```

  ​

- 在拦截器中提供一个属性allowAction，并提供getter和setter方法

  ```java
  	private String allowAction;
  
  	public String getAllowAction() {
  		return allowAction;
  	}
  
  	public void setAllowAction(String allowAction) {
  		this.allowAction = allowAction;
  	}
  
  	@Override
  	public String intercept(ActionInvocation invocation) throws Exception {
  		//获取了用户所要访问的路径,即在struts.xml中设置的action的name
  		String actionName = invocation.getProxy().getActionName();
  		if (allowAction != null && allowAction.equals(actionName)) {
  			return invocation.invoke();
  		}
  		
  		Map<String, Object> sessionMap = invocation.getInvocationContext().getSession();
  		User user = (User) sessionMap.get("currentUser");
  
  		if (user == null) {
  			return "login";
  		}
  		return invocation.invoke();
  	}
  ```

### 学员操作

#### 实现用户权限的访问控制

- 需求说明：对用户登录添加权限控制，非登录用户不能访问信息管理页面
- 思路：
  - 编写拦截器，继承AbstractInterceptor类
  - 在struts.xml中配置拦截器
  - 在Action的配置中引用拦截器


### 文件的上传

- 文件上传，可以说是在项目中经常使用的功能。
- 回顾在JSP中如何实现文件上传
  - 将form表单的enctype="multipart/form-data"，表单会以二进制流的方式来提交。
  - 通过上传组件common-fileupload来获取文件上传的内容。

#### 文件上传组件

- Commons-FileUpload组件
  - Commons是Apache开放源代码组织的一个Java子项目，其中的FileUpload是用来处理HTTP文件上传的子项目。
  - Commons-IO：上传组件依赖的IO包。
- Commons-FileUpload组件特点
  - 使用简单：可以方便地嵌入到JSP文件中，编写少量代码即可完成文件的上传功能
  - 能够全程控制上传内容
  - 能够对上传文件的大小、类型进行控制

在Struts2中已经默认为我们内置好了commons-fileupload和commons-io组件，我们只需要编写代码即可。

#### 基于Struts 2的文件上传

Struts 2的文件上传实现步骤：

- 设置表单提交属性

  ```html
  <form enctype="multipart/form-data" method="post"></form>
  ```

- 编写文件上传处理Action

- 配置Action

`注意：`

- File类型的xxx属性，与表单中的File控件的name属性一致，用于封装File控件对应的文件内容
- String类型的xxxFileName属性，该属性名称就是前面的File类型属性+FileName组合而成，是固定的语法，作用就是封装File控件对应文件的文件名
- String类型的xxxContentType属性，同样也是xxx属性+ContentType组合而成，固定语法，作用就是封装File控件对应文件的文件类型
- 在Action中设置了这三个属性，在执行上传时就可以直接通过getXxx()方法来获取到上传文件的文件名、类型及文件内容。
- 而实现文件上传的过程就是使用流实现文件读取的过程，

```java
public class FileUploadAction extends ActionSupport {

	private static final long serialVersionUID = -6332824097024610665L;

	// 内置了一个File属性，命名：必须和文件域同名
	private File upload;
	// 内置了一个ContentType属性，命名：文件域名+ContentTYpe;
	private String uploadContentType;
	// 内置一个FIleName属性，命名：文件域名+FileName
	private String uploadFileName;

	public File getUpload() {
		return upload;
	}

	public void setUpload(File upload) {
		this.upload = upload;
	}

	public String getUploadContentType() {
		return uploadContentType;
	}

	public void setUploadContentType(String uploadContentType) {
		this.uploadContentType = uploadContentType;
	}

	public String getUploadFileName() {
		return uploadFileName;
	}

	public void setUploadFileName(String uploadFileName) {
		this.uploadFileName = uploadFileName;
	}

	@Override
	public String execute() throws Exception {
		FileInputStream ins = null;
		FileOutputStream ous = null;
		try {
			ins = new FileInputStream(getUpload());

			// 判断上传的文件夹是否存在，如果不存在则创建
			String uploadPath = ServletActionContext.getServletContext().getRealPath("/uploads/");
			File uploadFilePath = new File(uploadPath);
			if (!uploadFilePath.exists()) {
				uploadFilePath.mkdirs();
			}
			// 生成新的文件名
			String newFileName = System.currentTimeMillis() + uploadFileName.substring(getUploadFileName().lastIndexOf("."));

			ous = new FileOutputStream(uploadPath + File.separator + newFileName);
			byte[] buffer = new byte[1024];
			int length = 0;
			while ((length = ins.read(buffer)) > 0) {
				ous.write(buffer, 0, length);
			}
			// 设置输出文件名
			setUploadFileName(newFileName);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ins != null) {
				ins.close();
			}
			if (ous != null) {
				ous.close();
			}
		}
		return SUCCESS;
	}
}
```

```xml
<package name="default" namespace="/" extends="struts-default">
	<action name="upload" class="com.znsd.struts.action.FileUploadAction">
		<result name="success">success.jsp</result>
		<result name="input">fileupload.jsp</result>
	</action>
</package>
```

```html
<img src="${pageContext.request.contextPath}/<s:property value="'uploads/'+uploadFileName"/>">
```

#### 文件过滤

- 只允许上传指定类型的文件。

- 只允许上传指定大小的文件。

- 有两种限制方式：

  1. 手动编码方式

     ```java
     // 编写限制代码
     if (getUpload().length() > 100*1024) { // 如果大于100KB
       	addFieldError("upload", "上传的文件不能超过100KB");
       	return INPUT;
     }
     if (!allowType.contains(uploadContentType)) { //限制文件上传格式
       	addFieldError("upload", "只允许上传" + allowType + "类型文件");
       	return INPUT;
     }
     ```

     ```xml
     <!-- 在action中添加允许上传文件格式的参数 -->
     <action name="upload" class="com.znsd.struts.action.FileUploadAction">
     		<param name="allowType">text/html,text/xml</param>
     </action>
     ```

  2. 使用fileupload拦截器参数实现

   - maximumSize：指定上传文件大小，单位字节，默认大小为2MB。
   - allowedTypes：指定上传文件的类型，多个类型用,隔开。
   - allowedExtensions：允许上传的文件扩展名，多个使用,隔开。

     ```xml
     <interceptors>
       	<interceptor-stack name="znsdStack">
         	<interceptor-ref name="defaultStack">
           		<param name="fileUpload.maximumSize">2097152</param>
           		<param name="fileUpload.allowedTypes">text/html,text/xml</param>
           		<param name="fileUpload.allowedExtensions">html,dtd</param>
         </interceptor-ref>
       </interceptor-stack>
     </interceptors>
     <default-interceptor-ref name="znsdStack"></default-interceptor-ref>
     ```

- 上传出错后会返回一个input逻辑视图，设置result返回的页面。

`在Struts2中有对于上传文件大小的总量的限制，如果总大小超出，直接抛出actionerror。可以通过常亮struts.multipart.maxSize来设置。`

#### contentType类型设置

contentType类型设置可以指定文件下载的类型

| 文件类型   | 类型设置                             |
| ------ | -------------------------------- |
| Word   | application/msword               |
| Execl  | application/vnd.ms-excel         |
| PPT    | application/vnd.ms-powerpoint    |
| 图片     | image/gif ， image/bmp，image/jpeg |
| 文本文件   | text/plain                       |
| html网页 | text/html                        |
| 可执行文件  | application/octet-stream         |

#### 错误提示（国际化）

- Struts默认的提示信息是英文的，如果需要可以通过国际化配置来更改错误提示信息。
- 具体配置可以参考org.apche.struts2下的struts-messages.properties文件中的配置。

#### 多文件上传

- 表单设置：多个File控件name属性相同

  ```html
  <s:form action="multipleUpload.action" method="post" enctype="multipart/form-data">
        <s:file name="upload" label="请选择文件"></s:file>
        <s:file name="upload" label="请选择文件"></s:file>
        <s:file name="upload" label="请选择文件"></s:file>
        <s:submit value="上传"></s:submit>
  </s:form>
  ```

- Action的修改：将三个属性的类型修改成数组类型

  ```java
  // 内置了一个File属性，命名：必须和文件域同名
  private File[] upload;
  // 内置了一个ContentType属性，命名：文件域名+ContentTYpe;
  private String[] uploadContentType;
  // 内置一个FIleName属性，命名：文件域名+FileName
  private String[] uploadFileName;
  ```

多个文件上传，本质就是将控件以集合形式保存，然后通过循环实现文件的上传。另外，在页面中上传控件的名称也可以不相同，但是这就需要在Action中定义多个属性，所以使用数组方式比较简便，这也是一种经验体现

### 学员操作

#### 实现单个文件上传

- 需求说明：允许上传个人图片
- 分析思路：
  - 设置表单属性
  - 编写Action，Action属性的命名与File控件的名称要一致
  - 配置Action

#### 实现多个文件上传

- 需求说明：模仿教学示例，实现多个文件的上传功能
- 分析思路：
  - 将File控件设置相同名称
  - Action的属性设置为数组类型
  - 使用循环实现文件上传

### 文件下载

- 如果直接访问下载文件路径虽然可以下载文件，但是会存在以下问题。
  1. 文件名为中文的问题。
  2. 安全性差，无法进行权限控制。

#### 文件下载功能实现

- 图片中的下载效果该如何实现

  ![20180108172256](http://www.znsd.com/znsd/courses/uploads/cb76fcb4190ee52eae8ab4351e473da0/20180108172256.png)

- 实现步骤

  1. 编写下载文件Action获取InputStream输入流

     ```java
     public class FileDownloadAction extends ActionSupport {

     	private static final long serialVersionUID = 1L;

     	// 读取下载的目录
     	private String inputPath;
     	// 下载的文件名
     	private String fileName;
     	// 文件类型
     	private String contentType;

     	public String getInputPath() {
     		return inputPath;
     	}

     	public void setInputPath(String inputPath) {
     		this.inputPath = inputPath;
     	}

     	public String getFileName() {
     		return fileName;
     	}

     	public void setFileName(String fileName) {
     		this.fileName = fileName;
     	}

     	public String getContentType() {
     		return contentType;
     	}

     	public void setContentType(String contentType) {
     		this.contentType = contentType;
     	}

     	@Override
     	public String execute() throws Exception {
     		System.out.println("FileDownloadAction.execute()");
     		contentType = "image/jpeg";
     		fileName = "1515401779929.png";
     		return SUCCESS;
     	}
     	
         // 文件下载的方法
     	public InputStream getInputStream() throws FileNotFoundException {
     		String path = ServletActionContext.getServletContext().getRealPath(inputPath);
     		return new BufferedInputStream(new FileInputStream(path + File.separator + fileName));
     	}
     }
     ```

     ​

  2. 配置Action指定下载文件的类型、下载形式等

     ```xml
     <action name="download" class="com.znsd.struts.action.FileDownloadAction">
     	<param name="inputPath">/uploads</param>
     	<!-- 指定类型为stream -->
     	<result name="success" type="stream">
             <!-- 下载的文件类型 -->
             <param name="contentType">${contentType}</param>

             <!-- 文件下载的方法，去掉get，首字母小写 -->
             <param name="inputName">inputStream</param>

             <!-- Attachement表示以附件形式下载Filename表示下载时显示的文件名称 -->
             <param name="contentDisposition">
               attachment;filename="${fileName}"
             </param>

             <!-- 文件缓冲区大小 -->
             <param name="bufferSize">4096</param>
     	</result>
     </action>
     ```

  3. 文件下载页面

     ```html
     <a href="test/中文路径.zip">中文路径.zip</a>
     <a href="download.action">文件下载</a>
     ```

     ​

- 在Struts 2中使用该组件时，同样需要使用到commons-fileupload-x.x.x..jar和commons-io-x.x.x..jar两个文件，至于版本，则取决于Struts 2使用版本。而获取的方式依然是从相应的网址上直接进行下载，并且可以下载相应的API文档。

#### stream结果类型

stream结果类型

- 将文件数据（通过InputStream获取）直接写入响应流
- 相关参数的配置

| 名称                 | 作用                                    |
| ------------------ | ------------------------------------- |
| contentType        | 设置发送到浏览器的MIME类型                       |
| contentLength      | 设置文件的大小                               |
| contentDisposition | 设置响应的HTTP头信息中的Content-Disposition参数的值 |
| inputName          | 指定Action中提供的inputStream类型的属性名称        |
| bufferSize         | 设置读取和下载文件时的缓冲区大小                      |

#### 下载文件

- 页面添加两个超链接

  ```html
  <a href="filedownpost.action?fileName=test.rar&conetntType=application/x-rar-compressed">test</a>
  <a href="/filedownpost.action?fileName=中文.rar&conetntType=application/x-rar-compressed;charset=iso8859-1">中文文件下载</a>
  ```

- FileDownAction，如果是中文，需要设置提交的文件编码格式。在服务器端需要进行转码。

  ```java
  String newFileName = new String(fileName.getBytes("iso-8859-1"), "utf-8");
  return new BufferedInputStream(new FileInputStream(path + "\\" + newFileName));
  ```

#### 对文件下载进行权限控制

对文件下载进行权限控制有两种实现方式：

- 在下载的Action中提供下载的权限控制，只允许登录用户下载文件。
- 通过自定义拦截器实现权限控制。

### 学员操作

#### 实现文件的下载

- 需求说明：模仿教学示例，实现将简历中上传的图片下载到本地保存
- 在Action中获取InputStream输入流
- 在配置文件中设置stream结果类型
  - 指定contentType参数
  - 指定contentDisposition参数

### 小结

- 拦截器是Struts2的核心
- 在框架中可以设置多个拦截器形成拦截器链
- 自定义拦截器的实现
  - 实现Interceptor接口
  - 继承AbstractInterceptor类
- 在Struts2框架中实现文件上传需要在项目中添加commons-fileupload环境
  - commons-fileupload-x.x.x..jar
  - commons-io-x.x.x..jar

### Struts2中的Ajax

#### 什么是Ajax

- Ajax(Asynchronous JavaScript And XML)，即异步和服务器交互技术。
- Ajax改进了传统的Web技术，通过Ajax，用户与服务器采用异步交互技术，从而避免了用户的等待，提高了用户的体验。

### Struts2的Ajax支持

- Struts2是个非常强大的MVC框架，它提供了非常完善的MVC功能。Struts2提供了多种强大的重量级AJAX插件，如DWR，Dojo等。
- 下面介绍的两种轻量级的Ajax实现方式：
  1. 通过stream类型的result提供ajax支持。
  2. 通过Json插件来提供ajax支持。

### 验证用户名是否存在

- 添加getInputStream方法

  ```java
  	private InputStream inputStream;
  	private String username;

  	public String getUsername() {
  		return username;
  	}

  	public void setUsername(String username) {
  		this.username = username;
  	}

  	public InputStream getInputStream() {
  		return inputStream;
  	}

  	public void setInputStream(InputStream inputStream) {
  		this.inputStream = inputStream;
  	}

  	public String checkUsername() throws Exception {
  		if (username != null && username.equals("test")) {
  			inputStream = new ByteArrayInputStream("false".getBytes());
  		} else {
  			inputStream = new ByteArrayInputStream("true".getBytes());
  		}
  		return SUCCESS;
  	}
  ```

  ​

- 通过stream返回text类型的字符串。

  ```xml
  <action name="checkUsername" class="com.znsd.struts.action.ValidateUsername" method="checkUsername">
        <result type="stream">
          	<!-- 返回的结果类型 -->
          	<param name="contentType">text/html</param>
          	<!-- 调用返回InputStream的方法 -->
          	<param name="inputName">inputStream</param>
        </result>
  </action>
  ```

  ```js
  $(function(){
  	$("#username").blur(function() {
  		$("#msg").load("checkUsername.action",{username:$("#username").val()});
  	});
  });
  ```

#### 练习验证用户名是否存在

- 验证用户名是否存在。
- 通过返回stream字符串方式实现。

![image](http://www.znsd.com/znsd/courses/uploads/d92bff76632a320c605ace07239664a1/image.png)

#### 基于Json格式的Ajax请求

- 添加Json插件  struts2-json-plugin-2.3.24.1.jar
- Json插件提供一个Json类型的Result。
  - 继承json-default
  - 返回结果类型为json
  - 插件包会自动将Action对象转换为json格式的文件。

#### 返回json格式

- 添加JsonAction

  ```java
  	private Map<String, Object> dataMap;

  	private String key = "123123123";

  	//要被序列化为json格式的对象
  	public Map<String, Object> getDataMap() {
  		return dataMap;
  	}

  	public void setDataMap(Map<String, Object> dataMap) {
  		this.dataMap = dataMap;
  	}

  	//设置key属性不作为json的内容返回  
  	public String getKey() {
  		return key;
  	}

  	public void setKey(String key) {
  		this.key = key;
  	}
  	
  	public String json() {
  		dataMap = new HashMap<String, Object>();
  		User user = new User();
  		user.setName("张三");
  		user.setPassword("111");
  		dataMap.put("user", user);
  		dataMap.put("success", true);
  		return SUCCESS;
  	}
  ```

  ​

- 配置文件设置如下

  ```xml
  <!-- 需要集成json-default -->
  <package name="json" extends="json-default">
  	<action name="json" class="com.znsd.struts.action.JsonAction" method="json">
  		<result type="json">
  			<!--指定将被Struts2序列化的属性，在action中必须有对应的getter方法-->  
  			<param name="root">dataMap</param>
  		</result>
  	</action>
  </package>
  ```

  `如果没有设置root参数，则会将整个Action都序列化为json对象。`

### 练习 Struts2+Ajax

#### 练习1：录入信息并显示

![image](http://www.znsd.com/znsd/courses/uploads/dcdd0878535b09151c2452339d64dfa1/image.png)

#### 练习2：学生系统



### 总结

1. 通过Stream方式实现Ajax。
2. 通过Json方式实现Ajax。