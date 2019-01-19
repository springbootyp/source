# JSON

### 本章目标

- 掌握JSON的基本结构。
- 在服务器端生成JSON的文件。
- 掌握Ajax中解析JSON。

### JSON是什么

1. JSON (JavaScript Object Notation, JS 对象标记) 是一种轻量级的数据交换格式。它基于 ECMAScript(w3c制定的js规范)的一个子集，采用完全独立于编程语言的文本格式来存储和表示数据。简洁和清晰的层次结构使得 JSON 成为理想的数据交换语言。 易于人阅读和编写，同时也易于机器解析和生成，并有效地提升网络传输效率
2. JSON：JavaScript 对象表示法（`J`ava`S`cript `O`bject `N`otation），它是存储和交换文本信息的语法。类似 XML但比 XML 更小、更快，更易解析。
3. JSON是JavaScript的原生格式，这意味着在JavaScript中处理JSON格式不需要任何的API和工具包。

### 为什么要使用JSON

- 传统的网页应用中很多时候使用XML来进行数据的存储
  1. AJAX返回复杂的数据
  2. WebService
- 这些都是使用的XML文件来作为数据的传输格式。特别是Ajax中解析XML文件比较痛苦，还需要考虑浏览器兼容性问题。
- 那么有没有一种更加简洁，操作更加方便的数据格式呢？

```xml
<student>
    <name>张三</name>
    <age>18</age>
    <sex>男</sex>
</student>
```

```json
{
   "student":{
    "name":"张三",
    "age":18,
    "sex":"男"
    }
}
```

### JSON的优点

- JSON 是轻量级的文本数据交换格式 
- JSON 独立于语言 
- JSON 具有自我描述性，更易理解 
- JSON 使用 JavaScript 语法来描述数据对象，但是 JSON 仍然独立于语言和平台。 
- JSON 解析器和 JSON 库支持多种的编程语言。 
- JSON 可通过 JavaScript 进行解析 
- JSON 数据可使用 AJAX 进行传输 

### JSON语法规则

1. 对象表示法：

   对象结构以”{”大括号开始，以”}”大括号结束。中间部分由0或多个以”，”分隔的”key(关键字)/value(值)”对构成，关键字和值之间以”：”分隔，语法结构如代码。

   ```json
   {
       "key1":"value1",
       "key2":"value2",
     	......
   }
   ```

   ​

2. 数组表示法：

   数组结构以”[”开始，”]”结束。中间由0或多个以”，”分隔的值列表组成，语法结构如代码。

   ```json
   [
       {
           "key1":"value1",
           "key2":"value2" 
       },
       {
            "key3":"value3",
            "key4":"value4"   
       }
   ]
   ```

   ​

- JSON 语法是 JavaScript 对象表示法语法的子集。
  1. 数据在名称/值对中
  2. 数据由逗号分隔
  3. 花括号保存对象
  4. 方括号保存数组
- JSON的值可以支持的类型：数字，字符串，布尔值，数组，对象，null

### JSON示例

```js
<script type="text/javascript">
	var jsonObj = {
		"name" : "张山",
		"age" : 12,
		"address" : "广东省深圳市坪山区龙田小学",
		"show" : function() {
			alert("show json");
		}
	};
	alert(jsonObj.name);
	alert(jsonObj.age);
	jsonObj.show();
</script>
```

### JSON格式转化

#### 将一个字符串转换为JSON

- eval() 方法：

  ```js
  var jsonStr = '{"name":"李四","age":20}';
  var obj1 = eval("(" + jsonStr + ")");
  alert(obj1.name + "   "+ obj1.age);
  ```

  `eval方式不安全，如果中间有JS代码，会被执行。`

- JSON.parse() 方法：

  ```js
  var jsonStr = '{"name":"李四","age":20}';
  var obj2 = JSON.parse(jsonStr);
  alert(obj2.name + "   "+ obj2.age);
  ```

  `尽可能的使用JSON.parse()方法，相比evel()方法JSON.parse()更加安全，JSON.parse()方法会对JSON格式进行验证。`

### 服务器端生成JSON的方式

- 一、手动拼接JSON字符串

  优势：不需要借助任何第三方工具。

  缺点：比较容易出错，编写起来比较麻烦。

- 二、使用org.json.jar包生成。

  优势：调用方法使生成格式能确保正确。可以生成较复杂的对象。

  缺点：对于属性较多的对象生成比较麻烦。需要指定每个属性。

- 三、使用jackson包生成。

  优势：可以直接将对象转换为JSON格式。还可以通过注解进行控制。

  缺点：导包比较多。

#### 手动拼接JSON字符串

