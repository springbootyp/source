## 第四章     类型转换和数据效验 

### 本章目标 

- 了解SpringMVC中数据绑定的过程
- 了解SpringMVC中类型转换的原理
- 添加自定义类型转换器
- 会使用常用的格式化器
- 了解SpringMVC中的验证机制
- 为表单添加验证
- 对显示的错误进行国际化处理

### 存在的问题 

- 通过上一章的练习，我们通过SpringMVC实现了一个基本的CRUD。但是还存在一些问题。 
  - 数据类型的转换
  - 数据类型的格式化
  - 数据效验
- 这节课我们会将上面的问题全部解决。

### Springmvc请求处理流程

![mdnvtfl0.ov5](http://www.znsd.com/znsd/courses/uploads/9064b4bf50f97638b6da9163aa7b2b67/mdnvtfl0.ov5.jpg)

![20141129165243297](http://www.znsd.com/znsd/courses/uploads/f8ae1560620789399487b652e9deb5ce/20141129165243297.png)

- 用户向服务器发送请求，请求被Spring 前端控制Servelt DispatcherServlet捕获
- DispatcherServlet对请求URL进行解析，得到请求资源标识符（URI）。然后根据该URI，调用HandlerMapping获得该Handler配置的所有相关的对象（包括Handler对象以及Handler对象对应的拦截器），最后以HandlerExecutionChain对象的形式返回
- DispatcherServlet 根据获得的Handler，选择一个合适的HandlerAdapter。（如果成功获得HandlerAdapter后，此时将开始执行拦截器的preHandler(...)方法）
- 提取Request中的模型数据，填充Handler入参，开始执行Handler（Controller)。 在填充Handler的入参过程中，根据你的配置，Spring将帮你做一些额外的工作
  - HttpMessageConveter： 将请求消息（如Json、xml等数据）转换成一个对象，将对象转换为指定的响应信息
  - 数据转换：对请求消息进行数据转换。如String转换成Integer、Double等
  - 数据根式化：对请求消息进行数据格式化。 如将字符串转换成格式化数字或格式化日期等
  - 数据验证： 验证数据的有效性（长度、格式等），验证结果存储到BindingResult或Error中
- Handler执行完成后，向DispatcherServlet 返回一个ModelAndView对象；
- 根据返回的ModelAndView，选择一个适合的ViewResolver（必须是已经注册到Spring容器中的ViewResolver)返回给DispatcherServlet 
- ViewResolver 结合Model和View，来渲染视图
- 将渲染结果返回给客户端

### Spring MVC数据绑定流程  

- SpringMVC将ServletRequest对象及目标方法的形参实例传给`WebDataBinderFactory`实例，以创建`DataBinder`实例对象。 

- DataBinder调用装配在SpringMVC上下文中的`ConversionService`组件进行类型转换和数据格式化工作，将Servlet请求信息填充到形参对象中。 

- 调用Validator组件对已经绑定了请求信息的形参对象进行数据有效性验证，并最终生成数据绑定结果BindingData对象中的形参对象和校检错误对象。

- SpringMVC抽取BindingResult将他们赋给处理方法的相应参数。

