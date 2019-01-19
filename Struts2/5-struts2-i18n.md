## 第五章 国际化、类型转换、数据验证

### 本章目标

- 掌握Struts2的国际化
- 掌握Struts2的类型转换`重点（难点）`
- 掌握Struts2的验证框架`重点（难点）`

### 国际化 （internationalization）

- 国际化英文单词为：Internationalization，又称I18N，I为因为单词的第一个字母，18为这个单词的长度，而N代表这个单词的最后一个字母。国际化又称本地化（Localization,L10N）。


- 所谓国际化（internationalization）是指：程序可以根据机器所在的国家和语言，自动选择适合与当前国家语言的内容。
- 所谓的国际化本质，其实就是查找，替换。
- Java国际化机制是根据程序所在的local决定查找哪一个国际化资源文件，并用该文件中的key所对应的消息来替代页面上的key。
- Java程序国际化只需要2步：
  - 提供对应国家的资源文件。
  - 输出国际化消息。

### 国际化资源文件

Java程序的国际化思路

- 将程序中的提示信息、错误信息等放在资源文件中，为不同国家/语言编写对应资源文件


- 资源文件由很多key-value对组成，key保持不变，value随国家/语言不同而不同
- 这些资源文件使用共同的基名，通过在基名后面添加语言代码、国家和地区代码来进行区分

| 资源文件名                                 | 说    明                          |
| ------------------------------------- | ------------------------------- |
| ApplicationResources_en.properties    | 所有英文语言的资源                       |
| ApplicationResources_zh.properties    | 所有的中文语言的资源                      |
| ApplicationResources_zh_CN.properties | 针对中国大陆的、中文语言的资源                 |
| ApplicationResources_zh_HK.properties | 针对中国香港的、中文语言的资源                 |
| ApplicationResources.properties       | 默认资源文件，如果请求的资源文件不存在，将调用它的资源进行显示 |

### Java中的国际化

控制台中实现国际化

1. 添加资源文件命名： (名称_语言_国家.properties)

   - base_en_US.properties


   ```properties
   hello=hello
   ```

   ​

   - base_zh_CN.properties 中文资源文件需要通过native2ascii命令进行编码转译


   ```properties
   hello=你好
   ```

2. java代码实现


```java
public class Test {

 	public static void main(String[] args) {
 		Locale myLocale = Locale.getDefault();// 获得系统默认的国家/语言环境

 		ResourceBundle bundle = ResourceBundle.getBundle(Test.class.getPackage().toString().substring(8)+".base", myLocale); // 根据指定的国家/语言环境加载对应的资源文件

 		System.out.println(bundle.getString("hello"));// 获得本地化字符串
 	}
}
```



### Struts2的国际化

- Struts2的国际化更加强大，更加便捷。它支持模块化加载，不同的模块加载不同的国际化资源。
- Struts2支持使用国际化的方式,只要将国际化资源文件放到指定目录下，系统会自动加载国际化资源文件。

### Struts2使用国际化

Struts2使用国际化的步骤

1. 添加资源文件。
2. 在struts.xml通过i18n配置国际化资源文件路径。
3. 页面中使用国际化。
4. action中使用国际化。

#### 添加国际化配置文件

- 添加国际化资源文件，放在src目录下，可以创建resource文件夹存放国际化文件。
  - message_en_US.properties
  - message_zh_CN.properties

- 通过一个struts.custom.i18n.resources常量来加载国际化资源文件路径。

  ```xml
  <!--value的只是资源文件的前缀-->
  <constant name="struts.custom.i18n.resources" value="message"></constant>
  ```

  

  - 这个全局化的资源文件，即可被action访问，也可被JSP访问。
  - 只需要在配置文件中加载一次，将所有的配置信息全部放到一个文件中进行维护。

#### JSP中的国际化

- JSP页面中显示国际化信息
  - 页面中使用\<s:textname="key">来输出国际化消息。
  - 标签中使用key来输出国际化消息。
- 通过火狐浏览器切换语言来进行演示。

message_en_US.properties

```properties
add=add
```

message_zh_CN.properties

```properties
add=添加
```

```html
<s:text name="add"></s:text>
```



#### Action中的国际化

在Action中输出国际化消息

- 在AcionSupprt中提供了一个getText()方法来加载国际化信息。
- 在action中使用getText()方法来加载国际化key。
- 消息中如果需要使用动态的值，资源文件中可以使用{0}作为占位符，然后在getText()中，传入Stirng[]数组进行填充。

