## 第九章 JSP开发业务应用

### 回顾

- MySQL的分页语句是怎样的？
- 什么是连接池，使用连接池有什么好处？
- JNDI连接池常用属性有哪些？

### 本章任务

- 实现简单文件上传
- 实现学生头像上传的功能

### 本章目标

- 掌握Commons-FileUpload组件上传文件的功能`重点（难点）`

### Commons-FileUpload简介

- Commons-FileUpload组件：Commons是Apache开放源代码组织的一个Java子项目，其中的FileUpload是用来处理HTTP文件上传的子项目
- Commons-FileUpload组件特点
  1. 使用简单：可以方便地嵌入到JSP文件中，编写少量代码即可完成文件的上传功能
  2. 能够全程控制上传内容
  3. 能够对上传文件的大小、类型进行控制
- 获取Commons-FileUpload组件的方式
  1. http://commons.apache.org/proper/commons-fileupload/ 下载Commons-FileUpload组件
     - Commons-FileUpload组件类库：commons-fileupload-1.2.2.jar
     - Commons-FileUpload组件的API文档： apidocs 
  2. http://commons.apache.org/proper/commons-io/ 下载Commons-IO组件
     - Commons-IO组件类库：commons-io-2.4.jar
     - Commons-IO组件的API文档： commons-io-2.4\docs

