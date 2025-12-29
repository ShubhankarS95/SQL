-- Data types in My SQL 

-- BLOB 							BOOL 				CHAR		 			DATE 			BIGINT 					BIGINT UNSIGNED 
-- BINARY 							BIT 				DOUBLE UNSIGNED 		ENUM 			FLOAT 					GEOMETRY 
-- GEOMETRYCOLLECTION 				INT 				INT UNSIGNED 			INTEGER 		INTEGER UNSIGNED 		DATETIME 
-- LINESTRING 						DECIMAL 			LONG VARBINARY 			DOUBLE 			LONG VARCHAR 			DOUBLE PRECISION 
-- LONGBLOB 						LONGTEXT 			MEDIUMBLOB 				TEXT 			MEDIUMINT 				TIME
-- DOUBLE PRECISION unsigned   	TIMESTAMP			MEDIUMTEXT 			MULTILINESTRING 	MULTIPOINT 				TINYINT  	
-- MEDIUMINT UNSIGNED 				MULTIPOLYGON 		NUMERIC 				POINT 			POLYGON 				REAL 
-- SET 							SMALLINT 			SMALLINT UNSIGNED 		YEAR 			json 				TINYBLOB 
-- TINYINT UNSIGNED 				TINYTEXT 			VARBINARY 				VARCHAR

-- ## Categories:
-- # Date and Time 
-- Date 							DateTime 			Time 			TimeStamp 		year

-- Integer Type: 
-- TinyInt 			TinyInt Unsigned 		Int 		Int Unsigned 		BigInt 					BigInt Unsigned


-- Datatype 				Description 
-- * CHAR(Size) 		   Default is 1 
-- 					Fixed length string,
-- 				   can contain letters, numbers, special characters Size-total number of characters allowed, 
-- 				   can be from 0 to 255.
-- * VARCHAR(Size) 		Default is 1 
-- 					A variable length String. 
-- 					can contain letters, numbers, special characters 
-- 					Size-Maximum number of characters allowed 
-- 					Length can be from 0 to 65535 
-- * BINARY(Size) 	Default is 1 
-- 				Similar to CHAR, but stores binary byte strings. 
-- 				
-- * VARBINARY(Size)	   Similar to VARCHAR, but stores binary byte Strings.
-- 		 T			The size defines the maximum column length in byte 
-- * tinyblob   			Used to store Binary Large Objects. Max length:255 characters 
-- * MEDIUMBLOB 		For BLOBS (Binary Large Objects). Holds up to 16,777,215 bytes of data 
-- * BLOB(Size)		 For Binary Large Objects. Holds upto 65535 bytes of Data 
-- * LONGBLOB 		For BLOBS (Binary Large Objects). Holds up to 4,294,967,295 bytes of data 
-- * TINYTEXT 		Holds a String with a maximum length of 255 Characters 
-- * MEDIUMTEXT 		Holds a string with a maximum length of 16,777,215 characters 	
-- * TEXT(size) 		Stores String with a maximum length=65535 bytes 
-- * LONGTEXT 		Holds a string with a maximum length of 4,294,967,295 characters
-- * ENUM(val1, val2, val3, ...) 	A string object that can have only one value, chosen from a list of possible values 
-- 								You can list upto 65535 values in an ENUM List. 
-- 								If a value is inserted that is not in the list, a blank value will be inserted. 
-- 								The values are sorted in the order you enter them
-- * SET(val1, val2, val3, ...)		 A string object that can have 0 or more values, chosen from a list of possible values. 
-- 									You can list up to 64 values in a SET list


-- ## Operator used in select Statement 
-- 1. Arithmetic Operator (+,-,*,/)
-- 2. Relational Operator =,<,<=,>,>=, (!=, <>) Not equal to 
-- 3. Logical Operator (AND, OR, NOT) 
-- 4. Select Operator 
-- 	a. in, between, is null, like 
-- 	b. not in, not between, is not null, not like
	
	
-- ## Lets create Table before we start exploring the operators 
create table dept( 
deptno int,
dname text,
loc text,
constraint pk_dept primary key (deptno) 
);

create table emp(
empno int,
ename text,
job text,
mgr int,
hiredate date,
sal float(7,2),
comm int,
deptno int,
constraint pk_emp primary key (empno),
constraint fk_deptno foreign key (deptno) references dept (deptno)
);

-- Insert Records in Dept First: 
insert into DEPT (DEPTNO, DNAME, LOC) 
values (10, 'ACCOUNTING', 'NEW YORK'); 

