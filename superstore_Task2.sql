CREATE DATABASE IF NOT EXISTS superstore_db;
USE superstore_db;
CREATE TABLE superstore (
    `Row ID` INT,
    `Order ID` VARCHAR(50),
    `Order Date` VARCHAR(20),
    `Ship Date` VARCHAR(20),
    `Ship Mode` VARCHAR(50),
    `Customer ID` VARCHAR(50),
    `Customer Name` VARCHAR(100),
    `Segment` VARCHAR(50),
    `Country` VARCHAR(100),
    `City` VARCHAR(100),
    `State` VARCHAR(100),
    `Postal Code` INT NULL,
    `Region` VARCHAR(50),
    `Product ID` VARCHAR(50),
    `Category` VARCHAR(50),
    `Sub-Category` VARCHAR(50),
    `Product Name` TEXT,
    `Sales` DECIMAL(10,2)
);
USE superstore_db;

USE superstore_db;

LOAD DATA LOCAL INFILE 'C:/Users/MILAN/Desktop/superstore.csv'
INTO TABLE superstore
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
DESCRIBE superstore;
SELECT * FROM superstore LIMIT 5;
SELECT COUNT(*) AS total_columns
FROM information_schema.columns
WHERE table_schema = DATABASE()
AND table_name = 'superstore';
SELECT * FROM superstore LIMIT 3;
SELECT COUNT(*) AS total_rows
FROM superstore;
SELECT 
    MIN(Sales) AS min_sales,
    MAX(Sales) AS max_sales,
    AVG(Sales) AS avg_sales,
    SUM(Sales) AS total_sales
FROM superstore;

SELECT 
    COUNT(*) AS total_rows,
    COUNT(Sales) AS sales_not_null
FROM superstore;

-- 1️ Total Sales--------------------------------
SELECT SUM(Sales) AS Total_Sales
FROM superstore;
-- 2️ Total Orders---------------------------
SELECT COUNT(DISTINCT `Order ID`) AS Total_Orders
FROM superstore;
-- Total Customers--------------------------------------
SELECT COUNT(DISTINCT `Customer ID`) AS Total_Customers
FROM superstore;
-- -- Sales by Category ---------------------------------------
SELECT 
    Category,
    SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY Category
ORDER BY Total_Sales DESC;
-- Sales by Region-----------------------
SELECT 
    Region,
    SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY Region
ORDER BY Total_Sales DESC;
  -- Top 5 products by Sales-----------------------
SELECT 
    `Product Name`,
    SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY `Product Name`
ORDER BY Total_Sales DESC
LIMIT 5;
-- Monthly Sales Trend----------------------------
SELECT
    DATE_FORMAT(STR_TO_DATE(`Order Date`, '%d-%m-%Y'), '%Y-%m') AS Month,
    SUM(Sales) AS Monthly_Sales
FROM superstore
GROUP BY Month
ORDER BY Month;

-- task2  --------------------------------------------------------------------------------------------------
USE superstore_db;
SHOW TABLES;
USE superstore_db;

CREATE TABLE customers AS
SELECT DISTINCT
    `Customer ID`,
    `Customer Name`,
    Segment,
    Country,
    City,
    State,
    `Postal Code`,
    Region
FROM superstore;
SELECT
    s.`Order ID`,
    s.`Order Date`,
    c.`Customer Name`,
    c.Region,
    s.Category,
    s.`Sub-Category`,
    s.Sales
FROM superstore s
INNER JOIN customers c
ON s.`Customer ID` = c.`Customer ID`
LIMIT 10;

SELECT
    c.Region,
    COUNT(DISTINCT s.`Order ID`) AS Total_Orders,
    SUM(s.Sales) AS Total_Sales
FROM customers c
INNER JOIN superstore s
ON c.`Customer ID` = s.`Customer ID`
GROUP BY c.Region
ORDER BY Total_Sales DESC;
SELECT
    ROUND(SUM(Sales) / COUNT(DISTINCT `Order ID`), 2) AS Average_Order_Value
FROM superstore;
SELECT
    ROUND(SUM(Sales) / COUNT(DISTINCT `Customer ID`), 2) AS Avg_Sales_Per_Customer
FROM superstore;
SELECT
    c.`Customer Name`,
    SUM(s.Sales) AS Total_Sales
FROM customers c
JOIN superstore s
ON c.`Customer ID` = s.`Customer ID`
GROUP BY c.`Customer Name`
ORDER BY Total_Sales DESC
LIMIT 5;

SELECT
    Region,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Sales)*100/(SELECT SUM(Sales) FROM superstore),2) AS Sales_Percentage
FROM superstore
GROUP BY Region
ORDER BY Total_Sales DESC;