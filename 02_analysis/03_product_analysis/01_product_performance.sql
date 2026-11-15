-- ================================================================================================
-- PRODUCT PERFORMANCE
-- ================================================================================================


-- -----------------------------------------------------------------------------------------------
-- 1. Top 10 Products by Revenue
-- Identifies the top 10 products generating the highest total sales revenue.
-- Also shows total quantity sold and average selling price for each product.
-- -----------------------------------------------------------------------------------------------

SELECT TOP 10
    p.product_id AS product_id,
    p.product_name AS product_name,
    p.category AS category,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.item_revenue) AS total_sales_revenue,
    CAST(
        SUM(oi.item_revenue) / SUM(oi.quantity)
        AS DECIMAL(18,2)
    ) AS average_selling_price
FROM dbo.order_items AS oi
INNER JOIN dbo.products AS p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_sales_revenue DESC;


-- -----------------------------------------------------------------------------------------------
-- 2. Top 10 Products by Quantity Sold
-- Identifies the top 10 products with the highest total unit sales.
-- This helps compare high-volume products with high-revenue products.
-- -----------------------------------------------------------------------------------------------

SELECT TOP 10
    p.product_id AS product_id,
    p.product_name AS product_name,
    p.category AS category,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.item_revenue) AS total_sales_revenue,
    CAST(
        SUM(oi.item_revenue) / SUM(oi.quantity)
        AS DECIMAL(18,2)
    ) AS average_selling_price
FROM dbo.order_items AS oi
INNER JOIN dbo.products AS p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_quantity_sold DESC;


-- -----------------------------------------------------------------------------------------------
-- 3. Product Performance by Category
-- Summarizes total sales quantity and total sales revenue by product category
-- to compare category-level performance.
-- -----------------------------------------------------------------------------------------------

SELECT
    p.category AS category,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.item_revenue) AS total_sales_revenue
FROM dbo.order_items AS oi
INNER JOIN dbo.products AS p
    ON oi.product_id = p.product_id
GROUP BY
    p.category
ORDER BY total_quantity_sold DESC;


-- -----------------------------------------------------------------------------------------------
-- 4. Top Revenue-Generating Product by Category
-- Calculates total revenue for each product and ranks products within each category.
-- Returns the highest revenue-generating product from every category.
-- -----------------------------------------------------------------------------------------------

WITH product_revenue AS (
    SELECT
        p.category AS category,
        p.product_name AS product_name,
        SUM(oi.item_revenue) AS total_sales_revenue
    FROM dbo.order_items AS oi
    INNER JOIN dbo.products AS p
        ON oi.product_id = p.product_id
    GROUP BY
        p.category,
        p.product_name
),
rank_product AS (
    SELECT
        category,
        product_name,
        total_sales_revenue,
        RANK() OVER (
            PARTITION BY category
            ORDER BY total_sales_revenue DESC
        ) AS revenue_rank
    FROM product_revenue
)
SELECT 
    category,
    product_name,
    total_sales_revenue,
    revenue_rank
FROM rank_product
WHERE revenue_rank = 1;


