-- ================================================================================================
-- 1. CUSTOMERS DATA LOAD
-- Load raw CSV data into staging, validate, and transform.
-- ================================================================================================

CREATE TABLE dbo.customers_staging (
    customer_id VARCHAR(50),
    customer_signup_date VARCHAR(50),
    gender VARCHAR(50),
    age VARCHAR(50),
    age_group VARCHAR(50),
    state_ VARCHAR(100),
    city VARCHAR(100),
    pincode_prefix VARCHAR(50),
    customer_segment VARCHAR(50),
    preferred_device VARCHAR(50),
    preferred_payment_method VARCHAR(50),
    acquisition_channel VARCHAR(100),
    total_orders VARCHAR(50),
    total_spend VARCHAR(50),
    last_order_date VARCHAR(50),
    average_order_value VARCHAR(50),
    customer_status VARCHAR(50),
    loyalty_tier VARCHAR(50)
);


-- Load raw CSV data into staging.

BULK INSERT dbo.customers_staging
FROM 'C:\archive\customers.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);


-- Check for duplicate customer IDs.

SELECT
    customer_id,
    COUNT(*) AS record_count
FROM dbo.customers_staging
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- Check data type conversions.

SELECT
    COUNT(*) AS TotalRows,
    COUNT(TRY_CONVERT(INT, age)) AS ValidAge,
    COUNT(TRY_CONVERT(INT, total_orders)) AS ValidTotalOrders,
    COUNT(TRY_CONVERT(DECIMAL(18,2), total_spend)) AS ValidTotalSpend,
    COUNT(TRY_CONVERT(DATE, customer_signup_date)) AS ValidSignupDate,
    COUNT(TRY_CONVERT(DATE, last_order_date)) AS ValidLastOrderDate,
    COUNT(TRY_CONVERT(DECIMAL(18,2), average_order_value)) AS ValidAverageOrderValue
FROM dbo.customers_staging;


-- Load transformed data into the final table.

INSERT INTO dbo.customers (
    customer_id,
    customer_signup_date,
    gender,
    age,
    age_group,
    state_,
    city,
    pincode_prefix,
    customer_segment,
    preferred_device,
    preferred_payment_method,
    acquisition_channel,
    total_orders,
    total_spend,
    last_order_date,
    average_order_value,
    customer_status,
    loyalty_tier
)
SELECT
    customer_id,
    TRY_CONVERT(DATE, customer_signup_date),
    gender,
    age,
    age_group,
    state_,
    city,
    TRY_CONVERT(INT, pincode_prefix),
    customer_segment,
    preferred_device,
    preferred_payment_method,
    acquisition_channel,
    TRY_CONVERT(INT, total_orders),
    TRY_CONVERT(DECIMAL(18,2), total_spend),
    TRY_CONVERT(DATE, last_order_date),
    TRY_CONVERT(DECIMAL(18,2), average_order_value),
    customer_status,
    loyalty_tier
FROM dbo.customers_staging;


-- Verify final row count.

SELECT COUNT(*) AS TotalCustomers
FROM dbo.customers;


-- ================================================================================================
-- 2. PRODUCTS DATA LOAD
-- Load raw data into staging, validate, and transform.
-- ================================================================================================

CREATE TABLE dbo.products_staging (
    product_id VARCHAR(50),
    product_name VARCHAR(255),
    category VARCHAR(100),
    subcategory VARCHAR(100),
    brand VARCHAR(100),
    price VARCHAR(50),
    cost_price VARCHAR(50),
    discount_range VARCHAR(50),
    rating_average VARCHAR(50),
    rating_count VARCHAR(50),
    stock_quantity VARCHAR(50),
    product_launch_date VARCHAR(50),
    product_type VARCHAR(50),
    return_rate_baseline VARCHAR(50)
);


-- Load raw CSV data into staging.

BULK INSERT dbo.products_staging
FROM 'C:\archive\products.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);


-- Check for duplicate product IDs.

SELECT
    product_id,
    COUNT(*) AS record_count
