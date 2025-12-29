-- CONSTRAINTS
--  constraints are rules enforced on table columns to ensure the validity, integrity, and consistency of the data stored in the database.
-- They define conditions that the data must meet and are used to restrict the type of data that can be inserted, updated, or deleted.

-- Key Features of Constraints: 
-- 1. Data Integrity: Ensure that only valid and consistent data is entered. 
-- 2. Data Accuracy: Restrict invalid or duplicate data. 
-- 3. Relationship Enforcement: Maintain relationships between tables. 

-- Types of Constraints in My SQL:
--  1. NOT NULL: Ensures that a column cannot have a NULL value.
--  2. UNIQUE: Ensures that all values in a column (or combination of columns) are unique. 
--  3. PRIMARY KEY: Combines UNIQUE and NOT NULL to uniquely identify each row in a table. 
--  4. FOREIGN KEY: Links two tables and enforces referential integrity. 
--  5. CHECK: Validates that a column's value satisfies a specific condition. 
--  6. DEFAULT: Assigns a default value to a column if no value is provided. 
--  7. AUTO_INCREMENT: Automatically generates unique numeric values for a column. 
--  8. ENUM: Restricts a column to predefined values. 
--  9. INDEX: Improves query performance by indexing a column (not strictly a constraint but related to data rules). 
-- 10. UNSIGNED: Restricts numeric columns to store only non-negative values.

-- NOT NULL: 
-- The NOT NULL constraint ensures that a column cannot have NULL values.
--  It is used to enforce that a column must always have a valid value, making it mandatory to provide a value when inserting or updating data. 

-- Key Features:
--  1. Prevents NULL Values: A column with the NOT NULL constraint cannot store NULL.
--  2. Ensures Data Completeness: Guarantees that essential data is always present. 
--  3. Applies at Column Level: Defined when creating or altering a table.

-- You can enforce NOT NULL constraint while creating a table as shown below.

drop table employees ;

-- 1. creating a table.

CREATE TABLE employees 
( id INT PRIMARY KEY, 
	name VARCHAR(100) NOT NULL, -- NOT NULL applied here 
	age INT
);

-- 2. When Altering a Table: 

ALTER TABLE employees MODIFY name VARCHAR(100) NOT NULL 

-- 3. Insert valid data into the above table 
INSERT INTO employees (id, name, age) VALUES (1, 'Suraj', 30); 

-- 4. Insert invalid data into the table 
INSERT INTO employees (id, age) VALUES (2,25); 
-- SQL Error [1364] [HY000]: Field 'name' doesn't have a default value 

-- 5. Removing NOT NULL Constraint:
-- In case you already have a table with NOT NULL Constraint applied and you wish to remove the constraints, you can use the below query
 show create table employees;

ALTER TABLE employees MODIFY name VARCHAR(100); 

show create table employees; 

-- In real world: You will have a client side validation as well. 

-- 3 Kind of Validation in real world example 
-- 1. Client side (UI) 
-- 2. Server Side(Spring Boot) 
-- 3. DB side (constraints) 

-- Naming Not Null Constraints: 
-- We cannot have a name for not null constraints directly. 
-- It needs to be declared inline.
--  We can use CHECK constraints along with is not null as shown below. 

 drop table users; 
 
 
 CREATE TABLE users ( 
 id INT PRIMARY KEY name VARCHAR(100),
 CONSTRAINT chk_name_not_null CHECK (name IS NOT NULL)
);

-- UNIQUE Constraints:
-- A Unique Key is a constraint in MySQL that ensures all values in a column (or combination of columns) are unique across the table. 
-- This prevents duplicate entries for the specified column(s), helping maintain data integrity.

--  Key Features: 
-- 1. Ensures Uniqueness: No two rows can have the same value in the unique key column(s). 
-- 2. Allows NULL Values: A column with a unique key constraint can store NULL, but only one NULL value is allowed.
-- 3. Multiple Unique Keys: A table can have multiple unique keys, unlike the primary key which is limited to one.

-- 1. Define a unique key while creating a table. 
CREATE TABLE users (
user id INT AUTO_INCREMENT PRIMARY KEY, 
email VARCHAR(255) UNIQUE, -- Unique constraint on 'email'
 username VARCHAR(50) UNIQUE -- Unique constraint on 'username' 
 );
 
