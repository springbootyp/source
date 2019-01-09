drop table sc;
drop table course;
drop table student;
drop table teacher;
drop table dep;

CREATE TABLE DEP
       (DNO NUMBER(2),
        DNAME VARCHAR2(30),
        DIRECTOR NUMBER(4),
        TEL   VARCHAR2(8));

CREATE TABLE TEACHER
       (TNO NUMBER(4),
        TNAME VARCHAR2(10),
        TITLE VARCHAR2(20),
        HIREDATE DATE,
        SAL NUMBER(7,2),
        BONUS  NUMBER(7,2),
   	MGR NUMBER(4),             
        DEPTNO NUMBER(2));

CREATE TABLE student
       (sno NUMBER(6),
        sname VARCHAR2(8),
        sex VARCHAR2(2),
        birth   DATE,
        passwd  VARCHAR2(8),
        dno  NUMBER(2));
        
CREATE TABLE course
       (cno VARCHAR2(8),
        cname VARCHAR2(20),
        credit NUMBER(1),
        ctime  NUMBER(2),
        quota  NUMBER(3));
        
CREATE TABLE sc
       (sno NUMBER(6),
        cno  VARCHAR2(8),
        grade NUMBER(3));        
        
alter table dep add (constraint pk_deptno primary key(dno));
alter table dep add(constraint dno_number_check check(dno>=10 and dno<=50));
alter table dep modify(tel default 62795032);
alter table student add (constraint pk_sno primary key(sno));
alter table student add(constraint sex_check check(sex='��' or sex='Ů'));
alter table student modify(birth default sysdate);
alter table course add (constraint pk_cno primary key(cno));
alter table sc add (constraint pk_key primary key(cno,sno));
alter table teacher add (constraint pk_tno primary key(tno));
alter table sc add (FOREIGN KEY(cno) REFERENCES course(cno));
alter table sc add (FOREIGN KEY(sno) REFERENCES student(sno));
alter table student add (FOREIGN KEY(dno) REFERENCES dep(dno));
alter table teacher add (FOREIGN KEY(deptno) REFERENCES dep(dno));  

INSERT INTO DEP VALUES (10, '�����ϵ', 9469 , '62785234');
INSERT INTO DEP VALUES (20,'�Զ���ϵ', 9581 , '62775234');
INSERT INTO DEP VALUES (30,'���ߵ�ϵ', 9791 , '62778932');
INSERT INTO DEP VALUES (40,'��Ϣ����ϵ', 9611, '62785520');
INSERT INTO DEP VALUES (50,'΢�ɵ���ϵ', 2031, '62797686');


INSERT INTO TEACHER VALUES(9468,'CHARLES','PROFESSOR','17-12��-2004',8000,1000,NULL,10);
INSERT INTO TEACHER VALUES(9469,'SMITH','PROFESSOR','17-12��-2004',5000,1000 ,9468,10);
INSERT INTO TEACHER VALUES(9470,'ALLEN','ASSOCIATE PROFESSOR', '20-2��-2003',4200,500,9469,10);
INSERT INTO TEACHER VALUES(9471,'WARD','LECTURER', '22-2��-2004',3000,300,9469,10);
INSERT INTO TEACHER VALUES(9581,'JONES','PROFESSOR ', '2-4��-2003',6500,1000,9468,20);
INSERT INTO TEACHER VALUES(9582,'MARTIN','ASSOCIATE PROFESSOR ','28-9��-2005',4000,800,9581,20);
INSERT INTO TEACHER VALUES(9583,'BLAKE','LECTURER ','1-5��-2006',3000,300,9581,20);
INSERT INTO TEACHER VALUES(9791,'CLARK','PROFESSO', '9-6��-2003',5500,NULL,9468,30);
INSERT INTO TEACHER VALUES(9792,'SCOTT','ASSOCIATE PROFESSOR ','09-12��-2004',4500,NULL,9791,30);
INSERT INTO TEACHER VALUES(9793,'BAGGY','LECTURER','17-11��-2004',3000,NULL,9791,30);
INSERT INTO TEACHER VALUES(9611,'TURNER','PROFESSOR ','8-9��-2005',6000,1000,9468,40);
INSERT INTO TEACHER VALUES(9612,'ADAMS','ASSOCIATE PROFESSO','12-1��-2004',4800,800,9611,40);
INSERT INTO TEACHER VALUES(9613,'JAMES','LECTURER','3-12��-2006',2800,200,9611,40);
INSERT INTO TEACHER VALUES(2031,'FORD','PROFESSOR','3-12��-2005',5500,NULL,9468,50);
INSERT INTO TEACHER VALUES(2032,'MILLER','ASSOCIATE PROFESSO','23-1��-2005',4300,NULL,2031,50);
INSERT INTO TEACHER VALUES(2033,'MIGEAL','LECTURER','23-1��-2006',2900,NULL,2031,50);
INSERT INTO TEACHER VALUES(2034,'PEGGY', 'LECTURER', '23-1��-2007',2500,NULL,2031,50);