- SpringMVC通过反射机制对目标处理方法进行解析，将请求的消息到处理方法的形参中，数据绑定核心组件是DataBinder，运行机制如下。

  ![image](http://www.znsd.com/znsd/courses/uploads/75c0c26973f3a1915351d64a7482b83a/image.png)

- 查看源代码可以看到，通过WebDataBinderFactory创建DataBinder对象 

  ![image](http://www.znsd.com/znsd/courses/uploads/b45481d0849d2932d9d40bcc35d294b9/image.png)

- DataBinder中有三个比较重要的属性 

  - bindingResult：绑定的数据及错误结果对象
  - conversionService：类型转换及数据格式化对象
  - validators：数据验证对象

  ![image](http://www.znsd.com/znsd/courses/uploads/103628e55cbc5084b79567dc4cc0ca12/image.png)

### 类型转换

在SpringMVC中内置了很多的类型转换器，可以完成绝大多数类型转换工作。 

![image](http://www.znsd.com/znsd/courses/uploads/570aada963f40bf10fb0c50b394392e4/image.png)

#### 自定义类型转换器 

- 当碰到一些特殊场合，有可能需要我们自己定义类型转换器。

- 下面来讲解一个自定义类型转换器，将字符串转换为emp对象。

- 当页面无法完成数据绑定或者类型转换时，springmvc会抛出异常，异常信息可以使用BindingResult来进行获取。 

  ```java
  public String register(User user, BindingResult result){
  	if(result.getErrorCount() > 0){
  		for (FieldError error : result.getFieldErrors()) {
      		System.out.println(error.toString());
  		}
  	}
  	System.out.println("user:" + user);
  
  	return “register";
  }
  ```

#### Spring支持的转换器 

Spring定义了3种类型的转换器接口，实现任意一个转换器接口都可以作为自定义转换器注册到ConversionServiceFactoryBean中。 

- Converter<S,T>：将S类型转换为T类型。
- ConverterFactory：将相同系列的多个“同质”Converter封装在一起，如果希望一种类型转换成另一种类型及其子类对象（例如String转换为Number及Number的子类（Integer，Long，Double等）），可以使用该转换器工厂。
- GenericConverter：会根据源类对象及目标类对象所在的宿主类中的上下文信息进行类型转换。

```java
@Component
public class DateConverter implements Converter<String, Date>{

	@Override
	public Date convert(String text) {
		Date date = null;
		try {
			if (text.indexOf("-") > 0) {
				DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
				date = format.parse(text);
			} else {
				DateFormat format = new SimpleDateFormat("yyyy/MM/dd");
				date = format.parse(text);
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return date;
	}
}
```

- 注解实现日期转换器，处理日期问题

```java
@InitBinder
public void initBinder(WebDataBinder binder) {
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true)); 
}
```

#### 添加自定义类型转换器 

- ConversionService是SpringMVC中类型转换器的核心接口。要添加自定义类型转换器，需要实现该接口。 

- 利用ConversionServiceFactoryBean在Spring的IOC容器中定义一个ConversionService。Spring将自动识别出IOC容器中的ConversionService，并在Bean属性配置对应的类型转换器的实现类，SpringMVC处理方法的形参绑定时就会自动调用该类型转换器。

- 可以通过ConversionServiceFactoryBean的converters属性注册类型转换器。 

  ```xml
  <!-- 在这里启用转换器 -->
  <mvc:annotation-driven conversion-service="conversionService" />
  <!-- 定义自定义类型转换器的bean -->
  <bean id="conversionService" class="org.springframework.context.support.ConversionServiceFactoryBean">
      <property name="converters">
          <set>
              <!-- 这里是我们自己定义的类型转换器 -->
              <!-- 注意，这里首字母要小写，因为springmvc帮我们创建bean的时候，是以类名首字母小写命名 -->
              <ref bean="dateConverter"/>
          </set>
      </property>
  </bean>
  ```

- 测试获取日期

  ```java
  @RequestMapping("/register")
  public String post(User user, BindingResult result) {
      if (result.getErrorCount() > 0) {
          for (FieldError error : result.getFieldErrors()) {
              System.out.println(error);
          }
      }
      System.out.println(user.getBirthday());
      return "hello";
  }
  ```

#### 练习：使用字符串的方式添加数据 

**使用一个文本框来添加用户信息。**

- 字符串格式

- 用户名-密码-年龄-地址

- 按照格式输入字符串，通过自定义类型转换器将字符串转换为User对象。

  ![20180801103326](http://www.znsd.com/znsd/courses/uploads/7f838414606335516a1dd811cb3cf14b/20180801103326.png)

### 关于mvc:annotation-driven 

- <mvc:annotation-driven />会自动注册以下三个Bean对象。 
  - RequestMappingHandlerMapping
  - RequestMappingAdapter
  - ExceptionHandlerExceptionResolver
- 还将提供一下支持 
  - 支持使用ConversionService实例对表单参数进行实例转换。 
  - 支持使用@NumberFormat(pattern = "#.###k") 、 @DateTimeFormat(pattern = "yyyy/MM/dd")注解完成数据类型的格式化。
  - 支持使用@Valid注解对JavaBean实例进行JSR303验证。
  - 支持使用@ReuqestBody和@ResponseBody注解。

#### 直接配置视图访问 

```xml
<!--配置直接访问页面-->
<!--
	可以直接转发到相应的页面，而无需再经过控制器
	path：请求路径，如/test
	view-name：逻辑视图名称，对应的jsp文件名
-->
<mvc:view-controller path="/viewpath" view-name="viewname" />

<!--实际开发中通常都需要配置mvc:annotation-driven标签-->
<mvc:annotation-driven />
```

#### Spring MVC资源文件无法引用的问题

- 当程序中使用了.js或者.jpg等资源文件时，页面无法被访问。需要添加mvc:default-servlet-handler。 

  ```xml
  <!--将非mapping配置下的请求交给默认的Servlet来处理-->
  <mvc:default-servlet-handler/>
  <!--如果添加了默认servlet，mvc请求将无效，需要添加annotation-driven-->
  <mvc:annotation-driven></mvc:annotation-driven>
  ```

  ![image](http://www.znsd.com/znsd/courses/uploads/c1904cc3aff6b2ef5ca6f5c488ba38ec/image.png)

### 数据格式化

- 对属性的输入/输出格式化，其本质来讲依然属于类型转换的范畴。

- Spring在格式化模块中定义了一个实现ConversionService接口的FormattingConversionService实现类，该实现类扩展了GenericConversionService，因此它即具有类型转换的功能又具有格式化的功能。

- FormattingConversionService拥有一个FormattingConversionServiceFactoryBean工厂类，后者用于构造前者。

- FormattingConversionServiceFactoryBean内部已经注册了： 

  - 支持数字类型的属性用@NumberFormat注解。
  - 支持日期类型的属性使用@DateTimeFormat注解。

- 装配了FormattingConverstionServiceFactoryBean后，就可以在SpringMVC形参绑定及模型数据输出时使用注解驱动了。 

  ```xml
  <mvc:annotation-driven conversion-service="FormattingConversionServiceFactoryBean" />
  ```

### 日期格式化

@DateTimeFormat注解可以对日期类型进行格式化。 

- pattern属性：类型为字符串，指定解析/格式化字段数据的模式。如"yyyy-MM-dd hh: mm:ss"。 
- iso属性：解析格式化的ISO模式。 
  - ISO.DATE(yyyy-MM-dd)
  - ISO.TIME(hh: mm:ss.SSSZ)
  - ISO.DATE_TIME(yyyy-MM-dd hh: mm:ss.SSSZ)
  - ISO.NONE(不使用)
- style属性：字符串类型，通过样式指定日期时间的格式，由两位字符组成，第一位表示日期的格式，第二位表示时间的格式。 
  - S：短日期时间格式
  - M：中日期时间格式
  - L：长日期时间格式
  - F：完整日期时间格式
  - -：忽略日期时间格式

### 数字格式化

@NumberFormat可对类似数字类型的属性进行标注，它拥有两个互斥的属性。 

- patten：类型为String，自定义样式，如”#,##”，#代表数字。
- style：类型为NumberFormat.Style。用于指定样式类型，包括三种。 
  - Style.NUMBER：正常数字类型。
  - Style.CURRENCY：货币类型。
  - Style.PERCENT：百分比类型。

### 小结

- SrpingMVC的类型转换过程
- SpringMVC的常用的类型转换器。
- 添加自定义类型转换器
- 会使用数据格式化器

### 为什么要进行数据效验 

- 如何效验？
- 验证出错后返回的页面。
- 错误提示，及国际化的处理。 

#### JSR303 

- JSR303是Java为Bean数据合法性效验提供的标准框架，它已经包含在JavaEE6.0中。
- JSR303通过在Bean属性上标注类似@NotNull、@Max等标准的注解指定验证规则，并通过标准的验证接口对Bean进行验证。

#### JSR303常用注解

| 注解                  | 说明                                         |
| --------------------- | -------------------------------------------- |
| @Null                 | 必须为null                                   |
| @NotNull              | 必须不为null                                 |
| @AssertTrue           | 必须为true                                   |
| @AssertFalse          | 必须为false                                  |
| @Min(value)           | 必须为一个数字，其值必须大于等于指定的最小值 |
| @Max(value)           | 必须为一个数字，其值必须小于等于指定的最小值 |
| @DecimalMin(value)    | 必须为一个数字，其值必须大于等于指定的最小值 |
| @DecimalMax(value)    | 必须为一个数字，其值必须小于等于指定的最小值 |
| @Size(max,min)        | 元素的大小必须在指定范围内                   |
| @Digits(int,fraction) | 必须是一个数字，其值必须在可接受范围内       |
| @Past                 | 必须是一个过去的日期                         |
| @Future               | 必须是一个将来的日期                         |
| @Pattern(value)       | 其值必须符合指定的正则表达式                 |



#### hibernate Validator扩展注解 

- Hibernate Validator是JSR3.0的一个扩展组件，除支持所有标准的效验注解外，它还支持以下扩展注解 

| 注解      | 说明                               |
| --------- | ---------------------------------- |
| @Email    | 被修饰的元素必须是电子邮件         |
| @Length   | 被修饰的元素长度必须在指定的范围内 |
| @NotEmpty | 被修饰的元素必须非空               |
| @Range    | 被修饰的元素必须在合适的范围内     |



#### SpringMVC数据效验步骤 

- 导入Hibernate-validator包。
- 添加<mvc:annotation-driven />配置信息
- 在实体类上添加验证注解。
- 在目标方法Bean类型的前面添加@Valid注解。

#### SpringMVC的数据效验

- \<mvc:annotation-driven/>会默认装配好一个`LocalValidator FactoryBean`，通过在处理方法的入参上标注@valid注解即可让SpringMVC完成数据绑定后执行数据效验工作。 
- 在已经标注了JSR303注解的表单/命令对象前标注一个@Valid，SpringMVC框架在将请求参数绑定到该形参对象后，就会调用效验框架根据注解声明的校检规则进行校检。 
- SpringMVC是通过对处理方法签名的规定来保存效验结果的，前一个表单/命令对象的效验结果，保存到随后的入参中，这个保存了效验结果的入参必须是BindingResult或者Error类型，这两个类都位于org.springframework.validation包中。 

#### SpringMVC的数据效验

- `需效验的Bean对象和其绑定结果对象或错误对象是成对出现的，它们之间不允许声明其它入参。 `
- Errors接口提供了获取错误信息的方法，如getErrorCount()或 getFieldErrors(String field) 
- BindingResult扩展了Errors接口。 

#### 在页面上显示错误信息 

- SpringMVC除了会将表单/命令对象的效验结果保存到对应的BindingResult或Errors对象中外，还会将所有效验结果保存到”隐含模型”中。
- 表单的名称必须和实体类的名称一致，小写开头。
- 即使处理方法的签名中没有对应于表单/命令对象的结果入参，效验结果也会保存在“隐含模型”中。
- 隐含模型中的所有数据最终将通过HttpServletRequest传递到JSP视图中，因此在JSP视图可以获取错误信息。
- 在JSP页面上可通过<form:errors path="username" />显示错误信息。

#### Errors标签

form:errors：显示表单组件或数据效验所对应的错误。

- <form:errors path="*" />：显示表单中所有的错误。*
- *<form:errors path="user*" />：显示所有以user为前缀的属性对应的错误。
- <form:error path="username" />：显示username表单元素的错误。 

#### 示例

前台页面代码实现 

```html
<form:form action="${pageContext.request.contextPath}/emp/add" method="post" modelAttribute="employee">
    姓名:<form:input path="name" /><form:errors path="name" /><br><!-- 获取单个字段错误信息 -->
    邮箱:<form:input path="email" /><form:errors path="email" /><br>
    性别:<form:radiobuttons items="${genders}" path="gender" /><br>
    部门：<form:select path="dept.id" items="${depts}" itemValue="id" itemLabel="name"></form:select><br><br>
    生日：<form:input path="birthday" /><form:errors path="birthday" /><br>
    金额：<form:input path="salary" /><form:errors path="salary" /><br>
    <!-- 获取所有错误信息 -->
    <form:errors path="*" /><br />
    <input type="submit" value="提交" />
</form:form>
```

实体类代码实现

```java
public class Employee implements Serializable {
    
    /*
	 * @Null 被注释的元素必须为 null
	 * 
	 * @NotNull 被注释的元素必须不为 null
	 * 
	 * @AssertTrue 被注释的元素必须为 true
	 * 
	 * @AssertFalse 被注释的元素必须为 false
	 * 
	 * @Min(value) 被注释的元素必须是一个数字，其值必须大于等于指定的最小值
	 * 
	 * @Max(value) 被注释的元素必须是一个数字，其值必须小于等于指定的最大值
	 * 
	 * @DecimalMin(value) 被注释的元素必须是一个数字，其值必须大于等于指定的最小值
	 * 
	 * @DecimalMax(value) 被注释的元素必须是一个数字，其值必须小于等于指定的最大值
	 * 
	 * @Size(max, min) 被注释的元素的大小必须在指定的范围内
	 * 
	 * @Digits (integer, fraction) 被注释的元素必须是一个数字，其值必须在可接受的范围内
	 * 
	 * @Past 被注释的元素必须是一个过去的日期
	 * 
	 * @Future 被注释的元素必须是一个将来的日期
	 */

	@NotEmpty
	private String name;
	@Email
	private String email;
	private String gender;

	private Dept dept;
	
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date birthday;
	@NumberFormat(pattern="#,####,###.#")
	@DecimalMin("1000")
	@DecimalMax("9999")
	private Double salary;
    // 忽略set、get方法
}
```

后台代码实现

```java
private void loadEmpData(Map<String, Object> map) {
    List<String> genderList = new ArrayList<String>();
    genderList.add("男");
    genderList.add("女");
    map.put("genders", genderList);

    List<Dept> depts = new ArrayList<Dept>();
    depts.add(new Dept(1, "开发部"));
    depts.add(new Dept(2, "技术部"));
    depts.add(new Dept(3, "产品部"));
    map.put("depts", depts);
}

@RequestMapping("/add")
public String add(@Valid Employee emp, BindingResult result, Map<String, Object> map, Model model){
    if (result.hasErrors()) {
        // result.rejectValue("name", "NotEmpty", "名称不能为空");
        for (ObjectError error : result.getAllErrors()) {
            System.err.println(error.getObjectName() + ":" + error.getCode() + "-->" + error.getDefaultMessage());
        }
        loadEmpData(map);
        return "register";
    }
    System.out.println("emp:" + emp);
    return "redirect:/emps";
}
```

#### 练习：实现用户验证 

添加一个用户注册页面 

- 注册信息包括，用户名，密码，邮箱，出生日期字段。 
- 要求验证用户输入的信息。
- 用户名不能为空
- 两次输入密码必须一致。
- 邮箱格式必须正确。
- 出生日期必须是一个过去时间。

### 提示消息的国际化 

- 每个属性在数据绑定和数据效验发生错误时，都会生成一个对应的FieldError对象。

- 当一个属性效验失败后，效验框架会为该属性生成4个消息代码，这些代码以效验注解类为前缀，结合modelAttribute中的对象名.属性名及属性类型名生成多个对应的消息代码：例如User类中的password属性标注了一个@Pattern注解，当属性不满足@Pattern所定义的规则时，就会产生如下4个错误代码： 

  ```properties
  pattern.user.password
  pattern.password
  pattern.java.lang.String
  pattern
  ```

- 当使用SpringMVC标签显示错误消息时，SpringMVC会查看Web上下文是否装配了对应的国际化消息，如果没有，则会显示错误信息，否则使用国际化消息。

  ```properties
  #语法：实体类上属性的注解.验证目标方法的modleAttribute 属性值(如果没有默认为实体类首字母小写).注解修饰的属性 
  #以第一个为例：Employee实体类中 属性name用了NotEmpty注解修饰，表示不能为空。所以前缀是NotEmpty
  #验证的目标方法 public String add(@Valid Employee emp, ...) emp被注解@Valid修饰，但又被modleAttribute修饰(modelAttribute="employee")。所以中间是employee
  #后缀就是被注解修饰的属性名name  
  NotEmpty.employee.name=用户名不能为空
  Email.employee.email=Email格式不正确
  Past.employee.birthday=出生日期不能是一个将来的日期
  DecimalMin.employee.salary=工资必须大于等于1000
  DecimalMax.employee.salary=工资必须小于等于1000
  ```

#### 注册国际化资源文件 

注册国际化资源文件 

```xml
<!-- 注册国际化信息，必须有id，指定资源文件名称，资源文件在src目录下 -->
<bean id="messageSource" class="org.springframework.context.support.ResourceBundleMessageSource">
    <!-- 注入绑定的资源文件名称 i18n
            i18n_en.properties
            i18n_zh_CN.properties
     -->
	<property name="basename" value="i18n"></property>
</bean>
```

#### 提示消息的国际化

- 若数据类型转换和数据格式化时发生了错误，或该有的参数不存在，或调用处理方法时发生错误，都会在隐含模型中创建错误信息。其错误代码前缀如下： 
  - required：必要的参数不存在。
  - typeMismatch：在数据绑定时，发生数据类型不匹配的问题。
  - methodInvocation：SpringMVC调用处理方法时发生错误。

### jsp页面国际化

* 添加i18n拦截器的配置

  ``` xml
  <mvc:interceptors>
        <bean class="org.springframework.web.servlet.i18n.LocaleChangeInterceptor" />
  </mvc:interceptors>
  ```

* 页面添加springmvc的tags标签库

  ``` html
  <%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
  ```

* 页面使用message标签显示国际化内容

  ```html
  <spring:message code="label.user.name"></spring:message>
  code属性是国际化文件内的key
  ```


### 总结 

- SrpingMVC的数据绑定过程
- 了解SpringMVC的类型转换过程
- 添加自定义类型转换器
- 会使用数据格式化器
- 对表单提交过来的数据进行数据效验
- 在视图中显示错误信息
- 对显示的错误进行国际化处理