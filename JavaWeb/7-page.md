## 第八章  分页

### 回顾

- EL表达式的作用是什么？.和[]有什么区别？
- EL表达式的隐式对象包括哪些？
- JSTL中核心标签库包括哪些？
- MySql中查询第21到30条学生信息？

### 本章任务

- 实现学生信息分页显示

### 本章目标

- 掌握分页显示的原理及实现步骤`重点（难点）`

### 大容量的数据显示

- 数据显示：较多数据信息以列表方式显示

- 当数据量很大时，用户必须拖动页面才能浏览更多的数据，而且页面也显得冗长

  ![image](http://www.znsd.com/znsd/courses/uploads/c3d9332337280dbb071fdf73ca69aa19/image.png)

### 大容量数据显示特点

以列表方式显示数据的特点

**优势**

- 数据能够按照指定格式显示，布局清晰
- 不受信息数量的限制

**不足**

- 当数据量较多，需要用户拖动页面才能浏览更多信息

**提问**

- 那有没有另一种显示方式，既能显示多条信息，又不需要拖动页面呢？
- 采用分页技术实现批量数据的页面显示

`如果数据是从数据库中读出的，当数据上万条或更多时，数据库的压力非常大，可能有假死机的现象。`

### 生活中的分页显示

- 分页显示在生活中随处可见

  ![image](http://www.znsd.com/znsd/courses/uploads/3fc57d820fd177bee2e3761d711b2a05/image.png)

### 分页实现的思路

- 分页显示的步骤
  1. 确定每页显示的数据数量
  2. 确定分页显示所需的总页数
  3. 编写SQL查询语句，实现数据查询
  4. 在JSP页面中进行分页显示设置

### 封装Page类

```java
public class Page<T> implements Serializable {

	private static final long serialVersionUID = 1L;

	private static Integer LIMIT = 5;

	private int pageCount = 1; // 总页数
	private int pageSize = LIMIT; // 页面大小，即每页显示记录数
	private int totalCount = 0; // 记录总数
	private int pageIndex = 1; // 当前页码
	List<T> list = new ArrayList<T>(); // 每页数据集合

	public Page() {

	}

	public Page(int pageIndex) {
		super();
		this.pageIndex = pageIndex;
	}

	public Page(int pageSize, int pageIndex) {
		super();
		this.pageSize = pageSize;
		this.pageIndex = pageIndex;
	}

	/**
	 * 获取开始位置
	 * 
	 * @return
	 */
	public int getStart() {
		if ((pageIndex - 1) * pageSize <= 0) {
			return 0;
		}
		return (pageIndex - 1) * pageSize;
	}

	/**
	 * 获取总页数 如果你的数据表没有主键，那么count(1)比count(*)快
	 * 如果有主键的话，那主键（联合主键）作为count的条件也比count(*)要快 如果你的表只有一个字段的话那count(*)就是最快的啦
	 * count(*) count(1) 两者比较。 主要还是要count(1)所相对应的数据字段。
	 * 如果count(1)是聚索引,id,那肯定是count(1)快，但是差的很小的。
	 * 因为count(*),自动会优化指定到那一个字段。所以没必要去count(?)，用count(*),sql会帮你完成优化的
	 * 
	 * @return
	 */
	public int getPageCount() {
		return (int) Math.ceil(totalCount / pageSize);
	}

	public void setPageCount(int pageCount) {
		this.pageCount = pageCount;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public int getPageIndex() {
		return pageIndex;
	}

	public void setPageIndex(int pageIndex) {
		this.pageIndex = pageIndex;
	}

	public List<T> getList() {
		return list;
	}

	public void setList(List<T> list) {
		this.list = list;
	}

	@Override
	public String toString() {
		return "Page [pageCount=" + pageCount + ", pageSize=" + pageSize + ", totalCount=" + totalCount + ", pageIndex="
				+ pageIndex + ", list=" + list + "]";
	}

}
```

`注意：`

select count(1) from 表名   效率高于select count(*)  from 表名

### MySql分页SQL语句

- MySql中使用Limit进行分页

```sql
select ID,NAME,AGE,GENDER from T_STUDENT limit 21, 10; -- 每页显示的数据量
```

### 获取分页信息

获取分页信息

![20180206111001](http://www.znsd.com/znsd/courses/uploads/202095afa630b3fead6997cf98df5b8d/20180206111001.png)

### 分页的设置

- 分页设置的实现
  - 根据已确认的当前页，设置上页和下页
  - 根据总页数设置首页和末页

```java
protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {		
		
		// 读取页码
		String pageIndex = request.getParameter("page");
		if (pageIndex == null || "".equals(pageIndex)) { // 判断页码
			pageIndex = "1";
		}
		// 将当前页码赋值给变量进行后续的传递
		Page<Student> page = new Page<Student>(Integer.parseInt(pageIndex));
		
		StudentService studentService = new StudentServiceImpl();
		page = studentService.getPage(page);
		
		page.setPageIndex(Integer.parseInt(pageIndex));
		request.setAttribute("page", page);
		request.getRequestDispatcher("studentList.jsp").forward(request, response);
	
}
```

```java
public Page<Student> getPage(Page<Student> page) {
		
		Student student = null;
		List<Student> studentList = new ArrayList<Student>();
		
		try {
			BaseDao baseDao = new BaseDao();
			Connection conn = baseDao.getConnection();

			PreparedStatement ps = conn.prepareStatement("select * from t_student limit ?, ?");
			ps.setInt(1, page.getStart());
			ps.setInt(2, page.getPageSize());
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {

				student = new Student(rs.getInt("id"), rs.getString("name"), rs.getInt("age"), rs.getString("gender"));
				studentList.add(student);
			}
			
			page.setTotalCount(getCount());
			page.setList(studentList);
		
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return page;
	}
```

- 根据已确认的当前页，设置上页和下页
- 根据总页数设置首页和末页

```html
<tfoot>
		<tr>
			<td>
				<a href="student?page=1">首页</a>
				<c:if test="${page.pageIndex - 1 > 0}">
					<a href="student?page=${page.pageIndex - 1}">上一页</a>
				</c:if>
			</td>
			<td>
				<c:forEach var="page" begin="1" end="${page.pageCount + 1}">
					<a href="student?page=${page}" style="${param.page eq page ? 'color: red;' : ''}">${page}</a>
				</c:forEach>
			</td>
			<td>
				<c:if test="${page.pageIndex < page.pageCount + 1}">
					<a href="student?page=${page.pageIndex + 1}">下一页</a>	
				</c:if>
				<a href="student?page=${page.pageCount + 1}">尾页</a>
			</td>
		</tr>
</tfoot>
```

### 学员操作——实现学生分页显示

- 训练要点：SQL语句嵌套子查询
- 需求说明：编写代码实现首页学生的分页显示，要求能够执行首页、下一页、上一页、末页的操作，并在页面中显示总页数和当前页
- 实现思路
  1. 确定每页显示的新闻数量
  2. 编写数据库访问类，声明查询方法
  3. 编写SQL语句
  4. 编写JavaBean封装分页信息
  5. 在JSP中调用JavaBean
- 完成时间：50分钟