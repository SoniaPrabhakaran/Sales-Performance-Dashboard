--SQL Analytics and Query views 

--KPI Views for PowerBI

-- Total Revenue, Profit, Orders 
CREATE OR REPLACE VIEW superstore.kpi_overview AS 
SELECT 
  SUM(sales) AS total_revenue, 
  SUM(profit) AS total_profit, 
  COUNT(DISTINCT order_id) AS total_orders
FROM superstore.fact_sales;

-- Monthly Sales Trend 
CREATE OR REPLACE VIEW superstore.kpi_monthly_sales AS 
SELECT 
  d.year, 
  d.month, 
  d.month_name, 
  SUM(f.sales) AS monthly_sales, 
  SUM(f.profit) AS monthly_profit 
FROM superstore.fact_sales f 
JOIN superstore.dim_date d ON f.date_id = d.date_id 
GROUP BY d.year, d.month, d.month_name 
ORDER BY d.year, d.month;


--Growth Opportunities – High Sales, Low Margin
CREATE OR REPLACE VIEW superstore.v_growth_opportunities AS
SELECT 
    r.region,
    r.market,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit,
    ROUND(SUM(f.profit) / NULLIF(SUM(f.sales),0) * 100,2) AS profit_margin_pct
FROM superstore.fact_sales f
JOIN superstore.dim_region r ON f.region_id = r.region_id
GROUP BY r.region, r.market
HAVING SUM(f.sales) > 100000
   AND ROUND(SUM(f.profit) / NULLIF(SUM(f.sales),0) * 100,2) < 10
ORDER BY total_sales DESC;

-- Regional + Market Analysis 
CREATE OR REPLACE VIEW superstore.kpi_region_market AS 
SELECT 
  r.region, 
  r.market, 
  SUM(f.sales) AS sales, 
  SUM(f.profit) AS profit 
FROM superstore.fact_sales f 
JOIN superstore.dim_region r ON f.region_id = r.region_id 
GROUP BY r.region, r.market 
ORDER BY sales DESC;


--Market Analysis View
CREATE OR REPLACE VIEW superstore.v_market_analysis AS
SELECT 
    r.market,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit,
    COUNT(DISTINCT f.order_id) AS total_orders,
    ROUND(SUM(f.profit) / NULLIF(SUM(f.sales),0) * 100,2) AS profit_margin_pct
FROM superstore.fact_sales f
JOIN superstore.dim_region r ON f.region_id = r.region_id
GROUP BY r.market
ORDER BY total_sales DESC;


--Regional revenue opportunity y-o-y view
CREATE OR REPLACE VIEW superstore.v_regional_yoy AS
SELECT 
    d.year,
    r.region,
    SUM(f.sales) AS total_sales,
    LAG(SUM(f.sales)) OVER (PARTITION BY r.region ORDER BY d.year) AS prev_year_sales,
    ROUND(
        (SUM(f.sales) - LAG(SUM(f.sales)) OVER (PARTITION BY r.region ORDER BY d.year))
        / NULLIF(LAG(SUM(f.sales)) OVER (PARTITION BY r.region ORDER BY d.year),0) * 100,2
    ) AS yoy_sales_growth_pct
FROM superstore.fact_sales f
JOIN superstore.dim_date d ON f.date_id = d.date_id
JOIN superstore.dim_region r ON f.region_id = r.region_id
GROUP BY d.year, r.region
ORDER BY r.region, d.year;




--Quarterly performance view 

CREATE OR REPLACE VIEW superstore.kpi_quarterly_performance AS
SELECT 
    d.year,
    d.quarter,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit,
    COUNT(DISTINCT f.order_id) AS total_orders
FROM superstore.fact_sales f
JOIN superstore.dim_date d ON f.date_id = d.date_id
GROUP BY d.year, d.quarter
ORDER BY d.year, d.quarter;

--Use this in Power BI for line charts or clustered bar charts
-- showing quarterly revenue, profit, and orders.


-- Customer Segmentation Analysis
CREATE OR REPLACE VIEW superstore.kpi_customer_segmentation AS
SELECT 
    c.segment,
    COUNT(DISTINCT c.customer_name) AS total_customers,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit,
    AVG(f.sales) AS avg_sales_per_order,
    AVG(f.profit) AS avg_profit_per_order
FROM superstore.fact_sales f
JOIN superstore.dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.segment
ORDER BY total_sales DESC;

--Use this for pie charts (sales share by segment) and 
--scatter plots (avg sales vs avg profit per segment).


--yoy growth by category view

CREATE OR REPLACE VIEW superstore.v_yoy_growth_category AS
SELECT 
    d.year,
    p.category,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit,
    LAG(SUM(f.sales)) OVER (PARTITION BY p.category ORDER BY d.year) AS prev_year_sales,
    ROUND(
        (SUM(f.sales) - LAG(SUM(f.sales)) OVER (PARTITION BY p.category ORDER BY d.year))
        / NULLIF(LAG(SUM(f.sales)) OVER (PARTITION BY p.category ORDER BY d.year),0) * 100,2
    ) AS yoy_sales_growth_pct,
    LAG(SUM(f.profit)) OVER (PARTITION BY p.category ORDER BY d.year) AS prev_year_profit,
    ROUND(
        (SUM(f.profit) - LAG(SUM(f.profit)) OVER (PARTITION BY p.category ORDER BY d.year))
        / NULLIF(LAG(SUM(f.profit)) OVER (PARTITION BY p.category ORDER BY d.year),0) * 100,2
    ) AS yoy_profit_growth_pct
