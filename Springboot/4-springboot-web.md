# 第四章 SpringBoot web开发

## 1、简介

使用SpringBoot;

1)、创建SpringBoot应用，选中我们需要的模块；

2)、SpringBoot已经默认将这些场景配置好了，只需要在配置文件中指定少量配置就可以运行起来

3)、自己编写业务代码

**自动配置原理？**

这个场景的SpringBoot帮我们配置了什么？能不能修改？能修改那些配置？能不能扩展？xxx

```java
xxxAutoConfiguration:帮我们给容器中自动配置组件
xxxProperties:配置类来封装配置文件的内容
```

## 2、静态资源文件映射规则

```java
@ConfigurationProperties(prefix = "spring.resources", ignoreUnknownFields = false)
public class ResourceProperties implements ResourceLoaderAware, InitializingBean {
    //可以设置和静态资源相关的参数，缓存时间等
```

```java
@Override
public void addResourceHandlers(ResourceHandlerRegistry registry) {
   if (!this.resourceProperties.isAddMappings()) {
      logger.debug("Default resource handling disabled");
      return;
   }
   Integer cachePeriod = this.resourceProperties.getCachePeriod();
   if (!registry.hasMappingForPattern("/webjars/**")) {
      customizeResourceHandlerRegistration(registry
            .addResourceHandler("/webjars/**")
            .addResourceLocations("classpath:/META-INF/resources/webjars/")
            .setCachePeriod(cachePeriod));
   }
   String staticPathPattern = this.mvcProperties.getStaticPathPattern();
   if (!registry.hasMappingForPattern(staticPathPattern)) {
      customizeResourceHandlerRegistration(
            registry.addResourceHandler(staticPathPattern)
                  .addResourceLocations(
                        this.resourceProperties.getStaticLocations())
                  .setCachePeriod(cachePeriod));
   }
}
```

### 1、webjar

1)、所有的/webjars/**，都去classpath:/META-INF/resources/webjars/找资源；

	webjars：以jar包的方式引入静态资源

http://www.webjars.org/

![12.jquery](assets/12.jquery.jpg)

localhost:8080/webjars/jquery/3.3.1/jquery.js

### 2、本地资源

```
private String staticPathPattern = "/**";
```

访问任何资源

2、会在这几文件夹下去找静态路径（静态资源文件夹）

```
"classpath:/META-INF/resources/", 
"classpath:/resources/",
"classpath:/static/", 
"classpath:/public/",
"/";当前项目的根路径
```

![13.static](assets/13.static.jpg)

localhost:8080/abc ==>去静态资源文件夹中找abc

![14.static-css](assets/14.static-css.jpg)

3、index页面欢迎页，静态资源文件夹下所有的index.html页面；被“/**”映射；

localhost:8080/  -->index页面

```JAVA
@Bean
public WelcomePageHandlerMapping welcomePageHandlerMapping(
      ResourceProperties resourceProperties) {
   return new WelcomePageHandlerMapping(resourceProperties.getWelcomePage(),
         this.mvcProperties.getStaticPathPattern());
}
```

4、喜欢的图标，即网站title的图标favicon

```java
@Configuration
@ConditionalOnProperty(value = "spring.mvc.favicon.enabled", matchIfMissing = true)
public static class FaviconConfiguration {

   private final ResourceProperties resourceProperties;

   public FaviconConfiguration(ResourceProperties resourceProperties) {
      this.resourceProperties = resourceProperties;
   }

   @Bean
   public SimpleUrlHandlerMapping faviconHandlerMapping() {
      SimpleUrlHandlerMapping mapping = new SimpleUrlHandlerMapping();
      mapping.setOrder(Ordered.HIGHEST_PRECEDENCE + 1);
       //把任何favicon的图标都在静态文件夹下找
      mapping.setUrlMap(Collections.singletonMap("**/favicon.ico",
            faviconRequestHandler()));
      return mapping;
   }

   @Bean
   public ResourceHttpRequestHandler faviconRequestHandler() {
      ResourceHttpRequestHandler requestHandler = new ResourceHttpRequestHandler();
      requestHandler
            .setLocations(this.resourceProperties.getFaviconLocations());
      return requestHandler;
   }

}
```

可以在配置文件配置静态资源文件夹

```properties
spring.resources.static-locations=classpath:xxxx
```

## 3、模板引擎

将html和数据 结合到一起 输出组装处理好的新文件

SpringBoot推荐Thymeleaf;语法简单，功能强大

### 1、引入thymeleaf 3

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>
```

默认导入thymeleaf2，版本太低 所以使用thymeleaf3.

[官方导入办法](https://docs.spring.io/spring-boot/docs/1.5.12.RELEASE/reference/htmlsingle/#howto-use-thymeleaf-3)

```xml
<properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    <java.version>1.8</java.version>
    <!--thymeleaf 3的导入-->
    <thymeleaf.version>3.0.9.RELEASE</thymeleaf.version>
    <!--布局功能支持 同时支持thymeleaf3主程序 layout2.0以上版本  -->
    <!--布局功能支持 同时支持thymeleaf2主程序 layout1.0以上版本  -->
    <thymeleaf-layout-dialect.version>2.2.2</thymeleaf-layout-dialect.version>
</properties>
```

### 2、Thymeleaf使用和语法

```java
@ConfigurationProperties(prefix = "spring.thymeleaf")
public class ThymeleafProperties {

   private static final Charset DEFAULT_ENCODING = Charset.forName("UTF-8");

   private static final MimeType DEFAULT_CONTENT_TYPE = MimeType.valueOf("text/html");

   public static final String DEFAULT_PREFIX = "classpath:/templates/";

   public static final String DEFAULT_SUFFIX = ".html";
   //只要把HTML文件方法类路径下的template文件夹下，就会自动导入
```

只要把HTML页面放到classpath:/templates/,thymeleaf就能自动渲染；

使用：

1、导入thymeleaf的名称空间

```html
<html xmlns:th="http://www.thymeleaf.org">    
```

2、使用thymeleaf语法；

```html
<!DOCTYPE html>
<html lang="en"  xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8" />
    <title>success</title>
</head>
<body>
<h1>success</h1>
<!--th:text 将div里面的文本内容设置为-->
<div th:text="${Lion}">
前端数据
</div>
</body>
</html>
```

3、语法规则

1）、th:text="${hello}"可以使用任意标签 替换原生的任何属性

**在SpringBoot的环境下**

```html
<div id="testid" class="testcalss" th:id="${Lion}" th:class="${Lion}" th:text="${Lion}">
	前端数据
</div>
```

![15.thtmeleaf-th01](assets/15.thtmeleaf-th01.jpg)

**直接访问HTML页面**

![15.thtmeleaf-th02](assets/15.thtmeleaf-th02.jpg)

**2)、内联写法注意需要在body上加上 th:inline="text"敲黑板**

不然不起作用

```html
<body class="text-center" th:inline="text"></body>
```

th标签的访问优先级

Order Feature Attributes

### 3、语法规则

|      | 功能                            | 标签                                 | 功能和jsp对比                             |
| ---- | ------------------------------- | ------------------------------------ | ----------------------------------------- |
| 1    | Fragment inclusion              | th:insert th:replace                 | include(片段包含)                         |
| 2    | Fragment iteration              | th:each                              | c:forEach(遍历)                           |
| 3    | Conditional evaluation          | th:if th:unless th:switch th:case    | c:if(条件判断)                            |
| 4    | Local variable definition       | th:object  th:with                   | c:set(声明变量)                           |
| 5    | General attribute modification  | th:attr th:attrprepend th:attrappend | 属性修改支持前面和后面追加内容            |
| 6    | Specific attribute modification | th:value th:href th:src ...          | 修改任意属性值                            |
| 7    | Text (tag body modification)    | th:text th:utext                     | 修改标签体内容utext：不转义字符<h1>大标题 |
| 8    | Fragment specification          | th:fragment                          | 声明片段                                  |
| 9    | Fragment removal                | th:remove                            |                                           |

 

