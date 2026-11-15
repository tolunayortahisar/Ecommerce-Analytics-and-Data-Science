/*
    Customer Value Prediction Dataset

    Feature Period : Before 2025-01-01
    Target Period  : 2025-01-01 to 2025-12-31

    Targets:
        future_purchase -> Whether the customer makes a Delivered purchase in 2025
        future_spend    -> Total Delivered spending in 2025
*/

WITH customer_base AS (
    SELECT
        o.customer_id,
        DATEDIFF(day, MAX(o.order_date), '2024-12-31') AS recency_days,
        COUNT(DISTINCT o.order_id) AS frequency,
        CAST(SUM(o.final_amount) AS DECIMAL(18,2)) AS monetary,
        CAST(AVG(o.final_amount) AS DECIMAL(18,2)) AS avg_order_value
    FROM dbo.orders AS o
    WHERE o.order_status = 'Delivered'
      AND o.order_date < '2025-01-01'
    GROUP BY o.customer_id
),

basket_features AS (
    SELECT
        o.customer_id,
        CAST(
            SUM(oi.quantity) * 1.0
            / COUNT(DISTINCT o.order_id)
            AS DECIMAL(18,2)
        ) AS avg_items_per_order
    FROM dbo.orders AS o
    INNER JOIN dbo.order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
      AND o.order_date < '2025-01-01'
    GROUP BY o.customer_id
),

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
      AND o.order_date < '2025-01-01'
    GROUP BY
        o.customer_id,
        p.category
),

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

category_features AS (
    SELECT
        customer_id,
        category_diversity,
        category AS favorite_category,

        CAST(
            favorite_category_items * 1.0
            / total_items
            AS DECIMAL(10,4)
        ) AS favorite_category_share
    FROM category_stats
    WHERE rn = 1
),

activity_features AS (
    SELECT
        o.customer_id,

        CAST(
            COUNT(DISTINCT o.order_id) * 30.44
            /
            CASE
                WHEN DATEDIFF(
                    day,
                    MIN(o.order_date),
                    '2024-12-31'
                ) < 30
                THEN 30
                ELSE DATEDIFF(
                    day,
                    MIN(o.order_date),
                    '2024-12-31'
                )
            END
            AS DECIMAL(10,2)
        ) AS purchase_frequency

    FROM dbo.orders AS o
    WHERE o.order_status = 'Delivered'
      AND o.order_date < '2025-01-01'
    GROUP BY o.customer_id
),

discount_features AS (
    SELECT
        o.customer_id,

        CAST(
            (
                SUM(oi.quantity * oi.unit_price)
                - SUM(oi.item_revenue)
            ) * 1.0
            /
            NULLIF(
                SUM(oi.quantity * oi.unit_price),
                0
            )
            AS DECIMAL(10,4)
        ) AS effective_discount_rate

    FROM dbo.orders AS o
    INNER JOIN dbo.order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
      AND o.order_date < '2025-01-01'
    GROUP BY o.customer_id
),

return_features AS (
    SELECT
        o.customer_id,

        CAST(
            COUNT(DISTINCT r.order_id) * 1.0
            /
            NULLIF(
                COUNT(DISTINCT o.order_id),
                0
            )
            AS DECIMAL(10,4)
        ) AS returned_order_rate

    FROM dbo.orders AS o
    LEFT JOIN dbo.returns AS r
        ON o.order_id = r.order_id
    WHERE o.order_status = 'Delivered'
      AND o.order_date < '2025-01-01'
    GROUP BY o.customer_id
),

review_features AS (
    SELECT
        o.customer_id,

        CAST(
            AVG(r.rating * 1.0)
            AS DECIMAL(10,2)
        ) AS average_rating,

        CAST(
            COUNT(DISTINCT r.order_id) * 1.0
            /
            NULLIF(
                COUNT(DISTINCT o.order_id),
                0
            )
            AS DECIMAL(10,4)
        ) AS review_rate

    FROM dbo.orders AS o
    LEFT JOIN dbo.customer_reviews AS r
        ON o.order_id = r.order_id
    WHERE o.order_status = 'Delivered'
      AND o.order_date < '2025-01-01'
    GROUP BY o.customer_id
),

future_value AS (
    SELECT
        o.customer_id,

        CAST(
            SUM(o.final_amount)
            AS DECIMAL(18,2)
        ) AS future_spend

    FROM dbo.orders AS o
    WHERE o.order_status = 'Delivered'
      AND o.order_date >= '2025-01-01'
      AND o.order_date < '2026-01-01'
    GROUP BY o.customer_id
)

SELECT
    cb.customer_id,

    -- Historical Features
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
    rvf.review_rate,

    -- Classification Target
    CASE
        WHEN fv.future_spend > 0 THEN 1
        ELSE 0
    END AS future_purchase,

    -- Regression Target
    CAST(
        COALESCE(fv.future_spend, 0)
        AS DECIMAL(18,2)
    ) AS future_spend

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
    ON cb.customer_id = rvf.customer_id

LEFT JOIN future_value AS fv
    ON cb.customer_id = fv.customer_id;