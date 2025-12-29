CREATE TABLE employees (
employee_id INT NOT null,
emp_name varchar( 100) NULL,
department_id INT NOT NULL,
salary DECIMAL (10, 2) NOT NULL,
PRIMARY KEY (employee_id)
);

select * from scala_training.employees e ;

INSERT INTO employees (employee_id,emp_name, department_id, salary)
VALUES
(1, 'Suraj', 101, 50000.00),
(2, 'Kiran', 101, 60000.00),
(3, 'Kamal', 102, 70000.00),
(4, NULL, 102, 50000.00),
(5, NULL, 103, 60000.00),
(6, 'Aayushman', 103, 70000.00),
(7, NULL, 101, 50000.00);



-- # MAX():  
-- Syntax
-- 		MAX DISTINCT] expr) lover_ clause]
-- 			1. Returns the maximum value of expr
-- 			2. If we pass Integer, it returns the Maximum Value out of it.
-- 			3. If we pass String, It will return the Maximum value out of it.
-- 			4. The DISTINCT keyword can be used to find the maximum of the distinct values of expr. However
-- 			it will return you same result even if you dont use DISTINCT
-- 			5. This function executes as a window function if over_clause is present

-- 		Find out the Max salary from the employee table
	select Max(salary) from employees;

select * from employees e 
order by salary desc;


-- Find out the list of employees getting highest salary 

select * from employees where salary=70000; 
-- 70000 is the output of previous query 

-- Onliner using Subqueries 

select * from employees where salary=( select max(salary) from employees);

SELECT MAX(salary), MAX(emp_name) from employees; 
-- 70000.00 Suraj 

-- * MAX with string are not case-sensitive. 
-- From the list of Suraj, zelina, Ankur 
-- It will give you zelina as output. 
-- 
-- From the list of Suraj, azelina, Ankur 
-- It will give you Suraj as output. 

select * from employees e 
order by emp_name ;

-- - MAX with Where Clause? 
-- 	Where condition will be applicable first and then max would execute on top of that. 

SELECT MAX(salary) AS highest_salary FROM employees WHERE salary < 70000; 

-- The above query would be same as 
select max(salary) as highest_salary from ( select * from employees where salary<70000 )t;



-- * MAX with Group by? 
-- 		The below query would return 1 result per Department id.

# below query works if enabled a setting
select * from employees 
group by department_id ; 


SELECT department_id, MAX(salary) from employees 
group by department_id; 

-- * MAX with Having?
-- It first groups the data and then does a filter on the result of group by 

SELECT department_id, MAX(salary) AS highest_salary FROM employees 
GROUP BY department_id 
HAVING MAX(salary) > 60000;

-- same as 
select * from ( SELECT department_id, MAX(salary) AS highest_salary FROM employees 
GROUP BY department_id) t
where t.highest_salary>6000;


-- #  MAX with calculation? 
-- 	Returns the Maximum Salary after incrementing by 10% 

SELECT MAX(salary* 1.1) AS max_adjusted_salary FROM employees;

-- it is better than the above query
SELECT MAX(salary)*1.1 AS max_adjusted_salary FROM employees; 

-- This will also produce the same result. 
-- 2nd one will perform better as we are not incrementing to every record

-- #  MAX with DISTINCT 
-- This produces the same result as without DISTINCT 


SELECT MAX(DISTINCT salary) AS max_unique_salary FROM employees; 

-- Equivalent to

select max(distinct(salary)) from employees;

select * from employees e ;

-- # MAX with Window 
SELECT emp_name, department_id, salary,  
	MAX(salary) OVER (PARTITION BY department_id) AS max_salary_in_department
FROM employees; 

-- # Another Example with Student Table 
-- Lets create a student table and insert some records into it. 
-- Lets insert records in such a way that every student has scored highest mark in one of the subject 
-- and No student has scored highest in all the subject. 

CREATE TABLE student_marks 
( roll_number VARCHAR(50), 
	student_name VARCHAR(50), 
	student_subject VARCHAR(50),
	student_marks INT CHECK (student_marks <= 100) 
);
	
-- Step 2: Insert 9 records into the 'student_marks table
 INSERT INTO student_marks 
 (roll_number, student_name, student_subject, student_marks) 
 VALUES 
 (1, 'Aarav', 'Physics', 92), 
 (1, 'Aarav', 'Chemistry', 81),
 (1, 'Aarav', 'Mathematics', 95),
