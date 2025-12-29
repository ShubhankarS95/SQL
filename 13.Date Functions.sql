-- ##  Date Functions

-- MySQL provides several useful date functions that allow you to manipulate and retrieve date and time data

-- We have 5 datatypes to support date and time in mysql.
--		 1. DATE: 
--				a. Stores date values in the format YYYY-MM-DD (e.g., '2024-10-22'). 
--				b. Range: 1000-01-01 to 9999-12-31 
--				C. Used when you need to store only the date without a time component. 
--		 2. DATETIME: 
--				a. Stores date and time values in the format YYYY-MM-DD HH:MM:SS 
--				b. Range: 1000-01-01 00:00:00 to 9999-12-31 23:59:59 (e.g., '2024-10-22 10:30:00') 
--				C. Suitable when you need precise date and time without timezone handling.
--		 3. TIMESTAMP:
--				 a. Similar to DATETIME, but it includes time zone conversions. 
--				 b. Range: 1970-01-01 00:00:01 UTC to 2038-01-19 03:14:07 UTC. 
--				 c. Automatically updated to the current date and time if not specified, depending on settings. 
-- 				 d. Often used for tracking record creation or modification times.
-- 		4. TIME: 
--				 a. Stores time values in the format HH:MM:SS (e.g., '10:30:00').
--				 b. Range: -838:59:59 to 838:59:59 (can store negative values, useful for representing time differences). 
--				C. Useful for recording time intervals or standalone times without a date. 
--		5. YEAR: 
--				a. Stores a year in either two-digit or four-digit format (e.g., '2024'). 
--				b. Range: 1901 to 2155 (or 1970 to 2069 if using 2 digits). 
--				c. Useful for recording years without specific dates or times. 

-- https://dev.mysql.com/doc/refman/8.4/en/date-and-time-functions.html 


CREATE TABLE emp1( dob1 DATE, dob2 DATETIME, dob3 TIMESTAMP, dob4 TIME, dob5 YEAR);


insert into emp1 values('2024-10-22', '2024-10-22 10:30:00', '2024-10-22 10:30:00', '10:30:00', '2024');
insert into emp1 values (CURDATE(),NOW(),NOW(),NOW(),NOW());
insert into emp1 values (NOW(),NOW(),NOW(),NOW(),NOW());
insert into emp1 values (CURDATE(),NOW(),CURRENT_TIMESTAMP(), CURTIME(),YEAR(NOW()));
insert into emp1 values (CURDATE(),NOW(),UTC_TIMESTAMP(), CURTIME(), YEAR(NOW()));



-- 1. NOW[[fsp]):
--	   LOCALTIME, LOCALTIME([fsp]) 
--     LOCALTIMESTAMP, LOCALTIMESTAMP([fsp]) 
--     CURRENT_TIMESTAMP, CURRENT_TIMESTAMP([fsp]) 
--   Returns the current date and time as a value in YYYY-MM-DD hh:mm:ss' or YYYYMMDDhhmmss format,
--   depending on whether the function is used in string or numeric context. The value is expressed in the session time zone.


 SELECT NOW(); 			-- 2024-10-27 13:45:52
 SELECT NOW() + 0; 		-- 20241027134603 
 SELECT NOW(0) + 0; 	-- 20241027134703
 SELECT NOW (2) + 0; 	-- 20241027134724.15 
 SELECT NOW (6); 		-- 2024-11-09 10:14:55.208841 
 SELECT NOW (6) + 0; 	-- 20241109101357.924960 
 SELECT NOW (7) + 0; 	-- Error All of the above function can be used in place of another.
  
 -- [fsp] is the optional parameter that can be used to specify the number of digit after.
 
  SELECT NOW(),  -- 2024-12-16 10:32:53
 	LOCALTIME,	-- 2024-12-16 10:32:53
 	LOCALTIME(3), 	-- 22024-12-16 10:32:53.629
 	LOCALTIMESTAMP, -- 2024-12-16 10:32:53
 	LOCALTIMESTAMP(3), -- 2024-12-16 10:32:53.629
 	CURRENT_TIMESTAMP,  --  2024-12-16 10:32:53
 	CURRENT_TIMESTAMP(3);  -- 2024-12-16 10:32:53.629
 	
