-- ## Why Joins?
-- To get data from more than 1 table. 

-- Customer and Order details 
-- Customer table, Product, Order_details, address_table, shipment table 

-- Let's create a table to understand All the examples. 
-- Create table emp 
drop table emp;


CREATE TABLE emp ( 
emp_id INT PRIMARY KEY,
emp_name VARCHAR(50),
dept_id INT );

--  Create table dept 
drop table dept;

CREATE TABLE dept 
( dept_id INT PRIMARY KEY,
  dept_name VARCHAR(50)
);

-- Let's insert some in dept table 
INSERT INTO dept (dept_id, dept_name)
VALUES (101, 'Engineering'), 
(102, 'Marketing'), 
(103, 'Finance'),
 (104, 'HR'),
 (105, 'ΙΤ');

-- Let's insert some in emp table

INSERT INTO emp (emp_id, emp_name, dept_id) 
VALUES (1, 'Amit', 101),
(2, 'Priya', 102),
(3, 'Rahul', 103),
(4, 'Sita', 101),
(5, 'Karan', NULL), 
(6, 'Anjali', 102),
(7, 'Vikram', 104),
 (8, 'Neha', 101),
 (9, 'Arjun', 103),
 (10, 'Deepa', NULL); 


-- Let's See the data in tabular format

select * from emp;

select * from dept;


-- Aliases in table: 
-- An alias is a temporary name assigned to a table, column, or other database object to simplify queries or improve readability.
-- Aliases are especially useful when working with complex queries, aggregations, or when joining multiple tables.

-- ##  1. Column Alias:
--  To rename any column while displaying data. 
select emp id as "EMPLOYEE ID", emp name Employee_Name from emp;

select emp_id,emp_name,emp_id+100 as emp_new_id from emp; 

-- ##  2 . Table Alias: 
-- This is used when you wish to give a unique reference to table name 
-- A table alias assigns a temporary name to a table, making it easier to reference in queries, especially when using joins or subqueries.

select * from ( 
select dept id,count(*) total_count 
from emp 
where dept id is not null 
group by dept_id) e 
where e.total_count>1;



-- In the above example total_count is column level alias done on aggregate function and e is table level alias.

-- An efficient query would be this, 
-- Because we have not filtered Null records in the beginning and we have filtered it at the end. 

select from ( 
select dept id,count(*) as total_count
from emp 
group by dept_id)t 
where t.total count>1 and dept_id is not null; 

-- Types of Joins
--  1. Inner Join or equi join 
--  2. Inner Join using, and where 
--  3. Inner Join using USING clause
--  4. Outer Join 
--		a. Left Outer Join/Left Join 
--		b. Right Outer Join/Right Join 
--		C. Full Outer Join (Simulated using UNION) 
--	5. CROSS JOIN or cartesian product 
--	6. SELF JOIN
--  7. Natural Join
--  8. Non-equi Join
--  9. STRAIGHT_JOIN
--  10. SEMI JOIN (Using EXISTS or IN)
--  11. ANTI JOIN (Using NOT EXISTS or NOT IN) INNER JOIN:
--		 An INNER JOIN retrieves rows from both the tables in case they match certain condition. 
--		All the records which did not match certain conditions are discarded. 
--		You can use INNER JOIN or Just JOIN in your query 

-- Key Features of INNER JOIN :
--	1. Combines rows from both tables only when the ON condition is satisfied. 
--	2. If no match is found, the row is excluded from the result. 
--	3. It is the most commonly used type of join for querying related data.

-- Give me the list of all the employees with matching dept? 

SELECT e, d* FROM emp e INNER JOIN dept d 
ON e.dept id = d.dept id 

-- Or 

SELECT e., d.* FROM emp e JOIN dept d 
ON e.dept_id = d.dept_id;

-- Give me the list of all the emp name with a its department name? 
SELECT e.emp_name, d.dept_name FROM emp e INNER JOIN dept d ON e.dept_id = d.dept_id;


