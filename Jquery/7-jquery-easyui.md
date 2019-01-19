# 第七章  EasyUI入门

### 本章目标

- 掌握EasyUI的基本用法`重点` `难点`
- 掌握常用的EasyUI组件的使用
- 学会查看EasyUIAPI文档和Demo学习EasyUI的用途。

### 为什么使用EasyUI

现在开发网页对前端页面效果要求越来越高，用户体验要求也越来越高，那么如何能简单快速的开发出具有非常酷炫和高用户体验的页面呢？一些封装好的UI插件帮助我们解决了这个问题。

- 常见的UI框架
  1. jQuery UI：jQuery官方提供的UI插件。
  2. Bootstrap：来自Twitter的一款前端开源框架，目前也非常受欢迎。
  3. EasyUI：一套功能强大，并且使用简单的UI插件。
  4. MiniUI：和EasyUI类似，相当于Mini版的EasyUI。
  5. ExtJS：功能非常强大的重量级前端框架，无论是功能还是界面ExtJS都是业内顶尖的。但由于使用复杂，体积庞大，不适合初学者。

### 什么是EasyUI

EasyUI 是一个基于jQuery 的UI框架，jQueryEasyUI的目标就是帮助Web开发者更轻松的打造功能丰富，并且页面美观的UI界面。

- Easyui官方网站 http://www.jeasyui.com
- easyUI演示地址 http://www.jeasyui.com/themebuilder/index.php
- 国内easyui中文网站 http://www.jeasyui.net/