-- Let's try to insert few records

insert into users (email, username) 
values("suraz.hadoop@gmail.com", 'suraz.hadoop'); 

select * from users; -- Both the below query will fail.

insert into users (email, username) values("suraz.hadoop@gmail.com", 'suraz_hadoop'); 
-- error 

insert into users (email, username) values("suraz_hadoop@gmail.com", 'suraz.hadoop'); 
-- error

-- 2. Define a Composite Unique Key:
-- Composite Unique key means the combination of 2 or more keys maintaining uniqueness.

CREATE TABLE orders ( 
order id INT, 
product_id INT, 
UNIQUE (order_id, product_id) -- Composite unique key 
);

insert into orders values (101,201); 
insert into orders values (101,201); -- error 
insert into orders values (101,202); 
insert into orders values (102,201);

-- 3. Add unique key with a name
 CREATE TABLE emp ( 
id INT NOT NULL,
email INT NOT NULL,
CONSTRAINT emp_email UNIQUE (email) 
);

-- 4. Add a Unique Key to an Existing Table: PLEASE NOTE: THIS CREATES AN INDEX users.unique_email 

drop table users;

CREATE TABLE users 
( user_id INT AUTO_INCREMENT PRIMARY KEY,
email VARCHAR(255) ,
username VARCHAR(50) UNIQUE -- Unique constraint on 'username' 
);

ALTER TABLE users ADD CONSTRAINT unique_email UNIQUE (email); 


-- 5. Removing a Unique Key Let's check the unique key name using below query.
-- The unique key name is username 

SHOW CREATE TABLE users;