-- Inner join with multiple conditions

SELECT e., d.* FROM emp e INNER JOIN dept d ON e.dept_id = d.dept_id and d.dept_name ="Engineering"


-- How INNER JOIN Works 
-- 1. The ON condition (e.dept_id = d.dept_id) is checked for each pair of rows in the emp and dept tables. 
-- 2. Only rows with matching dept_id in both tables are included in the result. 
-- 3. Rows with no match (e.g., Karan in emp and HR in dept) are excluded. 

-- Real World Example: 
-- Any User who logs in OLC, we store their data in users 
-- There is a master table courses which has all our courses listed. 
-- Any User who takes the course, their data will be in user_courses 
-- List of all the students who has taken any course with us. Inner Join. 

-- User user courses 
-- 1	101	 
-- 2     -
-- 3 	102 
-- 4 	 -
-- 5 	101


SELECT u.name,uc.course_id,uc.price 
FROM users u INNER JOIN user_courses uc 
ON u.id = uc.user_id;

--  INNER JOIN using, and WHERE

--  We can also get the Output of INNER join by using, and where in the below query.
--  An INNER JOIN is used internally by the SQL engine to execute this query. 
--  This is the Old style method and it NOT recommended any more as it lacks the clarity because of the absence of JOIN keyword. 
--  If you remove the where condition, it will become CROSS JOIN. 

select e.",d." from emp e, dept d 
where e.dept id=d.dept id;


-- ## INNER JOIN using USING Clause
--  The USING clause in SQL is a shorthand way of specifying the columns to be used for the join condition 
-- when both tables share one or more columns with the same name. 
-- This is especially useful for simplifying the query and making it more readable,
--  as you don't need to explicitly mention the table names for the joining columns. 

SELECT e.emp name, d.dept name 
FROM emp e JOIN dept d
USING (dept id);

-- Note: you can not use alias inside USING 
SELECT e.emp_name, d.dept_name 
FROM emp e JOIN dept d 
USING (e.dept_id); -- doesnot work

-- Key Points
-- 1. Same Column Names:
-- 		The USING clause is used when the columns you want to join on have the same name in both tables. 
-- 2. Implicit Column Matching: 
--		You don't need to specify the table name for the joining column(s); just the column name is enough.
-- 3. No Duplicates: 
--      The USING clause automatically avoids selecting duplicate columns from the joined tables.

SELECT e.*.d.* 
FROM emp e JOIN dept d 
USING (dept_id); 


--  ## Left Join: Left Outer Join 
-- Retrieve all employees, including those without a matching department. 
-- Departments with no matches will show NULL. 

SELECT e., d.* 
FROM emp e LEFT JOIN dept d 
ON e.dept id = d.dept id;

SELECT e.emp_name, d.dept_name 
FROM emp e LEFT JOIN dept d 
ON e.dept_id = d.dept_id;


-- ## User table, User_courses: 
--  	Give me all users name, email id, courseid 
--  Right Join: 
--    Right Outer Join Retrieve all departments, including those without matching employees. 
--    Employees with no matches will show NULL. 

-- Include matching records from inner join 
-- Include non-matching records from Right side table
-- Add NULL for those non-matching record on the left side table 

SELECT e.emp_name, d.dept_name 
FROM emp e RIGHT JOIN dept d 
ON e.dept_id = d.dept_id;



-- Real world use-case
-- Udemy creates a lot of courses. 
-- Find out the list of all the student and the course they have taken.
-- It should also display the course which are not taken by anyone. 

-- FULL Outer Join:
-- Retrieves all rows from both tables, with matching rows where possible.
-- If there's no match, NULL values are returned for the missing side. 
-- MySQL does not directly support FULL OUTER JOIN.
-- You can simulate it using a UNION of LEFT JOIN and RIGHT JOIN. 

