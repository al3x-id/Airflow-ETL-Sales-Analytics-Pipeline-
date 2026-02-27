-- Top 10 Performing Products
SELECT 
product_name,
SUM(sales_amount) AS total_revenue,
COUNT(order_number) AS total_orders,
SUM(quantity) AS total_quantity_sold
FROM fact_sales
JOIN dim_products USING (product_key)
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Regional Sales
SELECT
country,
COUNT(customer_id) AS total_customer,
SUM(sales_amount) AS total_revenue,
ROUND(AVG(sales_amount), 2) AS avg_order_value
FROM fact_sales
JOIN dim_customers USING (customer_key)
GROUP BY country
ORDER BY total_revenue DESC;



-- Customer Segment
SELECT
customer_id,
concat(first_name, " ", last_name) AS customer_name,
country,
SUM(sales_amount) AS lifetime_value,
COUNT(order_number) AS total_orders,
CASE
	WHEN SUM(sales_amount) >= 5000 THEN "High Value"
    WHEN SUM(sales_amount) >= 2000 THEN "Medium Value"
    ELSE "Low Value"
END customer_segment
FROM fact_sales
JOIN dim_customers USING (customer_key)
GROUP BY customer_id, customer_name, country
ORDER BY lifetime_value DESC;


-- Monthly Revenue Analysis
SELECT
DATE_FORMAT(order_date, "%M-%Y") AS sales_month,
SUM(sales_amount) AS monthly_revenue,
COUNT(order_number) AS total_orders
FROM fact_sales
GROUP BY sales_month
ORDER BY monthly_revenue DESC;
