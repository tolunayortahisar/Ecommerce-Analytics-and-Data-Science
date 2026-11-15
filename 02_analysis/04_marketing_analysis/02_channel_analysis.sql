-- ================================================================================================
-- MARKETING CHANNEL ANALYSIS
-- ================================================================================================


-- ================================================================================================
-- 1. MARKETING CHANNEL PERFORMANCE
--
-- Compares delivered order volume, revenue, and average order value across marketing channels.
-- This helps identify which channels generate the strongest overall sales performance.
-- ================================================================================================

SELECT
    o.marketing_channel AS marketing_channel,
    COUNT(o.order_id) AS total_orders,
    SUM(o.final_amount) AS total_revenue,
    CAST(
        SUM(o.final_amount) / COUNT(o.order_id)
        AS DECIMAL(18,2)
    ) AS average_order_value
FROM dbo.orders AS o
WHERE o.order_status = 'Delivered'
GROUP BY
    o.marketing_channel
ORDER BY total_revenue DESC;


-- ================================================================================================
-- 2. CHANNEL REVENUE CONTRIBUTION
--
-- Calculates each marketing channel's percentage contribution to total delivered sales revenue.
-- This shows how concentrated overall revenue is across different acquisition channels.
-- ================================================================================================

SELECT
    o.marketing_channel AS marketing_channel,
    SUM(o.final_amount) AS total_revenue,
    CAST(
        SUM(o.final_amount) * 100.0
        / SUM(SUM(o.final_amount)) OVER()
        AS DECIMAL(18,2)
    ) AS revenue_percentage
FROM dbo.orders AS o
WHERE o.order_status = 'Delivered'
GROUP BY
    o.marketing_channel
ORDER BY total_revenue DESC;


-- ================================================================================================
-- 3. CHANNEL PERFORMANCE RANKING
--
-- Ranks marketing channels by revenue, order volume, and average order value.
-- Comparing these rankings helps determine whether channel revenue performance is driven
-- primarily by transaction volume or by higher customer spending per order.
-- ================================================================================================

WITH channel AS (
    SELECT
        o.marketing_channel AS marketing_channel,
        COUNT(o.order_id) AS total_orders,
        SUM(o.final_amount) AS total_revenue,
        CAST(
            SUM(o.final_amount) / COUNT(o.order_id)
            AS DECIMAL(18,2)
        ) AS average_order_value
    FROM dbo.orders AS o
    WHERE o.order_status = 'Delivered'
    GROUP BY
        o.marketing_channel
)
SELECT
    marketing_channel,
    total_orders,
    total_revenue,
    average_order_value,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank,
    RANK() OVER (
        ORDER BY total_orders DESC
    ) AS order_volume_rank,
    RANK() OVER (
        ORDER BY average_order_value DESC
    ) AS aov_rank
FROM channel
ORDER BY revenue_rank;
