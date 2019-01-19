# DOM

### Document对象常用方法

 - getElementById() 返回对拥有指定id的第一个对象的引用
 - getElementsByName() 返回带有指定名称的对象的集合
 - getElementsByTagName() 返回带有指定标签名的对象的集合
 - getElementsByClassName() 返回带有指定类名的对象的集合
 - write() 向文档写文本、HTML表达式或JavaScript代码

### 四种访问页面元素的区别

 - getElementById() 按元素的id来访问
 - getElementsByName() 按元素的name来访问
 - getElementsByTagName() 按元素的标签来访问
 - getElementsByClassName() 按元素的样式类名来访问

### 例子

 - 动态改变层、标签中的内容

```html
<div id="myDiv">
	123123123
</div>
<input type="button" onclick="test();" value="改变div内容">
```

```javascript
function test() {
	var myDiv = document.getElementById('myDiv');
	myDiv.innerText = "456";
}
```

 - 访问相同name的元素

```html
<input type="checkbox" name="like">吃饭</input>
<input type="checkbox" name="like">上网</input>
<input type="button" onclick="test();" value="选中">
```

```javascript
function test() {
    var like = document.getElementsByName("like");
	for (var i = 0; i < like.length; i++) {
		like[i].checked = true;
	}
}
```

 - 访问相同标签的元素

```html
<a href="http://www.baidu.com">百度</a>
<a href="http://www.360.com">360</a>
<input type="button" onclick="test();" value="测试">
```

```javascript
function test() {
    var inputs = document.getElementsByTagName("a");
    for (var i = 0; i < inputs.length; i++) {
        console.info(inputs[i].href);
    }
}
```

 - div显示输入的信息

```html
学号：<input id="id" type="text"/>
姓名：<input id="name" type="text"/>
性别：<input id="gender" type="text"/>
年龄：<input id="age" type="text"/>
<div id="studentDiv"></div>
<input type="button" onclick="test();" value="测试">
```

```javascript
var id = document.getElementById("id");
var name = document.getElementById("name");
var gender = document.getElementById("gender");
var age = document.getElementById("age");

var studentDiv = document.getElementById("studentDiv");
studentDiv.innerHTML = id.value + "<br>" + name.value + "<br>" + gender.value + "<br>" + age.value + "<br>";
```

### 元素的显示和隐藏

#### visibility
    
 - visible 表示元素是可见的
 - hidden 表示元素是不可见的

```javascript
object.style.visibility="值"
```
    
#### display

 - none 表示此元素不会被显示
 - block 表示此元素将显示为块级元素，此元素前后会带有换行符

```javascript
object.style.display="值"
```

**显示/隐藏ul例子**

```html
<ul id="u1" style="display:block;">111</ul>
<input type="button" onclick="show();" value="显示/隐藏">
```

```javascript
function show() {
	var ul = document.getElementById("u1");
	if('block' == ul.style.display) {
		ul.style.display = "none";
	} else {
		ul.style.display = "block";
	}
}
```

**复选框全选效果**

```html
全选<input type="checkbox" onchange="selectAll(this);"/><br>
<input name="studentId" type="checkbox" /><br>
<input name="studentId" type="checkbox" /><br>
<input name="studentId" type="checkbox" /><br>
<input name="studentId" type="checkbox" /><br>
<input name="studentId" type="checkbox" /><br>
<input name="studentId" type="checkbox" /><br>
<input name="studentId" type="checkbox" /><br>
```

```javascript
function selectAll(checkbox) {
	var checkboxArr = document.getElementsByName("studentId");
	for (var i = 0; i < checkboxArr.length; i++) {
		checkboxArr[i].checked = checkbox.checked;
	}
}
```

```javascript
function hidden_b2(){
    document.getElementById("b2").style.visibility="hidden";
}
function none_b2(){
    document.getElementById("b2").style.display="none";
}
```

 
 
 
  
# DOM-2章节

### 本章目标

 - 使用getElement系列方法实现DOM元素的查找和定位
 - 使用Core DOM标准操作实现节点的增删改查
 - 使用HTML DOM特有操作实现HTML元素内容修改

### W3C规定的三类DOM标准接口

 - Core DOM（核心DOM）适用于各种结构化文档
 - XML DOM 专注于XML文档
 - HTML DOM 专用于HTML文档
 
### Core DOM的操作

#### 查看节点

 - 访问指定节点方法

```javascript
getElementById(); //返回一个节点对象
getElementsByName(); //返回多个（节点数组）
getElementsByTagName(); //返回多个（节点数组）
```

 - 查看/修改节点属性

```javascript
getAttribute("属性名"); //获取属性值
setAttribute("属性名","属性值"); // 设置属性值
```

 - 根据层次关系查找节点

如果编程时希望访问某个元素的父元素，但又不知道父元素的ID、name、tag，怎么办？

 - parentNode 返回元素的父节点
 - firstChild 返回元素的首个子节点
 - lastChild 返回元素的最后一个子元素
 - childNodes 返回元素子节点的 NodeList

 **parentNode 例子**

