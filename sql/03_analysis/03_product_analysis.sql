USE uk_retail_analytics;

-- Top 10 Products by Revenue
SELECT
    stock_code,
    description,
    ROUND(SUM(revenue), 2) AS product_revenue
FROM sales_clean
GROUP BY stock_code, description
ORDER BY product_revenue DESC
LIMIT 10;

-- Top 10 Products by Units Sold
SELECT
    stock_code,
    description,
    SUM(quantity) AS units_sold
FROM sales_clean
GROUP BY stock_code, description
ORDER BY units_sold DESC
LIMIT 10;

-- Product Revenue Ranking
WITH product_sales AS (
    SELECT
        stock_code,
        description,
        SUM(revenue) AS product_revenue
    FROM sales_clean
    GROUP BY stock_code, description
)

SELECT
    stock_code,
    description,
    ROUND(product_revenue, 2) AS product_revenue,
    DENSE_RANK() OVER (
        ORDER BY product_revenue DESC
    ) AS revenue_rank
FROM product_sales
ORDER BY revenue_rank
LIMIT 20;

-- Product Contribution to Total Revenue
WITH product_sales AS (
    SELECT
        stock_code,
        description,
        SUM(revenue) AS product_revenue
    FROM sales_clean
    GROUP BY stock_code, description
)

SELECT
    stock_code,
    description,
    ROUND(product_revenue, 2) AS product_revenue,
    ROUND(
        product_revenue /
        SUM(product_revenue) OVER () * 100,
        2
    ) AS revenue_contribution_pct
FROM product_sales
ORDER BY product_revenue DESC
LIMIT 20;
