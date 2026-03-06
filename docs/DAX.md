Full list of DAX measures

- Product Quantity = SUM('superstore fact_sales'[quantity])

- Profit Contribution % = 
DIVIDE(
    SUM('superstore fact_sales'[profit]),
    CALCULATE(SUM('superstore fact_sales'[profit]), ALL('superstore dim_product')),
    0
)

- Top Product by Profit = 
CALCULATE (
    MAX ( 'superstore dim_product'[product_name]),
    TOPN (
        1,
        SUMMARIZE (
            'superstore dim_product',
            'superstore dim_product'[product_name],
            "Profit", SUM ( 'superstore fact_sales'[profit])
        ),
        [Profit],
        DESC
    )
)

- Avg pofit per product = 
DIVIDE(
    SUM('superstore fact_sales'[profit]),
    DISTINCTCOUNT('superstore dim_product'[product_id])
    )

- Sales per segment = SUM('superstore fact_sales'[sales])

- Profit per segment = SUM('superstore fact_sales'[profit])

- Sale YoY Growth % = 
VAR CurrentYearSales =
    SUM ('superstore fact_sales'[sales])
VAR PrevYearSales =
    CALCULATE (
        SUM ( 'superstore fact_sales'[sales] ),
        DATEADD ( 'superstore dim_date'[date_id], -1, YEAR )
    )
RETURN
    DIVIDE ( CurrentYearSales - PrevYearSales, PrevYearSales, 0 )

-Profit YoY Growth % = 
VAR CurrentYearProfit =
    SUM ( 'superstore fact_sales'[profit])
VAR PrevYearProfit =
    CALCULATE (
        SUM ( 'superstore fact_sales'[profit]),
        DATEADD ( 'superstore dim_date'[date_id], -1, YEAR )
    )
RETURN
    DIVIDE ( CurrentYearProfit - PrevYearProfit, PrevYearProfit, 0 )

- Technology sales = CALCULATE ( SUM ( 'superstore fact_sales'[sales]), 'superstore dim_product'[category] = "Technology" )

- Technology Profit = CALCULATE ( SUM ( 'superstore fact_sales'[profit] ), 'superstore dim_product'[category] = "Technology" )

-Technology Profit Margin % = DIVIDE ( [Technology Profit], [Technology sales], 0 )

- Technology Profit YoY Growth % = 
VAR CurrentYearProfit =
    CALCULATE ( SUM ( 'superstore fact_sales'[profit] ), 'superstore dim_product'[category] = "Technology" )
VAR PrevYearProfit =
    CALCULATE (
        SUM ( 'superstore fact_sales'[profit] ),
        DATEADD ( 'superstore dim_date'[date_id], -1, YEAR ),
        'superstore dim_product'[category]= "Technology"
    )
RETURN DIVIDE ( CurrentYearProfit - PrevYearProfit, PrevYearProfit, 0 )

- Technology YoY Growth % = 
VAR CurrentYearSales =
    CALCULATE ( SUM ( 'superstore fact_sales'[sales]), 'superstore dim_product'[category] = "Technology" )
VAR PrevYearSales =
    CALCULATE (
        SUM ( 'superstore fact_sales'[sales] ),
        DATEADD ( 'superstore dim_date'[date_id], -1, YEAR ),
        'superstore dim_product'[category] = "Technology"
    )
RETURN DIVIDE ( CurrentYearSales - PrevYearSales, PrevYearSales, 0 )



    
