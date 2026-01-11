-- Subquery or nested query

-- Query within another QUERY is called as subquery or nested query
-- It is used to retrieve data from single or multiple tables based on more than one step process.
-- While using subquery, You cannot use inner query table columns in outer query.
 
-- Subquery is of 2 type.
-- • Non-correlated subquery: Child query is executed first, then parent query
-- • Corelated subquery: Parent query is executed first, then only child query.
 
-- Non-correlated subquery are of 4 types
-- a. Single row subquery: using =
-- b. Multiple row subquery: Using in
-- c. Multiple column subquery: Using where()
-- d. Inline view (or) subquery are using in from clause.


-- Lets prepare our data

drop table emp;
drop table dept;

CREATE TABLE dept (
deptno INT PRIMARY KEY,   -- Department Number
dname VARCHAR (14),       -- Department Name
loc VARCHAR(13)			 -- Location
);


-- Create the EMP table
CREATE TABLE emp (
empno INT PRIMARY KEY,      -- Employee Number
ename VARCHAR (10),  		-- Employee Name
job VARCHAR(9),			-- Job Title
mgr INT,					-- Manager ID (self-referential)
hiredate DATE,				-- Hire Date
sal DECIMAL(7,2),			-- Salary
comm DECIMAL(7,2),			-- Commission
deptno INT,					-- Department Number (foreign key)
FOREIGN KEY (deptno) REFERENCES dept(deptno) -- Foreign Key
);


-- Insert data into DEPT table
INSERT INTO dept (deptno, dname, loc) VALUES
(10,"ACCOUNTING", "NEW YORK"),
(20, "RESEARCH", "DALLAS"),
(30, "SALES", "CHICAGO"),
(40, "OPERATIONS", "BOSTON");


-- Insert data into EMP table :

INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) VALUES
(7839, 'KING', 'PRESIDENT', NULL, '1990-06-09', 5000.00, NULL, 10),
(7566, 'JONES', 'MANAGER', 7839, '1992-09-21', 2975.00, NULL, 20),
(7698, 'BLAKE', 'MANAGER', 7839, '1993-06-21', 2850.00, NULL, 30),
(7782, 'CLARK', 'MANAGER', 7839, '1992-05-14', 2450.00, NULL, 10),
(7788, 'SCOTT', 'ANALYST', 7566, '1996-03-05', 3000.00, NULL, 20),
(7902, 'FORD', 'ANALYST', 7566, '1997-12-05', 3000.00, NULL, 20),
(7844, 'TURNER', 'SALESMAN', 7698, '1995-06-04', 1500.00, 0.00, 30);


select * from emp;
select * from dept;



-- Find the list of all the employee who are making more than average salary of the employee.

select *  from emp where sal>=(select avg(sal) from emp);
-- avg sal = 2967.857143

-- The above one is a single row sub query as the inner query is returning a single value.
-- We use =, <, >, <, >= between operators here.

-- Find all the employees who are working in sales department from emp, dept table.

select * from emp where deptno = (select deptno from dept where dname='SALES');

-- Note: We cannot use child table columns in Parents table in case of nested query.
-- We need Joins for that.

select e. ename,d.dname from
emp e join dept d
on
e.deptno =d.deptno and d.dname ='SALES';

-- Find the Senior most employee of the organization

select * from emp where hiredate=(select min(hiredate) from emp);


-- Find all the employees who are working in the same department where SCOTT works.

select * from emp where deptno=(
select deptno from emp where ename='SCOTT');

-- Find all employees who works in the same department as SCOTT but don't show SCOTT

select * from emp where deptno=(
select deptno from emp where ename='SCOTT') and ename!="SCOTT";

-- Find all the employees who are getting more salary than the highest paid emp of dept 20

select * from emp where sal>(
select max(sal) from emp where deptno=20);

-- Find 2nd highest salary of the employee
select max(sal) from emp where sal <( select max(sal) from emp);

-- Find out 2nd highest salary, earning employee details.

select * from emp where sal = ( select max(sal) from emp where sal < ( select max(sal) from emp));

-- FIND OUT THE DEPT NAME OF THAT PERSON WHO IS EARNING THE MOST

select dname from dept where deptno=(	select deptno from emp where sal=( select max(sal) from emp));

-- GROUP BY and Single Row Subquery:
-- List all Jobs whose avg salary is more than avg salary of MANAGER

select job,avg(sal) 
from emp 
group by job
having avg(sal)> ( select avg(sal)from emp where job='MANAGER');

-- Find the job which on-average pays the Least.

SELECT job, AVG(sal) AS avg_salary
FROM emp
GROUP BY job
HAVING AVG(sal) = ( SELECT MIN(avg_salary)	FROM (
						SELECT job, AVG(sal) AS avg_salary FROM emp 
						GROUP BY job
						) AS subquery
					);



-- Find deptno with Highest number of employee

select deptno,count(*) as total_count1
from emp
group by deptno
having total_count1=
( select max(total_count) from
	 ( select deptno, count(*) as total_count from emp e
group by deptno) t
);

