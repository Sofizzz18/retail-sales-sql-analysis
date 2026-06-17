-- ===========================================
-- Retail Sales SQL Project
-- ===========================================

-- ===========================================
-- Database Setup
-- ===========================================

CREATE DATABASE IF NOT EXISTS retail_sales;
USE retail_sales;

-- ===========================================
-- Data Exploration
-- ===========================================

-- Preview the first 10 rows
SELECT * 
FROM retail_sales
LIMIT 10;

-- Display the table structure
DESCRIBE retail_sales;

-- Count the total number of records
SELECT COUNT(*) AS total_records
FROM retail_sales;

-- ===========================================
-- Data Quality Checks
-- ===========================================

SELECT
    SUM(Date IS NULL) AS date_nulls,
    SUM(Category IS NULL) AS category_nulls,
    SUM(Sales IS NULL) AS sales_nulls,
    SUM(Quantity IS NULL) AS quantity_nulls,
    SUM(Profit IS NULL) AS profit_nulls,
    SUM(Region IS NULL) AS region_nulls
FROM retail_sales;

-- =========================
-- Duplicate Record Check
-- =========================

SELECT
    Date,
    Category,
    Sales,
    Quantity,
    Profit,
    Region,
    COUNT(*) AS duplicate_count
FROM retail_sales
GROUP BY
    Date,
    Category,
    Sales,
    Quantity,
    Profit,
    Region
HAVING COUNT(*) > 1;

-- ============================
-- Categorical Data Validation
-- ============================

SELECT 
DISTINCT Category
FROM retail_sales
ORDER BY Category;

SELECT 
DISTINCT Region
FROM retail_sales
ORDER BY Region;

SELECT
    Category,
    COUNT(*) AS total_records
FROM retail_sales
GROUP BY Category
ORDER BY total_records DESC;

SELECT Region, COUNT(*)
FROM retail_sales
GROUP BY Region
ORDER BY COUNT(*) DESC;

SELECT *
FROM retail_sales
WHERE Category IS NULL
   OR Category = ''
   OR Category = 'Nan'
   OR Category = 'NaN?';
   
SELECT *
FROM retail_sales
WHERE Region IS NULL
   OR Region = ''
   OR Region = 'NaN';
   
-- ===========================================
-- Numeric Data Validation
-- ===========================================

SELECT
    MIN(Sales) AS min_sales,
    MAX(Sales) AS max_sales,
    AVG(Sales) AS avg_sales
FROM retail_sales;

--

SELECT
    MIN(Profit) AS min_profit,
    MAX(Profit) AS max_profit,
    AVG(Profit) AS avg_profit
FROM retail_sales;

-- ===========================================
-- Quantity Statistics
-- ===========================================

SELECT
    MIN(Quantity) AS min_quantity,
    MAX(Quantity) AS max_quantity,
    AVG(Quantity) AS avg_quantity
FROM retail_sales;

-- ===========================================
-- Date Validation
-- ===========================================

SELECT
    MIN(Date) AS earliest_date,
    MAX(Date) AS latest_date
FROM retail_sales;

-- ===========================================
-- Data Cleaning
-- ===========================================

-- Category
-- Replace missing and inconsistent category values with 'Unknown'

UPDATE retail_sales
SET Category = 'Unknown'
WHERE Category IS NULL
   OR Category = ''
   OR Category = 'Nan'
   OR Category = 'NaN?';

-- Region
-- Replace missing and inconsistent region values with 'Unknown'

UPDATE retail_sales
SET Region = 'Unknown'
WHERE Region IS NULL
   OR Region = ''
   OR Region = 'NaN';

-- Sales
-- No cleaning required. No missing or invalid values found.

-- Quantity
-- No cleaning required. No missing or invalid values found.

-- Profit
-- No cleaning required. No missing or invalid values found.

-- Convert the Date column from text to DATE format

UPDATE retail_sales
SET Date = STR_TO_DATE(Date, '%m/%d/%Y');

ALTER TABLE retail_sales
MODIFY COLUMN Date DATE;

-- ===================================
-- Business Summary
-- ===================================

-- Calculate the total sales

