# Java基础-XML

## 什么是XML？

- XML（Extensible Markup Language）可扩展的标记语言，它是一种通用的数据交换格式,它的平台无关性、语言无关性、系统无关性、给数据集成与交互带来了极大的方便。
- XML在不同的语言环境中解析方式都是一样的,只不过实现的语法不同而已

## XML 能干什么？

1. 存储数据
2. 传输数据，纯文本文件，不存在转换格式的麻烦
3. 软件配置，比如今后学的配置tomcat虚拟目录映射等就用到了

## XML文档节点类型

- **文档(document)**

- **元素(element)**

- **属性(attribute)**

- **文本(PCDATA--parsed character data)**

- 注释(comment)

- DOCTYPE ：主要验证文档内容的正确性

- 实体(ENTITIES)

- CDATA(character data)

## 解析XML方式分为四种

**解析XML方式分为四种方式**

- DOM（Document Object Model） 解析
- SAX（Simple APIs for XML） 解析
- JDOM 解析
- DOM4J 解析

### DOM解析

#### **DOM解析介绍**

- DOM的全称是Document Object Model，也即文档对象模型。在应用程序中，基于DOM的**XML分析器将一个XML文档转换成一个对象模型的集合（通常称DOM树）**，应用程序正是通过对这个对象模型的操作，来实现对XML文档数据的操作。通过DOM接口，应用程序可以在任何时候访问XML文档中的任何一部分数据，因此，这种利用DOM接口的机制也被称作随机访问机制。
- DOM接口提供了一种通过分层对象模型来访问XML文档信息的方式，这些分层对象模型依据XML的文档结构形成了一棵节点树。无论XML文档中所描述的是什么类型的信息，即便是制表数据、项目列表或一个文档，利用DOM所生成的模型都是节点树的形式。也就是说，DOM强制使用树模型来访问XML文档中的信息。由于XML本质上就是一种分层结构，所以这种描述方法是相当有效的。
- DOM树所提供的随机访问方式给应用程序的开发带来了很大的灵活性，它可以任意地控制整个XML文档中的内容。然而，由于DOM分析器把整个XML文档转化成DOM树放在了内存中，因此，当文档比较大或者结构比较复杂时，对内存的需求就比较高。而且，对于结构复杂的树的遍历也是一项耗时的操作。所以，DOM分析器对机器性能的要求比较高，实现效率不十分理想。不过，由于DOM分析器所采用的树结构的思想与XML文档的结构相吻合，同时鉴于随机访问所带来的方便，因此，DOM分析器还是有很广泛的使用价值的。

#### DOM的基本对象

DOM的基本对象有5个：Document，Node，NodeList，Element和Attr

- **Document对象**：代表了整个XML的文档，所有其它的Node，都以一定的顺序包含在Document对象之内，排列成一个树形的结构，程序员可以通过遍历这颗树来得到XML文档的所有的内容，这也是对XML文档操作的起点。我们总是先通过解析XML源文件而得到一个Document对象，然后再来执行后续的操作。此外，Document还包含了创建其它节点的方法，比如createAttribut()用来创建一个Attr对象。它所包含的主要的方法有：

  - **createAttribute(String)：**用给定的属性名创建一个Attr对象，并可在其后使用setAttributeNode方法来放置在某一个Element对象上面。

  - **createElement(String)：**用给定的标签名创建一个Element对象，代表XML文档中的一个标签，然后就可以在这个Element对象上添加属性或进行其它的操作。

  - **createTextNode(String)：**用给定的字符串创建一个Text对象，Text对象代表了标签或者属性中所包含的纯文本字符串。如果在一个标签内没有其它的标签，那么标签内的文本所代表的Text对象是这个Element对象的唯一子对象。

  - **getElementsByTagName(String)：**返回一个NodeList对象，它包含了所有给定标签名字的标签。

  - **getDocumentElement()：**返回一个代表这个DOM树的根节点的Element对象，也就是代表XML文档根元素的那个对象。

