-- ================================================================================================
-- CUSTOMER OVERVIEW
-- ================================================================================================


-- -----------------------------------------------------------------------------------------------
-- 1. Overall Customer KPIs
-- Calculates the total number of customers, average age, and customer count by gender.
-- -----------------------------------------------------------------------------------------------

SELECT
    COUNT(*) AS total_customers,
    CAST(AVG(age) AS DECIMAL(5,2)) AS average_age,
    SUM(
        CASE
            WHEN gender = 'Male' THEN 1
            ELSE 0
        END
    ) AS male_customer_count,
    SUM(
        CASE
            WHEN gender = 'Female' THEN 1
            ELSE 0
        END
    ) AS female_customer_count
FROM dbo.customers;


-- -----------------------------------------------------------------------------------------------
-- 2. Customer Gender Distribution
-- Calculates the number and percentage of customers by gender.
-- -----------------------------------------------------------------------------------------------

SELECT
    gender,
    COUNT(*) AS customer_count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS gender_percentage
FROM dbo.customers
GROUP BY gender;


-- -----------------------------------------------------------------------------------------------
-- 3. Customer Age Distribution
-- Groups customers by age range to understand the demographic structure of the customer base.
-- -----------------------------------------------------------------------------------------------

WITH customer_age_groups AS (
    SELECT
        CASE
            WHEN age < 25 THEN 'Under 25'
            WHEN age BETWEEN 25 AND 34 THEN '25-34'
            WHEN age BETWEEN 35 AND 44 THEN '35-44'
            WHEN age BETWEEN 45 AND 54 THEN '45-54'
            ELSE '55+'
        END AS age_group
    FROM dbo.customers
)
SELECT
    age_group,
    COUNT(*) AS customer_count
FROM customer_age_groups
GROUP BY age_group
ORDER BY
    CASE
        WHEN age_group = 'Under 25' THEN 1
        WHEN age_group = '25-34' THEN 2
        WHEN age_group = '35-44' THEN 3
        WHEN age_group = '45-54' THEN 4
        WHEN age_group = '55+' THEN 5
    END;

-- Note: A CTE is used to create the age group once and reuse it for grouping and custom sorting.
