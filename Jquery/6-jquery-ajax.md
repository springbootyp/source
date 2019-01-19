# 第六章  jQuery中的Ajax

### 回顾

- 使用jQuery Validate实现表单验证

### 本章目标

- 掌握JQuery中Ajax的使用`重点`
- 使用ajax发送Ajax请求`重点`
- 使用ajax解析json格式

### 为什么使用jQuery中的Ajax

- 使用原生的JS实现Ajax

```js
var xmlHttp = new XMLHttpRequest();
xmlHttp.onreadystatechange=function(){
  	if (xmlHttp.readyState==4){
    	document.getElementById("content").innerHTML = xmlHttp.responseText;
  	}
}
xmlHttp.open("POST", "student", true);
xmlHttp.send();
```

- 使用jQuery实现Ajax

```js
$.ajax({
   	type: "POST",
   	url: "student",
   	data: "name=John&location=Boston",
   	success: function(msg){
     	alert( "Data Saved: " + msg );
   	}
});
```

- 通过上面两段代码的对比，可以发现JQuery实现Ajax比原生JS实现Ajax简单太多了。从而大大的提高了我们的开发效率。

### JQuery中的Ajax

- JQuery框架对Ajax提供了非常友好的支持，实现Ajax我们不再需要编写那么多冗余的代码了。
- JQuery为我们提供了几个Ajax的实现方法。

| 方法            | 语法                                       | 描述                                       |
| ------------- | ---------------------------------------- | ---------------------------------------- |
| `$.ajax()`    | $.ajax( options )                        | 执行异步 AJAX 请求                             |
| $.get()       | $.get ( url, [data], [callback], [type] ) | 使用 AJAX 的 HTTP GET 请求从服务器加载数据            |
| $.getScript() | $.getScript( url, [callback] )           | 使用 AJAX 的 HTTP GET 请求从服务器加载并执行 JavaScript |
| $. getJSON()  | $.getJSON( url,  [data], [callback] )    | 专用于返回json格式的请求                           |
| $.post()      | $.post( url, [data], [callback], [type] ) | 使用 AJAX 的 HTTP POST 请求从服务器加载数据           |
| load()        | load( url, [data], [callback] )          | 从服务器加载数据，并把返回的数据放置到指定的元素中                |

#### load方法

- 语法

  ```js
  $("#result").load("data.txt"); //返回data.txt中输出的数据
  ```

  load是最简单的jquery-ajax函数，用户直接返回HTML的数据给jquery对象，load也是唯一一个不通过$.调用的函数。

#### $.get()

$.get()：通过get方式调用Ajax请求。

语法：

```js
function checkUserName(value){
    if(value != ""){
        var url = "checkusername";       //请求url
        var data = {name:value};         //参数
        $.get(url,data,function(result){
        	$("#username + span").remove();
          	if(result == "false"){
            	$("#username").after($("<span class='red'>用户名已经存在</span>"));
          	} else{
            	$("#username").after($("<span class='blue'>用户名可以使用</span>"));
          	}
         ,"text");   //返回数据类型
    }
}
```

`注意：回调函数还有一个参数，用来返回ajax的请求状status，"timeout","error","notmodified","success","parsererror"`

#### $.post()

$.post()通过post方式调用Ajax请求。与get方式基本一致

语法：

```js
function checkUserName(value){
    if(value != ""){
        var url = "checkusername";       //请求url
        var data = {name:value};            //参数
        $.post(url,data,function(result){
            $("#username + span").remove();
                if(result == "false"){
	  				$("#username").after($("<span class='red'>用户名已经存在</span>"));
            	}else{
                    $("#username").after($("<span class='blue'>用户名可以使用</span>"));
         		}
         ,"text");   //返回数据类型
    }
}
```

`注意：回调函数还有一个参数，用来返回ajax的请求状status，"timeout","error","notmodified","success","parsererror"`

#### $.serialize()

$.serialize()可以序列化表单值创建 URL 编码文本字符串。

语法：

```js
$(selector).serialize();
```

例子：

```html
<form action="">
	第一个名称: <input type="text" name="FirstName" value="Mickey" /><br>
	最后一个名称: <input type="text" name="LastName" value="Mouse" /><br>
</form>
<button>序列化表单值</button>
<div id="result"></div>
```

