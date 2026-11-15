# E-Commerce Analytics & Data Science

### End-to-End Data Analytics, Machine Learning & Business Intelligence Project

An end-to-end data analytics and data science portfolio project combining **Microsoft SQL Server, Python, Machine Learning, and Power BI** to explore e-commerce business performance, understand customer behavior, and develop predictive analytics solutions.

The project demonstrates the complete analytical workflow, from relational database development and SQL-based business analysis to customer segmentation, predictive modeling, and interactive dashboard development.

---

## 1. Project Overview

E-commerce businesses generate large volumes of transactional, customer, product, marketing, and operational data. Transforming these records into actionable insights is essential for understanding business performance and supporting data-driven decision-making.

This project focuses on three complementary areas:

- **Descriptive Analytics:** Understanding historical sales, customer behavior, product performance, and operational efficiency.
- **Customer Analytics & Machine Learning:** Exploring customer characteristics, developing segmentation approaches, and predicting customer value.
- **Business Intelligence:** Communicating business insights and predictive results through interactive Power BI dashboards.

### Project Objectives

- Design and populate a relational database using SQL Server.
- Perform data validation, transformation, and SQL-based analysis.
- Analyze sales trends, customer behavior, product performance, and marketing activities.
- Develop customer segmentation and predictive modeling workflows using Python.
- Evaluate machine learning models using appropriate performance metrics.
- Build interactive Power BI dashboards for business reporting and decision support.
- Demonstrate an integrated, end-to-end analytics workflow.

---

## 2. Technology Stack

| Technology | Purpose |
|---|---|
| Microsoft SQL Server | Relational database management, data preparation, and SQL analysis |
| T-SQL | Data transformation, joins, aggregations, and analytical queries |
| Python | Exploratory data analysis, feature engineering, and machine learning |
| Pandas & NumPy | Data manipulation and numerical analysis |
| Scikit-learn | Machine learning model development and evaluation |
| Jupyter Notebook | Reproducible analytical workflows |
| Power BI | Interactive dashboards, data visualization, and business intelligence |
| Git & GitHub | Version control, documentation, and portfolio presentation |

---

## 3. Dataset Overview

The project uses a multi-table e-commerce dataset covering business activities between **January 2023 and December 2025**.

### Dataset Highlights

| Metric | Value |
|---|---:|
| Analysis Period | 2023–2025 |
| Customers | 25,000 |
| Orders | 100,000 |
| Order Items | 254,331 |
| Products | 550 |
| Marketing Campaigns | 151 |
| Payment Records | 100,000 |
| Shipment Records | 89,681 |

### Main Data Domains

**Customer Data**
Customer demographics, acquisition channels, customer segments, loyalty tiers, and purchasing behavior.

**Sales & Orders**
Order transactions, order values, discounts, payment information, and sales activity.

**Product Data**
Product categories, pricing, costs, profitability, and product performance.

**Marketing Data**
Campaign information, marketing channels, and campaign-related business performance.

**Operational Data**
Shipping activity, delivery performance, and fulfillment-related metrics.

The dataset was obtained from Kaggle and imported into Microsoft SQL Server for further processing and analysis.

