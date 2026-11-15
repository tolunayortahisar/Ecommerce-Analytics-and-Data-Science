-- ================================================================================================
-- CUSTOMER SEGMENTS
-- ================================================================================================


-- -----------------------------------------------------------------------------------------------
-- 1. Customer Segment Distribution
-- Calculates the number and percentage of customers in each customer segment.
-- -----------------------------------------------------------------------------------------------

SELECT
    customer_segment,
    COUNT(*) AS customer_count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS customer_percentage
FROM dbo.customers
GROUP BY customer_segment
ORDER BY customer_count DESC;

-- -----------------------------------------------------------------------------------------------
-- 2. Customer Acquisition Channel Distribution
-- Calculates the number and percentage of customers acquired through each acquisition channel.
-- -----------------------------------------------------------------------------------------------
SELECT
    acquisition_channel,
    COUNT(*) AS customer_count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS acquisition_channel_percentage
FROM dbo.customers
GROUP BY acquisition_channel
ORDER BY customer_count DESC;

-- -----------------------------------------------------------------------------------------------
-- 3. Customer Loyalty Tier Distribution
-- Calculates the number and percentage of customers in each loyalty tier.
-- -----------------------------------------------------------------------------------------------
SELECT
    loyalty_tier,
    COUNT(*) AS customer_count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS loyalty_tier_percentage
FROM dbo.customers
GROUP BY loyalty_tier
ORDER BY customer_count DESC;

-- -----------------------------------------------------------------------------------------------
-- 4. Preferred Device Distribution
-- Calculates the number and percentage of customers by preferred device.
-- Missing device values are retained to make data completeness visible.
-- -----------------------------------------------------------------------------------------------
SELECT
    preferred_device,
    COUNT(*) AS customer_count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS preferred_device_percentage
FROM dbo.customers
GROUP BY preferred_device
ORDER BY customer_count DESC;