insert into student(birth,sno,sname,sex,passwd,dno) values('01-8�� -10',1,'John','��','123456',10);
insert into student(birth,sno,sname,sex,passwd,dno) values('02-8�� -10',2,'Jacob','��','123456',10);
insert into student(birth,sno,sname,sex,passwd,dno) values('03-8�� -10',3,'Michael','��','123456',10);
insert into student(birth,sno,sname,sex,passwd,dno) values('04-8�� -10',4,'Joshua','��','123456',10);
insert into student(birth,sno,sname,sex,passwd,dno) values('05-8�� -10',5,'Ethan','��','123456',10);
insert into student(birth,sno,sname,sex,passwd,dno) values('06-8�� -10',6,'Matthew','��','123456',20);
insert into student(birth,sno,sname,sex,passwd,dno) values('07-8�� -10',7,'Daniel','��','123456',20);
insert into student(birth,sno,sname,sex,passwd,dno) values('08-8�� -10',8,'Chris','��','123456',20);
insert into student(birth,sno,sname,sex,passwd,dno) values('09-8�� -10',9,'Andrew','��','123456',30);
insert into student(birth,sno,sname,sex,passwd,dno) values('10-8�� -10',10,'Anthony','��','123456',30);
insert into student(birth,sno,sname,sex,passwd,dno) values('11-8�� -10',11,'William','��','123456',30);
insert into student(birth,sno,sname,sex,passwd,dno) values('12-8�� -10',12,'Joseph','��','123456',40);
insert into student(birth,sno,sname,sex,passwd,dno) values('13-8�� -10',13,'Alex','��','123456',40);
insert into student(birth,sno,sname,sex,passwd,dno) values('14-8�� -10',14,'David','��','123456',40);
insert into student(birth,sno,sname,sex,passwd,dno) values('15-8�� -10',15,'Ryan','��','123456',40);
insert into student(birth,sno,sname,sex,passwd,dno) values('16-8�� -10',16,'Noah','��','123456',40);
insert into student(birth,sno,sname,sex,passwd,dno) values('17-8�� -10',17,'James','��','123456',40);
insert into student(birth,sno,sname,sex,passwd,dno) values('18-8�� -10',18,'Nicholas','��','123456',50);
insert into student(birth,sno,sname,sex,passwd,dno) values('19-8�� -10',19,'Tyler','��','123456',50);
insert into student(birth,sno,sname,sex,passwd,dno) values('20-8�� -10',20,'Logan','��','123456',50);
insert into student(birth,sno,sname,sex,passwd,dno) values('21-8�� -10',21,'Emily','Ů','123456',10);
insert into student(birth,sno,sname,sex,passwd,dno) values('22-8�� -10',22,'Emma','Ů','123456',10);
insert into student(birth,sno,sname,sex,passwd,dno) values('23-8�� -10',23,'Madis','Ů','123456',10);
insert into student(birth,sno,sname,sex,passwd,dno) values('24-8�� -10',24,'Isabe','Ů','123456',10);
insert into student(birth,sno,sname,sex,passwd,dno) values('25-8�� -10',25,'Ava','Ů','123456',10);
insert into student(birth,sno,sname,sex,passwd,dno) values('26-8�� -10',26,'Abigail','Ů','123456',20);
insert into student(birth,sno,sname,sex,passwd,dno) values('27-8�� -10',27,'Olivia','Ů','123456',20);
insert into student(birth,sno,sname,sex,passwd,dno) values('28-8�� -10',28,'Hannah','Ů','123456',20);
insert into student(birth,sno,sname,sex,passwd,dno) values('29-8�� -10',29,'Sophia','Ů','123456',30);
insert into student(birth,sno,sname,sex,passwd,dno) values('30-8�� -10',30,'Samant','Ů','123456',30);
insert into student(birth,sno,sname,sex,passwd,dno) values('31-8�� -10',31,'Elizab','Ů','123456',30);
insert into student(birth,sno,sname,sex,passwd,dno) values('01-7�� -10',32,'Ashley','Ů','123456',40);
insert into student(birth,sno,sname,sex,passwd,dno) values('02-7�� -10',33,'Mia','Ů','123456',40);
insert into student(birth,sno,sname,sex,passwd,dno) values('11-8�� -10',34,'Alexis','Ů','123456',40);
insert into student(birth,sno,sname,sex,passwd,dno) values('12-8�� -10',35,'Sarah','Ů','123456',40);
insert into student(birth,sno,sname,sex,passwd,dno) values('13-8�� -10',36,'Natalie','Ů','123456',40);
insert into student(birth,sno,sname,sex,passwd,dno) values('14-8�� -10',37,'Grace','Ů','123456',40);
insert into student(birth,sno,sname,sex,passwd,dno) values('15-8�� -10',38,'Chloe','Ů','123456',50);
insert into student(birth,sno,sname,sex,passwd,dno) values('16-8�� -10',39,'Alyssa','Ů','123456',50);
insert into student(birth,sno,sname,sex,passwd,dno) values('17-8�� -10',40,'Brianna','Ů','123456',50);         


