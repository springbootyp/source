# Oracle-DML&DDL

​	SQL语言共分为四大类:

* 数据查询语言DQL(Data query language)
* 数据操纵语言DML(Data Manipulation Language)
* 数据定义语言DDL(Data Definition Language)
* 数据控制语句DCL(Data Control Language)

​		

##### DML

* INSERT

  ```sql
  INSERT INTO 表（列1 ，列2 …） VALUES （表达式1 ，表达式2 .. ) ;
  INSERT INTO 表1 （列1 ，列2 …） SELECT 列1 ，列2 ••• FROM 表2 WHERE 
  ```

* DELETE 

  ```sql
  DELETE FROM 表名称 WHERE 条件;
  ```

* UPDATE 

  ```sql
  UPDATE 表名称 SET 列名称=表达式1, 列名称=表达式2 WHERE 条件;
  UPDATE 表名称 SET (列1，列2)=（值1、值2） WHERE 条件;
  ```

##### DDL

* Create

  ```sql
  create index upp_name_index  on t_user (upper(name));
  CREATE TABLE [schema.]table_name...
  ```

* Drop

  ```sql
  drop index user_name_index;
  drop table table_name
  ```

* Alter

  ```sql
  alter table t_user add (age number(2));
  alter index user_name_index rebuild;
  ```

##### DCL

* Grant

  ```sql
  grant create table to user;
  
  CREATE SESSION 连接到数据库上
  CREATE SEQUENCE 创建序列，序列是一系列数字，通常用来自动填充主键列
  CREATE SYNONYM　　 创建同名对象
  CREATE TABLE　　创建表
  CREATE ANY TABLE 在任何模式中创建表
  DROP TABLE 删除表
  DROP ANY TABLE 　　 删除任何模式中的表
  CREATE PROCEDURE 创建存储过程
  EXECUTE ANY PROCEDURE 执行任何模式中的存储过程
  CREATE USER 创建用户
  DROP USER　　　删除用户
  CREATE VIEW 创建视
  
  ```

* Revoke

  ```sql
  revoke create table from user;
  ```

##### DQL

* select

  * 对数值型数据列、变量、常量可以使用算数操作符创建表达式（+、-、*、/、%）
  * 对日期型数据列、变量、常量可以使用部分算数操作符创建表达式（+ -）
  * 运算符不仅可以在列和常量之间进行运算，也可以在多列之间进行运算
  * 乘法和除法的优先级高于加法和减法
  * 同级运算的顺序是从左到右
  * 表达式中使用括号可强行改变优先级的运算顺序

  ```sql
  -- 基本语法
  SELECT{*, column [alias],...} FROM table;
  -- 字符串的连接操作符
  SELECT last_name || ‘work at ’|| job_id FROM employees;
  -- 取别名
  select last_name as "姓名" from employees;
  -- DISTINCT
  SELECT DISTINCT department_id FROM employees;
  -- 限制条件
  SELECT [DISTINCT] {*, column [alias], ...} FROM table [WHERE condition];
  -- BETWEEN and
  SELECT last_name, salary FROM employees WHERE salary BETWEEN 1000 AND 1500;
  -- IN
  SELECT employee_id,last_name FROM employees WHERE manager_id IN (7902, 7566, 7788);
  -- LIKE:(%)可表示零或多个字符,( _ ) 可表示一个字符
  SELECT last_name FROM employees WHERE last_name LIKE '_A%';
  -- IS NULL
  SELECT last_name, manager_id FROM employees WHERE manager_id IS NULL;
  ```

* 逻辑运算符

  * AND:如果组合条件都是TRUE,结果为TRUE

    ```sql
    SELECT employee_id, last_name, job_id, salary FROM employees
    WHERE salary>=1100 AND job_id='CLERK'
    ```

  * OR:如果组合条件一边是TRUE，结果为TRUE

    ```sql
    SELECT employee_id, last_name, job_id, salary FROM employees
    WHERE salary>=1100 OR job_id='CLERK'
    ```

  * NOT:如果条件为FALSE,结果为TRUE

    ```sql
    SELECT last_name, job_id FROM employees
    WHERE job_id NOT IN ('CLERK','MANAGER','ANALYST');
    ```

* 排序

  * order by

    ```sql
    -- asc:升序，desc：降序
    select last_name, job_id from emp order by last_name asc,job_id desc
    ```

