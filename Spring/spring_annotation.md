Spring 自定义注解

		Java 的annotation提供的是一种类似于注释的机制，注解本身不做任何事，好比一个配置或者说一个标记。
		用于包、类型、构造方法、方法、成员变量、参数及本地变量的标记。

    程序后续可以利用java的反射机制来了解各种元素是否有何标记，针对不同的标记，作出相应的操作

spring注解的原理	

	注解就是源代码的元数据，即一种描述数据的数据。注解使用"@"符号标记，通过反射机制获取被检查方法上的注解信息，根据注解元素的值进行特定的处理



JAVA的元注解

@Target：表示该注解可以用于什么地方

可能的ElementType参数有：

- FIELD：域声明（包括enum实例）
- CONSTRUCTOR：构造器的声明
- LOCAL_VARIABLE：局部变量声明
- METHOD：方法声明
- PACKAGE：包声明
- PARAMETER：参数声明
- TYPE：类、接口（包括注解类型）或enum声明

@Retention：表示需要在什么级别保存该注解信息、定义该注解的生命周期

	可选的RetentionPolicy参数包括

- SOURCE：注解将被编译器丢弃，在编译阶段丢弃。这些注解在编译结束之后就不再有任何意义;@Override,@SuppressWarnings
- CLASS：在类加载的时候丢弃。在字节码文件的处理中有用。注解默认使用这种方式
- RUNTIME：始终不会丢弃，运行期也保留该注解，因此可以使用反射机制读取该注解的信息。我们自定义的注解通常使用这种方式

@Document：一个简单的Annotations标记注解，表示是否将注解信息添加在java文档中

@Inherited：允许子类继承父类中的注解



自定义注解：
    
    ```
    @Target(ElementType.METHOD)// 表明该注解可以使用在方法上
    @Retention(RetentionPolicy.RUNTIME) // 表示需要在远行时保存该注解信息
    public @interface MyAnno {
    	// 注解中的参数
        String value() default "";
        // 注解中的数组参数
        String[] names ;
        // 注解中的enum类型参数
        AnnoType enum type default AnnoType.A;
        // 定义AnnoType枚举类型
        public enum AnnoType {
    		A,
    		B,
    		C;
    	}
    }
    



定义注解处理器

- 通过反射获取使用注解标记的方法、字段、类，进行处理

      ```
      public class AnnoProcess {
      	// 使用自定义注解@MyAnno
      	@MyAnno(value="test"，names={"Jack","Allen"},type=AnnoType.A)
      	public void testAnn() {
      		System.out.println("test====");
      	}
      	
      	public static void main(String[] args) {
      		AnnoProcess an = new AnnoProcess();
      		an.testAnn();
      		// 获取Class中所有公开的方法或者字段或者构造方法
      		Method[] m2 = AnnoProcess.class.getDeclaredMethods();
      		
              for(Method m : m2) {
                  // 找到某个方法有使用@MyAnno注解的
              	MyAnno ma2 = m.getDeclaredAnnotation(MyAnno.class);
              	
              	if(null != ma2) {
              		System.out.println("I'm find my annotations method!==="+m.getName());
              	}
              }
              
      	}
      }

- 通过SpringAOP实现自定义注解处理
    
      ```
      @Component
      @Aspect/
      public class MyAspect {
      	@Pointcut("execution(* com.znsd.service.*.*.*(..))")
          private void pointcut() {
          }
      	@Before(value = "pointcut()")
      	public void before(JoinPoint jp) {
              // 基于springAOP可以拦截程序中所有的类、方法的执行，由此可以获取执行类或方法使用的注解
              // 如果有使用自定义注解的，可以单独进行处理
      		Method methods[] = jp.getTarget().getClass().getDeclaredMethods();
      		MyAnno ma = null;
      		for(Method m : methods) {
      			ma = m.getAnnotation(MyAnno.class);
      			if(null != ma) {
      				System.out.println("这个方法使用了@MyAnno注解==="+m);
      			}
      		}
      	}
      }