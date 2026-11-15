-- ================================================================================================
-- SALES OVERVIEW
--
-- Note:
-- Only delivered orders are included to represent realized sales.
-- ================================================================================================


-- -----------------------------------------------------------------------------------------------
-- 1. Overall Sales KPIs
-- Calculates the main sales performance metrics for delivered orders.
-- -----------------------------------------------------------------------------------------------

SELECT
    COUNT(order_id) AS total_orders,
    SUM(final_amount) AS total_revenue,
    SUM(shipping_fee) AS total_shipping_fee,
    SUM(tax_amount) AS total_tax,
    CAST(SUM(final_amount) / COUNT(order_id) AS DECIMAL(18,2)) AS average_order_value
FROM dbo.orders
WHERE order_status = 'Delivered';


