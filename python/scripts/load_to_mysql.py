"""Load the MySQL-ready cleaned retail CSV into MySQL."""

from __future__ import annotations

import os
from pathlib import Path

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine

ROOT = Path(__file__).resolve().parents[2]
CSV_COLUMNS = {
    "Invoice": "invoice_no",
    "StockCode": "stock_code",
    "Description": "description",
    "Quantity": "quantity",
    "InvoiceDate": "invoice_date",
    "Price": "unit_price",
    "Customer ID": "customer_id",
    "Country": "country",
    "IsCancelled": "is_cancelled",
    "Revenue": "revenue",
}


def main() -> None:
    load_dotenv(ROOT / ".env")
    database_url = os.environ["DATABASE_URL"]
    source = ROOT / os.getenv(
        "PROCESSED_CSV_PATH", "data/processed/cleaned_sales_mysql.csv"
    )
    engine = create_engine(database_url)
    loaded_rows = 0

    for chunk in pd.read_csv(source, chunksize=25_000, parse_dates=["InvoiceDate"]):
        chunk = chunk[list(CSV_COLUMNS)].rename(columns=CSV_COLUMNS)
        with engine.begin() as connection:
            chunk.to_sql(
                "sales_clean",
                connection,
                if_exists="append",
                index=False,
                method="multi",
                chunksize=2_000,
            )
        loaded_rows += len(chunk)
        print(f"Loaded {loaded_rows:,} rows")

    print(f"Finished loading {loaded_rows:,} rows into sales_clean")


if __name__ == "__main__":
    main()
