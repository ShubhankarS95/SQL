-- ## String Functions:
-- 1. ASCII(str)/ORD (str): 
-- Returns the ASCII CODE of 1st character of the String or 1st digit of a number
 SELECT ASCII('A'); -- 65 
 SELECT ASCII('apple'); -- 97 
 SELECT ORD('apple'); -- 97 
 SELECT ASCII(1); -- 49 
 SELECT ASCII(10); -- 49
 SELECT ORD(10); -- 49 
 
 -- ## 2. BIN(str): 
 -- Returns the Binary value of String. 
 -- The String should be a valid number 
 SELECT BIN ('9'); -- 1001 
 SELECT BIN('A'); -- 0 
 SELECT BIN(10); -- 1010 
 
 -- ## 3. BIT_LENGTH(Str): 
 -- returns the length of a string in bits 
 SELECT BIT_LENGTH('MySQL'); -- 40 
 
 -- MySQL is of 5 character. Each character needs 1 byte. 8 character needs 5 byte. 1 byte 8 bit, 5 byte=40 bit. 
 SELECT BIT_LENGTH(10); -- 16 
 
 -- since it is 2 character 
 
 -- ## 4. CHAR(val1, val2, val3...val N): 
 -- The CHAR() function in MySQL returns the character(s) corresponding to the given ASCII (or Unicode) values.
 -- You can pass multiple integer values, and the function will return a string composed of the characters that correspond to those values.
  SELECT CHAR(77, 89, 83, 81, 76); -- MYSQL 
  
  -- ## 5. CHAR_LENGTH(str) / CHARACTER_LENGTH(str): 
  -- Returns the length of the string in characters. 
 select CHAR_LENGTH("Hello"); -- 5 
 select CHARACTER_LENGTH("Hello"); -- 5 
 select CHAR_LENGTH(""); -- 3 
 select CHARACTER_LENGTH(""); -- 3 
 select CHAR_LENGTH(""); -- 9 
 
 -- ## 6. LENGTH()/OCTET_LENGTH() 
 -- Returns the length of the string in bytes. 
 SELECT LENGTH("OLC"); -- 3 
 SELECT LENGTH("0"); -- 9 
 -- it needs 9 bytes to store

SELECT OCTET_LENGTH(""); -- 9 

-- ## 7. CONCAT(str1, str2, ...): 
-- Concatenates two or more strings. 
-- Syntax: CONCAT(string 1, string2, ..., stringN) Example:
SELECT CONCAT('Hello', '', 'World'); -- Hello World 
select CONCAT("Mr ",ename) from emp; 
select CONCAT("Mr ","",ename) from emp; 
select CONCAT(ename,",", ifnull(job,''),",", ifnull(deptno,'')) from emp;


-- ## 8. CONCAT_WS():
--  Concatenates strings with a separator. 
-- Syntax: CONCAT_WS(separator, string1, string2, ..., string N) 
-- It works even for integers. 
SELECT CONCAT_WS('-', '25', '01','1989'); -- 25-01-1989 
SELECT CONCAT_WS('-', '25', "01", 1989); -- 25-01-1989 
SELECT CONCAT_WS('-', 25,01,1989); -- 25-1-1989 
-- Note: How it gave 1 instead of 01 for Integer. 

-- ## 9. ELT(index, String 1, String2,String3): 
-- The ELT() function returns the string at the specified index from a list of strings. 
-- The index is 1-based, meaning that the first string in the list corresponds to index 1. 
SELECT ELT(2, 'MySQL', 'PostgreSQL', 'SQLite'); -- PostgreSQL 
SELECT ELT(5, 'Apple', 'Banana', 'Cherry'); -- [NULL] 0,-ve index will return you [NULL] 

