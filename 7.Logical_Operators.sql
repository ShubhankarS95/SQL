-- ## Logical Operators:
--  If we want to define more than 1 condition in the where condition, we can use logical operator to combine multiple condition.
--  We can use AND or OR Logical Operator accordingly.
--  AND Operator displays the records if both the condition is true.
--  OR Operator displays the records if any of the condition is true. 

-- 1. List all the employee who are clerk and earns atleast 1000 salary.

select * from emp where job='CLERK' and sal>=1000;

-- 2. List all employee who are either CLERK or Not CLERK but getting salary more than 3000 

select * from emp where job='CLERK' or sal>=3000;

-- 3. You can also Use OR to write query on multiple condition on same Column 
-- List all the employees who are either CLERK or ANALYST 

select * from emp where JOB='CLERK' OR JOB="ANALYST"; 

-- What is the output of the below code 

select * from emp where JOB='CLERK' AND JOB="ANALYST"; 

-- No result as we don't have any emp whose job is both CLERK and ANALYST. 

--  4. List all employees who belongs to dept number 10 or 20 

select * from emp where deptno = 10 or deptno =20;



-- Special Operators: 
-- 1. In, Not in 
-- 2. Between, not Between 
-- 3. Is null, is not null 
-- 4. Like, not Like 

-- In: It is used to specify the list of values that we wish to pick from. Instead of using multiple OR operator to specify multiple values,
--  use in and provide all the values in the range. 
-- In performs better than multiple or 

-- 1. List all the emp who are from dept 10 or 20 

select * from emp where deptno in (10,20); 

-- 2. List all emp whose name is either SCOTT or ADAMS 

select * from emp where ename in ('SCOTT', "ADAMS");


-- While working with subqueries if subqueries returns multiple value than we must use in to catch all those values.

select * from emp where deptno in (select deptno from dept);

-- However, if your subquery returns you only 1 row, 
-- then you can use Assuming you have only 1 New York Location.
select * from emp where deptno = ( select deptno from dept where loc='NEW YORK' ); 

-- The above query would fail if there are multiple dept at New York.
 select * from emp where deptno = ( select deptno from dept limit 1 ); 
 
-- 3. Select all emp where dept number is not 10 and 20 
select * from emp where deptno not in(10,20); 

-- Note: NULL does not work with in and not in

-- 4. Select all emp who does not have MGR. 
-- The below query doesn't return you anything. 

select * from emp where mgr not in (NULL); -- doesnot work 

select * from emp where mgr in (NULL);

-- Do this instead 
select * from emp where mgr is not null; -- all employee 

select *  from emp where mgr is NULL; -- President 

-- 5. NULL does not work, when you use with other values too, in case of not in 

select * from emp where deptno not in(10,20,null); 

-- This query would not return anything. 

-- This is equivalent to below code that works. 

select * from emp where deptno!=10 and deptno!=20 and deptno is not null;

-- The below would work(would fetch not null values), as we are using it with in 
-- If you have any emp whose deptno is NULL, It doesnot fetch you that record, But it doesnot impact other values.

-- 6. NULL works with IN, But doesnot fetch NULL records. It atleast fetches other records. 
-- Modify emp table, and update any record with deptno NULL 
select from emp where deptno in (10,20,null); 

--  It is equivalent to not including NULL. Both above and below query will produce same output. 

select from emp where deptno in(10,20); 

-- If you wish to fetch the employee who belong to 10 or 20 or have NULL in the deptno, use this query. 
select from emp where deptno=10 or deptno=20 or deptno is null; 

