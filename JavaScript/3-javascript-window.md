# window对象

window表示浏览器窗口，所有的浏览器都支持window对象，`所有的JavaScript全局对象、函数以及、变量均自动成为window对象的成员。`全局变量是 window 对象的属性。全局函数是 window 对象的方法。HTML DOM的document也是window对象的属性之一

```javascript
window.document.getElementById("header");
// 等价于
document.getElementById("header");
```

### 常用属性

 - screen 有关客户端的屏幕和显示性能的信息
 - history 有关客户访问的URL信息
 - location 有关当前URL·的信息

#### screen

每个 Window 对象的 screen 属性都引用一个 Screen 对象。Screen 对象中存放着有关显示浏览器屏幕的信息。JavaScript 程序将利用这些信息来优化它们的输出，以达到用户的显示要求。例如，一个程序可以根据显示器的尺寸选择使用大图像还是使用小图像，它还可以根据显示器的颜色深度选择使用 16 位色还是使用 8 位色的图形。另外，JavaScript 程序还能根据有关屏幕尺寸的信息将新的浏览器窗口定位在屏幕中间。

| 属性                   | 描述                           |
| -------------------- | ---------------------------- |
| availHeight          | 返回显示屏幕的高度 (除 Windows 任务栏之外)。 |
| availWidth           | 返回显示屏幕的宽度 (除 Windows 任务栏之外)。 |
| bufferDepth          | 设置或返回调色板的比特深度。               |
| colorDepth           | 返回目标设备或缓冲器上的调色板的比特深度。        |
| deviceXDPI           | 返回显示屏幕的每英寸水平点数。              |
| deviceYDPI           | 返回显示屏幕的每英寸垂直点数。              |
| fontSmoothingEnabled | 返回用户是否在显示控制面板中启用了字体平滑。       |
| ``height``           | 返回显示屏幕的高度。                   |
| logicalXDPI          | 返回显示屏幕每英寸的水平方向的常规点数。         |
| logicalYDPI          | 返回显示屏幕每英寸的垂直方向的常规点数。         |
| pixelDepth           | 返回显示屏幕的颜色分辨率（比特每像素）。         |
| updateInterval       | 设置或返回屏幕的刷新率。                 |
| `width`              | 返回显示器屏幕的宽度。                  |


#### history

History对象包含用户（在浏览器窗口中）访问过的 URL。
它window对象的一部分，可通过 window.history 属性对其进行访问。

 - back() 加载 history 列表中的前一个 URL（返回）
 - forward() 加载 history 列表中的下一个 URL（前进）
 - go() 加载 history 列表中的某个具体页面。

```javascript
<input type="button" onclick="window.history.back();" value="返回"></input>

<input type="button" onclick="history.forward();" value="前进"></input>

<input type="button" onclick="window.history.go(2);" value="go"></input>
```

#### location

Location 对象存储在 Window 对象的 Location 属性中，表示那个窗口中当前显示的文档的 Web 地址。它的 href 属性存放的是文档的完整 URL

```javascript
window.location.href = "www.baidu.com";
```

**location对象属性**

