# jQuery基础

### 回顾

- setInterval()方法有什么作用？
- 如何改变浏览器地址栏中的网址？
- getElementByXXX()系列方法有哪些？

### 本章目标

- 会在网页中导入jQuery框架
- 掌握jQuery的基本语法
- 掌握jQuery对象与DOM对象的相互转换
- 会使用jQuery实现简单特效

### jQuery简介

- 官网地址http://jquery.com/
- jQuery由美国人John Resig于2006年创建


- jQuery是目前最流行的JavaScript程序库，它是对JavaScript对象和函数的封装
- 它的设计思想是write less,do more(写更少,做的更多)


![image](http://www.znsd.com/znsd/courses/uploads/05176ed02d9b27fae92830b96d214202/image.png)

### 初识jQuery

#### 实现隔行变色效果，只需一句关键代码

![image](http://www.znsd.com/znsd/courses/uploads/80398907c12161c3f7acac4e74572e73/image.png)

```js
$("tr:even").css("background-color","#ccc");
```

`本页代码只为了让学生对jQuery有个大致的印象，无需详细讲解`

### jQuery能做什么

- 访问和操作DOM元素
- 控制页面样式
- 对页面事件进行处理
- 扩展新的jQuery插件
- 与Ajax技术完美结合

`提示：jQuery能做的JavaScript也都能做，但使用jQuery能大幅提高开发效率`

### jQuery的优势

- 体积小，压缩后只有100KB左右
- 强大的选择器
- 出色的DOM封装
- 可靠的事件处理机制
- 出色的浏览器兼容性
- 使用隐式迭代简化编程
- 丰富的插件支持

### 获取jQuery

- 进入jQuery官网：http://jquery.com

  ![QQ图片20171215103946](http://www.znsd.com/znsd/courses/uploads/2be1b75d013751b4c945e7c2ddeb5c4c/20171215103946.png)

### jQuery库文件

- jQuery库分开发版和发布版

| 名称                       | 大小     | 说      明                           |
| ------------------------ | ------ | ---------------------------------- |
| jquery-1.版本号.js（开发版）     | 约268KB | 完整无压缩版本，主要用于测试、学习和开发               |
| jquery-1.版本号.min.js（发布版） | 约91KB  | 经过工具压缩或经过服务器开启Gzip压缩，主要应用于发布的产品和项目 |

- 在页面中引入jQuery

```js
<script src="js/jquery-1.8.3.js" type="text/javascript"></script>
```

`注意：由于js是从上往下逐行执行，所以jquery文件必须访问其他需要使用jquery的js文件之前。`

### jQuery基本语法

- 使用jQuery弹出提示框

  ```js
  <script>
    	// 为页面加载事件绑定方法 
      $(document).ready(function() {
          alert("我欲奔赴沙场征战jQuery，势必攻克之！");
      });
  </script>
  ```

- $(document).ready()

  ​

  $(document).ready()与window.onload类似，但也有区别

  ​

|      | window.onload                         | $(document).ready()                      |
| ---- | ------------------------------------- | ---------------------------------------- |
| 执行时机 | 必须等待网页中所有的内容加载完毕后（包括图片、flash、视频等）才能执行 | 网页中所有DOM文档结构绘制完毕后即刻执行，可能与DOM元素关联的内容（图片、flash、视频等）并没有加载完 |
| 编写个数 | 同一页面不能同时编写多个                          | 同一页面能同时编写多个                              |
| 简化写法 | 无                                     | $(function(){    //执行代码  }) ;            |



### 学员操作—编写第一个jQuery程序

需求说明：打开页面时，弹出窗口，提示信息为“我编写的第一个jQuery程序！

![image](http://www.znsd.com/znsd/courses/uploads/44c358cad5c7cbacdfa975d8badee1a1/image.png)

### DOM模型

#### DOM模型-1

浏览器可以把HTML文档显示成可视图形

![image](http://www.znsd.com/znsd/courses/uploads/8db177eebe77b256ba47728b6f5b4f49/image.png)

![image](http://www.znsd.com/znsd/courses/uploads/e6af73aebc68a20915d9afef7f755807/image.png)

#### DOM模型-2

浏览器把HTML文档的元素转换成节点对象，所有节点组成了一个树状结构

![image](http://www.znsd.com/znsd/courses/uploads/73ac506687ac5d05ad8fb3a19a83f2fa/image.png)

#### DOM模型-3

- 首先浏览器把这些节点对象按照一定顺序绘制到浏览器窗口中
- 以对象描述文档的方式就是DOM
- 节点对象就被称为DOM对象

### 节点类型

- 标签节点：文档中的所有标签

```html
<h2>……</h2>
```

- 内容节点：文档中的所有内容

```html
<p>你最喜欢的书籍是？ </p>
```

- 属性节点：标签节点的属性节点

```html
<p title="提示">……</p>
```

### DOM对象和jQuery对象

- DOM对象：直接使用JavaScript获取的节点对象

  ```js
  var objDOM=document.getElementById("title"); 
  var objHTML=objDOM.innerHTML;  
  ```

- DOM对象：使用jQuery包装DOM对象后产生的对象，它能够使用jQuery中的方法

  ```js
  $("#title").html( );
  //等同于
  document.getElementById("title").innerHTML; 
  ```

`注意：DOM对象和jQuery对象分别拥有一套独立的方法，不能混用`

### DOM对象转jQuery对象

可以使用$(dom对象) 函数进行转换：

```js
var txtName = document.getElementById("txtName"); //DOM对象
var $txtName = $(txtName);   //jQuery对象
```

`注意：jQuery对象命名一般约定以$开头。

### jQuery对象转DOM对象

jQuery对象是一个类似数组的对象，可以通过[index]的方法得到相应的DOM对象

```js
var $txtName = $ ("#txtName");      //jQuery对象
var txtName = $txtName[0];          //DOM对象
// 或者
var txtName = $txtName.get(0);  	//jQuery转DOM对象
```

`注意：`DOM对象不能使用jQuery的方法，jQuery也不能使用DOM对象中的方法`如果需要使用，需要进行转换`

### jQuery语法结构

- 工厂函数$()：将DOM对象转化为jQuery对象

- 选择器 selector：获取需要操作的DOM 元素

- 方法action()：jQuery中提供的方法，其中包括绑定事件处理的方法

  ```js
  $(selector).action();
  ```

  ```js
  $("#current").addClass("current");
  ```

  ​

### jQuery代码风格

- “$”等同于“ jQuery ”

  ```js
  $(document).ready()=jQuery(document).ready()
  $(function(){...})=jQuery(function(){...})
  ```


- 操作连缀书写

  ```js
  $("h2").css("background-color","#CCFFFF").next().css("display","block");
  ```

### 常用语法举例

| 语法              | 说      明      |
| --------------- | ------------- |
| css("属性","属性值") | 为元素设置CSS样式的值  |
| addClass()      | 为元素添加类样式      |
| next()          | 获得元素其后紧邻的同辈元素 |

css()使用

```js
$("#text").css("font-size", "50px");
```

addClass()使用

```css
<style>
	.text {
		text-align: center;
	}
</style>
```

```html
<p id="txtName">测试</p>
```

```js
$("#txtName").addClass("text");
```

next()使用

```html
<p id="txtName">测试</p>
<span>相邻元素</span>
```

```js
$("#txtName").next().html();
```



### 学员操作

#### 使用jQuery变换网页效果

- 需求说明：单击标题“你是人间的四月天”后，标题字体大小、颜色发生变化，正文的字体大小发生变化，网页中所有元素的边距发生变化，所有文本的行高发生变化

![image](http://www.znsd.com/znsd/courses/uploads/d852d698057145a1275f9dbd194a62a2/image.png)

![image](http://www.znsd.com/znsd/courses/uploads/0ff882b7017b84a9d7ba1900584c7bae/image.png)

- 实现思路
  1. 在新建的HTML文档中引入jQuery库
  2. 使用$(document).ready()创建文档加载事件
  3. 使用$(选择器)选取所需元素
  4. 使用css()方法为所选取的元素添加CSS样式

#### 使用addClass()为图片添加边框

- 需求说明：点击页面中的图片后，图片外围加上边框

  ![image](http://www.znsd.com/znsd/courses/uploads/e2dd58f4474ea7e09226e3f78f200a5b/image.png)

  ![image](http://www.znsd.com/znsd/courses/uploads/0631e6aee93cc943253629cb58edc73d/image.png)

#### 制作帮助中心问答特效

- 需求说明：点击标题后，显示回答的内容，同时标题加上背景色

  ![image](http://www.znsd.com/znsd/courses/uploads/af2d27783473758b4ddf725b3efc96aa/image.png)

  ![image](http://www.znsd.com/znsd/courses/uploads/9ee1c55a46db12e75e8c6c2704ef7fbf/image.png)

  ​

#### 使用jQuery方式弹出消息

- 需求说明：点击页面中的文字“请为我们的服务做出评价”，弹出消息框，显示“非常满意”

- 将DOM对象转换为jQuery对象，再调用jQuery对象的方法

  ![image](http://www.znsd.com/znsd/courses/uploads/ed03eee84eebac37485c37e0feba1ccf/image.png)

- 实现思路：

  1. 在新建的HTML文档中引入jQuery库
  2. 使用$(document).ready()创建文档加载事件
  3. 获取DOM对象
  4. 将DOM对象转换成jQuery 对象
  5. 使用jQuery对象的click()方法，弹出对话框

#### 使用DOM方式判断复选框选中状态

需求说明：使用DOM方式进行判断，当复选框选中时，弹出窗口

![image](http://www.znsd.com/znsd/courses/uploads/6093951d778ab5f1b26bda73c596b157/image.png)

### 总结

- jQuery的基本语法结构是
- 常用选择器
  1. ID选择器
  2. 标签选择器
  3. 类选择器
- 设置样式的方法
  1. css()
  2. addClass()
- DOM对象和jQuery对象可以相互转化

### 作业

- 什么是jQuery，jQuery的理念是什么？
- jQuery的优势？
- jQuery的基本语法结构是？
- DOM对象和jQuery对象如何相互转换？
- $(document).ready()与window.onload的区别？