-- ## 10. EXPORT_SET():
-- The EXPORT_SET() function in MySQL returns a string representation of a binary number,
-- where each bit in the binary number is mapped to a specific set of strings. 
-- This is useful when you want to visualize or represent a binary value using custom strings. 
-- Syntax: EXPORT_SET(bits, on_string, off_string, [separator], [number_of_bits]} 
-- bits: The integer value whose bits will be evaluated. 
-- on_string: The string to use for each bit that is set to 1. 
-- off_string: The string to use for each bit that is set to 0.
-- separator (optional): A string to separate the on_string and off_string values in the result.The default is a comma (,). 
-- number_of_bits (optional): The number of bits to evaluate. By default, all bits of the integer are evaluated.
 SELECT EXPORT_SET(5, 'Y', 'N', ',', 3); -- Y,N,Y 
 
 -- 5 in binary is 101. 
 -- The first bit (1) is mapped to 'Y', 
 -- the second bit (0) is mapped to 'N', and so on.
 -- The result is 'Y,N,Y' based on 3 bits.
 
 
SELECT EXPORT_SET(5, 'Y', 'N', ',', 4); -- Y ,N,Y,N
SELECT EXPORT_SET(5, 'Y', 'N', ',', 4); -- y,n,y,n 
-- 5-> 101 -> YNY 
-- 4 character 1010-> YNYN 

-- Note: It has appended 0 at the end making it 1010 and no 0101 
SELECT EXPORT_SET(5, 'Y', 'N', ',', 10); 
-- Note: It probably is a bug.
SELECT EXPORT_SET(9, 'Yes', 'No', '', 4); -- YesNoNoYes 

-- 9 in binary is 1001. For each bit, 'Yes' represents 1 and 'No' represents 0, with the separator set to '|'. 
SELECT EXPORT_SET(9, 'Yes', 'No', '|', 3); -- Yes|No|No 

SELECT EXPORT_SET(5, 'T', 'F', '', 2); --TF
-- You demanded 2 character and the firat2 characters are preted. 
SELECT EXPORT_SET(6, '1', '0'); 

-- Output: 64 Bit Representation.
0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

-- 6 is 110, which is converted to 4 digit 0110 and then filled up with remaining 600's

--##  11. FIELD(value, value1, value2, ..., valueN) 
-- The FIELD() function in MySQL returns the index (position) of a value in a list of values.
-- It returns O if the value is not found.
-- The index is 1-based, meaning that the first item in the list has an index of 1. 
SELECT FIELD('PostgreSQL', 'MySQL', 'PostgreSQL', 'SQLite'); -- 2 
SELECT FIELD('Oracle', 'MySQL', 'PostgreSQL', 'SQLite'); -- 0 
SELECT FIELD(3, 1, 2, 3, 4, 5); -- 3 

-- Update emp table, set one job to ALLEN.
-- UPDATE scala_training.emp	SET job='ALLEN' 	WHERE empno=2001;

select FIELD('ALLEN',ename ,job) as Present, ename ,job from emp;
-- It returned 2 as ALLEN is present in 2nd column. 
-- It returned 1 as ALLEN is present in 1st column. 

select * from ( select FIELD ('ALLEN', ename, job) as present, ename, job from emp) t where present!=0 ;
 
-- ## 12. FIND_IN_SET(str, list):
-- Returns the position of a string within a list of strings. 
SELECT FIND_IN_SET('b', 'a,b,c'); -- 2

