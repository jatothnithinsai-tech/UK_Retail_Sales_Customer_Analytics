USE uk_retail_analytics;

-- Customer-level metrics for value and frequency analysis.
CREATE OR REPLACE VIEW vw_customer_summary AS
SELECT
    customer_id,
    MIN(DATE(invoice_date)) AS first_purchase_date,
    MAX(DATE(invoice_date)) AS last_purchase_date,
    COUNT(DISTINCT invoice_no) AS total_orders,
    SUM(quantity) AS total_units,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue) / NULLIF(COUNT(DISTINCT invoice_no), 0), 2)
        AS average_order_value,
    COUNT(DISTINCT CASE WHEN is_cancelled = 1 THEN invoice_no END)
        AS cancelled_orders,
    COUNT(DISTINCT country) AS countries_served
FROM sales_clean
WHERE customer_id IS NOT NULL
GROUP BY customer_id;
