-- ## Function:
--  It is a set of instructions written to solve a particular task.
--  It must return a value.
-- Every database has 2 types of Functions.
--   1. Predefined/Built-in Functions 
--   2. User Defined Functions 

-- ## Predefined Functions:
--  These are of 3 Types 
-- 		1. Scalar Function:
--			 Works on Single value and return a Single value.
-- 			 a. Numeric Functions: 
--				i. ABS(),ROUND(),FLOOR(), CEIL(), RAND()
--			 b. String Functions: 
--				i. CONCAT(), SUBSTRING(), UPPER(), LOWER(), LENGTH() 
--			 c. Date and Time Functions: 
--				i. NOW(),CURDATE(), DATE_ADD(), DATEDIFF(), EXTRACT() 
--			 d. Control Flow Functions: 
--				i. IF(), CASE, NULLIF(), COALESCE() 
--		2. Aggregate Functions: 
--			a. COUNT(), SUM(), AVG(), MAX(),MIN() 
--		3. Window Functions: 
--			a. ROW_NUMBER(), RANK(), DENSE_RANK(),SUM() OVER()

-- ## Custom Functions: 
--	4. User Defined Functions: 
--	5. Stored Procedure:
--	6. Prepared Statements:

-- ## NUMERIC FUNCTIONS:
-- ## 1. ABS():
--		 It is used to convert -ve values into positive values. 

select abs(-5) from dual; 

-- Here -5 can be a valid column name from the table.
-- Dual is a virtual table that can be used to just test the functions. 
select abs(-5) from emp; -- returns 5 N times, where n= total rows of emp table. 
select abs(-5); -- returns 5 
select sal,abs(sal) from emp; -- returns all employee salary in +ve value. For NULL, it will return NULL


-- ##  2. MOD(m, n): 
--  It will give remainder after m divided by n 
select mod(5,3) from dual; -- 2 

-- ## 3. ROUND(m,n): 
-- It rounds given floated valued number 'm' based on 'n' digits after decimal point.
-- It always checks remaining number. 
-- If remaining number are above 50% then 1 is automatically added to the rounded number. 
select round(1.2) from dual; -- 1 
select round(1.5) from dual; -- 2 
select round(1.4999999) from dual; -- 1
select round(1.1234,3) from dual; -- 1.123 
select round(1.1235,3) from dual; -- 1.124 round with -ve 2nd parameter: 
select round(1234.567,-1) from dual; -- 1230 
select round(1235.567,-1) from dual; -- 1240
select round(1235.567,-2) from dual; -- 1200 
select round(1255.567,-2) from dual; -- 1300

-- ## 4. Truncate(m,n):
-- It truncates given floating value m based on n. 
-- This function does not check remaining number is above 50% or below 50%. 
-- It does not round up before truncating. 
select truncate (1234.999,0) from dual; -- 1234 
select truncate (1234.5674,2) from dual; -- 1234.56 
select truncate (1234.5674,-1) from dual; -- 1230 
select truncate (1299.5674,-2) from dual; -- 1200 

-- ## 5. Sign: 
-- It returns -1 for ve value, O for zero,+1 for +ve value. 
select sign(-100) from dual; -- 1
select sign(100) from dual; -- 1 
select sign(-0) from dual; -- 0 

-- ## 6. RAND():
-- Returns a random floating-point number between 0 and 1. You can pass a seed value to generate a repeatable sequence. 
select RAND(); -- 0.07826328657405757

-- Generate a random number between 1 to 99. This will give us 2 digit random number
SELECT FLOOR(RAND()*100) AS random_number;

-- Select a random employee from emp table. 
-- It generates a random value for each row and orders it by that value in ascending and then limit it by 1. 
select * from emp order by rand() limit 1;

-- If you want to generate the same random sequence each time you run your query, you can provide a seed: 
SELECT RAND (1234) AS random_number ; -- 0.881177173816764 

-- Running this query again will give you same output. This is not actually random. 
-- It is given to sql engine which returns you same output. This is helpful to produce same number for same input good for testing.
 select empno, ROUND (RAND(empno)*10000) as random_id from emp;

-- Generate 5 Random Numbers:
SELECT FLOOR(RAND()* 100) AS random_number from emp limit 5; 

-- It works on String data as well. But it is not recommended 
SELECT RAND("a123") AS random_number;

-- ## Mathematical Functions 
-- 1. POW(x,y) / POWER(x,y) 
select POW(2,3) from dual; -- 8 
select POW(deptno, 2) from emp; 
select POWER (2,3) from dual; 

-- 2. SQRT(x) 
-- Returns square root of a number 
select sqrt(16); -- 4 

-- 3. LOG(x): 
-- Returns the natural logarithm (base e) of x. 
select log(8); -- 2.0794415416798357 

-- 4. LOG10(x): 
-- Returns the base 10 logarithm of x. 

select log10(8); -- 0.9030899869919435 

-- 5. Greatest(exp1, exp2, exp3...)
-- Returns the maximum value among given expressions.
-- You can use this to get the maximum value from all possible columns. 

select greatest(10,20,30) from dual; -- 30 
select sal, comm, greatest(sal, comm) from emp;

-- If you wish to get proper value, use IF or IFNULL 
select sal,comm, greatest (IFNULL(sal,0), IFNULL(comm,0)) as Greatest from emp;

-- Least: Can be used to get list value from multiple expression. 
select least(10,20,30) from dual; -- 10 
select sal,comm, least(IFNULL(sal, 0), IF (comm, comm,0)) as Least from emp;

-- 6. Ceil: 
-- Returns the nearest Greatest Number. 
select ceil(5.2) from dual; -- 6 

-- 7. Floor: 
-- Returns the nearest Smallest Number. 
select floor(5.9999) from dual; -- 5










