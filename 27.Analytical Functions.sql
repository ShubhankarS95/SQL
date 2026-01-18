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


-- DIFFERENCE BETWEEN ROW_NUMBER(), RANK, DENSE_RANK

select * from student;

-- without partition next consecutive rank will be added to the next partition for dense rank  1 -> 2
-- and for rank, number of rows present in first partition + 1 will be added in the next partition 1 -> 251
select  state_name,
row_number() over(order by state_name) as row_n,
rank() over(order by state_name) as rank1,
dense_rank() over(order by state_name) as dense_rank1
from student

-- with each partition number reset to 1

select  state_name,
row_number() over(partition by state_name order by state_name) as row_n,
rank() over(partition by state_name order by state_name) as rank1,
dense_rank() over(partition by state_name order by state_name) as dense_rank1
from student




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



-- NTILE:
-- It is used to divide rows into a specified number of roughly equal-sized groups or buckets.
-- This is particularly useful for creating quartiles, deciles, or other groupings in your dataset.
-- The bucket size is determined by dividing the total number of rows by n. If the rows cannot be
-- evenly divided, the first buckets will have an extra row.
-- Example: If there are 10 rows and 3 buckets, the distribution will be:
-- Bucket 1: 4 rows
-- Bucket 2: 3 rows
-- Bucket 3: 3 rows
-- Syntax:
-- NTILE(n) OVER (PARTITION BY column_name ORDER BY column_name)
-- n: The number of buckets or groups to divide the rows into.
-- PARTITION BY: Optional. Divides the data into partitions to apply the NTILE function separately
-- to each partition.
-- ORDER BY: Specifies the order of rows within each partition. The ordering determines how
-- rows are assigned to buckets.
-- Divide the dataset into 4 parts. If you don't specify anything under over(), it will divide the data into

SELECT empno, ename,sal,NTILE(4) OVER () AS tile_no
FROM emp;


-- Divide the employees based on empno
select empno,
ename,
sal,
NTILE(4) OVER (order by empno) AS tile_no
FROM emp;

-- Divide based on Salary
SELECT empno, ename, sal,
NTILE(4) OVER (order by sal) AS tile_no
FROM emp;

-- If there is a tie in sal, then re-arrange the records by empno in desc within that salary.
SELECT empno, ename, sal,
NTILE(4) OVER (order by sal desc,empno desc) AS tile_no
FROM emp;


-- Partition with order by
SELECT empno, ename, sal, deptno,
NTILE(4) OVER (partition by deptno order by sal) AS tile_no
FROM emp;


