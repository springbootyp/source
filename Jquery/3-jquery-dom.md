# jQuery操作DOM对象

### 回顾及作业点评

- 列举至少4种基本选择器？
- 合并元素集合使用哪种选择器？
- 后代选择器和子选择器有什么区别？

### 本章目标

- 使用jQuery操作CSS样式`重要`
- 使用jQuery操作文本与属性值内容`重要`
- 使用jQuery操作DOM节点`重要`
- 使用jQuery遍历DOM节点`重要`
- 使用jQuery操作CSS-DOM

### DOM操作分类

DOM操作分为三类：

- DOM Core：任何一种支持DOM的编程语言都可以使用它，如getElementById()
- HTML-DOM：用于处理HTML文档，如document.forms
- CSS-DOM：用于操作CSS，如element.style.color="green"

`提示：`JavaScript用于对(x)html文档进行操作，它对这三类DOM操作都提供了支持

### jQuery中的DOM操作

- jQuery对JavaScript中的DOM操作进行了封装，使用起来也更简便
- jQuery中的DOM操作可分为：
  1. 样式操作
  2. 内容及Value属性值操作
  3. 节点操作
  4. 节点属性操作
  5. 节点遍历
  6. CSS-DOM操作

`提示：`“元素”和“节点”含义大同小异，本章并不严格区分

### 直接设置样式值

使用css()为指定的元素设置样式值

```js
css(name,value); // 设置单个属性
// 或
css({name:value, name:value,name:value…}); // 同时设置多个属性
```

例如：

```js
$(this).css("border","5px solid #f5f5f5");
// 或
$(this).css({"border":"5px solid #f5f5f5","opacity":"0.5"}); // opacity设置透明度
```

### 动态添加边框效果

