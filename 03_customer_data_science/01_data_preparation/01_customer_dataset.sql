/*
============================================================
Customer Machine Learning Dataset
============================================================
Creates a customer-level analytical dataset for behavioral
segmentation and customer value modeling.

Population:
- Customers with at least one Delivered order
- One row represents one customer

Reference Date:
- 2025-12-31

The dataset combines purchasing, basket, category, discount,
return, and review behavior into customer-level features.
============================================================
*/



-- Core customer purchase behavior (RFM + average order value)
WITH customer_base AS (
    SELECT
        customer_id,
        DATEDIFF(day, MAX(order_date), '2025-12-31') AS recency_days,
        COUNT(DISTINCT order_id) AS frequency,
        CAST(
            SUM(final_amount) 
            AS DECIMAL(18,2)
        ) AS monetary,
        CAST(
            AVG(final_amount)
            AS DECIMAL(18,2)
        ) AS avg_order_value
    FROM dbo.orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_id
),
-- Average number of purchased items per delivered order
basket_features AS (
    SELECT
        o.customer_id,
        CAST(
            SUM(oi.quantity) * 1.0 / COUNT(DISTINCT o.order_id)
            AS DECIMAL(18,2)
        ) AS avg_items_per_order
    FROM dbo.orders AS o
    INNER JOIN dbo.order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.customer_id
),
-- Aggregate purchased quantities at customer-category level
customer_category AS (
    SELECT
        o.customer_id,
        p.category,
        SUM(oi.quantity) AS category_items,
        COUNT(*) OVER (
            PARTITION BY o.customer_id
        ) AS category_diversity
    FROM dbo.orders AS o
    INNER JOIN dbo.order_items AS oi
        ON o.order_id = oi.order_id
    INNER JOIN dbo.products AS p
        ON oi.product_id = p.product_id
    WHERE o.order_status = 'Delivered'
    GROUP BY
        o.customer_id,
        p.category
),
-- Calculate category-level statistics and rank each customer's categories
category_stats AS (
    SELECT
        customer_id,
        category,
        category_items,
        category_diversity,
        SUM(category_items) OVER (
            PARTITION BY customer_id
        ) AS total_items,
        MAX(category_items) OVER (
            PARTITION BY customer_id
        ) AS favorite_category_items,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY category_items DESC, category ASC
        ) AS rn
    FROM customer_category
),
-- Select each customer's favorite category and category concentration
category_features AS (
    SELECT
        customer_id,
        category_diversity,
        category AS favorite_category,
        CAST(
            favorite_category_items * 1.0 / total_items
            AS DECIMAL(10,4)
        ) AS favorite_category_share
    FROM category_stats
    WHERE rn = 1
),
-- Normalize delivered order frequency by the customer's observation period
-- A minimum 30-day observation window limits extreme rates for new customers
activity_features AS (
    SELECT
        customer_id,
        CAST(
            COUNT(DISTINCT order_id) * 30.44 /
            CASE
                WHEN DATEDIFF(day, MIN(order_date), '2025-12-31') < 30
                    THEN 30
                ELSE DATEDIFF(day, MIN(order_date), '2025-12-31')
            END
            AS DECIMAL(10,2)
        ) AS purchase_frequency
    FROM dbo.orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_id
),
-- Calculate the weighted effective discount received by each customer
discount_features AS (
    SELECT
        o.customer_id,
        CAST(
            (
                SUM(oi.quantity * oi.unit_price) - SUM(oi.item_revenue)
            ) * 1.0
            / NULLIF(SUM(oi.quantity * oi.unit_price), 0)
            AS DECIMAL(10,4)
        ) AS effective_discount_rate
    FROM dbo.orders AS o
    INNER JOIN dbo.order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.customer_id
),
-- Calculate the share of delivered orders associated with a return
-- DISTINCT order_id prevents multiple return records from inflating the rate
return_features AS (
    SELECT
        o.customer_id,
        CAST(
            COUNT(DISTINCT r.order_id) * 1.0 /
            NULLIF(COUNT(DISTINCT o.order_id), 0)
            AS DECIMAL(10,4)
        ) AS returned_order_rate
    FROM dbo.orders AS o
    LEFT JOIN dbo.returns AS r
        ON o.order_id = r.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.customer_id
),
-- Customer review behavior: average rating and share of reviewed orders
-- average_rating remains NULL for customers without rating data
review_features AS (
    SELECT
        o.customer_id,
        CAST(
            AVG(r.rating * 1.0)
            AS DECIMAL(10,2)
        ) AS average_rating,
        CAST(
            COUNT(DISTINCT r.order_id) * 1.0 /
            NULLIF(COUNT(DISTINCT o.order_id), 0)
            AS DECIMAL(10,4)
        ) AS review_rate
    FROM dbo.orders AS o
    LEFT JOIN dbo.customer_reviews AS r
        ON o.order_id = r.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.customer_id
)
-- Combine all behavioral features into one customer-level analytical dataset
SELECT
    cb.customer_id,
    cb.recency_days,
    cb.frequency,
    cb.monetary,
    cb.avg_order_value,
    bf.avg_items_per_order,
    cf.category_diversity,
    cf.favorite_category,
    cf.favorite_category_share,
    af.purchase_frequency,
    df.effective_discount_rate,
    rf.returned_order_rate,
    rvf.average_rating,
    rvf.review_rate
FROM customer_base AS cb
LEFT JOIN basket_features AS bf
    ON cb.customer_id = bf.customer_id
LEFT JOIN category_features AS cf
    ON cb.customer_id = cf.customer_id
LEFT JOIN activity_features AS af
    ON cb.customer_id = af.customer_id
LEFT JOIN discount_features AS df
    ON cb.customer_id = df.customer_id
LEFT JOIN return_features AS rf
    ON cb.customer_id = rf.customer_id
LEFT JOIN review_features AS rvf
    ON cb.customer_id = rvf.customer_id;
