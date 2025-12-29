drop table sales;

CREATE TABLE Sales (
SaleID INT PRIMARY KEY,
SaleDate DATE,
Region VARCHAR(50),
Product VARCHAR(50),
Category VARCHAR(50),
Quantity INT,
UnitPrice DECIMAL(10, 2),
Revenue DECIMAL(10, 2)
);

INSERT INTO Sales (SaleID, SaleDate, Region, Product, Category, Quantity, UnitPrice, Revenue) VALUES
(1, '2024-11-01', 'North', 'Laptop', 'Electronics', 5, 800, 4000),
(2, '2024-11-02', 'South', 'Smartphone', 'Electronics', 10, 600, 6000),
(3, '2024-11-03', 'East', 'TV', 'Electronics', 3, 1500, 4500),
(4, '2024-11-04', 'West', 'Laptop', 'Electronics', 2, 850, 1700),
(5, '2024-11-05', 'North', 'WashingMachine', 'Appliances', 1, 2000, 2000),
(6, '2024-11-06', 'South', 'Refrigerator', 'Appliances', 1, 2500, 2500),
(7, '2024-11-07', 'East', 'Microwave', 'Appliances', 2, 500, 1000);

select * from Sales;

-- 1. Find out Total Amount of Sales done so far.
-- Ans: 21,700

select sum(Revenue) from Sales;

-- 2. Find out Average Revenue per sales.
-- Ans: 3,100

select avg(Revenue) from Sales;


-- 3. Find out MaxRevenue and MinRevenue per sales.
-- MaxRevenue: 6,000
-- MinRevenue: 1,000

select max(Revenue) as MaxRevenue, min(Revenue) as MinRevenue from Sales;

-- 4. Find out total Quantity Sold Region wise

select Region, sum(Quantity) from Sales
group by Region;

-- 5. Find out Average revenue Category wise

select Category, avg(Revenue) from Sales
group by Category;

-- 6. Find out Count of Sales by Product

select product, count(1) from Sales
group by product;

-- 7. Revenue Contribution Percentage by Region

select Region, Round((sum(Revenue)/ (select sum(Revenue) as total_Revenue from Sales))*100 ,2)
from Sales
group by Region;

-- 8. List all the Product sold together in a concatenated String. It should not have duplicate.

-- select distinct product from Sales;

SELECT GROUP_CONCAT(distinct product)
FROM sales;

-- 9.List all the Regions in which we have sold the Products.
-- 	It should be a JSON Array without duplicates.
-- Hint: Use JSON_ARRAYAGG
-- Output:
-- ["North", "South", "East", "West"]

SELECT JSON_ARRAYAGG( Region) as all_products
FROM sales;


-- 10. List all the product sold along with the quantity as a json array. You should have 1 entry per sales

SELECT JSON_OBJECTAGG(product,quantity) 
FROM sales
group by SaleID ;


-- 11. List Product and its total sales across as a json array

SELECT 
   JSON_OBJECTAGG(t.Product,t.TotalQuantity)
FROM (
    SELECT Product,SUM(Quantity) AS TotalQuantity FROM Sales GROUP BY Product) AS t;



-- 12. Generate a JSON Array of All Products Sold with Quantities
-- Note: This output should come as a single column value.
-- [
-- {"Product": "Laptop", "Quantity": 5},
-- {"Product": "Smartphone", "Quantity": 10},
-- {"Product": "TV", "Quantity": 3},
-- {"Product": "Laptop", "Quantity": 2},
-- {"Product": "WashingMachine", "Quantity": 1},
-- {"Product": "Refrigerator", "Quantity": 1},
-- {"Product": "Microwave", "Quantity": 2}
-- ]

select JSON_ARRAYAGG(json_obj) from (
select saleid, JSON_OBJECTAGG(product,quantity) as json_obj
FROM sales group by saleid
)t;

-- 13. Get Region wise Total Revenue in JSON Format as shown below
-- {
-- "North": 6000,
-- "South": 8500,
-- "East": 5500,
-- "West": 1700
-- }

SELECT 
   JSON_OBJECTAGG(Region,total)