```properties
Simple expressions:(表达式语法)
    Variable Expressions: ${...}
    	1、获取对象属性、调用方法
    	2、使用内置基本对象：
    	    #ctx : the context object.
            #vars: the context variables.
            #locale : the context locale.
            #request : (only in Web Contexts) the HttpServletRequest object.
            #response : (only in Web Contexts) the HttpServletResponse object.
            #session : (only in Web Contexts) the HttpSession object.
            #servletContext : (only in Web Contexts) the ServletContext object.
         3、内置一些工具对象
        	#execInfo : information about the template being processed.
        	#messages : methods for obtaining externalized messages inside variables expressions, in the same way as they
            would be obtained using #{…} syntax.
            #uris : methods for escaping parts of URLs/URIs
            #conversions : methods for executing the configured conversion service (if any).
            #dates : methods for java.util.Date objects: formatting, component extraction, etc.
            #calendars : analogous to #dates , but for java.util.Calendar objects.
            #numbers : methods for formatting numeric objects.
            #strings : methods for String objects: contains, startsWith, prepending/appending, etc.
            #objects : methods for objects in general.
            #bools : methods for boolean evaluation.
            #arrays : methods for arrays.
            #lists : methods for lists.
            #sets : methods for sets.
            #maps : methods for maps.
            #aggregates : methods for creating aggregates on arrays or collections.
            #ids : methods for dealing with id attributes that might be repeated (for example, as a result of an iteration).
    Selection Variable Expressions: *{...} //选择表达式：和${}功能一样，补充功能
   # 配合th:object使用，object=${object} 以后获取就可以使用*{a}  相当于${object.a}
  	    <div th:object="${session.user}">
            <p>Name: <span th:text="*{firstName}">Sebastian</span>.</p>
            <p>Surname: <span th:text="*{lastName}">Pepper</span>.</p>
            <p>Nationality: <span th:text="*{nationality}">Saturn</span>.</p>
		</div>
    Message Expressions: #{...} //获取国际化内容
    Link URL Expressions: @{...} //定义URL链接
    	#<a href="details.html" th:href="@{/order/details(orderId=${o.id})}">view</a>
    Fragment Expressions: ~{...}//片段文档
    
Literals（字面量）
    Text literals: 'one text' , 'Another one!' ,…
    Number literals: 0 , 34 , 3.0 , 12.3 ,…
    Boolean literals: true , false
    Null literal: null
    Literal tokens: one , sometext , main ,…
Text operations:(文本操作)
    String concatenation: +
    Literal substitutions: |The name is ${name}|
Arithmetic operations:（数学运算）
    Binary operators: + , - , * , / , %
    Minus sign (unary operator): -
Boolean operations:（布尔运算）
    Binary operators: and , or
    Boolean negation (unary operator): ! , not
Comparisons and equality:（比较运算）
    Comparators: > , < , >= , <= ( gt , lt , ge , le )
    Equality operators: == , != ( eq , ne )
Conditional operators:（条件运算）
    If-then: (if) ? (then)
    If-then-else: (if) ? (then) : (else)
    Default: (value) ?: (defaultvalue)
Special tokens:（空操作）
	No-Operation: _
```

inline写法

```html
[[]] -->th:text
[()] -->th:utext
```



## 4、SpringMVC自动配置

### 1、SpringMVC的自动导入

