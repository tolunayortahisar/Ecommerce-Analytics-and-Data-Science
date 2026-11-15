# Returns and Customer Reviews Analysis

## Purpose

This analysis evaluates product returns and customer feedback to better understand return behavior, refund impact, customer satisfaction, and product experience.

The analysis focuses on return frequency and reasons, the financial impact of refunds, customer ratings and sentiment, and differences in customer satisfaction across product categories.

## Analysis Files

### 01_returns_analysis.sql

Evaluates product return activity using:

* Total returns
* Total refund amount
* Average refund amount
* Order return rate
* Return reason distribution
* Returns by product category

### 02_customer_reviews.sql

Examines customer feedback and satisfaction using:

* Total reviews
* Average rating
* Verified review percentage
* Rating distribution
* Review sentiment distribution
* Average rating by product category

## Key Findings

* The dataset contains **12,075 return records**, representing approximately **105.90M in total refunds**.
* The average refund amount is approximately **8.77K**.
* **9.51% of all orders** have at least one associated return record.
* **Size Issue** is the most common return reason, accounting for approximately **18.23%** of return records.
* The three most common return reasons — Size Issue, Changed Mind, and Product Damaged — account for approximately **50.67%** of all return records.
* **Fashion** has the highest number of return records, while **Electronics** has a substantially greater financial impact from refunds.
* The review dataset contains **77,530 customer reviews**, with an overall average rating of **3.69 out of 5**.
* Approximately **97.12%** of reviews are associated with verified purchases.
* **59.74%** of customer reviews received 4 or 5 stars, while only **9.04%** received 1 or 2 stars.
* **59.55%** of reviews are classified as Positive, compared with **9.02%** classified as Negative.
* Average ratings vary across product categories, ranging from **3.34 to 4.04**. Pet Supplies has the highest average rating, while Musical Instruments has the lowest.
* Category-level ratings should be interpreted together with review volume, since the number of reviews differs considerably between categories.

## SQL Techniques Used

* Aggregate functions (`COUNT`, `SUM`, `AVG`)
* `COUNT DISTINCT`
* `CAST`
* `CASE`
* `GROUP BY`
* `LEFT JOIN`
* `INNER JOIN`
* Window functions
* Percentage calculations
* Conditional aggregation
* Category-level aggregation
