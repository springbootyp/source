# 正则表达式

### 本章任务

- 制作严谨的电子邮箱验证页面
- 制作省市级联效果

![image](http://www.znsd.com/znsd/courses/uploads/f1bad67f1f8816a7b6c74736b3ef2103/image.png)

![image](http://www.znsd.com/znsd/courses/uploads/3375f51e50e96887a6968b4013ccd543/image.png)



### 本章目标

- 使用innerHTML动态改变DIV的内容
- 使用正则表达式验证页面输入的内容
- 使用数组实现级联的下拉列表框效果

### 正则表达式

#### 为什么要用正则表达式

- 简洁的代码
- 严谨的验证文本框中的内容

#### 什么是正则表达式

RegExp 是正则表达式的缩写。当您检索某个文本时，可以使用一种模式来描述要检索的内容。RegExp 就是这种模式。

- 普通模式
- 构造函数模式

简单（普通）模式可以是一个单独的字符。更复杂的模式包括了更多的字符，并可用于解析、格式检查、替换等等。您可以规定字符串中的检索位置，以及要检索的字符类型，等等。

#### 定义正则表达式

- 普通模式

```js
// var reg=/white/;
var reg=/表达式/附加参数;
```

- 构造函数 

```js
// var reg=new RegExp("表达式","附加参数")
var reg=new RegExp("white"); // 当您使用该 RegExp 对象在一个字符串中检索时，将寻找的是字符 "white"
```

- 简单模式

```js
var reg=/china/;
var reg=/abc8/;
```

- 复合模式

```js
var reg=/^\w+$/;
var reg=/^\w+@\w+.[a-zA-Z]{2,3}(.[a-zA-Z]{2,3})?$/;
```



#### RegExp 方法

- test() 

test() 方法检索字符串中的指定值。返回值是 true 或 false

**例子**

```js
var reg = new RegExp("e");
document.write(reg.test("The is javascript"));
```

- exec() 

exec() 方法检索字符串中的指定值。返回值是被找到的值。如果没有发现匹配，则返回 null。

**例子**

```js
var reg = new RegExp("e");
document.write(reg.exec("The is javascript"));
```

- compile()

compile() 方法用于改变 RegExp，既可以改变检索模式，也可以添加或删除第二个参数。

**例子**

```js
var reg=new RegExp("e");
document.write(reg.test("The is javascript"));

reg.compile("d");
document.write(reg.test("The is javascript"));
```



#### 正则表达式修饰符

| 修饰符                                      | 描述                           |
| ---------------------------------------- | ---------------------------- |
| [i](http://www.w3school.com.cn/jsref/jsref_regexp_i.asp) | 执行对大小写不敏感的匹配。                |
| [g](http://www.w3school.com.cn/jsref/jsref_regexp_g.asp) | 执行全局匹配（查找所有匹配而非在找到第一个匹配后停止）。 |
| m                                        | 执行多行匹配。                      |

**g使用例子**

```js
var str = "hello 123456";
var pattern=/\d/g;
document.write(str.match(pattern));
```



#### 正则表达式方括号

| 表达式                                      | 描述                   |
| ---------------------------------------- | -------------------- |
| [[abc\]](http://www.w3school.com.cn/jsref/jsref_regexp_charset.asp) | 查找方括号之间的任何字符。        |
| [[^abc\]](http://www.w3school.com.cn/jsref/jsref_regexp_charset_not.asp) | 查找任何不在方括号之间的字符。      |
| [0-9]                                    | 查找任何从 0 至 9 的数字。     |
| [a-z]                                    | 查找任何从小写 a 到小写 z 的字符。 |
| [A-Z]                                    | 查找任何从大写 A 到大写 Z 的字符。 |
| [A-z]                                    | 查找任何从大写 A 到小写 z 的字符。 |
| [adgk]                                   | 查找给定集合内的任何字符。        |
| [^adgk]                                  | 查找给定集合外的任何字符。        |
| (red\|blue\|green)                       | 查找任何指定的选项。           |

**[]使用例子**

```js
var str = "hello 123456 abc";
var pattern = new RegExp(/[abc]/g);
document.write(str.match(pattern));
```



#### 正则表达式符号

| 符号   | 描述                              |
| ---- | ------------------------------- |
| /…/  | 代表一个模式的开始和结束                    |
| ^    | 匹配字符串的开始                        |
| $    | 匹配字符串的结束                        |
| \s   | 任何空白字符                          |
| \S   | 任何非空白字符                         |
| \d   | 匹配一个数字字符，等价于[0-9]               |
| \D   | 除了数字之外的任何字符，等价于[^0-9]           |
| \w   | 匹配一个数字、下划线或字母字符，等价于[A-Za-z0-9_] |
| \W   | 任何非单字字符，等价于[^a-zA-z0-9_]        |
| .    | 除了换行符之外的任意字符                    |

```js
// 通过\s表达式匹配空白字符
var str = "hello123456 abc";
var pattern = new RegExp(/\s/g);
document.write(pattern.test(str));

// 匹配非空白字符
var str = "hello123456 abc";
var pattern = new RegExp(/\S/g);
document.write(str.match(pattern));
```



#### 正则表达式符号2

| 符号    | 描述                              |
| ----- | ------------------------------- |
| {n}   | 匹配前一项n次                         |
| {n,}  | 匹配前一项n次，或者多次                    |
| {n,m} | 匹配前一项至少n次，但是不能超过m次              |
| *     | 匹配前一项0次或多次，等价于{0,}              |
| +     | 匹配前一项1次或多次，等价于{1,}              |
| ？     | 匹配前一项0次或1次，也就是说前一项是可选的，等价于{0,1} |
| \|    | 或者，多个规则选择一个                     |

**邮箱正则例子**

```js
var email = "111111111@qq.com";
var reg = new RegExp(/^\w+@\w+.[a-zA-Z]{2,3}(.[a-zA-Z]{2,3})?$/);
console.info(reg.test(email));
```

#### 常用正则表达式

- 电话号码 \d{3}-\d{8}|\d{4}-\{7,8}
- 身份证号码 ^(\d{6})(\d{4})(\d{2})(\d{2})(\d{3})([0-9]|X)$
- 邮箱地址 /^\w+@\w+.[a-zA-Z]{2,3}(.[a-zA-Z]{2,3})?$/
- 手机号码 0?(13|14|15|18|17)[0-9]{9}
- IP (25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)
- 邮编号码 \d{6}
- 中文字符 [\u4e00-\u9fa5]

#### String对象可以使用正则表达式的方法

| 方法      | 描述              |
| ------- | --------------- |
| match   | 找到一个或多个正则表达式的匹配 |
| search  | 检索与正则表达式相匹配的值   |
| replace | 替换与正则表达式匹配的字符串  |
| split   | 把字符串分割为字符串数组    |

#### 验证邮政编码例子

```js
document.write("425000".match(/^\d{6}$/));
```

#### 验证手机号码例子

```js
var reg = new RegExp(/0?(13|14|15|18|17)[0-9]{9}/);
document.write(reg.test("13800138000"));
```



#### 正则表达式应用场景

- 用户名
- 密码
- 电子邮箱
- 手机号码
- 身份证号码
- 生日
- 邮政编码
- 固定电话

#### 作业

自己动手写个验证身份证号码的正则表达式









### 使用下拉框实现级联效果

####如何使用下拉框来实现现级效果

![image](http://www.znsd.com/znsd/courses/uploads/65c89de3d7666b4c5ef464478a7add2a/image.png)

#### 问题分析

下拉框需要用到html中的两个标签，一个是`select`，一个是`option`，当用户选择省份下拉框是通过onchange事件来改变城市信息。

- select对象
- option对象

#### select对象常用事件方法和属性

| 类别   | 名称            | 描述                  |
| ---- | ------------- | ------------------- |
| 事件   | onchange      | 当改变选项时调用的事件         |
| 方法   | add()         | 向下拉列表中添加一个选项        |
| 属性   | options[]     | 返回包含下拉列表中的所有选项的一个数组 |
| 属性   | selectedIndex | 设置或返回下拉列表中被选项目的索引号  |
| 属性   | length        | 返回下拉列表中的选项的数目       |

#### select对象属性例子

```html
<select onchange="get(this);">
  	<option>1701班</option>
  	<option>1702班</option>
  	<option>1703班</option>
</select>
```

```js
function get(select) {
  	console.info("选择了第" + select.selectedIndex + "条");
  	console.info("总共" + select.length + "条");
}
```

#### add()例子

```html
<select id="class" onchange="get(this);">
	  <option>1701班</option>
	  <option>1702班</option>
	  <option>1703班</option>
</select>
<input type="button" value="添加" onclick="addOption();">
```

```js
function addOption() {
  	var clazz = document.getElementById("class");
  	clazz.add(new Option("1704班", 1704));
}
```

#### Array使用

- 创建数组

```js
var  数组名称 = new Array(size);
```

- 为数组元素赋值

```js
var fruit= new Array("apple", "orange", " peach","bananer");
```

- 访问数组

```js
var fruit = new Array(4);
fruit [0] = "apple";
fruit [1] = "orange";
fruit [2] = "peach";
fruit [3] = "bananer";
```

#### 数组的属性和方法

| 类别   | 名称        | 描述                           |
| ---- | --------- | ---------------------------- |
| 属性   | length    | 设置或返回数组中元素的数目                |
| 方法   | join(  )  | 把数组的所有元素放入一个字符串，通过一个的分隔符进行分隔 |
| 方法   | concat( ) | 合并两个数组                       |
| 方法   | sort(  )  | 对数组的元素进行排序                   |

### 下拉级联例子

```html
<select id="region" onchange="loadCity(this);">
    <option>请选择省份</option>
</select>
<select id="city">
    <option>请选择城市</option>
</select>
```

```js
var regions = new Array();
regions['湖南省'] = ['长沙市', '岳阳市', '永州市'];
regions['广东省'] = ['深圳市', '广州市', '韶关市', '湛江市'];
```

```js
// 加载省份
function loadRegion() {
    var region = document.getElementById('region');
    var j = 0;
    for (var i in regions) {
      region.add(new Option(i));
    }
}

// 加载城市
function loadCity(region) {
    var city = document.getElementById('city');
    // 清除之前的所有option
    city.options.length = 0;

    var citys = regions[region.value];
    for (var i = 0; i < citys.length; i++) {
      city.add(new Option(citys[i]));
    }
}
```

![image](http://www.znsd.com/znsd/courses/uploads/d90084c2b581823f83f1c41753a3de63/image.png)