FROM dbo.products_staging
GROUP BY product_id
HAVING COUNT(*) > 1;


-- Check data type conversions.

SELECT
    COUNT(*) AS TotalRows,
    COUNT(TRY_CONVERT(DECIMAL(18,2), price)) AS ValidPrice,
    COUNT(TRY_CONVERT(DECIMAL(18,2), cost_price)) AS ValidCostPrice,
    COUNT(TRY_CONVERT(DECIMAL(3,2), rating_average)) AS ValidRating,
    COUNT(TRY_CONVERT(INT, rating_count)) AS ValidRatingCount,
    COUNT(TRY_CONVERT(INT, stock_quantity)) AS ValidStock,
    COUNT(TRY_CONVERT(DATE, product_launch_date)) AS ValidLaunchDate,
    COUNT(TRY_CONVERT(DECIMAL(5,4), return_rate_baseline)) AS ValidReturnRate
FROM dbo.products_staging;


-- Load transformed data into the final table.

INSERT INTO dbo.products (
    product_id,
    product_name,
    category,
    subcategory,
    brand,
    price,
    cost_price,
    discount_range,
    rating_average,
    rating_count,
    stock_quantity,
    product_launch_date,
    product_type,
    return_rate_baseline
)
SELECT
    product_id,
    product_name,
    category,
    subcategory,
    brand,
    TRY_CONVERT(DECIMAL(18,2), price),
    TRY_CONVERT(DECIMAL(18,2), cost_price),
    discount_range,
    TRY_CONVERT(DECIMAL(3,2), rating_average),
    TRY_CONVERT(INT, rating_count),
    TRY_CONVERT(INT, stock_quantity),
    TRY_CONVERT(DATE, product_launch_date),
    product_type,
    TRY_CONVERT(DECIMAL(5,4), return_rate_baseline)
FROM dbo.products_staging;


-- Verify final row count.

SELECT COUNT(*) AS TotalProducts
FROM dbo.products;


-- ================================================================================================
-- 3. MARKETING CAMPAIGNS DATA LOAD
-- Load raw data into staging, validate, and transform.
-- ================================================================================================

CREATE TABLE dbo.marketing_campaigns_staging (
    campaign_id VARCHAR(50),
    campaign_name VARCHAR(255),
    channel VARCHAR(100),
    campaign_start_date VARCHAR(50),
    campaign_end_date VARCHAR(50),
    campaign_type VARCHAR(100),
    target_segment VARCHAR(50),
    discount_percentage VARCHAR(50),
    conversions VARCHAR(50),
    revenue_generated VARCHAR(50),
    impressions VARCHAR(50),
    clicks VARCHAR(50),
    campaign_cost VARCHAR(50),
    roi VARCHAR(50)
);


-- Load raw CSV data into staging.

BULK INSERT dbo.marketing_campaigns_staging
FROM 'C:\archive\marketing_campaigns.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);


-- Check for duplicate campaign IDs.

SELECT
    campaign_id,
    COUNT(*) AS record_count
FROM dbo.marketing_campaigns_staging
GROUP BY campaign_id
HAVING COUNT(*) > 1;


-- Check data type conversions for fields used in the final table.

SELECT
    COUNT(*) AS TotalRows,
    COUNT(TRY_CONVERT(DATE, campaign_start_date)) AS ValidStartDate,
    COUNT(TRY_CONVERT(DATE, campaign_end_date)) AS ValidEndDate
FROM dbo.marketing_campaigns_staging;


-- Load transformed data into the final table.

INSERT INTO dbo.marketing_campaigns (
    campaign_id,
    campaign_name,
    campaign_type,
    start_date,
    end_date,
    target_audience,
    channel
)
SELECT
    campaign_id,
    campaign_name,
    campaign_type,
    TRY_CONVERT(DATE, campaign_start_date),
    TRY_CONVERT(DATE, campaign_end_date),
    target_segment,
    channel
FROM dbo.marketing_campaigns_staging;