-- LAG:
-- It is a window function that allows you to access data from the previous row of the result set
-- within a window or partition. It's commonly used to compare values from adjacent rows, such
-- as calculating differences, detecting changes, or creating historical comparisons.
-- Syntax:
-- column_name)
-- LAG(column_name, offset, default_value) OVER (PARTITION BY column_name ORDER BY


Drop table sales;
CREATE TABLE sales (
id INT AUTO_INCREMENT PRIMARY KEY,
sale_date DATE NOT NULL,
product_name VARCHAR(100) NOT NULL,
quantity INT NOT NULL,
total_amount DECIMAL(10, 2) NOT NULL
);

INSERT INTO sales (sale_date, product_name, quantity, total_amount) VALUES
('2024-12-22', 'Printer', 2, 50000.00),
('2024-12-20', 'Keyboard', 15, 15000.00),
('2024-12-16', 'Laptop', 3, 150000.00),
('2024-12-21', 'Mouse', 20, 10000.00),
('2024-12-23', 'Tablet', 3, 60000.00),
('2024-12-18', 'Headphones', 10, 25000.00),
('2024-12-17', 'Smartphone', 5, 120000.00),
('2024-12-19', 'Monitor', 4, 40000.00),
('2024-12-24', 'Smartwatch', 7, 35000.00),
('2024-12-25', 'Router', 8, 24000.00);


select id, sale_date, total_amount,
LAG(total_amount) over () as prev_day_sales from sales;


-- This copies the total_amount column to next column next row. 
-- Note the data was not inserted in the order of the sales date.
-- You can pass 2nd parameter to controll the lag rows.
-- Passing -ve value in the 2nd parameter will result in error.

select id,sale_date, total_amount, 
LAG(total_amount,0) over() as prev_day_sales
from sales;

-- Compare today with Yesterday., third parameter for handling null values

select id, sale_date, total_amount,
LAG(total_amount, 1,0) over() as prev_day_sales
from sales;

-- Compare today with Day before Yesterday.
select id, sale_date, total_amount,
LAG(total_amount,2,0) over () as prev_day_sales from sales;

-- We wish to first arrange the data by sales _date and then do a LAG.
select id, sale_date, total_amount,
LAG(total_amount, 1,0) over (ORDER BY SALE_DATE) as prev_day_sales
from sales;


-- Using Partition by
DROP table sales;
CREATE TABLE sales (
id INT AUTO_INCREMENT PRIMARY KEY,
sale_date DATE NOT NULL,
product_name VARCHAR(100) NOT NULL,
total_amount DECIMAL (10, 2) NOT NULL
);

INSERT INTO sales (sale_date, product_name, total_amount) VALUES
('2024-12-22', 'Laptop', 135000.00),
('2024-12-21', 'Laptop', 140000.00),
('2024-12-24', 'Laptop', 142000.00),
('2024-12-25', 'Laptop', 145000.00),
('2024-12-23', 'Laptop', 138000.00),
('2024-12-22', 'Smartphone', 87000.00),
('2024-12-21', 'Smartphone', 85000.00),
('2024-12-25', 'Smartphone', 89000.00),
('2024-12-24', 'Smartphone', 88000.00),
('2024-12-23', 'Smartphone', 86000.00),
('2024-12-24', 'Tablet', 65000.00),
('2024-12-21', 'Tablet', 62000.00),
('2024-12-23', 'Tablet', 64000.00),
('2024-12-22', 'Tablet', 63000.00),
('2024-12-25', 'Tablet', 66000.00);

select * from sales;

SELECT
product_name,
sale_date,
total_amount,
LAG(total_amount,1,0) OVER (PARTITION BY product_name ORDER BY sale_date) as prev_day_sales
from sales;



SELECT
product_name,
sale_date,
total_amount,
LAG(total_amount,1,0) OVER (PARTITION BY product_name ORDER BY sale_date) as prev_day_sales,
total_amount - LAG(total_amount,1,0) OVER (PARTITION BY product_name ORDER by sale_date) as difference
from sales;


-- LEAD:
-- It is a window function that retrieves data from a subsequent (next) row within the same result set.
-- It's useful for comparing the current row's values with the next row, allowing you to  analyze sequential data.


select id,sale_date,total_amount,
LEAD(total_amount,1,0) over () as next_day_sales from sales;

-- Get another column with same column copied
select id,sale_date, total_amount,
LEAD(total_amount,0) over () as next_day_sales from sales;

select id, sale_date, total_amount,
LEAD(total_amount,2) over () as next_day_sales from sales;

-- We wish to first arrange the data by sales_date and then do a LEAD.
SELECT id,sale_date,total_amount,
LEAD (total_amount) OVER (ORDER BY sale_date) AS previous_day sales FROM sales;


select *,total_amount-next_day_sales as difference from (
SELECT id,sale_date,total_amount,LEAD (total_amount, 1,0) OVER (ORDER BY sale_date) AS next_day_Sales
FROM sales) as t

-- Using Partition by

-- Only Partition without Order by
select sale_date, product_name,total_amount,
LEAD(total_amount, 1,0) OVER(partition by product_name) as next_day_sales
from sales;


-- Please Note: The data is not ordered by salesdate. It just group the data by the way it
-- appears.
select sale_date, product_name,total_amount,
LEAD(total_amount, 1,0) OVER(partition by product_name order by sale_date) as
next_day_sales
from sales;

select sale_date, product_name,total_amount,LEAD(total_amount, 1,0) OVER(partition by product_name order by sale_date) as
next_day_sales,total_amount - LEAD(total_amount, 1,0) OVER(partition by product_name order by sale_date)
as difference
from sales;


select *, total_amount - next_day_sales as difference from (
select sale_date, product_name,total_amount, LEAD(total_amount, 1,0) OVER(partition by product_name order by sale_date) as next_day_sales
from sales) e


-- 1. Running Sum/Count/Avg/Max/Min
-- 2. FIRST_VALUE(
-- 3. LAST_VALUE()
-- 4. CUME_DIST()
-- 5. PERCENT_RANK()

-- Running TOTAL:
-- In case we wish to see the running sum of any product sold, we can use Running Sum technique. Lets see that with an example

## WARNING NOT RECOMMENDED
-- SELECT @@sql_mode;
-- SET SESSION sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''))


select sale_date,product_name,total_amount,sum(total_amount)  as total_sales from sales;

-- It gives first record, with total Sum

select sale_date,product_name,total_amount,sum(total_amount)  over() as total_sales from sales;

select sale_date,product_name,total_amount,sum(total_amount) over(partition by product_name) as total_sales from sales;

select sale_date,product_name,total_amount,
sum(total_amount) over(partition by product_name order by sale_date) as total_sales 
from sales;

select * from sales;

-- Let's get running total from beginning to end without partitioning. You can achieve this by
-- adding a secondary column say id.

select id,sale_date,product_name,total_amount _amount, 
sum(total_amount) over(order by sale_date,id) as total_sales 
from sales;

-- You can use these technique to find running average,running max, running min, running count

select sale_date,product_name,total_amount,count(*) over () as total_count
from sales;

select sale_date,product_name,total_amount,count(*) over (order by
sale_date) as total_count from sales;

select sale_date,product_name,total_amount,count(*) over (order by
sale_date,product_name) as total_count from sales;

select sale_date,product_name,total_amount,count(*) over (partition by product_name
order by sale_date, product_name) as total_count from sales;


select sale_date,product_name,total_amount,
count(*) over (partition by product_name order by sale_date) as total_count,
avg(total_amount) over (partition by product_name order by sale_date) as avg_price,
max(total_amount) over (partition by product_name order by sale_date) as max_price,
min(total_amount) over (partition by product_name order by sale_date) as min_price
from sales;

