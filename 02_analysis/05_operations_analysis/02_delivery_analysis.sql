-- ================================================================================================
-- DELIVERY ANALYSIS
-- ================================================================================================


-- ================================================================================================
-- 1. DELIVERY DELAY DISTRIBUTION
--
-- Classifies delivered shipments as Delayed or On Time and calculates
-- the percentage distribution of each delivery outcome.
-- ================================================================================================

SELECT
    CASE
        WHEN delayed_flag = 1 THEN 'Delayed'
        ELSE 'On Time'
    END AS delivery_status_group,
    COUNT(*) AS total_shipments,
    CAST(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()
        AS DECIMAL(18,2)
    ) AS percentage_
FROM dbo.shipments
WHERE delivery_status = 'Delivered'
GROUP BY
    CASE
        WHEN delayed_flag = 1 THEN 'Delayed'
        ELSE 'On Time'
    END;


-- ================================================================================================
-- 2. DELIVERY PERFORMANCE BY ORDER VALUE
--
-- Compares revenue and average order value between delayed and on-time orders
-- to evaluate whether delivery delays are associated with order value.
-- ================================================================================================

SELECT
    CASE
        WHEN s.delayed_flag = 1 THEN 'Delayed'
        ELSE 'On Time'
    END AS delivery_status_group,
    COUNT(*) AS total_orders,
    SUM(o.final_amount) AS total_revenue,
    CAST(
        SUM(o.final_amount) / COUNT(*)
        AS DECIMAL(18,2)
    ) AS average_order_value
FROM dbo.shipments AS s
INNER JOIN dbo.orders AS o
    ON s.order_id = o.order_id
WHERE s.delivery_status = 'Delivered'
GROUP BY
    CASE
        WHEN s.delayed_flag = 1 THEN 'Delayed'
        ELSE 'On Time'
    END;


-- ================================================================================================
-- 3. DELIVERY PERFORMANCE BY LOCATION
--
-- Measures shipment volume and delay rates across delivery cities.
-- This helps identify locations with relatively weaker delivery reliability.
-- Shipment volume should also be considered when interpreting high delay rates.
-- ================================================================================================

SELECT
    s.delivery_city AS delivery_city,
    COUNT(*) AS total_shipments,
    SUM(
        CASE
            WHEN s.delayed_flag = 1 THEN 1
            ELSE 0
        END
    ) AS delayed_shipments,
    CAST(
        SUM(
            CASE
                WHEN s.delayed_flag = 1 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*)
        AS DECIMAL(18,2)
    ) AS delay_rate
FROM dbo.shipments AS s
WHERE s.delivery_status = 'Delivered'
GROUP BY
    s.delivery_city
ORDER BY
    delay_rate DESC;