(2, 'Ananya', 'Physics', 76),
(2, 'Ananya', 'Chemistry', 88),
(2, 'Ananya', 'Mathematics', 87),
(3, 'Aditya', 'Physics', 89), 
(3, 'Aditya', 'Chemistry', 78), 
(3, 'Aditya', 'Mathematics', 100); 


select * from student_marks;
 

SELECT roll_number, student_name, student_subject, student_marks, 
 MAX(student_marks) OVER (PARTITION BY student_subject) AS max_marks_in_subject 
from  student_marks;


-- MAX with other columns 
select emp_name, MAX(salary) from employees; -- doesnot work 

select emp_name, GREATEST (salary,0) from employees; 

-- MAX with CASE STATEMENT 
# handling the columns value using case
SELECT department_id, 
MAX(CASE WHEN department_id > 101 THEN salary END) AS highest_manager_salary 
FROM employees 
group by department_id; 

SELECT department_id, 
MAX(CASE WHEN department_id >101 THEN salary else -1 END) AS highest_manager_salary 
FROM employees group by department_id; 

-- MAX with where condition?
select department_id,max(salary) 
from employees 
where emp_name is not null 
group by department_id having max(salary)> 60000;

-- Having vs Where? 
-- Where is used before aggregate function is executed to filter unwanted data.
-- Lets take the below example where if Name is NULL, then we will call it bad data.

-- In this case, if you run the query without where dause, every dept will give you 150000 as max salary. 
select department_id,max(salary) from employees
group by department_id;

-- However, you know those records with NULL names are invalid.
-- So use where clause to filter the data before you even aggregate.

select department_id,max(salary) from employees 
where emp_name is not null 
group by department_id; 

-- Further, if you wish to apply a condition on the result of the above query, 
-- then you can use having clause. 

select department_id,max(salary) from employees 
where emp_name is not null 
group by department_id 
having max(salary)> 60000;

-- Scenario 										Query Example
-- Find the highest salary							SELECT MAX(salary) FROM employees;
-- Latest hire date 								 SELECT MAX(hire_date) FROM employees;
-- Highest salary per department 					MAX(salary) WITH GROUP BY
-- Maximum after a condition 						MAX() WITH WHERE 
-- Maximum in a partition  						 MAX() OVER (PARTITION BY department)


-- ## SUM() 
-- Syntax: SUM([DISTINCT] expr) [over_clause] 
SELECT SUM(salary) AS total salary FROM employees; 

-- SUM with Where 
SELECT SUM(salary) AS total_salary 
FROM employees 
WHERE department_id = 101; 

-- SUM with nested 
select sum(salary) as total_salary from 
( SELECT salary from employees 
	where department_id=101 ) e;

-- SUM with groupby
SELECT department_id, SUM(salary) AS total_salary 
FROM employees 
GROUP BY department_id; 

-- SUM() with Calculations. It adds 2000 to each row. 
SELECT SUM(salary + 2000) AS total_compensation 
FROM employees;

-- SUM() with DISTINCT 
SELECT SUM(DISTINCT salary) AS total_unique_salary 
FROM employees;

-- Using SUM() with HAVING Clause 
SELECT department_id, SUM(salary) AS total_salary 
FROM employees 
GROUP BY department_id 
HAVING SUM(salary) > 100000; 

-- Achieving the same result without Having (Nested Query) 
select * from ( SELECT department_id, SUM(salary) AS total_salary 
				FROM employees GROUP BY department_id )e 
where e.total_salary>100000;



-- Sum with Conditional Logic 
-- Give me the total_salary I pay to all departments except 101
SELECT SUM(CASE WHEN department_id != 101 THEN salary ELSE 0 END) AS total manager_salary 
FROM employees;

select sum(salary) from employees where department_id = 101; 

SELECT department_id,SUM(CASE WHEN department_id != 101 THEN salary ELSE 0 END) AS total manager_salary 
FROM employees 
group by department_id;

-- SUM WITH WINDOW 
SELECT emp_name, salary, department_id, SUM(salary) OVER (PARTITION BY department_id) AS running_total FROM employees; 


-- ## AVG([Distinct] expr) [over_clause]: 
-- Returns the average value of expr.
-- The DISTINCT option can be used to return the average of the distinct values of expr. 

-- AVG finds the average of all the salaries. 
SELECT AVG(salary) AS avg_distinct_salary 
FROM employees; -- 58571.428571

