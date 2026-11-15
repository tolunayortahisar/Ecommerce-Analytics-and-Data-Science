-- ================================================================================================
-- ORDER ANALYSIS
-- ================================================================================================


-- ------------------------------------------------------------------------------------------------
-- 1. Order Status Distribution
-- Calculates the number and percentage of orders for each order status.
-- ------------------------------------------------------------------------------------------------

SELECT
    order_status,
    COUNT(*) AS order_count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS status_percentage
FROM dbo.orders
GROUP BY order_status
ORDER BY order_count DESC;

-- ------------------------------------------------------------------------------------------------
-- 2. Order Outcome Distribution
-- Groups orders by their outcome to analyze completed, unsuccessful, returned, and in-progress orders.
-- ------------------------------------------------------------------------------------------------

SELECT 
    CASE
        WHEN order_status = 'Delivered' THEN 'Completed'
        WHEN order_status IN ('Cancelled' , 'Failed') THEN 'Unsuccessful'
        WHEN order_status = 'Returned' THEN 'Returned'
        WHEN order_status = 'Processing' THEN 'In Progress'
    END AS order_group,
    COUNT(*) AS order_count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS status_percentage
FROM dbo.orders
GROUP BY
    CASE
        WHEN order_status = 'Delivered' THEN 'Completed'
        WHEN order_status IN ('Cancelled' , 'Failed') THEN 'Unsuccessful'
        WHEN order_status = 'Returned' THEN 'Returned'
        WHEN order_status = 'Processing' THEN 'In Progress'
    END
ORDER BY order_count DESC;

-- ------------------------------------------------------------------------------------------------
-- 3. Order Value Distribution
-- Groups orders into value ranges to analyze the distribution of order amounts.
-- ------------------------------------------------------------------------------------------------
SELECT 
    CASE
        WHEN final_amount < 10000 THEN '0-10,000'
        WHEN final_amount < 20000 THEN '10,000-20,000'
        WHEN final_amount < 30000 THEN '20,000-30,000'
        WHEN final_amount < 50000 THEN '30,000-50,000'
        ELSE '50,000+'
    END AS [Order Value Range],
    COUNT(*) AS order_count
FROM dbo.orders
GROUP BY
    CASE
        WHEN final_amount < 10000 THEN '0-10,000'
        WHEN final_amount < 20000 THEN '10,000-20,000'
        WHEN final_amount < 30000 THEN '20,000-30,000'
        WHEN final_amount < 50000 THEN '30,000-50,000'
        ELSE '50,000+'
    END
ORDER BY [Order Value Range];

-- Note: Use square brackets [ ] for column aliases that contain spaces.
-- Single quotes ' ' represent text/string values, not column names.