```javascript
var div = document.getElementById("stuName").parentNode;
```

**firstChild 例子**

```javascript
document.firstChild
```

**lastChild 例子**

```javascript
document.lastChild
```

**childNodes[i] 例子**

```javascript
document.getElementById("form").childNodes;
```

`注意`：使用childNodes时，浏览器会将空格和换行当成一个子节点。

```html
<table id="stuTable" border="1"><thead><tr><td>学号</td><td>姓名</td></tr></thead><tbody><tr><td>1</td><td>张山</td></tr></tbody></table>
```

```javascript
var stuTable = document.getElementById("stuTable");
stuTable.firstChild.firstChild.firstChild.innerHTML = "动态改变";
```

 
#### 创建和追加节点

 - createElement() 创建节点  
 - appendChild() 末尾追加方式插入节点
 - insertBefore() 在指定节点前插入新节点

 **例子**
 
 ```html
 <div id="newDiv">111</div>
<input type="button" onclick="newNode();" value="newNode">
 ```
 
 ```javascript
 // 创建节点例子
 function newNode() {
        var newDiv = document.getElementById("newDiv");
        var img = document.createElement("img");
        img.setAttribute("src", "a.jpg");
        // img=需要追加的节点，newDiv需要加入到的节点
        document.body.insertBefore(img, newDiv);
}
 ```
 
 ```javascript
 // 复制图片例子
 function copyNode() {
        var image = document.getElementById("image");
        var copyImg = image.cloneNode(false);
        document.body.appendChild(copyImg);
}
 ```
 
#### 删除和替换节点

 - removeChild() 删除节点
 - replaceChild() 替换节点
 
**例子**

```javascript
function deleteNode() {
    var image = document.getElementById("image");
    document.body.removeChild(image);
}
```

### HTML DOM 特有对象的操作（table）

#### 什么是dom对象

//需要插入图片
HTML文档中的每个节点都是DOM对象，每类对象都有1套属性、方法。最常用的是<table>表格和各类表单<form>元素对象

#### HTML DOM对象 的属性访问

```html
<img id="changeImg" src="a.jpg" style="width:100px;height:100px;" alt="图片提示">
<input type="button" onclick="changeAttr();" value="changeImg"/>
```

```javascript
function changeAttr() {
	var img = document.getElementById("changeImg");
	img.src = "b.jpg";
	alert(img.alt);
}
```

#### HTML DOM对象操作table

**table对象常用属性方法**

 - 属性 rows[] 返回包含表格中所有行的一个数组
 - 方法 insertRow() 在表格中插入一个新行
 - 方法 deleteRow() 从表格中删除一行

```html
<table id="table" border="1">
	<tr>
		<td>姓名</td>
		<td>年龄</td>
	</tr>
	<tr>
		<td>张山</td>
		<td>20</td>
	</tr>
	<tr>
		<td>李四</td>
		<td>24</td>
	</tr>
	<tr>
		<td>麻子</td>
		<td>30</td>
	</tr>
</table>
<input type="button" onclick="opeTable();" value="opeTable">
```

```javascript
function opeTable() {
	var table = document.getElementById("table");
	console.info(table.rows);
	//table.insertRow(1);
	table.deleteRow(2);
}
```

#### tableRow中的行属性和对象

 - 属性 cells 返回包含行中所有单元格的一个数组
 - 属性 rowIndex 返回该行在表中的位置
 - 方法 insertCell() 在一行中的指定位置插入一个空的<td>标签
 - deleteCell() 删除行中指定的单元格

#### tableCell单元格对象属性

 - cellIndex 返回单元格在某行单元格集合中的位置
 - innerHTML 设置或返回单元格的开始标签和结束标签之间的HTML
 - align 设置或返回单元格内部数据的水平排列方式
 - className 设置或返回元素的class属性

#### 动态插入表格数据

```javascript
function addRow() {
	var table = document.getElementById("table");
	var newRow = table.insertRow(3);

	var oneCell = newRow.insertCell(0);
	oneCell.innerHTML = "动态的";

	var towCell = newRow.insertCell(1);
	towCell.innerHTML = "100";
	towCell.align = "center";
}

function delRow() {
    // ... 删除行
}

function updateRow() {
    // ... 更新行
}
```

### 总结

 - W3C提供了DOM的哪三类标准？
 - Core DOM包括哪些常用的节点操作？方法分别是什么？
 - Core DOM、HTML DOM访问属性的方法分别是什么？
 - HTML DOM对象-table相关对象包括哪些？分别包含哪些常用的属性、方法？

### 作业

 1. Core DOM包括哪些常用的节点操作？方法分别是什么？
 2. Core DOM、HTML DOM访问属性的方法分别是什么？
 3. HTML DOM对象-table相关对象包括哪些？分别包含哪些常用的属性、方法？

 
 
 