-- AVG DISTINCT first gets the distinct salaries and then does average on the distinct salaries. 
SELECT AVG(DISTINCT salary) AS avg_distinct_salary FROM employees; -- 60000 

-- Department wise Average Salary
 SELECT department_id, AVG(salary) AS avg_distinct_salary 
 FROM employees 
 group by department_id; 
 
-- AVG with Where 
Select department_id,avg(salary) 
from employees 
where salary>=50000 
group by department_id; 

-- AVG with Having 
Select department_id,avg(salary)
from employees 
group by department_id
having avg(salary)>=50000; 

select department_id,avg(salary) 
from employees 
where salary>=50000 
group by department_id 
having avg(salary)>50000;

-- Query with Over(): 
-- Find department wise employee Average Salary 

SELECT employee_id, department_id, salary,AVG(salary) OVER (PARTITION BY department_id) AS avg_salary_per_department 
FROM employees;

-- Note: You cannot use distinct with Over Window Function. 
SELECT employee_id, department_id, salary, AVG(distinct salary) OVER (PARTITION BY department_id) AS avg_salary_per_department 
FROM employees;


-- ## COUNT(expr) [over_clause]: 
-- It is used to count the number of rows in a table or the number of non-NULL values in a column. 
-- Count All Rows
 SELECT COUNT(*) AS total rows FROM employees; 
 
-- Count Specific Rows with WHERE Clause 
SELECT COUNT(*) AS well paid count FROM employees WHERE salary > 50000; -- 4 

-- Count on NULL Data columns. 

select count(emp name) from employees; -- 4 

-- If your table has a row will all null values then select count(*) still gives you a perfect count. Count Unique Values only. 
select count(department_id) from employees; -- 7


select count(distinct department_id) from employees; -- 3 

-- Count Rows Grouped by Another Column 
-- Give me Department wise total employee count. 
SELECT department id, COUNT(*) AS employee_count 
FROM employees 
GROUP BY department_id; 

-- Count with Condition on Count 
SELECT department id, COUNT(*) AS employee_count 
FROM employees 
GROUP BY department_id 
HAVING COUNT(*) >= 3; 

-- This retrieves departments that has atleast 3 employees 

-- Note: 
-- HAVING is used to filter the data based on the output of Group by and hence used with Group by.
-- WHERE is used to filter the data before Group by to remove all unwanted data first. 

--		 Aspect 					WHERE  										HAVING
-- 		Timing 					Filters rows before grouping 				Filters rows after grouping. 
-- 		Scope 					Works on individual rows (raw data). 		Works on grouped/aggregated data.
-- 		Aggregate Functions     Cannot use aggregate functions directly  	Can use aggregate functions. 
-- 		Usage 					Used without or with GROUP BY  				Typically used with GROUP BY

-- Can we have both together? 
SELECT department_id, COUNT(*) AS employee_count 
FROM employees 
where emp name is not null 
GROUP BY department_id 
HAVING COUNT(*) > 1; -- 1012 

-- Another Similar Query
 SELECT department_id, SUM(salary) AS total_salary 
FROM employees 
WHERE salary > 30000 
GROUP BY department_id 
HAVING SUM(salary) > 120000; 

-- Count with Order by 
SELECT department_id, COUNT(*) AS employee_count 
FROM employees 
GROUP BY department_id 
ORDER BY employee_count DESC;

-- Count with OVER() (Window Function) 
SELECT employee_id, department_id, COUNT(*) OVER (PARTITION BY department_id) AS total_in_department 
FROM employees;


-- Count All Rows in a Subquery: 
SELECT COUNT(*) AS high_earning_employees 
FROM ( SELECT employee_id 
		FROM employees 
		WHERE salary > 50000) AS subquery; 
		

-- Difference between count(column) and count(*)? 
-- Count(*) returns the count of total records including NULL Values. 
-- Count(column) returns the count of total records that has not-null Values for the particular column. 

-- Difference between count(*) and count(1)? 

SELECT COUNT(*) FROM EMPLOYEES; -- 7 
SELECT COUNT(1) FROM EMPLOYEES; -- 7 
SELECT COUNT(2) FROM EMPLOYEES; -- 7 
SELECT COUNT(200) FROM EMPLOYEES; -- 7 
select count("Hello") from employees; 

-- It is believed that count(1) performs faster than count(*) as there is no involvement of column name in the first case. 
-- But this is not true anymore. In any latest database, both gives us the same efficiency.