select id,sale_date,product_name,total_amount,
count(*) over (order by sale_date, id) as total_count,
sum(total_amount) over (order by sale_date,id) as sum,
round(avg(total_amount) over (order by sale_date,id),2) as avg_price,
max(total_amount) over (order by sale_date, id) as max_price,
min(total_amount) over (order by sale_date,id) as min_price
from sales;

-- What if we have 2 same product, with same sales date and we run the below query

select * from sales order by sale_date;
-- INSERT INTO sales (sale_date, product_name, total_amount) VALUES
-- ('2024-12-21', 'Laptop', 135000.00);

select sale_date,product_name,total_amount,
count(*) over (partition by product_name order by
sale_date,product_name) as total_count from sales;


-- If we see the above example, since we have first 2 rows with same sale_date and product
-- name, It will give us same value for count(*).
-- How to solve?
-- Choose unique column while ordering

select sale_date, product_name,total_amount,
count(*) over (partition by product_name order by sale_date, id) as total_count from
sales;


-- Controlling the Window Frame-Size
-- We can use ROWS BETWEEN N PRECEDING AND CURRENT ROW to control the window frame size.

select sale_date,product_name,total_amount,
sum(total_amount) over (order by sale_date,id) as total from sales

-- Let us try to get the running total for 3 rows at any time.

SELECT sale_date, product_name, total_amount,
       SUM(total_amount) OVER (
           ORDER BY sale_date, id 
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS total 
FROM sales;

-- At any point, the total would be the sum of 3 rows.

-- ROWS BETWEEN CURRENT ROW AND n FOLLOWING:
-- This includes the current row and the next n rows in the calculation.

-- ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING:
-- This include 1 preceding row, the current row, and 1 following row.

-- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW:
-- All rows from the start to the current row (default for many functions like sum()).

-- ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING:
-- All rows from the current row to the end.


-- You can use ROWS with without partition and order by clause.

select sale_date,product_name,total_amount,
sum(total_amount) over(order by sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as "total"  from sales


select sale_date,product_name,total_amount,
sum(total_amount) over (order by sale_date,id ROWS BETWEEN CURRENT ROW and UNBOUNDED FOLLOWING) as "total" from sales


select sale_date,product_name,total_amount,
sum(total_amount) over (partition by product_name order by sale_date ROWS BETWEEN CURRENT ROW AND UNBOUNDED following) as "total" from sales


select sale_date,product_name,total_amount,
sum(total_amount) over (order by sale_date,id ROWS BETWEEN UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING) as "total" from sales


-- You can use these techique in all the cases where you have over ()
-- FIRST_VALUE():
-- It is used as an analytical function to return the first value in an ordered set of rows within a window.

select sale_date,product_name,total_amount,FIRST_VALUE(total_amount) OVER() as first_val from sales;

-- Note: The result are not sorted by any column.

-- Let's Sort the data by sales _date
select sale_date,product_name,total_amount,
FIRST_VALUE(total_amount) OVER(order by sale_date) as first_val from sales;

-- Let's Partition data without sorting
select sale_date,product_name,total_amount,
FIRST_VALUE(total_amount) OVER(partition by product_name) as first_val from sales;

-- Partitioning and Sorting
select sale_date,product_name,total_amount,
FIRST_VALUE(total_amount) OVER(partition by sale_date order by sale_date) as first_val from sales;


select sale_date, product_name,total_amount,
FIRST_VALUE(total_amount) OVER(partition by product_name order by sale_date ) as
first_val from sales;

-- last_value():
-- It is used as an analytical function to return the last value in an ordered set of rows within a window.

select sale_date,product_name,total_amount,
LAST_VALUE(total_amount) OVER() as last_val from sales;


-- Lets sort the data by sale_date
select sale_date,product_name,total_amount,
LAST_VALUE(total_amount) OVER(order by sale_date) as last_val from sales;

-- Note:
-- The behaviour of this code is little different than in FIRST_VALUE. 
-- Here we can see the last_value is coming different for different sale_date, Which did not happen in FIRST_VALUE


select sale_date,product_name,total_amount,
FIRST_VALUE(total_amount) OVER(order by sale_date) as first_val,
LAST_VALUE(total_amount) OVER(order by sale_date) as last_val
from sales;


-- Note: first value is constantly 140000, where as last_val is different for different date.

-- Why FIRST_VALUE Returns the Same Value:
-- FIRST_VALUE (total_amount) always gives the value from the very first row in the partition or window. Since
-- the window always starts from the first row (UNBOUNDED PRECEDING), the "first value" is fixed, regardless
-- of the current row.

-- Why LAST_VALUE Returns the Different Value:
-- LAST_VALUE(total _amount) gives the value of the last row in the current window frame. By
-- default, the frame is UNBOUNDED PRECEDING AND CURRENT Row. Thus, the "last value" changes for
-- each row because the "current row" changes as the query processes each row in order.

-- Considers all rows from the start of the partition up to the current row, but its output is based
-- on the "last row" within this frame (i.e., the current row).