SELECT NOW(); -- 2024-10-23 15:26:56
 SELECT NOW(3); -- 2024-10-27 12:42:05.234 
 
 
 -- ## 2. SYSDATE([fsp]): 
 -- Returns the current date and time as a value in 'YYYY-MM-DD hh:mm:ss' or YYYYMMDDhhmmss format,
 --  depending on whether the function is used in string or numeric context.
 -- fsp: fractional seconds precision from 0 to 6. It returns the time at which it executes. 
 
 SELECT SYSDATE(); -- 2024-11-09 08:28:21 
 SELECT SYSDATE()+0;  -- 20241109082839 
 SELECT SYSDATE(), SYSDATE (3), SYSDATE()+3; -- 2024-11-09 08:29:32       2024-11-09 08:29:32.157        20241109082935 
 
 -- Now() vs SYSDATE():
 -- Now() returns a constant time that indicates the time at which the statement began to execute. 
 -- (Within a stored function or trigger, NOW() returns the time at which the function or triggering statement began to execute.) 
 -- This differs from the behavior for SYSDATE(), which returns the exact time at which it executes. 
 SELECT NOW(), SLEEP(2), NOW(): -- 2024-10-27 08:02:47      0      2024-10-27 08:02:47 
 SELECT SYSDATE(), SLEEP(2), SYSDATE(); -- 2024-10-27 08:04:33    0      2024-10-27 08:04:35
 	
 	
-- ## 3. CURDATE()/CURRENT_DATE()/CURRENT_DATE:
--  Returns the current date as a value in 'YYYY-MM-DD' or YYYYMMDD format,
-- depending on whether the function is used in string or numeric context. 
SELECT CURDATE(), CURRENT_DATE(),CURRENT_DATE; -- 2024-12-16	2024-12-16	2024-12-16 
SELECT CURDATE()+0, CURRENT_DATE()+0, CURRENT_DATE+0; -- 20241216	20241216	20241216


-- ## 4. CURTIME(fsp)/CURRENT_TIME(fsp)/CURRENT_TIME: 
-- Returns the current time as a value in 'hh:mm:ss' or hhmmss format, 
-- depending on whether the function is used in string or numeric context.
-- The value is expressed in the session time zone.
--  If the fsp argument is given to specify a fractional seconds precision from 0 to 6,
-- the return value includes a fractional seconds part of that many digits.

 SELECT CURTIME(), CURRENT_TIME(),CURRENT_TIME; -- 10:40:30	10:40:30	10:40:30

SELECT CURTIME()+0, CURRENT_TIME()+0,CURRENT_TIME+0; -- returns BIGINT 130024	130024	130024 
SELECT CURTIME(3), CURRENT_TIME(3)+0; --  08:18:10.230 81810.230 


--  ##  5. DATE(expr): 
-- Extracts the date part from a DATETIME or TIMESTAMP value. 
SELECT DATE('2024-10-22 10:30:00'); -- Returns '2024-10-22 


-- ## 6. DAY(date)/DAYOFMONTH(date) Returns the day of the month for date, 
-- in the range 1 to 31, or O for dates such as '0000-00- 00' or '2024-00-00' that have a zero day part.Returns NULL if date is NULL. 

SELECT DAYOFMONTH ('2024-10-27'); -- 27 
SELECT DAY('2024-10-27');-- 27 
SELECT DAYOFMONTH('2024-10-00'); -- 0 
SELECT DAY('2024-10-00'); -- 0
 SELECT DAYOFMONTH('2024-10-32'); -- NULL


-- ## 7. DAYNAME(): 
-- Returns the name of the weekday for date.
 SELECT dayname('1989-01-25'); -- Wednesday 

 
-- ## 8. DAYOFWEEK(date):
--  Returns the weekday index for date (1 = Sunday, 2 = Monday, ..., 7 = Saturday).
--  These index values correspond to the ODBC standard. Returns NULL if date is NULL. 
SELECT DAYOFWEEK('2024-11-09'); -- 7 



-- ## 9. DAYOFYEAR(date): 
SELECT DAYOFYEAR('2024-10-27'); -- 301 


-- ## 10. EXTRACT(unit FROM Date): 
-- Extracts a specific part of the date (like year, month, day). 
SELECT EXTRACT(YEAR FROM '2024-10-22'); -- 2024 
SELECT EXTRACT(MONTH FROM '2024-10-22'); -- 10 
SELECT EXTRACT (DAY FROM '2024-10-22'); -- 22 
SELECT EXTRACT(HOUR FROM '2024-10-22 01:02:03'); -- 1 
SELECT EXTRACT (MINUTE FROM '2024-10-22 01:02:03'); -- 2

