# Operations Analysis

## Purpose

This analysis evaluates shipping and delivery performance to understand the operational efficiency of the e-commerce business.

The analysis focuses on delivery duration, shipment delays, delay frequency, and whether delivery performance differs according to order value and delivery location.

## Analysis Files

### 01_shipping_performance.sql

Provides a high-level overview of shipping performance using:

* Total delivered shipments
* Average delivery duration
* Total delayed shipments
* Overall delay rate

Since the `delivery_days` field was unavailable, actual delivery duration was calculated using the difference between dispatch and actual delivery dates.

### 02_delivery_analysis.sql

Examines delivery performance in greater detail, including:

* Delayed vs. on-time shipment distribution
* Delivery performance by order value
* Average Order Value (AOV) for delayed and on-time orders
* Delivery performance by location
* Location-level delay rates

## Key Findings

* Among delivered shipments, **57.17% were delivered on time**, while **42.83% were delayed**.
* The relatively high delay rate indicates a significant opportunity to improve delivery reliability.
* Delayed orders generated approximately **884.71M in revenue**, while on-time orders generated approximately **1.20B**.
* Average Order Value is similar between delayed and on-time orders: approximately **25.61K** for delayed orders and **26.01K** for on-time orders.
* The small difference in AOV suggests that delivery delays are not strongly associated with order value.
* Location-level analysis was also used to identify differences in delivery reliability across cities. Delay rates should be interpreted together with shipment volume to avoid overemphasizing locations with small numbers of shipments.

## SQL Techniques Used

* Aggregate functions (`COUNT`, `SUM`, `AVG`)
* `CAST`
* `CASE`
* `DATEDIFF`
* `GROUP BY`
* `INNER JOIN`
* Window functions
* Percentage calculations
* Conditional aggregation
* Location-based aggregation