SELECT e.emp_name,d.dept_name 
FROM emp e LEFT JOIN dept d 
ON e.dept_id = d.dept_id 
UNION 
SELECT e.emp_name, d.dept_name
FROM emp e RIGHT JOIN dept d 
ON e.dept id = d.dept id;

-- Please note: 
-- UNION ALL will bring duplicate, UNION filters duplicate.

SELECT e., d. 
FROM emp e LEFT JOIN dept d 
ON e.dept_id = d.dept_id 
UNION ALL 
SELECT e., d.* 
FROM emp e RIGHT JOIN dept d
ON e.dept id = d.dept id;


-- Revision: 
-- Left. Emp and Dept table Right Side Inner Join: 
-- When you need records from both the table on match. 

--  Left Join: Give me all matching records for Emp and dept and give me all non-matching records from emp table 
--  Right Join: Give me all Matching Records + Non-matching from dept 

-- Lets change our table structure and dataset for the rest of the query 

DROP TABLE emp; 
DROP TABLE DEPT; 

CREATE TABLE DEPT ( 
DEPT_ID INT PRIMARY KEY, 
DNAME VARCHAR(50), 
LOC VARCHAR(50) 
);

CREATE TABLE EMP ( 
EMP_ID INT PRIMARY KEY, 
ENAME VARCHAR(50), 
JOB VARCHAR(50), 
MGR INT,
HIREDATE DATE,
SAL DECIMAL(10, 2),
COMM DECIMAL(10,2), 
DEPT_ID INT, 
FOREIGN KEY (DEPT_ID) REFERENCES DEPT(DEPT_ID)
);

INSERT INTO DEPT ( DEPT_ID, DNAME, LOC)
VALUES (10, 'ACCOUNTING', 'NEW YORK'),
(20, 'RESEARCH', 'DALLAS'), 
(30, 'SALES', 'CHICAGO'), 
(40, 'OPERATIONS', 'BOSTON'); 

-- Insert data into EMP table 

INSERT INTO EMP (EMP_ID, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPT_ID) 
VALUES (7369, 'SMITH', 'CLERK', 7902, '1980-12-17', 800, NULL, 20),
(7499, 'ALLEN', 'SALESMAN', 7698, '1981-02-20', 1600, 300, 30), 
(7521, 'WARD', 'SALESMAN', 7698, '1981-02-22', 1250, 500, 30), 
(7566, 'JONES', 'MANAGER', 7839, '1981-04-02', 2975, NULL, 20), 
(7698, 'BLAKE', 'MANAGER', 7839, '1981-05-01', 2850, NULL, 30), 
(7782, 'CLARK', 'MANAGER', 7839, '1981-06-09', 2450, NULL, 10), 
(7788, 'SCOTT', 'ANALYST', 7566, '1987-07-13', 3000, NULL, 20), 
(7839, 'KING', 'PRESIDENT', NULL, '1981-11-17', 5000, NULL, 10), 
(7844, 'TURNER', 'SALESMAN', 7698, '1981-09-08', 1500, 0, 30), 
(7900, 'JAMES', 'CLERK', 7698, '1981-12-03', 950, NULL, 30), 
(7902, 'FORD', 'ANALYST', 7566, '1981-12-03', 3000, NULL, 20), 
(7934, 'MILLER', 'CLERK', 7782, '1982-01-21', 1300, NULL, 10) ;

-- CROSS JOIN:
-- Returns the Cartesian product of both tables, 
-- meaning every row from the first table is combined with every row from the second table. 
-- This will return 12*4 rows. 

SELECT e.*, d.* 
FROM emp e CROSS JOIN dept d; 

SELECT e.ename, d.dname 
FROM emp e CROSS JOIN dept d; 

-- SELF JOIN: 
-- A join where a table is joined with itself is called self join. 
-- Here 2 table in question are same. 
-- Find out emp with his manager.

select e.emp_id as emp_id,e.ename as emp_name, m.emp_id as mgr_id,m.ename as mgr_name 
from emp e,emp m 
where e.mgr=m.emp_id ;


