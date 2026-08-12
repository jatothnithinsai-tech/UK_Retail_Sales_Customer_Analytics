USE uk_retail_analytics;

-- Top 10 Customers by Revenue
SELECT
    customer_id,
    ROUND(SUM(revenue), 2) AS customer_revenue
FROM sales_clean
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY customer_revenue DESC
LIMIT 10;

-- Top 10 Customers by Number of Orders
SELECT
    customer_id,
    COUNT(DISTINCT invoice_no) AS total_orders
FROM sales_clean
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 10;

-- Customer Average Order Value
WITH customer_orders AS (
    SELECT
        customer_id,
        invoice_no,
        SUM(revenue) AS order_value
    FROM sales_clean
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id, invoice_no
)

SELECT
    customer_id,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_value), 2) AS total_revenue,
    ROUND(AVG(order_value), 2) AS avg_order_value
FROM customer_orders
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 20;

-- Customer Revenue Ranking
WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(revenue) AS total_revenue
    FROM sales_clean
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)

SELECT
    customer_id,
    ROUND(total_revenue, 2) AS total_revenue,
    DENSE_RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank,
    ROUND(
        total_revenue /
        SUM(total_revenue) OVER () * 100,
        2
    ) AS revenue_contribution_pct
FROM customer_sales
ORDER BY revenue_rank
LIMIT 20;
