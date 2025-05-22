-- ==============================
-- 📁 Zudio SQL Analysis
-- 🗂️ Dataset: Product Performance
-- 📅 Period: FY 2025-26
-- ==============================


CREATE DATABASE Zudio;
USE Zudio;

                                                    -- 🔧 1. Create Table
CREATE TABLE Product_performance (
    Campaign_ID VARCHAR(20),
    Product_ID VARCHAR(20),
    Budget DECIMAL(15,2),
    Clicks INT,
    Conversions INT,
    Revenue_Generated DECIMAL(15,2),
    ROI DECIMAL(6,2),
    Client_ID VARCHAR(20),
    Plan_type VARCHAR(30),
    Subscription_Length INT,
    Promotion_ID VARCHAR(40),
    Discount_Level DECIMAL(5,2),
    Units_Sold INT,
    Product_Bundle_Code VARCHAR(20),
    Bundle_Price DECIMAL(15,2),
    Customer_Satisfaction_Post_Refund DECIMAL(3,1),
    Common_Keywords TEXT,
    Customer_city VARCHAR(50),
    Product_category VARCHAR(50)
);
-- 🔧 1. Test Import data
SELECT COUNT(*) FROM Product_performance;

-- Remove safe update
SET SQL_SAFE_UPDATES = 0;

                                              -- ✅ 2. Data Cleaning Queries

-- Remove nulls from Product_ID
DELETE FROM Product_performance WHERE Product_ID IS NULL;

-- Add Profit column
SELECT *, (Revenue_Generated - Budget) AS Profit
FROM Product_performance;

ALTER TABLE Product_performance
ADD Profit DECIMAL(15,2);

UPDATE Product_performance
SET Profit = Revenue_Generated - Budget;

												-- 🌟 3. Analysis Queries

-- Which product Generated the Highest Revenue?
SELECT Product_ID, SUM(Revenue_generated) AS Total_Revenue
FROM Product_performance
GROUP BY Product_ID
ORDER BY Total_Revenue DESC
LIMIT 1;

-- Which city had the highest total number of units sold?
SELECT Customer_city, SUM(Units_sold) AS Total_units_sold
FROM Product_performance
Group BY Customer_city
Order BY Total_units_sold DESC
LIMIT 1;

-- Find the products with duplicate product_IDs
SELECT Product_ID, COUNT(*) AS Occurrances
FROM Product_performance
GROUP BY Product_ID
ORDER BY Occurrances > 1;

-- What is the average ROI per subscription Plan?
SELECT Plan_type, ROUND(AVG(ROI), 2) AS Average_ROI
FROM Product_performance
Group By Plan_type;

-- Find the second highest revenue generaating product.
SELECT Product_ID, SUM(Revenue_Generated) AS Total_revenue
FROM Product_performance
Group by Product_ID
Order BY Total_revenue DESC
LIMIT 1 OFFSET 1;

-- Calculate profit & show top 5 most profitable products
SELECT Product_ID, SUM(Profit) AS Net_profit
FROM Product_performance
Group By Product_ID
Order BY Net_profit DESC
LIMIT 5;

-- Total conversions & conversion rate (%) by city
SELECT Customer_city, SUM(Clicks) AS T_clicks, SUM(Conversions) AS T_conversions, 
	Round((SUM(Conversions) / SUM(Clicks)) * 100, 2) AS Conversion_percent
FROM Product_performance
GROUP BY Customer_city
Order BY Conversion_percent DESC;

-- Top cities by total Revenue
SELECT Customer_city, SUM(Revenue_Generated) AS T_Revenue, SUM(Units_Sold) AS T_Units
FROM Product_performance
GROUP BY Customer_city
ORDER BY T_Revenue DESC
LIMIT 3;

-- Products with conversion rate > 20%
SELECT Product_ID, Clicks, Conversions, (Conversions/Clicks) * 100 AS Conversion_rate
FROM Product_performance
WHERE Clicks > 0
	AND (Conversions / Clicks) * 100 > 20;
    
-- Product Bundles that sold over 100 Units
SELECT Product_Bundle_Code, SUM(Units_Sold) AS Total_units_sold
FROM Product_performance
Group BY Product_Bundle_Code
HAVING total_units_sold > 100
Order BY total_units_sold;

-- Most common subscription plan
SELECT Plan_type, SUM(Subscription_Length) AS Popularity, SUM(Units_Sold) AS Total_units,
SUM(Revenue_Generated) AS Revenue
FROM Product_performance
Group BY Plan_type
ORDER BY Popularity DESC
LIMIT 1;

SELECT Plan_type, COUNT(*) AS Count
FROM Product_performance
GROUP BY Plan_type
ORDER BY Count DESC
LIMIT 1;

-- Are there any products that appear more than once?
SELECT Product_ID, COUNT(*) AS Occurrances
FROM Product_performance
Group BY Product_ID
HAVING COUNT(*) > 0;

-- Which rows have ROI > 1000 or < -100?
SELECT *
FROM Product_performance
WHERE ROI > 100 OR ROI < -100;
SELECT *
FROM Product_performance
WHERE ROI > 1000 OR ROI < 0;

