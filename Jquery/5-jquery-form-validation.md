# 第五章  jQuery表单验证

### 回顾及作业

- 列举至少4种常用的鼠标或键盘事件
- 当元素获得焦点时将触发什么事件？
- bind()方法有什么作用？

### 本章目标

- 会使用jQuery对表单内容进行验证`重点`
- 会使用表单选择器
- 会使用Validate验证插件`重点（难点）`

### 为什么要表单验证

- 减轻服务器的压力

- 保证输入的数据符合要求

  ![image](http://www.znsd.com/znsd/courses/uploads/1845ae17601557055f7e36f4a6bb01d1/image.png)

  ​

### 常用的表单验证

- 表单元素是否为空

- 用户名

- 密码和确认

- E-mail地址

- 身份证号码

- 日期格式

  ![image](http://www.znsd.com/znsd/courses/uploads/86e76a9570051f83e097d9d28da67a23/image.png)

### jQuery中的验证

- jQuery中实现表单验证和JavaScript中基本一致，只是获取页面元素的方法，修改元素属性有区别而已，思路完全一致。
- document.getElementById("id").valueu换成了$("#id").val()

### 为什么使用表单选择器

- 表单选择器用于选取某些特定的表单元素，比如所有单选按钮或隐藏的元素

  ![image](http://www.znsd.com/znsd/courses/uploads/0b2f477310062ef486319811b52cfb09/image.png)

### 表单选择器

| 语法        | 描述                                  | 示例                                       |
| --------- | ----------------------------------- | ---------------------------------------- |
| :input    | 匹配所有input、textarea、select和button 元素 | $("#myform :input")选取表单中所有的input、select和button元素 |
| :text     | 匹配所有单行文本框                           | $("#myform :text")选取email 和姓名两个input 元素  |
| :password | 匹配所有密码框                             | $("#myform :password" )选取所有  <input type="password" />元素 |
| :radio    | 匹配所有单项按钮                            | $("#myform :radio")选取<input  type="radio" />元素 |
| :checkbox | 匹配所有复选框                             | $(" #myform :checkbox " )选取  <input type="checkbox " />元素 |
| :submit   | 匹配所有提交按钮                            | $("#myform :submit " )选取  <input type="submit " />元素 |
| :image    | 匹配所有图像域                             | $("#myform :image" )选取  <input type=" image" />元素 |
| :reset    | 匹配所有重置按钮                            | $(" #myform :reset " )选取  <input type=" reset " />元素 |
| :button   | 匹配所有按钮                              | $("#myform :button" )选取button 元素         |
| :file     | 匹配所有文件域                             | $(" #myform :file" )选取  <input type=" file " />元素 |
| :hidden   | 匹配所有不可见元素，或者type 为hidden的元素         | $("#myform :hidden" )选取<input  type="hidden " />、style="display:  none"等元素 |

### 验证多行数据

批量提交数据的时候经常要验证多行数据

![20171221101859](http://www.znsd.com/znsd/courses/uploads/56305a123f44bacb36c7965d5bbc3dae/20171221101859.png)

### 练习

#### 实现学习经历动态维护表单和验证

需求说明：

1. 每项信息必须填写，“开始时间”和“结束时间”必须是“年”和“月”组成的6位数字，如“199906”、“200112”

2. 提供动态生成表单功能，即点击表单中的“添加一条”，则生成一行新的信息输入区。页面默认有一行信息输入区

   ![image](http://www.znsd.com/znsd/courses/uploads/8dfaed3cc17941684edacad7f9214267/image.png)

完成时间20分钟



### jQuery插件

- jQuery除了核心库以外还提供了非常丰富的插件，极大的提高了我们的开发效率。
- 常见的jQuery插件
  1. Validate数据验证插件
  2. JQueryUI 
  3. Easy UI
  4. Bootstrap 
  5. 报表插件

#### Validate插件

- 前面我们手动实现了表单的数据验证，虽然这个工作不是很复杂，但是很繁琐，每次针对不同的页面会编写大量的重复的代码。

- 在jQuery中给我们提供了一套功能非常强大的，可配置的一套验证插件Validate插件，可以极大的减少我们数据验证的工作量。

- 官方地址：<https://jqueryvalidation.org/>

  ![image](http://www.znsd.com/znsd/courses/uploads/31add723003dcc2495e4eba32e5a38a4/image.png)

#### jQuery Validate的优点

- 让客户端验证变得非常容易，并且提供了很多配置项目。
- 插件还附带了很多的验证方法，并实现了国际化，可以配置多语言的提示信息。

#### 如何使用jQuery Validate

- jQuery Validate也是基于Jquery开发的插件，所以在使用前必须导入Jquery的JS文件。

  ```js
  <script src="scripts/jquery.min.js"></script>
  ```

- 然后引入jQuery Validate的JS文件。

  ```js
  <script src="scripts/jquery.validate.min.js"></script>
  ```

- jQuery Validate默认为英文提示，另外还需要使用messages_zh.js设置中文提示消息。

  ```js
  <script src="scripts/messages_zh.js"></script>
  ```


#### Validate的使用方式

- HTML方式，将验证属性写在表单元素中

  ```html
  <form class="cmxform" id="studentForm" method="get" action="">
        <p>
            	<label for="cname">学号：</label>
            	<input id="cname" name="name" minlength="2" type="text" required>
        </p>
        <p>
            	<label for="cemail">姓名</label>
            	<input id="cemail"  name="email" required>
        </p>
        <p>
            	<label for="curl">邮箱</label>
            	<input id="curl" type="email" name="url">
        </p>
        <p>
            	<label for="ccomment">备注</label>
            	<textarea id="ccomment" name="comment" required></textarea>
        </p>
        <p>
          	<input class="submit" type="submit" value="提交">
        </p>
  </form>
  ```

  ```js
  <script type="text/javascript" src="../jquery-1.8.3.js"></script>
  <script type="text/javascript" src="jquery.validate.js"></script>
  <script type="text/javascript" src="messages_zh.js"></script>
  <script>
  $.validator.setDefaults({
      submitHandler: function() {
        alert("提交事件!");
      }
  });
  $(document).ready(function() {
      $("#studentForm").validate();
  });
  </script>
  ```

- JS方式，通过js完成表单验证

  ```html
  <form class="cmxform" id="signupForm" method="get" action="">
    <fieldset>
      <legend>验证完整的表单</legend>
      <p>
        <label for="firstname">名字</label>
        <input id="firstname" name="firstname" type="text">
      </p>
      <p>
        <label for="lastname">姓氏</label>
        <input id="lastname" name="lastname" type="text">
      </p>
      <p>
        <label for="username">用户名</label>
        <input id="username" name="username" type="text">
      </p>
      <p>
        <label for="password">密码</label>
        <input id="password" name="password" type="password">
      </p>
      <p>
        <label for="confirm_password">验证密码</label>
        <input id="confirm_password" name="confirm_password" type="password">
      </p>
      <p>
        <label for="email">Email</label>
        <input id="email" name="email" type="email">
      </p>
      <p>
        <label for="agree">请同意我们的声明</label>
        <input type="checkbox" class="checkbox" id="agree" name="agree">
      </p>
      <p>
        <label for="newsletter">我乐意接收新信息</label>
        <input type="checkbox" class="checkbox" id="newsletter" name="newsletter">
      </p>
      <fieldset id="newsletter_topics">
        <legend>主题 (至少选择两个) - 注意：如果没有勾选“我乐意接收新信息”以下选项会隐藏，但我们这里作为演示让它可见</legend>
        <label for="topic_marketflash">
          <input type="checkbox" id="topic_marketflash" value="marketflash" name="topic[]">Marketflash
        </label>
        <label for="topic_fuzz">
          <input type="checkbox" id="topic_fuzz" value="fuzz" name="topic[]">Latest fuzz
        </label>
        <label for="topic_digester">
          <input type="checkbox" id="topic_digester" value="digester" name="topic[]">Mailing list digester
        </label>
        <label for="topic" class="error" style="display:none">至少选择两个</label>
      </fieldset>
      <p>
        <input class="submit" type="submit" value="提交">
      </p>
    </fieldset>
  </form>
  ```

  ```js
  <script>
  $.validator.setDefaults({
  	submitHandler: function() {
  		alert("提交事件!");
  	}
  });
  $(document).ready(function() {
  	// 在键盘按下并释放及提交后验证提交表单
  	$("#signupForm").validate({
  		rules: {
  			firstname: "required",
  			lastname: "required",
  			username: {
  				required: true,
  				minlength: 2
  			},
  			password: {
  				required: true,
  				minlength: 5
  			},
  			confirm_password: {
  				required: true,
  				minlength: 5,
  				equalTo: "#password"
  			},
  			email: {
  				required: true,
  				email: true
  			},
  			"topic[]": {
  				required: "#newsletter:checked",
  				minlength: 2
  			},
  			agree: "required"
  		},
  		messages: {
  			firstname: "请输入您的名字",
  			lastname: "请输入您的姓氏",
  			username: {
  				required: "请输入用户名",
  				minlength: "用户名必需由两个字母组成"
  			},
  			password: {
  				required: "请输入密码",
  				minlength: "密码长度不能小于 5 个字母"
  			},
  			confirm_password: {
  				required: "请输入密码",
  				minlength: "密码长度不能小于 5 个字母",
  				equalTo: "两次密码输入不一致"
  			},
  			email: "请输入一个正确的邮箱",
  			agree: "请接受我们的声明",
  			topic: "请选择两个主题"
  		}
  	});
  });
  </script>
  ```

#### 默认校验规则

| 序号   | 规则                 | 描述                                       |
| ---- | ------------------ | ---------------------------------------- |
| 1    | required:true      | 必须输入的字段。                                 |
| 2    | remote:"check.php" | 使用 ajax 方法调用 check.php 验证输入值。            |
| 3    | email:true         | 必须输入正确格式的电子邮件。                           |
| 4    | url:true           | 必须输入正确格式的网址。                             |
| 5    | date:true          | 必须输入正确格式的日期。日期校验 ie6 出错，慎用。              |
| 6    | dateISO:true       | 必须输入正确格式的日期（ISO），例如：2009-06-23，1998/01/22。只验证格式，不验证有效性。 |
| 7    | number:true        | 必须输入合法的数字（负数，小数）。                        |
| 8    | digits:true        | 必须输入整数。                                  |
| 9    | creditcard:        | 必须输入合法的信用卡号。                             |
| 10   | equalTo:"#field"   | 输入值必须和 #field 相同。                        |
| 11   | accept:            | 输入拥有合法后缀名的字符串（上传文件的后缀）。                  |
| 12   | maxlength:5        | 输入长度最多是 5 的字符串（汉字算一个字符）。                 |
| 13   | minlength:10       | 输入长度最小是 10 的字符串（汉字算一个字符）。                |
| 14   | rangelength:[5,10] | 输入长度必须介于 5 和 10 之间的字符串（汉字算一个字符）。         |
| 15   | range:[5,10]       | 输入值必须介于 5 和 10 之间。                       |
| 16   | max:5              | 输入值不能大于 5。                               |
| 17   | min:10             | 输入值不能小于 10。                              |

#### 提示功能

- jQuery Validate提供了中文信息提示包，位于下载包的 dist/localization/messages_zh.js，只需将包引入到页面即可

- 当然也可以自己设置messages来设置提示

  ```js
  /*
   * Translated default messages for the jQuery validation plugin.
   * Locale: ZH (Chinese, 中文 (Zhōngwén), 汉语, 漢語)
   */
  $.extend( $.validator.messages, {
  	required: "这是必填字段",
  	remote: "请修正此字段",
  	email: "请输入有效的电子邮件地址",
  	url: "请输入有效的网址",
  	date: "请输入有效的日期",
  	dateISO: "请输入有效的日期 (YYYY-MM-DD)",
  	number: "请输入有效的数字",
  	digits: "只能输入数字",
  	creditcard: "请输入有效的信用卡号码",
  	equalTo: "你的输入不相同",
  	extension: "请输入有效的后缀",
  	maxlength: $.validator.format( "最多可以输入 {0} 个字符" ),
  	minlength: $.validator.format( "最少要输入 {0} 个字符" ),
  	rangelength: $.validator.format( "请输入长度在 {0} 到 {1} 之间的字符串" ),
  	range: $.validator.format( "请输入范围在 {0} 到 {1} 之间的数值" ),
  	max: $.validator.format( "请输入不大于 {0} 的数值" ),
  	min: $.validator.format( "请输入不小于 {0} 的数值" )
  } );
  return $;
  }));
  ```

#### jQuery Validate的应用

- 用户注册，登录

  ```html
  <form class="cmxform" id="signupForm" method="get" action="">
  	  <fieldset>
  	  	<legend>用户注册</legend>
  	  	<table>
  	  		<tr>
  	  			<td>
  	  				<label for="username">用户名：</label>
  	  			</td>
  	  			<td>
  	  				<input id="username" name="username" type="text">
  	  			</td>
  	  		</tr>
  	  		<tr>
  	  			<td>
  	  				<label for="password">密码</label>
  	  			</td>
  	  			<td>
  	  				<input id="password" name="password" type="password">
  	  			</td>
  	  		</tr>
  	  		<tr>
  	  			<td>
  	  				<label for="confirm_password">确认密码</label>
  	  			</td>
  	  			<td>
  	  				<input id="confirm_password" name="confirm_password" type="password">
  	  			</td>
  	  		</tr>
  	  		<tr>
  	  			<td>
  	  				<label for="email">Email</label>
  	  			</td>
  	  			<td>
  	  				<input id="email" name="email" type="email">
  	  			</td>
  	  		</tr>
  	  		<tr>
  	  			<td>
  	  				<input class="submit" type="submit" value="提交">
  	  			</td>
  	  		</tr>
  	  	</table>
  	  </fieldset>
  </form>
  ```

  ```js
  $(document).ready(function() {
  	// 在键盘按下并释放及提交后验证提交表单
  	$("#signupForm").validate({
  		rules: {
  			username: "requir用户名",
  			password: "required",
  			username: {
  				required: true,
  				minlength: 2
  			},
  			password: {
  				required: true,
  				minlength: 5
  			},
  			confirm_password: {
  				required: true,
  				minlength: 5,
  				equalTo: "#password"
  			},
  			email: {
  				required: true,
  				email: true
  			}			
  		},
  		messages: {			
  			username: {
  				required: "请输入用户名",
  				minlength: "用户名必需由两个字母组成"
  			},
  			password: {
  				required: "请输入密码",
  				minlength: "密码长度不能小于 5 个字母"
  			},
  			confirm_password: {
  				required: "请输入密码",
  				minlength: "密码长度不能小于 5 个字母",
  				equalTo: "两次密码输入不一致"
  			},
  			email: "请输入一个正确的邮箱",
  			agree: "请接受我们的声明",
  			topic: "请选择两个主题"
  		},
  		//验证通过后执行的方法
  		submitHandler: function() {
  			alert("提交事件!");
  			$("#signupForm").get(0).submit();
  		}
  	});
  });
  ```

  ![20171221112128](http://www.znsd.com/znsd/courses/uploads/2975f14322fdf1fad179adbbd90d99b6/20171221112128.png)

- 验证用户名和密码。

  ![image](http://www.znsd.com/znsd/courses/uploads/658905e07fe8f48df9725424af10cce1/image.png)

- JS提交

  ```js
  $(function(){
      $("#registerForm").validate({
          //验证通过后执行的方法
          submitHandler:function(form){
  			alert("提交事件!");
  			$("#registerForm").get(0).submit();
          }
      });
  })
  ```

  `注意：如果想提交表单, 需要使用 form.submit()，而不要使用 $(form).submit()。`

#### jQuery validation debug

- 如何将debug参数设置为true，那么验证插件将只验证，不提交。调试时十分方便。

  ```js
  $(function(){
      $("#registerForm").validate({
          debug:true
      });
  })
  ```

  ​

- 如果一个页面中有多个表单都想设置成为 debug，则使用：

  ```js
  $.validator.setDefaults({
     debug: true
  })
  ```

  ​

#### 更改错误信息的位置

默认情况是：error.appendTo(element.parent());即把错误信息放在验证的元素后面，并用span元素包裹起来

- 将message添加到label元素后

```js
errorPlacement: function(error, element) {
     // 将message添加到label元素后
     $(element).closest("form").find("label[for='" + element.attr( "id" ) + "']").append(error);  
},
errorElement: "span" // 以span形式包裹message
```

- 将message添加到td后面（如果是用table布局可以使用这种方式）

```js
errorPlacement : function(error, element) {
	error.appendTo(element.parent("td").next("td"));
}
```

#### 更改错误信息显示的样式

- 设置错误提示的样式，可以增加图标显示，在该系统中已经建立了一个validation.css，专门用于维护校验文件的样式

  ```css
  input.error { 
  	border: 1px solid red; 
  }
  label.error {
    	background:url("./images/unchecked.gif") no-repeat 0px 0px;
    	padding-left: 16px;
    	padding-bottom: 2px;
    	font-weight: bold;
    	color: #EA5200;
  }
  label.checked {
    	background:url("./images/checked.gif") no-repeat 0px 0px;
  }
  label.valid {
  	background: url('./images/checked.gif') no-repeat;
  	width: 16px;
  	height: 16px;
  }
  ```

  ```js
  $(function(){
      $("#registerForm").validate({
          success:“valid”,  //添加验证通过的样式        
      });
  })
  ```

#### 验证的触发方式修改

- 默认表单验证为多种验证方式，可以手动对属性进行修改

| 触发方式         | 类型      | 描述                                       | 默认值   |
| ------------ | ------- | ---------------------------------------- | ----- |
| onsubmit     | Boolean | 提交时验证。设置为 false 就用其他方法去验证。               | true  |
| onfocusout   | Boolean | 失去焦点时验证（不包括复选框/单选按钮）。                    | true  |
| onkeyup      | Boolean | 在 keyup 时验证。                             | true  |
| onclick      | Boolean | 在点击复选框和单选按钮时验证。                          | true  |
| focusInvalid | Boolean | 提交表单后，未通过验证的表单（第一个或提交之前获得焦点的未通过验证的表单）会获得焦点。 | true  |
| focusCleanup | Boolean | 如果是 true 那么当未通过验证的元素获得焦点时，移除错误提示。避免和 focusInvalid 一起用。 | false |

```js
$(function(){
    $("#registerForm").validate({
		onsubmit:false  //关闭提交验证        
    });
})
```

#### 异步验证

- 可以实现异步验证，比如验证用户名是否存在

  ```js
  remote: {
      url: "sssServlet", //后台处理程序
      type: "post",      //数据发送方式
      dataType: "json",  //接受数据格式   
      data: {            //要传递的数据
          username: function() {
              return $("#username").val();
          }
      }
  }
  ```

  `注意：服务器端只能返回true或者false，不能返回其他内容`

  例子：

  ```js
  rules: {
  	username: {
  		required: true,
  		minlength: 2,
  		remote:{
  			url: "student", //后台处理程序
  			type: "post",      //数据发送方式
  			dataType: "json",  //接受数据格式   
  			data: {            //要传递的数据
  			    username: function() {
  			        return $("#username").val();
  			    }
  			}
      	}
  	}
  }
  ```

#### 添加自定义校验（可选）

语法：

```js
addMethod：name, method, message
```

```js
// 中文字两个字节
jQuery.validator.addMethod("byteRangeLength", function(value, element, param) {
    var length = value.length;
    for(var i = 0; i < value.length; i++){
        if(value.charCodeAt(i) > 127){
            length++;
        }
    }
  return this.optional(element) || ( length >= param[0] && length <= param[1] );   
}, $.validator.format("请确保输入的值在{0}-{1}个字节之间(一个中文字算2个字节)"));

// 邮政编码验证   
jQuery.validator.addMethod("isZipCode", function(value, element) {   
    var tel = /^[0-9]{6}$/;
    return this.optional(element) || (tel.test(value));
}, "请正确填写您的邮政编码");
```

**注意**：要在 additional-methods.js 文件中添加或者在 jquery.validate.js 文件中添加。建议一般写在 additional-methods.js 文件中。

**注意**：在 messages_cn.js 文件中添加：isZipCode: "只能包括中文字、英文字母、数字和下划线"。调用前要添加对 additional-methods.js 文件的引用。

#### jQuery.validate 中文 API

| 名称                      | 返回类型      | 描述            |
| ----------------------- | --------- | ------------- |
| validate(options)       | Validator | 验证所选的 FORM。   |
| valid()                 | Boolean   | 检查是否验证通过。     |
| rules()                 | Options   | 返回元素的验证规则。    |
| rules("add",rules)      | Options   | 增加验证规则。       |
| rules("remove",rules)   | Options   | 删除验证规则。       |
| removeAttrs(attributes) | Options   | 删除特殊属性并且返回它们。 |

#### Validator对象

| 名称                             | 返回类型      | 描述                                       |
| ------------------------------ | --------- | ---------------------------------------- |
| form()                         | Boolean   | 验证 form 返回成功还是失败。                        |
| element(element)               | Boolean   | 验证单个元素是成功还是失败。                           |
| resetForm()                    | undefined | 把前面验证的 FORM 恢复到验证前原来的状态。                 |
| showErrors(errors)             | undefined | 显示特定的错误信息。                               |
| Validator 函数                   |           |                                          |
| setDefaults(defaults)          | undefined | 改变默认的设置。                                 |
| addMethod(name,method,message) | undefined | 添加一个新的验证方法。必须包括一个独一无二的名字，一个 JAVASCRIPT 的方法和一个默认的信息。 |
| addClassRules(name,rules)      | undefined | 增加组合验证类型，在一个类里面用多种验证方法时比较有用。             |
| addClassRules(rules)           | undefined | 增加组合验证类型，在一个类里面用多种验证方法时比较有用。这个是同时加多个验证方法。 |

### 总结

- 验证输入是否为空、验证数据格式是否正确、验证数据的范围、验证数据的长度
- 使用正则表达式可验证邮箱、电话号码、年龄
- 使用表单选择器和表单属性过滤器获取匹配的表单元素
- 使用Validate进行表单验证

### 作业

- jQuery验证和JS验证有什么区别？
- Validate基本验证规则有哪些？作用是什么？
- Validate对象的属性和方法包括哪些？
- 如何添加自定义效验规则