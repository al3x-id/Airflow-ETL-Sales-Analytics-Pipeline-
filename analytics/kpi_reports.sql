-- Revenue Analysis
SELECT
COUNT(order_number) AS total_orders,
SUM(quantity) AS total_item_sold,
SUM(sales_amount) AS total_revenue,
ROUND(AVG(sales_amount), 2) AS avg_order_value
FROM fact_sales;

-- Customer Summary
SELECT
COUNT(customer_key) AS total_customers,
ROUND(SUM(sales_amount)/ COUNT(customer_key), 2) AS customer_lifetime_value,
ROUND(AVG(customer_orders), 2) AS avg_order_per_customer
FROM(
	SELECT 
    customer_key,
    sales_amount,
    COUNT(order_number) AS customer_orders
    FROM fact_sales
    GROUP BY customer_key, sales_amount
)customer_summary;

WITH monthly_sales AS(
	SELECT
    DATE(order_date - INTERVAL DAY(order_date)-1 DAY) AS month_date,
    YEAR(order_date, "YYYY") AS year,
    SUM(sales_amount) AS monthly_revenue
	FROM fact_sales
	GROUP BY month_date
)
	SELECT
    DATE_FORMAT(month_date, "%Y-%M") AS sales_month,
    monthly_revenue,
    LAG(monthly_revenue, 1, 0) OVER (ORDER BY month_date) AS previous_month,
    ROUND(
		(
			monthly_revenue - LAG(monthly_revenue, 1, 0) OVER (ORDER BY month_date)) 
    / 
    LAG(monthly_revenue, 1, 0) OVER (ORDER BY month_date)* 100, 2) AS monthly_growth_percent
    FROM monthly_sales
    ORDER BY month_date;