| 属性       | 描述                          |
| -------- | --------------------------- |
| hash     | 设置或返回从井号 (#) 开始的 URL（锚）。    |
| host     | 设置或返回主机名和当前 URL 的端口号。       |
| hostname | 设置或返回当前 URL 的主机名。           |
| href     | 设置或返回完整的 URL。               |
| pathname | 设置或返回当前 URL 的路径部分。          |
| port     | 设置或返回当前 URL 的端口号。           |
| protocol | 设置或返回当前 URL 的协议。            |
| search   | 设置或返回从问号 (?) 开始的 URL（查询部分）。 |


**location对象方法**

| 属性        | 描述           |
| --------- | ------------ |
| assign()  | 加载新的文档。      |
| reload()  | 重新加载当前文档。    |
| replace() | 用新的文档替换当前文档。 |

### 常用方法

 - prompt 提示用户输入的对话框

```javascript
var value = prompt("请输入");
alert(value);
```

 - alert 显示带有一个提示信息和一个确定按钮的警示框
 - confirm 显示一个带有提示信息、确定和取消按钮的对话框 

```javascript
var v = confirm("是否确认删除用户信息");
if (v) {
    alert("删除成功");
} else {
    alert("删除失败");
}
```
 - close 关闭浏览器窗口

```javascript
// 新版的Chrome和Firefox无法使用，浏览器安全限制
function closeWin(){
    window.close();
}

function closeWindow() {
  	mywindow.close();
}

mywindow = window.open('', '','width=200,height=300');
mywindow.document.write('新窗口');

<input type="button" value="点击关闭" onclick="closeWindow();"></input>
```

 - open 打开一个新浏览器窗口，加载指定的URL

window.open("URL", "名称", "属性配置");

| 名称                | 说明                                       |
| ----------------- | ---------------------------------------- |
| height、width      | 窗口文档显示区的高度、宽度。以像素计                       |
| left、top          | 窗口的x坐标、y坐标，以像素计                          |
| toolbar=yes,no    | 是否显示浏览器的工具栏，黙认是yes                       |
| scrollbars=yes,no | 是否显示滚动条，默认是 yes                          |
| location=yes,no   | 是否显示地址字段，默认是 yes                         |
| status=yes,no     | 是否添加状态栏，默认是 yes                          |
| menubar=yes,no    | 是否显示菜单栏。默认是 yes                          |
| resizable=yes,no  | 窗口是否可调节尺寸，默认是 yes                        |
| titlebar=yes,no   | 是否显示标题栏，默认是 yes                          |
| fullscreen=yes,no | 是否使用全屏模式显示浏览器。默认是 no。处于全屏模式的窗口必须同时处于剧院模式。 |


```javascript
function openWindow() {
	window.open("http://www.baidu.com", "百度", "width=300,height=500");
}
```

 - setTimeout 在指定的`毫秒`数后调用函数或计算表达式

```javascript
window.setTimeout(function(){
	alert("开始执行");
}, 3000);
```

  - setInterval 按照指定的周期（以`毫秒`计）来调用函数或表达式

```javascript
window.setInterval(function(){
	console.info(222);
}, 3000);
```

### window对象常用事件

 - onload 一个页面（图像）完成加载
 - onmouseover 鼠标移到某元素之上
 - onmouseout 鼠标移出某个元素之时
 - onlick 当用户单击某个对象时调用的事件句柄
 - onkeydown 键盘按键被按下
 - onkeyup 键盘按键被放开
 - onchange 内容被改变
 - onblur 失去焦点
 - onfocus 获得焦点

通过 `onkeydown`事件来实现文本框只能输入数字

```javascript
function noNumber(e){
	return !isNaN(e.key);
}
<input type="text" onkeydown="return noNumber(event);"></input>
```

### 制作时钟特效

#### 思路

由于涉及到时间的显示问题，所以要用到日期对象Date，还有时间在不停地走，因此需要不断地调用函数，所以要用到windows的定时器setInterval( )方法。

#### Date对象

```javascript
var date = new Date("september 12,2017,12:10:50") // 参数格式MM  DD,YYYY,hh:mm:ss
```

#### Date对象的方法

 - setSeconds 和 setMinutes         0 至 59 
 - setHours     0 至 23 
 - setDay       0 至 6（星期几） 
 - setDate      1 至 31（月份中的天数） 
 - setMonth     0 至 11（一月至十二月）


```javascript
function printTime() {
	var date = new Date();
	var dateTime = date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds();
	document.getElementById("clockDiv").innerHTML = dateTime;
}

function clock() {
	printTime();
	setInterval("printTime()", 1000);
}
```

### 制作自动移动窗口特效

![auto_move](http://www.znsd.com/znsd/courses/uploads/ab949a932154baf1d4d58ed86fbb8a00/auto_move.gif)

实现思路

- 需要创建window对象
- 调用window对象中的moveTo(left, top);方法`注意：此方法仅支持IE浏览器`
- 需要用到setInterval方法

### 总结

 - window对象有哪些常用的方法及其含义？
 - 请列举Date对象有哪些方法？
 - 请解释setTimeout()方法与setInterval()方法的区别，及各自适用场合？
 - 请举例说明事件onload和onclick的用法