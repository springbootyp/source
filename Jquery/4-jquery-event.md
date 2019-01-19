# 第四章jQuery中的事件与动画

### 回顾及作业

- val()方法和attr()方法分别有什么作用？
- html()方法和text()方法有什么区别？
- 获取子元素和获取父元素分别用什么方法？

### 本章目标

- 使用常用简单事件制作网页特效`重点`
- 使用鼠标事件制作主导航特效`重点`
- 使用键盘事件制作表单特效`重点`
- 使用hover()制作下拉菜单特效
- 使用鼠标事件及动画制作弹出对话框

### 网页中的事件

- 在网页中的事件也是实现和用户交互的基础

- 例如tab页切换效果，可以通过鼠标点击事件来实现

  ![20171220163347](http://www.znsd.com/znsd/courses/uploads/12cf2f7bd69b7034706c2e7726bc539e/20171220163347.png)

![20171220163446](http://www.znsd.com/znsd/courses/uploads/97c6ebef9510c5556f89730af8671925/20171220163446.png)

### jQuery中的事件

jQuery事件是对JavaScript事件的封装，常用事件分类如下：

- 基础事件
  1. window事件
  2. 鼠标事件
  3. 键盘事件
  4. 表单事件
- 复合事件是多个事件的组合
  1. 鼠标光标悬停
  2. 鼠标连续点击

window事件，就是当用户执行某些会影响浏览器的操作时，而触发的事件。例如打开网页时加载页面、关闭窗口、调节窗口大小、移动窗口等操作引发的事件处理。在jQuery中，常用的window事件有文档就绪事件，它对应的方法是ready()，在前面章节中，已经详细介绍过其用法，本章不再赘述。

#### 鼠标事件

鼠标事件是当用户在文档上移动或单击鼠标时而产生的事件，常用鼠标事件有

| 方法           | 描述                          | 执行时机  |
| ------------ | --------------------------- | ----- |
| click( )     | 触发或将函数绑定到指定元素的click事件       | 单击鼠标时 |
| mouseover( ) | 触发或将函数绑定到指定元素的mouse  over事件 | 鼠标移过时 |
| mouseout( )  | 触发或将函数绑定到指定元素的mouse  out事件  | 鼠标移出时 |

#### 实现主导航特效

- 以mouseover()为例，实现鼠标移过时特效

  ```js
  $("#menu li").mouseover(function() { // 当鼠标移过元素时，为事件添加响应方法
  	$(this).addClass("heightlight"); // 鼠标所在的元素添加样式
  });
  ```

  ![20171220165149](http://www.znsd.com/znsd/courses/uploads/3150f00baae6c3d33203b0a15c12e97a/20171220165149.png)

#### 键盘事件

用户每次按下或者释放键盘上的键时都会产生事件，常用键盘事件有：

| 方法          | 描述                       | 执行时机      |
| ----------- | ------------------------ | --------- |
| keydown( )  | 触发或将函数绑定到指定元素的keydown事件  | 按下键盘时     |
| keyup( )    | 触发或将函数绑定到指定元素的keyup事件    | 释放按键时     |
| keypress( ) | 触发或将函数绑定到指定元素的keypress事件 | 产生可打印的字符时 |

- 以keydown ()为例，实现按键时特效

  ```js
   $(document).keydown(function (event) { // 当键盘被按下时，事件对象event中封装了事件的参数
      if (event.keyCode == "13") { // 如果是回车键
          alert("确认要提交么？");
      }
  });
  ```

#### 表单事件

当元素获得焦点时，会触发focus事件，失去焦点时，会触发blur事件，详见下表：

| 方法       | 描述                    | 执行时机 |
| -------- | --------------------- | ---- |
| focus( ) | 触发或将函数绑定到指定元素的focus事件 | 获得焦点 |
| blur( )  | 触发或将函数绑定到指定元素的blur事件  | 失去焦点 |

- 以focus()为例，实现获得焦点时特效

  ```js
  $("[name=member]").focus(function(){ // 当元素获得焦点时
      $(this).addClass("input_focus"); // 通过添加样式改变文本框背景色
  });
  ```

  ![20171220165952](http://www.znsd.com/znsd/courses/uploads/95a7a7fc5fb82102c87c4c1f5c8de65a/20171220165952.png)

### 学员操作

#### 制作左导航特效

  需求说明：初始状态下，只显示“购物特权”主菜单，点击“购物特权”后显示其下的列表内容，鼠标移动到子菜单上时，子菜单添加背景色

  ![20171220170206](http://www.znsd.com/znsd/courses/uploads/76eb1d705ec82876730c3f423e32999b/20171220170206.png)

  完成时间：25分钟

#### 制作登录框特效

  需求说明：文本框获得焦点时，文本框边框的显示效果（颜色）改变

  ![image](http://www.znsd.com/znsd/courses/uploads/c9aca67f3540bb6f10903204fb57239f/image.png)

  完成时间：15分钟

### 绑定事件

除了使用事件名绑定事件外，还可以使用bind()方法

```js
$("input[name=event_1]").bind("click",function() { // click为事件类型,function为处理函数
    $("p").css("background-color","#F30");
});
```

### 绑定多个事件

bind()方法还可以同时为多个事件绑定方法

```js
$("input[name=event_1]").bind({
    mouseover: function () {
        $("ul").css("display", "none");
    },
    mouseout: function () {
        $("ul").css("display", "block");
    }
});
```

![event](http://www.znsd.com/znsd/courses/uploads/8ec30f3db87bf2f836ae9ac5c005d9f6/event.gif)

### 移除事件

移除事件使用unbind()方法，其语法如下：

```js
unbind([type],[fn]);
```

| 参数     | 含义   | 描述                                       |
| ------ | ---- | ---------------------------------------- |
| [type] | 事件类型 | 主要包括：blur、focus、click、mouseout等基础事件，此外，还可以是自定义事件 |
| [fn]   | 处理函数 | 用来绑定的处理函数                                |

`当unbind()不带参数时，表示移除所绑定的全部事件`

```js
$("input[name=event_1]").unbind("mouseout"); // 移除鼠标移出事件
```

### 鼠标光标悬停事件

hover()方法相当于mouseover与mouseout事件的组合

```js
$("input[name=event_1]").hover(function(){ // 光标移入时触发
  		$("ul").css("display","none");
	},
	function(){
  		$("ul").css("display","block"); // 光标移出时触发
	}
);
```

### 鼠标连续click事件

toggle()方法用于模拟鼠标连续click事件

```js
$("body").toggle(
	function () { // 第一次点击触发
      	alert(1);
    },
	function () {  // 第二次点击触发
      	alert(2);
    },
	function () {  // 第三次点击触发
    	alert(3);
    }
);

```

![toggle](http://www.znsd.com/znsd/courses/uploads/cabf0304ec5aa7c94e1df988822b4c22/toggle.gif)

### 学员操作

#### 制作团购网主导航

需求说明：鼠标移过导航项时，鼠标所处导航项改变背景图像

![menu](http://www.znsd.com/znsd/courses/uploads/160ccc8591a94dced102530e2a647553/menu.gif)

完成时间：20分钟



### 学员操作jQuery动画效果

jQuery提供了很多动画效果，如：

- 控制元素显示与隐藏
- 控制元素淡入淡出
- 改变元素高度

#### 显示及隐藏元素

- show() 在显示元素时，能定义显示元素时的效果，如显示速度

  ```js
  $(".tipsbox").show("slow"); // 以较慢的速度显示元素
  ```

  `提示：显示速度可以取如下值：毫秒（如1000）、slow、normal、fast`

  ```html
  <div id="tips" style="display:none;">
  		提示信息
  </div>
  ```

  ```js
  $("#tips").show("slow");
  ```

#### 切换元素可见状态

- toggle()除了可以模拟鼠标的连续单击事件外，还能用于切换元素的可见状态

  ```js
  $("li:gt(5):not(:last)").toggle();
  ```

  ![toggle-menu](http://www.znsd.com/znsd/courses/uploads/864189b72bcb60bd980d478f8639b9e9/toggle-menu.gif)

  ```html
  <div>
      <ul id="nav">
          <li>手机通讯、数码电器</li>
          <li>食品饮料、酒水、蔬菜</li>
          <li>进口食品、进口纽埃</li>
          <li>美容化妆、个人护理</li>
          <li>母婴用品、个人护理</li>
          <li>厨卫清洁、纸、清洁剂</li>

          <li>家具家私、锅具餐具</li>
          <li>生活电器，汽车生活</li>
          <li>电脑、外设、办公用品</li>
      </ul>
  <div>
  <input id="menuBtn" type="button" value="伸缩菜单">
  ```

  ```js
  $("#menuBtn").click(function() {
  	$("#nav li:gt(5):not(:last)").toggle();
  });
  ```

#### 淡入淡出效果

- fadeIn()和fadeOut()可以通过改变元素的透明度实现淡入淡出效果

  ```js
  $("input[name=fadein_btn]").click(function(){
        $("img").fadeIn("slow"); // 以较慢的速度淡入
  });
  $("input[name=fadeout_btn]").click(function(){
        $("img").fadeOut(1000); // 以1000毫秒的速度淡出
  });

  ```

  例子：

  ```html
  <img src="images/1.jpg" style="width:200px;height:200px;display:none">
  <button name="fadein_btn" id="imgText">淡入淡出效果</button>
  <button name="fadeout_btn" id="imgText">淡入淡出效果毫秒为单位</button>
  ```

  ```js
  $("button[name=fadein_btn]").click(function(){
    	$("img").fadeIn("slow");
  });
  $("button[name=fadeout_btn]").click(function(){
   	$("img").fadeOut(1000);
  });
  ```

  ![fadein](http://www.znsd.com/znsd/courses/uploads/b31bf1b0b991d9876a2dd8ab9bf53e27/fadein.gif)

#### 改变元素的高度

- slideDown() 可以使元素逐步延伸显示，slideUp()则使元素逐步缩短直至隐藏

  ```js
  $("h2").click(function(){
  	$(".txt").slideUp("slow");
      $(".txt").slideDown("slow");
  });
  ```

  例子：

  ```html
  <h2>slideDown</h2>
  <p class="txt">txt</p>
  <p class="txt">txt</p>
  ```

![slideDown](http://www.znsd.com/znsd/courses/uploads/32b8e260dcd1e0fc5673667f33d886d1/slideDown.gif)

### 学员操作

#### 制作折叠列表页

需求说明：

![cllapse](http://www.znsd.com/znsd/courses/uploads/4ffd83e42a89955fe6bb0fbbcd542867/cllapse.gif)

#### 制作当当网我的订单页

需求说明:鼠标鼠标移过“我的当当”时，出现下拉菜单，鼠标移出时，下拉菜单隐藏

![zuoye2](http://www.znsd.com/znsd/courses/uploads/a9854132227cbdf73366ffe1ec980dc5/zuoye2.gif)

### 总结

- 鼠标事件
  1. click
  2. mouseover
  3. mouseout
- 键盘事件
  1. keydown、
  2. keyup、
  3. keypress
- 表单事件
  1. focus
  2. blur
- 复合事件
  1. hover
  2. toggle
- 动画
  1. show()
  2. hide()
  3. toggle()
  4. fadeIn()
  5. fadeOut()
  6. slideUp()
  7. slideDown()

### 作业

- jQuery中的事件包括哪些？在什么情况下触发？
- jQuery所支持的哪几种动画？