![image](http://www.znsd.com/znsd/courses/uploads/aec298733714f4c98a72e2daf77262e5/image.png)

### Commons-FileUpload组件应用

环境准备

- 在项目中引入commons-fileupload-1.3.3.jar和commons-io-2.6.jar文件（将JAR文件添加到WEB-INF\lib目录下）

- 设置表单的enctype属性

  ```html
  <form enctype="multipart/form-data" method="post"></form>
  ```

`注意：`上传文件时form标签的method属性必须取值为"post"，不能取值为"get"    

### 文件上传的实现

- 编写上传文件处理页的实现步骤

  ```java
  //创建FileItemFactory对象
  //创建ServletFileUpload对象	
  //解析form表单中所有文件
  if (普通表单字段){  
      //获取表单字段的name属性值
      if (此属性是“user”)){ 
          //输出XXX上传了文件
      }
  }else{   //文件表单字段
      //获取上传文件的名字
      if (名字不为空) {
      //保存此文件并输出保存成功		
      }
  } 
  ```


- upload.jsp

  ```html
  <body>
  	<p align="center">请您选择需要上传的文件</p>
  	<form id="form1" name="form1" method="post" action="fileServlet" enctype="multipart/form-data">
  		<table border="0" align="center">
  			<tr>
  				<td>上传人：</td>
  				<td><input name="name" type="text" id="name" size="20"></td>
  			</tr>
  			<tr>
  				<td>上传文件：</td>
  				<td><input name="file" type="file" size="20"></td>
  			</tr>
  			<tr>
  				<td></td>
  				<td><input type="submit" name="submit" value="提交"> <input
  					type="reset" name="reset" value="重置"></td>
  			</tr>
  		</table>
  	</form>
  </body>
  ```

- FileUploadServlet.java

  ```java
  package com.znsd.servlet;

  import java.io.File;
  import java.io.IOException;
  import java.util.Iterator;
  import java.util.List;

  import javax.servlet.ServletConfig;
  import javax.servlet.ServletContext;
  import javax.servlet.ServletException;
  import javax.servlet.http.HttpServlet;
  import javax.servlet.http.HttpServletRequest;
  import javax.servlet.http.HttpServletResponse;

  import org.apache.commons.fileupload.FileItem;
  import org.apache.commons.fileupload.disk.DiskFileItemFactory;
  import org.apache.commons.fileupload.servlet.ServletFileUpload;

  public class FileUploadServlet extends HttpServlet {

  	private static final long serialVersionUID = -7744625344830285257L;
  	private ServletContext servletContext;
  	private String savePath;

  	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
  		// doPost(request, response);
  	}

  	public void init(ServletConfig config) {
  		// 在web.xml中设置的一个初始化参数
  		savePath = config.getInitParameter("savePath");
  		servletContext = config.getServletContext();
  	}

  	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
  		request.setCharacterEncoding("UTF-8");
  		DiskFileItemFactory factory = new DiskFileItemFactory();
  		ServletFileUpload upload = new ServletFileUpload(factory);
  		// upload.setSizeMax(1024*1024);
  		try {
  			List<FileItem> items = upload.parseRequest(request);
  			Iterator<FileItem> itr = items.iterator();
  			while (itr.hasNext()) {
  				FileItem item = (FileItem) itr.next();
  				if (item.isFormField()) {
  					System.out.println("表单参数名:" + item.getFieldName() + "，表单参数值:" + item.getString("UTF-8"));
  				} else {
  					if (item.getName() != null && !"".equals(item.getName())) {
  						System.out.println("上传文件的大小:" + item.getSize());
  						System.out.println("上传文件的类型:" + item.getContentType());
  						// item.getName()返回上传文件在客户端的完整路径名称
  						System.out.println("上传文件的名称:" + item.getName());

  						File tempFile = new File(item.getName());

  						// 上传文件的保存路径 //运行目录下
  						File file = new File(servletContext.getRealPath("/") + savePath, tempFile.getName());
  						item.write(file);
  						request.setAttribute("upload.message", "上传文件成功！");
  					} else {
  						request.setAttribute("upload.message", "没有选择上传文件！");
  					}
  				}
  			}
  			// } catch (SizeLimitExceededException e) {
  			// log.error("上传文件大小超过限制：",e);
  		} catch (Exception e) {
  			System.out.println("上传失败：" + e.getMessage());
  			request.setAttribute("upload.message", "上传文件失败！");
  		}
  		request.getRequestDispatcher("/uploadResult.jsp").forward(request, response);
  	}
  }
  ```

- uploadResult.jsp

  ```html
  <body>

  	${upload.message}
  	
  	<a href="upload.jsp">上传文件</a>
  	
  </body>
  ```

### Commons-FileUpload组件的API

- FileItemFactory接口与实现类

| 方法名称                                     | 方法描述        |
| ---------------------------------------- | ----------- |
| public void setSizeThreshold(int sizeThreshold) | 设置内存缓冲区的大小  |
| public void setRepositoryPath(String  path ) | 设置临时文件存放的目录 |

- ServletFileUpload类的常用方法

| 方法名称                                     | 方法描述                                   |
| ---------------------------------------- | -------------------------------------- |
| public void setSizeMax(long  sizeMax)    | 设置请求信息实体内容的最大允许的字节数                    |
| public List parseRequest(HttpServletRequest req ) | 解析form表单中的每个字符的数据，返回一个FileItem对象的集合    |
| public static final boolean  isMultipartContent (HttpServletRequest req ) | 判断请求信息中的内容  是否是“multipart/form-data”类型 |
| public void setHeaderEncoding(String  encoding) | 设置转换时所使用的字符集编码                         |

- FileItem接口的常用方法

| 方法名称                         | 方法描述                                     |
| ---------------------------- | ---------------------------------------- |
| public boolean isFormField() | 判断FileItem对象封装的数据类型（普通表单字段返回true，文件表单字段返回false） |
| public String getName()      | 获得文件上传字段中的文件名（普通表单字段返回null）              |
| public String getFieldName() | 返回表单字段元素的name属性值                         |
| public void write()          | 将FileItem对象中保存的主体内容保存到指定的文件中             |
| public String  getString()   | 将FileItem对象中保存的主体内容以一个字符串返回。其重载方法public  String  getString(String  encoding)中的参数用指定的字符集编码方式 |
| public long  getSize()       | 返回单个上传文件的字节数                             |

### 学员操作——实现文件上传

- 训练要点：掌握Commons-FileUpload组件相关类方法的使用

- 需求说明：制作一个简单的文件上传页面，用户可以选择本地文件，将其上传到服务器进行保存

  ![image](http://www.znsd.com/znsd/courses/uploads/aec298733714f4c98a72e2daf77262e5/image.png)

- 实现思路

  1. 添加commons-fileupload.jar和commons-io-2.4.jar
  2. 在JSP文件中使用page指令导入Commons-FileUpload类
  3. 调用Commons-FileUpload组件相关类的方法获取文件信息并实现保存

### 控制上传文件的属性

- 控制上传文件的类型

  ```java
  List<String> filType = Arrays.asList("gif","bmp","jpg");
  String ext = fileName.substring(fileName.lastIndexOf(".") + 1);
  if(!filType.contains(ext)) {  //判断文件类型是否在允许范围内
    out.print("上传失败，文件类型只能是gif、bmp、jpg");
  } else { 
    //上传文件
  }
  ```

![image](http://www.znsd.com/znsd/courses/uploads/e459dd6c51070c4cf058b03c6b144ca7/image.png)

- 控制上传文件的大小

  ```java
  ServletFileUpload upload = new ServletFileUpload(factory);
  //设置单个文件的最大限制
  upload.setSizeMax(1024*30); 
  try {
    	//……省略上传代码
  } catch(FileUploadBase.SizeLimitExceededException ex){
      out.print("上传失败，文件太大，单个文件的最大限制是：" + upload.getSizeMax() + "bytes!");
  }
  ```

  ![image](http://www.znsd.com/znsd/courses/uploads/95eba6d6657deb420bc1cc485ffe6b2b/image.png)

### 学员操作——实现学生头像上传功能

- 训练要点：使用Commons-FileUpload组件上传文件并对文件进行控制
- 需求说明
  1. 添加学生需要上传个人头像
  2. 允许上传的图片类型为：GIF文件、JPG文件、JPEG文件
  3. 上传图片的大小不能超过5MB
- 实现思路
  1. 使用Commons-FileUpload组件上传文件并对文件进行控制
  2. 调用封装业务的JavaBean将数据保存至数据库

### 小结

- 文件上传的步骤？
- ServletFileUpload的常用方法？
- FileItem的常用方法？
- 如果实现同时上传多个文件？