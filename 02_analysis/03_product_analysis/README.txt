# Product Analysis

## Purpose

This analysis evaluates product and category performance from both sales and profitability perspectives.

The analysis focuses on identifying high-performing products, understanding the relationship between sales volume and revenue, comparing category and subcategory performance, and examining how revenue performance differs from profitability.

## Analysis Files

### 01_product_performance.sql

Evaluates individual product performance using:

* Total quantity sold
* Total sales revenue
* Average selling price
* Top products by revenue
* Top products by sales volume
* Product performance by category
* Top revenue-generating product within each category

### 02_category_analysis.sql

Examines sales performance at category and subcategory levels, including:

* Total quantity sold
* Total sales revenue
* Average selling price
* Category performance
* Subcategory performance
* Top revenue-generating subcategory within each category

### 03_product_profitability.sql

Analyzes product and category profitability using:

* Product-level profit margin
* Estimated product profit
* Category revenue
* Category profit
* Category profit margin
* Profitability classification

## Key Findings

* Product sales volume and revenue do not necessarily move together. Some high-priced products generate substantial revenue without being among the highest-volume products.
* **Fashion** has the highest sales volume, while **Electronics** generates substantially more revenue.
* Revenue within Electronics is strongly supported by high-value subcategories such as **Smartwatches, Laptops, and Smartphones**.
* Fashion subcategories generally generate stronger unit volumes at lower average selling prices.
* The highest-revenue product is not necessarily the most profitable product, showing the importance of evaluating profitability separately from revenue.
* **Electronics** generates approximately **1.22B in revenue**, but its estimated category profit margin is only about **0.69%**.
* **Fashion**, despite generating considerably less revenue than Electronics, produces approximately **46.19M in estimated profit** with a profit margin of about **33.14%**.
* These results demonstrate that revenue, sales volume, and profitability provide different perspectives on product performance.

## SQL Techniques Used

* Aggregate functions (`COUNT`, `SUM`, `AVG`)
* `CAST`
* `CASE`
* `GROUP BY`
* `INNER JOIN`
* Common Table Expressions (CTEs)
* Window functions
* `RANK`
* `PARTITION BY`
* `TOP`
* Profit and profit margin calculations
* Custom profitability classification