insert into course values('c001','���ݽṹ',3,10,100);
insert into course values('c002','Java����',2,20,100);
insert into course values('c003','���ֵ�·',3,30,100);
insert into course values('c004','ģ���·',3,40,100);
insert into course values('c005','�ź���ϵͳ',4,50,100);
insert into course values('c006','C����',3,60,100);
insert into course values('c007','�ߵ���ѧ',5,70,100);
insert into course values('c008','�Զ�ԭ��',1,80,100);
insert into course values('c009','������',3,90,100);
insert into course values('c010','��ѧ����',2,61,100);
insert into course values('c011','��е��ͼ',3,52,100);
insert into course values('c012','΢��ԭ��',3,43,100);
insert into course values('c013','ͨ�Ż���',3,74,100);
insert into course values('c014','�����ԭ��',5,35,100);
insert into course values('c015','���ݿ�',3,86,100);
insert into course values('c016','����ԭ��',2,97,100);
insert into course values('c017','��ѧ����',2,38,100);
insert into course values('c018','ͳ�ƻ���',4,50,100);
insert into course values('c019','���Դ���',4,70,100);
insert into course values('c020','Linux����',3,60,100);



insert into sc values(6,'c002',60);
insert into sc values(6,'c015',60);
insert into sc values(6,'c010',61);
insert into sc values(27,'c010',65);
insert into sc values(6,'c001',60);
insert into sc values(6,'c011',61);
insert into sc values(6,'c018',70);
insert into sc values(8,'c007',65);
insert into sc values(27,'c020',65);
insert into sc values(27,'c015',65);       
insert into sc values(26,'c015',55);   
insert into sc values(25,'c015',59);      
insert into sc values(1,'c017',65);
insert into sc values(2,'c017',66);
insert into sc values(3,'c017',67);
insert into sc values(4,'c017',68);
insert into sc values(5,'c017',69);
insert into sc values(6,'c017',70);
insert into sc values(7,'c017',71);
insert into sc values(8,'c017',72);
insert into sc values(9,'c017',73);
insert into sc values(10,'c017',74);
insert into sc values(11,'c017',75);
insert into sc values(12,'c017',76);
insert into sc values(13,'c017',77);
insert into sc values(14,'c017',78);
insert into sc values(15,'c017',79);
insert into sc values(16,'c017',80);
insert into sc values(17,'c017',81);
insert into sc values(18,'c017',82);
insert into sc values(19,'c017',83);
insert into sc values(20,'c017',84);
insert into sc values(21,'c017',85);
insert into sc values(22,'c017',86);
insert into sc values(23,'c017',87);
insert into sc values(24,'c017',88);
insert into sc values(25,'c017',89);
insert into sc values(26,'c017',90);
insert into sc values(27,'c017',89);
insert into sc values(28,'c017',88);
insert into sc values(29,'c017',87);
insert into sc values(30,'c017',86);
insert into sc values(31,'c017',85);
insert into sc values(32,'c017',84);
insert into sc values(33,'c017',83);
insert into sc values(34,'c017',82);
insert into sc values(35,'c017',81);
insert into sc values(36,'c017',80);
insert into sc values(37,'c017',79);
insert into sc values(38,'c017',78);
insert into sc values(39,'c017',77);
insert into sc values(40,'c017',76);
commit;