-- What is NULL? 
-- NULL is a constant which define absence of value or an unknown value. It is used when a column does not have a value assigned.
-- NULL is not same as empty String(") or Zero (0). It is a distinct value that indicates no data. 
-- Any Expression with NULL will result in NULL. 

select 10+NULL; -- Shows [NULL]

-- 7. List name, salary, commission, salary+commission of all the employee? 
select ename, sal, comm, sal+comm as Total_Salary from emp;



-- Please note: We got total_salary as NULL for so many employees just because they don't get any commission, which indeed is wrong. 
-- To overcome this problem we can use IFNULL() function. 
-- IF NULL is equivalent to NVL() in Oracle. 
-- The IFNULL function allows you to substitute a value when a NULL is encountered.
--  It takes two arguments: 
--    if the first argument is NULL, it returns the second argument; 
--    otherwise, it returns the first argument.

--  Syntax: IF NULL(expression, replacement_value) 
select IFNULL(null, 0); -- 0,retums 2nd argument as 1st is NULL 

select IFNULL(10,20); -- 10, returns 1st argument as it is not NULL

-- Lets try to find the salary of the employee now 
 select ename,sal.comm,IFNULL(sal+comm,sal) as Total Salary from emp;
-- Or 
select ename, sal, comm, sal+IFNULL(comm,0) as Total Salary from emp;

-- IF() Function: This is similar to NVL2() in Oracle. Which takes 3 parameters. 
-- If the condition is true (i.e., the expression is not NULL), it returns the second argument. 
-- If the condition is false (i.e., the expression is NULL), it returns the third argument.

--  IF(expression IS NOT NULL, value_if_not_null, value_if_null) 

select if(null, 0,10); --10 select if(10,20,30); -- 20 

select ename, sal, comm, if(sal+comm, sal+comm, sal) as Total salary from emp; 

select ename, sal, comm, IF (comm is not null, sal+comm, sal) as Total_salary from emp; 
-- Or
 select ename, salcomm,sal+if(comm, comm,0) as Total Salary from emp; 
select ename, sal, comm, sal+ IF(comm is not null, comm,0) as Total_salary from emp; 

-- Lets update commission column for all the employees who are not getting any commission.
--  Lets give a commission of 1005 
update emp set comm= IF (comm,comm, 1005); 
-- or
update emp set comm= IF(comm is not null, comm+0,1005);




-- ## BETWEEN: 
-- This Operator is used to retrieve range of values from a table column. 
-- This is also called as Between... And Operator 
-- Syntax:
--  Select * from <Table_name> WHERE <COLUMN_NAME> between <LOW_VALUE> and <HIGH VALUE> ;

-- List All employees whose salary is between 3000 and 5000. 
select * from emp where sal between 3000 and 5000;

-- Don't give High value and then low value. 
-- It will not fetch you any record select from emp where sal between 3000 and 1000;

select * from emp where ename between "A" and "C"; 
-- Note: In this case, it gives you the list of all the employees whose name starts with A or B (Not C). 
-- Similary if you say "A" to "G", it gives you all the name that starts with A, B, C, D,E,F

-- Is Null/Is Not Null
-- Can be used to check if a column is null or not null. 
update emp set comm=null where comm=1005;

Select * from emp where comm is null;
select *  from emp where comm is not null; 
select *  from emp where comm=null; -- won't work.

-- ## Like Operator:
--  It is basically used to search String based on character pattern, when you don't know the exact value. 
-- Like Operator supports 2 special characters, which are called as Wild card Characters. 
--  1. % (Percentile):
	-- Represents Group of Characters you want to match. 
-- 2. (Underscore): 
	-- Represents a Single Character you want to match Syntax: 
	
-- Select * from <Table_Name> where <Column_Name> like 'Pattern Here'; 

-- 1. List all employees whose name starts with A 
select *  from emp where ename like 'A%';


-- 2. List all employess whose name starts with A followed by 4 characters.
--  Those 4 characters can be anything
select *  from emp where ename like 'A____'; -- 4 underscore

--  3. List all employees whose name 2nd character is A 

select * from emp where ename like '_A%'; 

-- 4. List all employees whose name 3rd character is A.
--  Note: We have used 2_ here. 
select *  from emp where ename like '__A%'; 

-- 5. List all employees who have joined in December 
select * from emp where hiredate like '____-12%';

-- 6. List all employees who have joined in the year 1981 
select *  from emp where hiredate like '1981%' 

-- 7. You can also use escape character if your data itself contains % and_ 

insert into emp(empno, ename) values (2001,"S_GHIMIRE");

select * from emp where ename like 'S%';

-- If you wish to get S_GHIMIRE only. 
select * from emp where ename like 'S?_%' escape '?'; 

-- Note: ? is not a fixed character here and it is just a place holder. You could have used any other character instead as shown below.
select * from emp where ename like 'S*_%' escape "*"; 

select * from emp where ename like 'S/%' escape '/';

insert into emp(empno, ename) values (2002, "S__GHIMIRE");


select * from emp where ename like 'S/_%' escape '/'; 

-- Gives both record S_GHIMIRE, S_GHIMIRE 

-- The below code gives you only 1 record S__GHIMIRE 
select * from emp where ename like 'S?_?_%' escape '?'; 
select * from emp where ename like 'S* * %' escape '*'; 

insert into emp(empno, ename) values (2003,"S_%GHIMIRE");

select * from emp where ename like 'S*_*%%' escape '*'; 
-- This will escape both _ and %. Second % will not be escaped.


