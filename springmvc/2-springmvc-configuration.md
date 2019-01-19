## 第二章     Spring MVC基本配置 

### 本章目标 

- @Controlol注解
- @RequestMaping注解
- Servlet API
- 请求参数的处理
- 返回结果的处理

###  为什么使用注解 

- 目前越来越多的主流框架都支持注解，同样Spring也支持基于注解的"零配置"。 
- 注解相比XML的优势： 
  - 它可以充分利用 Java 的反射机制获取类结构信息，这些信息可以有效减少配置的工作。
  - 注解和 Java 代码位于一个文件中，更加便于维护。
  - `注意：必须在Spring 2.5版本后才能使用注解。`

### 使用注解 

**注解方式将Bean的定义信息和Bean实现类结合在一起，Spring提供的注解有**

- @Component：一个普通的Bean类。
- @Repository  ：用于标注持久层DAO类
- @Service  ：用于标注业务层类
- @Controller  ：用于标注控制器类

**示例**

```java
// 与在XML配置文件中编写<bean id="userDao" class="dao.impl.UserDao" /> 等效
@Repository("userDao") // Spring有默认的命名策略，使用非限定类名，第一个字母小写，也可以在注解中使用value属性指定组件的名称。
public class UserDao implements IDao {
    
}
```

#### @Controller 

- 作用：将当前类作为一个控制器类

- 如果使用注解方式，必须在Spring中添加自动扫描的路径。

  ```xml
  <!-- 配置Spring MVC自动扫描的路径 -->
  <context:component-scan base-package="com.znsd.controller" />
  ```

- 不适用注解，手动添加控制器的路径  

  ```xml
  <!-- 手动添加控制器的路径 -->
  <bean class="com.lxit.controller.MyController"/>
  ```


#### @RequestMapping

- Spring MVC使用@RequestMapping注解为控制器指定请求的URL。
- 在控制器的类定义及方法定义处都可以标记。 
  - 类定义处：提供初步的映射信息，为该类下所有请求方法添加前缀。
  - 方法定义处：提供进一步的映射信息，提供方法的请求路径。
- DispacherServlet截获请求后，就通过控制器上的@RequestMapping提供的映射信息确认请求所对应的处理方法。

#### @RequestMapping示例 

- 为类添加RequestMapping更改请求路径 

  ```java
  @Controller
  @RequestMapping("world")
  public class HelloWorld {	
  	@RequestMapping("/hello")
  	public String hello(){
  		System.out.println("hello spring mvc");
  		return "hello";
  	}
  }
  ```

- 访问请求路径

  ```http
  http://localhost:8080/SpringMVCDemo/world/hello
  ```

### HTTP请求 

