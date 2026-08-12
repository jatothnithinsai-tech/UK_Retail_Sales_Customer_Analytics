USE uk_retail_analytics;

-- Monthly Revenue
SELECT
    DATE_FORMAT(invoice_date, '%Y-%m') AS sales_month,
    ROUND(SUM(revenue), 2) AS monthly_revenue
FROM sales_clean
GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
ORDER BY sales_month;

-- Monthly Orders
SELECT
    DATE_FORMAT(invoice_date, '%Y-%m') AS sales_month,
    COUNT(DISTINCT invoice_no) AS total_orders
FROM sales_clean
GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
ORDER BY sales_month;

-- Month-over-Month Revenue Growth
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(invoice_date, '%Y-%m') AS sales_month,
        SUM(revenue) AS monthly_revenue
    FROM sales_clean
    GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
),
sales_with_previous_month AS (
    SELECT
        sales_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
)

SELECT
    sales_month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(
        (
            (monthly_revenue - previous_month_revenue)
            / previous_month_revenue
        ) * 100,
        2
    ) AS month_over_month_growth_pct
FROM sales_with_previous_month
ORDER BY sales_month;
