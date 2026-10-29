"""Rebuild the Tableau sales source from the original Online Retail II workbook.

Run from the repository root: python python/scripts/rebuild_tableau_extract.py
The original notebook's population rules are reproduced; retained notebook outputs
are historical evidence and are not silently rewritten.
"""
from pathlib import Path
import argparse
import hashlib
import json

import pandas as pd
from tableauhyperapi import (
    Connection, CreateMode, HyperProcess, SqlType, TableDefinition, TableName,
    Telemetry, escape_string_literal,
)

ROOT = Path(__file__).resolve().parents[2]
SOURCE_SHA256 = "bcbe73b35f5b7babf197fb0cb983a11f5d9ff929078d4aa53d171b1f2df2e980"
EXPECTED = [1029609, 40077, 20913891.47, 5878, 11385368, 521.84]


def rebuild(raw_path: Path, output_root: Path = ROOT) -> dict:
    source_hash = hashlib.sha256(raw_path.read_bytes()).hexdigest()
    if source_hash != SOURCE_SHA256:
        raise ValueError("Source workbook differs from the reconciled UCI file; review its provenance first.")
    frames = []
    for sheet in ["Year 2009-2010", "Year 2010-2011"]:
        frame = pd.read_excel(raw_path, sheet_name=sheet)
        frame["SourceSheet"] = sheet  # This was present before notebook deduplication.
        frames.append(frame)
    raw = pd.concat(frames, ignore_index=True)
    clean = raw.drop_duplicates().copy()
    cancelled = clean["Invoice"].astype(str).str.startswith("C", na=False)
    sales = clean.loc[
        ~cancelled & clean["Quantity"].gt(0) & clean["Price"].gt(0)
        & clean["Description"].notna()
    ].copy()
    sales["Revenue"] = sales["Quantity"] * sales["Price"]
    sales = sales.rename(columns={
        "Invoice": "invoice_no", "StockCode": "stock_code", "Description": "description",
        "Quantity": "quantity", "InvoiceDate": "invoice_date", "Price": "unit_price",
        "Customer ID": "customer_id", "Country": "country", "Revenue": "revenue",
    })
    sales["invoice_no"] = sales["invoice_no"].astype(str).str.strip().str.replace(r"\.0$", "", regex=True)
    sales["stock_code"] = sales["stock_code"].astype(str)
    sales["customer_id"] = sales["customer_id"].astype("Int64")
    sales["invoice_date"] = pd.to_datetime(sales["invoice_date"])
    sales["transaction_id"] = range(1, len(sales) + 1)
    sales["is_cancelled"] = 0
    sales["loaded_at"] = pd.NaT  # Original load time is unknown.
    fields = [
        ("transaction_id", SqlType.big_int()), ("invoice_no", SqlType.text()),
        ("stock_code", SqlType.text()), ("description", SqlType.text()),
        ("quantity", SqlType.big_int()), ("invoice_date", SqlType.timestamp()),
        ("unit_price", SqlType.double()), ("customer_id", SqlType.big_int()),
        ("country", SqlType.text()), ("is_cancelled", SqlType.big_int()),
        ("revenue", SqlType.double()), ("loaded_at", SqlType.timestamp()),
    ]
    csv_path = output_root / "data/processed/sales_clean.csv"
    extract_path = output_root / "tableau/extracts/sales_clean.hyper"
    csv_path.parent.mkdir(parents=True, exist_ok=True)
    extract_path.parent.mkdir(parents=True, exist_ok=True)
    sales[[name for name, _ in fields]].to_csv(csv_path, index=False, date_format="%Y-%m-%d %H:%M:%S")
    table = TableDefinition(TableName("Extract", "Extract"), [
        TableDefinition.Column(name, datatype) for name, datatype in fields
    ])
    pending = extract_path.with_suffix(".pending.hyper")
    with HyperProcess(Telemetry.DO_NOT_SEND_USAGE_DATA_TO_TABLEAU,
                      parameters={"log_dir": str(csv_path.parent)}) as hyper:
        with Connection(hyper.endpoint, pending, CreateMode.CREATE_AND_REPLACE) as connection:
            connection.catalog.create_schema("Extract")
            connection.catalog.create_table(table)
            connection.execute_command(
                f"COPY {table.table_name} FROM {escape_string_literal(str(csv_path.resolve()))} "
                "WITH (FORMAT CSV, HEADER, NULL '')"
            )
            actual = connection.execute_list_query(
                'SELECT COUNT(*),COUNT(DISTINCT invoice_no),SUM(revenue),'
                'COUNT(DISTINCT customer_id),SUM(quantity),'
                'SUM(revenue)/COUNT(DISTINCT invoice_no) FROM "Extract"."Extract"'
            )[0]
    actual[2] = round(actual[2], 2)
    actual[5] = round(actual[5], 2)
    if actual != EXPECTED:
        raise ValueError(f"Extract reconciliation failed: {actual!r}")
    pending.replace(extract_path)
    result = {
        "status": "PASS", "raw_source_sha256": source_hash,
        "raw_rows": len(raw), "duplicates_removed": len(raw) - len(clean),
        "kpis": dict(zip(["sales_rows", "orders", "revenue_gbp", "identified_customers",
                          "units", "aov_gbp"], actual)),
        "csv_sha256": hashlib.sha256(csv_path.read_bytes()).hexdigest(),
        "scope": "Positive sales; anonymous sales retained; identified customers exclude missing IDs.",
    }
    (csv_path.parent / "tableau_rebuild_validation.json").write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--raw", type=Path, default=ROOT / "data/raw/online_retail_II.xlsx")
    parser.add_argument("--output-root", type=Path, default=ROOT)
    args = parser.parse_args()
    print(json.dumps(rebuild(args.raw, args.output_root), indent=2))
