# Architecture

```mermaid
flowchart LR
    A[Raw retail workbook] --> B[Python profiling and cleaning]
    B --> C[Processed CSV files]
    C --> D[(MySQL sales_clean table)]
    D --> E[MySQL analysis queries and views]
    E --> F[Tableau data model]
    F --> G[Published portfolio dashboard]
```

## Layers

- **Raw:** Immutable source files, excluded from version control.
- **Processed:** Reproducible cleaned extracts.
- **Warehouse:** Typed transaction tables in MySQL.
- **Analytics:** Stable views that define reporting logic.
- **Presentation:** Tableau worksheets, calculated fields, and dashboards.
