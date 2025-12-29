-- ##(DATA Manupulating language)DML statements:

-- Let's create a database and use that before we move to DML statements. 
-- Let's do it UI Way Open Terminal and type the below code highlighted in Light Blue.

-- mysql> CREATE DATABASE IF NOT EXISTS olc_training; 
-- mysql> show databases; 

-- list down all databases. 
-- mysql> use olc_training; 
-- mysql>show tables;

show tables;

-- ## INSERT: 
-- Is used to insert data into a table.
-- There are Several methods to insert data into a table. 

-- 1. Insert into... values...

 CREATE TABLE IF NOT EXISTS employee (
 id int, 
 name text, 
 salary int 
 );
 
 INSERT INTO employee VALUES(101, "Suraj", 5000);
 insert into employee values(102, "Suman", 6000); 
 
select * from employee; 

-- 2. Skipping Columns:
insert into employee(id, salary) values (103,7000); 

-- 3. Insert multiple rows at the same time. 

insert into employee values 
(103,'kiran', 7000), 
(104, 'Kumar',9000);

-- 4. Insert into ... set

insert into employee set id=105,name='karan';


-- 5. Insert into ... IGNORE 
-- If you want to insert a row but ignore the insertion
-- if a duplicate key error occurs (like if a PRIMARY KEY or UNIQUE constraint is violated),
-- you can use INSERT IGNORE. 

-- Create a new employee table with a primary key 

DROP TABLE EMPLOYEE;

CREATE TABLE employee ( 
id int primary key, 
name text, 
salary int ); 
insert into employee values (101,"Suraj", 5000); 

insert into employee (salary, id) 
values (7000,102); 

insert IGNORE into employee values (101, "Suraz", 6000);

-- Dealing with duplicate Inserts? 
-- Can I insert the row, if it does not exists or update the row, if it exists?
-- Yes, For that you need to have atleast 1 primary key, 
-- so that we can uniquely identify that record. 
-- Drop the previous employee table, if you have it.

CREATE TABLE employee ( 
id int primary key, 
name text, 
salary int
);

 insert into employee values (101, "Suraj", 5000);
insert into employee(id, salary) values (103,7000); 

select * from employee; 

-- inserts a new record as primary key is not found 

INSERT INTO employee (id, name, salary)
VALUES (102, 'Kiran', 9000) 
ON DUPLICATE KEY UPDATE name = VALUES(name), salary = VALUES(salary);

INSERT INTO employee (id, name, salary) 
VALUES (103, 'Suraz', 9000) 
ON DUPLICATE KEY UPDATE name = VALUES(name), salary = VALUES(salary); 

-- ## UPDATE:
-- It is used to change data within a table. 

update employee 
set salary=6000 
where name="Suraj"; 

update employee 
set salary=6000 
where name='Suraj';

-- Increment everyone's salary by 1000.
update employee set salary=salary+1000;


-- Multiple column update 
update employee set salary=7000, name='Suraz' where id=103; 

-- DELETE: 
-- Can be used to delete all the rows or particular row from the table.
-- delete from employee where id=101;

-- This deletes all the record from employee table.
 
delete from employee; 

-- Roll back the Transaction: 

START TRANSACTION; 

delete from employee where id=103; 

select * from employee;

-- If there is any issue 
ROLLBACK; 
select * from employee;
-- if everything is fine. 
commit;

-- ##Truncate vs delete
-- Delete is a DML command deletes the desired data from the table and are stored in a buffer,
-- which we can get back using ROLLBACK command. 
-- Truncate is a DDL command that deletes all the data from the table and 
-- we can never get back the data using rollback.


-- SELECT command:
-- It is used to fetch the data from database table. 
-- Almost all RDBMS supports this command. 

-- Syntax: 
-- SELECT (DISTINCT] column1, column2, ...
-- FROM table_name 
-- (WHERE condition] 
-- (GROUP BY column1, column2, ...] 
-- [HAVING condition] 
-- [ORDER BY column1 (ASC | DESC), column2 [ASC | DESC], ...] 
-- (LIMIT offset, row_count]; 

-- Example
SELECT DISTINCT name, age 
FROM students 
WHERE age > 18
GROUP BY age 
HAVING COUNT(*) > 2 
ORDER BY age DESC 
LIMIT 5;



-- Select command can be used to 

-- Select all cols and all rows
select * from employee; 

-- Select all cols and particular rows.
Select from employee where id=101; 

-- Select particular cols and all rows. 
Select name, age from employee; 

-- Select particular cols and particular rows. 
Select name, age from employee where dept='IT' 

-- CREATE table from existing table. 
-- You can also create a new table from the data based on existing table.
 SELECT * FROM EMPLOYEE; 

create table employee2 as select * from employee; 

select * from employee2; 
 

 create table employee3 as 
select id, name from employee2 
where name is not NULL;


-- ## Note: while copying a table from another table, 
--  constraints are never copied like primary key, foreign key... 

DROP TABLE EMPLOYEE; 

CREATE TABLE employee ( 
id int primary key,
name text, 
salary int );

insert into employee values 
(101,"Suraj", 5000);

insert into employee (id, salary)
values (103,7000); 

CREATE TABLE EMPLOYEE4 as
SELECT * FROM EMPLOYEE; 


DESC EMPLOYEE;

DESC EMPLOYEE4;

-- CREATING A NEW TABLE FROM EXISITING TABLE WITHOUT COPYING DATA:
-- Syntax:
-- CREATE TABLE <new table name> as 
-- select * from <existing table name> where <false condition>; 

-- You can use select with where condition and pass a false condition. 

 create table employee5 as 
 select * from employee where name='Hello'; 
 
select * from employee5; 

describe employee5; 

-- ## What is the output of the below code assuming employee table has 2 rows.
-- 
-- Create table emp2 as select null from employee;
-- 
-- Answer: new table will have 1 column as null, and it will have 2 null values inserted.