- 使用css()添加边框效果

  ![20171219174111](http://www.znsd.com/znsd/courses/uploads/a54d8533fab08822d77536e4eaa75f48/20171219174111.png)

![20171219174309](http://www.znsd.com/znsd/courses/uploads/676d572109c66a1145e9583de7c49305/20171219174309.png)

### 追加和移除样式

- 追加样式

  ```js
  addClass(class);
  //或
  addClass(class1 class2 … classN);
  ```

- 移除样式

  ```js
  removeClass("style2")
  //或
  removeClass("style1 style2");
  ```

  ![image](http://www.znsd.com/znsd/courses/uploads/00f7e2b5db4d62834b3de6c350fa8eb3/image.png)

### 切换样式

- toggleClass() 如果存在就删除，不存在就添加。（模拟了addClass()与removeClass()实现样式切换的过程）

![20171219200749](http://www.znsd.com/znsd/courses/uploads/a38a6260194dc7a5dfb4a9194c6ab0b2/20171219200749.png)

```html
<ul id="menu">
  	<li>注册登录</li>
  	<li>易付宝账户激活</li>
  	<li>易付宝实名认证</li>
  	<li>密码相关</li>
  	<li>会员购买</li>
</ul>
```

```js
$(document).ready(function() {
		$("#menu li").on("mouseover", function() {
			$(this).toggleClass("mouseover");
		});
		$("#menu li").on("mouseout", function() {
			$(this).removeClass("mouseover");
		});
});
```

改用toggleClass()方法实现同样的效果

```js
$("#menu li").on("mouseover mouseout", function() {
	$(this).toggleClass("menu_color");
});
```

### HTML代码操作

- html()可以对HTML代码进行操作，类似于JS中的innerHTML

  ```js
  $("div.left").html(); // 获取元素中的html代码
  // 或者
  $("div.left").html("<div class='content'>…</div>"); // 设置元素中的html代码
  ```

### 文本操作

- text()可以获取或设置元素的文本内容

  ```js
  $("div.left").text(); // 获取元素中的文本内容
  // 或者
  $("div.left").text("<div class='content'>…</div>"); // 设置元素中的文本内容
  ```

### html()和text()的区别

| 语法             | 参数                  | 功能                      |
| -------------- | ------------------- | ----------------------- |
| html()         | 无参数                 | 用于获取第一个匹配元素的HTML内容或文本内容 |
| html(content)  | content参数为元素的HTML内容 | 用于设置所有匹配元素的HTML内容或文本内容  |
| text()         | 无参数                 | 用于获取所有匹配元素的文本内容         |
| text (content) | content参数为元素的文本内容   | 用于设置所有匹配元素的文本内容         |

### 获取与设置节点属性

- attr()用来获取与设置元素属性

  ```js
  $newNode4.attr("alt"); // 获取alt属性值
  //或
  $("img").attr({width:"50",height:"100"}); // 设置width、height属性的值
  ```

  ​

- removeAttr()用来删除元素的属性

  ```js
  $newNode2.removeAttr("title"); // 删除元素的title属性
  ```

### Value值操作

- val()可以获取或设置元素的value属性值

  ```js
  $(this).val(); // 获取元素的value属性值
  //或
  $(this).val(""); // 设置元素的value属性值
  ```

### 学员操作

#### 制作今日团购模块

需求说明：当鼠标移过商品信息时，添加如右一所示的样式，边框及背景颜色变为#D51938，说明文字变为白色，鼠标移出时，恢复初始状态

![image](http://www.znsd.com/znsd/courses/uploads/cca9675effcf1aa6d6810857399b32bd/image.png)

#### 制作YY安全中心登录框特效

需求说明：当文本框获得焦点时，文本框内默认文字消失，失去焦点时，文本框内提示文字再次出现

![image](http://www.znsd.com/znsd/courses/uploads/82571a41182636a998ba2754e56dfd54/image.png)

![image](http://www.znsd.com/znsd/courses/uploads/8b60cb989899da09d96a06465776b9a7/image.png)

### 节点操作

- jQuery中节点操作主要分为：
  1. 查找节点
  2. 创建节点
  3. 插入节点
  4. 删除节点
  5. 替换节点
  6. 复制节点

#### 创建节点元素

工厂函数$()用于获取或创建节点

- $(selector)：通过选择器获取节点
- $(element)：把DOM节点转化成jQuery节点
- $(html)：使用HTML字符串创建jQuery节点

```js
var $newNode2=$("<li title='标题为千与千寻'>千与千寻</li>"); // 创建含文本与属性<li>元素节点
```

#### 插入子节点

- 元素内部插入子节点

| 语法                 | 功能                                       |
| ------------------ | ---------------------------------------- |
| append(content)    | $(A).append(B)表示将B追加到A中  如：$("ul").append($newNode1); |
| appendTo(content)  | $(A).appendTo(B)表示把A追加到B中  如：$newNode1.appendTo("ul"); |
| prepend(content)   | $(A).  prepend (B)表示将B前置插入到A中  如：$("ul"). prepend ($newNode1); |
| prependTo(content) | $(A).  prependTo (B)表示将A前置插入到B中  如：$newNode1. prependTo ("ul"); |

#### 插入同辈节点

- 元素外部插入同辈节点

| 语法                    | 功能                                       |
| --------------------- | ---------------------------------------- |
| after(content)        | $(A).after  (B)表示将B插入到A之后  如：$("ul").after($newNode1); |
| insertAfter(content)  | $(A).  insertAfter (B)表示将A插入到B之后  如：$newNode1.insertAfter("ul"); |
| before(content)       | $(A).  before (B)表示将B插入至A之前  如：$("ul").before($newNode1); |
| insertBefore(content) | $(A).  insertBefore (B)表示将A插入到B之前  如：$newNode1.insertBefore("ul"); |

#### 替换节点

- replaceWith()和replaceAll()用于替换某个节点

  ```js
  $("ul li:eq(1)").replaceWith($newNode1);
  // 或
  $newNode1.replaceAll("ul li:eq(1)");
  // 两者的关系类似于append()和appendTo()
  ```

  ```html
  <h3>热门动画排行</h3>
  	<ul id="dy">
  		<li>名侦探柯南</li>
  		<li>死神</li>
  		<li>海贼王</li>
  </ul>
  ```

  ```js
  $("#dy li:eq(1)").replaceWith($("<li>sss</li>"));
  ```

  ![20171219205118](http://www.znsd.com/znsd/courses/uploads/681f06b5fe032f31e11c6f32e82223cc/20171219205118.png)

#### 复制节点

- clone()用于复制某个节点

  ```js
  $("ul li:eq(1)").clone(true).appendTo("ul");
  ```

- 可以使用clone()实现输出DOM元素本身的HTML

  ```js
  $("<div></div>").append($(DOM元素).clone()).html();
  ```

#### 删除节点

- jQuery提供了三种删除节点的方法

  1. remove()：删除整个节点

     ```js
     $("#test").remove(); // 删除一个input
     ```

  2. detach()：删除整个节点，保留元素的绑定事件、附加的数据

     ```html
     <p>Hello</p> how are <p>you?</p>
     ```

     ```js
     $("p").detach();
     ```

  3. empty()：清空节点内容`不支持input`

     ```js
     $("#emptySpan").empty(); // 清空一个span内容，不删除节点
     ```

### 学员操作

#### 制作会员信息模块

需求说明：单击“X”图标时，删除其所在行信息，单击“新增”时，增加一条表格中现有信息

![image](http://www.znsd.com/znsd/courses/uploads/79105f3767464020d19d150f602e1d2e/image.png)

完成时间：20分钟

### 遍历子元素

- children()方法可以用来获取元素的所有子元素

  ```js
  $("body").children(); // 获取<body>元素的子元素，但不包含子元素的子元素
  ```

  ![20171220154919](http://www.znsd.com/znsd/courses/uploads/2b334b58f30f94ed3515233f06c1af5a/20171220154919.png)

#### 遍历同辈元素

jQuery可以获取紧邻其后、紧邻其前和位于该元素前与后的所有同辈元素

| 语法               | 功能                                       |
| ---------------- | ---------------------------------------- |
| next([expr])     | 用于获取紧邻匹配元素之后的元素，  如：$("li:eq(1)").next().css("background-color","#F06"); |
| prev([expr])     | 用于获取紧邻匹配元素之前的元素，  如：$("li:eq(1)").prev().css("background-color","#F06"); |
| siblings([expr]) | 用于获取位于匹配元素前面和后面的所有同辈元素，  如：$("li:eq(1)").siblings().css("background-color","#F06"); |

```html
<ul id="dy">
		<li>名侦探柯南</li>
		<li>死神</li>
		<li>海贼王</li>
</ul>
```

```js
$("#dy li:eq(1)").next().css("background-color", "#F06");
$("#dy li:eq(1)").prev().css("background-color", "#F06");
$("#dy li:eq(1)").siblings().css("background-color", "#F06");
```

#### 遍历前辈元素

jQuery中可以遍历前辈元素，方法如下：

- parent()：获取元素的父级元素
- parents()：元素元素的祖先元素

`提示：jQuery中提供了each()、find()、filter()等节点操作方法，请自行查找jQuery api进行学习`

### CSS-DOM操作

除css()外，还有获取和设置元素高度、宽度、相对位置等的样式操作方法

| 语法              | 功能                              |
| --------------- | ------------------------------- |
| css()           | 设置或返回匹配元素的样式属性                  |
| height([value]) | 设置或返回匹配元素的高度                    |
| width([value])  | 设置或返回匹配元素的宽度                    |
| offset([value]) | 返回以像素为单位的top和left坐标。此方法仅对可见元素有效 |

```html
<img id="cssdom" src="images/1.jpg" alt="测试图片">
```

```js
$("#cssdom").height(100);
$("#cssdom").width(200);
$("#cssdom").offset({left:18,top:480.15625});
```

### 总结

- 样式操作：css()、addClass()、removeClass()、toggleClass()
- 内容操作：html()、 text()、 val()
- 节点操作：查找、创建、替换、复制和遍历
- 节点属性操作：attr() 、removeAttr()
- 遍历操作：遍历子元素、遍历同辈元素和遍历前辈元素