- 标准的HTTP请求 路径。

  ![image](http://www.znsd.com/znsd/courses/uploads/e0010fa34fdfd5c51e6ba287c58e4980/image.png)

### 映射请求参数，请求方法和请求头 

- @RequestMapping除了可以使用请求URL映射请求外，还可以使用请求方法，请求参数和请求头映射请求。 
- @RequestMapping的value、method、params及heads分别表示请求url，请求方法，请求参数及请求头的映射条件，他们之间是与的关系，联合使用多个条件可以让请求更加精确化。 
- params和headers支持简单的表达式。
  - param1：表示请求必须包含param1的请求参数。
  - !param1：表示请求不能包含param1的请求参数。
  - param1!=value1：表示请求参数param1不能等于value1。
  - {"param1=value1","param2"}：表示请求参数param1必须等于value1，必须包含请求参数param2。

### 请求方法，请求参数，请求头示例 

- 设置请求地址为test1，以post方式提交，必须带一个参数userid 

  ```java
  @RequestMapping(value="/test1", method = RequestMethod.POST, params = "userid")
  public String test1(){
  	System.out.println("test1");
  	return "hello";
  }
  ```

- 设置请求地址为test2，请求头contenttype属性必须以text/开头。

  ```java
  @RequestMapping(value = "/test2", headers = "contentType=text/*")
  public String test2(){
  	System.out.println("test2");
  	return "hello";
  }
  ```

### 使用@RequestMapping映射请求

- @RequestMapping还支持Ant风格的URL。 

- Ant支持3中通配符 

  - ?：匹配文件中一个字符。
  - *：匹配文件中任意字符。
  - **：匹配多层路径。

  ```http
  /user/*/create：匹配/user/aaa/create,/user/bbb/crate
  /user/**/create：匹配/user/create,/user/aaa/bbb/create
  /user/create??：匹配/user/createaa,/user/createbb
  ```

### 参数的处理 

- @PathVariable：URL模版方式
- @RequestParam：获取请求参数
- @RequestHeader：获取请求头内容

#### @PathVariable

- @PathVariable：用来映射URL中的占位符。映射的变量名必须和占位符中的名称一致。

  ```java
  @RequestMapping("/delete/{userid}")
  public String delete(@PathVariable("userid")int userid) {
  	System.out.println("userid=" + userid);
  	return "hello";
  }
  ```

  ![20180705161846](http://www.znsd.com/znsd/courses/uploads/cbdbbf3136539d01dfb49f8dad6d6d6a/20180705161846.png)

#### @RequestParam 

- @RequtParam：获取页面传递过来的参数，GET和POST都支持。 

  ```java
  @RequestMapping("/testRequestParam")
  public String testRequestParam(@RequestParam("username")String username, @RequestParam("age")int age){
  	System.out.println("username=" + username);
  	System.out.println("age=" + age);
  	return "hello";
  }
  ```

  ![20180705162050](http://www.znsd.com/znsd/courses/uploads/cbab0cf628991d4e40be6d730f8a467c/20180705162050.png)

#### @RequestParam  

RequestParam有三个属性： 

- value：指定参数的名称
- required：指定参数是否为必填
- defaultValue：指定参数的默认值

`当参数与传递的参数同名时，可以省略@Requestparam `

#### @RequestHeader 

- 请求头包含了若干的属性，用来获取客户端的信息。通过@RequestHeader可以用来获取请求头中的信息 

  ```java
  @RequestMapping("/testRequestHeader")
  public String testRequestHeader(@RequestHeader("Accept-Language") String language){
  	System.out.println("language=" + language);
  	return "hello";
  }
  ```

  ![20180705162244](http://www.znsd.com/znsd/courses/uploads/895b3b724ea409c3b32827a2db58b1e3/20180705162244.png)

#### @CookieValue

- @CookieValue：用来获取客户端Cookie信息。

  ```java
  @RequestMapping("/testCookieValue")
  public String testCookieValue(@CookieValue("JSESSIONID")String sessionid){
  	System.out.println("sessionid=" + sessionid);
  	return "hello";
  }
  ```

  ![20180705162449](http://www.znsd.com/znsd/courses/uploads/5d16b981afdbec158dc8df7267e94a4b/20180705162449.png)

### 实体对象绑定请求参数 

- Spring MVC会直接将页面元素和实体对象进行匹配，自动转换为实体对象。并且支持级联属性。如address.city等。

  ```html
  <form action="world/user/create" method="post">
  	姓名：<input type="text" name="username"><br>
  	密码：<input type="text" name="userpass"><br>
  	年龄：<input type="text" name="age"><br>
  	<input type="submit" value="提交" />
  </form>
  ```

  ```java
  public class User {
  	private String username;
  	private String userpass;
  	private int age;
  }
  ```

  ```java
  @RequestMapping(value = "/user/create", method = RequestMethod.POST)
  public String createUser(User user) {
  	System.out.println(user.toString());
  	return "hello";
  }
  ```

### 练习：SpringMVC实现用户注册 

使用Spring MVC实现用户注册 

### 小结  

- 从页面传递参数的方式
- @PathVariable
- @RequestParam
- @RequestHeader
- @CookieValue
- POJO

### Servlet API 

**Spring MVC可以使用Servlet API作为请求方法的参数。**

- `HttpServletRequest`
- `HttpServletResponse`
- `HttpSession`
- Local
- InputStream
- OutputStream
- Read
- Write

#### 示例

- 将ServletAPI作为方法的参数，方法中就可以使用api所对应的方法。

  ```java
  @RequestMapping("/testServletAPI")
  public String testServletAPI(HttpServletRequest request,
  HttpServletResponse response,HttpSession session){
  	return "hello";
  }
  ```

**org.springframework.web.servlet.mvc.annotation.ServletHandlerMethodInvoker源码分析**

```java
@Override
protected Object resolveStandardArgument(Class<?> parameterType, NativeWebRequest webRequest) throws Exception {
    HttpServletRequest request = webRequest.getNativeRequest(HttpServletRequest.class);
    HttpServletResponse response = webRequest.getNativeResponse(HttpServletResponse.class);

    if (ServletRequest.class.isAssignableFrom(parameterType) ||
        MultipartRequest.class.isAssignableFrom(parameterType)) {
        Object nativeRequest = webRequest.getNativeRequest(parameterType);
        if (nativeRequest == null) {
            throw new IllegalStateException(
                "Current request is not of type [" + parameterType.getName() + "]: " + request);
        }
        return nativeRequest;
    }
    else if (ServletResponse.class.isAssignableFrom(parameterType)) {
        this.responseArgumentUsed = true;
        Object nativeResponse = webRequest.getNativeResponse(parameterType);
        if (nativeResponse == null) {
            throw new IllegalStateException(
                "Current response is not of type [" + parameterType.getName() + "]: " + response);
        }
        return nativeResponse;
    }
    else if (HttpSession.class.isAssignableFrom(parameterType)) {
        return request.getSession();
    }
    else if (Principal.class.isAssignableFrom(parameterType)) {
        return request.getUserPrincipal();
    }
    else if (Locale.class == parameterType) {
        return RequestContextUtils.getLocale(request);
    }
    else if (InputStream.class.isAssignableFrom(parameterType)) {
        return request.getInputStream();
    }
    else if (Reader.class.isAssignableFrom(parameterType)) {
        return request.getReader();
    }
    else if (OutputStream.class.isAssignableFrom(parameterType)) {
        this.responseArgumentUsed = true;
        return response.getOutputStream();
    }
    else if (Writer.class.isAssignableFrom(parameterType)) {
        this.responseArgumentUsed = true;
        return response.getWriter();
    }
    return super.resolveStandardArgument(parameterType, webRequest);
}
```

### 处理模型数据

**Spring MVC提供一下几种途径返回模型数据：**

- ModeAndView：将处理方法的返回类型设置为ModeAndView，方法体即可通过该模型对象添加模型数据。
- Map及Model形参：当形参为Map，Model,ModelMap时，处理方法返回时，Map中的数据会自动添加到模型中。
- @SessionAttributes：将模型中的某个属性存储到Session中，以便多个请求之间共享这个属性。
- @ModelAttribute：方法形参标记该注解后，形参对象就会放到模型中。

#### @ModelAndView 

- 控制器处理方法如果返回ModelAndView，即包含视图信息，也包含模型信息。 

- 构造方法：提供了多种构造方法的重载 

- 添加模型数据：

  - ModelAndView addObject(String attributeName, Object attributeValue);
  - ModelAndView addAllObjects(Map<String, ?> modelMap) ;

- 添加视图

  - void setView(View view);
  - void setViewName(String viewName);

  ```java
  @RequestMapping("/testModelAndView")
  public ModelAndView testModelAndView(){
  	ModelAndView modelAndView = new ModelAndView("hello");
  	//添加单个值
  	modelAndView.addObject("h","Hello Spring MVC");		
  	return modelAndView;
  }
  ```


#### Map形参 

- Spring MVC在内部使用了一个Model接口存储模型数据。

- Spring MVC在调用方法前会创建一个隐含的模型对象作为数据模型的存储容器。如果传入的参数为Map或者Model类型，SpringMVC会自动将对象保存到模型数据中。

  ```java
  @RequestMapping("/testMap")
  public String testMap(Map<String,Object> map){
  	map.put("mapdata", "map data");
  	return "hello";
  }
  ```

#### @SessionAttributes

- 如果希望在多个请求之间共享某个模型的数据，则可以在控制器类上标注一个@SessionAttributes，SpringMVC会将对应的属性存储到Session中。 
- @SessionAttributes除了可以通过属性名指定需要放到会话中的属性外，还可以通过模型属性的对象类型指定哪些类型放到Session中。 
  - @SessionAttributes(types=User.class) ：将隐含模型中所有类型为User属性添加到Session中。
  - @SessionAttributes(value={"user1","user2"})：将user1对象和user2放入Session中。
  - @SessionAttributes(types={User.class,Dept.class})
  - @SessionAttributes(value={"user1","user2"},types={Dept.class})：
- @SessionAttributes只能用来修饰类。

#### @SessionAttributes 

- 保存用户到Session中

  ```java
  @SessionAttributes("user")
  @Controller
  @RequestMapping("world")
  public class HelloWorld {
  	@RequestMapping("/testSession")
  	public String testSession(Map<String,Object> map){
  		User user = new User();
  		user.setUsername("zhangsan");
  		user.setUserpass("123");
  		user.setAge(20);
  		map.put("user", user);
  		return "hello";
  	}
  }
  ```

- `@SessionAttributes注解只能放在类的前面，而不能放在方法前。`

#### @ModelAttribute

- 在方法定义上定义@ModelAttribute注解： 
  - SpringMVC调用方法前，会逐个调用方法上标注了@ModelAttributes的方法。
  - 将@ModelAttributes中的属性保存到map中，可以在执行表单提交生成对象之前，替换执行方法同名的形参。
- 在方法的形参上定义@ModelAttribute注解： 
  - 可以从隐含对象中获取隐含的模型中获取对象，再将请求参数绑定到对象中，再传入形参。
  - 将方法形参对象添加到模型中。
- 运行流程： 
  - 执行@ModelAttribute注解修饰的方法：从数据库中取出对象，把对象放入到Map中，键为：user
  - Spring MVC 从Map中取出User对象，并把表单的请求参数赋给该User对象对应的属性。
  - Spring MVC 把上述对象传入目标方法的参数。参数名称必须和@ModelAttribute 的Map中保存的user对象同名。

#### @ModelAttribute 例子

```java
@ModelAttribute
public User getUser(){
	User user = new User();
	System.out.println("调用 getUser 方法");
	//默认保存名字为类名首字母小写的user对象到Request中
	return user;
}

@ModelAttribute
public void getUserById(Integer id,Map<String,Object> map){
	User myuser = new User();
	map.put("myuser", myuser);
	//手动指定user对象的名称，到Request中
	System.out.println("调用 getUser 方法");
}

@RequestMapping("/testModelAttribute")
public String testModelAttribute(@ModelAttribute("user")User user){
	System.out.println(user);
	return "hello";
}

```

#### 由@SessionAttributes引发的异常 

- 当类使用@SessionAttributes修饰，而方法中使用了和SessionAttributes修饰同名的映射参数，确没有添加@ModelAttribute修饰时，则会报错。 

  ![image](http://www.znsd.com/znsd/courses/uploads/6eada1dfa6b248aff7d7feaed4ab3769/image.png)

解决方案 

- 参数前使用@ModelAttribute修改映射的名称。
- 和@SessionAttributes中的名称不同。

### 总结 

- @Controlol注解
- @RequestMaping注解
- Servlet API
- 请求参数的处理
- 返回结果的处理