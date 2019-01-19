## 第六章    Hibernate注解 

### 本章任务

- 使用注解重构学生系统

### 本章目标 

- 学会使用Hibernate注解`难点`

### 什么是注解 

- 什么是JPA注解：JPA(Java Persistence API)是Sun官方提出的Java持久化规范。它为Java开发人员提供了一种对象关系映射工具来管理Java应用中的关系数据，而Hibernate是它的一种实现。 
- 使用注解的目的：为了简化繁琐的ORM映射文件（*.hbm.xml)的配置。提高开发效率。

### Hibernate注解的分类 

- 类级别的注解 
  - @Entity
  - @Table
- 属性级别的注解 
  - @Id
  - @Column
  - @Transient
- 映射文件的注解 
  - @OneToMany
  - @ManyToOne

### 使用注解的准备工作 

使用Hibernate注解的步骤如下： 

- 添加jar包
- 使用注解配置持久化类以及对象关联关系
- 使用AnnotationConfiguration建立SessionFactory
- 在Hibernate配置文件（hibernate.cfg.xml）中声明持久化类

### 注解—配置持久化类 

常用持久化类注解

| 注解            | 含义和作用                 |
| --------------- | -------------------------- |
| @Entity         | 将一个类声明为一个持久化类 |
| @Id             | 声明了持久化类的标识属性   |
| @GeneratedValue | 定义标识属性值的生成策略   |
| @Table          | 为持久化类映射指定表       |
| @Column         | 将属性映射到列（字段）     |
| @Transient      | 将忽略这些属性             |



#### @Entity 

- @Entity：映射实体类 
  - @Entity(name=" tablename ")
  - name:可选，对应数据库的一个表，若表名和实体类相同，则可以省略。
- `注意`：使用@Entity属性必须指定实体类的主键属性

#### @Table 

@Table：生成对应的数据库表 