-- Hier archical Data
-- If we have a table with hierarchal data and if we are retrieving hierarchal data using subquery then we
-- will use different column name in subquery but those columns belong to same datatype

select * from emp where mgr=( select empno from emp where ename='KING');

-- In this case, mgr and empno are of same type.
-- The subquery is returning empno column which is being mapped with mgr column in outer query.
-- Multiple Row Subquery:
-- If subquery returning multiple values, we call those multiple row subquery.
-- If you keep the below sal in the nested query

select max(sal) from emp group by deptno;

-- This is going to return multiple output. You cannot keep it as subquery using =
select * from emp where sal=( select max(sal) from emp group by deptno);

select * from emp where sal=(select max(sal) from emp group by deptno limit 1);

-- You need to use in when subqueries returns multiple records.

select * from emp where sal in (
select max(sal) from emp group by deptno);

-- Display all employees who are supervisers to another employees.
select * from emp where empno in ( select distinct mgr from emp where mgr is not null )

-- Diplay all employees who are not managing anyone.
select * from emp where empno not in ( select ifnull (mgr,0) from emp );

-- Note: If you don't use ifull, it will return you no output as King has NULL Manager.

-- Multi Column Subquery:
-- We can also compare multiple column values of the child query with the multiple columns of the parent
-- query. This is called as Multiple column subquery.
-- We must use where condition with multiple columns in ()

select * from emp where (job, mgr) in (select job, mgr from emp where ename='SCOTT');


-- List ename, dname, sal of emp whose sal, commission matches with salary, comm of emp working in
-- DALLAS.
select ename,dname,sal from emp e join dept d
on e.deptno=d.deptno and (sal,ifnull(comm,0)) in
(select sal,ifnull (comm,0) from emp where deptno =
(select deptno from dept where loc="DALLAS"))

-- Or

select ename,dname,sal from emp e join dept d
on e.deptno=d.deptno and (sal,ifnull(comm,0)) in
(select sal, ifnull(comm,0) from
emp e join dept d
on e.deptno =d.deptno and d.loc='DALLAS')

--  Display employees who are getting maximum salary department wise.
-- The below query will produce wrong result.

update emp set sal=2850 where ename="FORD";

select * from emp where sal in ( select max(sal) as max_sal from emp group by deptno );

-- The correct Query should be
select * from emp where (deptno,sal) in (
select deptno,max(sal) max_sal from emp group by deptno )


-- Find out senior most employees dept wise ?

select deptno,ename,hiredate
from emp
WHERE (deptno,hiredate) in
 ( select deptno,min(hiredate) as early_joiner
   from emp group by deptno ) ;


-- List all employee getting more salary than the highest salary from dept 20

select * from emp where sal> ( select max(sal) from emp where deptno=20);

-- List all employees getting more salary than the lowest salary paid to dept 10 employee.

select * from emp where sal>( select min(sal) as min_salary from emp where deptno=10)


-- ALL and ANY
-- If we have a large dataset and if our subquery has max, min function, it could degrade the performance
-- of the query, as it is an aggregate function. We can use ALL and ANY to get same benefit and better
-- performance.
-- are used with subqueries to compare a value to a set of values returned by the subquery.
-- They are commonly used in conditions involving WHERE, HAVING, or SELECT.
-- ALL Keyword
-- • Compares a value to every value in a list or subquery.
-- • The condition must hold true for all values in the subquery.

SELECT ename, sal
FROM emp
WHERE sal > ALL (SELECT sal FROM emp WHERE deptno = 30);


-- The outer query will give the name,sal of all the employees whose sal is greater than 2850,1500
-- ie max(sal) from dept 30.
-- To get Minimum, just change the sign.
SELECT ename, sal
FROM emp
WHERE sal < ALL (SELECT sal FROM emp WHERE deptno = 20);

-- ANY Keyword
-- • Compares a value to any value in a list or subquery.
-- • The condition holds true if it matches at least one value in the subquery.

SELECT ename, sal
FROM emp
WHERE sal > ANY (SELECT sal FROM emp WHERE deptno = 20);

-- 2975,3000,2850
-- The inner query returns 2975,3000,2850.
-- The outer query returns all the records whose salary is greater than either 2975,3000 or 2850


-- Inline View:
-- An inline view is essentially a subquery that appears in the FROM clause of a query. It acts as a
-- temporary table that is created on-the-fly and used within the context of the main query. Inline
-- views are helpful for simplifying complex queries and improving readability.
-- Basic Syntax:

SELECT columns FROM (
SELECT columns FROM table_name WHERE conditions
) AS alias WHERE conditions;

-- Let's try to find out the list of all the employees whose annual salary is more than 30000
-- select ename, sal,sal* 12 annual_ sal from emp where annual
-- _sal>30000;
-- This query will fail because we cannot use annual sal in where clause.
-- We should use inner query here, more likely inner view

select * from (
select ename, sal, sal* 12 annual_sal from emp
) e where e.annual_sal>30000;
