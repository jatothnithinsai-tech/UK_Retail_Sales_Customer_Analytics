USE uk_retail_analytics;

-- Product-level performance for Tableau rankings and contribution analysis.
CREATE OR REPLACE VIEW vw_product_summary AS
SELECT
    stock_code,
    MAX(description) AS description,
    COUNT(DISTINCT invoice_no) AS total_orders,
    SUM(quantity) AS total_units,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(unit_price), 2) AS average_unit_price,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT CASE WHEN is_cancelled = 1 THEN invoice_no END)
        AS cancelled_orders,
    ROUND(
        COUNT(DISTINCT CASE WHEN is_cancelled = 1 THEN invoice_no END)
        / NULLIF(COUNT(DISTINCT invoice_no), 0) * 100,
        2
    ) AS cancellation_rate_pct
FROM sales_clean
GROUP BY stock_code;
