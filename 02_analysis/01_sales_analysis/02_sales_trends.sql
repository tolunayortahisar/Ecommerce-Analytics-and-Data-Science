-- ================================================================================================
-- SALES TRENDS
--
-- Note:
-- Only delivered orders are included to represent realized sales.
-- ================================================================================================


-- -----------------------------------------------------------------------------------------------
-- 1. Yearly Sales Performance
-- Compares order volume, revenue, AOV, and revenue growth across years.
-- LAG() is used to retrieve the previous year's revenue for year-over-year comparison.
-- -----------------------------------------------------------------------------------------------

SELECT
    YEAR(order_date) AS order_year,
    COUNT(order_id) AS total_orders,
    SUM(final_amount) AS total_revenue,
    LAG(SUM(final_amount)) OVER (ORDER BY YEAR(order_date)) AS previous_year_total_revenue,
    CAST(SUM(final_amount) / COUNT(order_id) AS DECIMAL(18,2)) AS average_order_value,
    (SUM(final_amount) - LAG(SUM(final_amount)) OVER (ORDER BY YEAR(order_date))) / LAG(SUM(final_amount)) OVER (ORDER BY YEAR(order_date)) * 100.0 AS revenue_rate
FROM dbo.orders
WHERE order_status = 'Delivered'
GROUP BY YEAR(order_date)
ORDER BY order_year DESC;