FROM superstore.fact_sales f
JOIN superstore.dim_date d ON f.date_id = d.date_id
JOIN superstore.dim_product p ON f.product_id = p.product_id
GROUP BY d.year, p.category
ORDER BY p.category, d.year;

--Use this for line charts or clustered bars showing
-- YoY growth by product category.

--Market Analysis View

CREATE OR REPLACE VIEW superstore.v_market_analysis AS
SELECT 
    r.market,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit,
    COUNT(DISTINCT f.order_id) AS total_orders,
    ROUND(SUM(f.profit) / NULLIF(SUM(f.sales),0) * 100,2) AS profit_margin_pct
FROM superstore.fact_sales f
JOIN superstore.dim_region r ON f.region_id = r.region_id
GROUP BY r.market
ORDER BY total_sales DESC;


--Growth Opportunities – High Sales, Low Margin
CREATE OR REPLACE VIEW superstore.v_growth_opportunities AS
SELECT 
    r.region,
    r.market,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit,
    ROUND(SUM(f.profit) / NULLIF(SUM(f.sales),0) * 100,2) AS profit_margin_pct
FROM superstore.fact_sales f
JOIN superstore.dim_region r ON f.region_id = r.region_id
GROUP BY r.region, r.market
HAVING SUM(f.sales) > 100000
   AND ROUND(SUM(f.profit) / NULLIF(SUM(f.sales),0) * 100,2) < 10
ORDER BY total_sales DESC;

--Regional revenue opportunity y-o-y view
CREATE OR REPLACE VIEW superstore.v_regional_yoy AS
SELECT 
    d.year,
    r.region,
    SUM(f.sales) AS total_sales,
    LAG(SUM(f.sales)) OVER (PARTITION BY r.region ORDER BY d.year) AS prev_year_sales,
    ROUND(
        (SUM(f.sales) - LAG(SUM(f.sales)) OVER (PARTITION BY r.region ORDER BY d.year))
        / NULLIF(LAG(SUM(f.sales)) OVER (PARTITION BY r.region ORDER BY d.year),0) * 100,2
    ) AS yoy_sales_growth_pct
FROM superstore.fact_sales f
JOIN superstore.dim_date d ON f.date_id = d.date_id
JOIN superstore.dim_region r ON f.region_id = r.region_id
GROUP BY d.year, r.region
ORDER BY r.region, d.year;

--Technology category y-o-y growth view
CREATE OR REPLACE VIEW superstore.v_technology_yoy AS
SELECT 
    d.year,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit,
    LAG(SUM(f.sales)) OVER (ORDER BY d.year) AS prev_year_sales,
    ROUND(
        (SUM(f.sales) - LAG(SUM(f.sales)) OVER (ORDER BY d.year))
        / NULLIF(LAG(SUM(f.sales)) OVER (ORDER BY d.year),0) * 100,2
    ) AS yoy_sales_growth_pct
FROM superstore.fact_sales f
JOIN superstore.dim_date d ON f.date_id = d.date_id
JOIN superstore.dim_product p ON f.product_id = p.product_id
WHERE p.category = 'Technology'
GROUP BY d.year
ORDER BY d.year;

--Top products by profit view
CREATE OR REPLACE VIEW superstore.v_top_products_profit AS
SELECT 
    p.product_name,
    p.category,
    p.sub_category,
    SUM(f.profit) AS total_profit,
    SUM(f.sales) AS total_sales,
    SUM(f.quantity) AS total_quantity
FROM superstore.fact_sales f
JOIN superstore.dim_product p ON f.product_id = p.product_id
GROUP BY p.product_name, p.category, p.sub_category
ORDER BY total_profit DESC
LIMIT 15;


--customer segement - Purchasing behaviour analysis view
CREATE OR REPLACE VIEW superstore.v_segment_spend_frequency AS
SELECT 
    c.segment,
    COUNT(DISTINCT f.order_id) AS order_frequency,
    SUM(f.sales) AS total_spend,
    ROUND(SUM(f.sales) / NULLIF(COUNT(DISTINCT f.order_id),0),2) AS avg_spend_per_order
FROM superstore.fact_sales f
JOIN superstore.dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.segment
ORDER BY total_spend DESC;







--##Adhoc queries

-- Top 10 Products by Profit

SELECT product_name, SUM(profit) AS total_profit
FROM superstore.fact_sales f
JOIN superstore.dim_product p ON f.product_id = p.product_id
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;


-- Top 5 Customers by Sales
SELECT c.customer_name, SUM(f.sales) AS total_sales
FROM superstore.fact_sales f
JOIN superstore.dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.customer_name
ORDER BY total_sales DESC
LIMIT 5;

