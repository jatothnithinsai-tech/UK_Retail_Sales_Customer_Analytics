USE uk_retail_analytics;

-- Total Revenue
SELECT
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales_clean;

-- Total Orders
SELECT
    COUNT(DISTINCT invoice_no) AS total_orders
FROM sales_clean;

-- Total Customers
SELECT
    COUNT(DISTINCT customer_id) AS total_customers
FROM sales_clean
WHERE customer_id IS NOT NULL;

-- Total Units Sold
SELECT
    SUM(quantity) AS total_units_sold
FROM sales_clean;

-- Average Order Value
SELECT
    ROUND(AVG(order_value), 2) AS average_order_value
FROM (
    SELECT
        invoice_no,
        SUM(revenue) AS order_value
    FROM sales_clean
    GROUP BY invoice_no
) AS order_summary;
