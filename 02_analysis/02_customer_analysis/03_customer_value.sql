-- ================================================================================================
-- CUSTOMER VALUE
-- ================================================================================================


-- -----------------------------------------------------------------------------------------------
-- 1. Customer Value Overview
-- Provides an overall view of customer value by calculating average spending,
-- average order frequency, and average order value across the customer base.
-- -----------------------------------------------------------------------------------------------

SELECT
	COUNT(*) AS total_customers,
	AVG(total_spend) AS average_total_spend,
	AVG(total_orders) AS average_total_order,
	AVG(average_order_value) AS overall_average_order_value
FROM dbo.customers;


-- -----------------------------------------------------------------------------------------------
-- 2. Customer Value by Segment
-- Compares customer segments based on average spending, order frequency, and AOV
-- to understand how customer value differs across segments.
-- -----------------------------------------------------------------------------------------------

SELECT
    customer_segment,
    AVG(total_spend) AS average_total_spend,
	AVG(total_orders) AS average_total_order,
	AVG(average_order_value) AS overall_average_order_value
FROM dbo.customers
GROUP BY customer_segment
ORDER BY average_total_spend DESC;


-- -----------------------------------------------------------------------------------------------
-- 3. Customer Value by Loyalty Tier
-- Compares customer value across loyalty tiers to examine differences in
-- spending, order frequency, and average order value.
-- -----------------------------------------------------------------------------------------------

SELECT
    loyalty_tier,
    AVG(total_spend) AS average_total_spend,
	AVG(total_orders) AS average_total_order,
	AVG(average_order_value) AS overall_average_order_value
FROM dbo.customers
GROUP BY loyalty_tier
ORDER BY
	CASE
        WHEN loyalty_tier = 'Bronze' THEN 1
        WHEN loyalty_tier = 'Silver' THEN 2
        WHEN loyalty_tier = 'Gold' THEN 3
		WHEN loyalty_tier = 'Platinum' THEN 4
    END;


-- -----------------------------------------------------------------------------------------------
-- 4. Top 10 High-Value Customers
-- Identifies the top 10 customers by total spending and shows their segment,
-- loyalty tier, order count, and average order value.
-- -----------------------------------------------------------------------------------------------

SELECT TOP 10
    customer_id AS Customer,
    customer_segment AS Segment,
    loyalty_tier AS Loyalty,
    total_orders AS Orders,
    total_spend AS [Total Spend],
    average_order_value AS AOV
FROM dbo.customers
ORDER BY total_spend DESC;


-- -----------------------------------------------------------------------------------------------
-- 5. Customer Spend Tier Distribution
-- Groups customers into spending tiers to understand the distribution of
-- low-, medium-, high-, and very high-value customers.
-- -----------------------------------------------------------------------------------------------

WITH customer_tier_group AS (
    SELECT
        CASE
            WHEN total_spend < 50000 THEN 'Low Value'
            WHEN total_spend BETWEEN 50000 AND 150000 THEN 'Medium Value'
            WHEN total_spend BETWEEN 150000 AND 300000 THEN 'High Value'
            ELSE 'Very High Value'
        END AS customer_tier
    FROM dbo.customers
)
SELECT
    customer_tier,
    COUNT(*) AS customer_count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS customer_percentage
FROM customer_tier_group
GROUP BY customer_tier
ORDER BY
    CASE
        WHEN customer_tier = 'Low Value' THEN 1
        WHEN customer_tier = 'Medium Value' THEN 2
        WHEN customer_tier = 'High Value' THEN 3
        WHEN customer_tier = 'Very High Value' THEN 4
     END;