[Spring框架](https://docs.spring.io/spring-boot/docs/1.5.12.RELEASE/reference/htmlsingle/#boot-features-developing-web-applications)

自动配置好了mvc：

以下是SpringBoot对SpringMVC的默认

Spring Boot provides auto-configuration for Spring MVC that works well with most applications.

The auto-configuration adds the following features on top of Spring’s defaults:

- Inclusion of `ContentNegotiatingViewResolver` and `BeanNameViewResolver` beans.

  - 自动配置了ViewResolver(视图解析器：根据方法的返回值得到视图对象（View）,视图对象决定如何渲染（转发？重定向？）)
  - `ContentNegotiatingViewResolver`组合所有视图解析器
  - 如何定制：我们可以自己给容器中添加一个视图解析器；自动将其整合进来

- Support for serving static resources, including support for WebJars (see below).静态资源

- Static `index.html` support.

- Custom `Favicon` support (see below).

- 自动注册 了`Converter`, `GenericConverter`, `Formatter` beans.

  - `Converter`：类型转换 文本转为字面量

  - `Formatter` ：格式化器 转换后格式转换

    ```java
    @Bean
    @ConditionalOnProperty(prefix = "spring.mvc", name = "date-format")//在文件配置入职格式化的规则
    public Formatter<Date> dateFormatter() {
       return new DateFormatter(this.mvcProperties.getDateFormat());//日期格式化组件
    }
    ```

    自己添加的格式化转换器，只需要放在容器中即可

- Support for `HttpMessageConverters` (see below).

  - `HttpMessageConverters` ：转换HTTP转换和响应：User - json

  - `HttpMessageConverters` ：是从容器中确定；获取所有的`HttpMessageConverters`  ，将自己的组件注册在容器中@Bean 

  - If you need to add or customize converters you can use Spring Boot’s `HttpMessageConverters` class:

    ```java
    import org.springframework.boot.autoconfigure.web.HttpMessageConverters;
    import org.springframework.context.annotation.*;
    import org.springframework.http.converter.*;
    
    @Configuration
    public class MyConfiguration {
    
        @Bean
        public HttpMessageConverters customConverters() {
            HttpMessageConverter<?> additional = ...
            HttpMessageConverter<?> another = ...
            return new HttpMessageConverters(additional, another);
        }
    
    }
    ```

- Automatic registration of `MessageCodesResolver` (see below).

  - 定义错误代码生成规则

- Automatic use of a `ConfigurableWebBindingInitializer` bean (see below).

  - ```java
    @Override
    protected ConfigurableWebBindingInitializer getConfigurableWebBindingInitializer() {
       try {
          return this.beanFactory.getBean(ConfigurableWebBindingInitializer.class);
       }
       catch (NoSuchBeanDefinitionException ex) {
          return super.getConfigurableWebBindingInitializer();
       }
    }
    ```

    在beanFactory：中可以自己创建一个，初始化webDataBinder

    请求数据 ==》javaBean

If you want to keep Spring Boot MVC features, and you just want to add additional [MVC configuration](https://docs.spring.io/spring/docs/4.3.16.RELEASE/spring-framework-reference/htmlsingle#mvc) (interceptors, formatters, view controllers etc.) you can add your own `@Configuration` class of type `WebMvcConfigurerAdapter`, but **without** `@EnableWebMvc`. If you wish to provide custom instances of `RequestMappingHandlerMapping`, `RequestMappingHandlerAdapter` or `ExceptionHandlerExceptionResolver` you can declare a `WebMvcRegistrationsAdapter` instance providing such components.

If you want to take complete control of Spring MVC, you can add your own `@Configuration` annotated with `@EnableWebMvc`.

思想：修改默认配置

### 2、扩展SpringMVC

编写一个配置类，类型是WebMvcConfigurerAdapter(继承)，使用WebMvcConfigurerAdapter可以扩展，不能标注@EnableWebMvc;既保留了配置，也能拓展我们自己的应用

```java
@Configuration
public class MyMvcConfig extends WebMvcConfigurerAdapter {

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
//        super.addViewControllers(registry);
        //浏览器发送wdjr请求，也来到success页面
        registry.addViewController("/wdjr").setViewName("success");
    }
}
```

原理：

1）、WebMvcAutoConfiguration是SpringMVC的自动配置

2）、在做其他自动配置时会导入；@Import(EnableWebMvcConfiguration.class)

```java
@Configuration
public static class EnableWebMvcConfiguration extends DelegatingWebMvcConfiguration {
    private final WebMvcConfigurerComposite configurers = new WebMvcConfigurerComposite();

	//从容器中获取所有webMVCconfigurer
	@Autowired(required = false)
	public void setConfigurers(List<WebMvcConfigurer> configurers) {
		if (!CollectionUtils.isEmpty(configurers)) {
			this.configurers.addWebMvcConfigurers(configurers);
            
            	@Override
                protected void addViewControllers(ViewControllerRegistry registry) {
                    this.configurers.addViewControllers(registry);
                }
            //一个参考实现,将所有的webMVCconfigurer相关配置一起调用（包括自己的配置类）
            	@Override
               // public void addViewControllers(ViewControllerRegistry registry) {
                   // for (WebMvcConfigurer delegate : this.delegates) {
				 //delegate.addViewControllers(registry);
                    //}
                }
		}
	}
    
```



3）、自己的配置被调用

效果：SpringMVC的自动配置和我们的扩展配置都会起作用

### 3、全面接管mvc

不需要SpringBoot对SpringMVC的自动配置。

```java
@EnableWebMvc
@Configuration
public class MyMvcConfig extends WebMvcConfigurerAdapter {

@Override
public void addViewControllers(ViewControllerRegistry registry) {


//        super.addViewControllers(registry);
        //浏览器发送wdjr请求，也来到success页面
        registry.addViewController("/wdjr").setViewName("success");
    }
}
```

例如静态资源访问，不推荐全面接管

原理：

为什么@EnableWebMvc注解，SpringBoot对SpringMVC的控制就失效了

1）、核心配置

```java
@Import(DelegatingWebMvcConfiguration.class)
public @interface EnableWebMvc {
}
```

2）、DelegatingWebMvcConfiguration

```java
@Configuration
public class DelegatingWebMvcConfiguration extends WebMvcConfigurationSupport {
```

3）、WebMvcAutoConfiguration

```java
@Configuration
@ConditionalOnWebApplication
@ConditionalOnClass({ Servlet.class, DispatcherServlet.class,
      WebMvcConfigurerAdapter.class })
//容器没有这个组件的时候，这个自动配置类才生效
@ConditionalOnMissingBean(WebMvcConfigurationSupport.class)
@AutoConfigureOrder(Ordered.HIGHEST_PRECEDENCE + 10)
@AutoConfigureAfter({ DispatcherServletAutoConfiguration.class,
      ValidationAutoConfiguration.class })
public class WebMvcAutoConfiguration {
```

4）、@EnableWebMvc将WebMvcConfigurationSupport导入进来了；

5）、导入的WebMvcConfigurationSupport只是SpringMVC最基本的功能



## 5、修改SpringMVC默认配置

模式:

	1）、SpringBoot在自动配置很多组件的时候，先看容器中有没有用户自己配置的（@Bean、@Component）如果有就用用户配置的，如果没有，才自动配置；如果有些组件可以有多个（ViewResolver）将用户配置的和自己默认的组合起来；
	
	2）、在SpringBoot中会有 xxxConfigurer帮助我们扩展配置。

## 6、RestfulCRUD

### 1、默认访问首页

在config/MyConfig.java中编写配置类

```java
//所有的webMvcConfigurerAdapter组件会一起起作用
@Bean //註冊到容器去
public WebMvcConfigurerAdapter webMvcConfigurerAdapter(){
    WebMvcConfigurerAdapter adapter = new WebMvcConfigurerAdapter() {
        @Override
        public void addViewControllers(ViewControllerRegistry registry) {
            registry.addViewController("/").setViewName("login");
            registry.addViewController("/login.html").setViewName("login");
        }
    };
    return adapter;
}
```

静态资源引用

```html
<link href="#" th:href="@{/css/signin.css}" rel="stylesheet" />
```

### 2、国际化

1、编写国际化配置文件

2、使用ResourceBundleMessageSource管理国际化资源文件

3、在页面中使用fmt:message，取出国际化内容

#### 1、浏览器切换国际化

步骤

1、编写国际化配置文件，抽取页面需要的显示的国际化消息

![16.national](assets/16.national.jpg)

2、SpringBoot自动配置好了国际化配置的资源文件

```java
@ConfigurationProperties(prefix = "spring.messages")
public class MessageSourceAutoConfiguration {
    //我们的配置文件可以直接放在类路径下叫messages.properties
    private String basename = "messages";
    @Bean
	public MessageSource messageSource() {
		ResourceBundleMessageSource messageSource = new ResourceBundleMessageSource();
		if (StringUtils.hasText(this.basename)) {
            //设置国际化文件的基础名，去掉语言国家代码
			messageSource.setBasenames(StringUtils.commaDelimitedListToStringArray(
					StringUtils.trimAllWhitespace(this.basename)));
		}
		if (this.encoding != null) {
			messageSource.setDefaultEncoding(this.encoding.name());
		}
		messageSource.setFallbackToSystemLocale(this.fallbackToSystemLocale);
		messageSource.setCacheSeconds(this.cacheSeconds);
		messageSource.setAlwaysUseMessageFormat(this.alwaysUseMessageFormat);
		return messageSource;
	}
```

3、对IDEA的编码进行设置

![17.encoding](assets/17.encoding.jpg)

4、login进行标签插入

```html
<!DOCTYPE html>
<!-- saved from url=(0051)https://getbootstrap.com/docs/4.1/examples/sign-in/ -->
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <link rel="icon" href="https://getbootstrap.com/favicon.ico" />

    <title>登录页面</title>

    <!-- Bootstrap core CSS -->
    <link href="#" th:href="@{/css/bootstrap.min.css}" rel="stylesheet" />

    <!-- Custom styles for this template -->
    <link href="./login_files/signin.css" th:href="@{/css/signin.css}" rel="stylesheet" />
  </head>

  <body class="text-center">
    <form class="form-signin">
      <img class="mb-4" src="./login_files/bootstrap-solid.svg" th:src="@{/img/bootstrap-solid.svg}" alt="" width="72" height="72" />
      <h1 class="h3 mb-3 font-weight-normal" th:text="#{login.tip}">Please sign in</h1>
      <label  class="sr-only" th:text="#{login.username}">Username</label>
      <input type="text"  name="username" class="form-control" placeholder="Username" th:placeholder="#{login.username}" required="" autofocus=""/>
      <label for="inputPassword" class="sr-only" th:text="#{login.password}">Password</label>
      <input type="password" name="password" id="inputPassword" class="form-control" placeholder="Password" th:placeholder="#{login.password}" required="" />
      <div class="checkbox mb-3">
        <label>
          <input type="checkbox" value="remember-me" /> [[#{login.remember}]]
        </label>
      </div>
      <button class="btn btn-lg btn-primary btn-block" type="submit" th:text="#{login.btn}">Sign in</button>
      <p class="mt-5 mb-3 text-muted">© 2017-2018</p>
    </form>
  

</body></html>
```

效果根据浏览器语言的信息切换国际化

原理：

国际化locale（区域信息对象）；LocaleResolver(获取区域对象)；

```java
@Bean
@ConditionalOnMissingBean
@ConditionalOnProperty(prefix = "spring.mvc", name = "locale")
public LocaleResolver localeResolver() {
    if (this.mvcProperties
        .getLocaleResolver() == WebMvcProperties.LocaleResolver.FIXED) {
        return new FixedLocaleResolver(this.mvcProperties.getLocale());
    }
    AcceptHeaderLocaleResolver localeResolver = new AcceptHeaderLocaleResolver();
    localeResolver.setDefaultLocale(this.mvcProperties.getLocale());
    return localeResolver;
}            

```

默认的就是根据请求头带来的区域信息获取local国际化信息（截图就是这么犀利）

![18.accept-language](assets/18.accept-language.jpg)

#### 2、点击链接切换国际化

自己编写localResolver，加到容器中

1、更改HTML代码

```html
<p class="mt-5 mb-3 text-muted">© 2017-2018</p>
  <a href="#" class="btn btn-sm" th:href="@{/index.html?lg=zh_CN}">中文</a>
  <a href="#" class="btn btn-sm" th:href="@{/index.html?lg=en_US}">English</a>
```

2、新建一个MyLocaleResolver.class

```java
public class MyLocaleResolver implements LocaleResolver {

    //解析区域信息
    @Override
    public Locale resolveLocale(HttpServletRequest request) {
        String l = request.getParameter("lg");
        Locale locale = Locale.getDefault();
        if(!StringUtils.isEmpty(l)){
            String[] split = l.split("_");
            locale = new Locale(split[0], split[1]);
        }
        return locale;
    }

    @Override
    public void setLocale(HttpServletRequest request, HttpServletResponse response, Locale locale) {

    }
}
```

3、将MyLocaleResolver加入到容器中

```java
@Bean
public LocaleResolver localeResolver(){
    return new MyLocalResolver();
}
```

4、启动演示

### 3、登录拦截器

#### 1、登录

开发技巧

	1、清除模板缓存
	
	2、Ctrl+F9刷新

1、新建一个LoginController

```java
@Controller
public class LoginController {

    @PostMapping(value ="/user/login")
    public String login(@RequestParam("username")String username,
                        @RequestParam("password")String password,
                        Map<String,Object> map){
        if(!StringUtils.isEmpty(username) && "123456".equals(password)){
            //登录成功
            return "list";
        }else{
            map.put("msg", "用户名密码错误");
            return "login";
        }

    }
}
```

2、登录错误消息显示

```html
<!--判断-->
<p style="color: red" th:text="${msg}" th:if="${not #strings.isEmpty(msg)}"></p>
```

3、表单重复提交

表单重复提交事件 --》重定向来到成功页面--》模板引擎解析

```java
if(!StringUtils.isEmpty(username) && "123456".equals(password)){
    //登录成功,防止重复提交
    return "redirect:/main.html";
}else{
    map.put("msg", "用户名密码错误");
    return "login";
}
```

模板引擎解析

```java
@Override
public void addViewControllers(ViewControllerRegistry registry) {
    registry.addViewController("/").setViewName("login");
    registry.addViewController("/index.html").setViewName("login");
    registry.addViewController("/main.html").setViewName("Dashboard");
}
```

### 4、拦截器

作用：实现权限控制，每个页面请求前中后，都会进入到拦截器进行处理（登录权限）

1、在component下新建一个LoginHandlerInterceptor拦截器

```java
public class LoginHandlerInterceptor implements HandlerInterceptor {

    //目标方法执行之前
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        Object user = request.getSession().getAttribute("loginUser");
        if(user!=null){
            //已经登录
            return true;
        }
        //未经过验证
        request.setAttribute("msg", "没权限请先登录");
        request.getRequestDispatcher("/index.html").forward(request, response);

        return false;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

    }
}
```

2、在MyMvcConfig配置中重写拦截器方法，加入到容器中

```java
//所有的webMvcConfigurerAdapter组件会一起起作用
@Bean //註冊到容器去
public WebMvcConfigurerAdapter webMvcConfigurerAdapter(){
    WebMvcConfigurerAdapter adapter = new WebMvcConfigurerAdapter() {
        @Override
        public void addViewControllers(ViewControllerRegistry registry) {
            registry.addViewController("/").setViewName("login");
            registry.addViewController("/index.html").setViewName("login");
            registry.addViewController("/main.html").setViewName("Dashboard");
        }
        //注册拦截器
        @Override
        public void addInterceptors(InterceptorRegistry registry) {
            //静态资源 css js img 已经做好了静态资源映射
            registry.addInterceptor(new LoginHandlerInterceptor()).addPathPatterns("/**").
                    excludePathPatterns("/index.html","/","/user/login");
        }
    };
    return adapter;
}
```

3、在LoginHandler中添加登录成功写入session

```java
@Controller
public class LoginController {

    @PostMapping(value ="/user/login")
    public String login(@RequestParam("username")String username,
                        @RequestParam("password")String password,
                        Map<String,Object> map,
                        HttpSession session){
        if(!StringUtils.isEmpty(username) && "123456".equals(password)){
            //登录成功,防止重复提交
            session.setAttribute("loginUser", username);
            return "redirect:/main.html";
        }else{
            map.put("msg", "用户名密码错误");
            return "login";
        }

    }
}
```

### 5、CRUD-员工列表

实验要求：

1）、RestfulCRUD：CRUD满足Rest风格

URI:/资源名称/资源标识+HTTP操作

|      | 普通CRUD                | RestfulCRUD       |
| ---- | ----------------------- | ----------------- |
| 查询 | getEmp                  | emp -- GET        |
| 添加 | addEmp?xxx              | emp --POST        |
| 修改 | updateEmp?id=xxx&xxx=xx | emp/{id} -- PUT   |
| 删除 | deleteEmp?id=1          | emp/{id} --DELETE |

2、实验的请求架构

|                | 请求URI  | 请求方式 |
| -------------- | -------- | -------- |
| 查询所有员工   | emps     | GET      |
| 查询某个员工   | emp/{id} | GET      |
| 添加页面       | emp      | GET      |
| 添加员工       | emp      | POST     |
| 修改页面(回显) | emp/{id} | GET      |
| 修改员工       | emp/{id} | PUT      |
| 删除员工       | emp/{id} | DELETE   |

3、员工列表

#### 1、公共页面抽取

使用方法

```html
1、抽取公共片段
<!--footer.html-->
<div id="footid" th:fragment="copy">xxx</div>
2、引入公共片段
<!--test.html-->
<div th:insert=~{footer::copy}></div>
~{templatename::selector} 模板名::选择器  footer::#footid
~{templatename::fragmentname} 模板名::片段名称 footer::copy
行内写法可以加~{xx::xx} 标签体可以 xx::xx
```



**三种引用方式**

**th:insert** :加个外层标签 +1

**th:replace** :完全替换 1

**th:include**：就替换里面的内容 -1

公共页面

```html
<body>
	...
    <div th:insert="footer :: copy"></div>
    <div th:replace="footer :: copy"></div>
    <div th:include="footer :: copy"></div>
</body>
```

结果

```html
<body>
...
    <!-- th:insert -->
    <div>
        <footer>
            &copy; 2011 The Good Thymes Virtual Grocery
        </footer>
    </div>
    <!--th:replace-->
    <footer>
   		&copy; 2011 The Good Thymes Virtual Grocery
    </footer>
    <!--th:include-->
    <div>
        &copy; 2011 The Good Thymes Virtual Grocery
    </div>
</body>
```

用此种方法将公共页面引入

#### 2、列表高亮

引入片段的时候传入参数，新建一个commons文件夹存储公共页面bar.html

模板引入变量名

dashboard

```html
<a class="nav-link active"
   th:class="${activeUri}=='main.html'?'nav-link active':'nav-link'"
   href="https://getbootstrap.com/docs/4.1/examples/dashboard/#" th:href="@{/main.html}">
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-home"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
    Dashboard <span class="sr-only">(current)</span>
</a>
```

员工管理

```html
<li class="nav-item">
    <a class="nav-link"
       th:class="${activeUri}=='emps'?'nav-link active':'nav-link'"
       href="https://getbootstrap.com/docs/4.1/examples/dashboard/#" th:href="@{/emps}">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-users"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
        员工管理
    </a>
```

引入模板的时候传入参数

dashboard.html引入

```html
<!--引入侧边栏-->
   <div th:replace="commons/bar :: sidebar(activeUri='main.html')"></div>
```

list.html引入

```html
<!--引入侧边栏-->
<div th:replace="commons/bar::sidebar(activeUri='emps')"></div>
```

### 6、列表数据显示（查）

#### 1、传入员工对象

EmployeeController类,传入员工对象

```java
@Controller
public class EmployeeController {

    @Autowired
    EmployeeDao employeeDao;
    /**
     * 查询所有员工返回列表页面
     */
    @GetMapping(value = "/emps")
    public String list(Model model){

        Collection<Employee> employees = employeeDao.getAll();
        model.addAttribute("emps",employees);
        return "emp/list";
    }
}
```

#### 2、 遍历对象

list.html中 使用模板的 `th:each`方法

```html
table class="table table-striped table-sm">
    <thead>
    <tr>
        <th>#</th>
        <th>lastName</th>
        <th>email</th>
        <th>gender</th>
        <th>department</th>
        <th>birth</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
        <tr th:each="emp:${emps}">
            <td th:text="${emp.id}">1</td>
            <td th:text="${emp.lastName}">1</td>
            <td th:text="${emp.email}">1</td>
            <td th:text="${emp.gender}">1</td>
            <td th:text="${emp.department.departmentName}">1</td>
            <td th:text="${#dates.format(emp.birth,'yyyy-MM-dd HH:mm:ss')}">1</td>
            <td>
                <button class="btn btn-sm btn-primary">编辑</button>
                <button class="btn btn-sm btn-danger">删除</button>
            </td>
        </tr>
    </tbody>
</table>
```

#### 3、效果显示

![19.table list](assets/19.table list.jpg)



### 7、员工添加（增）

功能：点击添加按钮，出现新增页面

#### 1、新增页面

```html
<form>
    <!-- LastName -->
    <div class="form-group">
        <label for="LastName">LastName</label>
        <input type="text" class="form-control" id="LastName"  placeholder="LastName">
    </div>
    <!-- Email -->
    <div class="form-group">
        <label for="Email">Email</label>
        <input type="email" class="form-control" id="Email"  placeholder="zhangsan@163.com">
    </div>
    <!--gender-->
    <div class="form-group">
        <label >Gender</label><br/>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="gender" value="1">
            <label class="form-check-label" >男</label>
        </div>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="gender" value="0">
            <label class="form-check-label" >女</label>
        </div>
    </div>
    <!-- department -->
    <div class="form-group">
        <label for="exampleFormControlSelect1">department</label>
        <select class="form-control" id="exampleFormControlSelect1">
            <option th:each="dept:${depts}" th:value="${dept.id}" th:text="${dept.departmentName}"></option>
        </select>
    </div>
    <!--Birth-->
    <div class="form-group">
        <label for="birthDate">Birth</label>
        <input type="text" class="form-control" id="birthDate" placeholder="2012-12-12">
    </div>
    <button type="submit" class="btn btn-primary">添 加</button>
</form>
```

#### 2、页面跳转

在EmployeeController中添加addEmpPage方法

```java
/**
 * 添加员工
 */
@GetMapping(value = "/emp")
public String toAddPage(Model model){
    //来到添加页面,查出所有部门显示
    Collection<Department> depts = departmentDao.getDepartments();
    model.addAttribute("depts",depts);
    return "emp/add";
}
```

关键点：在添加部门页面要遍历部门信息，所以在方法中出入部门信息

#### 3、添加功能完成

新建一个PostMapping

> ThymeleafViewResolver 查看redirect和forward,原生的sendredirect方法；

1、新建一个postMapping的方法用来接受页面的添加POST请求

```java
/**
 * 员工添加
 */
@PostMapping(value = "/emp")
public String addEmp(Employee employee){

    employeeDao.save(employee);
    //来到员工列表页面、redirect:重定向到一个地址，forward转发到一个地址
    return "redirect:/emps";
}
```

2、修改添加页面，添加name属性

```html
<form th:action="@{/emp}" method="post">
    <!-- LastName -->
    <div class="form-group">
        <label for="LastName">LastName</label>
        <input type="text" class="form-control" id="LastName" name="lastName" placeholder="LastName">
    </div>
    <!-- Email -->
    <div class="form-group">
        <label for="Email">Email</label>
        <input type="email" class="form-control" id="Email"  name="email" placeholder="zhangsan@163.com">
    </div>
    <!--gender-->
    <div class="form-group">
        <label >Gender</label><br/>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="gender" value="1">
            <label class="form-check-label" >男</label>
        </div>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="gender" value="0">
            <label class="form-check-label" >女</label>
        </div>
    </div>
    <!-- department -->
    <div class="form-group">
        <label >department</label>
        <select class="form-control"  name="department.id">
            <option th:each="dept:${depts}" th:value="${dept.id}" th:text="${dept.departmentName}"></option>
        </select>
    </div>
    <div class="form-group">
        <label for="birthDate">Birth</label>
        <input type="text" class="form-control" id="birthDate" placeholder="2012-12-12" name="birth">
    </div>
    <button type="submit" class="btn btn-primary">添 加</button>
</form>
```

1、部门对象问题？

```html
<select class="form-control"  name="department.id">
```

2、日期格式化？

属性中添加 date-formate 默认是 / 

```java
@Bean
@ConditionalOnProperty(prefix = "spring.mvc", name = "date-format")
public Formatter<Date> dateFormatter() {
   return new DateFormatter(this.mvcProperties.getDateFormat());
}

@Override
public MessageCodesResolver getMessageCodesResolver() {
   if (this.mvcProperties.getMessageCodesResolverFormat() != null) {
      DefaultMessageCodesResolver resolver = new DefaultMessageCodesResolver();
      resolver.setMessageCodeFormatter(
            this.mvcProperties.getMessageCodesResolverFormat());
      return resolver;
   }
   return null;
}
```

```properties
spring.mvc.date-format=yyyy-MM-dd
```

### 8、员工编辑（改）

思路使用add页面，并且数据回显，然后区分添加，PUT请求

#### 1、修改按钮

在list.html的`编辑`按钮加上链接

```html
<td>
    <a  href="#" th:href="@{/emp/}+${emp.id}" class="btn btn-sm btn-primary">编辑</a>
    <button class="btn btn-sm btn-danger">删除</button>
</td>
```

#### 2、编写跳转页面

跳转到员工编辑页面的Controller

```java
/**
 * 员工编辑页面
 */
@GetMapping(value = "/emp/{id}")
public String toEditPage(@PathVariable("id") Integer id ,Model model){
    Employee emp = employeeDao.getEmpById(id);
    Collection<Department> departments = departmentDao.getDepartments();
    model.addAttribute("emp",emp);
    model.addAttribute("depts",departments);
    return "emp/add";
}
   
```

#### 3、对页面修改

对add页面进行修改

1）、添加回显

2）、添加判断是否emp!=null（区分add or edit）

3）、添加put请求 --两个input的hidden标签

```html
 <form th:action="@{/emp}" method="post">
        <!--发送put请求-->
        <!--1.SpringMVC配置HiddenHttpMethodFilter
            2.页面创建一个post表单
            3.创建一个 input name_method 值就是我们请求的方式-->
        <input type="hidden" name="_method" value="put" th:if="${emp!=null}">

        <input type="hidden" name="id" th:value="${emp.id}" th:if="${emp!=null}">
        <!-- LastName -->
        <div class="form-group">
            <label for="LastName">LastName</label>
            <input type="text" class="form-control" id="LastName" name="lastName" placeholder="LastName" th:value="${emp!=null}?${emp.lastName}">
        </div>
        <!-- Email -->
        <div class="form-group">
            <label for="Email">Email</label>
            <input type="email" class="form-control" id="Email"  name="email" placeholder="zhangsan@163.com" th:value="${emp!=null}?${emp.email}">
        </div>
        <!--gender-->
        <div class="form-group">
            <label >Gender</label><br/>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="gender" value="1" th:checked="${emp!=null}?${emp.gender}==1">
                <label class="form-check-label" >男</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="gender" value="0" th:checked="${emp!=null}?${emp.gender}==0">
                <label class="form-check-label" >女</label>
            </div>
        </div>
        <!-- department -->
        <div class="form-group">
            <label >department</label>
            <select class="form-control"  name="department.id" >
                <option th:selected="${emp!=null}?${dept.id == emp.department.id}" th:each="dept:${depts}" th:value="${dept.id}" th:text="${dept.departmentName}"></option>
            </select>
        </div>
        <div class="form-group">
            <label for="birthDate">Birth</label>
            <input type="text" class="form-control" id="birthDate" placeholder="2012-12-12" name="birth" th:value="${emp!=null}?${#dates.format(emp.birth,'yyyy-MM-dd HH:mm:ss')}">
        </div>
        <button type="submit" class="btn btn-primary" th:text="${emp!=null}?'修改':'添加'">添 加</button>
    </form>
</main>
```
### 9、员工删除（删）

#### 1、新建Contoller

```java
/**
 * 员工删除
 */
@DeleteMapping(value = "/emp/{id}")
public String deleteEmp(@PathVariable("id") Integer id){
    employeeDao.deleteEmpById(id);
    return "redirect:/emps";
}
```

#### 2、修改删除标签

```html
<button th:attr="del_uri=@{/emp/}+${emp.id}"  class="btn btn-sm btn-danger deleteBtn">
    删除
</button>
```

#### 3、写Form表单

form表单卸载外面，input 中 name="_method" value="delete" 模拟delete请求

```html
                </tbody>
            </table>
        </div>
    </main>
    <form id="deleteEmpForm" method="post">
        <input type="hidden" name="_method" value="delete">
    </form>
</div>
```

#### 4、写JS提交

```javascript
<script>
    $(".deleteBtn").click(function () {
        $("#deleteEmpForm").attr("action",$(this).attr("del_uri")).submit();
        return false;
    })
</script>
```

> return false;禁用btn提交效果

## 7、错误机制的处理

### 1、默认的错误处理机制

默认错误页面

![20.error](assets/20.error.jpg)

原理参照

ErrorMvcAutoConfiguration:错误处理的自动配置

```
org\springframework\boot\spring-boot-autoconfigure\1.5.12.RELEASE\spring-boot-autoconfigure-1.5.12.RELEASE.jar!\org\springframework\boot\autoconfigure\web\ErrorMvcAutoConfiguration.class

```

- DefaultErrorAttributes

  帮我们在页面共享信息

  ```java
  @Override
  public Map<String, Object> getErrorAttributes(RequestAttributes requestAttributes,
        boolean includeStackTrace) {
     Map<String, Object> errorAttributes = new LinkedHashMap<String, Object>();
     errorAttributes.put("timestamp", new Date());
     addStatus(errorAttributes, requestAttributes);
     addErrorDetails(errorAttributes, requestAttributes, includeStackTrace);
     addPath(errorAttributes, requestAttributes);
     return errorAttributes;
  }
  ```

- BasicErrorController

  ```java
  @Controller
  @RequestMapping("${server.error.path:${error.path:/error}}")
  public class BasicErrorController extends AbstractErrorController {
      //产生HTML数据
      @RequestMapping(produces = "text/html")
  	public ModelAndView errorHtml(HttpServletRequest request,
  			HttpServletResponse response) {
  		HttpStatus status = getStatus(request);
  		Map<String, Object> model = Collections.unmodifiableMap(getErrorAttributes(
  				request, isIncludeStackTrace(request, MediaType.TEXT_HTML)));
  		response.setStatus(status.value());
  		ModelAndView modelAndView = resolveErrorView(request, response, status, model);
  		return (modelAndView == null ? new ModelAndView("error", model) : modelAndView);
  	}
  	//产生Json数据
  	@RequestMapping
  	@ResponseBody
  	public ResponseEntity<Map<String, Object>> error(HttpServletRequest request) {
  		Map<String, Object> body = getErrorAttributes(request,
  				isIncludeStackTrace(request, MediaType.ALL));
  		HttpStatus status = getStatus(request);
  		return new ResponseEntity<Map<String, Object>>(body, status);
  	}
  ```

- ErrorPageCustomizer

  ```java
  @Value("${error.path:/error}")
  private String path = "/error";//系统出现错误以后来到error请求进行处理，(web.xml)
  ```

- DefaultErrorViewResolver

  ```java
  @Override
  public ModelAndView resolveErrorView(HttpServletRequest request, HttpStatus status,
        Map<String, Object> model) {
     ModelAndView modelAndView = resolve(String.valueOf(status), model);
     if (modelAndView == null && SERIES_VIEWS.containsKey(status.series())) {
        modelAndView = resolve(SERIES_VIEWS.get(status.series()), model);
     }
     return modelAndView;
  }
  
  private ModelAndView resolve(String viewName, Map<String, Object> model) {
      //默认SpringBoot可以找到一个页面？error/状态码
     String errorViewName = "error/" + viewName;
      //如果模板引擎可以解析地址，就返回模板引擎解析
     TemplateAvailabilityProvider provider = this.templateAvailabilityProviders
           .getProvider(errorViewName, this.applicationContext);
     if (provider != null) {
         //有模板引擎就返回到errorViewName指定的视图地址
        return new ModelAndView(errorViewName, model);
     }
      //自己的文件 就在静态文件夹下找静态文件 /静态资源文件夹/404.html
     return resolveResource(errorViewName, model);
  }
  ```

一旦系统出现4xx或者5xx错误 ErrorPageCustomizer就回来定制错误的响应规则,就会来到 /error请求,BasicErrorController处理，就是一个Controller

1.响应页面,去哪个页面是由 DefaultErrorViewResolver 拿到所有的错误视图

```java
protected ModelAndView resolveErrorView(HttpServletRequest request,
      HttpServletResponse response, HttpStatus status, Map<String, Object> model) {
   for (ErrorViewResolver resolver : this.errorViewResolvers) {
      ModelAndView modelAndView = resolver.resolveErrorView(request, status, model);
      if (modelAndView != null) {
         return modelAndView;
      }
   }
   return null;
}
```

l浏览器发送请求 accpt:text/html

客户端请求：accept:/*

### 2、如何定制错误响应

	1）、如何定制错误的页面
	
		1.有模板引擎：静态资源/404.html,什么错误什么页面；所有以4开头的 4xx.html 5开头的5xx.html
	
		有精确的404和4xx优先选择404
	
		页面获得的数据
	
			timestamp：时间戳
	
			status：状态码
	
			error：错误提示
	
			exception：异常对象
	
			message：异常信息
	
			errors:JSR303有关
	
		2.没有放在模板引擎，放在静态文件夹，也可以显示，就是没法使用模板取值
	
		3.没有放模板引擎，没放静态，会显示默认的错误
	
	2）、如何定义错误的数据



举例子：新建4xx和5xx文件

![21.error-static](assets/21.error-static.jpg)



```html
<body >
    <p>status: [[${status}]]</p>
    <p>timestamp: [[${timestamp}]]</p>
    <p>error: [[${error}]]</p>
    <p>message: [[${message}]]</p>
    <p>exception: [[${exception}]]</p>
</body>
```

![22.4xxhtml](assets/22.4xxhtml.jpg)

### 3、如何定制Json数据

#### 1、仅发送json数据

```java
public class UserNotExitsException extends  RuntimeException {
    public UserNotExitsException(){
        super("用户不存在");
    }
}
```

```java
/**
 * 异常处理器
 */
@ControllerAdvice
public class MyExceptionHandler {

    @ResponseBody
    @ExceptionHandler(UserNotExitsException.class)
    public Map<String ,Object> handlerException(Exception e){
        Map<String ,Object> map =new HashMap<>();
        map.put("code", "user not exist");
        map.put("message", e.getMessage());
        return map;
    }
}
```

无法自适应 都是返回的json数据

#### 2、转发到error自适应处理

```java
@ExceptionHandler(UserNotExitsException.class)
public String handlerException(Exception e, HttpServletRequest request){
    Map<String ,Object> map =new HashMap<>();
    //传入自己的状态码
    request.setAttribute("javax.servlet.error.status_code", 432);
    map.put("code", "user not exist");
    map.put("message", e.getMessage());
    //转发到error
    return "forward:/error";
}
```

程序默认获取状态码

```java
protected HttpStatus getStatus(HttpServletRequest request) {
   Integer statusCode = (Integer) request
         .getAttribute("javax.servlet.error.status_code");
   if (statusCode == null) {
      return HttpStatus.INTERNAL_SERVER_ERROR;
   }
   try {
      return HttpStatus.valueOf(statusCode);
   }
   catch (Exception ex) {
      return HttpStatus.INTERNAL_SERVER_ERROR;
   }
```

没有自己写的自定义异常数据

#### 3、自适应和定制数据传入

Spring 默认的原理，出现错误后回来到error请求，会被BasicErrorController处理,响应出去的数据是由BasicErrorController的父类AbstractErrorController(ErrorController)规定的方法getAttributes得到的；

1、编写一个ErrorController的实现类【或者AbstractErrorController的子类】，放在容器中；

2、页面上能用的数据，或者是json数据返回能用的数据都是通过errorAttributes.getErrorAttributes得到；

容器中的DefaultErrorAtrributes.getErrorAtrributees();默认进行数据处理

```java
public class MyErrorAttributes extends DefaultErrorAttributes {
    @Override
    public Map<String, Object> getErrorAttributes(RequestAttributes requestAttributes, boolean includeStackTrace) {
        Map<String, Object> map = super.getErrorAttributes(requestAttributes, includeStackTrace);
        map.put("company", "wdjr");
        return map;
    }
}
```

异常处理：把map方法请求域中

```java
    @ExceptionHandler(UserNotExitsException.class)
    public String handlerException(Exception e, HttpServletRequest request){
        Map<String ,Object> map =new HashMap<>();
        //传入自己的状态码
        request.setAttribute("javax.servlet.error.status_code", 432);
        map.put("code", "user not exist");
        map.put("message", e.getMessage());
        request.setAttribute("ext", map);
        //转发到error
        return "forward:/error";
    }
}
```

在上面的MyErrorAttributes类中加上

```java
//我们的异常处理器
Map<String,Object> ext = (Map<String, Object>) requestAttributes.getAttribute("ext", 0);
map.put("ext", ext);
```

## 8、配置嵌入式servlet容器

### 1、定制和修改Servlet容器

SpringBoot默认使用Tomcat作为嵌入式的Servlet容器；

![23.tomcat emd](assets/23.tomcat emd.jpg)

问题？

1）、如何定制和修改Servlet容器；

1、 修改Server相关的配置文件 application.properties

```properties
#通用的servlet容器配置
server.xxx
#tomcat的配置
server.tomcat.xxxx
```

2、编写一个EmbeddedServletContainerCustomizer;嵌入式的Servlet容器的定制器；来修改Servlet的容器配置

```java
@Bean
public EmbeddedServletContainerCustomizer embeddedServletContainerCustomizer(){
    return new EmbeddedServletContainerCustomizer() {
        //定制嵌入式Servlet的容器相关规则
        @Override
        public void customize(ConfigurableEmbeddedServletContainer container) {
            container.setPort(8999);
        }
    };
}
```

其实同理，都是实现EmbeddedServletContainerCustomizer

### 2、注册Servlet三大组件

三大组件 Servlet Filter Listener

由于SprringBoot默认是以jar包启动嵌入式的Servlet容器来启动SpringBoot的web应用，没有web.xml

注册三大组件

#### ServletRegistrationBean

```java
@Bean
public ServletRegistrationBean myServlet(){
    ServletRegistrationBean servletRegistrationBean = new ServletRegistrationBean(new MyServlet(),"/servlet");
    return servletRegistrationBean;
}
```

MyServlet

```java
public class MyServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.getWriter().write("Hello Servlet");
    }
}
```

#### FilterRegistrationBean

```java
@Bean
public FilterRegistrationBean myFilter(){
    FilterRegistrationBean filterRegistrationBean = new FilterRegistrationBean();
    filterRegistrationBean.setFilter(new MyFilter());
    filterRegistrationBean.setUrlPatterns(Arrays.asList("/hello","/myServlet"));
    return filterRegistrationBean;
}
```

MyFilter

```java
public class MyFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        System.out.println("MyFilter process");
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {

    }
}
```

#### ServletListenerRegistrationBean

```java
@Bean
public ServletListenerRegistrationBean myListener(){
    ServletListenerRegistrationBean<MyListener> registrationBean = new ServletListenerRegistrationBean<>(new MyListener());
    return registrationBean;
}
```

MyListener

```java
public class MyListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println(".........web应用启动..........");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println(".........web应用销毁..........");
    }
}
```



SpringBoot帮助我们自动配置SpringMVC的时候，自动注册SpringMVC的前端控制器；DispatcherServlet;

```java
@Bean(name = DEFAULT_DISPATCHER_SERVLET_REGISTRATION_BEAN_NAME)
@ConditionalOnBean(value = DispatcherServlet.class, name = DEFAULT_DISPATCHER_SERVLET_BEAN_NAME)
   public ServletRegistrationBean dispatcherServletRegistration(
         DispatcherServlet dispatcherServlet) {
      ServletRegistrationBean registration = new ServletRegistrationBean(
            dispatcherServlet, this.serverProperties.getServletMapping());
       //默认拦截 /所有请求 包括静态资源 不包括jsp
       //可以通过server.servletPath来修改SpringMVC前端控制器默认拦截的请求路径
      registration.setName(DEFAULT_DISPATCHER_SERVLET_BEAN_NAME);
      registration.setLoadOnStartup(
            this.webMvcProperties.getServlet().getLoadOnStartup());
      if (this.multipartConfig != null) {
         registration.setMultipartConfig(this.multipartConfig);
      }
      return registration;
   }

}
```

### 3、切换其他的Servlet容器

在ServerProperties中

```java
private final Tomcat tomcat = new Tomcat();