SELECT FIND_IN_SET('b', 'abc'); -- 0 
SELECT FIND_IN_SET('b', 'a','b','c'); -- syntax error
 SELECT FIND_IN_SET('b', 'abc,b'); --2
 
 -- ## 13. FORMAT(number, d): 
 -- Formats a number as a string with a specific number of decimal places. 
 -- It rounds off if required. It returns String and not Number. 
 SELECT FORMAT(12345.6789, 2); -- 12,345.68 
 SELECT FORMAT (12345.6749, 2); -- 12,345.67 
 SELECT FORMAT (12345.6719, 2)+2; -- 12,345.67 => 12+2=14, 
 
 -- 12,345 is converted to numeric, it got only 12 as it could not process, and hence 12+2=14 
 
 -- ## 14. TO BASE64(): 
 -- The TO_BASE64() function in MySQL encodes a given string into Base64 format.
 --  Base64 encoding is a method for encoding binary data into an ASCII string format. 
 -- It is often used to encode binary data, such as images or other files, into a format that can be easily transmitted or stored. 
 SELECT TO_BASE64('Hello World'); -- 'SGVsbG8gV29ybGQ= 
 
 -- ## 15. FROM_BASE64(): 
 -- The FROM_BASE64() function in MySQL decodes a base-64 encoded string and returns the original string.
 --  Base-64 encoding is commonly used to encode binary data into an ASCII string format,
 --  and this function helps convert the encoded format back to its original binary data or text. 
 SELECT FROM_BASE64 ('SGVsbG8gV29ybGQ='); -- Hello World


 
-- ## 16. HEX(String): 
-- converts a string or a numeric value to its hexadecimal representation.
-- It can be used with both string and numeric inputs, producing different results depending on the input type.
-- In Hexadecimal, 0-9 are represented as it is. 10-A 11-B 12-C 13-D 14-E 15-F 

 SELECT HEX("A"); -- 41 
 -- Unicode(A)= 65 Hex(65)= 41 4*161 +1*16° = 16|65|1 4 
 SELECT HEX("OLC"); -- 4F4C43 
 -- Unicode(0)= 79 Hex(79)= 4F 4*16+15*1 Unicode(L)=76. Hex(76)=4C Unicode(C)=67 Hex(67)=43

-- ## 17. UNHEX(String):
--  is used to convert a hexadecimal value into its corresponding string representation, treating each pair of hexadecimal digits as a character. 
SELECT UNHEX("4F4C43"); - -OLC 

-- ## 18. INSERT(original_string, start_position, length, insert_string)
--  allows you to insert a substring into a string at a specified position. 
-- You can also use it to replace a portion of a string with another substring. 
-- 1. original_string: The string in which the substring will be inserted or replaced. 
-- 2. start_position: The position in the original_string where the replacement or insertion begins (1- based index). 
-- 3. length: The number of characters in the original_string to be replaced. 
-- If length is 0, no characters are replaced, and insert_string is just inserted at the position. 
-- 4. insert_string: The substring that will be inserted or replace part of the original_string. 
SELECT INSERT('Hello World', 7, 0, 'MySQL '); -- Hello MySQL World 

-- At 7th Position, it will insert MySQL. Since length=0, no character is replaced. 
SELECT INSERT('Hello World', 7, 1, 'MySQL '); -- Hello MySQL orld
 
-- At 7th Position, it will insert MySQL, It will also replace 1 character i.e., W 
SELECT INSERT('Hello World', 7, 5, 'MySQLOLC'); -- Hello MySQLOLC 
  
-- At 7th Position, it will insert MySQLOLC, it should replace 5 characters as well. 
SELECT INSERT('Hello World', 7, 4, 'AB'); -- Hello ABd 
  
-- At 7th Position, insert AB. It should impact 4 character from the Source string hence rl is removed.
-- If we specify the index that doesnot exist, it doesnot impact as shown below. 
SELECT INSERT('Hello World', 15, 4, 'AB'); -- Hello World 

-- ## 19. INSTR(str, substr): 
-- Returns the position of the first occurrence of a substring within a string. They are not case sensitive. 
SELECT INSTR('Hello World', 'World'); -- 7,pos starts at 1 

SELECT INSTR('Hello World', 'OLC'); -- 0 
SELECT INSTR('Hello World', 'world'); -- 7 
SELECT INSTR('Hello World', 'WORLD'); -- 7 
-- It is recommended to convert both String into Lower or Upper and then compare 
SELECT INSTR(LOWER('Hello World'), LOWER('WORLd'));
SELECT ename, INSTR (ename, LOWER('ghimire')) from emp;
 