-- Verify final row count.

SELECT COUNT(*) AS TotalCampaigns
FROM dbo.marketing_campaigns;


-- ================================================================================================
-- 4. ORDERS DATA LOAD
-- Load raw data into staging, validate, and transform.
-- ================================================================================================

CREATE TABLE dbo.orders_staging (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_date VARCHAR(50),
    order_time VARCHAR(50),
    order_status VARCHAR(50),
    shipping_method VARCHAR(100),
    delivery_city VARCHAR(100),
    delivery_state VARCHAR(100),
    coupon_code VARCHAR(50),
    discount_percentage VARCHAR(50),
    marketing_channel VARCHAR(100),
    subtotal VARCHAR(50),
    shipping_fee VARCHAR(50),
    tax_amount VARCHAR(50),
    final_amount VARCHAR(50),
    campaign_id VARCHAR(50)
);


-- Load raw CSV data into staging.

BULK INSERT dbo.orders_staging
FROM 'C:\archive\orders.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);


-- Check row count.

SELECT COUNT(*) AS TotalRows
FROM dbo.orders_staging;


-- Check for duplicate order IDs.

SELECT
    order_id,
    COUNT(*) AS record_count
FROM dbo.orders_staging
GROUP BY order_id
HAVING COUNT(*) > 1;


-- Check data type conversions.

SELECT
    COUNT(*) AS TotalRows,
    COUNT(TRY_CONVERT(DATE, order_date)) AS ValidOrderDate,
    COUNT(TRY_CONVERT(TIME, order_time)) AS ValidOrderTime,
    COUNT(TRY_CONVERT(DECIMAL(5,2), discount_percentage)) AS ValidDiscount,
    COUNT(TRY_CONVERT(DECIMAL(18,2), subtotal)) AS ValidSubtotal,
    COUNT(TRY_CONVERT(DECIMAL(18,2), shipping_fee)) AS ValidShippingFee,
    COUNT(TRY_CONVERT(DECIMAL(18,2), tax_amount)) AS ValidTax,
    COUNT(TRY_CONVERT(DECIMAL(18,2), final_amount)) AS ValidFinalAmount
FROM dbo.orders_staging;


-- Check customer relationships.

SELECT COUNT(*) AS InvalidCustomerIDs
FROM dbo.orders_staging o
LEFT JOIN dbo.customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- Check campaign relationships.

SELECT COUNT(*) AS InvalidCampaignIDs
FROM dbo.orders_staging o
LEFT JOIN dbo.marketing_campaigns c
    ON o.campaign_id = c.campaign_id
WHERE o.campaign_id IS NOT NULL
  AND c.campaign_id IS NULL;


-- Load transformed data into the final table.

INSERT INTO dbo.orders (
    order_id,
    customer_id,
    order_date,
    order_time,
    order_status,
    shipping_method,
    delivery_city,
    delivery_state,
    coupon_code,
    discount_percentage,
    marketing_channel,
    subtotal,
    shipping_fee,
    tax_amount,
    final_amount,
    campaign_id
)
SELECT
    order_id,
    customer_id,
    TRY_CONVERT(DATE, order_date),
    TRY_CONVERT(TIME, order_time),
    order_status,
    shipping_method,
    delivery_city,
    delivery_state,
    coupon_code,
    TRY_CONVERT(DECIMAL(5,2), discount_percentage),
    marketing_channel,
    TRY_CONVERT(DECIMAL(18,2), subtotal),
    TRY_CONVERT(DECIMAL(18,2), shipping_fee),
    TRY_CONVERT(DECIMAL(18,2), tax_amount),
    TRY_CONVERT(DECIMAL(18,2), final_amount),
    campaign_id
FROM dbo.orders_staging;


-- Verify final row count.

SELECT COUNT(*) AS TotalOrders
FROM dbo.orders;


-- ================================================================================================
-- 5. ORDER ITEMS DATA LOAD
-- Load raw data into staging, validate, and transform.
-- ================================================================================================