FROM (
select Region, sum(Revenue) as total from Sales
group by Region) t;



-- 14. Generate a JSON Array of Regions with Their Respective Categories and Revenue

select region, json_array( json_objectagg(category,total))
from (
select region,category,sum(revenue) as total
from sales s 
group by region, category
) t
group by region;

-- Assignments on Dates Function.
-- Lets Add few more records to cover more dates.


INSERT INTO Sales (SaleID, SaleDate, Region, Product, Category, Quantity, UnitPrice, Revenue)
VALUES
(8, '2021-01-15', 'North', 'Laptop', 'Electronics', 5, 800, 4000),
(9, '2021-12-25', 'South', 'Smartphone', 'Electronics', 10, 600, 6000),
(10, '2022-05-10', 'East', 'TV', 'Electronics', 3, 1500, 4500),
(11, '2022-11-20', 'West', 'Laptop', 'Electronics', 2, 850, 1700),
(12, '2023-03-17', 'North', 'WashingMachine', 'Appliances', 1, 2000, 2000),
(13, '2023-07-04', 'South', 'Refrigerator', 'Appliances', 1, 2500, 2500),
(14, '2024-02-29', 'East', 'Microwave', 'Appliances', 2, 500, 1000), -- Leap year
(15, '2024-10-15', 'West', 'Air Conditioner', 'Appliances', 3, 1800, 5400),
(16, '2025-01-01', 'North', 'Speaker', 'Electronics', 6, 300, 1800),
(17, '2025-12-31', 'South', 'Headphones', 'Electronics', 4, 250, 1000);

select * from sales;


-- 15. Find Total Revenue by Year-Month Wise ,sort it by Desc order

SELECT DATE_FORMAT(SaleDate, '%Y-%m') AS YearMonth,SUM(Revenue) AS TotalRevenue
FROM Sales
GROUP BY YearMonth
ORDER BY TotalRevenue DESC;

-- 16. Revenue Generated on Weekends
-- Answer: 18,200
select sum(revenue) from sales s 
where DAYOFWEEK(SaleDate)=1 or dayofweek(SaleDate)=7 


-- 17. Revenue Generated on Weekend for any Given Year.

select date_format(SaleDate,'%Y') as year, sum(revenue) from sales s 
where DAYOFWEEK(SaleDate)=1 or dayofweek(SaleDate)=7
group by year
having year = 2024;

-- 18. Find Year Wise,Weekend Sales Order by Sales year

select date_format(SaleDate,'%Y') as year, sum(revenue) from sales s 
where DAYOFWEEK(SaleDate)=1 or dayofweek(SaleDate)=7
group by year
order by year desc;

-- 19. Total Revenue by Day of week

select date_format(SaleDate,"%W") as DAYOFWEEK, sum(revenue) from sales s 
group by DAYOFWEEK;

-- 20. Total Revenue by Day of week for any Given Year. If I input 2024, It should give me the list of all the revenue done weekday wise.


select date_format(SaleDate,"%W") as DAYOFWEEK, sum(revenue) from sales s 
where date_format(SaleDate,"%Y")=2024
group by DAYOFWEEK;

-- 21. YearWise, Week day wise, total sales order by year

select date_format(SaleDate,"%Y") as year ,date_format(SaleDate,"%W") as DAYOFWEEK, sum(revenue) from sales s 
group by year,DAYOFWEEK;


-- 22. Average Revenue by Day of week

select date_format(SaleDate,"%W") as DAYOFWEEK, avg(revenue) from sales s 
group by DAYOFWEEK;

23. Total Number of sales and total revenue in last 90 days
-- 10 29900.00

select count(1) as no_of_sales, sum(revenue) as total from sales s 
where SaleDate > date_sub(current_date(),interval 91 day) ;

-- 24. Revenue Split by Year and Quarter

select year(Saledate) as year,quarter(saledate) as quarter ,sum(revenue) from sales
group by year, quarter
order by year desc ,quarter desc;


-- 25. What is the First and Last Sale Date
-- 2021-01-15 2025-12-31

select min(SaleDate) as first_sale_date,max(SaleDate) as last_sale_date from sales s; 

