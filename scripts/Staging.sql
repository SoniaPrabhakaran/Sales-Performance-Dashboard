----------------------------------------------------------
-- Populate dimension tables BEFORE fact table
----------------------------------------------------------

-- 1) dim_date
INSERT INTO superstore.dim_date (date_id, year, quarter, month, month_name, year_month)
SELECT DISTINCT
  order_date,
  EXTRACT(YEAR FROM order_date)::int,
  EXTRACT(QUARTER FROM order_date)::int,
  EXTRACT(MONTH FROM order_date)::int,
  TO_CHAR(order_date, 'Mon'),
  TO_CHAR(order_date, 'YYYY-MM')
FROM superstore.stg_orders
WHERE order_date IS NOT NULL
ON CONFLICT (date_id) DO NOTHING;

-- 2) dim_customer
INSERT INTO superstore.dim_customer (customer_name, segment)
SELECT DISTINCT customer_name, segment
FROM superstore.stg_orders
WHERE customer_name IS NOT NULL
ON CONFLICT (customer_name, segment) DO NOTHING;

-- 3) dim_product
INSERT INTO superstore.dim_product (product_id, product_name, category, sub_category)
SELECT DISTINCT ON (product_id)
  product_id, product_name, category, sub_category
FROM superstore.stg_orders
WHERE product_id IS NOT NULL
ORDER BY product_id, product_name  -- choose which row wins
ON CONFLICT (product_id) DO UPDATE
SET product_name = EXCLUDED.product_name,
    category = EXCLUDED.category,
    sub_category = EXCLUDED.sub_category;


-- 4) dim_region
INSERT INTO superstore.dim_region (country, state, region, market)
SELECT DISTINCT country, state, region, market
FROM superstore.stg_orders
WHERE country IS NOT NULL
ON CONFLICT (country, state, region, market) DO NOTHING;



----------------------------------------------------------
-- 5) fact_sales (safe insert with guaranteed dimension keys)
----------------------------------------------------------

INSERT INTO superstore.fact_sales (
  order_id, date_id, customer_key, product_id, region_id,
  ship_mode, order_priority, market, sales, profit, quantity, discount
)
SELECT
  s.order_id,
  s.order_date,
  c.customer_key,
  s.product_id,
  r.region_id,
  s.ship_mode,
  s.order_priority,
  s.market,
  CAST(s.sales AS NUMERIC(12,2)),
  CAST(s.profit AS NUMERIC(12,2)),
  CAST(s.quantity AS INTEGER),
  COALESCE(CAST(s.discount AS NUMERIC(6,4)), 0)
FROM superstore.stg_orders s
JOIN superstore.dim_customer c 
  ON c.customer_name = s.customer_name AND c.segment = s.segment
JOIN superstore.dim_product p
  ON p.product_id = s.product_id
JOIN superstore.dim_region r
  ON r.country = s.country
 AND r.state IS NOT DISTINCT FROM s.state
 AND r.region = s.region
 AND r.market = s.market;

