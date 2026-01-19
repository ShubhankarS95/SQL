use training;

create table table1
(
stud varchar(10),
marks varchar(10),
rank1 varchar(10),
dense_rank1 varchar(10)
);


insert into table1
(stud,marks,rank1,dense_rank1) values
("1","99","1","1"),
("2","95","2","2"),
("3","95","2","2"),
("3","95","2","2"),
("4","94","4","3"),
("4","94","4","3");

select * from table1;
truncate table table1;

select *, row_number() over(partition by stud,marks,rank1,dense_rank1 order by stud) as row_n
from table1


create table country
(
name varchar(20)
);


insert into country
values
("India"),
("Pakistan"),
("England"),
("New Zealand"),
("Australia");

select * from country
order by name;


SELECT c1.name AS team1, c2.name AS team2
FROM country c1
JOIN country c2
  ON c1.name < c2.name  -- ensures (A,B) appears, but not (B,A)
ORDER BY team1, team2;






create table weather
(id varchar(10),
recordDate varchar(20),
temperature int
);

insert into weather values
("1","2000-12-14",3),
("2","2000-12-16",5);

select * from weather;

WITH w AS (
  SELECT
    id,
    recordDate,
    LAG(STR_TO_DATE(recordDate, '%Y-%m-%d')) OVER (ORDER BY STR_TO_DATE(recordDate, '%Y-%m-%d')) AS prev_recordDate,
    temperature,    
    LAG(temperature) OVER (ORDER BY STR_TO_DATE(recordDate, '%Y-%m-%d')) AS prev_temperature
  FROM weather
)
select id,recordDate, prev_recordDate,datediff(str_to_date(recordDate,"%Y-%m-%d"),ifnull(prev_recorddate ,curDate())) as date_diff,
temperature ,prev_temperature,
 ifnull(temperature - lag(temperature) over(order by recordDate) ,-1) as diff
from w






-- Drop existing tables if they exist (optional, for clean re-runs)
DROP TABLE IF EXISTS Trips;
DROP TABLE IF EXISTS Users;

-- Create Users table
CREATE TABLE Users (
    users_id INT PRIMARY KEY,
    banned ENUM('Yes', 'No') NOT NULL,
    role   ENUM('client', 'driver', 'partner') NOT NULL
);

-- Create Trips table
CREATE TABLE Trips (
    id         INT PRIMARY KEY,
    client_id  INT NOT NULL,
    driver_id  INT NOT NULL,
    city_id    INT NOT NULL,
    status     ENUM('completed', 'cancelled_by_driver', 'cancelled_by_client') NOT NULL,
    request_at VARCHAR(10) NOT NULL,  -- kept as VARCHAR as per your spec (e.g., '2013-10-01')
    CONSTRAINT fk_trips_client FOREIGN KEY (client_id) REFERENCES Users(users_id),
    CONSTRAINT fk_trips_driver FOREIGN KEY (driver_id) REFERENCES Users(users_id)
);

-- Insert data into Users
INSERT INTO Users (users_id, banned, role) VALUES
(1,  'No',  'client'),
(2,  'Yes', 'client'),
(3,  'No',  'client'),
(4,  'No',  'client'),
(10, 'No',  'driver'),
(11, 'No',  'driver'),
(12, 'No',  'driver'),
(13, 'No',  'driver');

-- Insert data into Trips
INSERT INTO Trips (id, client_id, driver_id, city_id, status, request_at) VALUES
(1,  1,  10, 1,  'completed',            '2013-10-01'),
(2,  2,  11, 1,  'cancelled_by_driver',  '2013-10-01'),
(3,  3,  12, 6,  'completed',            '2013-10-01'),
(4,  4,  13, 6,  'cancelled_by_client',  '2013-10-01'),
(5,  1,  10, 1,  'completed',            '2013-10-02'),
(6,  2,  11, 6,  'completed',            '2013-10-02'),
(7,  3,  12, 6,  'completed',            '2013-10-02'),
(8,  2,  12, 12, 'completed',            '2013-10-03'),
(9,  3,  10, 12, 'completed',            '2013-10-03'),
(10, 4,  13, 12, 'cancelled_by_driver',  '2013-10-03');

select * from users

select * from trips

WITH not_banned as (
    SELECT users_id FROM users
    WHERE banned = 'No'
) 
SELECT
    request_at as Day,
    ROUND( SUM( CASE WHEN status LIKE 'cancelled%'
                     THEN 1.00
                     ELSE 0 END) / COUNT(*), 2)
    AS "Cancellation Rate"