CREATE TABLE dbo.order_items_staging (
    order_item_id VARCHAR(50),
    order_id VARCHAR(50),
    product_id VARCHAR(50),
    quantity VARCHAR(50),
    unit_price VARCHAR(50),
    discount_percentage VARCHAR(50),
    item_revenue VARCHAR(50),
    item_cost VARCHAR(50),
    profit VARCHAR(50)
);


-- Load raw CSV data into staging.

BULK INSERT dbo.order_items_staging
FROM 'C:\archive\order_items.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);


-- Check row count.

SELECT COUNT(*) AS TotalRows
FROM dbo.order_items_staging;


-- Check for duplicate order item IDs.

SELECT
    order_item_id,
    COUNT(*) AS record_count
FROM dbo.order_items_staging
GROUP BY order_item_id
HAVING COUNT(*) > 1;


-- Check data type conversions.

SELECT
    COUNT(*) AS TotalRows,
    COUNT(TRY_CONVERT(INT, quantity)) AS ValidQuantity,
    COUNT(TRY_CONVERT(DECIMAL(18,2), unit_price)) AS ValidUnitPrice,
    COUNT(TRY_CONVERT(DECIMAL(5,2), discount_percentage)) AS ValidDiscount,
    COUNT(TRY_CONVERT(DECIMAL(18,2), item_revenue)) AS ValidRevenue,
    COUNT(TRY_CONVERT(DECIMAL(18,2), item_cost)) AS ValidCost,
    COUNT(TRY_CONVERT(DECIMAL(18,2), profit)) AS ValidProfit
FROM dbo.order_items_staging;


-- Check order relationships.

SELECT COUNT(*) AS InvalidOrderIDs
FROM dbo.order_items_staging oi
LEFT JOIN dbo.orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- Check product relationships.

SELECT COUNT(*) AS InvalidProductIDs
FROM dbo.order_items_staging oi
LEFT JOIN dbo.products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


-- Load transformed data into the final table.

INSERT INTO dbo.order_items (
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    discount_percentage,
    item_revenue,
    item_cost,
    profit
)
SELECT
    order_item_id,
    order_id,
    product_id,
    TRY_CONVERT(INT, quantity),
    TRY_CONVERT(DECIMAL(18,2), unit_price),
    TRY_CONVERT(DECIMAL(5,2), discount_percentage),
    TRY_CONVERT(DECIMAL(18,2), item_revenue),
    TRY_CONVERT(DECIMAL(18,2), item_cost),
    TRY_CONVERT(DECIMAL(18,2), profit)
FROM dbo.order_items_staging;


-- Verify final row count.

SELECT COUNT(*) AS TotalOrderItems
FROM dbo.order_items;


-- ================================================================================================
-- 6. PAYMENTS DATA LOAD
-- Load raw data into staging, validate, and transform.
-- ================================================================================================

CREATE TABLE dbo.payments_staging (
    payment_id VARCHAR(50),
    order_id VARCHAR(50),
    payment_date VARCHAR(50),
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    amount_paid VARCHAR(50),
    transaction_fee VARCHAR(50),
    refund_amount VARCHAR(50)
);


-- Load raw CSV data into staging.

BULK INSERT dbo.payments_staging
FROM 'C:\archive\payments.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);


-- Check row count.

SELECT COUNT(*) AS TotalRows
FROM dbo.payments_staging;


-- Check for duplicate payment IDs.

SELECT
    payment_id,
    COUNT(*) AS record_count
FROM dbo.payments_staging
GROUP BY payment_id
HAVING COUNT(*) > 1;


-- Check data type conversions.

SELECT
    COUNT(*) AS TotalRows,
    COUNT(TRY_CONVERT(DATE, payment_date)) AS ValidPaymentDate,
    COUNT(TRY_CONVERT(DECIMAL(18,2), amount_paid)) AS ValidAmountPaid,
    COUNT(TRY_CONVERT(DECIMAL(18,2), transaction_fee)) AS ValidTransactionFee,
    COUNT(TRY_CONVERT(DECIMAL(18,2), refund_amount)) AS ValidRefundAmount
