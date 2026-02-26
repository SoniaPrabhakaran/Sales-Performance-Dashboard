-- 1) Create schema 
CREATE SCHEMA IF NOT EXISTS superstore;

-- 2) Staging tableINSERT INTO fact_sales 
(
    fact_id,
    order_id,
    date_id,
    customer_key,
    product_id,
    region_id,
    ship_mode,
    order_priority,
    market,
    sales,
    profit,
    quantity,
    discount
  )
VALUES (
    fact_id:integer,
    'order_id:text',
    'date_id:date',
    customer_key:integer,
    'product_id:text',
    region_id:integer,
    'ship_mode:text',
    'order_priority:text',
    'market:text',
    sales:numeric,
    profit:numeric,
    quantity:integer,
    discount:numeric
  );
DROP TABLE IF EXISTS superstore.stg_orders;
CREATE TABLE superstore.stg_orders (
  row_id SERIAL PRIMARY KEY,
  order_id TEXT NOT NULL,
  order_date DATE NOT NULL,
  ship_date DATE,
  ship_mode TEXT,
  order_priority TEXT,
  customer_name TEXT NOT NULL,
  segment TEXT NOT NULL,
  country TEXT NOT NULL,
  state TEXT,
  region TEXT NOT NULL,
  product_id TEXT NOT NULL,
  category TEXT NOT NULL,
  sub_category TEXT NOT NULL,
  product_name TEXT NOT NULL,
  sales NUMERIC(12,2) NOT NULL,
  quantity INTEGER NOT NULL,
  discount NUMERIC(6,4) DEFAULT 0,
  profit NUMERIC(12,2) NOT NULL,
  market TEXT
);

-- 3) Dimension tables
DROP TABLE IF EXISTS superstore.dim_date;
CREATE TABLE superstore.dim_date (
  date_id DATE PRIMARY KEY,
  year INTEGER NOT NULL,
  quarter INTEGER NOT NULL,
  month INTEGER NOT NULL,
  month_name TEXT NOT NULL,
  year_month TEXT NOT NULL
);

DROP TABLE IF EXISTS superstore.dim_customer;
CREATE TABLE superstore.dim_customer (
  customer_key SERIAL PRIMARY KEY,
  customer_name TEXT NOT NULL,
  segment TEXT NOT NULL,
  UNIQUE(customer_name, segment)   -- ensures no duplicates
);

DROP TABLE IF EXISTS superstore.dim_product;
CREATE TABLE superstore.dim_product (
  product_id TEXT PRIMARY KEY,
  product_name TEXT NOT NULL,
  category TEXT NOT NULL,
  sub_category TEXT NOT NULL
);

DROP TABLE IF EXISTS superstore.dim_region;
CREATE TABLE superstore.dim_region (
  region_id SERIAL PRIMARY KEY,
  country TEXT NOT NULL,
  state TEXT,
  region TEXT NOT NULL,
  market TEXT NOT NULL,
  UNIQUE (country, state, region, market)
);

-- 4) Fact table
DROP TABLE IF EXISTS superstore.fact_sales;
CREATE TABLE superstore.fact_sales (
  fact_id SERIAL PRIMARY KEY,
  order_id TEXT NOT NULL,
  date_id DATE NOT NULL REFERENCES superstore.dim_date(date_id),
  customer_key INTEGER NOT NULL REFERENCES superstore.dim_customer(customer_key),
  product_id TEXT NOT NULL REFERENCES superstore.dim_product(product_id),
  region_id INTEGER NOT NULL REFERENCES superstore.dim_region(region_id),
  ship_mode TEXT,
  order_priority TEXT,
  market TEXT,
  sales NUMERIC(12,2) NOT NULL,
  profit NUMERIC(12,2) NOT NULL,
  quantity INTEGER NOT NULL,
  discount NUMERIC(6,4) NOT NULL
);

-- Helpful indexes
CREATE INDEX ON superstore.stg_orders(order_date);
CREATE INDEX ON superstore.fact_sales(date_id);
CREATE INDEX ON superstore.fact_sales(customer_key);
CREATE INDEX ON superstore.fact_sales(product_id);
CREATE INDEX ON superstore.fact_sales(region_id);


SELECT COUNT(*) FROM superstore.stg_orders;
SELECT COUNT(*) FROM superstore.dim_customer;
SELECT COUNT(*) FROM superstore.dim_product;
SELECT COUNT(*) FROM superstore.dim_region;
SELECT COUNT(*) FROM superstore.dim_date;


