# CSS交互



### 回顾样式表

#### 样式表的基本语法

- 标签选择器
- ID选择器
- 类选择器

标签选择器

```css
input{
   width:120px;
   border:solid 1px #ff0000;
}
```

ID选择器

```css
#flow{
  color:#ff0000
}
```

类选择器

```css
.center{
   text-align:center;
   font-weight:bold;
}
```

### 常见样式

- 文本属性
- 背景属性
- 边框属性
- 边界属性
- 填充属性
- 浮动属性
- 列表属性
- 定位属性

| 类别   | 属性             | 描述          |
| ---- | -------------- | ----------- |
| 文本属性 | font-size      | 字体大小        |
|      | font-family    | 字体类型        |
| 边框属性 | border         | 设置四个边框所有的属性 |
|      | border-width   | 设置边框的宽度     |
|      | border-style   | 设置边框的样式     |
|      | border-color   | 设置边框的颜色     |
| 边界属性 | margin         | 设置所有外边框属性   |
|      | margin-left    | 设置元素的左外边距   |
|      | margin-right   | 设置元素的右外边距   |
|      | margin-top     | 设置元素的上外边距   |
|      | margin-bottom  | 设置元素的下外边距   |
| 填充属性 | padding        | 设置元素的所有内边距  |
|      | padding-left   | 设置元素的左      |
|      | padding-right  | 设置元素的右      |
|      | padding-top    | 设置元素的上      |
|      | padding-bottom | 设置元素的下      |

### 样式表类型

- 行内样式
- 内部样式表
- 外部样式表

行内样式

```css
<input name="user" type="text" style="width:100px; border:solid 1px #cccccc;" />
```

内部样式

```css
<html>
<head>
<title>内部样式表</title>
<style type="text/css">
    body{
		font-size:12px;	
		line-height:20px;
	}
   .video{
		margin: 3px;
		float: left;
	}
</style>
</head>
```

外部样式

外部样式使用<link>标签链接到外部样式文件

```css
<html>
<head>
<title>外部样式表</title>
<link rel="stylesheet" href="style.css" type="text/css" />
</head>
<body>
……
</body>
</html>
```

### JavaScript访问样式的常用方法

- 使用getElement系列方法访问元素
- 改变样式属性：
  1. style属性
  2. className属性

```js
document.getElementById("titles").style.color="#ff0000"; // 真确
document.getElementById("titles").style.font-size="25p"; // 错误
```

### style对象的属性

| 类别          | 属性            | 描述          |
| ----------- | ------------- | ----------- |
| Padding（边距） | padding       | 设置元素的填充     |
|             | paddingTop    | 设置元素的上填充    |
|             | paddingBottom | 设置元素的下填充    |
|             | paddingLeft   | 设置元素的左填充    |
|             | paddingRight  | 设置元素的右填充    |
| Border （边框） | border        | 设置四个边框所有的属性 |
|             | borderTop     | 设置上边框的属性    |
|             | borderBtttom  | 设置下边框的属性    |
|             | borderLeft    | 设置左边框的属性    |
|             | borderRight   | 设置右边框的属性    |

### JavaScript访问样式的应用

#### 通过js实现图片选中聚焦效果

![20171214162854](http://www.znsd.com/znsd/courses/uploads/e0316b624aca10084b6d9f6b86d3f603/20171214162854.png)

### 思路

- 把图书图片放在一个div中
- 通过图片的获取焦点事件(onmouseover)来设置style属性
- 通过图片的失去焦点事件(onmouseout)来还原style属性

```css
  <style>
	.img {
		width:150px;
		height:150px;
		border:solid 1px #c9c9cb;
		margin-right: 10px;
		float:left;
	}
  </style>
```

```html
<body>
	<div class="img">
		<img src="./images/1.jpg" onmouseout="unSelect(this);" onmouseover="setSelect(this);" width="150px" height="150px">
	</div>
	<div class="img">
		<img src="./images/2.jpg" onmouseout="unSelect(this);" onmouseover="setSelect(this);" width="150px" height="150px">
	</div>
	<div class="img">
		<img src="./images/3.jpg" onmouseout="unSelect(this);" onmouseover="setSelect(this);" width="150px" height="150px">
	</div>
 </body>
```

```js
<script>
	function setSelect(img){
		img.style.border = "solid 1px red";
	};

	function unSelect(img) {
		img.style.border = "solid 1px #c9c9cb";
	}
</script>
```

### 获取行内样式的方法

document.getElementById(elementId).样式属.样式性值

```html
<span id="test" style="color:red;">11111</span>
```

```js
var test = document.getElementById("test");
var spanColor = test.style.color;
```

### 课后作业

1. JavaScript访问样式的常用方式有哪些？
2. 常用选择器有哪几种？优先级是怎样的？
3. CSS样式表有哪几种？如何导入外部样式表？
4. JavaScript中有哪些常用样式属性？