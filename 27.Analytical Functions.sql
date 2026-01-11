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


















