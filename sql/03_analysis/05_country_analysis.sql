USE uk_retail_analytics;

-- Top 10 Countries by Revenue
SELECT
    country,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales_clean
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 10;

-- Top 10 Countries by Orders
SELECT
    country,
    COUNT(DISTINCT invoice_no) AS total_orders
FROM sales_clean
GROUP BY country
ORDER BY total_orders DESC
LIMIT 10;

-- Revenue Contribution by Country
WITH country_sales AS (
    SELECT
        country,
        SUM(revenue) AS country_revenue
    FROM sales_clean
    GROUP BY country
)

SELECT
    country,
    ROUND(country_revenue, 2) AS country_revenue,
    ROUND(
        country_revenue /
        SUM(country_revenue) OVER () * 100,
        2
    ) AS revenue_contribution_pct
FROM country_sales
ORDER BY country_revenue DESC;

-- UK vs International Performance
SELECT
    CASE
        WHEN country = 'United Kingdom' THEN 'United Kingdom'
        ELSE 'International'
    END AS market,
    COUNT(DISTINCT invoice_no) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(revenue), 2) AS avg_line_revenue
FROM sales_clean
GROUP BY
    CASE
        WHEN country = 'United Kingdom' THEN 'United Kingdom'
        ELSE 'International'
    END;