- **Node对象**:是DOM结构中最为基本的对象，代表了文档树中的一个抽象的节点。在实际使用的时候，很少会真正的用到Node这个对象，而是用到诸如Element、Attr、Text等Node对象的子对象来操作文档。Node对象为这些对象提供了一个抽象的、公共的根。虽然在Node对象中定义了对其子节点进行存取的方法，但是有一些Node子对象，比如Text对象，它并不存在子节点，这一点是要注意的。Node对象所包含的主要的方法有

  - **appendChild(org.w3c.dom.Node)：**为这个节点添加一个子节点，并放在所有子节点的最后，如果这个子节点已经存在，则先把它删掉再添加进去。

  - **getFirstChild()：**如果节点存在子节点，则返回第一个子节点，对等的，还有getLastChild()方法返回最后一个子节点。

  - **getNextSibling()：**返回在DOM树中这个节点的下一个兄弟节点，对等的，还有getPreviousSibling()方法返回其前一个兄弟节点。

  - **getNodeName()：**根据节点的类型返回节点的名称。

  - **getNodeType()：**返回节点的类型。

  - **getNodeValue()**：返回节点的值。

  - **hasChildNodes()**：判断是不是存在有子节点。

  - **hasAttributes()：**判断这个节点是否存在有属性。

  - **getOwnerDocument()：**返回节点所处的Document对象。

  - **insertBefore(org.w3c.dom.Node new，org.w3c.dom.Node ref)：**在给定的一个子对象前再插入一个子对象。

  - **removeChild(org.w3c.dom.Node)：**删除给定的子节点对象。

  - **replaceChild(org.w3c.dom.Node new，org.w3c.dom.Node old)：**用一个新的Node对象代替给定的子节点对象。

- **NodeList**：对象顾名思义，就是代表了一个包含了一个或者多个Node的列表。可以简单的把它看成一个Node的数组，我们可以通过方法来获得列表中的元素：

  - **getLength()：**返回列表的长度。

  - **item(int)：**返回指定位置的Node对象。

- **Element对象**：  代表的是XML文档中的标签元素，继承于Node，亦是Node的最主要的子对象。在标签中可以包含有属性，因而Element对象中有存取其属性的方法，而任何Node中定义的方法，也可以用在Element对象上面。

  - **getElementsByTagName(String)：**返回一个NodeList对象，它包含了在这个标签中其下的子孙节点中具有给定标签名字的标签。

  - **getTagName()：**返回一个代表这个标签名字的字符串。

  - **getAttribute(String)：**返回标签中给定属性名称的属性的值。在这儿需要主要的是，应为XML文档中允许有实体属性出现，而这个方法对这些实体属性并不适用。这时候需要用到getAttributeNodes()方法来得到一个Attr对象来进行进一步的操作。

  - **getAttributeNode(String)：**返回一个代表给定属性名称的Attr对象。

- **Attr对象**:代表了某个标签中的属性。Attr继承于Node，但是因为Attr实际上是包含在Element中的，它并不能被看作是Element的子对象，因而在DOM中Attr并不是DOM树的一部分，所以Node中的getParentNode()，getPreviousSibling()和getNextSibling()返回的都将是null。也就是说，Attr其实是被看作包含它的Element对象的一部分，它并不作为DOM树中单独的一个节点出现。这一点在使用的时候要同其它的Node子对象相区别。

#### **DOM解析优缺点**

优点：

- **1、形成了树结构，有助于更好的理解、掌握，且代码容易编写。**
- **2、解析过程中，树结构保存在内存中，方便修改。**

缺点

- **1、由于文件是一次性读取，所以对内存的耗费比较大。**
- **2、如果XML文件比较大，容易影响解析性能且可能会造成内存溢出。**

#### 例子

xml文件

```xml
<!-- xml头部，固定语法 -->
<?xml version="1.0" encoding="UTF-8"?>
<!-- 定义一个节点 -->
<students>
    <!-- 定义一个子节点 id为节点的属性-->
	<student id="1001">
		<name>张三</name>
		<age>21</age>
		<sex>女</sex>
	</student>
</students>
```

解析xml

```java
/**
* 读取xml文件
* 
* @throws ParserConfigurationException
* @throws SAXException
* @throws IOException
*/
public static void read() throws ParserConfigurationException, SAXException, IOException {
    // 创建一个DocumentBuilderFactory的对象
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();

    // 创建一个DocumentBuilder的对象
    DocumentBuilder builder = factory.newDocumentBuilder();

    // 通过DocumentBuilder对象的parser方法加载students.xml文件到当前项目下
    Document document = builder.parse("students.xml");

    // 获取所有student节点的集合
    NodeList nodeList = document.getElementsByTagName("student");

    System.out.println("一共有：" + nodeList.getLength() + "个学生信息");

    for (int i = 0; i < nodeList.getLength(); i++) {
        // 获取一个一个的节点
        Node student = nodeList.item(i);
        System.out.println("节点名称：" + student.getNodeName());

        NamedNodeMap studentAttribute = student.getAttributes();
        Node id = studentAttribute.getNamedItem("id");
        System.out.println("节点属性:" + id.getNodeName() + "=" + id.getNodeValue());

        // 获取student下面的所有子节点
        NodeList studentNodes = student.getChildNodes();
        for (int j = 0; j < studentNodes.getLength(); j++) {

            Node node = studentNodes.item(j);
            if (node instanceof Element) { // 判断是否是元素

                Element typename = (Element) node;
                String typen = typename.getNodeName(); // 获取节点名称
                System.out.println(typen + "===" + typename.getTextContent()); // 获取节点值
            }
        }
    }
}
```