**Dataset Source:** [E-Commerce Sales and Customer Analytics — Kaggle](https://www.kaggle.com/datasets/shiyalkishan01/indian-e-commerce-sales-and-customer-analytics)

*Note: Raw dataset files are excluded from this repository. Users can obtain the dataset from its original source.*

---

## 4. Project Workflow

The project follows a structured analytical pipeline:

```text
                 E-COMMERCE DATASET
                         |
                         v
                 SQL SERVER DATABASE
                         |
                         v
              DATA IMPORT & VALIDATION
                         |
                         v
                 SQL BUSINESS ANALYSIS
                         |
                         v
                  PYTHON ANALYTICS
                         |
             +-----------+-----------+
             |                       |
             v                       v
     CUSTOMER SEGMENTATION    CUSTOMER VALUE
                                PREDICTION
             |                       |
             +-----------+-----------+
                         |
                         v
                  POWER BI DASHBOARDS
                         |
                         v
                BUSINESS INSIGHTS
```

This workflow integrates traditional business intelligence techniques with machine learning to support both historical analysis and predictive decision-making.

---

## 5. SQL Analytics

SQL Server serves as the primary data management and analytical environment.

The SQL workflow includes database creation, relational table design, data loading, validation, and business-oriented analytical queries.

### Sales Analysis

- Overall sales performance
- Revenue trends over time
- Order activity and transaction patterns
- Sales performance indicators

### Customer Analysis

- Customer population and characteristics
- Customer segmentation
- Customer spending and purchasing behavior
- Customer value analysis

### Product Analysis

- Product-level sales performance
- Category and subcategory analysis
- Product profitability
- Revenue and profit contribution

### Marketing Analysis

- Marketing campaign performance
- Marketing channel analysis
- Campaign-related business indicators

### Operations Analysis

- Shipping performance
- Delivery efficiency
- Shipment delays and operational patterns

### Returns & Reviews Analysis

The SQL analysis structure also includes dedicated work for returns and customer reviews.

These analyses help organize the business questions into separate, reusable SQL scripts and provide a foundation for dashboard development.

---

## 6. Python & Data Science

Python extends the SQL analysis by supporting exploratory data analysis, feature engineering, customer segmentation, and predictive modeling.

The data science workflow is organized into five stages.

### Stage 1 — Data Preparation

Preparing customer-related analytical data for Python-based processing and machine learning.

### Stage 2 — Exploratory Data Analysis

Investigating customer distributions, purchasing patterns, and relationships between analytical variables.

### Stage 3 — Feature Engineering

Preparing and transforming customer-level features for machine learning.

### Stage 4 — Customer Segmentation

Exploring customer segmentation techniques to better understand differences in customer behavior and value.

### Stage 5 — Customer Value Prediction

Developing supervised machine learning models to identify patterns associated with customer value.

### Predictive Model Performance

The project includes a comparison of Logistic Regression and Random Forest models.

| Model | ROC-AUC |
|---|---:|
| **Logistic Regression** | **0.8563** |
| Random Forest | 0.8491 |

Logistic Regression achieved the higher ROC-AUC score in the recorded evaluation.

**ROC-AUC** measures how effectively a classification model distinguishes between the target classes across different decision thresholds. Higher values indicate better discrimination, although model suitability also depends on the business objective and other evaluation criteria.

The predictive analysis was developed using a customer-level modeling dataset containing **13,633 records**.

---

## 7. Power BI Dashboards

Power BI brings together the analytical findings through four interactive report pages.

### Dashboard 1 — Customer Analysis

Focuses on understanding the customer base and customer-related business indicators.

Key analytical themes include customer characteristics, segmentation, and purchasing behavior.

### Dashboard 2 — Sales Overview

Provides an overview of business sales performance.

Key analytical themes include revenue, order activity, and sales trends.

### Dashboard 3 — Product Analysis

Examines product and category performance.

Key analytical themes include product contribution, category comparisons, and profitability.

### Dashboard 4 — Predictive Analytics

Presents customer-focused predictive analytics results.

This page connects the machine learning component with business intelligence reporting, making predictive information accessible through Power BI.

Together, the four dashboards demonstrate how descriptive and predictive analytics can be combined within a unified reporting environment.

*Dashboard screenshots and a shareable Power BI report version may be added to the repository after the final publication review.*

---

## 8. Repository Structure

```text
Ecommerce-Analytics-and-Data-Science/
|
|-- 01_data_import/
|   |-- 01_create_database.sql
|   |-- 02_create_tables.sql
|   |-- 03_load_data.sql
|
|-- 02_analysis/
|   |-- sales_analysis/
|   |-- customer_analysis/
|   |-- product_analysis/
|   |-- marketing_analysis/
|   |-- operations_analysis/
|   |-- returns_reviews_analysis/
|
|-- 03_customer_data_science/
|   |-- 01_data_preparation/
|   |-- 02_exploratory_data_analysis/
|   |-- 03_feature_engineering/
|   |-- 04_customer_segmentation/
|   |-- 05_customer_value_prediction/
|
|-- 04_power_bi/
|
|-- .gitignore
|-- README.md
```

The repository separates database preparation, SQL business analysis, Python-based data science, and business intelligence reporting into dedicated sections.

This modular structure supports easier navigation, maintenance, and future development.

---

## 9. Key Project Outcomes

The project demonstrates the integration of multiple analytical disciplines within a single business-oriented workflow.

**Database Development**

Designed and populated a relational SQL Server database containing customer, order, product, payment, marketing, and shipment data.

**Business Analytics**

Organized SQL analysis into business domains to investigate performance across sales, customers, products, marketing, and operations.

**Data Science**

Developed Python workflows for customer-level data preparation, exploratory analysis, feature engineering, segmentation, and predictive modeling.

**Machine Learning**

Evaluated Logistic Regression and Random Forest classification models, achieving a best recorded ROC-AUC score of **0.8563**.

**Business Intelligence**

Developed four Power BI report pages covering customer analysis, sales performance, product analysis, and predictive analytics.

**End-to-End Integration**

Connected relational database development, analytical querying, machine learning, and business intelligence into a unified portfolio project.

---

## 10. Reproducing the Project

### Requirements

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- Python and Jupyter Notebook
- Required Python libraries
- ODBC Driver for SQL Server
- Microsoft Power BI Desktop
- Original Kaggle dataset

### General Workflow

1. Download the dataset from the Kaggle source.
2. Create the database using the SQL scripts in `01_data_import`.
3. Configure local CSV paths and import the dataset into SQL Server.
4. Execute the SQL analytical queries in `02_analysis`.
5. Configure the SQL Server connection for the Python notebooks.
6. Run the data preparation, exploratory analysis, feature engineering, segmentation, and prediction notebooks in their intended order.
7. Use the resulting analytical datasets to build or reproduce the Power BI reports.

### SQL Server Connection Configuration

Python notebooks support the `SQL_SERVER` environment variable so that local server names do not need to be hardcoded in the repository.

For example, in Windows Command Prompt:

```cmd
set "SQL_SERVER=YOUR_SQL_SERVER_NAME"
jupyter notebook
```

The environment variable is used by the notebook connection configuration. If it is not set, the notebook uses `localhost` as the default server address.

Users should adjust their database and ODBC configuration according to their local environment.

**Security note:** Local environments, raw data files, credentials, and private connection settings should not be committed to the repository.

---

## 11. Future Improvements

Potential extensions include:

- Adding Power BI dashboard screenshots and documentation.
- Expanding model evaluation with additional business-focused metrics.
- Comparing alternative customer segmentation approaches.
- Improving reproducibility through dependency management and configuration documentation.
- Exploring additional predictive analytics use cases.
- Developing further insights from customer behavior and operational performance.

---

## 12. About the Author

**Tolunay Ortahisar**

Mathematics Graduate — Istanbul University

Interested in Data Analytics, Data Science, Machine Learning, SQL, Python, and Business Intelligence.

This project was developed as a practical portfolio initiative to apply analytical knowledge, strengthen technical skills, and demonstrate an end-to-end data analytics and data science workflow.

**GitHub:** [tolunayortahisar](https://github.com/tolunayortahisar)

---

*This project is intended for educational, analytical, and portfolio purposes.*