insert into dept 
values (20, 'RESEARCH', 'DALLAS'); 

insert into dept 
values (30, 'SALES', 'CHICAGO'),
(40, 'OPERATIONS', 'BOSTON');


-- Insert into Employee: 
insert into emp
values( 7839, 'KING', 'PRESIDENT', null, STR_TO_DATE('17-11-1981','%d-%m-%Y'), 5000, null, 10 );

insert into emp 
values( 7698, 'BLAKE', 'MANAGER', 7839, STR_TO_DATE('1-5-1981','%d-%m-%Y'), 2850, null, 30 ); 

insert into emp 
values( 7782, 'CLARK', 'MANAGER', 7839, STR_TO_DATE('9-6-1981','%d-%m-%Y'), 2450, null, 10 );

insert into emp 
values( 7566, 'JONES', 'MANAGER', 7839, STR_TO_DATE('2-4-1981','%d-%m-%Y'), 2975, null, 20 ); 

insert into emp 
values( 7788, 'SCOTT', 'ANALYST', 7566, STR_TO_DATE('13-7-1987','%d-%m-%Y'), 3000, null, 20 ); 

insert into emp
values( 7902, 'FORD', 'ANALYST', 7566, STR_TO_DATE('3-12-1981','%d-%m-%Y'), 3000, null, 20 ); 

insert into emp 
values( 7369, 'SMITH', 'CLERK', 7902, STR_TO_DATE('17-12-1980','%d-%m-%Y'), 800, null, 20 );



insert into emp 
values( 7499, 'ALLEN', 'SALESMAN', 7698, STR_TO_DATE('20-2-1981','%d-%m-%Y'), 1600, 300, 30 ); 

insert into emp
values( 7521, 'WARD', 'SALESMAN', 7698, STR_TO_DATE('22-2-1981','%d-%m-%Y'), 1250, 500, 30 ); 

insert into emp 
values(7654, 'MARTIN', 'SALESMAN', 7698, STR_TO_DATE('28-9-1981','%d-%m-%Y'), 1250, 1400, 30);

insert into emp 
values( 7844, 'TURNER', 'SALESMAN', 7698, STR_TO_DATE('8-9-1981','%d-%m-%Y'), 1500, 0, 30 ); 

insert into emp 
values( 7876, 'ADAMS', 'CLERK', 7788, STR_TO_DATE('13-5-1987', '%d-%m-%Y'), 1100, null, 20 ); 

insert into emp
values( 7900, 'JAMES', 'CLERK', 7698, STR_TO_DATE('3-12-1981','%d-%m-%Y'), 950, null, 30 );

insert into emp 
values( 7934, 'MILLER', 'CLERK', 7782, STR_TO_DATE('23-1-1982','%d-%m-%Y'), 1300, null, 10 );



-- ## Arithmetic Operators:
--	 	Used in numeric datatype column
-- 		Arithmetic operator is used with select statement.
-- 		Relational, logical, special operator are used with Where condition.
-- 		Arithmetic operators can also be used with where condition. 

-- 1. Display name, salary, annual salary of employee. 
Select ename, sal, sal*12 from emp; 
Select ename, sal, sal*12 as annual salary from emp; 
Select ename, sal, sal*12 annual_salary from emp;
## Wrong Practice, Use to separate the words

select ename, sal, sal*12 'annual salary' from emp;

-- 2. List all the employees name, salary, annual_salary who is earning more than 30000 annually 

Select ename,sal,sal*12 annual salary from emp where sal*12 > 30000 ;

-- You cannot use column alias in the where clause. The below code will fail 
Select ename, sal, sal*12 annual salary from emp where annual_salary > 30000;


--  You can however use it in inner query 
select * from ( select ename, sal, sal*12 as annual_salary from emp De where e.annual_salary>30000;

-- 3. Give a hike of 20% to all the employees. Donot update the data, Just fetch the data with hike. 
select ename, sal, sal*1.2 as new salary from emp;


--##  Relational Operator: 
-- We can use this operator in where clause only.
-- 1. List all employee who are clerk 
select from emp where job ='CLERK'; 

-- 2. List all employee who are not clerk 
Select from emp where job!='CLERK'; 
Select from emp where job > 'CLERK'; 

-- 3. List all employee earning more than 2000 salary. 

Select from emp where sal>2000 ;

-- 4. List all employees earning less than or equal to 2000 
select from emp where sal <= 2000;