private final Jetty jetty = new Jetty();

private final Undertow undertow = new Undertow();
```

tomcat(默认支持)

jetty（长连接）

undertow（多并发）

切换容器 仅仅需要修改pom文件的依赖就可以

```xml
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
            <exclusions>
                <exclusion>
                    <artifactId>spring-boot-starter-tomcat</artifactId>
                    <groupId>org.springframework.boot</groupId>
                </exclusion>
            </exclusions>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-jetty</artifactId>
        </dependency>
<!--        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-undertow</artifactId>
        </dependency>-->
```

### 4、嵌入式Servlet容器自动配置原理

```java
@AutoConfigureOrder(Ordered.HIGHEST_PRECEDENCE)
@Configuration
@ConditionalOnWebApplication
@Import(BeanPostProcessorsRegistrar.class)
//给容器导入组件 后置处理器 在Bean初始化前后执行前置后置的逻辑 创建完对象还没属性赋值进行初始化工作
public class EmbeddedServletContainerAutoConfiguration {
    @Configuration
	@ConditionalOnClass({ Servlet.class, Tomcat.class })//当前是否引入tomcat依赖
    //判断当前容器没有用户自定义EmbeddedServletContainerFactory，就会创建默认的嵌入式容器
	@ConditionalOnMissingBean(value = EmbeddedServletContainerFactory.class, search = SearchStrategy.CURRENT)
	public static class EmbeddedTomcat {