- @Table(name=""，catalog="“,scheme="")
- @Entity配合使用，只能标注在实体class处，表示实体对应的数据库表的信息。
- name:可选，映射表的名称，默认表名和实体类名一致，只有在不一致的情况下才需要指定表的名称。
- catalog:可选，表示Catalog名称，默认为Catalog("");
- schema:可选，表示Schema名称，默认为schema("");

#### @Id  

- @Id：生成主键
- @GeneratedValue：主键生成策略 
- @GeneratedValue(strategy=GeneratedType,generator="") 
- strategy：对应的值有： 
  - AUTO：根据底层数据库自动选择（默认）
  - INDENTITY:支持自动编号的数据库。
  - SEQUENCE:支持序列的数据库。
  - 手工赋值：注意：MySql中字符串作为主键不能太长

```java
@Id
@GeneratedValue(generator = "id")
@GenericGenerator(name = "id", strategy = "assigned")
@Column(length = 8)
private Integer id;
```



#### @Column 

@Column：将实体属性映射到数据库表中的字段。 

- 常用属性：
- name：可选，数据库中该字段的名称，默认与属性名相同
- nullable：可选，表示该字段是否为null，默认为true。
- unique：可选，表示该字段是否是唯一值，默认为false。
- length：可选，指定字符串的长度，默认为255。
- insertable：可选，表示ORM框架插入数据时，是否忽略该字段。默认为true。
- updateable：可选，表示ORM框架更新数据时，是否忽略该字段。默认为true。

#### @Transient 

- @Transient：表示该字段是否被映射到数据库表中，如果一个字段不想将它映射到数据库的表中，请务必将其标记为Transient，否则默认为@Basic。

#### 注解—配置命名查询

使用注解可以配置命名查询。配置命名查询的注解为@NamedQuery 

```java
@Entity //标记为 数据库表
@Table(name = "t_student") // 指定该实体类映射的对应的数据库表名  
@NamedQuery(name = "selectStudent", query = "from Student where name like :name")
public class Student implements Serializable {
    @Id
	@GeneratedValue(generator = "id")
	@GenericGenerator(name = "id", strategy = "assigned")
	@Column(length = 8)
	private Integer id;
	private String name;
	private Integer age;
	private String gender;
}
```

```java
@Test
public void testQuery() {
	Session session = this.sessionFactory.openSession();
	// 测试命名查询
	Query query = session.getNamedQuery("selectStudent").setParameter("name", "%张%");
	List<Student> list = query.list();
	for (int i = 0; i < list.size(); i++) {
		System.out.println(list.get(i));
	}
}
```

### 注解—配置关联关系

| 注解        | 含义和作用                       |
| ----------- | -------------------------------- |
| @OneToOne   | 建立持久化类之间的一对一关联关系 |
| @OneToMany  | 建立持久化类之间的一对多关联关系 |
| @ManyToOne  | 建立持久化类之间的多对一关联关系 |
| @ManyToMany | 建立持久化类之间的多对多关联关系 |



#### @OneToOne 

- 单向一对一外键关联，（一个学生对应一个身份证） 
- @OneToOne(cascade=CascadeType.All) 
- @JoinColumn(name="cid",unique=true) 
- 注意：保存时，先保存外键对象，再保存主表对象 

```java
/**
 * 学生实体类
 * @author Administrator
 */
@Entity
@Table(name = "student")
public class Student implements Serializable {
	private Integer id;
	private Integer age;
	private String gender;

	private IdCard idCard; // 关联的身份证对象
    
    @Id
	@GeneratedValue
	public Integer getId() {
		return id;
	}
    
    @OneToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "cid", unique = true)
	public IdCard getIdCard() {
		return idCard;
	}
    // ... 忽悠其他set、get方法
}
```

```java
/**
 * 省份证实体类
 * @author Administrator
 */
@Entity
@Table(name = "idcard")
public class IdCard implements Serializable {
	@Id
	@GeneratedValue(generator = "cardId")
	@GenericGenerator(name = "cardId", strategy = "assigned")
	@Column(length = 18)
	private String cardId;
	private String name;
    // 忽略set、get方法
}
```

```java
@Test
public void testAdd() {
    Session session = this.sessionFactory.openSession();
    Transaction ts = session.getTransaction();
    try {
        ts.begin();
        IdCard card = new IdCard();
        card.setCardId("431103199006163216");
        card.setName("6");
        session.save(card);

        Student student = new Student();
        student.setAge(22);
        student.setGender("1");
        student.setIdCard(card);
        
        session.save(student);
        ts.commit();
    } catch (Exception e) {
        ts.rollback();
        e.printStackTrace();
    }
}
```

- 双向一对一外键关联，（身份证中也包含对学生的引用） 
- @OneToOne(mappedBy="card") 
- `注意`：双向关联，必须设置mappedBy属性，因为双向关联只能交给一方去维护，不能在两边都设置外键关联，否则双方都无法保存。

```java
@OneToOne(mappedBy = "idCard")//引用学生中的card对象
private Student student; // 身份证所属学生对象

public Student getStudent() {
    return student;
}

public void setStudent(Student student) {
    this.student = student;
}
```

#### @ManyToOne 

- 单向多对一外键关联。（多个学生对应一个班级）
- @ManyToOne(cascade=CascadeType.ALL,fetch=FetchType.EAGER)
- @JoinColumn(name="cid",referencedColumnName="CID")

```java
private Clazz clazz; //学生类中添加对班级的引用

@ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
@JoinColumn(name = "classId", referencedColumnName = "id")
public Clazz getClazz() {
    return clazz;
}
```

```java
@Entity
@Table(name = "t_clazz")
public class Clazz implements Serializable {

	@Id
	@GeneratedValue
	private Integer id; // 班级号
	private String name; // 班级名称
    // 忽略set、get方法
}
```

#### @OneToMany

- 单向一对多外键关联。（一个班级对应多个学生）
- @OneToMany(cascade=CascadeType.ALL,fetch=FetchType.EAGER) 
- @JoinColumn(name="cid") 

```java
@Entity
@Table(name = "t_clazz")
public class Clazz implements Serializable {
    
	@OneToMany(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
	@JoinColumn(name = "classId")
	private List<Student> studentList; //一个班级对应多个学生

	public List<Student> getStudentList() {
		return studentList;
	}

	public void setStudentList(List<Student> studentList) {
		this.studentList = studentList;
	}
}
```

#### @ManyToMany

- 单向多对多外键关系：学生和教师形成多对多的关系(多对多的关系必须借助第三张表来实现) ,

```java
@Entity
@Table(name = "student")
public class Student implements Serializable {

	private Set<Teacher> teachers = new HashSet<Teacher>(); // 添加老师关联集合

	@ManyToMany
	@JoinTable(
		name = "t_student_teacher",
		joinColumns = {@JoinColumn(name = "student_id")}, // 关联表学生列名
		inverseJoinColumns = {@JoinColumn(name = "teacher_id")} // 关联表老师列名
	)
	public Set<Teacher> getTeachers() {
		return teachers;
	}

	public void setTeachers(Set<Teacher> teachers) {
		this.teachers = teachers;
	}
    // 忽略其他代码
}
```

```java
@Entity
@Table
public class Teacher implements Serializable {

	@Id
	@GeneratedValue
	private Integer id;
	private String name;
	// 忽略set、get方法
}
```

```java
// 测试添加学生、老师关联信息
public void testAddStudent() {
 	Session session = this.sessionFactory.openSession();
    Transaction ts = session.getTransaction();
    try {
        ts.begin();
        Clazz clazz = (Clazz) session.load(Clazz.class, 4);

        Student student = new Student();
        student.setAge(33);
        student.setGender("1");
        student.setClazz(clazz);

        Teacher teacher = new Teacher();
        teacher.setName("li");

        session.save(teacher);

        Teacher teacher2 = new Teacher();
        teacher2.setName("wang");
        session.save(teacher2);

        Set<Teacher> teachers = new HashSet<Teacher>();
        teachers.add(teacher);
        teachers.add(teacher2);

        student.setTeachers(teachers);

        session.save(student);
        ts.commit();
    } catch (Exception e) {
        ts.rollback();
        e.printStackTrace();
    }   
}
```

#### @ManyToMany 

- 双向多对多外键关系：学生和教师形成多对多的关系(多对多的关系必须借助第三张表来实现) 

```java
@Entity
@Table
public class Teacher implements Serializable {

	@ManyToMany(mappedBy = "teachers") // 关联学生类中的教室集合
	private Set<Student> students = new HashSet<Student>(); // 教室对应的学生
    
    public Set<Student> getStudents() {
		return students;
	}

	public void setStudents(Set<Student> students) {
		this.students = students;
	}
}
```

```java
@Entity
@Table(name = "student")
public class Student implements Serializable {

	private Set<Teacher> teachers = new HashSet<Teacher>(); // 添加老师关联集合

	@ManyToMany
	@JoinTable(
		name = "t_student_teacher",
		joinColumns = {@JoinColumn(name = "student_id")},
		inverseJoinColumns = {@JoinColumn(name = "teacher_id")}
	)
	public Set<Teacher> getTeachers() {
		return teachers;
	}

	public void setTeachers(Set<Teacher> teachers) {
		this.teachers = teachers;
	}
}
```

### 学员操作—完成对学生信息的操作

需求说明 

- 使用注解配置街道班级、学生信息持久化类和数据表的映射
- 添加某班级的学生信息
- 查询某班级下的学生信息

### 总结 

- 什么是注解？
- 注解的好处是什么？
- 常用注解的分类？
- 映射文件的用法