SELECT
    ROUND(SUM(Sales), 2) AS total_sales
FROM retail_sales;

-- Calculate the total profit

SELECT
    ROUND(SUM(Profit),2) AS total_profit
FROM retail_sales;

-- Calculate the total quantity sold

SELECT
    ROUND(SUM(Quantity), 2) AS total_quantity
FROM retail_sales;

-- Calculate the average sales amount

SELECT
    ROUND(AVG(Sales), 2) AS average_sales
FROM retail_sales;

-- Calculate the average profit

SELECT
    ROUND(AVG(Profit), 2) AS average_profit
FROM retail_sales;

-- ===========================================
-- Product Performance Analysis
-- ===========================================

-- Calculate total quantity sold by category

SELECT 
    Category,
    SUM(Quantity) AS total_quantity
FROM retail_sales
GROUP BY Category
ORDER BY total_quantity DESC;

-- Calculate total quantity by region

SElECT
     Region,
     SUM(Quantity) as total_quantity
FROM retail_sales
GROUP BY Region
ORDER BY total_quantity DESC;

-- Calculate average profit by category

SELECT
    Category,
    ROUND(AVG(Profit), 2) AS average_profit
FROM retail_sales
GROUP BY Category
ORDER BY average_profit DESC;

-- Calculate average sales by category

SELECT
    Category,
    ROUND(AVG(Sales), 2) AS average_sales
FROM retail_sales
GROUP BY Category
ORDER BY average_sales DESC;

-- Calculate total quantity sold by category

SELECT 
    Category,
    SUM(Quantity) as total_quantity
FROM retail_sales
GROUP BY Category
ORDER BY total_quantity DESC;

-- Count the number of transactions by category
SELECT 
     Category,
     COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY Category
ORDER BY total_transactions DESC;

-- ===========================================
-- Time Series Analysis
-- ===========================================

-- Calculate monthly sales

SELECT
    YEAR(Date) AS year,
    MONTHNAME(Date) AS month_name,
    ROUND(SUM(Sales), 2) AS total_sales
FROM retail_sales
GROUP BY YEAR(Date), MONTH(Date), MONTHNAME(Date)
ORDER BY YEAR(Date), MONTH(Date);

-- Calculate monthly profit

SELECT 
    YEAR(Date) AS year,
    MONTHNAME(Date) AS month_name,
    ROUND(SUM(profit), 2) AS Total_Profit
FROM retail_sales
GROUP BY YEAR(Date), MONTH(Date), MONTHNAME(Date)
ORDER BY YEAR(Date), MONTH(Date);

-- Calculate Monthly Quantity Sold

SELECT 
    YEAR(Date) AS year,
    -- MONTH(Date) as month_number,
    MONTHNAME(Date) AS month_name,
    ROUND(SUM(quantity), 2) as Total_Quantity
FROM retail_sales
GROUP BY YEAR(Date), MONTH(date), MONTHNAME(Date)
ORDER BY YEAR(date), MONTH(Date);

-- Identify the month with the highest total sales

SELECT 
    DATE_FORMAT(Date, '%Y-%M') AS month,
    ROUND(SUM(Sales), 2) AS total_sales
FROM retail_sales
GROUP BY DATE_FORMAT(Date, '%Y-%M')
ORDER BY total_sales DESC
LIMIT 1;

-- Identify the month with the highest total profit

SELECT
    DATE_FORMAT(Date, '%Y-%M') AS month,
    ROUND(SUM(Profit), 2) AS total_profit
FROM retail_sales
GROUP BY DATE_FORMAT(Date, '%Y-%M')
ORDER BY total_profit DESC
LIMIT 1;

-- Identify the month with the highest quantity sold

SELECT 
    DATE_FORMAT(Date, '%Y-%M') AS month,
    ROUND(SUM(quantity), 2) AS total_quantity
FROM retail_sales
GROUP BY DATE_FORMAT(Date, '%Y-%M')
ORDER BY total_quantity DESC
LIMIT 1;

-- Top 10 highest sales transactions
    
SELECT *
FROM retail_sales
ORDER BY Sales DESC
LIMIT 10;

