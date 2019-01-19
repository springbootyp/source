# Swagger

​	Swagger 是一个规范和完整的框架，用于生成、描述、调用和可视化 RESTful 风格的 Web 服务.总体目标是使客户端和文件系统作为服务器以同样的速度来更新。文件的方法，参数和模型紧密集成到服务器端的代码，允许API来始终保持同步

##### 主要作用

* 接口的文档在线自动生成
* 功能测试

##### Swagger的开源项目

* Swagger-tools：提供各种与Swagger进行集成和交互的工具
* Swagger-core：用于Java/Scala的的Swagger实现
* Swagger-js: 用于JavaScript的Swagger实现
* Swagger-node-express: Swagger模块，用于node.js的Express web应用框架
* Swagger-ui：一个无依赖的HTML、JS和CSS集合，可以为Swagger兼容API动态生成优雅文档
* Swagger-codegen：一个模板驱动引擎，通过分析用户Swagger资源声明以各种语言生成客户端代码

##### SpringBoot+Swagger

* 添加swagger依赖

``` xml
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger2</artifactId>
    <version>2.9.2</version>
</dependency>
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger-ui</artifactId>
    <version>2.9.2</version>
</dependency>
```

* 配置swagger

  ```java
  @Configuration
  @EnableSwagger2
  public class AddResource {
  	@Bean
  	public Docket createRestApi() {
  		// 创建API页面展示信息
  		ApiInfo apiInfo = new ApiInfoBuilder()
  		// 页面标题 swagger-ui.html的标题
  		.title("SpringBoot整合Swagger2")
  		// 描述下的链接信息
  		.contact(new Contact("Loyal", "http://localhost:8080/toLogin", ""))
  		// 版本号  页面标题上显示的版本号
  		.version("1.0")
  		// 页面API文档的描述信息
  		.description("API 描述").build();
  		
  		return new Docket(DocumentationType.SWAGGER_2)
  				.apiInfo(apiInfo)
  				.select()
  				.apis(
  						// 将包路径下所有方法扫描成API
  						RequestHandlerSelectors.basePackage("com.example.boot_thyme.controller")
  					  )
  				.paths(PathSelectors.any())
  				.build();
  	}
  
  }
  ```

* 注解配置API文档内容

  ```java
  @Api("Swagger 耍耍水")
  @RestController
  public class LoginController {
  	
  	Logger logger = LoggerFactory.getLogger(LoginController.class);
  	
  	@Autowired
      private MessageSource messageSource;
  	// 定义API描述信息
  	@ApiOperation(value="登录",notes="用户登录系统")
      // 定义API参数
  	@ApiImplicitParams({
  		@ApiImplicitParam(name="name",paramType="query",dataType="String",value="用户名",required=true),
  		@ApiImplicitParam(name="pwd",paramType="query",dataType="String",value="密码",required=true)
  	})
      @ApiResponses({
  		@ApiResponse(code=200,message="请求成功了哦！"),
  		@ApiResponse(code=404,message="页面去哪了？")
  	})
  	@RequestMapping("/login")
  	public Map<String,Object> login(String name,String pwd) {
  		logger.info("LoginController.login()===");
  		Map<String,Object> model = new HashMap<String,Object>();
  		model.put("resultCode", "success");
  		model.put("resultMsg", "Operation success!");
  		return model;
  	}
  ```

* 相关注解：

  * @Api：标注类中所有方法为API
  * @ApiOperation：API方法定义
  * @ApiImplicitParams：API参数集合
  * @ApiImplicitParam：API参数定义
    * paramType属性：
      * header：请求参数放置于Request Header，使用@RequestHeader获取
      * query：请求参数放置于请求地址，使用@RequestParam获取
      * path：（用于restful接口）-->请求参数的获取：@PathVariable
      * body
  * @ApiResponses：API响应集合
  * @ApiResponse：API响应定义
  * @ApiIgnore：忽略该API
  * @ApiError ：发生错误返回的信息

* 
