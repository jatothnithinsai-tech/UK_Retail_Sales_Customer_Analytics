USE uk_retail_analytics;

-- One-row executive KPI view for Tableau.
CREATE OR REPLACE VIEW vw_sales_summary AS
SELECT
    ROUND(SUM(revenue), 2) AS total_revenue,
    COUNT(DISTINCT invoice_no) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(quantity) AS total_units,
    ROUND(SUM(revenue) / NULLIF(COUNT(DISTINCT invoice_no), 0), 2)
        AS average_order_value,
    COUNT(DISTINCT CASE WHEN is_cancelled = 1 THEN invoice_no END)
        AS cancelled_orders,
    ROUND(
        COUNT(DISTINCT CASE WHEN is_cancelled = 1 THEN invoice_no END)
        / NULLIF(COUNT(DISTINCT invoice_no), 0) * 100,
        2
    ) AS cancellation_rate_pct,
    MIN(DATE(invoice_date)) AS first_transaction_date,
    MAX(DATE(invoice_date)) AS last_transaction_date
FROM sales_clean;