-- Explain the below query 
select count(1) from employees; 

-- This is equivalent to 
select count(*) from ( select 1 from employees)e; 

-- It emits 1 for every row in employees table and then counts the total number of 1 

Explain select count(2) from employees;
-- This is equivalent to 
select count(*) from ( select 2 from employees)e;

-- It emits 2 for every record and then when we count total number of such 2,
-- it will still produce the same output as select count(1) from employees;

-- Explain the below query 
select count("Hello") from employees; 

-- This is equivalent to 

select count(*) from ( 
			select "Hello" from employees) e;
			
-- This emits Hello for every rows of employee and then counts the total records formed


-- ## GROUP_CONCAT: 
-- It is used to concatenate values from a group into a single string, with values separated by a default comma or a custom separator.
-- It is commonly used with the GROUP BY clause. 
SELECT department_id, GROUP_CONCAT(emp_name) AS employees 
FROM employees 
GROUP BY department_id;

-- You can also use the custom separator 
SELECT department_id, GROUP_CONCAT(emp_name SEPARATOR '|') AS employees 
FROM employees 
GROUP BY department_id;


-- Find out Department Wise Salaries 
SELECT department_id, GROUP_CONCAT(salary SEPARATOR ', ') AS salaries 
FROM employees 
GROUP BY department_id;


-- We can also remove any Duplicate occurances if any by using DISTINCT 
SELECT department_id, GROUP_CONCAT(DISTINCT salary SEPARATOR ' ') AS salaries 
FROM employees GROUP BY department_id;

-- You can also Order the values while Grouping 
SELECT department_id, GROUP_CONCAT(DISTINCT salary ORDER BY salary DESC SEPARATOR' | ') AS employees 
FROM employees GROUP BY department_id;

-- Controlling the Length of the String 
SET SESSION group_concat_max_len = 100; 

SELECT department_id, GROUP_CONCAT(DISTINCT salary ORDER BY salary DESC SEPARATOR' | ') AS employees 
FROM employees GROUP BY department_id;


-- Using GROUP_CONCAT() with a WHERE Clause. 
-- It filters first and then GROUP_CONCAT() would happen on the result. 
SELECT department_id, GROUP_CONCAT(emp_name) AS employees 
FROM employees 
WHERE salary > 50000 
GROUP BY department_id;


-- Filtering Concatenated Values 
SELECT department_id, GROUP_CONCAT(CASE WHEN salary > 30000 THEN emp_name END) AS high_earners
FROM employees GROUP BY department_id;

-- ## JSON_ARRAYAGG: 
-- This function is powerful for converting relational data into a JSON structure directly in MySQL
--  without requiring additional processing in the application layer.
-- In case you wish to get the list of all the employees name in a JSON array,
--  we can use JSON_ARRAYAGG function to achieve the same. 
-- Lets take this example 

-- 		1. List all the employees in a json array 
	SELECT JSON_ARRAYAGG(emp_name) AS employee_names FROM employees; 

-- 2. Group all the employee name department wise and then group them. 
SELECT department_id, JSON_ARRAYAGG(emp_name) AS employees FROM employees 
GROUP BY department_id;


-- 3. You can also order your data within the json in ascending or descending order using subquery technique.
 SELECT JSON_ARRAYAGG(emp_name) AS ordered_employee_names 
FROM ( SELECT emp_name 
		FROM employees 
		ORDER BY emp_name desc ) AS sorted_employees;

-- ## JSON_OBJECTAGG: 
-- It allows us to extract the data as key value pair. 
SELECT JSON_OBJECTAGG(employee_id, emp_name) AS employee_json FROM employees;


SELECT department_id, JSON_OBJECTAGG(employee_id, emp_name) AS employee_json 
FROM employees GROUP BY department_id;

-- Sorting Keys? 
-- Mysql doesnot support sort by on JSON_OBJECTAGG or JSON_ARRAYAGG directly and you need to use sub-queries in case you wish to sort the key. 

SELECT department_id, JSON_OBJECTAGG(employee_id, emp_name) AS employee_json 
FROM ( SELECT employee_id, emp_name, department_id FROM employees ORDER BY department_id, employee_id ) AS sorted_employees 
GROUP BY department_id;


SELECT JSON_ARRAYAGG(JSON_OBJECT('Product', Product, 'Quantity', Quantity)) AS Product_Quantities FROM Sales;