FROM Trips
WHERE
    client_id IN (SELECT users_id FROM not_banned)
    AND driver_id IN (SELECT users_id FROM not_banned)
    AND request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY request_at






-- 1) Create the table
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id      BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    cust_id       INT NOT NULL,
    location      VARCHAR(50) NOT NULL,
    order_date    DATE NOT NULL,
    total_amount  DECIMAL(12,2) NOT NULL CHECK (total_amount >= 0),

    PRIMARY KEY (order_id),
    KEY idx_cust (cust_id),
    KEY idx_location (location),
    KEY idx_order_date (order_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 2) Insert sample data
-- Your given rows are included and preserved:
--  (cust_id=123, BLR, 2025-02-05, 1000)
--  (cust_id=231, PUNE, 2025-05-10, 5000)

INSERT INTO orders (cust_id, location, order_date, total_amount) VALUES
-- BLR - cust 123
(123, 'BLR', STR_TO_DATE('20240310','%Y%m%d'), 1200),
(123, 'BLR', STR_TO_DATE('20241201','%Y%m%d'),  800),
(123, 'BLR', STR_TO_DATE('20250205','%Y%m%d'), 1000),  -- provided
(123, 'BLR', STR_TO_DATE('20250820','%Y%m%d'), 1500),
-- BLR - cust 345
(345, 'BLR', STR_TO_DATE('20240520','%Y%m%d'),  700),
(345, 'BLR', STR_TO_DATE('20240621','%Y%m%d'),  700),
(345, 'BLR', STR_TO_DATE('20250105','%Y%m%d'),  900),
(345, 'BLR', STR_TO_DATE('20250615','%Y%m%d'),  600),
(345, 'BLR', STR_TO_DATE('20250710','%Y%m%d'), 1200),
-- BLR - cust 112
(112, 'BLR', STR_TO_DATE('20240812','%Y%m%d'),  300),
(112, 'BLR', STR_TO_DATE('20250222','%Y%m%d'),  300),
-- PUNE - cust 231
(231, 'PUNE', STR_TO_DATE('20240115','%Y%m%d'), 2000),
(231, 'PUNE', STR_TO_DATE('20241111','%Y%m%d'), 2500),
(231, 'PUNE', STR_TO_DATE('20250510','%Y%m%d'), 5000),  -- provided
-- PUNE - cust 567
(567, 'PUNE', STR_TO_DATE('20240202','%Y%m%d'), 1500),
(567, 'PUNE', STR_TO_DATE('20240909','%Y%m%d'), 1000),
(567, 'PUNE', STR_TO_DATE('20250303','%Y%m%d'), 1000),
(567, 'PUNE', STR_TO_DATE('20251212','%Y%m%d'), 1500),
-- HYD - cust 456
(456, 'HYD',  STR_TO_DATE('20240404','%Y%m%d'),  800),
(456, 'HYD',  STR_TO_DATE('20241010','%Y%m%d'),  900),
(456, 'HYD',  STR_TO_DATE('20250404','%Y%m%d'), 1000),
(456, 'HYD',  STR_TO_DATE('20251010','%Y%m%d'), 1100),
(456, 'HYD',  STR_TO_DATE('20251111','%Y%m%d'),  500),
-- DEL - cust 114
(114, 'DEL',  STR_TO_DATE('20240707','%Y%m%d'),  400),
(114, 'DEL',  STR_TO_DATE('20250707','%Y%m%d'),  300);

select * from orders;

-- *Find the top 5 customers based on number of orders
select cust_id,count(*) as count_orders
from orders
group by cust_id
order by count_orders desc
limit 5

-- *Find locationwise customers who spend the most

with cte as (
select location,cust_id,sum(total_amount) as total_amount
from orders
group by location,cust_id

)
select location,cust_id,total_amount from (
select location,cust_id, total_amount, 
dense_rank() over(partition by location order by total_Amount desc) as dn
from cte
) as t
where dn=1



-- * Find locations whose revenue has increased from last year's rervenue

with cte as (
select location, year(order_date) as order_year, sum(total_amount) as revenue
from orders
group by location,year(order_Date)
)

select location,order_year,
lag(order_year) over(partition by location order by order_year asc) as prev_year,
revenue,
lag(revenue) over (partition by location order by order_year asc) as prev_yr_revenue
from cte










use world;
select * from Country;


select continent, rank() over(partition by continent order by continent) as rank1,
dense_rank() over(partition by continent order by continent) as dense_rank1,
row_number() over(partition by continent order by continent) as row_number1
from country;