```java
public class I18nAction extends ActionSupport {

	private String username;

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	private static final long serialVersionUID = 1L;

	@Override
	public String execute() throws Exception {
		if (username == null || username == "") {
			this.addActionError(getText("username.notNull", new String[]{"params"}));
		}
		return SUCCESS;
	}
}
```

```html
<s:actionerror/>
```

#### 用户更改语言选项

- Struts2默认是根据浏览器来选择语言。

- Struts2也可以让用户来选择语言。

  - 在地址栏后传递一个参数request_locale=en_US
  - 只要传一次参数，struts2就会记住所更改的语言选项。

- 添加语言选择功能

  ```html
  <s:a href="i18n.action?request_locale=zh_CN">中文</s:a>
  <s:a href="i18n.action?request_locale=en_US">English</s:a>
  ```

- 手动实现语言选择功能

  ```java
  @Override
  public String execute() throws Exception {
  	Locale locale = Locale.US;
  	ActionContext.getContext().setLocale(locale);
  	ServletActionContext.getRequest().getSession().setAttribute("WW_TRANS_I18N_LOCALE", locale);
  	return SUCCESS;
  }
  ```

- form表单国际化

  ```html
  <!-- key是properties文件中的名字 -->
  <s:textfield name="username" key="username"></s:textfield>
  <s:password name="password" key="password"></s:password>
  ```

  ​

### 学员操作：用户注册信息的国际化