-- Or 

select e.emp_id as emp_id,e.ename as emp name, m.emp_id as mgr_id,m.ename as mgr_name 
from emp e JOIN emp m 
on e.mgr=m.emp id;

-- What if you want to find all the employees with its reporting manager 
-- that should also include the Higher Manager who is the CEO of the company. 


SELECT e.ename AS Employee,m.ename AS Manager 
FROM emp e LEFT JOIN emp m 
ON e.mgr=m.emp_id;


select e.emp_id as emp_id,e.ename as emp_name, m.emp_id as mgr_id,m.ename as mgr_name 
from emp e LEFT JOIN emp m 
on e.mgr=m.emp_id


-- Note: 
-- Use Inner Join to filter Manager (CEO)
-- You can replace NULL with Some Value say CEO 

SELECT e.ename AS Employee, ifNULL(m.ename, "CEO") AS Manager
FROM emp e LEFT JOIN emp m 
ON e.mgr = m.emp_id;


-- Get the list of all the employees who are getting same salary as of scott. 
select e1.ename,e2.ename,ef.sal 
from emp ef,emp e2 
where e1.sale2.sal and ef.emp_id=e2.emp_id and e2.ename="SCOTT";

select e1.ename,e2.ename,e1.sal 
from emp e1 JOIN emp e2 
on e1.sal=e2.sal and e1.emp_id <> e2.emp_id and e2.ename="SCOTT";


-- Find out all the employees who are getting salary more than their manager. 
select e1.ename as emp_name,mgr.ename as mgr_name,e1.sal emp_sal,mgr.sal mgr_sal 
from emp e1 JOIN emp mgr 
on e1.mgr=mgr.emp_id and e1.sal>mgr.sal 

-- Or 

select e1.ename as emp name, mgr.ename as mgr name, el sal emp sal, mgr.sal mar sal 
from emp e1,emp mgr 
where e1.mar=mgr.emp_id and e1.sal>mgr.sal


-- List all the employees who have joined before their manager. 
select e.ename, mgr.ename,e.hiredate, mgr.hiredate 
from emp e, emp mgr 
where e.mgr=mgr.emp_id and e.hiredate<mgr.hiredate; 

select e.ename, mgr.ename,e.hiredate, mgr.hiredate 
from emp e join emp mgr 
on e.mgr=mgr.emp_id and e.hiredate <mgr.hiredate; 


-- ## Natural Join: It automatically joins two tables based on all columns with the same name and compatible data types. 
-- Unlike other joins, you do not explicitly specify the columns for the join condition
-- MySQL automatically determines the common columns to use. 

-- ## Key Points About Natural Join :
-- 1. It matches columns with the same name and compatible data types between the two tables. 
-- 2. It eliminates duplicate columns in the result (i.e., columns with the same name appear only once). 
-- 3. If no common columns exist, the result is a Cartesian product of the two tables. 
-- 4. It can be risky in large tables, as unintended columns with the same name might cause unexpected joins. 
-- 5. Avoid this in Production.


SELECT * FROM emp e NATURAL JOIN dept d;

select from emp e join dept d on e.DEPT ID=d.DEPT ID;


-- How it Works? 
-- 1. The NATURAL JOIN automatically uses the dept_id column, as it exists in both emp and dept tables. 
-- 2. Only rows where the dept_id matches in both tables are included. (INNER JOIN) 

-- When to use: 
-- 1. Use it when tables have meaningful common columns with the same names. 
-- 2. Avoid it if column names differ or when specific conditions are needed, 
-- as you cannot specify explicit join conditions in a NATURAL JOIN. 

-- Natural Join vs Join... USING 

SELECT * FROM emp e NATURAL JOIN dept d; 

SELECT e.*d* FROM emp e JOIN dept d USING (dept id);


