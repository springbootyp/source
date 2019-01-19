## 第五章     国际化和文件上传 

### 本章目标 

- 学会使用SpringMVC进行国际化配置
- 实现文件上传 

### 对页面内容进行国际化 

**需求：**

- 对页面上的内容进行国际化，时间，数值进行本地化处理
- 可以在bean中获取国际化资源文件Local对应的信息。
- 可以通过超链接切换Local，而不再依赖浏览器的设置情况。

**解决方法：**

- 页面中使用Spring的message标签
- 在bean中注入ResourceBundleMessageSource，使用其对应的getMessage()方法即可。
- 配置LocalResolver和LocaleChangeIntercepter。

#### 添加资源文件

在项目中添加资源文件，和前面的内容基本一致。 

- i18n_zh_CN.properties
- i18n_en_US.properties

#### 注册国际化资源文件 

- 注册国际化资源文件 

  ```xml
  <!-- 注册国际化信息，必须有id，指定资源文件名称，资源文件在src目录下 -->
  <bean id="messageSource" class="org.springframework.context.support.ResourceBundleMessageSource">
  	<property name="basename" value="i18n"></property>
  </bean>
  ```

#### 实现页面国际化 

- 在页面中添加spring标签 

  ```html
  <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
  ```

- 使用message标签显示国际化内容

  ```html
  <spring:message code="i18n.name" />
  ```

#### 在控制器中使用国际化 

- 控制器中对输出内容进行国际化操作

  ```java
  @Controller
  public class localControllor {
      
  	@Autowired
  	private ResourceBundleMessageSource messageSource;	
  	
  	//添加local参数，会自动获取网页中的语言
  	@RequestMapping("/testlocale")
  	public String testLocal(Locale locale, Map<String,Object> map){
  		//通过getMessage方法获取资源文件中的key值
  		String name = messageSource.getMessage("i18n.name", null, locale);
  		map.put("name", name);
  		return "locale";
  	}
  }
  ```

#### 切换语言 

- 不依赖浏览器，直接在页面中，通过超链接切换语言。 
- 默认情况下，SpringMVC根据`Accept-Language`参数判断客户端的本地化类型。 
- 当接收请求时，SpringMVC会在上下文中查找一个本地化解析器`（LocalResolver）`，找到后使用它获取请求所对应的本地化类型信息。
- SpringMVC还允许装配一个`动态更改本地化类型的拦截器`，这样通过指定一个请求参数就可以控制单个请求的本地化类型。

#### SpringMVC国际化工作原理

