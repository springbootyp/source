# Ajax

### 本章任务

- 使用Ajax验证用户名是否存在
- 使用Ajax实现无刷新注册
- 使用Ajax实现文本框的自动提示功能

### 本章目标

- 掌握Ajax技术原理
- 使用Ajax改善用户体验

### 背景

1. 传统的Web网站，提交表单，需要重新加载整个页面
2. 如果服务器长时间未能返回Response，则客户端将会无响应，用户体验很差
3. 服务端返回Response后，浏览器需要加载整个页面，对浏览器的负担也是很大的
4. 浏览器提交表单后，发送的数据量大，造成网络的性能问题

### ajax是什么

AJAX 是一种在无需重新加载整个网页的情况下，能够更新部分网页的技术。AJAX = 异步 JavaScript 和 XML它是一种用于创建快速动态网页的技术。通过在后台与服务器进行少量数据交换，AJAX 可以使网页实现异步更新。这意味着可以在不重新加载整个网页的情况下，对网页的某部分进行更新。传统的网页（不使用 AJAX）如果需要更新内容，必需重载整个网页面。

![image](http://www.znsd.com/znsd/courses/uploads/d2f94934b2a217ce5367a91fbc026d04/image.png)

- JavaScript：更新局部的网页
- XML：一般用于请求数据和响应数据的封装
- `XMLHttpRequest对象：发送请求到服务器并获得返回结果（ajax的核心）`
- CSS：美化页面样式
- 异步：发送请求后不等返回结果，由回调函数处理结果

### 什么是异步

​    当前页面发送一个请求给服务器，当前页面不需要等待服务器响应才能操作网页。发送完请求之后，当前页面可以继续浏览，操作。

### 为什么使用ajax

- 无刷新：不刷新整个页面，只刷新局部

- 无刷新的好处

  1. 只更新部分页面，有效利用带宽
  2. 提供连续的用户体验
  3. 提供类似C/S的交互效果，操作更方面

  ![image](http://www.znsd.com/znsd/courses/uploads/b340e6e4ce9012637cf219bbf874a03a/image.png)



### XMLHttpRequest 

XMLHttpRequest 是 整个Ajax技术的核心，它提供了异步发送请求的能力 ，所有现代浏览器均支持 XMLHttpRequest 对象（IE5 和 IE6 使用 ActiveXObject）。XMLHttpRequest 用于在后台与服务器交换数据。这意味着可以在不重新加载整个网页的情况下，对网页的某部分进行更新。

#### 创建 XMLHttpRequest 对象的语法

```js
var variable=new XMLHttpRequest();
```

#### 常用方法

| 方法名                            | 说    明                                   |
| ------------------------------ | ---------------------------------------- |
| open(method,URL,async)         | 建立与服务器的连接  method参数指定请求的HTTP方法,典型的值是GET或POST  URL参数指定请求的地址  async参数指定是否使用异步请求，其值为true或false |
| send(content)                  | 发送请求  content参数指定请求的参数                   |
| setRequestHeader(header,value) | 设置请求的头信息，header: 规定头的名称 value: 规定头的值     |

#### GET 和 POST

与 POST 相比，GET 更简单也更快，并且在大部分情况下都能用。然而，在以下情况中，请使用 POST 请求：

- 无法使用缓存文件（更新服务器上的文件或数据库）
- 向服务器发送大量数据（POST 没有数据量限制）
- 发送包含未知字符的用户输入时，POST 比 GET 更稳定也更可靠

#### GET和POST区别

**GET**

- 把参数数据加到URL中
- 传送的数据量较小，不能大于2KB
- 对于中文支持不好
- 安全性非常低
- 执行效率高

**POST**

- 将内容放置在http 请求信息体内传送
- 传送的数据量较大
- 可以传递文件域
- 可以支持中文
- 安全性较高

#### 常用属性 

- onreadystatechange：指定回调函数
- readyState: XMLHttpRequest的状态信息

| 就绪状态码 | 说    明                       |
| ----- | ---------------------------- |
| 0     | XMLHttpRequest对象没有完成初始化      |
| 1     | XMLHttpRequest对象开始发送请求       |
| 2     | XMLHttpRequest对象的请求发送完成      |
| 3     | XMLHttpRequest对象开始读取响应，还没有结束 |
| 4     | XMLHttpRequest对象读取响应结束       |

- status：HTTP的状态码

| 状态码  | 说    明    |
| ---- | --------- |
| 200  | 服务器响应正常   |
| 400  | 无法找到请求的资源 |
| 403  | 没有访问权限    |
| 404  | 访问的资源不存在  |
| 500  | 服务器内部错误   |

- responseText：获得响应的文本内容
- responseXML：获得响应的XML文档对象

**注意：就绪状态是4而且状态码是200，才可以处理服务器数据**

#### 一个简单的GET请求

```js
function sendRequest() {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange=function(){
      if (xmlHttp.readyState==4){
        document.getElementById("content").innerHTML = xmlHttp.responseText;
      }
    }	
    xmlHttp.open("GET", "test.txt", true);
    xmlHttp.send();
}
```

```html
<div id="content"></div>
<input type="button" onclick="sendRequest();" value="ajax">
```

错误：Cross origin requests are only supported for protocol schemes: http, data,chrome-extension, https, chrome-extension-resource.

出现该问题是因为浏览器为了安全性考虑，默认对跨域访问和直接访问本地文件禁止了。

解决方式：给浏览器传入启动参数（allow-file-access-from-files），允许跨域访问

```js
"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --allow-file-access-from-files
```



### ajax原理图

![image](http://www.znsd.com/znsd/courses/uploads/7cd7dee42147809940ff7737c50dbef2/image.png)

### 异步 - True 或 False

AJAX 指的是异步 JavaScript 和 XML（Asynchronous JavaScript and XML）。XMLHttpRequest 对象如果要用于 AJAX 的话，其 open() 方法的 async 参数必须设置为 true：

```js
xmlhttp.open("GET","test.txt",true);
```

对于 web 开发人员来说，发送异步请求是一个巨大的进步。很多在服务器执行的任务都相当费时。AJAX 出现之前，这可能会引起应用程序挂起或停止。

通过 AJAX，JavaScript 无需等待服务器的响应，而是：

- 在等待服务器响应时执行其他脚本
- 当响应就绪后对响应进行处理

#### Async = true

当使用 async=true 时，请规定在响应处于 onreadystatechange 事件中的就绪状态时执行的函数：

```js
xmlhttp.onreadystatechange=function(){
  	if (xmlhttp.readyState==4){
    	document.getElementById("myDiv").innerHTML=xmlhttp.responseText;
    }
}
xmlhttp.open("GET","test1.txt",true);
xmlhttp.send();
```

#### Async = false

如需使用 async=false，请将 open() 方法中的第三个参数改为 false：

```js
xmlhttp.open("GET","test1.txt",false);
```

一般不推荐使用 async=false，但是对于一些小型的请求，也是可以的。请记住，JavaScript 会等到服务器响应就绪才继续执行。如果服务器繁忙或缓慢，应用程序会挂起或停止。

**注释：**当您使用 async=false 时，请不要编写 onreadystatechange 函数 - 把代码放到 send() 语句后面即可，异步会等待服务器做出相应才执行后面的js代码

```js
xmlhttp.open("GET","test1.txt",false);
xmlhttp.send();
document.getElementById("myDiv").innerHTML=xmlhttp.responseText;
```

### 使用ajax验证用户名是否存在

#### 1. 实现无刷新用户验证

- 当用户名文本框失去焦点时，发送请求到服务器，判断用户名是否存在
- 如果已经存在则提示：“用户名已被可用”
- 如果不存在则提示：“用户名可以可用”

#### 2. 使用文本框的onblur事件

#### 3.使用Ajax技术实现异步交互

- 创建XMLHttpRequest对象
- 通过 XMLHttpRequest对象设置请求信息
- 向服务器发送请求
- 创建回调函数，根据响应状态动态更新页面

#### 例子

1. 创建xmlHttpRequest对象

```js
// 创建XMLHttpRequest对象
function createXMLHttpRequest(){
    var xhr;
    //不同浏览器创建XMLHttpRequest方法不同。
    if(window.ActiveXObject){ //如果是IE浏览器
      xhr = new ActiveXObject("Microsoft.XMLHTTP");
    }else if(window.XMLHttpRequest){ //非IE浏览器
      xhr = new XMLHttpRequest();
    } 
    return xhr;
}
```

2. 创建验证姓名表单的servlet
3. 使用JavaScript验证用户名是否存在

```js
// 校验用户名
function checkUserName() {
    var form = document.userForm;
    var username = form.username.value;
    if (username == "") {
      alert("用户名不能为空");
      return false;
    } else {
      doAjax("checkName?username=" + username);
    }
}
```

4. 发送ajax请求

```js
// 发送ajax请求
function doAjax(url) {
    var xmlHttp = createXMLHttpRequest();
    xmlHttp.onreadystatechange=function(){
        if (xmlHttp.readyState==4){
        	// 不做真实校验，如果有数据就认为用户名已经存在，否则不存在
	        var msg = document.getElementById("msg");
    	    if(xmlHttp.responseText && xmlHttp.responseText != "") {
        	  	msg.innerHTML = "用户名已经存在";
 	 	        msg.style.color = "red";
        	} else {
          		msg.innerHTML = "用户名可以使用";
          		msg.style.color = "green";
        	}
      	}
    }	
    xmlHttp.open("GET", "test.txt", true);
    xmlHttp.send();
}
```

```html
<form name="userForm">
	用户名：<input type="text" name="username" onblur="checkUserName();"><span id="msg"/>
</form>
```



#### 使用Ajax进行处理请求的4个步骤

1. 创建xmlhttprequest对象
2. 设置请求信息参数
3. 设置在服务器完成后要运行的回调函数
4. 发送请求

### 练习

#### 实现无刷新用户注册功能

- 添加注册的servlet
- 使用POST方式将表单信息提交到servlet

#### 使用Ajax添加新用户

- 使用Ajax实现用户注册
- 以post方式提交用户信息

### 小结

- Ajax的原理
- XMLHttpRequest对象的常用方法
- status状态
- Ajax的GET和POST请求方式



### 封装原生ajax

在前面的请求过程中，生成XMLHttpRequest对象，和发送Ajax请求中出现大量重复的代码。将重复代码提取到公共的ajax.js文件中。

```js
/* 封装ajax函数
 * @param {string}opt.type http连接的方式，包括POST和GET两种方式
 * @param {string}opt.url 发送请求的url
 * @param {boolean}opt.async 是否为异步请求，true为异步的，false为同步的
 * @param {object}opt.data 发送的参数，格式为对象类型
 * @param {function}opt.success ajax发送并接收成功调用的回调函数
 */
function ajax(opt) {
    opt = opt || {};
    opt.method = opt.method.toUpperCase() || 'POST';
    opt.url = opt.url || '';
    opt.async = opt.async || true;
    opt.data = opt.data || null;
    opt.success = opt.success || function () {};
    var xmlHttp = null;
    if (XMLHttpRequest) {
      	xmlHttp = new XMLHttpRequest();
    }
    else {
      	xmlHttp = new ActiveXObject('Microsoft.XMLHTTP');
    }
  	var params = [];
    for (var key in opt.data){
      	params.push(key + '=' + opt.data[key]);
    }
    var postData = params.join('&');
    if (opt.method.toUpperCase() === 'POST') {
      	xmlHttp.open(opt.method, opt.url, opt.async);
      	xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded;charset=utf-8');
      	xmlHttp.send(postData);
    }
    else if (opt.method.toUpperCase() === 'GET') {
      	xmlHttp.open(opt.method, opt.url + '?' + postData, opt.async);
      	xmlHttp.send(null);
    } 
    xmlHttp.onreadystatechange = function () {
      	if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
        	opt.success(xmlHttp.responseText);
      	}
    };
}
```

```js
<script type="text/javascript" src="scripts/ajax.js"></script>
ajax({
    method: 'POST',
    url: 'test.txt',
    data: {
        name1: 'value1',
        name2: 'value2'
    },
    success: function (response) {
       console.log(response)；
    }
});
```

通过对ajax的封装，极大的简化了我们调用ajax的代码，使ajax变得更加方便。



### 使用Ajax获取复杂用户

- 使用Ajax查询某个用户的信息

```js
function searchUsername() {
    var form = document.userForm;
    var name = form.name.value;
    ajax({
      	url: '/account',
      	data: {username:name},
      	method: 'post',
      	success: function(response) {
        	document.getElementById("result").innerHTML = eval("(" + response + ")").data;
      	}
    });
}
```

```html
<input type="button" onclick="searchUsername();" value="查询" /><br>
<span id="result"></span>
```

- 使用Ajax获取集合数据

### 异步处理XML格式数据 

#### XML：可扩展标记性语言 

- 可以存储任意复杂数据结构的数据
- 应用广泛
- 技术成熟

#### Ajax解析XML文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<list>
	<user>
		<name>zhangsan</name>
		<pass>123123</pass>
		<email>zhangsan@qq.com</email>
		<address>深圳</address>
	</user>
</list>
```

#### XMLDocument对象

- 获取节点对象
  1. getElementsByTagName()：获取指定节点名的节点对象集合 
  2. selectSingleNode ()：获取符合条件的单个节点对象 
  3. selectNodes()：获取符合条件的节点对象集合  
- 访问节点的信息
  1. getAttribute() ：获取节点的属性值 
  2. text/textContent/nodeValue：获取节点内部的文本 
  3. childNodes 属性：获取当前节点对象的子节点对象集合
  4. firstChild/lastChild：获取第一个或最后一个子节点 

```js
function processRequest() {
    var xhr = createXMLHttpRequest();
    var msg = document.getElementById("msg1");
    xhr.onreadystatechange=function(){
      	if (xhr.readyState == 4) {
        	console.info(xhr);
	        var data = xhr.responseXML;
    	    var name = data.getElementsByTagName("name")[0].textContent;
        	var pass = data.getElementsByTagName("pass")[0].textContent;
	        var email = data.getElementsByTagName("email")[0].textContent;
    	    var address = data.getElementsByTagName("address")[0].textContent;
        	document.getElementById("msg1").innerHTML = "姓名：" + name + ",邮箱：" + email + ",地址：" + address;
      	}
    }
    xhr.open("GET", "test.xml", true);
    xhr.send();
}
```

```html
<input type="button" onclick="processRequest();" value="查询" /><br>
<span id="msg1"></span>
```

### 使用Ajax实现自动提示功能

#### 实现搜索自动提示功能

![image](http://www.znsd.com/znsd/courses/uploads/f476d15c5dd5e29b52f34d43a6dae5b5/image.png)

#### 搜索提示的原理

- 每输入完一个关键字时，向服务器发送一个请求
- 服务器根据用户输入的关键字，从数据库中搜索相关关键字信息，并返回到客户端
- 在客户端显示提示信息

#### 注意事项

- 当键盘的按键抬起时，触发onkeyup键盘事件
- 将文本框的autocomplete属性设置为off，以免影响搜索提示
- 当搜索提示出现后，需要将其中选中的搜索项突出显示，以便区分

#### 关键java代码

```java
// 解决地址栏传递中文乱码问题
String key = request.getParameter("key");
key = new String(key.getBytes("ISO-8859-1"),"UTF-8");

if("".equals(key) || key == null){
    return;
}

// 获取查询结果
NewsDao dao = new NewsDao();
List<News> list = dao.getNewsListByTitle(key);

// 设置输出为XML格式
response.setContentType("text/xml;charset=utf-8");
response.setCharacterEncoding("utf-8");

PrintWriter out = response.getWriter();

// 拼接XML内容
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
StringBuffer sb = new StringBuffer();
sb.append("<list>");
for (News news : list) {
	sb.append("<title>"+news.getNtitle()+"</title>");
}
sb.append("</list>");
out.print(sb);
```

```css
<style type="text/css">
#searchlist {
	display: block;
	background-color: white;
	margin-top: -1px;
	border: 1px solid #d4d4d4;
	width: 450px;
	line-height: 20px;
	list-style: none;
	padding: 2px 0px 2px 2px;
}

.inputTxt {
	width: 450px;
	height: 20px;
}

.btn {
	color: white;
	background-color: #286cff;
	width: 100px;
	height: 28px;
	border: 1px solid #c8d6fb;
	border-radius: 3px;
	font-size: 14px;
	letter-spacing: 3px;
}
</style>
```

```html
<div>
	<input type="text" id="txtKey" class="inputTxt" autocomplete="off" onkeyup="searchKey(event)" />
  	<input type="button" value="百度一下" class="btn">
</div>
<ul id="searchlist" style="display: none;"></ul>
```

```js
function $(elId) {
	return document.getElementById(elId);
}
function searchKey(e) {
	var key = $("txtKey").value;
	if (key == "") {
		return;
	}
	var xhr = new XMLHttpRequest();
	xhr.open("get", "<%=request.getContextPath()%>/search?key=" + key);
	xhr.onload = function() {
		var titles = eval("(" + xhr.responseText + ")");
		var ulhtml = "";
		for (var i = 0; i < titles.length; i++) {
			var title = titles[i];
			ulhtml += "<li onclick='clicktitle(\"" + title + "\")'>" + title + "</li>";
		}
		$("searchlist").innerHTML = ulhtml;
		$("searchlist").style.display = "block";
	}
	xhr.send();
}
function clicktitle(value) {
	$("txtKey").value = value;
	$("searchlist").style.display = "none";
}
```

### 总结

- Ajax主要包括哪些技术？
- 使用Ajax的步骤有哪些？
- 使用Ajax处理POST请求应注意哪些问题？
- 使用Ajax如何解析XML文件。
- 使用Ajax实现自动提示功能的原理是什么？

### 作业

- Ajax主要包括哪些技术？
- 使用Ajax的步骤有哪些？
- 使用Ajax正确处理服务器数据必须满足的条件是什么？
- 使用Ajax实现自动提示功能的原理是什么？