-- Feature			 NATURAL JOIN 							 JOIN... USING 
-- Column Matching	 Automatically based on column names	 Explicitly specified by the user 
-- Control 			 No control over matching columns 		 Full control over columns 
-- Risk 			 High risk of unintended matches 		 Lower risk due to explicitness 
-- Result Columns 	 Removes duplicate columns 				 Removes duplicates for specified columns 
-- Preferred Use 	 Quick joins for simple cases 			 Safer for complex queries 


-- ## Non-equi join: 
-- A Non-Equi Join is a type of SQL join where the join condition is based on a comparison operator 
-- other than the equality (=) operator. 
-- These operators can include <, >, <=, >=, !=, or BETWEEN. 
-- Non-equi joins are commonly used when the relationship between tables cannot be expressed as a simple equality condition,
--  such as range-based joins or custom logic.


SELECT e EMP_ID, e.ENAME, e.SAL, d.DEPT_ID, d.DNAME 
FROM EMP e JOIN DEPT d 
ON ( 
	(d.DEPT ID=10 AND e.SAL <= 1500)
	OR (d.DEPT_ID = 20 AND e.SAL BETWEEN 1501 AND 3000)
	OR (d.DEPTID=30 AND e.SAL > 3000)
);




-- JOINS -III 
-- ## STRAIGHT_JOIN:
--  The STRAIGHT_JOIN is a variation of the JOIN in MySQL. It forces the query optimizer to use the join order as specified in the query, 
--  instead of letting MySQL decide the order based on its cost-based optimization.
-- This can be useful when:
-- 1. You know the optimal join order better than MySQL's query optimizer.
-- 2. The optimizer chooses a poor execution plan for certain queries.

-- Syntax:

SELECT * FROM small_table STRAIGHT_JOIN large_table
ON
small_table.key = large_table.key;

-- Note:
-- * Place the smaller table first in the join (as the left table in the query).
-- 		This is because the smaller table is typically scanned first, and the larger table is processed for matching rows, which reduces memory usage and execution time.
-- * This reduces the number of rows the database engine needs to iterate through when matching.


-- ## Key Points
-- 1. Join Order:
-- 	 *	With STRAIGHT_JOIN, the first table in the query is always read first, followed by the second table.
--	 *  Regular joins let MySQL reorder tables for optimization, but STRAIGHT_JOIN prevents this.
-- 2. Performance Tuning:
--  * Useful when you need fine-grained control over the execution plan.
--  * Often used when dealing with large datasets or complex queries where MySQL's optimizer doesn't pick the best join order.
-- 3. Equivalence:
--  *  STRAIGHT_JOIN is equivalent to specifying JOIN with a hint for a specific table order.

SELECT e., d.*
FROM
dept d STRAIGHT_JOIN emp e
ON e.dept_id = d.dept_id;


-- How it Works
--  *  The STRAIGHT_JOIN forces MySQL to process the emp table first, then the dept table, even if the optimizer might think the reverse order is better.

-- When to Use STRAIGHT_JOIN
-- 1. Forcing Join Order:
--	 * 	When you know processing a specific table first will improve performance.
-- 2. Optimizer Issues:
--   *  When MySQL's optimizer chooses a poor execution plan due to inaccurate statistics or assumptions.
-- 3. Large Datasets:
--   *  In queries involving large datasets, STRAIGHT_JOIN can help fine-tune query performance.

--  SEMI JOIN:
-- A semi-join in SQL refers to a situation where we return rows from one table that match the join condition with rows in another table, 
-- but without returning columns from the second table.
-- You cannot get access to columns from 2nd table in your select query

-- MySQL doesnot support semi join directly, but we can simulate the behavoir using 
-- Before experimenting, recreate emp, dept table remove any foreign key relationship

-- Let Dept table have only 10,20,40 dept_id
-- Let emp table have 10,20,30 dept_id employees.

-- EXISTS:
SELECT e.*
FROM EMP e
WHERE EXISTS (
SELECT 1
FROM DEPT d
WHERE e.DEPT_ID = d.DEPT_ID
);






