-- Sales by Region and Market
SELECT r.region, r.market, SUM(f.sales) AS total_sales
FROM superstore.fact_sales f
JOIN superstore.dim_region r ON f.region_id = r.region_id
GROUP BY r.region, r.market
ORDER BY total_sales DESC;


-- Quarterly Sales and Profit by Product Category
SELECT d.year, d.quarter, p.category,
       SUM(f.sales) AS sales, SUM(f.profit) AS profit
FROM superstore.fact_sales f
JOIN superstore.dim_date d ON f.date_id = d.date_id
JOIN superstore.dim_product p ON f.product_id = p.product_id
GROUP BY d.year, d.quarter, p.category
ORDER BY d.year, d.quarter;


--customer segmentation 

SELECT c.segment,
       SUM(f.sales) AS sales,
       SUM(f.profit) AS profit,
       COUNT(DISTINCT c.customer_name) AS customers
FROM superstore.fact_sales f
JOIN superstore.dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.segment;


--Market Analysis – Compare Performance Across Markets
SELECT 
    r.market,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit,
    COUNT(DISTINCT f.order_id) AS total_orders,
    ROUND(SUM(f.profit) / NULLIF(SUM(f.sales),0) * 100,2) AS profit_margin_pct
FROM superstore.fact_sales f
JOIN superstore.dim_region r ON f.region_id = r.region_id
GROUP BY r.market
ORDER BY total_sales DESC;

--Compare APAC, EMEA, US, LATAM markets by 
--sales, profit, and margin.


--Identify Growth Opportunities – Regions with High Sales but Low Profit Margin
SELECT 
    r.region,
    r.market,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit,
    ROUND(SUM(f.profit) / NULLIF(SUM(f.sales),0) * 100,2) AS profit_margin_pct
FROM superstore.fact_sales f
JOIN superstore.dim_region r ON f.region_id = r.region_id
GROUP BY r.region, r.market
HAVING SUM(f.sales) > 100000  -- threshold for "high sales"
   AND ROUND(SUM(f.profit) / NULLIF(SUM(f.sales),0) * 100,2) < 10  -- low margin
ORDER BY total_sales DESC;

--Flags regions with strong revenue but weak profitability.


--Regional Revenue Opportunity – YoY Comparison
SELECT 
    d.year,
    r.region,
    SUM(f.sales) AS total_sales,
    LAG(SUM(f.sales)) OVER (PARTITION BY r.region ORDER BY d.year) AS prev_year_sales,
    ROUND(
        (SUM(f.sales) - LAG(SUM(f.sales)) OVER (PARTITION BY r.region ORDER BY d.year))
        / NULLIF(LAG(SUM(f.sales)) OVER (PARTITION BY r.region ORDER BY d.year),0) * 100,2
    ) AS yoy_sales_growth_pct
FROM superstore.fact_sales f
JOIN superstore.dim_date d ON f.date_id = d.date_id
JOIN superstore.dim_region r ON f.region_id = r.region_id
GROUP BY d.year, r.region
ORDER BY r.region, d.year;

-- Shows YoY growth by region to identify where revenue is accelerating.


--Technology category y-o-y growth
SELECT 
    d.year,
    SUM(f.sales) AS total_sales,
    SUM(f.profit) AS total_profit,
    LAG(SUM(f.sales)) OVER (ORDER BY d.year) AS prev_year_sales,
    ROUND(
        (SUM(f.sales) - LAG(SUM(f.sales)) OVER (ORDER BY d.year))
        / NULLIF(LAG(SUM(f.sales)) OVER (ORDER BY d.year),0) * 100,2
    ) AS yoy_sales_growth_pct
FROM superstore.fact_sales f
JOIN superstore.dim_date d ON f.date_id = d.date_id
JOIN superstore.dim_product p ON f.product_id = p.product_id
WHERE p.category = 'Technology'
GROUP BY d.year
ORDER BY d.year;

-- Focused view of Technology category growth trends.

--Top 15 products by profit (Inventory priority)
SELECT 
    p.product_name,
    p.category,
    p.sub_category,
    SUM(f.profit) AS total_profit,
    SUM(f.sales) AS total_sales,
    SUM(f.quantity) AS total_quantity
FROM superstore.fact_sales f
JOIN superstore.dim_product p ON f.product_id = p.product_id
GROUP BY p.product_name, p.category, p.sub_category
ORDER BY total_profit DESC
LIMIT 15;
-- Helps prioritize inventory for high-profit products.

--customer segement - Purchasing behaviour analysis 
SELECT 
    c.segment,
    COUNT(DISTINCT f.order_id) AS order_frequency,
    SUM(f.sales) AS total_spend,
    ROUND(SUM(f.sales) / NULLIF(COUNT(DISTINCT f.order_id),0),2) AS avg_spend_per_order
FROM superstore.fact_sales f
JOIN superstore.dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.segment
ORDER BY total_spend DESC;
-- Understand purchasing behavior by customer segment.
-- i.e., which segments order more frequently and spend more per order.










