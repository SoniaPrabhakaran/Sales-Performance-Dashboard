# Superstore-Sales-Performance-Dashboard

This project integrates **SQL**, **Python ETL**, **PostgreSQL**, and **Power BI** to deliver a comprehensive **Sales Performance Dashboard**. 
It demonstrates an end-to-end workflow: from raw data cleaning and loading, to analytics views, and finally interactive visualizations.

## Business Problem
Analyze 4 years of retail sales data (Superstore dataset) to identify growth opportunities, underperforming 
segments, and customer behavior patterns.


## Features 
Automated **data cleaning and loading** with Python - **SQL schema** and reusable analytics views - Interactive **Power BI dashboard** with premium visuals - Business insights on **regional, product, customer, and technology performance**

## Dataset

- Source: *Superstore Sales* (Kaggle, Laiba Anwer). 
- Records: 9,994 sales transactions (2014–2017).
- Attributes: Orders, Customers, Products, Regions, Markets, Shipping, Profitability.


## Key Insights

- **Seasonality Matters** → Q4 consistently drives peak sales, suggesting promotional campaigns should be concentrated here.
- **Profit vs Sales Gap** → Growth in revenue does not always translate to profit — Furniture needs margin optimization.
- **Segment Value** → Corporate customers deliver higher profitability per order, while Consumers drive volume; strategies should balance loyalty vs acquisition.
- **Technology Dominance** → Phones and Copiers are the backbone of Technology growth, making them priority products for investment.
- **Balanced Strategy Needed** → Growth is uneven across categories and segments, so resource allocation should be tailored to maximize both revenue and profitability.

- ## Business Impact

- **Revenue Growth Analysis** → Identified consistent Q4 spikes in sales, highlighting seasonal demand opportunities.
- **Profitability Insights** → Showed that while sales grew steadily, profit growth lagged in categories like Furniture, signaling margin pressure.
- **Customer Segmentation** → Revealed that Corporate customers spend more per order but order less frequently, while Consumers drive volume. This informs targeted marketing strategies.
- **Technology Category Focus** → Demonstrated that Technology is the fastest‑growing and most profitable category, with Phones and Copiers leading sub‑category performance.
- **Regional Contribution** → Highlighted untapped opportunities in certain markets (e.g., APAC and EU) where sales growth is strong but profit margins vary.
- 

- ## Dataset

- Source: *Superstore Sales* (Kaggle, Laiba Anwer).
- Records: 9,994 sales transactions (2014–2017).
- Attributes: Orders, Customers, Products, Regions, Markets, Shipping, Profitability.

- 
- ## Tools Used

- **Excel** → Data cleaning.
- **Python (pandas, SQLAlchemy, psycopg2)** → ETL loader.
- **PostgreSQL** → Data modeling, SQL analytics views.
- **Power BI** → Interactive dashboard, DAX measures.

## Data Loading (Python ETL)

**File**: `python/staging.py`

**Purpose**: Automates loading of the Superstore dataset into PostgreSQL staging tables.

### Steps:

1. Load Excel file using `pandas`.
2. Clean column names and strip spaces.
3. Convert numeric fields (`sales`, `profit`, `discount`, `quantity`) to proper types.
4. Parse dates (`order_date`, `ship_date`).
5. Align columns with staging table schema (`stg_orders`).
6. Connect to PostgreSQL via SQLAlchemy.
7. Bulk insert cleaned data into staging table.

Run Command:
python python/staging.py

### Dependencies:

- `pandas`
- `sqlalchemy`
- `psycopg2`
- `openpyxl`

## SQL Schema & Views

- **Fact Table**: `fact_sales`
- **Dimensions**: `dim_date`, `dim_customer`, `dim_product`, `dim_region`

### Key Views and KPIs 

- `v_quarterly_performance` → Quarterly sales, profit, orders
- `v_customer_segmentation` → Segment‑wise spend & profitability
- `v_yoy_growth_category` → YoY growth by product category
- `v_market_analysis` → Market‑wise performance
- `v_growth_opportunities` → Regions with high sales but low margins
- `v_regional_yoy` → Regional YoY revenue growth
- `v_technology_yoy` → Technology category YoY growth
- `v_top_products_profit` → Top 15 products by profit
- `v_segment_spend_frequency` → Customer spend vs frequency
- `superstore_kpi_region_market`→ Sales, Profit, Margin by market

## Power BI Dashboard Pages

1. **Overview** → KPIs, Quarterly Trend, YoY Growth by Category
2. **Regional & Market Analysis** → Regional Sales and margin overview, Growth Opportunities
3. **Product Performance** → profit contribution by category, seasonal trends, Top products by profit 
4. **Customer Segmentation** → Spend vs Frequency, Annual revenue and growth trends
5. **Technology Focus** → KPIs, Technology trends by year, Top performing subcategories

📐 Core DAX Measures

Total Revenue = SUM ( 'fact_sales'[sales] )
Total Profit = SUM ( 'fact_sales'[profit] )
Total Orders = DISTINCTCOUNT ( 'fact_sales'[order_id] )
Profit Margin % = DIVIDE ( [Total Profit], [Total Revenue], 0 )

*See* `/docs/DAX.md` *for full list of measures.)*

## 📸 Dashboard Screenshots

- [Screenshot 1: Overview Page]
- [Screenshot 2: Regional and Market Analysis]
- [Screenshot 3: Product Performance]
- [Screenshot 4: Customer Segmentation]
- [Screenshot 5: Technology Focus]

## 📂 Deliverables

- Power BI file (`pbix/SalesDashboard.pbix`)
- SQL scripts (`sql/`)
- Python loader (`python/staging.py`)
- Screenshots (`/screenshots`)
- README.md (this file)
  
