-- ================================================================================================
-- CUSTOMER REVIEWS ANALYSIS
-- ================================================================================================


-- ================================================================================================
-- 1. REVIEW OVERVIEW
--
-- Provides a high-level view of customer reviews, including average rating
-- and the share of reviews associated with verified purchases.
-- ================================================================================================

SELECT
    COUNT(*) AS total_reviews,
    CAST(
        AVG(rating * 1.0)
        AS DECIMAL(18,2)
    ) AS average_rating,
    SUM(
        CASE
            WHEN verified_purchase = 'True' THEN 1
            ELSE 0
        END
    ) AS verified_reviews,
    CAST(
        SUM(
            CASE
                WHEN verified_purchase = 'True' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*)
        AS DECIMAL(18,2)
    ) AS verified_review_percentage
FROM dbo.customer_reviews;


-- ================================================================================================
-- 2. RATING DISTRIBUTION
--
-- Shows how customer reviews are distributed across the 1–5 rating scale
-- and calculates each rating's percentage of total reviews.
-- ================================================================================================

SELECT
    rating,
    COUNT(*) AS total_reviews,
    CAST(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()
        AS DECIMAL(18,2)
    ) AS percentage_
FROM dbo.customer_reviews
GROUP BY rating
ORDER BY rating DESC;


-- ================================================================================================
-- 3. REVIEW SENTIMENT DISTRIBUTION
--
-- Analyzes the distribution of Positive, Neutral, and Negative customer reviews
-- and calculates each sentiment group's share of total reviews.
-- ================================================================================================

SELECT
    review_sentiment,
    COUNT(*) AS total_reviews,
    CAST(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()
        AS DECIMAL(18,2)
    ) AS percentage_
FROM dbo.customer_reviews
GROUP BY review_sentiment
ORDER BY total_reviews DESC;


-- ================================================================================================
-- 4. CUSTOMER RATINGS BY PRODUCT CATEGORY
--
-- Compares customer satisfaction across product categories using average ratings.
-- Review volume is included to provide context when comparing category-level ratings.
-- ================================================================================================

SELECT
    p.category,
    COUNT(*) AS total_reviews,
    CAST(
        AVG(cr.rating * 1.0)
        AS DECIMAL(18,2)
    ) AS average_rating
FROM dbo.customer_reviews AS cr
INNER JOIN dbo.products AS p
    ON cr.product_id = p.product_id
GROUP BY
    p.category
ORDER BY
    average_rating DESC;