-- ## 20. LCASE(str)/LOWER(str)
-- It converts a string to lowercase 
SELECT LCASE('Hello World'); -- Returns 'hello world'
SELECT LOWER ('Hello World'); -- Returns 'hello world' 
SELECT LOWER (ename) from emp; 


-- ## 21. UCASE(Str)/UPPER(str):
-- Converts a string to uppercase. 
SELECT UCASE('Hello World'); -- Returns 'HELLO WORLD' 
SELECT UPPER('Hello World'); -- Returns 'HELLO WORLD' 

-- ## 22. LEFT(str, len): 
-- Returns the leftmost len characters of a string. 
SELECT LEFT('Hello World', 5); -- Hello 
SELECT LEFT('Hello World',-1); -- Empty 
SELECT LEFT('Hello World', 10); -- Hello Worl

SELECT LEFT('Hello World', 15); -- Hello World 

-- ## 23. RIGHT(str, len): 
-- Returns the rightmost len characters of a string. 
SELECT RIGHT('Hello World', 5);  -- Returns 'World' 
SELECT RIGHT('Hello World', -3); -- Empty 
SELECT RIGHT('Hello World', 15); -- Hello World 

-- ## 24. LOAD_FILE(File_Path):
-- reads the contents of a file and returns it as a string. 
-- Make sure you pass full path of the file and the file has read permission. 
-- mkdir /tmp/
-- vim/tmp/readme.txt --add something in this file, add 2-3 lines. 
-- sudo find / -name "my.cnf" 


-- ## 25. LOCATE(substr,str):
--  Similar to INSTR, It finds the First occurrence of a substring. 
-- Here the first parameter is substring, not str. 
-- It can also take additional parameter which can be used to search for other position. 
-- Syntax: LOCATE(substring, string, [start_position])

SELECT LOCATE('World', 'Hello World World'); -- 7 
SELECT LOCATE('World', 'Hello World World', 8); -- 13 
-- It is not case sensitive 
SELECT LOCATE('World', 'Hello WORID World'); -- 7 
-- Trying to pass 0,-ve value will give you O as output. 
SELECT LOCATE('World', 'Hello World World',0); -- 0 


-- ##  26. LPAD(str, len, pad): 
-- Pads the string on the left with another string to a specified length. 
-- The 2nd parameter is desired length of the output.
-- The 3rd parameter is the character that should be padded.
 SELECT LPAD('123', 5, '0'); -- 00123 
 SELECT LPAD('123', 6, '*'); -- ***123 
 SELECT LPAD('123', 2, '*'); -- 12 
 
 
 --## 27. RPAD(str, len, pad):
 -- Pads the string on the right with another string to a specified length. 
 SELECT RPAD('123', 5, '0'); -- 12300 
 SELECT RPAD('123', 5, "%"); -- 123%% 
SELECT RPAD('123', 2, '*'); -- 12 

-- ## 28. TRIM(str): 
-- Removes leading and trailing spaces from a string. It doesn't remove any spaces that is present within the word.

select trim(" Hello World "); -- Hello World 
 

-- ## 29. LTRIM(Str): 
-- Removes leading spaces from a string ie remove from the Left Side. 
select ltrim(" Hello World "); -- Hello World <Spaces>  -- doesn't remove the right side spaces


-- ## 30. RTRIM(str): 
-- Removes Trailing spaces from a string i.e., remove from the Right Side. 
select rtrim(" Hello World "); -- <Spaces>Hello World -- doesn't remove the left side spaces


-- ## 31. MAKE_SET(bits, str1, str2, ..., strN): 
-- returns a set (a comma-separated string) consisting of the elements that have their corresponding bits set in the binary representation of a given number. 
--     bits: This is the number that will be analyzed to check which bits are set to 1.
--     str1, str2, strN: These are the strings that correspond to each bit position in the number. 

--        The last String represents the first bit, 2nd Last string