```java
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      // 设置编码格式
      request.setCharacterEncoding("UTF-8");
      response.setCharacterEncoding("UTF-8");
      // 设置返回类型
      response.setContentType("application/json;charset=UTF-8;");

      List<Student> studentList = new ArrayList<Student>();
      studentList.add(new Student(1, "xxx", 12, "广东"));
      studentList.add(new Student(2, "sss", 15, "湖南"));
      studentList.add(new Student(1, "asdf", 18, "福建"));
      studentList.add(new Student(1, "www", 13, "山东"));

      PrintWriter out = response.getWriter();

      // 组装json格式字符串
      out.write("{");
      out.write("\"data\":[");
      for (int i = 0; i < studentList.size(); i++) {
          Student student = studentList.get(i);
          out.write("{\"id\":\"" + student.getId() + "\",");
          out.write("\"name\":\"" + student.getName() + "\",");
          out.write("\"address\":\"" + student.getAddress() + "\",");
          out.write("\"age\":\"" + student.getAge() + "\"}");
          if (i < studentList.size() -1 ) {
            out.write(",");
          }
      }
      out.write("]");
      out.write("}");
}
```

![image](http://www.znsd.com/znsd/courses/uploads/ddcbd4c8b9396c8ffdfd7a573045c619/image.png)


#### JavaScript解析JSON

```js
function parseJson() {
    var xmlHttp = createXMLHttpRequest();
    xmlHttp.onreadystatechange=function(){
        if (xmlHttp.readyState==4 && xmlHttp.status == 200){
          var msg = document.getElementById("msg1");
          var json = JSON.parse(xmlHttp.responseText);

          msg.innerHTML = "姓名：" + json.data[0].name + "，年龄：" + json.data[0].age + "，地址：" + json.data[0].address;
        }
    }
    xmlHttp.open("POST", "/json", true);
    xmlHttp.send();
}
```
#### 通过org.json生成JSON

org.json需要[json](http://www.znsd.com/znsd/courses/uploads/dc6f9d811c87c3a868f15877654c41a9/json-20171018.jar)的jar包

```java
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    // 设置编码格式
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    // 设置返回类型
    response.setContentType("application/json;charset=UTF-8;");

    List<Student> studentList = new ArrayList<Student>();
    studentList.add(new Student(1, "xxx", 12, "广东"));
    studentList.add(new Student(2, "sss", 15, "湖南"));
    studentList.add(new Student(1, "asdf", 18, "福建"));
    studentList.add(new Student(1, "www", 13, "山东"));

    PrintWriter out = response.getWriter();

    JSONObject jsonObj = new JSONObject();
    JSONArray jsonArray = new JSONArray();

    // 组装json格式字符串
    for (int i = 0; i < studentList.size(); i++) {
      Student student = studentList.get(i);
      JSONObject studentJson = new JSONObject();
      studentJson.put("id", student.getId());
      studentJson.put("name", student.getName());
      studentJson.put("age", student.getId());
      studentJson.put("address", student.getAge());
      jsonArray.put(studentJson);
    }
    jsonObj.put("code", "0");
    jsonObj.put("data", jsonArray);

    out.write(jsonObj.toString());
}
```

#### jackson包生成

[jackson下载](http://www.znsd.com/znsd/courses/uploads/035625df2f29f7b984dfdf0ec756adb6/jackson.zip)

使用jackson需要导入3个jar包

- jackson-annotations-2.8.2.jar
- jackson-core-2.8.2.jar
- jackson-databind-2.8.2.jar

```java
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    // 设置编码格式
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    // 设置返回类型
    response.setContentType("application/json;charset=UTF-8;");

    List<Student> studentList = new ArrayList<Student>();
    studentList.add(new Student(1, "xxx", 12, "广东"));
    studentList.add(new Student(2, "sss", 15, "湖南"));
    studentList.add(new Student(1, "asdf", 18, "福建"));
    studentList.add(new Student(1, "www", 13, "山东"));

    PrintWriter out = response.getWriter();

    ObjectMapper objectMapper = new ObjectMapper();
    objectMapper.writeValue(out, studentList);
}
```

`Jackson是根据实体封装的getter属性来生成json的属性，可以通过注解来修改属性名称@JsonProperty,也可以通过@JsonIgnore忽略不必要的属性。`

### JSON和XML的区别

#### 相同点：

- 都可以用来实现数据的存储，可以用来描述对象。

#### 不同点：

- 没有结束标签
- 更短，读取更加方便
- 使用JavaScript解析更加方便。
- 对于Ajax来说JSON比XML更快更方便。

### 总结

- JSON的优势是什么？
- JSON的语法规则。
- JAVA生成JSON格式文档。
- JavaScript解析JSON格式

### 作业

- 什么是JSON，使用JSON有什么优势？
- JSON有哪几种格式？如何表示。
- 使用JSON创建一个学生集合对象。
- FormData的作用是什么？对于ajax请求有什么优化。