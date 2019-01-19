## 第七章     Ajax、Json

### 本章目标 

- SpringMVC生成json格式的数据
- @RequestBody注解
- 了解HttpMessageConverter接口

### Spring MVC和Ajax

- 在现在的项目中Ajax可以说是必须使用的技术，SpringMVC框架作为目前最受欢迎的框架，和Ajax的集成非常的友好，可以说是非常傻瓜式的。 
- 当客户端使用ajax向服务器发送请求，服务器返回对应格式的数据，一般常见的数据格式有string，json，xml等。那么使用SpringMVC返回这些数据格式就是关键了。 

### Spring MVC处理Json格式的步骤 

- 导入jacksonjar包 

  - jackson-annotations-2.8.0.jar
  - jackson-core-2.8.0.jar
  - jackson-databind-2.8.0.jar

- 编写目标方法，使其返回对应的对象或集合

- 在方法前添加@ResponseBody注解。

  ```java
  @ResponseBody
  @RequestMapping("json")
  public List<User> json() {
      List<User> userList = new ArrayList<User>();
      userList.add(new User("admin", "123", "男", 22, new Date()));
      userList.add(new User("test", "123", "女", 12, new Date()));
      return userList;
  }
  ```

  ![20180803092810](http://www.znsd.com/znsd/courses/uploads/24a9358613bd6b4704eb43df1e8ff83e/20180803092810.png)

### 练习：使用json格式返回数据

- 通过Ajax来实现学生信息的查询。
- 要求： 
  - 只允许使用ajax调用服务器端的数据，不允许直接使用表单进行提交。
  - 通过jackson方式返回json格式的数据。对返回的json格式必须做统一的规范。

### SpringMVC实现Json的原理 

- 在Spring MVC中，输出Json格式异常简单，只需要返回对应的对象和集合类型即可，但是背后的实现原理时什么呢？ 
- 在SpringMVC中内置了一个HttpMessageConverter\<T>接口，用来处理返回的数据格式。
- HttpMessageConverter\<T>是Spring3.0新添加的一个接口，负责将请求信息转换为一个对象（类型为T），将对象（类型为T）输出为响应信息。

### HttpMessageConverter\<T>解析过程 

- 当请求从客户端发送时，为一个HttpInputMessage请求对象，HttpMessageConverter将提交的请求转换为Java对象。传给SpringMVC的控制器方法。当返回数据时为Java对象时，HttpInputMessage又会将Java对象转换为HttpOutputMessage对象返回给客户端。

  ![image](http://www.znsd.com/znsd/courses/uploads/541cd3da755ad7f12557fcd2ffddef3d/image.png)

### HttpMessageConverter\<T>对应的方法 

**HttpMessageConverter\<T>接口定义的方法：**

- boolean canRead(Class<?> clazz, MediaType mediaType);  指定转换器可以读取的对象类型，即转换器能否可将请求信息转换为clazz类型的对象，同时指定支持MediaType类型。
- boolean canWrite(Class<?> clazz, MediaType mediaType);  指定转换器能否将clazz类型的对象写入到相应流中，相应流支持的媒体类型在MediaType中定义。
- List\<MediaType> getSupportedMediaTypes(); 该转换器支持的媒体类型 
- T read(Class<? extends T> clazz, HttpInputMessage inputMessage) 将请求信息转换为T类型的对象 
- void write(T t, MediaType contentType, HttpOutputMessage outputMessage) 将T类型的信息写入到相应流中，同时指定相应的媒体类型为contentType。 

### HttpInputMessage

- 当用户提交请求时，SpringMVC会将用户提交的请求转换为一个HttpInputMessage对象，这个对象器本质就是一个InputStream文件流对象。然后传递到给HttpMessageConverter进行转换成需要的对象，然后再传递给对应的服务器。 

  ```java
  public interface HttpInputMessage extends HttpMessage {
  
  	InputStream getBody() throws IOException;
  
  }
  ```

### HttpOutputMessage

- 当服务器返回数据时，也会先将数据交由HttpMessageConverter进行转换，生成一个HttpOutputMessage对象，这个对象也相当于OutputStream，然后再将这个对象发送到客户端。 

  ```java
  public interface HttpOutputMessage extends HttpMessage {
  
  	OutputStream getBody() throws IOException;
  
  }
  
  ```

### HttpMessageConverter实现类 

| 实现类                               | 说明                                                         |
| ------------------------------------ | ------------------------------------------------------------ |
| StringHttpMessageConverter           | 将请求信息转换为字符串。                                     |
| FormHttpMessageConverter             | 将表单数据读取到MultiValueMap中。                            |
| ResourceHttpMessageConverter         | 读写Resource对象。                                           |
| XmlAwareFormHttpMessageConverter     | 扩展于FormHttpMessageConverter，如果部分表单属性是XML数据，可用该转换器进行读取。 |
| BufferedImageHttpMessageConverter    | 读写BufferedImage对象。                                      |
| ByteArrayHttpMessageConverter        | 读写二进制数据。                                             |
| SourceHttpMessageConverter           | 读写Source类型的数据。                                       |
| MarshallingHttpMessageConverter      | 通过String的Marshaller和Unmarshaller读写XML信息。            |
| Jaxb2RootElemengHttpMessageConverter | 通过Jaxb2读写XML信息，将请求信息转换到标注XmlRootElement和XmlType的类中。 |
| MappingJacksonHttpMessageConverter   | 利用Jackson开源包的ObjectMapper读写Json数据。                |
| RssChannelHttpMessageConverter       | 能够读写RSS种子信息。                                        |
| AtomFeedHttpMessageConverter         | 读写Atom格式的RSS信息。                                      |



### 默认装配的HttpInputMessage 

- DispatcherServlet默认装配RequestMappingHandlerAdapter，而RequestMappingHandlerAdapter默认装配如下HttpMessageConverter：

  ![image](http://www.znsd.com/znsd/courses/uploads/b56fd0350c9a842bc4e38503821b2fa0/image.png)

#### 加载Jackson装配的HttpInputMessage 

- 加入了Jackson的jar包后，RequestMappingHandlerAdapter会将MappingJacksonHttpMessageConverter装配进来。

  ![image](http://www.znsd.com/znsd/courses/uploads/e2cf181263e226cbf2ba0aafc2438542/image.png)

### 使用HttpMessageConverter\<T> 

- 使用HttpMessageConverter\<T>将请求信息转化并绑定到处理方法的入参或将相应结果转换对应类型的响应信息，Spring提供了两种途径：
  - 使用@RequestBody和@ResponseBody对处理方法进行标注。
  - 使用HttpEntity\<T>和ResponseEntity\<T>作为处理方法入参或返回值。
- 当控制器处理方法使用到@RequestBody/@ResponseBody或HttpEntity\<T>/ResponseEntity\<T>时，Spring首先根据请求头或相应头的Accept属性选择匹配的HttpMessageConverter，进而根据参数类型或者泛型类型的过滤得到匹配的HttpMessageConverter，若找不到可用的HttpMessageConverter则会报错

### @ResponseBody

- @ResonseBody：该注解用于将Controller方法返回的对象，通过适当的HttpMessageConverter转换为指定格式，如(json格式)，写入到Response的body数据区。 
- 适用场景：当控制器返回的非html格式的视图信息时。如string，json，xml，byte[]等。

### @RequestBody

- 该注解用于读取Request请求的body部分数据，使用系统默认配置的HttpMessageConverter进行解析，然后把相应的数据绑定到要返回的对象上，再把HttpMessageConverter返回的对象数据绑定到 controller中方法的参数上。 

  ```java
  @ResponseBody
  @RequestMapping("/testRequestBody")
  public String testRequestBody(@RequestBody String body){ // 将表单信息转换为一个字符串。
      System.out.println("requestbody：" + body);
      return body;
  }
  ```

  ```html
  <form action="testRequestBody" method="post">
  	<input type="text" name="name" />
  	<input type="password" name="pass" />
  	<input type="submit" value="提交" />
  </form>
  ```

### HttpEntity

- HttpEntity和@RequestBody注解功能类似，都是将请求的参数转换为对应的对象。 

  ```java
  @ResponseBody
  @RequestMapping("/testHttpEntity")
  public String testHttpEntity(HttpEntity<String> entity){
      return entity.getBody();
  }
  ```

### ResponseEntity

- ResponseEntity和@ResponseBody功能一致，不过是做为返回类型。

  ```java
  @RequestMapping("/testResponseEntity")
  public ResponseEntity<String> testResponseEntity(){
      ResponseEntity<String> entity = new ResponseEntity<String>("hello ResponseEntity", HttpStatus.OK);
      return entity;
  }
  ```

  

### 文件下载功能

- 使用ResponseEntity<byte[]>来实现文件下载。文件下载只需要将文件输出类型该为可以被下载的文件类型设置为ResponseEntity<byte[]>即可。 

  ```java
  @RequestMapping("/downFile")
  public ResponseEntity<byte[]> testdownFile(HttpSession session) throws IOException {
      ServletContext servletContext = session.getServletContext();
      InputStream in = servletContext.getResourceAsStream("downloads/down.txt");
      byte[] bytes = FileCopyUtils.copyToByteArray(in);
  
      HttpHeaders header = new HttpHeaders();
      header.add("Content-Disposition", "attachment;filename=down.txt");
  
      ResponseEntity<byte[]> entity = new ResponseEntity<byte[]>(bytes, header, HttpStatus.OK);
      return entity;
  }
  ```

### 练习：文件下载 

### 总结

- 返回JSON格式的数据
- @RequestBody/@RequestBody注解的作用
- @HttpEntity/@ResponseEntity注解的用法。
- 返回Json格式的数据。
- 文件下载