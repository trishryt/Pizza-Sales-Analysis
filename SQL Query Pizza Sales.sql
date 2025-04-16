CREATE DATABASE pizza_project_db;
USE pizza_project_db;


-- -------------------------- DATA CLEANING ----------------------------------------------

SELECT * FROM pizza_sales;

ALTER TABLE pizza_sales
MODIFY COLUMN pizza_name_id VARCHAR(50);

ALTER TABLE pizza_sales
MODIFY COLUMN pizza_size VARCHAR(50);

ALTER TABLE pizza_sales
MODIFY COLUMN pizza_category VARCHAR(50);

ALTER TABLE pizza_sales
MODIFY COLUMN pizza_ingredients VARCHAR(200);

ALTER TABLE pizza_sales
MODIFY COLUMN pizza_name VARCHAR(50);

ALTER TABLE pizza_sales
MODIFY COLUMN unit_price FLOAT;

ALTER TABLE pizza_sales
MODIFY COLUMN total_price FLOAT;

UPDATE pizza_sales
SET order_date = str_to_date(order_date, '%d-%m-%Y');

ALTER TABLE pizza_sales
MODIFY COLUMN order_date DATE;

ALTER TABLE pizza_sales
MODIFY COLUMN order_time TIME;

UPDATE pizza_sales
SET pizza_size = 
    CASE 
        WHEN pizza_size = 'S' THEN 'Small'
        WHEN pizza_size = 'M' THEN 'Medium'
        WHEN pizza_size = 'L' THEN 'Large'
        WHEN pizza_size = 'XL' THEN 'Extra Large'
        ELSE 'Double Extra Large'
    END;

CREATE TABLE pizza_sales_copy AS
SELECT * FROM pizza_sales;

SELECT * FROM pizza_sales_copy;



-- -------------------------- DATA ANALYSIS ----------------------------------------------
/* KPI :
	1. TOTAL REVENUE
    2. AVERAGE ORDER VALUE
    3. TOTAL PIZZA SOLD
    4. TOTAL ORDERS
    5. AVERAGE PIZZA PER ORDERS
*/

-- 1. TOTAL REVENUE

SELECT
	ROUND(SUM(total_price),2) AS Total_Revenue
FROM
	pizza_sales;

-- 2. AVERAGE ORDER VALUE

SELECT
	ROUND(SUM(total_price) / COUNT(DISTINCT order_id),2) AS Average_Order_Value
FROM
	pizza_sales;

-- 3. TOTAL PIZZA SOLD

SELECT
	ROUND(SUM(quantity),2) AS Total_Pizza_Sold
FROM
	pizza_sales;
    
-- 4. TOTAL ORDERS

SELECT
	COUNT(DISTINCT order_id) AS Total_Orders
FROM
	pizza_sales;

-- 5. AVERAGE PIZZA PER ORDERS

SELECT
	ROUND(SUM(quantity) / COUNT(DISTINCT order_id),2) AS Average_Pizza_per_Orders
FROM
	pizza_sales;

/* TREND ANAYLSIS :
	1. DAILY
    2. HOURLY
    3. MONTH
    4. QUARTER
*/

-- DAILY TREND FOR ORDERS

SELECT 
    DAYNAME(order_date) AS Day,
    COUNT(order_id) AS Total_Orders
FROM pizza_sales
GROUP BY WEEKDAY(order_date) , Day
ORDER BY WEEKDAY(order_date), Day;

-- HOURLY TREND FOR ORDERS

SELECT 
    HOUR(order_time) AS Hour,
    COUNT(order_id) AS Total_Orders
FROM pizza_sales
GROUP BY Hour
ORDER BY Hour;

-- MONTHLY

SELECT 
    MONTHNAME(order_date) AS Month,
    COUNT(order_id) AS Total_Orders
FROM pizza_sales
GROUP BY MONTH(order_date), Month
ORDER BY MONTH(order_date), Month;

-- QUARTER

SELECT 
    QUARTER(order_date) AS Quarter,
    COUNT(order_id) AS Total_Orders
FROM pizza_sales
GROUP BY Quarter;

/* SALES :
		1. %SALES BY PIZZA CATEGORY
        2. %SALES BY PIZZA SIZE
*/

-- 1. %SALES BY PIZZA CATEGORY

SELECT
	pizza_category,
    ROUND(SUM(total_price),2) AS Total_Sales,
    ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales), 2) AS Sales_Percentage
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Sales DESC;

-- 2. %SALES BY PIZZA SIZE

SELECT
	pizza_size,
    ROUND(SUM(total_price),2) AS Total_Sales,
    ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales), 2) AS Sales_Percentage
FROM pizza_sales
GROUP BY pizza_size
ORDER BY Total_Sales DESC;

-- TOTAL PIZZA SOLD BY CATEGORY

SELECT
	pizza_category,
	SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Pizza_Sold DESC;

-- TOTAL PIZZA SOLD BY SIZE

SELECT
	pizza_size,
	SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_size
ORDER BY Total_Pizza_Sold DESC;

/* BEST SELLER :
		1. TOP 5 BY TOTAL PIZZA SOLD
        2. BOTTOM 5 BY TOTAL PIZZA SOLD
*/

-- 1. TOP 5 BY TOTAL PIZZA SOLD

SELECT
	pizza_name,
	SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC
LIMIT 5;

-- 2. BOTTOM 5 BY TOTAL PIZZA SOLD

SELECT
	pizza_name,
	SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold ASC
LIMIT 5;