SELECT EXTRACT (SECOND FROM '2024-10-22 01:02:03'); -- 3
 SELECT EXTRACT(YEAR_MONTH FROM '2024-10-22 01:02:03'); -- 202410
 
 SELECT EXTRACT(DAY_MINUTE FROM '2024-10-22 02:40:03'); -- 220240 -HHMM 
 SELECT EXTRACT(MICROSECOND FROM '2019-07-02 01:02:03.000456'); -- 456 
 SELECT EXTRACT(QUARTER FROM '2024-10-22 01:02:03'); -- 4 
 SELECT EXTRACT(YEAR FROM NOW()); -- 2024 
 SELECT EXTRACT(MONTH FROM NOW()); -- 11 
 SELECT EXTRACT(DAY FROM NOW()); -- 9 
 
 -- Interval expr Unit: Expr is the quantity, Unit are like HOUR, DAY, or WEEK
-- 		unit Value			Expected expr Format
-- 		MICROSECOND			MICROSECONDS
-- 		SECOND				SECONDS
-- 		MINUTE				MINUTES
-- 		HOUR				HOURS
-- 		DAY					DAYS
-- 		WEEK				WEEKS
-- 		MONTH				MONTHS
-- 		QUARTER				QUARTERS
-- 		YEAR				YEARS
-- 		SECOND_MICROSECOND	'SECONDS.MICROSECONDS'
-- 		MINUTE_MICROSECOND	'MINUTES:SECONDS.MICROSECONDS'
-- 		MINUTE_SECOND		'MINUTES:SECONDS'
-- 		HOUR_MICROSECOND	'HOURS:MINUTES:SECONDS.MICROSECONDS'
-- 		HOUR_SECOND			'HOURS:MINUTES:SECONDS'
-- 		HOUR_MINUTE			'HOURS:MINUTES'
-- 		DAY_MICROSECOND		'DAYS HOURS:MINUTES:SECONDS.MICROSECONDS'
-- 		DAY_SECOND			'DAYS HOURS:MINUTES:SECONDS'
-- 		DAY_MINUTE			'DAYS HOURS:MINUTES'
-- 		DAY_HOUR			'DAYS HOURS'
-- 		YEAR_MONTH			'YEARS-MONTHS'

 
--  11. FROM_DATE(N):
 -- Given a day number N, returns a DATE value. Returns NULL if N is NULL. 
 -- the base date used by the FROM_DAYS() function is '0000-00-00'. 
 -- This base date is a hypothetical zero date (not a real date) and represents a starting point from which day counts can be calculated. 
 SELECT FROM_DAYS(730669); -- 2000-07-03 	
 -- 2000 365 Days + 500 Leap years+ few more days 
 
 
 -- ## 12. HOUR(time): 
 -- Returns the hour for time. 
 -- The range of the return value is 0 to 23 for time-of-day values.
 --  However, the range of TIME values actually is much larger, so HOUR can return values greater than 23.
 -- Returns NULL if time is NULL 
 
 SELECT HOUR('10:05:03');  -- 10 
 SELECT HOUR('272:59:59'); -- 272 
 SELECT HOUR(now());       -- 11 as current time is 11:15 
 
 
 -- ## 13. MINUTE(time): 
 -- Returns the minute for time, in the range 0 to 59, or NULL if time is NULL.
  SELECT MINUTE('2008-02-03 10:05:03'); -- 5 
  SELECT MINUTE(NOW()); -- 17 
  
  
  -- ## 14. SECOND(time):
  --  Returns the second for time, in the range 0 to 59, or NULL if time is NULL. 
  SELECT SECOND('10:05:03'); -- 3 
  SELECT SECOND('2024-02-03 10:05:05'); -- 5
 
  
  - ##15. MICROSECOND(expr): 
  -- Returns the microseconds from the time or datetime expression expr as a number in the range from 0 to 999999. Returns NULL if expr is NULL. 
  SELECT MICROSECOND('12:00:00.123456'); -- 123456 
  SELECT MICROSECOND('2019-12-31 23:59:59.000010'); -- 10 
  SELECT MICROSECOND('12:00:00'); --0 
  SELECT MICROSECOND(NOW()); --0
  SELECT NOW(6), MICROSECOND (NOW(6)); -- 2024-11-09 11:20:12.142916 142916 
  
  -- ## 16. MONTH(date): 
  -- Returns the month for date, in the range 1 to 12 for January to December,
  -- or O for dates such as '0000-00-00' or '2008-00-00' that have a zero month part.
  -- Returns NULL if date is NULL.
   SELECT MONTH('2024-02-03'); -- 2
  
  
  -- ## 17. ΜΟΝΤΗΝΑME(date):
  --  Returns the full name of the month for date. 
  SELECT MONTHNAME('2024-02-03'); -- February
  
  
 -- ## 18. QUARTER(date): 
 --  Returns the quarter of the year for date, in the range 1 to 4, or NULL if date is NULL. 
 -- Jan-Mar => 1 Apr-June=>2 July-Sep=>3 Oct-Dec=>4 
 SELECT QUARTER('2024-04-01'); -- 2 
 
 -- ## 19. LAST_DAY(date): 
 -- Takes a date or datetime value and returns the corresponding value for the last day of the month.
 --  Returns NULL if the argument is invalid or NULL.
  SELECT LAST_DAY('2024-02-05'); -- 2024-02-29 
  SELECT LAST_DAY('2024-02-05'); -- 2024-02-29 
  SELECT LAST_DAY('2024-01-01 01:01:01'); -- 2024-01-31 
  SELECT LAST_DAY('2024-03-32'); -- [NULL]
  SELECT LAST_DAY("2024-03-32"); -- [NULL] 
