-- ================================================================================================
-- RETURNS ANALYSIS
-- ================================================================================================


-- ================================================================================================
-- 1. RETURN OVERVIEW
--
-- Provides a high-level view of return activity and its financial impact.
-- ================================================================================================

SELECT
    COUNT(*) AS total_returns,
    SUM(refund_amount) AS total_refund_amount,
    CAST(
        AVG(refund_amount)
        AS DECIMAL(18,2)
    ) AS average_refund_amount
FROM dbo.returns;


-- ================================================================================================
-- 2. ORDER RETURN RATE
--
-- Calculates the percentage of unique orders that have at least one return record.
-- DISTINCT is used to prevent multiple return records for the same order
-- from inflating the number of returned orders.
-- ================================================================================================

SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT r.order_id) AS returned_orders,
    CAST(
        COUNT(DISTINCT r.order_id) * 100.0
        / COUNT(DISTINCT o.order_id)
        AS DECIMAL(18,2)
    ) AS return_rate
FROM dbo.orders AS o
LEFT JOIN dbo.returns AS r
    ON o.order_id = r.order_id;


-- ================================================================================================
-- 3. RETURN REASON DISTRIBUTION
--
-- Identifies the most common reasons for product returns and calculates
-- each reason's share of total return records.
-- ================================================================================================

SELECT
    return_reason,
    COUNT(*) AS total_returns,
    CAST(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()
        AS DECIMAL(18,2)
    ) AS percentage_
FROM dbo.returns
GROUP BY
    return_reason
ORDER BY
    percentage_ DESC;


-- ================================================================================================
-- 4. RETURNS BY PRODUCT CATEGORY
--
-- Compares return volume and total refund amounts across product categories.
-- This highlights the difference between return frequency and financial impact.
-- ================================================================================================

SELECT
    p.category,
    COUNT(r.return_id) AS total_returns,
    SUM(r.refund_amount) AS total_refund_amount
FROM dbo.returns AS r
INNER JOIN dbo.products AS p
    ON r.product_id = p.product_id
GROUP BY
    p.category
ORDER BY
    total_returns DESC;