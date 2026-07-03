-- RETAIL SALES ANALYSIS

CREATE DATABASE Retail_Sales_Analysis;
USE Retail_Sales_Analysis

CREATE TABLE Sales(
transactions_id	INT,
sale_date DATE,
sale_time TIME,
customer_id	INT,
gender VARCHAR(20),
age	INT,
category VARCHAR(50),
quantiy INT ,
price_per_unit INT,
cogs FLOAT,
total_sale FLOAT );

-- IMPORT DATA INTO Sales Table

BULK INSERT Sales
FROM 'G:\PROJECTS\Retail Analysis Sql Project\SQL - Retail Sales Analysis_utf .csv'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0A'
);

SELECT * FROM Sales
ORDER BY transactions_id ASC;

-- COUNT no. OF ROWS
SELECT COUNT(*) AS TOTAL_ROWS
FROM Sales;

-- CHECK NULL VALUES
SELECT * FROM Sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL 
OR gender IS NULL 
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL ;

-- HANDLING NULL VALUES 

DELETE FROM Sales
WHERE 
transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL 
OR gender IS NULL 
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL ;

-- DATA EXPLORATION

-- HOW MANY SALES WE HAVE 
  
  SELECT COUNT(*) AS Total_No_Of_Sales
  FROM Sales ;

-- HOW MANY CUSTOMERS WE HAVE 

SELECT  COUNT(DISTINCT Customer_id) AS No_Of_Customers
FROM Sales ;

-- HOW MANY CATEGORIES 

SELECT DISTINCT category AS Categories
FROM Sales ;

-- DATA ANALYSIS & BUSINESS KEY PROBLEMS

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * FROM Sales
WHERE sale_date = ' 2022-11-05' ;

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

SELECT *
FROM Sales
WHERE category = 'Clothing'
  AND quantiy > 10
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01';


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category,SUM(total_sale) AS Total_Sales
FROM Sales
GROUP BY category ;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
 
SELECT category, AVG(age) AS Avg_Age
FROM Sales
GROUP BY category
HAVING category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM Sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT COUNT(transactions_id) AS Total_No_Transaction,gender,category
FROM Sales
GROUP BY category,gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

    SELECT Years,
           Months,
           Avg_Sales
    FROM
    (
       SELECT 
       YEAR(sale_date) AS Years,
       MONTH(sale_date) AS Months,
       AVG(total_sale) AS Avg_Sales,
       RANK() OVER (
       PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC 
       ) AS Rank_no
       FROM Sales
       GROUP BY YEAR(sale_date) ,MONTH(sale_date)
     ) AS T1
       WHERE Rank_no = '1';

 
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

   SELECT TOP 5 customer_id ,SUM(total_sale) AS Total_sales
   FROM Sales
   GROUP BY customer_id
   ORDER BY SUM(total_sale) DESC;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

  SELECT category,COUNT(DISTINCT customer_id) AS NO_of_customer 
  FROM Sales
  GROUP BY category ;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
   
   SELECT 
      CASE  
          WHEN DATEPART(HOUR,sale_time) < 12 THEN 'MORNING'
          WHEN DATEPART(HOUR,sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
          ELSE 'EVENING'
      END AS SHIFT,
      COUNT(*) AS Number_of_Orders
   FROM Sales
   GROUP BY   
             CASE  
          WHEN DATEPART(HOUR,sale_time) < 12 THEN 'MORNING'
          WHEN DATEPART(HOUR,sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
          ELSE 'EVENING'
      END ;