* 聚合函数

  * COUNT(*|列名)：统计行数

    ```sql
    select count(1) from emp;
    ```

  * AVG(数值型列名）：平均值

    ```sql
    select avg(salary) from emp;
    ```

  * SUM(数值型列名）：求和

    ```sql
    select sum(salary) from emp;
    ```

  * MAX（列名）：最大值

    ```sql
    select max(salary) from emp;
    ```

  * MIN（列名）：最小值

    ```sql
    select min(salary) from emp;
    ```

* GROUP BY

  * 把该列具有相同值的多条记录当成一组记录处理，最后只输出一条记录

  * 结果集隐式按升序排列,如果需要改变排序方式可以使用Order by 子句

    ```sql
    SELECT column, group_function FROM table
    [WHERE condition]
    [GROUP BY group_by_expression]
    [ORDER BY column];
    e.g:
    	SELECT deptno,AVG(sal) FROM TB_EMP GROUP BY deptno;
    ```

  * HAVING子句

    * HAVING子句用来对分组后的结果再进行条件过滤
    * where和having都是用来做条件限定的,但是having只能用在group by之后
    * WHERE是在分组前进行条件过滤， HAVING子句是在分组后进行条件过滤，WHERE子句中不能使用聚合函数，HAVING子句可以使用聚合函数

    ```sql
    SELECT column, group_function
    FROM table
    [WHERE condition]
    [GROUP BY group_by_expression]
    [HAVING group_condition]
    [ORDER BY column];
    e.g:
    	SELECT deptno,AVG(sal) FROM TB_EMP GROUP BY deptno having AVG(sal)>100;
    ```

* 多表联查

  * 笛卡尔连接

    *   笛卡尔乘积是指在数学中，两个集合X和Y的笛卡尓积（Cartesian product），又称直积，表示为X×Y，第一个对象是X的成员而第二个对象是Y的所有可能有序对的其中一个成员

    * 假设有两个集合，A={1,2},b={a,b,c},那么它们组合匹配的可能性有：｛(1,a),(1,b),(1,c),(2,a),(2,b),(2,c)｝,这就是它们的笛卡尔积。

    * CROSS JOIN：CROSS JOIN产生了一个笛卡尔积（Cartesian product），就象是在连接两个表格时忘记加入一个WHERE子句一样

      ```sql
      SELECT ename,loc FROM emp CROSS JOIN dept;
      -- 等价于
      SELECT ename,loc FROM emp，dept;
      ```

  * 内连接（等值连接）

    * 两个表（或连接）中某一数据项相等的连接称为内连接。内连接的方式是在“设置表间关联关系”的界面中选择“=”，所以内连接又称为等值连接。连接的结果是形成一个新的数据表
    * 内连接中参与连接的表（或连接）的地位是相等的。内连接的运算顺序是：
      * 参与的数据表（或连接）中的每列与其它数据表（或连接）的列相匹配，形成临时数据表
      * 将满足数据项相等的记录从临时数据表中选择出来

    ```sql
    select * from t_user t,t_dept d where t.dept_id = d.id;
    ```

  * 外连接

    * 左外连接

      * left outer join 或者 left join

      * 左外连接就是在等值连接的基础上加上主表中的未匹配数据

        ```sql
        select * from t_user t left outer join t_dept d on t.dept_id = d.id;
        -- 等价于
        select * from t_user t , t_dept d where t.dept_id = d.id(+);
        -- + 号在右边, 以左边为准, 右边补齐
        ```

    * 右外连接

      * right outer join 或者 right join

      * 右外连接是在等值连接的基础上加上被连接表的不匹配数据

        ```sql
        -- + 号在左边, 以右边为准, 左边补齐
        select * from t_user t , t_dept d where t.dept_id(+) = d.id;
        -- 等价于
        select * from t_user t right join t_dept d on t.dept_id = d.id;
        ```

    * 全外连接

      * full outer join 或者 full join

      * 全外连接是在等值连接的基础上将左表和右表的未匹配数据都加上

        ```sql
        select * from t_user t full join t_dept d on t.dept_id = d.id;
        ```

    * 关于使用（+）的一些注意事项

      * （+）操作符只能出现在where子句中，并且不能与outer join语法同时使用
      * 当使用（+）操作符执行外连接时，如果在where子句中包含有多个条件，则必须在所有条件中都包含（+）操作符
      * （+）操作符只适用于列，而不能用在表达式上
      * （+）操作符不能与or和in操作符一起使用
      * （+）操作符只能用于实现左外连接和右外连接，而不能用于实现完全外连接

  * UNION

    * UNION 指令的目的是将两个 SQL 语句的结果合并起来

    * 两个 SQL 语句所产生的栏位需要是同样的（两段sql所查询的列必须一致）

      ```sql
      select * from t_user t left join t_dept d on t.dept_id = d.id
      union
      select * from t_user t right join t_dept d on t.dept_id = d.id
      ```

    * UNION ALL

      * UNION ALL 和 UNION 不同之处在于 UNION ALL 会将每一笔符合条件的资料都列出来，无论资料值有无重复

        ```sql
        select * from t_user t left join t_dept d on t.dept_id = d.id
        union all
        select * from t_user t right join t_dept d on t.dept_id = d.id
        ```

  * INTERSECT

    * 与union相反，取两段sql的交集内容

      ```sql
       select * from t_user t left join t_dept d on t.dept_id = d.id
       INTERSECT
       select * from t_user t right join t_dept d on t.dept_id = d.id
      ```

* 子查询(嵌套查询)

  * 所谓子查询，即一个select语句中嵌套了另外的一个或者多个select语句,嵌套查询先执行，然后将结果传递给主查询

  * 单行子查询:向外部返回的结果为空或者返回一行

    ```sql
    select * from t_user t where t.dept_id =(select d.id from t_dept d where d.name='17H1')
    ```

  * 多行子查询:向外部返回的结果为空、一行、或者多行

    * IN:与列表中的任一成员相等
    * ANY:与子查询返回的每一个值比较
    * ALL:与子查询返回的所有值比较

    ```sql
    select * from t_user t where t.dept_id in (select d.id from t_dept d where d.name='17H1');
    -- 使用any/all时，加上算数操作符一起使用
    select * from t_user t where t.dept_id =ANY (select d.id from t_dept d where d.name='17H1');
    ```