![20171222165036](http://www.znsd.com/znsd/courses/uploads/674d486c5e6a06ebdf066d19f8d9aa33/20171222165036.png)

### EasyUI的特点

- 基于jQuery用户界面插件的集合
- 为一些当前用于交互的js应用提供必要的功能。
- 使用EasyUI你不需要写很多的javascript代码，通常只需要定义html标记来定义用户界面即可。
- 开发产品时可节省大量的时间和资源。
- 简单，但很强大。
- 支持扩展，可根据项目需求扩展插件。
- 支持HTML5
- 免费版和商业版
- `比较适合创建后台管理页面`

### EasyUI的文档结构

- 首先要使用EasyUI必须下载EasyUI对应的文件包。官方下载地址：http://www.jeasyui.com/download/index.php
- EasyUI的文档结构
  1. demo：示例代码
  2. demo-mobile：对应手机端示例代码
  3. locale:国际化语言包
  4. plugins：插件包
  5. src：核心代码包
  6. themes：皮肤样式文件
  7. Jquery-easyui.min.js：easyui核心js文件
  8. jquery-min.js：所依赖的jquery文件

#### 如何导入EasyUI

在使用EasyUI之前必须先将先引入对应的JS文件，由于EasyUI是在jQuery基础上进行开发的，所以还必须在其他js之前引用对应的jquery文件和css文件。

```js
<!--jquery文件-->
<script type="text/javascript" src="easyui/jquery.min.js"></script>
<!--easyui核心文件-->
<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
<!--对应的语言包-->
<script type="text/javascript" src="easyui/locale/easyui-lang-zh_CN.js"></script>
<!--皮肤文件-->
<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css" />
<!--图标文件-->
<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css" />
```

### 如何使用EasyUI

使用EasyUI有两种方式

1. HTML静态class方式：通过指定class属性来设定

   ```js
   <div class="easyui-dialog" title="标题" style="width:400px;height:200px"></div>
   ```

2. 通过js方式进行加载

   ```html
   <div id="box" style="width:400px;height:200px;">弹出对话框</div>
   ```

   ```js
   $(function(){
   	$('#box').dialog();
   });
   ```

`注意：一般推荐使用js方式进行加载，因为一个UI组件有很多个属性和方法，如果使用class将有极大的不方便。`

### 智能加载方式

- 除了前面提供了加载方式外，EasyUI还提供一种智能加载方式。

- 智能加载是不去加载easyui.min.js和easyui.css等大体积的js和css文件，根据我们当前页面的需要去加载用到的js和css样式文件。

- 要使用智能加载首先需要引入easyloader.js，将其他js和 css文件去掉。（需要保留jquery.js文件）

  ```js
  <script type="text/javascript" src="easyui/easyloader.js"></script>
  ```

- 使用easyload.load()方法进行按需加载

  ```js
  easyloader.load("dialog",function(){
  	$("#box").dialog();
  });
  ```

`注意：使用智能加载的根据你所使用的ui组件按需加载，我们可以通过源代码看到加载了非常多的JS和CSS，使用智能加载会减少不必要的内容加载，但是会提高编码的难度，降低效率。`

### Parser解析器

- Parser解析器是专门用来解析UI组件的，一般来说，我们不需要使用它即可完成UI组件的解析工作。当然，也可能在某些环境下手动进行解析。

| 属性            | 值           | 说明               |
| ------------- | ----------- | ---------------- |
| $.parser.auto | true\|false | 定义是否自动解析easyUI组件 |

```js
$.parser.auto=false;  //当设置为false时，页面中指定class将不能完成解析。
```

`注意：$.parser.auto = false，必须放在$(function(){})方法之外，否则无效。`

- Parser除了auto属性以外，还提供手动解析UI组件的方法。

| 方法                  | 参数       | 说明                                    |
| ------------------- | -------- | ------------------------------------- |
| $.parser.parse()    | 空或者jq选择器 | 当为空时，解析页面中所有的UI组件，当为jq选择器时，解析指定的UI组件。 |
| $.parser.onComplete | 回调函数     | 当页面中的UI组件解析完毕后指定的方法。                  |

```js
//UI解析完毕后执行的方法。必须放在$(function(){})之外
$.parser.onComplete = function(){
    alert("UI解析完毕");  
}
```

### EasyUI中的插件

EasyUI提供了丰富的插件，适用于各种情况和场景。

- 基本类(Base)
- 布局类(Layout)
- 窗口类(Window)
- 菜单与按钮类(Menu和Button)
- 树形菜单类(Tree)
- 数据网格类(Grid)
- 表单类(Form)

![20171222173256](http://www.znsd.com/znsd/courses/uploads/12cdcfd5adc9d267fa79eb250beac6ae/20171222173256.png)

### 插件演示

由于EasyUI中的插件较多，直接对照帮助文档和Demo进行讲解演示。



### 动态加载树菜单和打开页面

```js
<script type="text/javascript">
	$(function() {
		$("#menuTree").tree({
			lines:true,
			url:'tree_data1.json',
			onLoadSuccess:function(){
				$("#tree").tree('expandAll');
			},
			onClick:function(node){
				console.info(node);
				if(node.path){
					openTab(node);
				}else if(node.id==16){
					logOut();
				}else if(node.id==15){
					openPasswordModifyDialog();
				}
			}
		});
		
		<!--打开标签!--> 
		function openTab(node){
			if ($("#tabs").tabs("exists",node.text)) {
				$("#tabs").tabs("select",node.text);
			}else{
				var content="<iframe frameborder=0 scrolling='auto' style='width:100%;height:100%' src="+node.path+"></iframe>";
				$("#tabs").tabs("add",{
					title:node.text,
					iconCls:node.iconCls,
					closable:true,
					content:content
				});
			}
		}
	})
</script>
```



### easyui 组件使用

#### easyui布局

- 导入easyui依赖js、css文件

```html
<script type="text/javascript" src="easyui/jquery.min.js"></script>
<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="easyui/locale/easyui-lang-zh_CN.js"></script>
<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css">
```

- 通过html布局

```html
<body class="easyui-layout">
	<div data-options="region:'north',border:false" style="height:60px;background:#B3DFDA;padding:10px">顶部</div>
	<div data-options="region:'west',split:true,title:'West'" style="width:250px;padding:10px;">
      左边菜单
	</div>
	<div data-options="region:'east',split:true,collapsed:true,title:'East'" style="width:100px;padding:10px;">右边菜单</div>
	<div data-options="region:'south',border:false" style="height:50px;background:#A9FACD;padding:10px;">底部</div>
	<div data-options="region:'center',title:'Center'">
		<div id="tabs" class="easyui-tabs" data-options="tools:'#tab-tools'" style="width:100%;height:630px">
	</div>
</body>
```

#### 树形菜单

- html通过div定义树形节点

```html
<div id="easyui-tree" class="easyui-panel" style="padding:5px"></div>
```

- js加载数据

```js
$("#easyui-tree").tree({
	  	url:'tree_data.json',
	  	method:'get',
	  	animate:true,
	  	onLoadSuccess:function(){
        	$("#easyui-panel").tree('expandAll');
        },
	  	lines:true,
	  	onClick: function(node) {
	  		openTab(node);
	  	}
});
```

- tree_data.json

```json
[
	{
		"id": 11,
		"text": "系统管理",
		"state": "closed",
		"children": [
			{
				"id": 111,
				"text": "用户管理",
				"path": "userManage.jsp"
			},
			{
				"id": 112,
				"text": "角色管理",
				"path": "roleManage.html"
			},
			{
				"id": 113,
				"text": "权限管理"
			}
		]
	},
	{
		"id": 12,
		"text": "订单管理",
		"children": [
			{
				"id": 121,
				"text": "Intel"
			},
			{
				"id": 122,
				"text": "Java",
				"attributes": {
					"p1": "Custom Attribute1",
					"p2": "Custom Attribute2"
				}
			},
			{
				"id": 123,
				"text": "Microsoft Office"
			},
			{
				"id": 124,
				"text": "Games",
				"checked": true
			}
		]
	}
]
```

  

#### 表格使用

- 通过html中的table标签定义表格

```html
<table id="grid"></table>
```

- js异步加载表格中的数据

```js
$(function() {		
		$("#grid").datagrid({
			title : 'Load Data', // 表格标题
			iconCls : 'icon-save', // 表格图标
			width : 600, // 宽度
			height : 250, // 高度
			url : 'datagrid_data.json', // 异步加载数据的url地址
			columns : [ [ { // 定义所有列
				field : "itemid", //json数据返回的字段名
				title : "编号", // 表格中列标题
				width : 80 // 表格中列的宽度
			}, {
				field : "productid",
				title : "商品",
				width : 80
			}, {
				field : "listprice",
				title : "价格",
				width : 80
			}, {
				field : "unitcost",
				title : "单位",
				width : 80
			}, {
				field : "attr1",
				title : "属性",
				width : 80
			}, {
				field : "status",
				title : "状态",
				width : 80
			} ] ]
		});
});
```

- json数据

```json
{
	"total": 28,
	"rows": [
		{
			"productid": "FI-SW-01",
			"productname": "Koi",
			"unitcost": 10.00,
			"status": "P",
			"listprice": 36.50,
			"attr1": "Large",
			"itemid": "EST-1"
		},
		{
			"productid": "K9-DL-01",
			"productname": "Dalmation",
			"unitcost": 12.00,
			"status": "P",
			"listprice": 18.50,
			"attr1": "Spotted Adult Female",
			"itemid": "EST-10"
		},
		{
			"productid": "RP-SN-01",
			"productname": "Rattlesnake",
			"unitcost": 12.00,
			"status": "P",
			"listprice": 38.50,
			"attr1": "Venomless",
			"itemid": "EST-11"
		},
		{
			"productid": "RP-SN-01",
			"productname": "Rattlesnake",
			"unitcost": 12.00,
			"status": "P",
			"listprice": 26.50,
			"attr1": "Rattleless",
			"itemid": "EST-12"
		},
		{
			"productid": "RP-LI-02",
			"productname": "Iguana",
			"unitcost": 12.00,
			"status": "P",
			"listprice": 35.50,
			"attr1": "Green Adult",
			"itemid": "EST-13"
		},
		{
			"productid": "FL-DSH-01",
			"productname": "Manx",
			"unitcost": 12.00,
			"status": "P",
			"listprice": 158.50,
			"attr1": "Tailless",
			"itemid": "EST-14"
		},
		{
			"productid": "FL-DSH-01",
			"productname": "Manx",
			"unitcost": 12.00,
			"status": "P",
			"listprice": 83.50,
			"attr1": "With tail",
			"itemid": "EST-15"
		},
		{
			"productid": "FL-DLH-02",
			"productname": "Persian",
			"unitcost": 12.00,
			"status": "P",
			"listprice": 23.50,
			"attr1": "Adult Female",
			"itemid": "EST-16"
		},
		{
			"productid": "FL-DLH-02",
			"productname": "Persian",
			"unitcost": 12.00,
			"status": "P",
			"listprice": 89.50,
			"attr1": "Adult Male",
			"itemid": "EST-17"
		},
		{
			"productid": "AV-CB-01",
			"productname": "Amazon Parrot",
			"unitcost": 92.00,
			"status": "P",
			"listprice": 63.50,
			"attr1": "Adult Male",
			"itemid": "EST-18"
		}
	]
}
```

### easy ui 所有图标

![20180515104933](http://www.znsd.com/znsd/courses/uploads/c6c179b2934aede58772814c6c5367b4/20180515104933.png)

```html
<a href="###" class="easyui-linkbutton" iconCls="icon-add">icon-add</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-edit">icon-edit</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-clear">icon-clear</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-remove">icon-remove</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-save">icon-save</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-cut">icon-cut</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-ok">icon-ok</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-no">icon-no</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-cancel">icon-cancel</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-reload">icon-reload</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-search">icon-search</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-print">icon-print</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-help">icon-help</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-undo">icon-undo</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-redo">icon-redo</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-back">icon-back</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-sum">icon-sum</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-tip">icon-tip</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-filter">icon-filter</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-man">icon-man</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-lock">icon-lock</a>  
<a href="###" class="easyui-linkbutton" iconCls="icon-more">icon-more</a>
```

## 总结

- EasyUI的基本用法。

