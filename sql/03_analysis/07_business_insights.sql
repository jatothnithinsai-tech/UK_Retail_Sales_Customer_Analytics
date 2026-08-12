USE uk_retail_analytics;

-- 1. Best Revenue Month
SELECT
    DATE_FORMAT(invoice_date, '%Y-%m') AS sales_month,
    ROUND(SUM(revenue), 2) AS monthly_revenue
FROM sales_clean
GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
ORDER BY monthly_revenue DESC
LIMIT 1;

-- 2. Best Performing Product
SELECT
    stock_code,
    description,
    ROUND(SUM(revenue), 2) AS product_revenue
FROM sales_clean
GROUP BY stock_code, description
ORDER BY product_revenue DESC
LIMIT 1;

-- 3. Highest Value Customer
SELECT
    customer_id,
    ROUND(SUM(revenue), 2) AS customer_revenue,
    COUNT(DISTINCT invoice_no) AS total_orders
FROM sales_clean
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY customer_revenue DESC
LIMIT 1;

-- 4. Best International Market
SELECT
    country,
    ROUND(SUM(revenue), 2) AS total_revenue,
    COUNT(DISTINCT invoice_no) AS total_orders
FROM sales_clean
WHERE country <> 'United Kingdom'
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 1;

-- 5. Peak Sales Day
SELECT
    DAYNAME(invoice_date) AS day_of_week,
    ROUND(SUM(revenue), 2) AS total_revenue,
    COUNT(DISTINCT invoice_no) AS total_orders
FROM sales_clean
GROUP BY DAYNAME(invoice_date), DAYOFWEEK(invoice_date)
ORDER BY total_revenue DESC
LIMIT 1;

-- 6. Peak Shopping Hour
SELECT
    HOUR(invoice_date) AS hour_of_day,
    ROUND(SUM(revenue), 2) AS total_revenue,
    COUNT(DISTINCT invoice_no) AS total_orders
FROM sales_clean
GROUP BY HOUR(invoice_date)
ORDER BY total_revenue DESC
LIMIT 1;

-- 7. UK vs International Revenue Share
WITH market_sales AS (
    SELECT
        CASE
            WHEN country = 'United Kingdom' THEN 'United Kingdom'
            ELSE 'International'
        END AS market,
        SUM(revenue) AS market_revenue
    FROM sales_clean
    GROUP BY
        CASE
            WHEN country = 'United Kingdom' THEN 'United Kingdom'
            ELSE 'International'
        END
)

SELECT
    market,
    ROUND(market_revenue, 2) AS market_revenue,
    ROUND(
        market_revenue / SUM(market_revenue) OVER () * 100,
        2
    ) AS revenue_share_pct
FROM market_sales
ORDER BY market_revenue DESC;
