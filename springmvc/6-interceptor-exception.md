## 第六章     拦截器及异常处理 

### 本章目标

- 学会自定义拦截器
- 了解自定义拦截器的执行过程
- 掌握SpringMVC的异常处理机制
- 会使用异常处理

### 拦截器

SpringMVC也可以使用拦截器对请求进行拦截处理，用户可以自定义拦截器来实现特定的功能，自定义拦截器必须实现HandlerInterceptor接口。 

- perHandle()：这个方法在业务处理器处理请求之前被调用，在该方法中对用户请求的request进行处理。如果拦截器对请求进行拦截处理后还要调用其他拦截器，或者是业务处理器去进行处理，则返回true，如果不需要再调用其他的组件处理请求，则返回false。
- postHandle()：这个方法在业务处理器处理完请求后，但是DispatcherServlet向客户端返回响应前被调用。在该方法对用户请求的数据进行处理。
- afterCompletion()：这个方法在DispatcherServlet完全处理完请求后被调用，可以在该方法中进行一些资源清理的操作。

```java
public class FirstInterceptor implements HandlerInterceptor {

	/**
	 * 进入目标方法之前调用
	 * 返回true：则继续调用后续的拦截器和目标方法
	 * 返回false：则不会调用后续的拦截器和目标方法
	 * 使用场景：权限控制、日志处理、事务...
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		System.out.println("FirstInterceptor.preHandle()");
		return true;
	}

	/**
	 * 调用目标方法之后，在渲染页面之前调用
	 * 使用场景：
	 * 1.需要改变request对象中的值
	 * 2.需要修改modelAndView中的值
	 * 3.修改转向的视图
	 */
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		System.out.println("FirstInterceptor.postHandle()");
	}

	/**
	 * 渲染页面完成之后调用
	 * 使用场景：做一些销毁工作
	 */
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		System.out.println("FirstInterceptor.afterCompletion()");
	}

}
```

#### 拦截器的执行顺序