FROM dbo.payments_staging;


-- Check order relationships.

SELECT COUNT(*) AS InvalidOrderIDs
FROM dbo.payments_staging p
LEFT JOIN dbo.orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;


-- Load transformed data into the final table.

INSERT INTO dbo.payments (
    payment_id,
    order_id,
    payment_date,
    payment_method,
    payment_status,
    amount_paid,
    transaction_fee,
    refund_amount
)
SELECT
    payment_id,
    order_id,
    TRY_CONVERT(DATE, payment_date),
    payment_method,
    payment_status,
    TRY_CONVERT(DECIMAL(18,2), amount_paid),
    TRY_CONVERT(DECIMAL(18,2), transaction_fee),
    TRY_CONVERT(DECIMAL(18,2), refund_amount)
FROM dbo.payments_staging;


-- Verify final row count.

SELECT COUNT(*) AS TotalPayments
FROM dbo.payments;


-- ================================================================================================
-- 7. SHIPMENTS DATA LOAD
-- Load raw data into staging, validate, and transform.
-- ================================================================================================

CREATE TABLE dbo.shipments_staging (
    shipment_id VARCHAR(50),
    order_id VARCHAR(50),
    warehouse_city VARCHAR(100),
    delivery_city VARCHAR(100),
    shipping_method VARCHAR(50),
    dispatch_date VARCHAR(50),
    expected_delivery_date VARCHAR(50),
    actual_delivery_date VARCHAR(50),
    delivery_days VARCHAR(50),
    delivery_status VARCHAR(50),
    delayed_flag VARCHAR(50)
);


-- Load raw CSV data into staging.

BULK INSERT dbo.shipments_staging
FROM 'C:\archive\shipments.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);


-- Check row count.

SELECT COUNT(*) AS TotalRows
FROM dbo.shipments_staging;


-- Check for duplicate shipment IDs.

SELECT
    shipment_id,
    COUNT(*) AS record_count
FROM dbo.shipments_staging
GROUP BY shipment_id
HAVING COUNT(*) > 1;


-- Check data type conversions.

SELECT
    COUNT(*) AS TotalRows,
    COUNT(TRY_CONVERT(DATE, dispatch_date)) AS ValidDispatchDate,
    COUNT(TRY_CONVERT(DATE, expected_delivery_date)) AS ValidExpectedDate,
    COUNT(TRY_CONVERT(DATE, actual_delivery_date)) AS ValidActualDate,
    COUNT(TRY_CONVERT(INT, TRY_CONVERT(DECIMAL(10,1), delivery_days))) AS ValidDeliveryDays,
    COUNT(TRY_CONVERT(BIT, delayed_flag)) AS ValidDelayedFlag
FROM dbo.shipments_staging;


-- Check order relationships.

SELECT COUNT(*) AS InvalidOrderIDs
FROM dbo.shipments_staging s
LEFT JOIN dbo.orders o
    ON s.order_id = o.order_id
WHERE o.order_id IS NULL;


-- Load transformed data into the final table.

INSERT INTO dbo.shipments (
    shipment_id,
    order_id,
    warehouse_city,
    delivery_city,
    shipping_method,
    dispatch_date,
    expected_delivery_date,
    actual_delivery_date,
    delivery_days,
    delivery_status,
    delayed_flag
)
SELECT
    shipment_id,
    order_id,
    warehouse_city,
    delivery_city,
    shipping_method,
    TRY_CONVERT(DATE, dispatch_date),
    TRY_CONVERT(DATE, expected_delivery_date),
    TRY_CONVERT(DATE, actual_delivery_date),
    TRY_CONVERT(INT, TRY_CONVERT(DECIMAL(10,1), delivery_days)),
    delivery_status,
    TRY_CONVERT(BIT, delayed_flag)
FROM dbo.shipments_staging;


-- Verify final row count.

