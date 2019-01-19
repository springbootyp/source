## 第一章  自定义MVC框架

### 本章任务

- 实现MVC自定义框架
  1. 基于Servlet技术
  2. 是MVC的一个实现
  3. 类似Struts框架

![image](http://www.znsd.com/znsd/courses/uploads/bbaac178f06ddad4c3b573e46b0d4662/image.png)

### 本章目标

- 掌握MVC设计模式
- 使用MVC设计模式开发自定义MVC框架

### 为什么需要框架技术

使用框架就像我们建房子，如何更快更好地盖房子？需要先把房屋的架构搭建好或者使用预制的架构。

![image](http://www.znsd.com/znsd/courses/uploads/de1b3d5c71b17ad47d35fee010a247cc/image.png)

### 什么是框架技术

“框架技术”是让我们站在巨人的肩膀上进行软件开发：

- 是一个应用程序的半成品
- 提供可重用的公共结构
- 按一定规则组织的一组组件

框架的优势

- 不用再考虑公共问题
- 专心在业务实现上
- 结构统一，易于学习、维护
- 新手也可写出好程序 

例子：

- 直接组装汽车，不用自己造轮子，车门，发动机等。
- 生产各种手机，不用自己生产零件，购买组装即可。

### 开源框架有那些

- Struts2
- Spring
- Hibernate
- SpringMVC
- MyBatis

### 传统的Model1

- 传统Model1开发模式。

  ![image](http://www.znsd.com/znsd/courses/uploads/ab39f4dccb459432b14ae5cbc7935c21/image.png)

- Model 1模式的实现比较简单，适用于快速开发小规模项目。但从工程化的角度看，它的局限性非常明显

- 存在的问题：
  1. JSP和页面代码混淆在一个页面中，不便于维护。
  2. 代码可重用性太低。
  3. 可维护性和可扩展性太差。

### 改进后的Model1

- 改进后的Model1。

  ![image](http://www.znsd.com/znsd/courses/uploads/3667b83101b802de98e9620a607e8c2c/image.png)

- 改进后的Model1相对Model1增加了JavaBean，实现了页面是业务部分分离。早起的ASP和JSP都采用的这种模式。

- 但是随着业务越来越复杂，网站功能越来越多，仅仅这样划分还远远不够，慢慢演变出了Model2模式。

### JSP Model 2

​        使用Jsp Model2的交互过程是用户通过浏览器向Web应用中的Servlet发送请求，Servlet接受到请求后实例化JavaBeans对象，调用JavaBeans对象的方法，JavaBeans对象返回从数据库中读取的数据。Servlet选择合适JSP，并且把从数据库中读取的数据通过这个JSP进行显示，最后JSP页面把最终的结果返回给浏览器。在JSPModel2中使用了三种技术。

- JSP负责页面的展示。
- Servlet负责流程控制，用来处理各种请求的分派。
- JavaBean负责业务逻辑，对数据库的操作。

![image](http://www.znsd.com/znsd/courses/uploads/413ce1dd6beb6dde24ee6f15db26e22d/image.png)

### 使用MVC的优势

​        其实Model2模式已经具有MVC的模式，由于使用了MVC模式，使得Model2具有组件化的特点，更适用于大规模应用的开发，但也增加了程序开发的复杂程度。

- MVC的优点：
  1. 消除了Model1的缺点。
  2. 适合多人合作开发大型Web项目。
  3. 各司其职，互不干涉。
  4. 有利于开发中的分工。
  5. 有利于组件的重用。

### MVC模式

MVC模式的编程思路

![image](http://www.znsd.com/znsd/courses/uploads/ed07c1163531cdf28a32b3a1e0a777dd/image.png)

### 基于MVC框架的程序结构

以用户登录为例：

![image](http://www.znsd.com/znsd/courses/uploads/39a57ce895ce3c41a77dc90b541d8ad0/image.png)

### 完成用户登录功能

#### 训练要点

- 掌握自定义MVC框架
- 使用Servlet作为控制器

#### 需求说明

- 开发自定义MVC框架
- 通过自定义Action实现逻辑控制
- 完成用户登录功能

#### 实现思路

- 开发模型M：实现业务逻辑的接口和类
- 开发控制器C：自定义Action接口，由LoginAction类实现
- 开发视图V：login.jsp，success.jsp
- 调试运行

#### Controller的设计

- 定义Action接口

  ```java
  public interface Action {

  	public String execute(HttpServletRequest request, HttpServletResponse response);
  }
  ```

- 实现自定义Action接口

  ```java
  public class LoginAction implements Action {

  	@Override
  	public String execute(HttpServletRequest request, HttpServletResponse response) {
  		String username = request.getParameter("username");
  		String password = request.getParameter("password");
  	
  		UserService userService = new UserServiceImpl();
  		UserModel user = userService.login(username, password);
  		if (user == null) {
  			request.setAttribute("msg", "用户名不存在或密码错误");
  			return "login.jsp";
  		}
  		request.setAttribute("user", user);
  		return "success.jsp";
  	}
  }
  ```

- 添加ActionManager类

  ```java
  public class ActionManager {

  	public Action getAction(HttpServletRequest request) {
  		//获取请求的uri
  		String uri = request.getRequestURI();
  		//获取上下文路径
  		String contextPath = request.getContextPath();
  		//截取上下文路径以后的部分
  		String actionPath = uri.substring(contextPath.length());
  		//获取Action 名称
  		String actionName = actionPath.substring(actionPath.lastIndexOf('/')+1,actionPath.lastIndexOf(".action"));

  		//添加新功能时在这里添加
  		Action action = null;
  		if ("login".equals(actionName)) {
  			action = new LoginAction();
  		}
  		return action;
  	}
  }
  ```

- 添加ActionServlet，处理客户提交的请求。

  ```java
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
  		ActionManager actionManager = new ActionManager();
    		//获得Action
  		Action action = actionManager.getAction(request);//ActionServlet获取自定义Action
  		if (action == null) {
  			throw new ServletException("未找到指定的action:");
  		}
  		//调用Action execute 方法
  		String result = action.execute(request, response);
  		request.getRequestDispatcher(result).forward(request, response);
  	}
  ```

- 配置ActionServlet

  ```xml
  <servlet>
      <display-name>ActionServlet</display-name>
      <servlet-name>ActionServlet</servlet-name>
      <servlet-class>com.znsd.struts.servlet.ActionServlet</servlet-class>
    </servlet>
    <servlet-mapping>
      <servlet-name>ActionServlet</servlet-name>
      <url-pattern>*.action</url-pattern>
    </servlet-mapping>
  ```

- login.jsp页面

  ```html
  <form action="login.action" method="post">
  		<table>
  			<tr>
  				<td>用户名</td>
  				<td><input type="text" name="username" id="username" /></td>
  			</tr>
  			<tr>
  				<td>密码</td>
  				<td><input type="password" name="password" id="password" /></td>
  			</tr>
  			<tr>
  				<td></td>
  				<td><input type="submit" value="登录" /> <input
  					type="reset" value=" 重置" /></td>
  			</tr>
  		</table>
  </form>
  ```

  ​

### 练习完成用户注册功能

开发说明

- 开发自定义的MVC框架。
- 通过自定义的Action实现业务逻辑。
- 完成注册功能。

### Controller的完善

`问题：`在自定义MVC框架中，一个Action处理一个业务，如果有很多业务需要处理，那就需要对应多个Action，工作量太大了，有没有好的解决办法呢？

- 将Action对象对应的url保存在配置文件中，然后利用反射，在ActionServlet加载时将配置读取配置信息，然后构建出Action对象，这样就极大的提高了框架的灵活性和重用性。

  1. 添加配置文件保存Action信息mvc.xml

     ```xml
     <?xml version="1.0" encoding="UTF-8"?>
     <actions>
     	<action name="login" class="com.znsd.struts.action.impl.LoginAction">
     		<result name="success">/WEB-INF/page/manager.jsp</result>
     		<result name="input">/WEB-INF/page/result.jsp</result>
     		<result name="error">/WEB-INF/page/login.jsp</result>
     	</action>
     </actions>
     ```

  2. 添加ActionMapping.java，保存Action信息。

     ```java
     public class ActionMapping {

     	private String name; // action 元素中的name

     	private String className; // action元素中的className属性

     	private Map<String, String> result = new HashMap<String, String>(); // action元素中的result
       	//省略setter/getter 方法
       	
       	/**
     	 * 获取action
     	 * 
     	 * @return
     	 */
     	public Map<String, String> getResult() {
     		return result;
     	}
       
       	/**
     	 * 添加action
     	 * 
     	 * @param name
     	 * @param result
     	 */
     	public void addResult(String name, String result) {
     		this.result.put(name, result);
     	}
     }
     ```

  3. 添加ActionMappingManager类，读取Action信息配置文件。

     ```java
     public class ActionMappingManager {
     	
       	public void init(String configFileName) {
     		InputStream is = ActionServlet.class.getClassLoader().getResourceAsStream(configFileName);
         	try {
     			Document document = new SAXReader().read(is);
     			Element root = document.getRootElement();
     			
     			List<Element> elements = root.elements("action");
     			for (Element element : elements) {
     				ActionMapping actionMapping = new ActionMapping();
     				String actionName = element.attributeValue("name");
     				actionMapping.setName(actionName);
     				actionMapping.setClassName(element.attributeValue("class"));
     				
     				List<Element> resultElements = element.elements("result");
     				for (Element result : resultElements) {
     					Map<String, String> resultMap = new HashMap<String, String>();
     					String resultName = result.attributeValue("name");
     					String resultValue = result.getTextTrim();
     					resultMap.put(resultName, resultValue);
     				}
     				
     				actionMappings.put(actionName, actionMapping);
     			}
     			
     		} catch (DocumentException e) {
     			e.printStackTrace();
     		} 
     	}
     }
     ```

  4. 在ActionMappingManager类中，添加根据Action读取Class映射的方法。

     ```java
     public ActionMapping getActionMapping(String actionName) throws Exception {
     		if (actionName == null || actionName == "") {
     			throw new Exception("actionName不能为空");
     		}
     		
     		//根据名称获取映射对象
     		ActionMapping amp = actionMappings.get(actionName);
     		if (amp == null) {
     			throw new Exception("未找到指定的actionName:" + actionName);
     		}
     		return amp;
     }
     ```

  5. 去掉原来ActionManager中的 getAction方法，添加反射创建Action的方法。

     ```java
     public static Action createAction(String className) {
       		//createAction方法用来获取Action实例
     		Action action = null;
     		try {
               	//className必须完整类名
     			action = (Action) Class.forName(className).newInstance(); // 通过反射构建Action对象
     		} catch (ClassNotFoundException e) {
     			e.printStackTrace();
     		} catch (InstantiationException e) {
     			e.printStackTrace();
     		} catch (IllegalAccessException e) {
     			e.printStackTrace();
     		}
     		return action;
     }
     ```

  6. Action接口中添加3个常量

     ```java
     public interface Action {
     	
     	public final static String SUCCESS = "success"; 
     	public final static String INPUT = "input"; 
     	public final static String ERROR = "error"; 
     }
     ```

  7. 修改web.xml配置信息

     ```xml
     <servlet>
     		<display-name>ActionServlet</display-name>
     		<servlet-name>ActionServlet</servlet-name>
     		<!-- ActionServlet的引用地址 -->
     		<servlet-class>com.znsd.struts.servlet.ActionServlet</servlet-class>
     		<!-- 设置ActionServlet初始化参数 -->
     		<init-param>
     			<param-name>config</param-name>
     			<param-value>struts.xml</param-value>
     		</init-param>
     		<!-- Web应用启动时就加载该Servlet -->
     		<load-on-startup>0</load-on-startup>
     </servlet>
     <servlet-mapping>
     		<servlet-name>ActionServlet</servlet-name>
     		<url-pattern>*.action</url-pattern>
     </servlet-mapping>
     ```

  8. 修改ActionServlet方法

     ```java
     public class ActionServlet extends HttpServlet {
     	
     	private ActionMappingManager actionMappingManager = null;

     	@Override
         public void init(ServletConfig config) throws ServletException {
     		actionMappingManager = ActionMappingManager.getInstance();
     		String configFile = config.getInitParameter("config");
     		actionMappingManager.init(configFile);
         }
     }

     ```

  9. 修改doPost方法

     ```java
     protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
     		ActionManager actionManager = new ActionManager();
     		
     		//获取请求的uri
     		String uri = request.getRequestURI();
     		//获取上下文路径
     		String contextPath = request.getContextPath();
     		//截取上下文路径以后的部分
     		String actionPath = uri.substring(contextPath.length());
     		//获取Action 名称
     		String actionName = actionPath.substring(actionPath.lastIndexOf('/')+1,actionPath.lastIndexOf(".action"));
     		
     		try {
     			// 获取action
     			ActionMapping mapping = actionManager.getActionMapping(actionName);
     			// 通过反射创建action
     			Action action = actionManager.createAction(mapping.getClassName());
     			// 调用相应的action中的execute方法
     			String resultName = action.execute(request, response);
     			// 获取result中的jsp文件
     			String result = mapping.getResult(resultName);
     			request.getRequestDispatcher(result).forward(request, response);
     		} catch (Exception e) {
     			throw new ServletException("未找到指定的actionName:" + actionName);
     		}
     	}
     ```

     ​


### 练习—改造MVC完成用户登录

**训练要点：**

- 掌握MVC模式
- 读取配置文件
- 动态加载类的实例

**需求说明：**

- 完善自定义MVC框架，读取配置文件，动态加载Action实例
- 使用完善后的自定义MVC 框架，实现用户登录功能

**实现思路：**

- 编写配置文件
- 编写ActionMapping类，保存Action信息
- 读取配置文件
- 反射生成Action
- 完善Controller
- 修改LoginAction
- 开发视图
- 调试运行

### 完善视图

1. 保存视图

   ```java
   public class Result {
   	private String name;
   	private String value;
   	private boolean isRedirect;
     
     	public boolean isRedirect() {
   		return isRedirect;
   	}

   	public void setRedirect(boolean isRedirect) {
   		this.isRedirect = isRedirect;
   	}
     
     	//省略setter/getter 方法
   }

   ```

2. 修改ActionMapping

   ```java
   public class ActionMapping { //使用Result类保存视图信息

   	private Map<String, Result> result = new HashMap<String, Result>(); 
     	
     	//根据 result-name,返回Result 实例
     	public Result getResult(String resultName) {
   		return this.result.get(resultName);
   	}
     	//向Map 中添加一个Result 实例。
     	public void addResult(String name, Result result) {
   		this.result.put(name, result);
   	}
   }
   ```

3. 修改ActionMappingManager类

   ```java
   for (Element element : elements) {
         ActionMapping actionMapping = new ActionMapping();
         String actionName = element.attributeValue("name");
         actionMapping.setName(actionName);
         actionMapping.setClassName(element.attributeValue("class"));

         List<Element> resultElements = element.elements("result");
         
         for (Element result : resultElements) {
               String resultName = result.attributeValue("name");
           	//读取重定向标识
               String isRedirect = result.attributeValue("isRedirect");
               String resultValue = result.getTextTrim();

               Result rst = new Result();
               rst.setName(resultName);
               rst.setValue(resultValue);
               rst.setRedirect("true".equals(isRedirect));
   			//将读取结果保存到Result中
               actionMapping.addResult(resultName, rst);
         }
         actionMappings.put(actionName, actionMapping);
   }
   ```

4. 修改ActionServlet

   ```java
   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
   		ActionManager actionManager = new ActionManager();
   		
   		//获取请求的uri
   		String uri = request.getRequestURI();
   		//获取上下文路径
   		String contextPath = request.getContextPath();
   		//截取上下文路径以后的部分
   		String actionPath = uri.substring(contextPath.length());
   		//获取Action 名称
   		String actionName = actionPath.substring(actionPath.lastIndexOf('/')+1,actionPath.lastIndexOf(".action"));
   		
   		try {
   			// 获取action
   			ActionMapping mapping = actionManager.getActionMapping(actionName);
   			// 通过反射创建action
   			Action action = actionManager.createAction(mapping.getClassName());
   			// 调用相应的action中的execute方法
   			String resultName = action.execute(request, response);
   			// 获取result中的jsp文件
   			Result result = mapping.getResult(resultName);
   			if (result == null) {
   				response.sendError(404, "未配置Action 的result 元素");
   				return;
   			}
   			//根据读取的结果决定页面的跳转
   			if (result.isRedirect()) {
   				//注意：重定向的请求不能跳转到/WEB-INF/目录下。
   				response.sendRedirect(result.getValue());
   				return;
   			}
             	//根据读取的结果决定页面的跳转
   			request.getRequestDispatcher(result.getValue()).forward(request, response);
   		} catch (Exception e) {
   			throw new ServletException("未找到指定的actionName:" + actionName);
   		}		
   	}
   ```

5. 修改各Servlet，将返回值改为常量

   ```java
   @Override
   public String execute(HttpServletRequest request, HttpServletResponse response) {
   		String username = request.getParameter("username");
   		String password = request.getParameter("password");
   		
   		if (username == null || password == null) {
   			return ERROR;
   		}
   	
   		UserService userService = new UserServiceImpl();
   		UserModel user = userService.login(username, password);
   		if (user == null) {
   			request.setAttribute("msg", "用户名不存在或密码错误");
   			return ERROR;
   		}
   		request.setAttribute("user", user);
   		return SUCCESS;
   }
   ```

### 练习：改造用户登录

- 通过配置文件升级MVC模式。
- 改造视图结果类。