![image](http://www.znsd.com/znsd/courses/uploads/228c060172d07288f1b6b5908e937a88/image.png)

#### 配置自定义拦截器 

在SpringMVC中配置自定义拦截器。

```xml
<!--配置拦截器, 多个拦截器,顺序执行 -->  
<mvc:interceptors>    
    <mvc:interceptor>    
        <!-- 匹配的是url路径， 如果不配置或/**,将拦截所有的Controller -->  
        <mvc:mapping path="/" />  
        <mvc:mapping path="/user/**" />  
        <mvc:mapping path="/test/**" />  
        <bean class="com.alibaba.interceptor.CommonInterceptor"></bean>    
    </mvc:interceptor>  
    <!-- 当设置多个拦截器时，先按顺序调用preHandle方法，然后逆序调用每个拦截器的postHandle和afterCompletion方法 -->  
</mvc:interceptors> 
```

#### 多个拦截器的执行顺序 

![image](http://www.znsd.com/znsd/courses/uploads/9a0e4e1f6a7ce05b4c9708759aec08ac/image.png)

#### 第二个拦截器返回false时的执行过程。

![image](http://www.znsd.com/znsd/courses/uploads/eeb565e6869696a60f48e488bd8276d4/image.png)

#### 添加权限验证 

- 当用户没有登录，将所有请求全部转发到login页面

  ```java
  public class SecurityInterceptor implements HandlerInterceptor {
  
  	@Override
  	public boolean preHandle(HttpServletRequest request, HttpServletResponse resonse, Object handler) throws Exception {
  		// 拦截所有get请求，如果未登录，则返回login.jsp页面   
  		if ("get".equalsIgnoreCase(request.getMethod())) {
  			User user = (User) request.getSession().getAttribute("current_user");
  			
  			if (user == null) {
  				request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, resonse);
  				return false;
  			}
  		}
  		return true;
  	}
  }
  
  ```

#### 练习：使用拦截器进行权限验证 

- 对于未登录的用户全部转发到login页面 

#### 小结 

- 自定义拦截器的使用
- 拦截器的执行顺序

### Springmvc异常处理的三种方式 

- **使用SimpleMappingExceptionResolver实现异常处理：** 仅能获取到异常信息，若在出现异常时，对需要获取除异常以外的数据的情况不适用 
- **实现HandlerExceptionResolver 接口自定义异常处理器：** 能获取导致出现异常的对象，有利于提供更详细的异常处理信息 
- **使用@ExceptionHandler注解实现异常处理：** 无需配置，不能获取除异常以外的数据 

#### SimpleMappingExceptionResolver实现异常处理 

- 配置异常信息

  ```xml
  <!-- 配置使用SimpleMappingExceptionResolver来映射异常 -->
  <bean class="org.springframework.web.servlet.handler.SimpleMappingExceptionResolver">
      <!-- 给异常命名一个别名 -->
      <property name="exceptionAttribute" value="ex"></property>
      <property name="exceptionMappings">
          <props>
              <!-- 一定要异常的全类名（也可以是自定义异常）。 表示出现MyException异常，就跳转到error.jsp视图 -->
              <prop key="java.lang.ArrayIndexOutOfBoundsException">error</prop>
          </props>
      </property>
  </bean>
  ```

- 在/WEB-INF/views下新建一个error.jsp视图 

  ```html
  <body>
  	<h1>Error Page</h1>
      <!-- 获取异常信息 -->
  	${requestScope.ex}
  </body>
  ```

- 控制器代码

  ```java
  @RequestMapping("index")
  public String index() {
      int[] array = new int[]{1, 2};
     	// 出现下标越界异常会进入error.jsp页面
      System.out.println(array[3]);
      return "success";
  }
  ```

![20180802161731](http://www.znsd.com/znsd/courses/uploads/3e4f7aa6cae4af4eaef2e83da0b42196/20180802161731.png)

#### HandlerExceptionResolver 接口自定义异常处理器 

- 实现HandlerExceptionResolver 接口，重写resolveException方法，全局处理所有异常

  ```java
  @Component // 将自定义异常类装载到spring容器中
  public class CustomeException implements HandlerExceptionResolver {
  
  	@Override
  	public ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, Object handler,
  			Exception ex) {
  		Map<String, Object> map = new HashMap<String, Object>();
  		if (ex instanceof NullPointerException) {
  			map.put("ex", ex);
  			return new ModelAndView("nullPointer", map); // 指定异常对应的视图页面
  		} 
  		if (ex instanceof IndexOutOfBoundsException) {
  			return new ModelAndView("indexOutOf", map); // 指定异常对应的视图页面
  		}
  		return new ModelAndView("error", map);
  	}
  }
  ```

#### @ExceptionHandler注解实现异常处理

异常处理类

```java
/**
 * 全局异常处理类，在项目中推荐使用全局异常处理类去处理所有异常信息
 * @author Administrator
 */
@ControllerAdvice
public class ExceptionHandlerAdvice {


	/**
	 * 在项目总如果没有对异常有页面要求，那么一个异常页面就够了
	 * 有些项目需要对每一类型的异常都有对象异常页面，比如前台的异常处理、后台异常处理
	 * @param request
	 * @param response
	 * @param handler
	 * @param ex
	 * @return
	 */
	@ExceptionHandler(value = { NullPointerException.class, IndexOutOfBoundsException.class })
	public ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, Object handler,
			Exception ex) {
		// 如果要将异常传递到视图中（jsp页面），必须使用ModelAndView来进行数据传递
		// 不能使用Map形参的方式，否则会报错
		System.out.println("ExceptionHandlerAdvice.resolveException()");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ex", ex);
		ModelAndView mv = new ModelAndView("error", map);
		return mv;
	}
}
```

页面获取异常

```html
<body>
	<h1>Error Page</h1>
	${requestScope.ex}
</body>
```

#### 异常处理

- Spring MVC通过HandlerExceptionResolver处理程序异常，包括Handler映射、数据绑定以及目标方法执行时发生的异常。 

- SpringMVC提供的HandlerExceptionResolver实现类。

  ![image](http://www.znsd.com/znsd/courses/uploads/83e1ae29dac9fbe5d2cd3cd3bc750238/image.png)

#### HandleExceptionResolver

- SpringMVC默认装配的HandleExceptionResolver。

- 没有使用<mvc:annotation-driven />配置 

  ![image](http://www.znsd.com/znsd/courses/uploads/58a2a97efaeddeb1aa6d85d10f03b8f2/image.png)

- 使用了<mvc:annotation-driven />配置

  ![image](http://www.znsd.com/znsd/courses/uploads/3807690b6e4232171e05e7ce87c46ec5/image.png)

#### @ExceptionHandler 

- 作用：主要处理Handler中的@ExceptionHandler注解定义的方法。
- @ExceptionHandler注解定义的方法优先级的问题：例如发生NullPointerException，但是声明的异常有RuntimeException和Exception，此时，会根据异常的最近继承关系找到继承关系最浅的那个@ExceptionHandler注解方法。 
- @ExceptionHandlerMethodResolver内部若找不到@ExceptionHandler注解的话，会找@ControllerAdvice中的@ExceptionHandler注解方法。
- `注意：`
  1. 在@ExceptionHandler方法的入参中传入Exception参数，该参数为即将发生的异常类型。
  2. 在@ExceptionHandler方法中不能传入Map参数，否则会抛出异常。如果需要传入参数，那么只能将返回值设置为ModelAndView。

#### 添加异常处理页面 

- 添加异常显示页面error，将异常信息进行显示。
- 异常方法不能通过参数方式保存map信息，只能通过ModelAndView返回异常信息。 

#### 全局异常处理 

- 前面的例子当中虽然可以处理异常，但是只能在当前控制器中使用，如果需要定义全局异常处理的话，需要单独添加一个全局处理类。 
- 这个类需要使用@ControllerAdvice来进行修饰，定义方法和前面一致。 

#### @ResponseStatus 

- 在异常及异父类中找到@ResponseStatus注解，然后使用这个注解的属性进行异常处理。 

- 添加一个异常类，并使用@ResponseStatus注解进行修饰。

  ```java
  @ResponseStatus(value = HttpStatus.UNAUTHORIZED)
  public class UnauthorizedException extends RuntimeException {
  
  	private static final long serialVersionUID = 1L;
  
  }
  ```

- 若在处理方法中抛出上述异常：若ExceptionHandlerExceptionResolver不解析上述异常，由于触发了异常的UnauthorizedException带有@ReponseStatus注解。因此会被ResponseStatusExceptionResolver解析到，最后响应HttpStatus.UNAUTHORIZED代码响应码401，无权限。 

- 关于其它响应码请参考HttpStatus枚举权限代码。

#### DefaultHandlerExceptionResolver 

对SpringMVC中的常见的异常进行处理：比如 

- NoSuchRequestHandingMethodException
- HttpRequestMethodNotSupportedException
- HttpMediaTypeNotSupportedException
- HttpMediaTypeNotAcceptableException

#### SimpleMappingExceptionResolver 

- 如果希望对所有异常进行统一处理，可以使用SimpleMappingExceptionResolver，它将异常类名映射为视图名，即发生异常时使用对应的视图报告异常。 

  ```xml
  <!-- 配置使用SimpleMappingExceptionResolver来映射异常 -->
  <bean class="org.springframework.web.servlet.handler.SimpleMappingExceptionResolver">
      <!-- 给异常命名一个别名 -->
      <property name="exceptionAttribute" value="ex"></property>
      <property name="exceptionMappings">
          <props>
              <!-- 一定要异常的全类名。 表示出现MyException异常，就跳转到error.jsp视图 -->
              <prop key="java.lang.ArrayIndexOutOfBoundsException">error</prop>
          </props>
      </property>
  </bean>
  ```

#### 小结 

- SpringMVC中的异常处理
- HandleExceptionResolver
- ResponseStatuserExceptionResolver
- DefaultHandlerExceptionResolver
- SimpleMappingExceptionResolver

### 总结

- 学会自定义拦截器
- 了解自定义拦截器的执行过程
- 掌握SpringMVC的异常处理机制
- 会使用异常处理