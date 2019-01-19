# JavaScript

---

### JavaScript历史

JavaScript是一个叫Brendan Eich这哥们在两周之内设计出了JavaScript语言，只用了10天，为什么起名叫JavaScript？因为当时Java语言非常红火，所以公司希望借Java的名气来推广，但事实上JavaScript除了语法上有点像Java，其他部分基本上没啥关系。

### 为什么要学JavaScript

因为我们是学java的，我们学java是用来做web开发，在web的世界里，只有JavaScript是可以跨平台,跨浏览器驱动网页，与用户交互的。学习JavaScript可以做前端验证（减轻服务器压力），动态效果（树形菜单，层的切换），动态改变页面内容。

### JavaScript的组成

 - ECMAScript

    - 语法标准
    - 语法
    - 变量和数据类型 
    - 运算符
    - 逻辑控制语句
    - 关键字、保留字
    - 对象
    - 编码遵循ECMAScript标准

 - DOM 文档对象模型（Document Object Model）
    
    

 - BOM 浏览器对象模型（Browser Object Model）

### JavaScript使用

1.基本结构

```javascript
<script type="text/javascript">
    // JavaScript 语句;
    alert("Hello World");
</script >
```

2.javascript使用方式

 - Html页面内嵌JS代码
 - 外部JS文件

```javascript
<script src="hello.js" language="javascript"></script>
```
 - 简短写法

```javascript
<input name="btn" type="button" value="弹出消息框"  onclick="javascript:alert('欢迎你');"/>
```

#### JavaScript脚本执行原理

 - 网页请求的过程

用户输入网站域名——>DNS解析域名对应的IP地址——>通过IP地址找到对应的服务器——>服务器接受并处理用户的请求——>返回处理的结果（HTML，JS，CSS）封装成一个输入流传入到浏览器——>将文件流解析（HTML，JS，CSS）响应给用户

### 核型语法

 - 变量
 - 数据类型
 - 输入/输出
 - 语法约定
 - 注释
 - 控制语句运算符

#### 注释

 - 单行注释 //开始，以行尾结束

```javascript
// 这是一行注释
alert('hello'); //这也是注释
```

 - 多行注释以 /* 开始，以 */ 结束，指示中间的语句是该程序中的注释

```javascript
/*
for循环输出信息，通过
document.write输出到页面上
*/
for (var i = 0; i<10; i++) {
    document.write("<h3>Hello World</h3>");
}
```

#### 输入输出

 - alert()

```javascript
alert("提示信息");
```

 - prompt()

```javascript
prompt("提示信息", "输入框的默认信息");
prompt("请输入姓名", "张三");
var name = prompt("请输入姓名");
if (name != null && name != '') {
    document.write("Hello," + name);
}
``` 
 
 
 
 
 
#### 语法

JavaScript的语法和Java语言类似，每个语句以`;`结束，语句块用`{...}`。但是，JavaScript并不强制要求在每个语句的结尾加`;`，浏览器中负责执行JavaScript代码的引擎会自动在每个语句的结尾补上`;`

下面的一行代码就是一个完整的赋值语句：

```javascript
var x = 1;// var用于声明变量的关键字,x变量名
```

下面的一行代码是一个字符串，但仍然可以视为一个完整的语句：

```javascript
'Hello, world';
```

下面的一行代码包含两个语句，每个语句用;表示语句结束：

```javascript
var x = 1; var y = 2; // 不建议一行写多个语句!
```

也可以一次声明多个变量

```javascript
var x, y, z = 10; // 声明x，y，z变量都为10
```

不声明直接赋值

```javascript
width=5;
```

{...}语句块,通常是4个空格。缩进不是JavaScript语法要求必须的，但缩进有助于我们理解代码的层次

```javascript
if (4 > 1) {
    alert("大于1");
} else {
    alert("小于1");
}
```



### 数据类型

#### typeof检测变量的返回值

javascript拥有动态的类型,这意味着相同的变量可用作不同的类型，可以通过**`typeof`**检测变量的类型