-- Retrieve the top 10 most profitable transactions

SELECT *
FROM retail_sales
ORDER BY Profit DESC
LIMIT 10;

-- Retrieve data from the sales_by_category view

-- ===========================================
-- Views
-- ===========================================

-- Create a view to summarize total sales by category

CREATE VIEW sales_by_category AS
SELECT
    Category,
    ROUND(SUM(Sales), 2) AS total_sales
FROM retail_sales
WHERE Category <> 'Unknown'
GROUP BY Category;

-- Retrieve data from the sales_by_category view

SELECT *
FROM sales_by_category;

-- ===========================================
-- Advanced Business Analysis
-- ===========================================

-- Identify the top 10 highest sales transactions

SELECT Sales
FROM retail_sales
GROUP BY Sales
LIMIT 10;

-- Find transactions with sales above the average sales value

SELECT sales
FROM retail_sales
WHERE sales > (
              SELECT AVG(sales) 
              FROM retail_sales
);

-- Rank product categories by total sales

SELECT category,
	   ROUND(SUM(sales),2) AS total_sales,
       RANK() OVER(
	      ORDER BY SUM(sales) DESC
          ) AS sales_rank
FROM retail_sales
GROUP BY Category;

-- Find categories with above average total sales

SELECT
    Category,
    ROUND(SUM(Sales), 2) AS total_sales
FROM retail_sales
GROUP BY Category
HAVING SUM(Sales) >
(
    SELECT AVG(category_sales)
    FROM
    (
        SELECT SUM(Sales) AS category_sales
        FROM retail_sales
        GROUP BY Category
    ) AS avg_sales
);

-- Rank categories  by total profit

SELECT category,
    ROUND(SUM(profit), 2) AS total_profit,
    DENSE_RANK() OVER(ORDER BY SUM(profit)DESC) AS profit_rank
FROM retail_sales
GROUP BY Category;

-- Calculate running total of sales

SELECT 
    Date,
    Sales,
    SUM(Sales) OVER(
        ORDER BY Date
        ) AS running_total
FROM retail_sales;
 
 -- Compare each transaction to the average sale

SELECT
    Date,
    Category,
    Sales,
    ROUND(AVG(Sales) OVER(), 2) AS average_sales
FROM retail_sales;

-- ===========================================
-- CASE Statement Analysis
-- ===========================================

SELECT 
    Date,
    Category,
    Sales,
    CASE
        WHEN Sales >= 1500 THEN 'High'
        WHEN Sales >= 800 THEN 'Medium'
        ElSE 'Low'
	END AS Sales_Category
FROM retail_sales;

-- Count transactions by sales category

SELECT
    CASE
        WHEN Sales >= 1500 THEN 'High'
        WHEN Sales >= 800 THEN 'Medium'
        ELSE 'Low'
    END AS sales_category,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY sales_category;

-- ===========================================
-- Common Table Expressions (CTEs)
-- ===========================================

-- Identify categories with above average total sales

WITH category_sales AS
(
    SELECT
        Category,
        SUM(Sales) AS total_sales
    FROM retail_sales
    GROUP BY Category
)

SELECT *
FROM category_sales
WHERE total_sales >
(
    SELECT AVG(total_sales)
    FROM category_sales
);

-- Rank categories by total sales using a CTE

WITH category_sales AS
(
    SELECT
        Category,
        SUM(Sales) AS total_sales
    FROM retail_sales
    GROUP BY Category
)

SELECT
    Category,
    ROUND(total_sales, 2) AS total_sales,
    RANK() OVER(ORDER BY total_sales DESC) AS sales_rank
FROM category_sales;

-- ===========================================
-- Final Data Verification
-- ===========================================

SELECT COUNT(*)
FROM retail_sales;

SELECT *
FROM retail_sales
LIMIT 10;

-- ===========================================
-- Key Business Insights
-- ===========================================

-- Home Goods recorded the highest quantity sold.
-- Books generated the highest average profit.
-- South region recorded the highest sales volume.
-- Monthly sales trends revealed the strongest performing month.
-- Missing values were cleaned and standardized before analysis.