添加xml节点

```java
/**
* 添加节点
* 
* @throws ParserConfigurationException
* @throws SAXException
* @throws IOException
* @throws TransformerException
*/
public static void add() throws ParserConfigurationException, SAXException, IOException, TransformerException {
    // 创建一个DocumentBuilderFactory的对象
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();

    // 创建一个DocumentBuilder的对象
    DocumentBuilder builder = factory.newDocumentBuilder();

    // 通过DocumentBuilder对象的parser方法加载students.xml文件到当前项目下
    Document document = builder.parse("students.xml");

    Element root = document.getDocumentElement();

    Element studentElement = document.createElement("student");

    studentElement.setAttribute("id", "1004");

    Element nameElement = document.createElement("name");
    nameElement.setTextContent("麻子");
    studentElement.appendChild(nameElement);

    Element ageElement = document.createElement("age");
    ageElement.setTextContent("26");
    studentElement.appendChild(ageElement);

    Element sexElement = document.createElement("sex");
    sexElement.setTextContent("男");
    studentElement.appendChild(sexElement);

    root.appendChild(studentElement);

    TransformerFactory factory2 = TransformerFactory.newInstance();
    Transformer transformer = factory2.newTransformer();
    transformer.transform(new DOMSource(document), new StreamResult(new File("students.xml")));
}
```

删除xml节点

```java
/**
* 获取目标节点，进行删除
*/
public static void delete() {

    DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
    try {

        DocumentBuilder db = dbf.newDocumentBuilder();
        Document xmldoc = db.parse("students.xml");
        // 获取根节点
        Element root = xmldoc.getDocumentElement();
        // 定位根节点中的id=1001的节点
        Element student = (Element) selectSingleNode("/students/student[@id='1001']", root);
        if (student != null) {
            // 删除该节点
            root.removeChild(student);
            // 保存
            TransformerFactory factory = TransformerFactory.newInstance();
            Transformer former = factory.newTransformer();
            former.transform(new DOMSource(xmldoc), new StreamResult(new File("students.xml")));
        } else {
            System.out.println("未找到需要删除的节点");
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
}
```

根据id选中一个节点信息

```java
/**
* 根据id选择节点信息
* 
* @param express
* @param source
* @return
*/
public static Node selectSingleNode(String express, Element source) {
    Node result = null;
    // 创建XPath工厂
    XPathFactory xpathFactory = XPathFactory.newInstance();
    // 创建XPath对象
    XPath xpath = xpathFactory.newXPath();
    try {
        result = (Node) xpath.evaluate(express, source, XPathConstants.NODE);
    } catch (XPathExpressionException e) {
        e.printStackTrace();
    }

    return result;
}
```

修改xml节点信息

```java
/**
* 修改节点信息
*/
public static void update() {
    // 创建一个DocumentBuilderFactory的对象
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();

    Document document = null;
    try {
        // 创建一个DocumentBuilder的对象
        DocumentBuilder builder = factory.newDocumentBuilder();

        // 通过DocumentBuilder对象的parser方法加载students.xml文件到当前项目下
        document = builder.parse("students.xml");
        Element root = document.getDocumentElement();

        // 根据id选择一个节点
        Element node = (Element)selectSingleNode("/students/student[@id=1002]", root);

        // 获取姓名节点
        Node nameNode = node.getElementsByTagName("name").item(0);
        // 修改节点的值
        nameNode.setTextContent("李四1");

        TransformerFactory factory2 = TransformerFactory.newInstance();
        Transformer transformer = factory2.newTransformer();
        transformer.transform(new DOMSource(document), new StreamResult(new File("students.xml")));
    } catch (SAXException | IOException e) {
        e.printStackTrace();
    } catch (ParserConfigurationException e) {
        e.printStackTrace();
    } catch (TransformerConfigurationException e) {
        e.printStackTrace();
    } catch (TransformerException e) {
        e.printStackTrace();
    }
}
```

## SAX 解析

### 什么是SAX 解析

