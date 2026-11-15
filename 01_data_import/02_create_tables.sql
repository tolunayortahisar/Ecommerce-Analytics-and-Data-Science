-- ================================================================================================
-- DATABASE TABLES SETUP
-- Create the final tables and define primary and foreign key relationships.
-- ================================================================================================


-- Customers

CREATE TABLE dbo.customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_signup_date DATE,
    gender VARCHAR(20),
    age INT,
    age_group VARCHAR(10),
    state_ VARCHAR(50),
    city VARCHAR(50),
    pincode_prefix INT,
    customer_segment VARCHAR(20),
    preferred_device VARCHAR(30),
    preferred_payment_method VARCHAR(30),
    acquisition_channel VARCHAR(40),
    total_orders INT,
    total_spend DECIMAL(18,2),
    last_order_date DATE,
    average_order_value DECIMAL(18,2),
    customer_status VARCHAR(20),
    loyalty_tier VARCHAR(20)
);


-- Products

CREATE TABLE dbo.products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(150),
    category VARCHAR(50),
    subcategory VARCHAR(100),
    brand VARCHAR(100),
    price DECIMAL(18,2),
    cost_price DECIMAL(18,2),
    discount_range VARCHAR(20),
    rating_average DECIMAL(3,2),
    rating_count INT,
    stock_quantity INT,
    product_launch_date DATE,
    product_type VARCHAR(30),
    return_rate_baseline DECIMAL(5,4)
);


-- Orders

CREATE TABLE dbo.orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    order_date DATE,
    order_time TIME,
    order_status VARCHAR(20),
    shipping_method VARCHAR(30),
    delivery_city VARCHAR(50),
    delivery_state VARCHAR(50),
    coupon_code VARCHAR(30),
    discount_percentage DECIMAL(5,2),
    marketing_channel VARCHAR(50),
    subtotal DECIMAL(18,2),
    shipping_fee DECIMAL(18,2),
    tax_amount DECIMAL(18,2),
    final_amount DECIMAL(18,2),
    campaign_id VARCHAR(20),

    CONSTRAINT FK_orders_customers
        FOREIGN KEY (customer_id)
        REFERENCES dbo.customers(customer_id)
);


-- Order Items

CREATE TABLE dbo.order_items (
    order_item_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    quantity INT,
    unit_price DECIMAL(18,2),
    discount_percentage DECIMAL(5,2),
    item_revenue DECIMAL(18,2),
    item_cost DECIMAL(18,2),
    profit DECIMAL(18,2),

    CONSTRAINT FK_order_items_orders
        FOREIGN KEY (order_id)
        REFERENCES dbo.orders(order_id),

    CONSTRAINT FK_order_items_products
        FOREIGN KEY (product_id)
        REFERENCES dbo.products(product_id)
);


-- Payments

CREATE TABLE dbo.payments (
    payment_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    payment_date DATE,
    payment_method VARCHAR(30),
    payment_status VARCHAR(20),
    amount_paid DECIMAL(18,2),
    transaction_fee DECIMAL(18,2),
    refund_amount DECIMAL(18,2),

    CONSTRAINT FK_payments_orders
        FOREIGN KEY (order_id)
        REFERENCES dbo.orders(order_id)
);


-- Shipments

CREATE TABLE dbo.shipments (
    shipment_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    warehouse_city VARCHAR(50),
    delivery_city VARCHAR(50),
    shipping_method VARCHAR(30),
    dispatch_date DATE,
    expected_delivery_date DATE,
    actual_delivery_date DATE,
    delivery_days INT,
    delivery_status VARCHAR(30),
    delayed_flag BIT,

    CONSTRAINT FK_shipments_orders
        FOREIGN KEY (order_id)
        REFERENCES dbo.orders(order_id)
);


-- Returns

CREATE TABLE dbo.returns (
    return_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    customer_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    return_date DATE,
    return_reason VARCHAR(100),
    refund_amount DECIMAL(18,2),
    return_status VARCHAR(30),

    CONSTRAINT FK_returns_orders
        FOREIGN KEY (order_id)
        REFERENCES dbo.orders(order_id),

    CONSTRAINT FK_returns_customers
        FOREIGN KEY (customer_id)
        REFERENCES dbo.customers(customer_id),

    CONSTRAINT FK_returns_products
        FOREIGN KEY (product_id)
        REFERENCES dbo.products(product_id)
);


-- Customer Reviews

CREATE TABLE dbo.customer_reviews (
    review_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    customer_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    rating INT,
    review_date DATE,
    review_text VARCHAR(1000),

    CONSTRAINT FK_customer_reviews_orders
        FOREIGN KEY (order_id)
        REFERENCES dbo.orders(order_id),

    CONSTRAINT FK_customer_reviews_customers
        FOREIGN KEY (customer_id)
        REFERENCES dbo.customers(customer_id),

    CONSTRAINT FK_customer_reviews_products
        FOREIGN KEY (product_id)
        REFERENCES dbo.products(product_id)
);


-- Marketing Campaigns

CREATE TABLE dbo.marketing_campaigns (
    campaign_id VARCHAR(20) PRIMARY KEY,
    campaign_name VARCHAR(100),
    campaign_type VARCHAR(50),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(18,2),
    target_audience VARCHAR(100),
    channel VARCHAR(50)
);


-- Add campaign relationship to orders.

ALTER TABLE dbo.orders
ADD CONSTRAINT FK_orders_campaigns
    FOREIGN KEY (campaign_id)
    REFERENCES dbo.marketing_campaigns(campaign_id);


-- Verify the tables in the database.

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
