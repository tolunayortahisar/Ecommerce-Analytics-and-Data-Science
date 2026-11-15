-- ================================================================================================
-- CAMPAIGN PERFORMANCE
-- ================================================================================================


-- -----------------------------------------------------------------------------------------------
-- 1. Campaign Performance Overview
-- Summarizes delivered-order performance for each individual marketing campaign.
--
-- This analysis helps identify campaigns generating the highest sales revenue,
-- order volume, and average order value.
-- -----------------------------------------------------------------------------------------------

SELECT
    o.campaign_id AS campaign_id,
    mc.campaign_name AS campaign_name,
    mc.campaign_type AS campaign_type,
    COUNT(o.order_id) AS total_orders,
    SUM(o.final_amount) AS total_revenue,
    CAST(
        SUM(o.final_amount) / COUNT(o.order_id)
        AS DECIMAL(18,2)
    ) AS average_order_value
FROM dbo.orders AS o
INNER JOIN dbo.marketing_campaigns AS mc
    ON o.campaign_id = mc.campaign_id
WHERE o.order_status = 'Delivered'
GROUP BY
    o.campaign_id,
    mc.campaign_name,
    mc.campaign_type
ORDER BY total_revenue DESC;


-- -----------------------------------------------------------------------------------------------
-- 2. Campaign Performance by Type
-- Aggregates campaign performance by campaign type.
--
-- The number of distinct campaigns is included to provide context when comparing
-- total order volume and sales revenue across campaign types.
-- -----------------------------------------------------------------------------------------------

SELECT
    mc.campaign_type AS campaign_type,
    COUNT(DISTINCT mc.campaign_id) AS total_campaigns,
    COUNT(o.order_id) AS total_orders,
    SUM(o.final_amount) AS total_revenue,
    CAST(
        SUM(o.final_amount) / COUNT(o.order_id)
        AS DECIMAL(18,2)
    ) AS average_order_value
FROM dbo.orders AS o
INNER JOIN dbo.marketing_campaigns AS mc
    ON o.campaign_id = mc.campaign_id
WHERE o.order_status = 'Delivered'
GROUP BY
    mc.campaign_type
ORDER BY total_revenue DESC;