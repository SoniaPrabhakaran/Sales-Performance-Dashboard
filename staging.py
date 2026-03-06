import os
import pandas as pd
from sqlalchemy import create_engine, Numeric, Integer, String, Date

# 1. Load Excel file
df = pd.read_excel("data/superstore_orders.xlsx")

# 2. Strip spaces from column names
df.columns = df.columns.str.strip()

# 3. Force numeric conversion for measures
numeric_cols = ["sales", "profit", "discount", "quantity"]
for col in numeric_cols:
    df[col] = pd.to_numeric(df[col], errors="coerce")

# 4. Drop rows with missing critical values (optional safeguard)
df = df.dropna(subset=["sales", "profit", "quantity"])

# 5. Parse dates properly
df["order_date"] = pd.to_datetime(df["order_date"], errors="coerce")
df["ship_date"] = pd.to_datetime(df["ship_date"], errors="coerce")

# 6. Keep only the columns that match the staging table schema
valid_cols = [
    "order_id", "order_date", "ship_date", "ship_mode", "order_priority",
    "customer_name", "segment", "state", "country", "market", "region",
    "product_id", "category", "sub_category", "product_name",
    "sales", "profit", "discount", "quantity"
]
df = df[valid_cols]

# 7. Explicitly cast numeric columns to float/int for Postgres
df["sales"] = df["sales"].astype(float)
df["profit"] = df["profit"].astype(float)
df["discount"] = df["discount"].astype(float)
df["quantity"] = df["quantity"].astype(int)

print(df['sales'].head()) # Check values
print(df['sales'].apply(type).head())  # Check types
print(df.dtypes['sales']) # Confirm dtype



# 8. Connect to Postgres (replace placeholders with your actual credentials)
engine = create_engine(
    "postgresql+psycopg2://postgres:postgres@localhost:5432/Superstore"
)

# 9. Load into staging table with explicit dtype mapping
df.to_sql(
    "stg_orders",
    engine,
    schema="superstore",
    if_exists="append",
    index=False,
    dtype={
        "order_id": String(),
        "order_date": Date(),
        "ship_date": Date(),
        "ship_mode": String(),
        "order_priority": String(),
        "customer_name": String(),
        "segment": String(),
        "state": String(),
        "country": String(),
        "market": String(),
        "region": String(),
        "product_id": String(),
        "category": String(),
        "sub_category": String(),
        "product_name": String(),
        "sales": Numeric(12, 2),
        "profit": Numeric(12, 2),
        "discount": Numeric(6, 4),
        "quantity": Integer(),
    },
    method="multi"   # ensures psycopg2 binds values correctly
)
print("Data loaded into staging table successfully.")


