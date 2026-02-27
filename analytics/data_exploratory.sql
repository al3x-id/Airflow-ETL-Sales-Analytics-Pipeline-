USE dim_fact_db;

-- Identify Tables in the Database
SHOW TABLES;

-- Discover Column Names and Data Types
DESCRIBE dim_customers;
DESCRIBE dim_products;
DESCRIBE fact_sales;

-- Preview Sample Data
# dim_customers
SELECT * 
FROM dim_customers
LIMIT 5;

# dim_products
SELECT * 
FROM dim_products
LIMIT 5;

# fact_sales
SELECT * 
FROM fact_sales
LIMIT 5;

-- Row Counts
SELECT
TABLE_NAME AS TableName,
TABLE_ROWS AS RowCounts
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dim_fact_db';

-- Distribution Check for Fact Tables
SELECT
order_number,
COUNT(*) AS frequency,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fact_sales), 3) AS percentage
FROM fact_sales
GROUP BY order_number
ORDER BY frequency DESC;