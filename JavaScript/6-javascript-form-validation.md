# 表单验证技术



### 本章目标

- 使用表单事件和脚本函数实现表单验证
- 使用String对象和文本框控件常用属性和方法实现客户端验证

### 什么时候需要表单验证

![image](http://www.znsd.com/znsd/courses/uploads/1845ae17601557055f7e36f4a6bb01d1/image.png)


- 减轻服务器的压力
- 保证输入的数据符合要求

![image](http://www.znsd.com/znsd/courses/uploads/9065c2423777e1bbac9eb155710d0d77/image.png)


### 表单验证的内容

- 日期是否有效或日期格式是否正确
- 表单元素是否为空
- 用户名和密码
- E-mail地址是否正确
- 身份证号码等是否是数字

![image](http://www.znsd.com/znsd/courses/uploads/62c682fa0c6d9d2b87b62334eba749bc/image.png)




### 表单验证思路

- 当输入的表单数据不符合要求时，如何编写脚本来进行提示？
- 获得表单元素值
- 使用JavaScript的一些方法对数据进行判断
- 当表单提示时，触发 onsubmit事件，对获取的数据进行验证

### String 对象

- length属性 获取字符串长度

```javascript
var str = "this is javascript";
str.length;
```

- toLowerCase() 把字符串转化为小写
- toUpperCase() 把字符串转化为大写
- charAt(index) 返回在指定位置的字符
- indexOf(字符串，index) 查找某个指定的字符串值在字符串中首次出现的位置
- substring(index1,index2) 返回位于指定索引index1和index2之间的字符串，并且包括索引index1对应的字符，不包括索引index2对应的字符

```js
var str = "this is javascript";

console.info(str.toLowerCase());
console.info(str.toUpperCase());
console.info(str.charAt(2));
console.info(str.indexOf("i"));
console.info(str.substring(2,4));
```



### E-mail邮箱格式验证

#### 思路分析

- 使用getElementById()获取Email的值
- 使用字符串方法indexOf( ) 判断Email的值是否包含“@”和“.”符号。
- 根据函数返回值是true还是flase来决定是否提交表单

```html
<form onsubmit="return validation();">
  邮箱地址<input id="email" type="text">
  <input type="submit" value="提交">
</form>
```

```js
function validation() {
  var email = document.getElementById("email");
  if (email.value.indexOf("@") == -1) {
    alert("请输入正确的邮箱地址");
    return false;
  } else {
    return true;
  }
}
```

### 文本框内容验证

- 姓名不能为空，并且姓名中不能有数字
- 密码不能为空，并且密码包含的字符不能少于6个
- 两次输入的密码必须一致
- 密码长度必须为6位

姓名中不能有数字

```js
var name = document.getElementById("name").value;
for(var i=0;i<name.length;i++){
	var j=name.substring(i,i+1)
  	if(j>=0){
    	alert("姓名中不能包含数字");
	    return false;
  	}
}
```

密码不能少于6位

```js
var pwd=document.getElementById("pwd").value;
if(pwd.length<6){
  alert("密码必须等于或大于6个字符");
  return false;	
}
```

验证两次密码是否一致

```js
var repwd=document.getElementById("repwd").value;
if(pwd!=repwd){
   alert("两次输入的密码不一致");
   return false;   
}
```



### 小结

实现表单注册功能验证，需要验证以下内容

- 用户名是否为空，不能少于4个字符，不能大于16个字符
- 密码是否为空，不能少于6位，两次密码是否相等
- 邮箱是否为空，格式是否正确是否包含`@`和`.`符号
- 备注内容是否为空



### 文本框效果

- 如何实现以下图片效果，用户点击邮箱文本框，文本框内容提示信息自动消失

![image](http://www.znsd.com/znsd/courses/uploads/fff2638bc87931a754a213ded23ae75d/image.png)

思路：使用文本框对象的相关属性、事件和方法实现此效果

#### 文本框对象的方法和事件

|  类别  | 名称         | 描述                 |
| :--: | :--------- | :----------------- |
|  事件  | onblur     | 失去焦点，当光标离开某个文本框时触发 |
|  事件  | onfocus    | 获得焦点，当光标进入某个文本框时触发 |
|  事件  | onkeypress | 某个键盘按键被按下并松开       |
|  方法  | blur()     | 从文本域中移开焦点          |
|  方法  | focus()    | 在文本域中设置焦点，即获得鼠标光标  |
|  方法  | select()   | 选取文本域中的内容          |
|  属性  | id         | 设置或返回文本域的id        |
|  属性  | value      | 设置或返回文本域的value属性的值 |

#### 制作文本框中初始的内容

```html
<form onsubmit="return validation();">
  <table>
    <tr>
      <td>邮箱地址</td>
      <td><input id="email" type="text" value="请输入正确的电子邮箱" onfocus="clearText()"></td>
    </tr>
    <tr>
      <td>密码</td>
      <td><input id="name" type="text"></td>
    </tr>
    <tr>
      <td></td>
      <td><input type="submit" value="提交"></td>
    </tr>
  </table>
</form>
```

```js
function clearText() {
	var mail=document.getElementById("email");
  	if(mail.value=="请输入正确的电子邮箱"){
    	mail.value="";
    	mail.style.borderColor="#ff0000";
  	}
}
```

### 制作文本框效果-2

当用户输入无效的电子邮件地址，Email文本框中的内容将被自动选中并且高亮显示，提示用户重新输入

```html
<input id="email" type="text" class="inputs"  onblur="checkEmail()"/>
<div class="red" id="DivEmail"></div>

```



```js
function checkEmail(){
    var mail= document.getElementById ("email");
    var divID= document.getElementById ("DivEmail");
    divID.innerHTML="";
    if(mail.value==""){
         divID.innerHTML="Email不能为空";
         return false;
    }
}
```

### 布置作业

- 为什么需要表单验证？
- 常用的表单验证主要包括哪些内容？
- 简述表单验证的大致思路？
- 如何验证电子邮件格式是否正确？（代码实现）
- 简要说明文本框对象的常用属性、方法和事件？