- 需求说明：使用Struts2的国际化实现用户注册信息的国际化显示

  ![image](http://www.znsd.com/znsd/courses/uploads/569c4d1c5dc4be95fea375fa0c019cef/image.png)![image](http://www.znsd.com/znsd/courses/uploads/013ef52ab0b9178cb5fef108ed78269a/image.png)

### 小结

- Struts2国际化实现
- JSP页面国际化
- Action国际化
- 切换语言

### 为什么需要类型转换

- HTTP请求参数都是字符串类型，Struts2必须将这些字符串转换为相应的数据类型。这个工作是所有MVC框架都应该提供的功能。

  ![image](http://www.znsd.com/znsd/courses/uploads/2f16c0ca73c95094545b0a73397a65f4/image.png)

### Struts中的类型转换

- Struts2的类型转换可以基于OGNL表达式，只要把HTTP参数命名为合法的OGNL表达式，就可以充分利用Struts2的类型转换机制。
- 开发者还可以开发自己的类型转换器。
- 如果转换器中出现异常，Struts2中的拦截器conversionError拦截器会自动处理异常，并且在页面上生成错误提示。
- Struts2提供了强大的表现层数据处理机制，开发者利用Struts2的类型转换机制可以完成任意类型的转换。

### Struts2的内置类型转换

- boolean和Boolean：完成布尔和字符串之间的转换。
- char和Character：完成字符和字符串之间的转换。
- int和Interger：完成整形和字符串之间的转换。
- long和Long：完成长整形和字符串之间的转换。
- float和Float：完成单精度浮点型和字符串之间的转换。
- double和Double：完成双精度浮点型和字符串之间的转换。
- Date：完成日期类型和字符串之间的转换。`Date很容易转换失败，因为Struts对日期格式要求很严格，只能是用户所在Locale的Short格式。(16-05-11)`
- 数组：默认情况下，数组元素是字符串，如果用户提供了自定义的转换器，也可以使其他符合类型的数组。
- 集合：默认情况下，集合元素是字符串，并创建一个新的ArrayList封装所有字符串。

### 基于OGNL的转换

- name：该请求参数将自动转换为Action的name属性。
- user.name：该请求参数将自动转换为Action的User对象的name属性。
- 注意：
  - 因为Struts2通过反射来创建User类的实例，因此必须为该类提供无参的构造函数。
  - 在Action中必须为user对象提供对应的setUser()方法，同样在User类中也必须为name提供setName()方法。

```html
<s:form action="convert.action" method="post">
	<s:textfield name="username" label="用户名"></s:textfield>
	<s:password name="password" label="密码"></s:password>
	<s:textfield name="list[0]" label="0"></s:textfield>
	<s:textfield name="list[1]" label="1"></s:textfield>
	<s:textfield name="list[2]" label="2"></s:textfield>
	
	<s:textfield name="map['key1']" label="key1"></s:textfield>
	<s:textfield name="map['key2']" label="key2"></s:textfield>
	<s:textfield name="map['key3']" label="key3"></s:textfield>
	<s:submit value="提交"></s:submit>
</s:form>
```

```java
public class ConvertAction extends ActionSupport {

	private String username;
	private String password;
	private List<String> list;
	private Map<String, String> map;

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public List<String> getList() {
		return list;
	}

	public void setList(List<String> list) {
		this.list = list;
	}

	public Map<String, String> getMap() {
		return map;
	}

	public void setMap(Map<String, String> map) {
		this.map = map;
	}

	@Override
	public String execute() throws Exception {
		System.out.println("username:" + username);
		System.out.println("password:" + password);
		System.out.println("list:" + list);
		System.out.println("map:" + map);
		return SUCCESS;
	}

}
```



### 自定义类型转换

在特殊情况下，这种类型转换满足不了需求，比如需要把一个复杂字符串转换为一个对象。如用户输入"huaihaizi,123"需要将huaihaizi映射到username，把123映射到password。则需要提供自定义类型转换器并将其注册到struts2中，供系统调用并完成类型转换。

```java
public class UserConvertor extends DefaultTypeConverter {

	@Override
	public Object convertValue(Map<String, Object> context, Object value, Class toType) {
		if (toType == User.class) {
			String[] params = (String[]) value;
			String userStr = params[0];
			String[] userArray = userStr.split(",");
			User user = new User();
			user.setName(userArray[0]);
			user.setAge(Integer.parseInt(userArray[1]));
			return user;
		}
		return null;
	}
}
```

```html
<s:form action="convert.action" method="post">
	<s:textfield name="user" label="姓名,年龄"></s:textfield>
	<s:submit value="提交"></s:submit>
</s:form>
```

### 注册类型转换器

1. 局部注册
   - 局部转换器只对当前的action有效。
   - `同一个包下`增加一个名为`action类名-conversion.properties`的文件，该文件包含如下内容。
   - `转换的属性=转换器类名`
2. 全局注册
   - 全局转换器对所有action中特定的属性都会生效。
   - 全局转换器不是对某个属性起作用，而是对某个类型起作用。
   - 在`类加载的路径下`添加`xwork-conversion.properties`文件。该文件包含如下内容
   - `转换的类型=转换器类名`

`全局类型转换器是针对所有类型，而局部类型转换器是针对当前action的某个属性。`

```html
<s:form action="convert.action" method="post">
	<s:textfield name="birthday" label="生日"></s:textfield>
	<s:submit value="提交"></s:submit>
</s:form>
```

```java
public class DateConvert extends DefaultTypeConverter {

	@Override
	public Object convertValue(Map<String, Object> context, Object value, Class toType) {
		String[] values = (String[])value;
		String strDate = values[0];
		
		DateFormat formate = new SimpleDateFormat("yyyy-MM-dd");
		Date date = null;
		try {
			date = formate.parse(strDate);
		} catch (ParseException e) {
			e.printStackTrace();
			return null;
		}
		return date;
	}
}
```

在src目录下新建xwork-conversion.properties文件

```properties
java.util.Date=com.znsd.struts.convert.DateConvert
```

### 类型转换器的处理流程

![image](http://www.znsd.com/znsd/courses/uploads/4136ffb0beb17263f2781788bb37035f/image.png)

### 类型转换的错误处理

- Action类继承Struts2的ActionSupport类。
- Struts2提供了一个名为conversionError的拦截器，该拦截器被注册在默认的拦截器栈中，它会负责处理类型转换过程中出现的错误。
- 当发生异常时，conversionError拦截器会处理该异常，转入input逻辑视图，因此应该为该Action添加名为input的逻辑视图定义。
- 在input视图对应的页面中使用，\<s:fielderror />标签输出类型转换错误。

```xml
<package name="default" namespace="/" extends="struts-default">
	<action name="convert" class="com.znsd.struts.action.ConvertAction">
		<result>success.jsp</result>
		<result name="input">convertError.jsp</result>
	</action>
</package>
```

convertError.jsp输出错误信息

```html
<body>
	<s:fielderror />
</body>
```

### 更改自定义错误提示

添加全局提示

- 添加全局的i18n配置文件

  1. message_en_US.properties
  2. message_zh_CN.properties

- 添加常量配置struts.custom.i18n.resources

  ```xml
  <constant name="struts.custom.i18n.resources" value="message"></constant>
  ```

- 添加属性

- xwork.default.invalid.fieldvalue={0}字段是无效的。

- {0}代表占位符，会用属性名替代。

  ```properties
  xwork.default.invalid.fieldvalue={0} field invalid
  ```

  ```properties
  xwork.default.invalid.fieldvalue={0}字段无效
  ```

添加局部提示

- 专门为Action的指定属性指定转换失败的错误提示，因此这种方法更有针对性，更具体。
- 在Action目录下添加一个与Action同名的i18n配置文件。
- 添加属性invalid.fieldvalue.属性名=提示信息

1. ConvertAction_en_US.properties

   ```properties
   invalid.fieldvalue.user=user property invalid
   ```

2. ConvertAction_zh_CN.properties

   ```properties
   invalid.fieldvalue.user=用户信息无效
   ```

### 练习，添加自定义转换器

输入用户字符串，转换为User对象

![image](http://www.znsd.com/znsd/courses/uploads/8c893481f0d994015c66eb4317a5bf22/image.png)![image](http://www.znsd.com/znsd/courses/uploads/f32822bb18dc959c52712dbc09a869a9/image.png)![image](http://www.znsd.com/znsd/courses/uploads/3d46e0596b109260adfe46da09fa5a9a/image.png)![image](http://www.znsd.com/znsd/courses/uploads/6090bf357bf99a720086a2fbad8462b8/image.png)



### 小结

- ONGL默认类型转换器
- 添加自定义转换器规则
- 转换器的错误处理

### 输入验证

- 输入验证可以分为客户端验证和服务器端验证。
- 通过JavaScript或者Jquey框架进行客户端验证。
  - 客户端验证主要为了防止一些客户的误输入，仅能对数据进行一些初步的过滤；对于恶意的行为，客户端验证无能为力，所以客户端效验并不能替代服务器端效验。
  - 客户端效验也是必不可少的，因为Web应用大部分的用户都是普通用户，他们输入时可能包含大量错误信息，客户端效验可以将这些错误信息阻止在客户端，从而降低服务器的压力。
- 服务器端验证是整个应用的最后一道防线。所以是必不可少的。
- Struts2中提供了Validate验证框架，来帮助我们进行服务器端验证。

### Struts2的输入效验

Struts2的输入效验分为两种方式：

1. 验证方法又可以分为以下两种：
   - validate()
   - validateXxx()
2. 验证框架

Struts2的输入效验过程

1. 类型转换器对请求参数执行类型转换，并把转换后的值赋给action中的属性。
2. 如果在执行类型转换的过程中出现异常，系统会将异常信息保存到ActionContext，conversionError拦截器将异常信息添加到fieldErrors里。不管类型转换是否出现异常，都会进入第3步。
3. 系统通过反射技术先调用action中的validateXxx()方法，Xxx为方法名。
4. 再调用action中的validate()方法。
5. 经过上面4步，如果系统中的fieldErrors存在错误信息（即存放错误信息的集合的size大于0)，系统自动将请求转发至名称为input的视图。如果系统中的fieldErrors没有任何错误信息，系统将执行action中的处理方法。

![20180106094401](http://www.znsd.com/znsd/courses/uploads/8f617d011ba4da5d2b0b1dd071d9262d/20180106094401.png)

#### 使用validate()进行验证

- 如何对用户注册进行验证

  ![20180106103319](http://www.znsd.com/znsd/courses/uploads/bba1c5f734240f24b8541d739933cd77/20180106103319.png)

- 使用Struts2的验证机制

  1. 继承ActionSupport
  2. 重写validate()方法
  3. 将数据代码和业务代码完全分离。
  4. validate()方法验证不通过是不会执行Action方法的。

#### 添加错误信息

- 在Action中添加错误信息
  - addFieldError(String fieldName,String errorMessage)，添加字段的错误信息。
  - addActionError(String anErrorMessage)，添加与Action所处理业务相关的错误信息。
- 在页面输出错误信息
  - \<s:fielderror/>：输出一个或者所有字段的错误信息
  - \<s:actionerror/>：输出所有Action的错误信息

```java
public class ValidateAction extends ActionSupport { // 继承ActionSupport类

	private static final long serialVersionUID = 1L;

	private String username;
	private String password;
	private String confirmPassword;

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getConfirmPassword() {
		return confirmPassword;
	}

	public void setConfirmPassword(String confirmPassword) {
		this.confirmPassword = confirmPassword;
	}

	@Override
	public String execute() throws Exception {
		return SUCCESS; // 验证成功
	}

	@Override
	public void validate() {
		if (username == null || username.equals("")) {
			// 验证出错，指定错误提示信息
			this.addFieldError("username", "用户名不能为空");
		}
		if (password == null || password.equals("")) {
			this.addFieldError("password", "密码不能为空");
		}
		if (confirmPassword == null || confirmPassword.equals("")) {
			this.addFieldError("confirmPassword", "确认密码不能为空");
		}
		if (!password.equals(confirmPassword)) {
			// 验证出错，指定ActionError错误提示信息
			this.addActionError("两次密码不一致");
		}
	}
}
```

```html
<h2>用户注册</h2>
<div>
	<!-- 显示服务器返回的所有错误信息 -->
	<s:actionerror/>
</div>
<s:form action="validate.action" method="post">
	<s:textfield name="username" label="用户名"></s:textfield>
	<s:password name="password" label="密码"></s:password>
	<s:password name="confirmPassword" label="确认密码"></s:password>
	<s:submit value="提交"></s:submit>
</s:form>
```

```xml
<package name="default" namespace="/" extends="struts-default">
	<action name="validate" class="com.znsd.struts.action.ValidateAction">
		<result>success.jsp</result>
		<!-- 指定校验失败后返回的页面 -->
		<result name="input">validateLogin.jsp</result>
	</action>
</package>
```

#### 练习-validate()

使用validate()方式实现用户信息验证。

![20180106104132](http://www.znsd.com/znsd/courses/uploads/72eee7cb3b58bc7e275dc3b3d9e5413d/20180106104132.png)

#### validateXxx()方法

- 调用Action类中有多个业务方法时，每次执行对应的action方法，validate()都会执行。如果只想为某个action方法指定一些独有的验证规则，那么我们就需要validateXxx()方式验证了。
- 采用validateXxx()方法 `Xxx`指定需要处理指定的请求方法。

`Xxx=指定处理请求的方法名称，首字母大写。`

#### validateXxx()方法使用

```java
public class ValidateAction extends ActionSupport {

	private static final long serialVersionUID = 1L;

	private String username;
	private String password;
	private String confirmPassword;

	public String register() throws Exception {
		return SUCCESS; // 验证成功
	}

	public void validateRegister() {
		if (username == null || username.equals("")) {
			// 验证出错，指定错误提示信息
			this.addFieldError("username", "用户名不能为空");
		}
		if (password == null || password.equals("")) {
			this.addFieldError("password", "密码不能为空");
		}
		if (confirmPassword == null || confirmPassword.equals("")) {
			this.addFieldError("confirmPassword", "确认密码不能为空");
		}
		if (!password.equals(confirmPassword)) {
			// 验证出错，指定ActionError错误提示信息
			this.addActionError("两次密码不一致");
		}
	}
}
```

#### 数据校验小结 

- 在代码中validate()方法始终会被执行
- 在代码中validateXxx()方法会先于validate()方法执行
- validate()一般实现公共的验证规则。ValidateXxx()用于实现限定的验证规则。

```java
public class RegisterAction extends ActionSupport{
	
  	// validate()一般实现公共的验证规则。ValidateXxx()用于实现限定的验证规则。
	public void validate() {
		// 后执行validate方法
	}
	public void validateRegist() {
		// 先执行validateRegist方法
	}
	public String  regist(){
		return SUCCESS;
	}
}

```



#### 学员操作：实现对用户注册的校验

- 需求说明：使用validateXxx()方法实现对用户注册的数据校验

![image](http://www.znsd.com/znsd/courses/uploads/ca295a9e85c35f5b5d8a051f1cd1dad0/image.png)

#### 为什么使用验证框架

使用validate()或者validateXxx()方法是否存在不足呢？

- 验证规则复杂时，实现过程无脑且繁琐。
- 导致Action类中代码臃肿。

`Struts 2为我们提供的验证框架专门用于解决验证问题。`

### Struts2的验证框架

- 验证框架
  - 集成日常开发常用的数据校验功能
  - 多种类型校验器的集合

| 校验器类型    | 校验器名称           | 说    明        |
| -------- | --------------- | ------------- |
| 必填校验器    | required        | 字段不能为空        |
| 必填字符串校验器 | requiredstring  | 字段值不能为空长度要大于0 |
| 字符串长度校验器 | stringlength    | 字段值的长度的范围     |
| 表达式效验器   | expression      | 判断两次输入的内容是否一致 |
| 正则表达式校验器 | regex           | 字段是否匹配一个正则表达式 |
| 字段表达式校验器 | fieldexpression | 字段必须满足一个逻辑表达式 |
| 日期校验器    | date            | 日期输入是否在指定的范围内 |
| 整数校验器    | int             | 字段的整数值的范围     |
| 双精度校验器   | double          | 字段值必须是双精度类型   |

`校验器的类型还有很多，教员可以提醒学员有兴趣的话通过课下查询相关资料，了解更详细的校验器内容`

- 使用验证框架的步骤

  - 编写Action
  - 配置Action
  - 编写表单
  - 编写验证文件和校验规则

- 编写Action

  ```java
  public class RegisterAction extends ActionSupport {

  	private User user; // 用户信息
  	private String confirmPassword; // 确认密码
  	public User getUser() {
  		return user;
  	}
  	public void setUser(User user) {
  		this.user = user;
  	}
  	public String getConfirmPassword() {
  		return confirmPassword;
  	}
  	public void setConfirmPassword(String confirmPassword) {
  		this.confirmPassword = confirmPassword;
  	}
  	
  	@Override
  	public String execute() throws Exception {
  		return super.execute();
  	}
  }
  ```

- 配置Action

  ```xml
  <package name="default" namespace="/" extends="struts-default">
  	<action name="register" class="com.znsd.struts.action.RegisterAction">
  		<result>success.jsp</result>
  		<result name="input">register.jsp</result>
  	</action>
  </package>
  ```

- 编写表单

  ```html
  <h2>用户注册</h2>
  <s:form action="register.action" method="post">
  	<s:textfield name="user.name" label="用户名"></s:textfield>
  	<s:password name="user.age" label="年龄"></s:password>
  	<s:password name="confirmPassword" label="确认密码"></s:password>
  	<s:submit value="提交"></s:submit>
  </s:form>
  ```

- 编写验证文件和校验规则

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE validators PUBLIC  
          "-//Apache Struts//XWork Validator 1.0.2//EN"  
          "http://struts.apache.org/dtds/xwork-validator-1.0.2.dtd">
  <validators>
  	<field name="user.name">
  		<field-validator type="requiredstring">
  			<param name="trim">true</param>
  			<message>用户名不能为空</message>
  		</field-validator>
  		<field-validator type="stringlength">
  			<param name="maxLength">10</param>
  			<param name="minLength">6</param>
  			<message>用户名长度须在${minLength}和${maxLength}之间</message>
  		</field-validator>
  	</field>
  </validators>
  ```

#### 验证规则文件

- 创建验证文件，验证文件的类型为xml格式
- 命名规则有两种方式
  1. ActionClassName-validation.xml
  2. ActionClassName-ActionName-validation.xml
- 存放位置：与Action位于同一包下

#### 验证规则文件

struts2的两种验证规则文件的作用是不同的。

- ActionClassName-validation.xml：对Action中所有的业务方法起作用。
- ActionClassName-ActionName-validation.xml：对Action中的某个业务方法起作用。

`如果两个文件同时存在，则两个文件都会起作用。`

#### 验证文件的执行顺序

如果存在多个验证规则文件，则会按照如下顺序执行。

- 父类Action-validation.xml
- 父类Action-ActionName-validatiton.xml
- Action-validation.xml
- Action-ActionName-validatiton.xml

#### 验证文件

struts2验证文件的格式

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE validators PUBLIC  
        "-//Apache Struts//XWork Validator 1.0.2//EN"  
        "http://struts.apache.org/dtds/xwork-validator-1.0.2.dtd">
<!-- 验证文件的根节点 -->
<validators>
	
</validators>
```

#### 编写验证规则

- 用户名：不能为空，长度在6和10之间

```xml
<validators>
	<field name="user.name">
		<field-validator type="requiredstring">
			<param name="trim">true</param>
			<message>用户名不能为空</message>
		</field-validator>
		<field-validator type="stringlength">
			<param name="maxLength">10</param>
			<param name="minLength">6</param>
			<message>用户名长度须在${minLength}和${maxLength}之间</message>
		</field-validator>
	</field>
</validators>
```

- 密码：不能为空，密码长度>=6,密码和确认密码必须一致 

  ```xml
  <validators>
  	<field name="user.password">
  		<field-validator type="requiredstring">
  			<param name="trim">true</param>
  			<message>密码不能为空</message>
  		</field-validator>
  		<field-validator type="stringlength">
  			<param name="maxLength">10</param>
  			<param name="minLength">6</param>
  			<message>密码长度须在${minLength}和${maxLength}之间</message>
  		</field-validator>
  		<field-validator type="fieldexpression">
  			<param name="expression">user.password==confirmPassword</param>
  			<message>密码和确认密码必须相同</message>
  		</field-validator>
  	</field>
  </validators>
  ```

- 验证电话号码：不能为空，符合电话号码格式

  ```xml
  <validators>
  	<field name="user.mobilePhone">
  		<field-validator type="requiredstring">
  			<param name="trim">true</param>
  			<message>手机号码不能为空</message>
  		</field-validator>
  		<field-validator type="regex">
  			<param name="regex"><![CDATA[^[1]([3][0-9]{1}|59|58|88|89)[0-9]{8}$]]></param>
  			<message>手机号码格式不正确</message>
  		</field-validator>
  	</field>
  </validators>
  ```

- 效验规则

  - 字段优先：

    ```xml
    <field name="email_address"> 
        <field-validator type="required"> 
            <message>邮箱必填.</message> 
        </field-validator> 
        <field-validator type="email"> 
            <message>邮件格式不正确.</message> 
        </field-validator> 
    </field> 
    ```

    ​

  - 规则优先：

    ```xml
    <validator type="required"> 
        <param name="fieldName">email_address</param> 
        <message>邮箱必填</message> 
    </validator> 
    <validator type="email"> 
        <param name="fieldName">email_address</param> 
        <message>邮件格式不正确.</message> 
    </validator>
    ```

    ```xml
    <validator type="required">
    	<param name="fieldName">user.age</param>
    	<message>年龄不能为空</message>
    </validator>
    <validator type="int">
    	<param name="fieldName">user.age</param>
    	<param name="max">150</param>
    	<param name="min">1</param>
    	<message>年龄长度须在${min}和${max}之间</message>
    </validator>
    ```

#### 显示内容的国际化

  XML文件中的提示信息有两种方式指定：

  - \<message>提示信息</message>    （不支持国际化）
  - \<message key="key" />（支持国际化）

#### 客户端效验

  - 目前的效验必须提交到服务器才会生效。那么能不能实现客户端验证呢？（不常用了解即可）
  - Struts2中实现客户端验证非常简单，只需两步：
    - 使用Struts标签来生成页面。
    - 在\<s:form\>标签中添加validate=true属性即可。
  - 客户端效验注意：
    - Struts2有一个属性theme，不要将其指定为simple。
    - 不是所有的效验规则都支持客户端效验。只有一下验证规则支持客户端效验。`required,requiredstring,stringlength,regex,email,url,int,double`
    - 如果指定了国际化效验规则，必须是有全局的国际化方式。

#### 数据验证流程

![image](http://www.znsd.com/znsd/courses/uploads/3efe501ae617d7a16e69699379e0d1d2/image.png)

### 学员操作

- 功能：实现对用户注册的校验
- 需求说明：使用验证框架实现用户注册的数据校验

![image](http://www.znsd.com/znsd/courses/uploads/2cb1f371ff62928a4d8cdd574657fad5/image.png)![image](http://www.znsd.com/znsd/courses/uploads/1ed983ffcbecbd9b0026da431d789bd2/image.png)



### 小结

- Struts2提供三种数据效验方式
  - validate()
  - validateXxx()
  - 效验框架
- 添加错误方法
  - addFieldError()：添加字段错误。
  - addActionError()：添加Action错误。
- 显示错误信息
  - \<s:fielderror />：显示字段错误。
  - \<s:actionerror />：显示Action错误。
- 验证框架命名：
  - Action-validation.xml
  - Action-ActionName-validatiton.xml

### 总结

- Struts2中实现国际化
- Struts2类型类型转换器
- validate()方法与validateXxx()方法是实现数据校验的两种方式
  - validate()方法会始终执行
  - validateXxx()方法会先于validate()方法执行，并对指定方法的请求进行处理
- 验证框架实现方式。