SELECT MAKE_SET(5, 'a', 'b', 'c', 'd'); -- a,с           101 
SELECT MAKE_SET(7, 'a', 'b', 'c', 'd'); -- a,b,c         111 
SELECT MAKE_SET(15, 'a', 'b', 'c', 'd'); -- a,b,c,d     1111 
SELECT MAKE_SET(16, 'a', 'b', 'c', 'd'); -- No Output  10000 000001 
SELECT MAKE_SET(16, 'a', 'b', 'c', 'd','e'); -- 10000 
SELECT MAKE_SET(25, 'a', 'b', 'c', 'd', 'e'); -- 11001 -- ade 
SELECT MAKE_SET(26, 'a', 'b', 'c', 'd','e'); -- 11010 -- bde 


-- ## 32. MATCH(): 
-- The MATCH() function in MySQL is used to perform full-text searches. 
-- It searches for text within text-based columns in a table.

--  Syntax: MATCH (column1, column2, ...) AGAINST (expression [search_modifier]) 
--			column1, column2, ...: The columns that contain the text you want to search. 
--			expression: The string you want to search for. 
--			search_modifier: You can specify how the search should be conducted, 
--							such as IN NATURAL LANGUAGE MODE, IN BOOLEAN MODE, or WITH QUERY EXPANSION. 

--	Please enable Full Text Search on the columns where you wish to do a search. 

ALTER TABLE emp ADD FULLTEXT (ename,job); -- This does the exact match.

select * FROM emp WHERE MATCH (ename, job) AGAINST ('ALLEN' IN NATURAL LANGUAGE MODE); 


-- ## 33. OCT()
-- This gives you Octal equivalent of a Number.
 SELECT OCT(10); -- 12 
 
 
 -- ## 34. POSITION(substring IN string): 
 -- Returns the position of a substring in a string. 
 SELECT POSITION ('World' IN 'Hello World'); -- 7 
 
 
 -- ## 35. QUOTE(String): 
 -- used to return a string that is properly escaped for use in SQL statements. 
 -- This function is particularly useful for ensuring that strings are safe to include in queries,
 --  helping to prevent SQL injection attacks and ensuring that special characters are correctly handled. 
 
 SELECT QUOTE("Hello, World!") AS quoted_string; -- 'Hello, World!'
 --  also handles special characters by escaping them 
 SELECT QUOTE("It's a great day!") AS quoted_string; -- 'It\'s a great day!"



-- ## 36. SUBSTRING/SUBSTR/ MID (str, start, length): 
-- Returns a substring from the string. Index starts at 1. 
-- Returns 5 characters from 1st 
SELECT SUBSTRING('Hello World', 1, 5); -- Returns 'Hello' 
SELECT SUBSTR('Hello World', 1, 5); 
SELECT MID('Hello World', 1, 5); 

SELECT SUBSTRING('Hello World', 4, 4); -- lo W 
-- Return 2 characters from The last 5 characters. 

SELECT SUBSTRING('Hello World', -5, 2); -- Wo 
SELECT SUBSTRING('Hello World', -3, 2); -- rl 
-- Return 4 characters from The last 5 characters. 
SELECT SUBSTRING('Hello World', -5, 4); -- Worl

-- ## 37. REPEAT(String, Number): 
-- Repeats a string a given number of time. 
 SELECT REPEAT("OLC ",3); -- OLC OLC OLC


-- 38. REPLACE(str, find, replace):
--  Replaces all occurrences of a substring with another substring.
 SELECT REPLACE('Hello World', 'World', 'OLC'); -- Hello OLC 
 SELECT REPLACE('Hello World', 'world', 'OLC'); -- Hello World 
 SELECT REPLACE('Hello World', '',''); -- Hello World 
 
-- 39. REVERSE(str):
-- Reverses the characters in a string. 
SELECT REVERSE('Hello'); -- olleH 
-- Let's put some of the Functions together 

SELECT CONCAT('First Name: ',UPPER('john')) AS full_name, 
	LENGTH('Hello World') AS length,
TRIM(' Leading and trailing spaces ') AS trimmed_string, 
REPLACE('Hello World', 'World', 'MySQL') AS replaced_string;


