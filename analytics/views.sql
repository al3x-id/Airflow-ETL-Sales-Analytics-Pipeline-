CREATE VIEW vw_revenue_kpi AS
	SELECT
	COUNT(order_number) AS total_orders,
	SUM(quantity) AS total_item_sold,
	SUM(sales_amount) AS total_revenue,
	ROUND(AVG(sales_amount), 2) AS avg_order_value
	FROM fact_sales
;

CREATE VIEW vw_customer_kpi AS
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

CREATE VIEW vw_monthly_growth_percent AS
	WITH monthly_sales AS(
		SELECT
		DATE(order_date - INTERVAL DAY(order_date)-1 DAY) AS month_date,
		SUM(sales_amount) AS monthly_revenue,
        COUNT(order_number) AS total_orders
		FROM fact_sales
		GROUP BY month_date
	)
		SELECT
		DATE_FORMAT(month_date, "%Y-%M") AS sales_month,
		monthly_revenue,
        total_orders,
		LAG(monthly_revenue, 1, 0) OVER (ORDER BY month_date) AS previous_month,
		ROUND(
			(
				monthly_revenue - LAG(monthly_revenue, 1, 0) OVER (ORDER BY month_date)) 
		/ 
		LAG(monthly_revenue, 1, 0) OVER (ORDER BY month_date)* 100, 2) AS monthly_growth_percent
		FROM monthly_sales
		ORDER BY month_date;

CREATE VIEW vw_top_products AS
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

CREATE VIEW vw_customer_segment AS
	SELECT
    customer_id,
	concat(first_name, " ", last_name) AS customer_name,
	country,
    SUM(sales_amount) AS total_revenue,
	ROUND(AVG(sales_amount), 2) AS avg_order_value,
	COUNT(order_number) AS total_orders,
	CASE
		WHEN SUM(sales_amount) >= 5000 THEN "High Value"
		WHEN SUM(sales_amount) >= 2000 THEN "Medium Value"
		ELSE "Low Value"
	END customer_segment
	FROM fact_sales
	JOIN dim_customers USING (customer_key)
	GROUP BY customer_id, customer_name, country
	ORDER BY total_revenue DESC;