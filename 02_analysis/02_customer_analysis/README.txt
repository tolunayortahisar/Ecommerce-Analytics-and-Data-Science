# Customer Analysis

## Purpose

This analysis explores the customer base of the e-commerce business by examining customer demographics, segmentation, acquisition channels, loyalty levels, and customer value.

The analysis aims to understand who the customers are, how they are distributed across different segments, and how customer value differs between customer groups.

## Analysis Files

### 01_customer_overview.sql

Provides a general overview of the customer base, including:

* Total number of customers
* Average customer age
* Gender distribution
* Age group distribution

### 02_customer_segments.sql

Examines how customers are distributed across key business dimensions:

* Customer segments
* Acquisition channels
* Loyalty tiers
* Preferred devices

### 03_customer_value.sql

Evaluates customer value and purchasing behavior using:

* Average total spend
* Average number of orders
* Average Order Value (AOV)
* Customer value by segment
* Customer value by loyalty tier
* Highest-value customers
* Customer spend tiers

## Key Findings

* The dataset contains **25,000 customers**.
* Customers aged **25–34** represent the largest age group, followed by customers aged **35–44**.
* **Regular customers** are the largest customer segment at approximately **44.01%**, followed by Budget customers at **30.85%**.
* **Organic Search** is the largest acquisition channel, accounting for approximately **22.02%** of customers.
* **Mobile App** is the dominant preferred device, used by approximately **62.20%** of customers.
* More than half of customers (**54.60%**) belong to the Bronze loyalty tier.
* Customer value increases substantially across loyalty tiers. Platinum customers have considerably higher average total spend, order frequency, and Average Order Value than lower loyalty tiers.
* Premium customers also show substantially higher average spending and order frequency than Regular, Budget, and New customer segments.
* The top customers by total spend are concentrated within the **Premium customer segment and Platinum loyalty tier**.
* **51.12%** of customers fall into the Low Spend tier, while **8.41%** are classified as Very High Spend customers.

## SQL Techniques Used

* Aggregate functions (`COUNT`, `SUM`, `AVG`)
* `CAST`
* `CASE`
* `GROUP BY`
* Common Table Expressions (CTEs)
* Window functions
* Percentage calculations
* Conditional aggregation
* Custom sorting
* `TOP`
