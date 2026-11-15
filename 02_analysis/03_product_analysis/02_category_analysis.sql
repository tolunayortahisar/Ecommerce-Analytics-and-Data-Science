-- ================================================================================================
-- CATEGORY ANALYSIS
-- ================================================================================================


-- -----------------------------------------------------------------------------------------------
-- 1. Category Performance Overview
-- Summarizes sales quantity, revenue, and average selling price for each product category.
-- This analysis helps compare category performance from both sales volume and revenue perspectives.
-- -----------------------------------------------------------------------------------------------

SELECT
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
	p.category
ORDER BY total_sales_revenue DESC;


-- -----------------------------------------------------------------------------------------------
-- 2. Top Revenue-Generating Subcategory by Category
-- First calculates sales performance for each subcategory, then ranks subcategories
-- within their parent category based on total sales revenue.
--
-- Only the highest revenue-generating subcategory from each category is returned.
-- -----------------------------------------------------------------------------------------------

WITH subcategory_revenue AS (
    SELECT
        p.category AS category,
        p.subcategory AS subcategory,
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
        p.category,
        p.subcategory
),
ranked_subcategories AS (
    SELECT
        category,
        subcategory,
        total_quantity_sold,
        total_sales_revenue,
        average_selling_price,
        RANK() OVER (
            PARTITION BY category
            ORDER BY total_sales_revenue DESC
        ) AS subcategory_rank
    FROM subcategory_revenue
)
SELECT
    category,
    subcategory,
    total_quantity_sold,
    total_sales_revenue,
    average_selling_price,
    subcategory_rank
FROM ranked_subcategories
WHERE subcategory_rank = 1;