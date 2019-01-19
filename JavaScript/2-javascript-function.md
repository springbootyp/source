# 函数和window对象

### 一.什么是函数

 - 函数的含义：类似于java中的方法，是完成特定功能的代码语句块
 - 使用简单：和java不同的事不用定义属于某个类，直接使用

### 二.自定义函数

```javascript
// 创建无参数的函数
function functionName() {

}
// 创建有参数的函数
function functionName(arg0, arg1, arg2) {
    
}

var testFunction = function() {

}
```

**调用函数** 函数的调用一般是和表单元素一起使用，调用格式如`事件名=方法名()`

**调用无参函数**

```javascript
<script language="javascript" type="text/javascript">
function testFun(){
    alert("hello");
}
</script>
<input type="button" onclick="testFun()" value="点我打印"></input>
```

**调用有参函数**

```javascript
<script language="javascript" type="text/javascript">
	function showHelloWorld(count) {
		for (var i = 0; i < count; i++) {
			document.write("<h3>" + "Hello World" + i + "</h3>");
		}
		alert("总共打印了" + count + "次");
	}
</script>
<input type="button" value="点击" onClick="showHelloWorld(5);"></input>
```

### 匿名函数

```javascript
事件名=function(){...}

(function(){
//javascript代码
}())

<input type="button" value="点击匿名函数" onClick="(function(){alert('点击了匿名函数');}())"></input>
```

### 直接运行函数

```javascript

window.onload = function(){
	alert(11);
};

function load(){
    alert('onload');
}
<body onload="load();"></body>
```

### 构造函数

```javascript
// 定义构造函数
function Student(id, name) {
    this.id = id;
    this.name = name;
}

//调用构造函数
Student(1, "sss"); // 作为普通函数的调用
console.info(window.name);

var student = new Student(10, "xxx"); // 作为构造函数的调用
console.info(student.id);
```

    两者的区别：普通函数调用，会将函数当做普通函数，构造函数中的this会被当做window对象。构造函数调用，构造函数中的this是当前创建的对象
### this

this是Javascript语言的一个关键字。它代表函数运行时，自动生成的一个内部对象，只能在函数内部使用。比如，

```js
　　function test(){
　　　　this.x = 1;
　　}
```

随着函数使用场合的不同，this的值会发生变化。但是有一个总的原则，那就是this指的是，`调用函数的那个对象`。下面分四种情况，详细讨论this的用法。

#### 一、纯粹的函数调用

这是函数的最通常用法，属于全局性调用，因此this就代表全局对象Global。请看下面这段代码，它的运行结果是1。

```js
<script>
	function test(){
  		this.x = 1;
  		alert(this.x);
　　}
	test(); // 1
</script>
```

为了证明this就是全局对象

```js
<script>
	var x = 1;
	function test(){　　　　
		alert(this.x);
　　}
	test(); // 1
</script>
```

运行结果还是1。再变一下

#### 二、作为构造函数调用

所谓构造函数，就是通过这个函数生成一个新对象（object）。这时，this就指这个新对象。

```js
function test(){
	this.x = 1;
}
var o = new test();
alert(o.x); // 1
```

运行结果为1。为了表明这时this不是全局对象，我对代码做一些改变

```js
var x = 2;
function test(){
	this.x = 1;
}
var o = new test();
alert(x); //2
```
### 三.系统函数

 - parseInt("") 将字符串转换为整型数字

```javascript
var a = "123";
var b = parseInt(a);
console.info(b);
console.info(typeof(b));
```

 - parseFloat("字符串") 将字符串转换为浮点型数字

```javascript
// 将字符串"12.34"转换为浮点型12.34数字
parseFloat("12.34"); 

var d = parseFloat("12.34567"); 
// 保留两位小数并四舍五入
console.info(d.toFixed(2));
```

 - isNaN("") 检查参数是否为非数字

```javascript
console.info(isNaN("123"));
console.info(isNaN("str"));
```

 - encodeURI()和decodeURI() 将字符串进行编码和解码

```javascript
console.info(encodeURI("https://www.baidu.com?key=js对象/"));
console.info(decodeURI("https://www.baidu.com?key=js%E5%AF%B9%E8%B1%A1/"))
```

 - eval("") 将参数字符串作为js代码来执行

```javascript
eval("alert('hello world')");

// eval返回json数据
var json = "{'id':1,'name':'李四'}";
var obj = eval('(' + json + ')');
console.info(obj);
```


### 变量的作用域

```javascript
<script language="javascript" type="text/javascript">
var num; //全局变量
function sayHello() {
    // num=2; 局部变量
	for (var i = 0; i < num; i++) {
		document.write("<h3>Hello world</h3>");
	}
}

function count() {
	num = prompt("请输入需要打印的次数");
	sayHello();
}
</script>

<input type="button" value="点击我" onclick="count();"></input>
```
### 总结

 - 如何创建一个有参函数并实现函数调用？
 - 全局变量和局部变量的区别是什么？


