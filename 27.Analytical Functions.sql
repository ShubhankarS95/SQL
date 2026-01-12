-- 27. Analytical Functions-I
-- 1. ROW_NUMBER()
-- 2. RANK()
-- 3. DENSE_RANK()
-- 4. NTILE()
-- 5. LAG()
-- 6. LEAD()
-- 7. FIRST_VALUE()
-- 8. LAST_VALUE()
-- 9. CUME_DIST()
-- 10. PERCENT_RANK()

select * from emp;

-- ROW NUMBER()
-- While MySQL doesnot have ROWNUM, You can simulate that using row _number().
-- It assigns a unique sequential integer to rows within a result set.
-- It also allows Sorting and Partitioning.

-- The syntax:
-- ROW_NUMBER() OVER ([PARTITION BY column_name] ORDER BY column_name)

-- Over: Defines how rows are grouped or ordered for numbering.

-- You can pass, Partitioning and or Ordering
-- PARTITION BY (Optional): Divides the result set into partitions (groups).
-- The row numbering restarts at 1 for each partition.
-- You can use more than 1 column to choose Partitioning.
-- ORDER BY: Specifies the order in which the rows are numbered within each partition. If not specified, the order is undefined.
-- You can use more than 1 coloumn to order the data, in asc or desc order.
-- Lets try with a Generic Syntax.

select *,ROW_NUMBER() over() AS rownum from emp;

select *,ROW_NUMBER() over(order by sal desc) AS rownum from emp;

-- Select 3rd Emp from the list.
-- We cannot use rownum column name in the where clause.

SELECT empno,ename job,sal, ROW_NUMBER() OVER (ORDER BY sal DESC) AS rownum
FROM emp where rownum=3;

-- Instead use the Inline View.
SELECT * from (
	SELECT empno,ename job,sal,
	row_number() OVER (ORDER BY sal DESC) AS rownum
FROM emp ) e where e.rownum=3;


-- Pagination:
Select * from (
SELECT empno ,ename, job,sal,
ROW_NUMBER() OVER (ORDER BY sal DESC) AS rownum
FROM emp) e where e.rownum between 3 and 5


select empno, ename,sal, deptno,
row_number() over(partition by deptno) as ranked
from emp;


select empno ,ename,job,sal,RoW_NUMBER() over (PARTITION BY job order by sal asc) AS rownum 
from emp;


-- Department Wise, Highly Paid Employee?
select * from (
select empno, ename, sal, deptno,
ROW_NUMBER() over(partition by deptno order by sal desc, empno desc) as ranked
from emp) e where e.ranked=1;

-- Rank():
-- It assigns a rank to each row within a result set or a partition of the result set, based on the
-- specified ORDER BY clause.
-- In case of equal, it gets same rank and there would be the gap in the next score.
-- If we don't give any condition in over), then it gives the same score as 1.
-- The scoring is controlled by ordered by.
-- The grouping is controlled by Partition by

SELECT empno, ename, sal,RANK() OVER() AS ranked FROM emp;

SELECT empno, ename, sal,rank() OVER() AS ranked,ROW_NUMBER() over() AS rownum FROM emp;

-- Rank is controlled by Order by.
SELECT empno, ename, sal,RANK() OVER(order by sal) AS ranked FROM emp;
-- Note: In case of Ties(eg 2850, we have same rank ie 3, But next row gets 6 and not 4)

SELECT empno, ename, sal,RANK() OVER (order by sal asc, empno desc) AS ranked FROM emp;

-- In the above example, we have ordered it by 2 parameters
-- Salary in ascending.
-- If there is a match of salary, then empno in descending
-- Since there are no 2 record that has same salary and empno, you will not see same Rank.
-- And hence you have 1...7
-- Partition by can Group the data, but can't assign the rank and hence we will still get the same
-- rank for all the rows ie 1.
SELECT empno, ename, sal, deptno, RANK() OVER(Partition by deptno)AS ranked FROM emp;

-- Lets try with Partition and 1 order by
SELECT empno, ename, sal,deptno,RANK() OVER (Partition by deptno order by sal asc) AS ranked FROM emp;


-- Top N in each Partition

SELECT * from (
SELECT empno, ename, sal, deptno,RANK() OVER (Partition by deptno order by sal asc,empno desc) AS ranked FROM emp) as e 
where e.ranked<=2

-- DENSE RANK()
-- It assigns a rank to each row in a result set or partition, based on the specified ORDER BY clause.
-- Unlike RANK(), it does not leave gaps in the ranks when there are ties.

SELECT empno, ename, sal, DENSE_RANK() over() AS ranked FROM emp;

SELECT empno, ename, sal,dense_rank() OVER (order by sal) as ranked FROM emp;

SELECT empno, ename, sal,dense_rank() OVER (order by sal asc, empno desc) AS ranked FROM emp;

SELECT empno, ename, sal, deptno,DENSE_RANK() OVER(Partition by deptno order by sal asc, empno desc)
AS ranked FROM emp;


-- Partition by more than 2 columns:
-- Yes, you can use multiple columns in the PARTITION BY clause with DENSE_RANK() (or anyother window function) in MySQL. 
-- When you specify multiple columns in PARTITION BY, the result set is partitioned based on the unique combinations of the specified columns.

drop table sales;
CREATE TABLE sales (
region VARCHAR(50),
product VARCHAR (50),
salesperson VARCHAR(50),
revenue INT
);

INSERT INTO sales (region, product, salesperson, revenue) VALUES
('North', 'A', 'John', 5000),
('North', 'A', 'Alice', 7000),
('North', 'B', 'John', 8000),
('South', 'A', 'Bob', 6000),
('South', 'A', "Carol", 9000),
('South', 'B', 'Alice', 7000);

select * from sales;

SELECT region, product, salesperson, revenue,
DENSE_RANK() OVER (PARTITION BY region, product ORDER BY revenue
DESC) AS ranked
FROM sales;

-- Assignment:
-- Create a Table with below structure.
-- state_name, district_name,school_name,student_name,gender, student_mark

-- CREATE TABLE student data (
-- state_name VARCHAR(50),
-- district_name VARCHAR(50),
-- school name VARCHAR(100),
-- student_name VARCHAR(50),
-- gender CHAR(1),
-- student_mark INT

-- Create sample data for 5 States say
-- Andhra Pradesh, Karnataka, Maharashtra, Tamil Nadu, Bihar

-- For each state, create 5 district. For each district create 5 schools and for each school lets have 5 Students. Use ChatGPT to insert the records.

-- 1. WAQ to get overall rank national wise.
-- 2. WAQ to get rank state_wise
-- 3. WAQ to get rank state,district wise
-- 4. WAQ to get rank state, district,school wise.
-- 5. WAQ to get rank state, district,school, Gender wise

-- Find Top 3 Students for each of the above category.

-- 1. WAQ to get overall rank national wise Top 3
-- 2. WAQ to get rank state_wise Top 3
-- 3. WAQ to get rank state,district wise Top 3
-- 4. WAQ to get rank state,district,school wise Top 3
-- 5. WAQ to get rank state, district,school, Gender wise Top 3





