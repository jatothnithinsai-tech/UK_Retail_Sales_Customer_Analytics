USE uk_retail_analytics;

-- Revenue by Day of Week
SELECT
    DAYNAME(invoice_date) AS day_of_week,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales_clean
GROUP BY DAYNAME(invoice_date), DAYOFWEEK(invoice_date)
ORDER BY DAYOFWEEK(invoice_date);

-- Orders by Day of Week
SELECT
    DAYNAME(invoice_date) AS day_of_week,
    COUNT(DISTINCT invoice_no) AS total_orders
FROM sales_clean
GROUP BY DAYNAME(invoice_date), DAYOFWEEK(invoice_date)
ORDER BY DAYOFWEEK(invoice_date);

-- Revenue by Hour of Day
SELECT
    HOUR(invoice_date) AS hour_of_day,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales_clean
GROUP BY HOUR(invoice_date)
ORDER BY hour_of_day;

-- Orders by Hour of Day
SELECT
    HOUR(invoice_date) AS hour_of_day,
    COUNT(DISTINCT invoice_no) AS total_orders
FROM sales_clean
GROUP BY HOUR(invoice_date)
ORDER BY hour_of_day;

-- Peak Shopping Period
SELECT
    CASE
        WHEN HOUR(invoice_date) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(invoice_date) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(invoice_date) BETWEEN 17 AND 21 THEN 'Evening'
        ELSE 'Night'
    END AS shopping_period,
    COUNT(DISTINCT invoice_no) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales_clean
GROUP BY shopping_period
ORDER BY total_revenue DESC;
