USE uk_retail_analytics;

-- Monthly sales trend used by Tableau time-series worksheets.
CREATE OR REPLACE VIEW vw_monthly_sales AS
SELECT
    DATE_FORMAT(invoice_date, '%Y-%m-01') AS month_start,
    YEAR(invoice_date) AS sales_year,
    MONTH(invoice_date) AS sales_month_number,
    DATE_FORMAT(invoice_date, '%Y-%m') AS sales_month,
    ROUND(SUM(revenue), 2) AS total_revenue,
    COUNT(DISTINCT invoice_no) AS total_orders,
    COUNT(DISTINCT customer_id) AS active_customers,
    SUM(quantity) AS total_units,
    ROUND(SUM(revenue) / NULLIF(COUNT(DISTINCT invoice_no), 0), 2)
        AS average_order_value,
    COUNT(DISTINCT CASE WHEN is_cancelled = 1 THEN invoice_no END)
        AS cancelled_orders
FROM sales_clean
GROUP BY
    DATE_FORMAT(invoice_date, '%Y-%m-01'),
    YEAR(invoice_date),
    MONTH(invoice_date),
    DATE_FORMAT(invoice_date, '%Y-%m');