SELECT LAST_DAY('2024-02-30'); -- NULL 
SELECT LAST_DAY(NOW()); -- NULL
  
  
  
  -- ## 20. WEEK(date[, mode]) 
  -- returns the week number for date. 
  SELECT WEEK ('2024-11-26'); -- 47 
  SELECT WEEK('2024-12-28'); -- 51 
  SELECT WEEK('2024-12-30'); -- 52 
  SELECT WEEK('2024-12-31'); -- 52 
  
  -- The two-argument form of WEEK() enables you to specify whether the week starts on Sunday or Monday and 
  -- whether the return value should be in the range from 0 to 53 or from 1 to 53. 
  
  SELECT WEEK('2024-11-15', 0) AS Week_Mode_0,
		 WEEK('2024-11-15', 1) AS Week_Mode_1, 
   		WEEK('2024-11-15', 2) AS Week_Mode_2,
		 WEEK('2024-11-15', 3) AS Week_Mode_3;
 -- 45 46 45 46 
 
-- Examples of mode values: 
	-- 	0: Week starts on Sunday, week 1 is the first week with a Sunday in it. 
	-- 	1: Week starts on Monday, week 1 is the first week with a Monday in it. 
	--  2: Week starts on Sunday, week 1 is the first week with at least 4 days in it.
	--  3: Week starts on Monday, week 1 is the first week with at least 4 days in it. 
	-- 4 to 7: Similar to the above but with different starting days and week definitions. 
	
-- The following table describes how the mode argument works.
--  Mode	First day of week	Range	Week 1 is the first week …
-- 0			Sunday			0-53	with a Sunday in this year
-- 1			Monday			0-53	with 4 or more days this year
-- 2			Sunday			1-53	with a Sunday in this year
-- 3			Monday			1-53	with 4 or more days this year
-- 4			Sunday			0-53	with 4 or more days this year
-- 5			Monday			0-53	with a Monday in this year
-- 6			Sunday			1-53	with 4 or more days this year
-- 7			Monday			1-53	with a Monday in this year
	
		
-- For mode values with a meaning of "with 4 or more days this year," weeks are numbered according to ISO 8601:1988:
--  If the week containing January 1 has 4 or more days in the new year, it is week 1.
--  Otherwise, it is the last week of the previous year, and the next week is week 1. 
SELECT WEEK('2024-02-20'); -- 7 
-- 1st January is Monday and has 6 days in the week.	

-- 21. WEEKDAY(date): 
-- Returns the weekday index for date (0 = Monday, 1 Tuesday, ... 6 = Sunday).
-- Returns NULL if date is NULL. 
SELECT WEEKDAY('2024-11-25 22:23:00'); -- 0 
SELECT WEEKDAY('2024-11-27'); -- 2 

-- ## 22. WEEKOFYEAR(date): 
-- Returns the calendar week of the date as a number in the range from 1 to 53.
--  Returns NULL if date is NULL.
 SELECT WEEKOFYEAR('2024-11-25'); -- 48 
 SELECT WEEKOFYEAR ('2026-12-30'); -- 53 
 -- There are 53 weeks in 2026 
 
 -- ## 23. YEAR(date): 
 -- Returns the year for date, in the range 1000 to 9999, or O for the "zero" date. 
 -- Returns NULL if date is NULL. 
 SELECT YEAR('2024-01-25'); -- 2024


-- ## 24. YEARWEEK(date, [Mode]):
--  Returns year and week for a date. 
-- The year in the result may be different from the year in the date argument for the first and the last week of the year.
--  Returns NULL if date is NULL. 
SELECT YEARWEEK('2024-12-30'); -- 202452 
SELECT YEARWEEK('2024-01-30'); -- 202404





