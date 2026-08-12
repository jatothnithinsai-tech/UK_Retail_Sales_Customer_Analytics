CREATE DATABASE IF NOT EXISTS uk_retail_analytics;

USE uk_retail_analytics;

CREATE TABLE IF NOT EXISTS sales_raw (
    row_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    invoice_no VARCHAR(50),
    stock_code VARCHAR(50),
    description TEXT,
    quantity INT,
    invoice_date DATETIME,
    unit_price DECIMAL(12,2),
    customer_id BIGINT,
    country VARCHAR(100),
    loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sales_clean (
    transaction_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    invoice_no VARCHAR(50) NOT NULL,
    stock_code VARCHAR(50) NOT NULL,
    description TEXT,
    quantity INT NOT NULL,
    invoice_date DATETIME NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    customer_id BIGINT,
    country VARCHAR(100) NOT NULL,
    is_cancelled BOOLEAN NOT NULL,
    revenue DECIMAL(14,2) NOT NULL,
    loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_sales_clean_invoice_date
ON sales_clean(invoice_date);

CREATE INDEX idx_sales_clean_customer
ON sales_clean(customer_id);

CREATE INDEX idx_sales_clean_stock
ON sales_clean(stock_code);

SHOW TABLES;


SELECT COUNT(*) AS total_rows
FROM sales_clean;

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;


SELECT
    @@hostname AS hostname,
    @@port AS port,
    @@version AS version,
    @@server_uuid AS server_uuid,
    DATABASE() AS current_database;



SELECT COUNT(*) AS total_rows
FROM sales_clean;