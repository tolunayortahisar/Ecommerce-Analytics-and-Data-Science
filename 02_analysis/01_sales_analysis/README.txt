# Sales Analysis

## Purpose

This analysis evaluates the overall sales performance of the e-commerce business, focusing on realized revenue, order trends, average order value, and order outcomes.

Only **Delivered** orders are used when calculating realized sales metrics such as revenue and average order value.

## Analysis Files

### 01_sales_overview.sql

Provides a high-level overview of sales performance using key metrics such as:

* Total delivered orders
* Total revenue
* Total shipping fees
* Total tax
* Average Order Value (AOV)

### 02_sales_trends.sql

Analyzes annual sales performance and changes over time, including:

* Annual order volume
* Annual revenue
* Average Order Value
* Previous-year revenue
* Year-over-year revenue growth

### 03_order_analysis.sql

Examines the overall distribution and outcomes of orders, including:

* Order status distribution
* Completed, unsuccessful, returned, and in-progress orders
* Order value distribution

## Key Findings

* The business recorded **80,679 delivered orders**, generating approximately **2.08B** in realized revenue.
* Overall Average Order Value was approximately **25.83K**.
* Revenue increased by approximately **68.16% in 2025 compared with 2024**, while Average Order Value remained relatively stable.
* The strong revenue increase in 2025 was therefore primarily associated with higher order volume rather than a major increase in order value.
* **80.68%** of all orders were delivered successfully.
* Approximately **10.95%** of orders were unsuccessful when cancelled and failed orders are considered together.

## SQL Techniques Used

* Aggregate functions (`COUNT`, `SUM`, `AVG`)
* `CAST`
* `CASE`
* Common Table Expressions (CTEs)
* Window functions
* `LAG`
* Percentage calculations
* Date-based aggregation
* Conditional filtering