```js
$(document).ready(function(){
    $("button").click(function(){
        $("#result").text($("form").serialize());
    });
});
```

#### $.serializeArray()

$.serializeArray()可以通过序列化表单值来创建对象（name和value）的数组。

语法：

```js
$(selector).serializeArray();
```

```js
//使用上面的html
$(document).ready(function(){
    $("button").click(function(){
         var x=$("form").serializeArray();
         $.each(x, function(i, field){
            $("#results").append(field.name + ":" + field.value + " ");
        });
    });
});
```

#### $.ajax

- $.ajax()作为jquery中ajax和核心函数，可以轻松通过参数配置实现实现前面的所有功能。

- $.ajax() 只有一个参数：参数 key/value 对象，包含各配置及回调函数信息。

  ```js
  $.ajax(options) ; 
  ```

  ```js
  // ajax可以对过程进行完整的控制
  $.ajax({
      type: "get",
      url: "http://www.cnblogs.com/rss",
      beforeSend: function(XMLHttpRequest){ 
        	console.info("发送请求前执行");
      },
      success: function(data, textStatus){ 
        	console.info("请求发送后台响应成功执行");
      },
      complete: function(XMLHttpRequest, textStatus){ 
        	console.info("请求发送完成执行");
      },
      error: function(){ 
        	console.info("请求发送出现错误执行");
      }
  });
  ```

#### options

| 选项名         | 选项值类型         | 描述                         |
| ----------- | ------------- | -------------------------- |
| url         | String        | 发送请求的地址(默认: 当前页地址)         |
| type        | String        | 请求方式(默认: "GET")            |
| timeout     | Number        | 设置请求超时时间（毫秒）               |
| async       | Boolean       | 设置是否为异步请求(默认: true)        |
| beforeSend  | Function      | 发送请求前调用                    |
| complete    | Function      | 请求完成后回调函数                  |
| contentType | String        | 发送信息至服务器时内容编码类型            |
| data        | Object,String | 发送到服务器的数据                  |
| dataType    | String        | 预期服务器返回的数据类型               |
| error       | Function      | 请求失败时将调用                   |
| global      | Boolean       | 是否触发全局 Ajax 事件。 (默认: true) |
| success     | Function      | 请求成功后调用                    |

#### ajax改写get和post

ajax的功能非常强大，可以很方便的实现前面的功能，让我们来用ajax改写前面的get和post请求。

```js
function checkUserName(value){
    if(value != ""){
        var url = "checkusername";
        var data = {name:value};
        $.ajax({
            url:url,
            type:“GET”,   //"POST"
            data:data,
            success:function(result){
                $("#username + span").remove();
                if(result == "false"){
                	$("#username").after($("<span class='red'>用户名已经存在</span>"));
                } else{
                    $("#username").after($("<span class='blue'>用户名可以使用</span>"));
                }
        }});
    }
}
```

#### $.ajax实现AutoComplete

![autocomplate](http://www.znsd.com/znsd/courses/uploads/62b79c04b4e70fdbdd229fd137c78806/autocomplate.gif)

通过jquery.ajax实现自动完成

```js
function getlist(value){
    if(value != ""){
        var url = "getlist";
        var data = {key:value};
        $.ajax({
            url:url,
            type:"GET", 
            data:data,
            datatype:"json",
            success:function(result){
				//处理结果
            }
        });
    }
}
```

#### $.ajaxSetup

ajaxSetup() 方法为将来的AJAX 请求设置默认值。ajaxSetup()方法可以为所有 AJAX 请求设置默认 URL 和 success 函数

语法：

```js
$.ajaxSetup({name:value, name:value, ... });
```

例子：

```js
// 设置统一的错误处理
$(document).ready(function(){
    $("button").click(function(){
        $.ajaxSetup({url:"wrongfile.txt",error:function(xhr){
             alert("错误信息: " + xhr.status + " " + xhr.statusText);
        }});
        $.ajax();
    });
});
```

### 总结

- jQuery实现Ajax的优势
- jQuery提供的ajax方式
- $.ajax方式实现Ajax
- 全局处理方法。

### 作业

- jQuery中的ajax的优势是什么？
- $.ajax包含哪些属性，作用是什么？
- $.ajaxSetup作用是什么？