-- ================================================================================================
-- SHIPPING PERFORMANCE ANALYSIS
-- ================================================================================================


-- ================================================================================================
-- 1. SHIPPING PERFORMANCE OVERVIEW
--
-- Provides an overall view of delivered shipment performance.
-- Delivery duration is calculated using dispatch and actual delivery dates because
-- the delivery_days column contains no usable values.
-- ================================================================================================

SELECT
    COUNT(*) AS total_delivered_shipments,
    CAST(
        AVG(DATEDIFF(DAY, dispatch_date, actual_delivery_date) * 1.0)
        AS DECIMAL(10,2)
    ) AS average_delivery_days,
    SUM(CAST(delayed_flag AS INT)) AS delayed_shipments,
    CAST(
        SUM(CAST(delayed_flag AS INT)) * 100.0 / COUNT(*)
        AS DECIMAL(18,2)
    ) AS delay_rate
FROM dbo.shipments
WHERE delivery_status = 'Delivered';