SELECT COUNT(*) AS TotalShipments
FROM dbo.shipments;


-- ================================================================================================
-- 8. RETURNS DATA LOAD
-- Load raw data into staging, validate, and transform.
-- ================================================================================================

CREATE TABLE dbo.returns_staging (
    return_id VARCHAR(50),
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    product_id VARCHAR(50),
    return_date VARCHAR(50),
    return_reason VARCHAR(100),
    refund_amount VARCHAR(50),
    return_status VARCHAR(50)
);


-- Load raw CSV data into staging.

BULK INSERT dbo.returns_staging
FROM 'C:\archive\returns.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);


-- Check row count.

SELECT COUNT(*) AS TotalRows
FROM dbo.returns_staging;


-- Check for duplicate return IDs.

SELECT
    return_id,
    COUNT(*) AS record_count
FROM dbo.returns_staging
GROUP BY return_id
HAVING COUNT(*) > 1;


-- Check data type conversions.

SELECT
    COUNT(*) AS TotalRows,
    COUNT(TRY_CONVERT(DATE, return_date)) AS ValidReturnDate,
    COUNT(TRY_CONVERT(DECIMAL(18,2), refund_amount)) AS ValidRefundAmount
FROM dbo.returns_staging;


-- Check order relationships.

SELECT COUNT(*) AS InvalidOrderIDs
FROM dbo.returns_staging r
LEFT JOIN dbo.orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;


-- Check customer relationships.

SELECT COUNT(*) AS InvalidCustomerIDs
FROM dbo.returns_staging r
LEFT JOIN dbo.customers c
    ON r.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- Check product relationships.

SELECT COUNT(*) AS InvalidProductIDs
FROM dbo.returns_staging r
LEFT JOIN dbo.products p
    ON r.product_id = p.product_id
WHERE p.product_id IS NULL;


-- Load transformed data into the final table.

INSERT INTO dbo.returns (
    return_id,
    order_id,
    customer_id,
    product_id,
    return_date,
    return_reason,
    refund_amount,
    return_status
)
SELECT
    return_id,
    order_id,
    customer_id,
    product_id,
    TRY_CONVERT(DATE, return_date),
    return_reason,
    TRY_CONVERT(DECIMAL(18,2), refund_amount),
    return_status
FROM dbo.returns_staging;


-- Verify final row count.

SELECT COUNT(*) AS TotalReturns
FROM dbo.returns;


-- ================================================================================================
-- 9. CUSTOMER REVIEWS DATA LOAD
-- Load raw data into staging, validate, and transform.
-- ================================================================================================

CREATE TABLE dbo.customer_reviews_staging (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    product_id VARCHAR(50),
    review_date VARCHAR(50),
    rating VARCHAR(50),
    review_sentiment VARCHAR(50),
    verified_purchase VARCHAR(50)
);


-- Load raw CSV data into staging.

BULK INSERT dbo.customer_reviews_staging
FROM 'C:\archive\customer_reviews.csv'
WITH (
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);


-- Check row count.

SELECT COUNT(*) AS TotalRows
FROM dbo.customer_reviews_staging;


-- Check data type conversions.

SELECT
    COUNT(*) AS TotalRows,
    COUNT(TRY_CONVERT(DATE, review_date)) AS ValidReviewDate,
    COUNT(TRY_CONVERT(INT, rating)) AS ValidRating
FROM dbo.customer_reviews_staging;


-- Load transformed data into the final table.

INSERT INTO dbo.customer_reviews (
    review_id,
    order_id,
    customer_id,
    product_id,
    rating,
    review_date,
    review_sentiment,
    verified_purchase
)
SELECT
    review_id,
    order_id,
    customer_id,
    product_id,
    TRY_CONVERT(INT, rating),
    TRY_CONVERT(DATE, review_date),
    review_sentiment,
    verified_purchase
FROM dbo.customer_reviews_staging;


-- Verify final row count.

SELECT COUNT(*) AS TotalCustomerReviews
FROM dbo.customer_reviews;