-- 40. STRCMP(String1, String2): 
-- used to compare two strings. 
-- It returns an integer value indicating the result of the comparison.
--  It is case Insensitive, which means apple and aPPLE is treated as same. 
-- Return Values Returns O if the two strings are equal. 
-- Returns a positive value if string 1 is greater than string2.
-- Returns a negative value if string1 is less than string2. 
SELECT STRCMP('apple', 'banana') AS comparison1, 
STRCMP('banana', 'apple') AS comparison2,
STRCMP('apple', 'apple') AS comparison3; -- 1,1,0 
-- This is case-insenstive. Which means apple and APPLE are treated same. 

SELECT STRCMP ('Apple', 'aPPLE'); -- 0
 SELECT STRCMP('cat', 'Dog'); -- -1 = 99 
 -- D-68 
 -- Dog is converted to lowercase and become dog Now the comparing would be cat,
 -- dog Unicode of c=99 Unicode of d=100,
 --  Hence - ve. 
 
 SELECT STRCMP('Apple', 'Zanana') AS comparison1,    -- -1
 STRCMP('banana', 'apple') AS comparison2,			-- 1
STRCMP('apple', 'apple') AS comparison3,			-- 0
STRCMP('Apple', 'aPPLE') AS comparison4,			-- 0
STRCMP('ball', 'balo') AS comparison4,				-- -1
STRCMP('bal', 'balo') AS comparison5,				-- -1 
STRCMP('balo', 'bal') AS comparison6, 				-- 1
STRCMP('cat', 'Dog') AS comparison7; 				-- -1

-- Select All Employees, whose name= smith 

select * from emp where STRCMP (ename, 'smith')=0;


-- ## 41. SPACE(number):
-- Returns a string of spaces of a specified length. 
SELECT SPACE(5); -- returns 5 spaces 
SELECT CONCAT('Suraz', SPACE(5), 'OLC'); -- Suraz OLC 
SELECT CONCAT(ename, SPACE(5), job) FROM emp; 

-- ## 42. SUBSTRING_INDEX (String, Delimiter, Count): 
-- It splits the string by delimiter and return total number of elements specified by count. 
-- This function is useful for extracting parts of a string based on a specific separator. 
--  string: The original string from which you want to extract the substring.
--  delimiter: The delimiter used to split the string. 
--  count: The number of occurrences of the delimiter to consider. This can be positive or negative: 
--			A positive value returns the substring from the left of the specified delimiter.
-- 		    A negative value returns the substring from the right. 1 -1


-- Split the String by, and return 1st element 
SELECT SUBSTRING_INDEX('apple, banana, cat', ',', 1) AS result; -- apple 

-- Split the String by, and return 1st 2 element 

SELECT SUBSTRING_INDEX('apple, banana, cat', ',', 2) AS result; -- apple, banana 

-- Split the string by, and return the last element 
SELECT SUBSTRING_INDEX('apple, banana, cat',',', -1) AS result; -- cat 

-- Split the string by, and return the last 2 element 

SELECT SUBSTRING_INDEX('apple, banana, cat',',',-2) AS result; -- banana,cat 

-- What if we pass 0? 
-- If we pass 0 in the 3rd parameter, it will return Nothing as you demanded for O element. 
SELECT SUBSTRING_INDEX('apple, banana, cat', ',', 0) AS result; 

-- What if delimiter is not found? 
-- It will return entire string. The 3rd parameter does not have any role here.

SELECT SUBSTRING_INDEX('apple, banana, cat', '|', 2) AS result; 

-- What if the count exceeds the number of delimiters? 
-- If the count is equal to or greater than number of delimiters, it will return the whole String.
 SELECT SUBSTRING_INDEX('apple, banana, cat', ',', 3) AS result; 

 SELECT SUBSTRING_INDEX('apple, banana, cat', ',', 4) AS result; 
-- Be cautious with the count parameter, especially when using negative values, to ensure you get the desired part of the string.




