USE uk_retail_analytics;

-- Check total rows
SELECT COUNT(*) AS total_rows
FROM sales_clean;

-- Check missing customer IDs
SELECT COUNT(*) AS missing_customer_ids
FROM sales_clean
WHERE customer_id IS NULL;

-- Check invalid quantities
SELECT COUNT(*) AS invalid_quantity_rows
FROM sales_clean
WHERE quantity <= 0;

-- Check invalid prices
SELECT COUNT(*) AS invalid_price_rows
FROM sales_clean
WHERE unit_price <= 0;

-- Check missing descriptions
SELECT COUNT(*) AS missing_descriptions
FROM sales_clean
WHERE description IS NULL
   OR TRIM(description) = '';

-- Check duplicate transaction records
SELECT
    invoice_no,
    stock_code,
    invoice_date,
    quantity,
    unit_price,
    COUNT(*) AS duplicate_count
FROM sales_clean
GROUP BY
    invoice_no,
    stock_code,
    invoice_date,
    quantity,
    unit_price
HAVING COUNT(*) > 1
LIMIT 20;

-- Check date range
SELECT
    MIN(invoice_date) AS first_transaction,
    MAX(invoice_date) AS last_transaction
FROM sales_clean;

-- Validate calculated revenue
SELECT
    ROUND(SUM(revenue), 2) AS stored_revenue,
    ROUND(SUM(quantity * unit_price), 2) AS recalculated_revenue,
    ROUND(
        SUM(revenue) - SUM(quantity * unit_price),
        2
    ) AS revenue_difference
FROM sales_clean;

-- Check exact duplicate business records
SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country,
    is_cancelled,
    revenue,
    COUNT(*) AS duplicate_count
FROM sales_clean
GROUP BY
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country,
    is_cancelled,
    revenue
HAVING COUNT(*) > 1
LIMIT 20;

-- Measure exact duplicate impact
WITH duplicate_groups AS (
    SELECT
        invoice_no,
        stock_code,
        description,
        quantity,
        invoice_date,
        unit_price,
        customer_id,
        country,
        is_cancelled,
        revenue,
        COUNT(*) AS duplicate_count
    FROM sales_clean
    GROUP BY
        invoice_no,
        stock_code,
        description,
        quantity,
        invoice_date,
        unit_price,
        customer_id,
        country,
        is_cancelled,
        revenue
    HAVING COUNT(*) > 1
)

SELECT
    COUNT(*) AS duplicate_groups,
    SUM(duplicate_count) AS rows_in_duplicate_groups,
    SUM(duplicate_count - 1) AS excess_duplicate_rows
FROM duplicate_groups;