		@Bean
		public TomcatEmbeddedServletContainerFactory tomcatEmbeddedServletContainerFactory() {
			return new TomcatEmbeddedServletContainerFactory();
		}
```

1）、EmbeddedServletContainerFactory（嵌入式Servlet容器工厂）

```java
public interface EmbeddedServletContainerFactory {
	//获取嵌入式的Servlet容器
   EmbeddedServletContainer getEmbeddedServletContainer(
         ServletContextInitializer... initializers);

}
```

继承关系

![24.EmdServletFactory](assets/24.EmdServletFactory.jpg)

2）、EmbeddedServletContainer:(嵌入式的Servlet容器)

![25.EmdServletContainer](assets/25.EmdServletContainer.jpg)

3）、TomcatEmbeddedServletContainerFactory为例 

```java
@Override
public EmbeddedServletContainer getEmbeddedServletContainer(
      ServletContextInitializer... initializers) {
   Tomcat tomcat = new Tomcat();
    //配置tomcat的基本环节
   File baseDir = (this.baseDirectory != null ? this.baseDirectory
         : createTempDir("tomcat"));
   tomcat.setBaseDir(baseDir.getAbsolutePath());
   Connector connector = new Connector(this.protocol);
   tomcat.getService().addConnector(connector);
   customizeConnector(connector);
   tomcat.setConnector(connector);
   tomcat.getHost().setAutoDeploy(false);
   configureEngine(tomcat.getEngine());
   for (Connector additionalConnector : this.additionalTomcatConnectors) {
      tomcat.getService().addConnector(additionalConnector);
   }
   prepareContext(tomcat.getHost(), initializers);
    //将配置好的tomcat传入进去；并且启动tomcat容器
   return getTomcatEmbeddedServletContainer(tomcat);
}
```

4）、嵌入式配置修改

```
ServerProperties、EmbeddedServletContainerCustomizer
```

EmbeddedServletContainerCustomizer:定制器帮我们修改了Servlet容器配置？

怎么修改？



5）、容器中导入了**EmbeddedServletContainerCustomizerBeanPostProcessor**

```java
@Override
public void registerBeanDefinitions(AnnotationMetadata importingClassMetadata,
      BeanDefinitionRegistry registry) {
   if (this.beanFactory == null) {
      return;
   }
   registerSyntheticBeanIfMissing(registry,
         "embeddedServletContainerCustomizerBeanPostProcessor",
         EmbeddedServletContainerCustomizerBeanPostProcessor.class);
   registerSyntheticBeanIfMissing(registry,
         "errorPageRegistrarBeanPostProcessor",
         ErrorPageRegistrarBeanPostProcessor.class);
}
```

```java
@Override
public Object postProcessBeforeInitialization(Object bean, String beanName)
      throws BeansException {
    //如果当前初始化的是一个ConfigurableEmbeddedServletContainer
   if (bean instanceof ConfigurableEmbeddedServletContainer) {
      postProcessBeforeInitialization((ConfigurableEmbeddedServletContainer) bean);
   }
   return bean;
}

private void postProcessBeforeInitialization(
    ConfigurableEmbeddedServletContainer bean) {
    //获取所有的定制器，调用每个定制器的customer方法给Servlet容器进行赋值
    for (EmbeddedServletContainerCustomizer customizer : getCustomizers()) {
        customizer.customize(bean);
    }
}

private Collection<EmbeddedServletContainerCustomizer> getCustomizers() {
    if (this.customizers == null) {
        // Look up does not include the parent context
        this.customizers = new ArrayList<EmbeddedServletContainerCustomizer>(
            this.beanFactory
            //从容器中获取所有的这个类型的组件：EmbeddedServletContainerCustomizer
            //定制Servlet,给容器中可以添加一个EmbeddedServletContainerCustomizer类型的组件
            .getBeansOfType(EmbeddedServletContainerCustomizer.class,
                            false, false)
            .values());
        Collections.sort(this.customizers, AnnotationAwareOrderComparator.INSTANCE);
        this.customizers = Collections.unmodifiableList(this.customizers);
    }
    return this.customizers;
}
```

ServerProperties也是EmbeddedServletContainerCustomizer定制器

步骤：

1）、SpringBoot根据导入的依赖情况，给容器中添加响应的容器工厂 例：tomcat

EmbeddedServletContainerFactory【TomcatEmbeddedServletContainerFactory】

2）、容器中某个组件要创建对象就要通过后置处理器；

```java
EmbeddedServletContainerCustomizerBeanPostProcessor
```

只要是嵌入式的Servlet容器工厂，后置处理器就工作；

3）、后置处理器，从容器中获取的所有的EmbeddedServletContainerCustomizer，调用定制器的定制方法

### 5、嵌入式Servlet容器启动原理

什么时候创建嵌入式的Servlet的容器工厂？什么时候获取嵌入式的Servlet容器并启动Tomcat;

获取嵌入式的容器工厂

1）、SpringBoot应用启动Run方法

2）、刷新IOC容器对象【创建IOC容器对象，并初始化容器，创建容器的每一个组件】；如果是web环境AnnotationConfigEmbeddedWebApplicationContext,如果不是AnnotationConfigApplicationContext

```JAVA
if (contextClass == null) {
   try {
      contextClass = Class.forName(this.webEnvironment
            ? DEFAULT_WEB_CONTEXT_CLASS : DEFAULT_CONTEXT_CLASS);
   }
```

3）、refresh(context);刷新创建好的IOC容器

```java
try {
   // Allows post-processing of the bean factory in context subclasses.
   postProcessBeanFactory(beanFactory);

   // Invoke factory processors registered as beans in the context.
   invokeBeanFactoryPostProcessors(beanFactory);

   // Register bean processors that intercept bean creation.
   registerBeanPostProcessors(beanFactory);

   // Initialize message source for this context.
   initMessageSource();

   // Initialize event multicaster for this context.
   initApplicationEventMulticaster();

   // Initialize other special beans in specific context subclasses.
   onRefresh();

   // Check for listener beans and register them.
   registerListeners();

   // Instantiate all remaining (non-lazy-init) singletons.
   finishBeanFactoryInitialization(beanFactory);

   // Last step: publish corresponding event.
   finishRefresh();
}
```

4）、 onRefresh();web的ioc容器重写了onRefresh方法

5）、webioc会创建嵌入式的Servlet容器；createEmbeddedServletContainer

6）、获取嵌入式的Servlet容器工厂；

```java
EmbeddedServletContainerFactory containerFactory = getEmbeddedServletContainerFactory();
```

从ioc容器中获取EmbeddedServletContainerFactory组件；

```java
@Bean
public TomcatEmbeddedServletContainerFactory tomcatEmbeddedServletContainerFactory() {
return new TomcatEmbeddedServletContainerFactory();
}
```
TomcatEmbeddedServletContainerFactory创建对象，后置处理器看这个对象，就来获取所有的定制器来定制Servlet容器的相关配置；

7）、使用容器工厂获取嵌入式的Servlet容器

8）、嵌入式的Servlet容器创建对象并启动Servlet容器；

先启动嵌入式的Servlet容器，在将ioc容器中剩下的没有创建出的对象获取出来

ioc启动创建Servlet容器

## 9、使用外置的Servlet容器

嵌入式的Servlet容器：应用达成jar包

	优点：简单、便携
	
	缺点：默认不支持JSP、优化定制比较复杂（使用定制器【ServerProperties、自定义定制器】，自己来编写嵌入式的容器工厂）

外置的Servlet容器：外面安装Tomcat是以war包的方式打包。

### 1、IDEA操作外部Servlet

1、创建程序为war程序

![26.tomcat1](assets/26.tomcat1.jpg)

2、选择版本

![27.tomcat2](assets/27.tomcat2.jpg)

3、添加tomcat

![28.tomcat3](assets/28.tomcat3.jpg)

4、选择tomcat

![30.tomcat4](assets/30.tomcat4.jpg)

5、选择本地的Tomcat

![31.tomcat5](assets/31.tomcat5.jpg)

6、配置tomcat路径

![32.tomcat6](assets/32.tomcat6.jpg)

7、添加服务器

![33.tomcat7](assets/33.tomcat7.jpg)

8、添加exploded的war配置，应用OK tomcat配置完成

![34.tomcat8](assets/34.tomcat8.jpg)

二、配置webapp文件夹

1、点击配置

![35.tomcat9](assets/35.tomcat9.jpg)

2、添加webapp目录

![36.tomcat10](assets/36.tomcat10.jpg)

3、默认配置就可以

![37.tomcat11](assets/37.tomcat11.jpg)

4、配置web.xml文件

![38.tomcat12](assets/38.tomcat12.jpg)

5、文档目录结构

![39.tomcat13](assets/39.tomcat13.jpg)

### 2、运行一个示例

1、项目目录

![40.demo1](assets/40.demo1.jpg)

2、配置文件写视图解析前后缀

```properties
spring.mvc.view.prefix=/WEB-INF/jsp/

spring.mvc.view.suffix=.jsp
```

3、HelloController

```java
@Controller
public class HelloController {
    @GetMapping("/hello")
    public String hello(Model model){
        model.addAttribute("message","这是Controller传过来的message");
        return "success";
    }
}
```

4、success.jsp

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Success</title>
</head>
<body>
<h1>Success</h1>
message:${message}
</body>
</html>
```

5、运行结果

![41.demo2](assets/41.demo2.jpg)

步骤

1、必须创建一个war项目；

2、将嵌入式的Tomcat指定为provided

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-tomcat</artifactId>
    <scope>provided</scope>
</dependency>
```

3、必须编写一个SpringBootServletInitializer的子类，并调用configure方法里面的固定写法

```java
public class ServletInitializer extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        //传入SpringBoot的主程序，
        return application.sources(SpringBoot04WebJspApplication.class);
    }

}
```

4、启动服务器就可以；

### 3、原理

jar包：执行SpringBoot主类的main方法，启动ioc容器，创建嵌入式的Servlet的容器；

war包：启动服务器，服务器启动SpringBoot应用，【SpringBootServletInitializer】启动ioc容器

servlet3.0规范

 8.2.4 共享库和运行时插件

规则：

1、服务器启动（web应用启动），会创建当前的web应用里面每一个jar包里面ServletContrainerInitializer的实现类的实例

2、SpringBootServletInitializer这个类的实现需要放在jar包下的META-INF/services文件夹下，有一个命名为javax.servlet.ServletContainerInitalizer的文件，内容就是ServletContainerInitializer的实现类全类名

3、还可以使用@HandlerTypes注解，在应用启动的时候可以启动我们感兴趣的类



流程：

1、启动Tomcat服务器

2、spring web模块里有这个文件

![42.servletContainerInit](assets/42.servletContainerInit.jpg)

```java
org.springframework.web.SpringServletContainerInitializer
```

3、SpringServletContainerInitializer将handlerTypes标注的所有类型的类传入到onStartip方法的Set<Class<?>>;为这些感兴趣类创建实例

4、每个创建好的WebApplicationInitializer调用自己的onStratup

5、相当于我们的SpringBootServletInitializer的类会被创建对象，并执行onStartup方法

6、SpringBootServletInitializer执行onStartup方法会创建createRootApplicationContext

```java
protected WebApplicationContext createRootApplicationContext(ServletContext servletContext) {
    SpringApplicationBuilder builder = this.createSpringApplicationBuilder();
    //环境构建器
    StandardServletEnvironment environment = new StandardServletEnvironment();
    environment.initPropertySources(servletContext, (ServletConfig)null);
    builder.environment(environment);
    builder.main(this.getClass());
    ApplicationContext parent = this.getExistingRootWebApplicationContext(servletContext);
    if (parent != null) {
        this.logger.info("Root context already created (using as parent).");
        servletContext.setAttribute(WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE, (Object)null);
        builder.initializers(new ApplicationContextInitializer[]{new ParentContextApplicationContextInitializer(parent)});
    }
	
    builder.initializers(new ApplicationContextInitializer[]{new ServletContextApplicationContextInitializer(servletContext)});
    builder.contextClass(AnnotationConfigEmbeddedWebApplicationContext.class);
    //调用Configure,子类重写了这个方法，将SpringBoot的主程序类传入进来
    builder = this.configure(builder);
    //创建一个spring应用
    SpringApplication application = builder.build();
    if (application.getSources().isEmpty() && AnnotationUtils.findAnnotation(this.getClass(), Configuration.class) != null) {
        application.getSources().add(this.getClass());
    }

    Assert.state(!application.getSources().isEmpty(), "No SpringApplication sources have been defined. Either override the configure method or add an @Configuration annotation");
    if (this.registerErrorPageFilter) {
        application.getSources().add(ErrorPageFilterConfiguration.class);
    }
	//最后启动Spring容器
    return this.run(application);
}
```

7、Spring的应用就启动完了并且创建IOC容器；

```java
public ConfigurableApplicationContext run(String... args) {
   StopWatch stopWatch = new StopWatch();
   stopWatch.start();
   ConfigurableApplicationContext context = null;
   FailureAnalyzers analyzers = null;
   configureHeadlessProperty();
   SpringApplicationRunListeners listeners = getRunListeners(args);
   listeners.starting();
   try {
      ApplicationArguments applicationArguments = new DefaultApplicationArguments(
            args);
      ConfigurableEnvironment environment = prepareEnvironment(listeners,
            applicationArguments);
      Banner printedBanner = printBanner(environment);
      context = createApplicationContext();
      analyzers = new FailureAnalyzers(context);
      prepareContext(context, environment, listeners, applicationArguments,
            printedBanner);
      refreshContext(context);
      afterRefresh(context, applicationArguments);
      listeners.finished(context, null);
      stopWatch.stop();
      if (this.logStartupInfo) {
         new StartupInfoLogger(this.mainApplicationClass)
               .logStarted(getApplicationLog(), stopWatch);
      }
      return context;
   }
   catch (Throwable ex) {
      handleRunFailure(context, listeners, analyzers, ex);
      throw new IllegalStateException(ex);
   }
}
```