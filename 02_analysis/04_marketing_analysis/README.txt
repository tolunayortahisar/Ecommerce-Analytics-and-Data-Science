# Marketing Analysis

## Purpose

This analysis evaluates marketing performance from campaign and order-level channel perspectives.

The analysis focuses on understanding which campaigns and marketing channels generate the most orders and revenue, how Average Order Value (AOV) differs across them, and whether revenue performance is primarily associated with order volume or order value.

> **Data Limitation:** Campaign budget data was unavailable for all campaigns. Therefore, budget-efficiency and ROI-based metrics were excluded from the analysis.

## Analysis Files

### 01_campaign_performance.sql

Evaluates marketing campaign performance using:

* Total orders
* Total revenue
* Average Order Value (AOV)
* Campaign-level performance
* Performance by campaign type

### 02_channel_analysis.sql

Examines order-level marketing channel performance using:

* Total orders
* Total revenue
* Average Order Value
* Revenue contribution
* Revenue, order volume, and AOV rankings

## Key Findings

* The highest-revenue campaign generated approximately **16.22M in revenue from 567 delivered orders**.
* The campaign with the highest revenue did not have the highest Average Order Value, showing that campaign revenue is influenced by both order volume and order value.
* **Organic Search** is the strongest marketing channel by both order volume and revenue, generating **18,416 delivered orders** and approximately **479.08M in revenue**.
* Organic Search contributes approximately **22.98% of total channel revenue**.
* The top four channels — **Organic Search, Direct/App, Paid Search, and Instagram** — account for approximately **61.05% of channel revenue**.
* Revenue rankings and order-volume rankings are identical across the analyzed marketing channels.
* Average Order Values are relatively similar across channels, indicating that differences in channel revenue are primarily associated with **order volume rather than major differences in order value**.
* **SMS Marketing** has the highest Average Order Value among the analyzed channels but the lowest order volume, demonstrating that a high AOV alone does not necessarily produce high total revenue.

## SQL Techniques Used

* Aggregate functions (`COUNT`, `SUM`)
* `COUNT DISTINCT`
* `CAST`
* `GROUP BY`
* `INNER JOIN`
* Common Table Expressions (CTEs)
* Window functions
* `RANK`
* Revenue contribution calculations
* Average Order Value calculations
* Multi-metric performance ranking