```javascript
var a; // a为undefined
var a = 1; // a为数字
var a = false; // a为布尔值
var a = "str"; // a 为字符串

var str = 'Hello';
var a1 = 1;
var a2 = true;
var a3 = {};
console.info(typeof(str));
console.info(typeof(a1));
console.info(typeof(a2));
console.info(typeof(a3));
```

#### 数据类型

 - undefined 变量被声明后，但未被赋值
 - boolean true或false
 - string 用单引号或双引号来声明的字符串
 - number 整数或者否点数
 - object javascript中的对象，数组和null
 - null

### 运算符

| 类型 | 运算符 |
|------|--------|
|算数运算符| "+" "-" * / % ++ -- |
|赋值运算符|=|
|比较运算符| &gt;  &lt;  >=  <= == != |
|逻辑运算符| && ! |




### 逻辑控制语句

 - if 条件语句
 - switch多分支语句
 - for,while循环语句

#### if

```javascript
if (1 > 0) {
    alert("yes")
} else {
    alert("no");
}
```

#### else if

```javascript
if (1 > 2) {
    alert("yes")
} else if (1 > 0) {
    alert("ok");
} else {
    alert("no");
}
```

#### switch

**语法**

```javascript
switch(n)
{
case 1:
  执行代码块 1
  break;
case 2:
  执行代码块 2
  break;
default:
  n 与 case 1 和 case 2 不同时执行的代码
}
```

**例子**

```javascript
var n = "1";
switch(n)
{
case "1":
  alert(1);
  break;
case "2":
  alert(2);
  break;
default:
  alert("都不满足");
}
```

#### for

 **语法**

```javascript
for (初始化; 条件; 增量;) {
    js代码
}
```

 **例子**

```javascript
for (var i = 0; i < 10; i++) {
    document.write("<h5>" + "Hello," + i + "</h5>");
}
```


#### while

While 循环会在指定条件为真时循环执行代码块

**语法**

```javascript
while (条件) {
    需要执行的代码
}
```

**例子**

```javascript
var i = 0;
while (i < 5) {
    document.write("number i is " + i + "<br>");
    i++;
}
```


 
#### break,continue 中断循环

**break**用于跳出循环。

```javascript
for (var i = 0; i < 5; i++) {

	if (i == 3) {
		break;
	}
	document.write("The number is " + i + "<br>");
}
```

**continue** 用于中止本次循环中的迭代，不会跳出循环

```javascript
for (var i = 0; i < 5; i++) {

	if (i == 3) {
		continue;
	}
	document.write("The number is " + i + "<br>");
}
```






### Hello World 例子

```javascript
<html>
	<head>
		<title>Hello World</title>
		<script type="text/javascript">
			for (var i = 0; i < 5; i++) {
				document.write("<h3>" + "Hello World" + i + "</h3>");
			}
		</script>
	</head>
	<body>
		页面内容
	</body>
</html>
```

**根据输入的次数显示Hello World**

```javascript
<script type="text/javascript">
	var j = prompt("请输入要打印的次数");
	for (var i = 0; i < j; i++) {
		document.write("<h3>" + "Hello World" + i + "</h3>");
	}
	alert("总共打印了" + j + "次");
</script>
```

### 语法约定

 - 代码区分大小写
 - 变量，对象，函数名称都以驼峰命名
 - 分号；JavaScript并不强制要求在每个语句的结尾加;，浏览器中负责执行JavaScript代码的引擎会自动在每个语句的结尾补上;

`注意：JavaScript引擎自动加分号在某些情况下会改变程序的语义，导致运行结果与期望不一致，所以最好我们手动加上分号。`
 
### Debug 调试

 - 添加/删除断点
 - 单步进入
 - 单步跳过
 - 单步退出
 
### 总结

 - 阐述javascript的基本结构。
 - javascript在页面中的应用有哪几种？
 - 阐述下面typeof的值分别是什么？
 
```javascript
typeof("str");
typeof(17.92);
typeof(false);
typeof(1);
```

### 作业

 - 如何使用JavaScript接收用户输入的信息？
 - 使用JavaScript脚本输出一个正三角形