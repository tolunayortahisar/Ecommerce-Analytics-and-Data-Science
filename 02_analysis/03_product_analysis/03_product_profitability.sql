-- ================================================================================================
-- PRODUCT PROFITABILITY
-- ================================================================================================


-- -----------------------------------------------------------------------------------------------
-- 1. Product-Level Profit Margin
-- Calculates unit profit and profit margin percentage for each product
-- using the listed product price and cost price.
--
-- This analysis identifies products with the strongest unit-level profitability.
-- -----------------------------------------------------------------------------------------------

SELECT
    product_id,
    product_name,
    category,
    price,
    cost_price,
    price - cost_price AS unit_profit,
    CAST(
        (price - cost_price) * 100.0 / price
        AS DECIMAL(18,2)
    ) AS profit_margin_percentage
FROM dbo.products
ORDER BY profit_margin_percentage DESC;


-- -----------------------------------------------------------------------------------------------
-- 2. Estimated Product Profitability
-- Measures product profitability using actual sales revenue and estimated product costs.
--
-- Estimated Total Cost = Quantity Sold × Product Cost Price
-- Estimated Profit = Sales Revenue - Estimated Total Cost
--
-- This analysis helps identify products that generate the highest total estimated profit,
-- which may differ from products with the highest unit profit margin.
-- -----------------------------------------------------------------------------------------------

SELECT
    p.product_id AS product_id,
    p.product_name AS product_name,
    p.category AS category,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.item_revenue) AS total_sales_revenue,
    SUM(oi.quantity * p.cost_price) AS estimated_total_cost,
    SUM(oi.item_revenue) - SUM(oi.quantity * p.cost_price) AS estimated_profit
FROM dbo.order_items AS oi
INNER JOIN dbo.products AS p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY estimated_profit DESC;


-- -----------------------------------------------------------------------------------------------
-- 3. Category Profitability
-- Aggregates sales revenue, estimated costs, and estimated profit at category level.
--
-- Estimated Profit Margin measures the share of sales revenue remaining after
-- estimated product costs are deducted.
--
-- This analysis helps compare high-revenue categories with high-profit categories.
-- -----------------------------------------------------------------------------------------------

SELECT
    p.category AS category,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.item_revenue) AS total_sales_revenue,
    SUM(oi.quantity * p.cost_price) AS estimated_total_cost,
    SUM(oi.item_revenue) - SUM(oi.quantity * p.cost_price) AS estimated_profit,
    CAST(
        (SUM(oi.item_revenue) - SUM(oi.quantity * p.cost_price)) * 100.0 / SUM(oi.item_revenue)
        AS DECIMAL(18,2)
    ) AS estimated_profit_margin_percentage
FROM dbo.order_items AS oi
INNER JOIN dbo.products AS p
    ON oi.product_id = p.product_id
GROUP BY
    p.category
ORDER BY estimated_profit DESC;


-- -----------------------------------------------------------------------------------------------
-- 4. Category Profitability Classification
-- Classifies product categories according to their estimated profit margin.
--
-- Profitability groups:
-- - High Margin      : 25% or higher
-- - Medium Margin    : 15% to below 25%
-- - Low Margin       : 5% to below 15%
-- - Very Low Margin  : Below 5%
--
-- The CTE calculates profitability metrics once, allowing the final query
-- to apply a clear CASE-based business classification.
-- -----------------------------------------------------------------------------------------------

WITH category_profitability AS (
    SELECT
        p.category AS category,
        SUM(oi.item_revenue) AS total_sales_revenue,
        SUM(oi.quantity * p.cost_price) AS estimated_total_cost,
        SUM(oi.item_revenue) - SUM(oi.quantity * p.cost_price) AS estimated_profit,
        CAST(
            (SUM(oi.item_revenue) - SUM(oi.quantity * p.cost_price)) * 100.0 / SUM(oi.item_revenue)
            AS DECIMAL(18,2)
        ) AS estimated_profit_margin_percentage
    FROM dbo.order_items AS oi
    INNER JOIN dbo.products AS p
        ON oi.product_id = p.product_id
    GROUP BY
        p.category
)
SELECT
    category,
    total_sales_revenue,
    estimated_profit,
    estimated_profit_margin_percentage,
    CASE
        WHEN estimated_profit_margin_percentage >= 25 THEN 'High Margin'
        WHEN estimated_profit_margin_percentage >= 15 THEN 'Medium Margin'
        WHEN estimated_profit_margin_percentage >= 5 THEN 'Low Margin'
        ELSE 'Very Low Margin'
    END AS profitability_class
FROM category_profitability
ORDER BY estimated_profit_margin_percentage DESC;
