-- Create New Table in Kimia Farma Database
CREATE TABLE `kimia_farma.kf_analysis` AS
SELECT
    t.transaction_id,
    t.date,
    t.branch_id,
    c.branch_name,
    c.kota,
    c.provinsi,
    t.rating AS rating_transaction,
    t.customer_name,
    t.product_id,
    p.product_name,
    t.price,
    t.discount_percentage,
    CASE 
        WHEN t.price <= 50000 THEN 0.1
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.2
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
        ELSE 0.3
    END AS gross_profit_percentage,
    (t.price * (1 - (t.discount_percentage / 100))) AS nett_sales,
    (t.price * (1 - (t.discount_percentage / 100)) * 
    CASE 
        WHEN t.price <= 50000 THEN 0.1
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.2
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
        ELSE 0.3
    END) AS nett_profit,
    c.rating AS rating_branch
FROM `kimia_farma.kf_final_transaction` t
JOIN `kimia_farma.kf_kantor_cabang` c ON t.branch_id = c.branch_id
JOIN `kimia_farma.kf_product` p ON t.product_id = p.product_id;


-- Exploratory Data Analysis
SELECT
    COUNT(*) AS total_transactions,
    MIN(date) AS earliest_date,
    MAX(date) AS latest_date,
    AVG(price) AS average_price,
    AVG(discount_percentage) AS average_discount_percentage,
    AVG(gross_profit_percentage) AS average_gross_profit_percentage,
    SUM(nett_sales) AS total_net_sales,
    SUM(nett_profit) AS total_net_profit,
    AVG(rating_transaction) AS average_transaction_rating,
    AVG(rating_branch) AS average_branch_rating,
    branch_name,
    COUNT(DISTINCT customer_name) AS total_customers
FROM `kimia_farma.kf_analysis`
GROUP BY branch_name
ORDER BY total_net_sales DESC;
