--# Basics of MySQL

--* Create: It is used to create database object like table, view, sequence, indexes

--- Creating a Database
--	Database is the collection of all the tables, views,sequences,ind exes.
--	We can use any of the below command to create a database.

	CREATE DATABASE sql_training;
	CREATE SCHEMA sql training2;

--- Drop Database
--	In case you wish to drop the database, you can use the below command to drop the database.
--	
--	DROP SCHEMA 'sql_training2;  -- in postgres Sql
	drop database sql training2;

--- Recommendation:
--
--	* Use CAPITAL letters to represent commands
--	* Use small letters to represent variables like tablename, column name.
--	* Use _ to separate 2 words. Use emp_name instead of empName



--- Creating a Table:
--	For creating the table, table must have atleast one columns.
--	
--	Syntax:
--	CREATE TABLE table_name(
--		coll__name datatype(size),
--		col2_name datatype(size),
--	...
--	colN_name datatype(size)
--	);

	Create table employee(
	id int,
	name varchar(100),
	salary float (10,2) );

select * from employee;
--- To see the Table description that we can created recently
  
  DESC employee;


-- # Altering the Table:
--   Alter can be used to change the structure of existing table. 
--   It supports 3 subcommands 
--	1. ADD
--	2. Modify 
--	3. DROP

--  If you wish to add column. 
ALTER TABLE scala_training.employee ADD aadhar_no varchar(12) NULL; 

-- add: It is used to add columns into the existing table. 
alter table employee add aadhar_number varchar(12); 

-- You can add more columns, by just separating them by, 

alter table employee add ( 
	pan_number varchar(10), 
	desg varchar(10) ); 

-- Modify: 
-- It is used to change the column datatype or column datatype size only.

ALTER TABLE employee MODIFY id TEXT; -- changing datatype 

alter table employee modify pan_number varchar(15); -- changing datatype size 

-- You can't use modify to modify 2 column at once.
alter table employee modify ( id INT, pan_number varchar(20) );


-- Drop:
-- It is used to drop column from the TABLE

alter table employee drop column pan_number; -- dropping 1 column 

-- Trying to drop the column that doesnot exist will give you the below error 
-- SQL Error [1091] [42000]: Can't DROP COLUMN `pan_number'; check that it exists 

-- You cant use drop to drop 2 column at the same time. 

alter table employee drop column (salary, desg); -- doesn't work 

-- Note: You cannot drop all the columns of a table using drop command. Eg:


Create table employee1( id int );

alter table employee1 drop column id; 

-- SQL Error [1090] [42000]: You can't delete all columns with ALTER TABLE; use DROP TABLE instead.
 
-- ## Dropping Objects: 
-- It is used to remove database object from database. 

-- In all RDBMS, we are allowed to drop only 1 database object at a time.
-- You can use Drop to drop table, view, INDEXES, STORED PROCEDURE using the below syntax. 
-- Drop table table_name;
-- Drop view view_name; 
-- Drop table employee; 

-- Truncating a table 
-- This command will remove all rows from table_name efficiently, 
-- It doesnot delete the table but just removes all the data from it. 

Truncate table employee; 

-- ## Renaming a table: 
 rename table employee1 to employee;


-- ## Renaming a Column:
ALTER TABLE employee CHANGE EMP_ID id text; 

-- Please note: The column type is mandatory here, even if you wish to keep it same. 
-- This will change the column name along with the datatype. 

ALTER TABLE employee CHANGE id emp_id int;