-- CREATE TABLE `users` 
-- ( `user_id` int NOT NULL AUTO_INCREMENT, 
-- `email` varchar(255) DEFAULT NULL,
-- username varchar(50) DEFAULT NULL,
-- PRIMARY KEY ('user_id'),
-- UNIQUE KEY 'email' ('email'),
-- UNIQUE KEY username (username),
-- UNIQUE KEY `unique_email ('email')
--  ) ENGINE=InnoDB AUTO_INCREMENT 4 DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_0900_ai_ci 


-- Note: You will also see these details under your index. 

-- 6. Drop the unique key
 ALTER TABLE users drop CONSTRAINT unique email; 
-- What will happen if we try to put unique constraint on a column that already has duplicate data

drop table users;

CREATE TABLE users 
( user_id INT AUTO_INCREMENT PRIMARY KEY,
	email VARCHAR(255),
	username VARCHAR(50) UNIQUE -- Unique constraint on 'username' 
);	
	
select * from users;

 insert into users (email,usemame) values("suraz.hadoop@gmail.com", 'suraz.hadoop');
 insert into users(email, username) values("suraz.hadoop@gmail.com".'suraz_hadoop');
 
 select * from users;

-- Note: entail has duplicates, username has unique records
 ALTER TABLE users 
 ADD CONSTRAINT unique_email UNIQUE (email);
 -- SQL Error [1062] [23000]: Duplicate entry 'suraz. hadoop@gmail.com' for key 'users. unique_email' 
 -- You will get an error. You should remove the duplicate on your own and then add the constraints.
 -- You can apply unique on those columns which has no duplicate data. 
 

-- ## PRIMARY key
-- is a constraint in MySQL that uniquely identifies each row in a table. 
-- It ensures that no two rows have the same value for the primary key column(s) and that the column cannot contain NULL values

--  Key Features of Primary Key: 
-- 1. Uniqueness: Ensures that all values in the primary key column(s) are unique.
-- 2. Not Null: Primary key columns cannot contain NULL values. 
-- 3. Single Primary Key per Table: A table can have only one primary key.
-- 4. Composite Primary Key: Can consist of one or more columns.


-- 1. Define a Primary Key When Creating a Table:
CREATE TABLE employees ( 
	emp_id INT PRIMARY KEY, -- Single-column primary key
	ame VARCHAR(100) 
);

-- 2. Composite Primary Key:
-- You can have more than 1 column combined together as a primary key.
 CREATE TABLE orders ( 
 order_id INT, 
 product_id INT, 
 PRIMARY KEY (order_id, product_id) -- Composite primary key 
 );

-- OR 

 CREATE TABLE orders 
 ( 
 	order_id INT, 
 	product_id INT,
 	CONSTRAINT pk_orders_order_id_product_id PRIMARY KEY (order_id, product_id)
 );	
 	
 -- 3. You can give a name to your Primary Key while creating the table 
 drop table employees;
  
 CREATE TABLE employees ( 
 emp_id INT name VARCHAR(100),
 CONSTRAINT pk_employees_emp_id PRIMARY KEY (emp_id)
 );

-- 4. Add Primary Key to existing table 
drop table employees; 
CREATE TABLE employees(
emp_id INT, 
name VARCHAR(100) );

ALTER TABLE employees 
ADD PRIMARY KEY (emp_id); 

-- Or 
ALTER TABLE employees 
ADD CONSTRAINT pk_emp_emp id PRIMARY KEY (emp id); 

-- Note: Naming does not work for naming primary key. 
-- You can confirm that by running 

show create table employees

-- This will never show pk_emp_emp_id 

-- 5. Drop Primary Key from existing table
ALTER TABLE employees 
DROP PRIMARY KEY;

describe employees; 

-- Create a table called user_courses such that no student can take same course twice.
-- Hint: user_id and course_id together should be a primary key. 
CREATE TABLE student_courses ( 
student_id INT, 
course_id INT, 
PRIMARY KEY (student_id, course_id) -- Composite primary key
);

-- Or You can do this 
drop table student_courses; 

CREATE TABLE student_courses ( 
student_id INT, 
course_id INT 
);


ALTER TABLE student_courses 
ADD CONSTRAINT pk_emp_emp_id PRIMARY KEY (student_id, course_id); 

show create table student_courses; 

-- Difference between Primary and Unique Keys.
-- FEATURE				primary key 					unique Key
--  Purpose 			Uniquely identifies a row 		Ensures unique column values
--  NULL Values 		Not allowed 					One NULL is allowed
--  Count Per Table 	Only one 						Multiple unique keys allowed 
 
 -- ## FOREIGN KEY: 
 -- is a constraint that establishes a relationship between two tables by linking a column in one table to the
 -- Primary Key or Unique Key column of another table. 
 -- It ensures referential integrity by preventing actions that would violate the relationship. 
 
--	 Key Features of FOREIGN KEY: 
-- 		1. Links Tables: Connects a child table to a parent table. 
--		2. Maintains Data Integrity: Ensures that the value in the foreign key column matches a value in the referenced column. 
--		3. Restricts Invalid Changes: Prevents deletion or updating of referenced data unless specified behavior (e.g., CASCADE, SET NULL) is defined.

--  Define a Foreign Key When Creating a Table:

drop table dept;
CREATE TABLE dept 
( 	dept_id INT PRIMARY KEY,
	dept_name VARCHAR(100)
);

CREATE TABLE EMP 
( EmpID INT PRIMARY KEY, -- Unique identifier for employees
 EmpName VARCHAR(100) NOT NULL, -- Name of the employee 
 DeptID INT, -- Foreign key referencing DEPT
  FOREIGN KEY (DeptID) REFERENCES dept(dept_id) 
);


-- You can also name the foreign key while creating the table 
drop table EMP 
CREATE TABLE EMP ( 
EmpID INT PRIMARY KEY, -- Unique identifier for employees 
EmpName VARCHAR(100) NOT NULL,-- Name of the employee
 DeptID INT, -- Foreign key referencing DEPT 
 CONSTRAINT fk_deptid FOREIGN KEY EY (DeptID) REFERENCES dept(dept_id)
);

SHOW CREATE TABLE EMP: 

-- Let's insert record in Parent first, followed by Child 
INSERT INTO DEPT (dept_id, dept_name) 
VALUES (1, 'Human Resources') ,
(2, 'Information Technology'),
(3, 'Finance'),
(4, "Marketing"), 
(5, 'Operations');

INSERT INTO EMP (EmpID, EmpName, DeptID) 
VALUES (101, 'Rajesh Kumar', 1), 
(102, 'Sneha Patil', 2), 
(103, 'Amit Shah', 3), 
(104, 'Priya lyer', 4),
(105, 'Manoj Singh', 5),
(106, 'Anjali Mehta', 2), 
(107, 'Vikram Reddy', 3), 
(108, 'Pooja Desai', 1),
(109, 'Arun Prakash', 4),
(110, 'Neha Gupta', 5);

-- What will happen if we try to delete 1 record from emp table?

delete from emp where empld=110;

-- This will work since employee is a child table.

-- What will happen if we try to delete 1 record from dept table?

 delete from dept where dept id=5;

-- This will throw us error, if there is any emp with dept_id=5
-- This will work, if there is no emp with dept_id=5


-- -- ## Cascade DELETE and Update:
-- If you delete any data from Primary table, then all records associated with that id will also be deleted from Child table.
-- If you want to cascade delete, You need to define the cascade at table level while creating table


drop table emp; 
-- drop child table first 
drop table dept; 
-- drop parent table next 

CREATE TABLE dept 
( 	dept_id INT PRIMARY KEY,
	dept_name VARCHAR(100) 
);

CREATE TABLE EMP 
( 
	EmpID INT PRIMARY KEY, -- Unique identifier for employees 
	EmpName VARCHAR(100) NOT NULL, -- Name of the employee 
	DeptID INT, -- Foreign key referencing DEPT 
	FOREIGN KEY (DeptID) REFERENCES DEPT(dept_id) 
	ON DELETE CASCADE 
	ON UPDATE cascade
);


INSERT INTO DEPT (dept_id, dept_name) 
VALUES (1, 'Human Resources'),
(2, 'Information Technology'),
(3, 'Finance'), (4, 'Marketing'),
(5, 'Operations');


INSERT INTO EMP (EmpID, EmpName, DeptID) 
VALUES (101, 'Rajesh Kumar', 1),
(102, 'Sneha Patil', 2),
(103, 'Amit Shah', 3),
(104, 'Priya lyer', 4),
(105, 'Manoj Singh', 5), 
(106, 'Anjali Mehta', 2), 
(107, 'Vikram Reddy', 3), 
(108, 'Pooja Desai', 1), 
(109, 'Arun Prakash', 4), 
(110, 'Neha Gupta', 5); 

select * from dept;

select * from emp;


delete from dept where dept id=5; 

-- This will also delete all employees who have dept_id=5 

update dept set dept_id=44 
where dept_name="Marketing";

select * from emp; 
-- all emp of dept 4 is changed to dept 44 
-- Delete Cascade: - Delete employees if the department is deleted Update Cascade: 
-- Update DeptID in EMP if it's changed in DEPT select from emp; 

select * from dept; 

update dept set DeptID=11 
where DeptID=1;

-- check emp table deptid also changed.


-- How to Add DELETE CASCADE on existing table 
-- 1. Remove Foreign Key
-- 2. Update Foreign Key and include delete cascade on it. 

drop table emp;
drop table dept;

CREATE TABLE dept ( 
dept_id INT PRIMARY KEY, 
dept_name VARCHAR(100) 
);


CREATE TABLE EMP ( 
EmpID INT PRIMARY KEY, -- Unique identifier for employees 
EmpName VARCHAR(100) NOT NULL, -- Name of the employee
 DeptID INT -- Foreign key referencing DEPT 
 FOREIGN KEY (DeptID) REFERENCES DEPT(dept_id) 
);
 

SHOW CREATE TABLE EMP;

SHOW CREATE TABLE DEPT;

ALTER TABLE EMP DROP FOREIGN KEY emp_ibfk_1; 

ALTER TABLE EMP 
ADD CONSTRAINT fk_emp_dept 
FOREIGN KEY (DeptID) REFERENCES DEPT(dept_id) 
ON DELETE CASCADE 
ON UPDATE CASCADE; 


-- Verify the changes 
SHOW CREATE TABLE EMP;


-- Add a Foreign Key to an Existing Table:
ALTER TABLE emp 
ADD CONSTRAINT fk_dept FOREIGN KEY (dept_id) REFERENCES dept(dept_id) 
ON DELETE CASCADE 
ON UPDATE cascade;

-- Can we have more than 1 FK in a table? 
-- Yes. 
-- course(id), user(id) (id columns are primary key in User and Course table) 
-- user_courses(user_id,course_id) (it will have user_id,course_id column which would be mapped to foreign key. 

-- Let's do some Practical.

CREATE TABLE user(
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL, 
email VARCHAR(255) NOT NULL UNIQUE,
phone VARCHAR(15),
gender ENUM('Male', 'Female', 'Other') 
);

CREATE TABLE courses( 
Id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT null
);

CREATE TABLE user_course ( 
ID INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
course_id INT NOT NULL,
FOREIGN KEY (user_id) REFERENCES user(id) 
ON DELETE cascade
ON UPDATE CASCADE,
FOREIGN KEY (course_id) REFERENCES courses(id) 
ON DELETE CASCADE 
ON UPDATE CASCADE 
);
-- Can I have foreign key on table with no Primary key?


-- CHECK Constraints: 
-- A check constraint ensures that a column's values meet a specific condition.
-- For example, you can enforce rules such as "Salary must be greater than 0" or "Age must be between 18 and 65." 
-- This helps maintain the integrity of the data in your database.

--  Check constraints can be defined: 
-- 1. At the Column Level (applied to a single column). 
-- 2. At the Table Level (applied to one or more columns). 

-- Applied to a Single Column 

CREATE TABLE Employee1 ( 
EmpID INT PRIMARY KEY, 
Age INT CHECK (Age >= 18 AND Age <= 65) ); 

-- Applied at table level.
CREATE TABLE Employee2 ( 
EmpID INT PRIMARY KEY, 
Age INT, 
Salary DECIMAL (10, 2),
CONSTRAINT chk_age_salary CHECK (Age >= 18 AND Salary > 0) ); 

-- We can add the constraint to an existing table as shown below
ALTER TABLE Employee 2 
ADD CONSTRAINT chk_age CHECK (Age >= 18 AND Age <= 65); 

show create table employee2;


-- We can remove the constraint from the table as shown below. 
ALTER TABLE Employee2 
DROP CONSTRAINT chk_age;

-- Check all Constraints added in your table. 
SELECT FROM information_schema.CHECK_CONSTRAINTS
WHERE CONSTRAINT SCHEMA = 'olc_training';

-- Let's do some examples together. drop table employee; 
CREATE TABLE Employee ( 
EmpID INT PRIMARY KEY, 
Name VARCHAR(100), 
Age INT CHECK (Age >= 18 AND Age <= 65),
Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
Salary DECIMAL(10, 2) CHECK (Salary > 0)
);

-- valid 
INSERT INTO Employee (EmpID, Name, Age, Gender, Salary) 
VALUES (1, 'Suraj Ghimire', 36, 'M', 5000.00);

-- invalid 
INSERT INTO Employee (EmpID, Name, Age, Gender, Salary) 
VALUES (2, 'Aayushman Ghimire', 70, 'M', 4000.00); 


-- ## DEFAULT:
-- The DEFAULT clause in MySQL is used to specify a default value for a column.
-- If no value is provided for the column during an INSERT operation, the column will automatically take the specified default value.

DROP TABLE EMP; 
CREATE TABLE EMP(
id INT PRIMARY KEY,
name VARCHAR(100),
age INT DEFAULT 25,
country VARCHAR(20) DEFAULT 'India',
is_graduate BOOLEAN DEFAULT true
);

show create table emp;
INSERT INTO EMP (id, name) VALUES (1, 'SURAJ GHIMIRE'); 
INSERT INTO EMP VALUES (2, 'AA YUSHMAN GHIMIRE'); -- You need to provide all values here 
INSERT INTO EMP (id) VALUES (2); 

select from emp; 

-- is_graduate will hold 0 or 1, where 1 is true, O is false.

-- We can modify an existing table and update the default constraints 
ALTER TABLE emp 
ALTER COLUMN age SET DEFAULT 30;
-- verify now 
show create table emp; 

-- Remove the existing default? 
ALTER TABLE Emp 
ALTER COLUMN age DROP default; 

-- Limitations: 
-- 1. You cannot use calculations in default as shown below

CREATE TABLE Logs 
( LogID INT PRIMARY KEY,
LogDate TIMESTAMP DEFAULT now()+1 
);
-- Or even something like this 

CREATE TABLE Logs 
( LogID INT PRIMARY KEY,
	LogDate INT DEFAULT 5+1 
);

-- 2. You can use the functions for example now() or constants like CURRENT_TIMESTAMP 

CREATE TABLE Logs 
( LogID INT PRIMARY KEY,
LoginDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
LogOutDate TIMESTAMP DEFAULT now() 
);

-- 3. Default Values with NULL: 
-- If a column has default value and if you provide NULL while inserting the records, 
-- it stores NULL provided the column supports that. 

-- How to see all the default value of a table. 

SHOW COLUMNS FROM Logs;

SELECT COLUMN NAME, COLUMN default
FROM information schema.COLUMNS 
WHERE TABLE NAME='Logs'; 


-- ## AUTO_INCREMENT:
--  The AUTO_INCREMENT attribute in MySQL automatically generates unique values for a column, usually used for primary keys.
--  It starts with a specified value (default is 1) and increments by 1 for each new row inserted.
--  You cannot have more than one AUTO_INCREMENT column in a table. If you delete rows, the gaps in AUTO_INCREMENT values cannot be reused automatically.
--  The AUTO_INCREMENT attribute can only be used with columns defined as: INT, TINYINT, SMALLINT, MEDIUMINT, BIGINT 
--  We cannot apply auto increment to any column that does not have unique or primary key 

CREATE TABLE Emp1 ( 
EmpID INT unique AUTO_INCREMENT,
Name VARCHAR(100),
Age INT
);

CREATE TABLE Emp2 (
EmpID INT primary key AUTO_INCREMENT, 
Name VARCHAR(100), 
Age INT
); 

-- The below query will not work 
CREATE TABLE Emp3 (
EmpID INT AUTO_INCREMENT,
Name VARCHAR(100),
Age INT
);

-- Error: Incorrect table definition; there can be only one auto column and it must be defined as a key
-- It finds the max value of the column to decide the next value.
--  Insert 2 records in emp1 table without specifying id. The id generated will be 1 and 2. 
-- Now insert 3rd record with id=100. Now insert 4th records without id, the id would be 101 and not 3


-- You can set the starting value for AUTO_INCREMENT:
 CREATE TABLE Emp4 ( 
EmpID INT AUTO_INCREMENT,
Name VARCHAR(100), Age INT,
PRIMARY KEY (EmpID) 
)AUTO_INCREMENT = 1001;

INSERT INTO EMP4 (name age) VALUES ('SURAJ GHIMIRE', 36);

ALTER TABLE Emp4 AUTO INCREMENT = 2000; 

INSERT INTO EMP4 (name age) VALUES ('SURAJ GHIMIRE', 36);

select * from emp4;
 
select * from emp4;


insert into emp4(name,age) values ("Kamal",32);
insert into emp4(name,age) values('Karan', 34);

select * from emp4;

insert into emp4 values (2001,'Karan', 34);

select * from emp4;
insert into emp4(name,age) values('vimal',29);

select * from emp4;

insert into emp4 values (101, 'Karan' 34); 

select * from emp4; 

insert into emp4 (name,age) values ('Sompal', 43);

select *  from emp4; -- 2003

-- Drop AUTO_INCREMENT:
-- To remove the AUTO_INCREMENT property from a column:
 ALTER TABLE emp4 
 MODIFY EmpID INT;
 
-- 	Add auto_increment to existing table 
ALTER TABLE emp4 
MODIFY EmpID INT AUTO_INCREMENT; 

-- Retrieve Last Inserted ID 

SELECT LAST_INSERT_ID();

-- You can change the incremental steps by using the system variable auto_increment_increment which defaults to 1.

SET @@auto_increment_increment = 2;

INSERT INTO EMP4 (name,age) VALUES ('SURAJ GHIMIRE',37); 
INSERT INTO EMP4 (name, age) VALUES ('SURAJ GHIMIRE',38); 

select * from emp4; 


-- When you delete all rows in a table (TRUNCATE TABLE), the sequence resets to 1 even if you have set AUTO_INCREMENT = 1001, while defining the table.
 TRUNCATE TABLE Emp4;
 
-- If you delete specific rows, the sequence continues from the last highest value. 
-- Deleted values are not reused. 
-- If you have id 1,3,5,7 and if you delete 5,7 and if you re-insert 2 records
-- Those new records will have id 9 11 and not 5 and 7 

-- ## ENUM: 
-- The ENUM data type is used to store a predefined list of allowed values for a column.
-- It is particularly useful when a column should only accept a limited set of values, such as Gender, Status, Category from a list of allowed values. 

-- An ENUM column can have a maximum of 65,535 distinct values.
-- Use ENUM for columns with a small, unchanging set of predefined values (e.g., status, gender, priority).

-- MySQL stores ENUM values internally as numeric indexes starting from 1.

-- For example, if an ENUM column is defined as 
-- ENUM('small', 'medium', 'large'): 
--	'small' is stored as 1 
--	'medium' as 2
--	'large' as 3 

-- Nulls are stored if the value is not provided, and a default value can also be set.

CREATE TABLE emp ( 
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL, 
gender ENUM('Male', 'Female', 'Other') NOT NULL,
status ENUM('Active', 'Inactive') DEFAULT 'Active'
);


 INSERT INTO emp(name, gender, status)
 VALUES ('Suraj', 'Male', 'Active'), 
 ('Aayushi', 'feMALE', 'Inactive'); 
 
 INSERT INTO emp(name, gender) 
 VALUES ('Kiran', 'Male'), 
('isha', 'feMALE'); 

select * from emp; 

-- Querying ENUM Values are in-case sensitive 

select * FROM emp WHERE gender = 'FeMaLE';

-- Modifying an ENUM Column 
-- Add a New Value: 

ALTER TABLE emp 
MODIFY COLUMN gender ENUM('Male', 'Female', 'Other', 'N/A'); 

-- Remove a Value: 
-- Redefine the column enum.
 ALTER TABLE mp MODIFY COLUMN gender ENUM('Male', 'Female');
 
show create table emp;

-- How enums are mapped to index 
SELECT gender, gender +0 AS gender_index FROM emp;


-- ## UNSIGNED:
--  The UNSIGNED attribute in MySQL is used to define a numeric column that only allows non-negative values.
-- By default, numeric types in MySQL are signed, meaning they can store both positive and negative values.
-- Using UNSIGNED increases the range of positive values a column can store, as it eliminates the need to reserve space for negative numbers.
-- Applies to Numeric Data Types: TINYINT, SMALLINT, MEDIUMINT, INT, BIGINT, DECIMAL, and FLOAT can be unsigned. 
-- It is not applicable to character data types (VARCHAR, CHAR, etc.). 
-- Expands Positive Range: By removing negative numbers, the range of positive values doubles compared to a signed type. 

Create table emp( Age tinyint unsigned) ; -- -128 0 to 127+128


-- Data Type 			Signed range											 	Unsigned Range 
-- TINYINT 			-128 to 127												 	0 to 255
-- SMALLINT   			-32.768 to 32.767											0 to 65,535
-- MEDIUM INT  		-8,388,608 to 8.388,607		 		 					 	0 to 16,777,215
-- INT					-2,147,483,648 to 2,147,483,647 	 					 	0 to 4,294,967,295 
-- BIGINT 			    -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 	0 to  18,446,744,073,709,551,615

CREATE TABLE products ( 
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
quantity INT UNSIGNED NOT NULL,
price DECIMAL(10, 2) UNSIGNED NOT null
);

-- id: Starts at 1 and only increases; negative values are not allowed.
--  AUTO_INCREMENT columns are often defined as UNSIGNED to maximize the positive range:
--  quantity: Cannot have negative values (e.g., stock levels). 
-- price: Cannot be negative; ensures no invalid negative pricing.


insert into products(quantity.price) values (5,1000);
insert into products(quantity,price) values(-5,2000);

-- SQL Error [1264] [22001]: Data truncation: Out of range value for column 'quantity' at row 1 
-- You can modify an existing column to make it unsigned:
 ALTER TABLE products 
 MODIFY quantity INT unsigned; 
 
-- If you attempt to insert a negative value into an UNSIGNED column, 
 -- MySQL will return an error: 
 -- If your data model might require negative values in the future, avoid UNSIGNED. 
 -- Ideal for fields where negative values don't make sense, such as id, quantity, price, or age.
 --  Only use UNSIGNED when you're certain the column will never need to store negative values.


-- Index in SQL:
-- An index in SQL is a database object that improves the performance of queries by enabling faster data retrieval.
-- Indexes are created on columns in a table and act like pointers to the rows, similar to an index in a book. 