![image](http://www.znsd.com/znsd/courses/uploads/f7a43f375ed2829514a14fa988355fc5/image.png)

#### 本地化解析器和本地化拦截器 

- AcceptHeaderLocalResolver：根据HTTP请求头的Accept-Language参数确定本地化类型，如果没有显示定义本地化解析器，SpringMVC使用该解析器。 
- CookieLocalResolver：根据指定的Cookie值确定本地化类型。
- `SessionLocalResolver`：根据Session中特定的属性确定本地化类型。
- `LocaleChangeIntercepter`：本地化拦截器，从请求参数中获取本次请求对应的本地化类型。 

#### 代码实现 

- 配置LocalResolver用来获取本地化语言 

  ```xml
  <!-- id值必须为localeResolver，否则会出现Cannot change HTTP accept header - use a different locale resolution strategy异常 -->
  <bean id="localeResolver" class="org.springframework.web.servlet.i18n.SessionLocaleResolver"></bean>
  ```

- 配置LocaleChangeInterceptor拦截器 

  ```xml
  <mvc:interceptors>
    <bean class="org.springframework.web.servlet.i18n.LocaleChangeInterceptor" />
  </mvc:interceptors>
  ```

- 配置超链接进行语言切换

  ```html
  <a href="locale?locale=zh_CN">中文</a>
  <a href="locale?locale=en_US">英文</a>
  ```

#### 练习：对员工管理系统进行国际化 

- 需求：配置LocalResolver用来获取本地化语言，并用超链接实现中英文切换。 

  ![20180802094225](http://www.znsd.com/znsd/courses/uploads/d92b1ac1036b86ba586525b1fe5f1418/20180802094225.png)

#### 小结 

- 页面实现国际化
- 后台代码实现国际化
- 进行国际化语言的切换

### 文件上传 

- SpringMVC为文件上传提供了直接的支持，这种支持是通过即插即用的MultipartResolver接口实现的。Spring用它的实现类CommonsMultipartResolver来实现。
- SpringMVC上下文中没有装配任何的MultipartResolver, 因此默认情况下SpringMVC不能处理文件的上传的操作，如果需要使用上传功能，需要手动配置MultipartResolver。

#### 配置MultipartResolver

- 导入CommonsMultipartResolver所依赖的jar包。

  - commons-fileupload-1.3.3.jar
  - commons-io-2.6.jar

- 添加配置文件 

  ```xml
  <bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
      <!-- 指定默认的编码格式 -->
      <property name="defaultEncoding" value="UTF-8" />
      <!-- 指定允许上传的文件大小，单位Byte -->
      <property name="maxUploadSize" value="512000" />
  </bean>
  ```

#### MultipartFile属性

- MultipartFile可以获取表单提交过来的文件域 
- 常用方法 
  - isEmpty()：判断是否提交文件
  - getContentType()：获取文件类型
  - getName()：获取表单元素名称
  - getOriginalFilename()：获取提交的文件名称
  - getInputStream()：获取文件流
  - getSize()：获取文件大小
  - getBytes()：获取字节数组

#### 上传文件示例 

页面代码 

```html
<form action="fileupload" method="post" enctype="multipart/form-data">
    <input type="file" name="file" /> 
    <input type="submit" value="上传" />
    <br />
    <div class="msg">${message}</div>
</form>
<c:if test="${ !empty imageurl }">
    <img src="${imageurl}" />
</c:if>
```

控制器代码

```java
@RequestMapping("/fileupload")
public String fileupload(ServletRequest request, @RequestParam("file") MultipartFile file, Model model)
    throws IOException {
    if (!file.isEmpty()) {
        String imageurl = saveFile(request, file);
        model.addAttribute("imageurl", imageurl);
    } else {
        model.addAttribute("message", "请选择要上传的文件");
    }
    return "fileupload";
}
```

提取保存文件的方法

```java
private String saveFile(ServletRequest request, MultipartFile file) throws IOException {
    // 获取文件的上传路径
    String uploadPath = request.getServletContext().getRealPath("uploads");
    File uploadPathFile = new File(uploadPath);
    if (!uploadPathFile.exists()) {
        uploadPathFile.mkdirs();
    }
    // 获取文件名称
    String filename = file.getOriginalFilename();
    // 截取文件后缀
    String fileext = filename.substring(filename.lastIndexOf("."));
    // 生成新的随机文件名称
    String newfileName = UUID.randomUUID() + fileext;
    // 文件保存路径
    File savePath = new File(uploadPath + "/" + newfileName);
    // 上传文件
    file.transferTo(savePath);
    return "uploads/" + newfileName;
}
```

如果提示文件找不到（404）需要修改springmvc.xml配置文件，加上以下配置

```xml
<mvc:default-servlet-handler/>
```

#### 练习：实现单个文件上传

- 需求：

  1. 上传图片并显示 
  2. 是否选择了上传文件需要进行判断，需要有提示
  3. 文件大小不能超过100KB，前台需要有提示
  4. 只能上传jpg,gif,png的图片格式。
  5. 上传的文件名必须使用新生成的名称。

  ![20180802105858](http://www.znsd.com/znsd/courses/uploads/300280f19174fdf89429e28bc93499cf/20180802105858.png)

### 多文件上传 

页面代码

```html
<form action="filesupload" method="post" enctype="multipart/form-data">
	<input type="file" name="file" /><br><br>
	<input type="file" name="file" /><br><br>
	<input type="file" name="file" /><br><br>
	<input type="submit" value="上传" />
	<br />
	<div class="msg">${message}</div>
</form>
<c:if test="${ !empty images }">
	<c:forEach items="${images}" var="img">
		<img src="${img}" />
	</c:forEach>
</c:if>
```

控制器代码，多个文件其实SpringMVC会帮我们合并为一个MultipartFile[]数组。循环遍历就可以了。 

```java
@RequestMapping("/filesupload")
public String filesupload(ServletRequest request, @RequestParam("file") MultipartFile[] files, Model model) throws IOException{
	List<String> images = new ArrayList<String>();
	if(files!=null && files.length > 0){
		for (int i = 0; i < files.length; i++) {
			images.add(this.saveFile(request, files[i]));
		}
		model.addAttribute("images", images);
	}
	return "filesupload";
}
```

#### 练习：多个文件上传

- 需求：

  1. 通过jquery动态生成多个文件域对象。
  2. 然后点击提交按钮进行上传
  3. 上传后再当前页面显示预览效果。
  4. 错误后需要返回错误提示。
  5. 其他要求同单个文件上传不变。

  ![20180802110559](http://www.znsd.com/znsd/courses/uploads/e19417c916dec3c21e9b69f9d41ad527/20180802110559.png)
### 总结

  - SpringMVC实现国际化的方式
  - 单个文件上传
  - 多个文件上传