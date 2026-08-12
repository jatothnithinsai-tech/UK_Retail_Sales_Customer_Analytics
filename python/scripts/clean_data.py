"""Clean a raw Online Retail CSV or Excel workbook."""

from __future__ import annotations

import os
from pathlib import Path

import pandas as pd
from dotenv import load_dotenv

ROOT = Path(__file__).resolve().parents[2]


def clean_sales(frame: pd.DataFrame) -> pd.DataFrame:
    """Normalize columns, types, flags, and derived revenue."""
    rename_map = {
        "InvoiceNo": "invoice_no",
        "Invoice": "invoice_no",
        "StockCode": "stock_code",
        "Description": "description",
        "Quantity": "quantity",
        "InvoiceDate": "invoice_date",
        "UnitPrice": "unit_price",
        "Price": "unit_price",
        "CustomerID": "customer_id",
        "Customer ID": "customer_id",
        "Country": "country",
    }
    cleaned = frame.rename(columns=rename_map).copy()
    required = {"invoice_no", "stock_code", "quantity", "invoice_date", "unit_price"}
    missing = required.difference(cleaned.columns)
    if missing:
        raise ValueError(f"Missing required columns: {sorted(missing)}")

    for column in ("invoice_no", "stock_code", "description", "customer_id", "country"):
        if column not in cleaned:
            cleaned[column] = pd.NA
        cleaned[column] = cleaned[column].astype("string").str.strip()

    cleaned["invoice_date"] = pd.to_datetime(cleaned["invoice_date"], errors="coerce")
    cleaned["quantity"] = pd.to_numeric(cleaned["quantity"], errors="coerce").astype("Int64")
    cleaned["unit_price"] = pd.to_numeric(cleaned["unit_price"], errors="coerce")
    cleaned = cleaned.dropna(subset=["invoice_no", "stock_code", "invoice_date", "quantity", "unit_price"])
    cleaned["country"] = cleaned["country"].fillna("Unknown")
    cleaned["is_cancellation"] = cleaned["invoice_no"].str.upper().str.startswith("C")
    cleaned["revenue"] = (cleaned["quantity"] * cleaned["unit_price"]).round(2)
    return cleaned.drop_duplicates().reset_index(drop=True)


def read_sales(source: Path) -> pd.DataFrame:
    """Read a supported source file, combining every Excel worksheet."""
    if not source.exists():
        raise FileNotFoundError(
            f"Raw sales file not found: {source}. Set RAW_DATA_PATH in .env "
            "or place the source file in data/raw/."
        )
    if source.suffix.lower() == ".csv":
        return pd.read_csv(source, encoding="ISO-8859-1")
    if source.suffix.lower() in {".xlsx", ".xls"}:
        sheets = pd.read_excel(source, sheet_name=None)
        if not sheets:
            raise ValueError(f"Excel workbook has no worksheets: {source}")
        return pd.concat(sheets.values(), ignore_index=True)
    raise ValueError(f"Unsupported raw data format: {source.suffix or '(none)'}")


def main() -> None:
    load_dotenv(ROOT / ".env")
    source = ROOT / os.getenv("RAW_DATA_PATH", os.getenv("RAW_CSV_PATH", "data/raw/online_retail_II.xlsx"))
    target = ROOT / os.getenv("PROCESSED_CSV_PATH", "data/processed/retail_sales_clean.csv")
    target.parent.mkdir(parents=True, exist_ok=True)
    cleaned = clean_sales(read_sales(source))
    cleaned.to_csv(target, index=False)
    print(f"Wrote {len(cleaned):,} cleaned rows to {target}")


if __name__ == "__main__":
    main()