- SAX是Simple API forXML的缩写，它并不是由W3C官方所提出的标准，可以说是“民间”的事实标准。实际上，它是一种社区性质的讨论产物。虽然如此，在XML中对SAX的应用丝毫不比DOM少，几乎所有的XML解析器都会支持它。
- 与DOM比较而言，SAX是一种轻量型的方法。我们知道，在处理DOM的时候，我们需要读入整个的XML文档，然后在内存中创建DOM树，生成DOM树上的每个Node对象。当文档比较小的时候，这不会造成什么问题，但是一旦文档大起来，处理DOM就会变得相当费时费力。特别是其对于内存的需求，也将是成倍的增长
- SAX在概念上与DOM完全不同。首先，不同于DOM的文档驱动，它是事件驱动的，也就是说，`它并不需要读入整个文档，而文档的读入过程也就是SAX的解析过程。所谓事件驱动，是指一种基于回调（callback）机制的程序运行方法`。

### SAX 解析例子

测试方法

```java
public class TestSax {

	public static void main(String[] args) {
		File file = new File("students.xml");
		try {
			SAXParserFactory spf = SAXParserFactory.newInstance();
			SAXParser parser = spf.newSAXParser();
			SaxHandler handler = new SaxHandler("student");
			parser.parse(new FileInputStream(file), handler);

			List<Student> studentList = handler.getStudents();
			for (Student student : studentList) {
				System.out.println(student.getId() + "\t" + student.getName() + "\t" + student.getSex() + "\t" + student.getAge());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
```

回调处理类

```java
public class SaxHandler extends DefaultHandler {
	private List<Student> students = null;
	private Student student;
	private String currentTag = null;
	private String currentValue = null;
	private String nodeName = null;

	public List<Student> getStudents() {
		return students;
	}

	public void setStudents(List<Student> students) {
		this.students = students;
	}

	public SaxHandler(String nodeName) {
		this.nodeName = nodeName;
	}

	@Override
	public void startDocument() throws SAXException {
		// TODO 当读到一个开始标签的时候，会触发这个方法
		super.startDocument();

		students = new ArrayList<Student>();
	}

	@Override
	public void endDocument() throws SAXException {
		// TODO 自动生成的方法存根
		super.endDocument();
	}

	@Override
	public void startElement(String uri, String localName, String name, Attributes attributes) throws SAXException {
		// TODO 当遇到文档的开头的时候，调用这个方法
		super.startElement(uri, localName, name, attributes);

		if (name.equals(nodeName)) {
			student = new Student();
		}
		if (attributes != null && student != null) {
			for (int i = 0; i < attributes.getLength(); i++) {
				if (attributes.getQName(i).equals("id")) {
					student.setId(attributes.getValue(i));
				} else if (attributes.getQName(i).equals("sex")) {
					student.setSex(attributes.getValue(i));
				}
			}
		}
		currentTag = name;
	}

	@Override
	public void characters(char[] ch, int start, int length) throws SAXException {
		// TODO 这个方法用来处理在XML文件中读到的内容
		super.characters(ch, start, length);

		if (currentTag != null && student != null) {
			currentValue = new String(ch, start, length);
			if (currentValue != null && !currentValue.trim().equals("") && !currentValue.trim().equals("\n")) {
				if (currentTag.equals("name")) {
					student.setName(currentValue);
				} else if (currentTag.equals("age")) {
					student.setAge(currentValue);
				} else if (currentTag.equals("sex")) {
					student.setSex(currentValue);
				}
			}
		}
		currentTag = null;
		currentValue = null;
	}

	@Override
	public void endElement(String uri, String localName, String name) throws SAXException {
		// TODO 在遇到结束标签的时候，调用这个方法
		super.endElement(uri, localName, name);

		if (name.equals(nodeName)) {
			students.add(student);
		}
	}
}
```

属性类

```java
public class Student {
	private String id;
	private String name;
	private String sex;
	private String age;
}
```



## DMO与SAX的区别

**DOM：拉模型，把整个文档加载到内存中**

- 优点：整个文档树在内存中，便于操作；支持删除、修改、重新排列等多种功能；
- 缺点：将整个文档调入内存（包括无用的节点），浪费时间和空间；
- 使用场合：一旦解析了文档还需多次访问这些数据；硬件资源充足（内存、CPU）

**SAX：推模型，事件驱动编程，基于回调SAX ，事件驱动。**当解析器发现元素开始、元素结束、文本、文档的开始或结束等时，发送事件，程序员编写响应这些事件的代码，保存数据。

- 优点：不用事先调入整个文档，占用资源少；
- 缺点：不是持久的；事件过后，若没保存数据，那么数据就丢了；无状态性；从事件中只能得到文本，但不知该文本属于哪个元素；
- 使用场合：数据量较大的XML文档，占用内存高，机器内存少，无法一次加载XML到内存；只需XML文档的少量内容，很少回头访问；