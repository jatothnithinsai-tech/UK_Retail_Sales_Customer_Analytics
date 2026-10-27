# UK Retail Sales & Customer Analytics

**Python · MySQL · Tableau | Historical retail performance from source workbook to executive dashboard**

This project investigates sales trends, customer concentration, product performance and cancellations using UCI Online Retail II. It connects profiling and cleaning notebooks to SQL analysis and an editable Tableau workbook.

![Actual Tableau dashboard showing UK retail revenue, orders, customers, products and geography](images/uk_retail_sales_customers_analytics_dashboard.png)

*Actual saved dashboard export. It shows 40,077 orders; the executed Python notebook records 40,079. This two-order difference remains unreconciled and is disclosed below.*

**Explore:** [executed EDA notebook](python/notebooks/03_exploratory_data_analysis.ipynb) · [SQL analyses](sql/03_analysis/) · [Tableau workbook](tableau/workbook/uk_retail_sales_customer_analytics_dashboard.twb) · [business summary](docs/architecture/project_summary.md)

## Business questions

- How do revenue and purchasing patterns vary over time?
- Which countries, products and customers account for the most sales?
- What do cancellation records and missing customer identifiers mean for interpretation?
- Where should a commercial team investigate seasonal capacity, availability and retention?

## Recorded analytical results

| Metric | Python notebook / documented result |
|---|---:|
| Raw transaction rows | 1,067,371 |
| Retained analytical rows | 1,029,609 |
| Reported sales revenue | £20,913,891.47 |
| Orders | 40,079 |
| Identified customers | 5,878 |
| Units sold | 11,385,368 |
| Average order value | £521.82 |
| Cancelled orders | 8,292 |
| Reported order cancellation rate | 17.14% |

The figures above describe existing notebook outputs, not a newly executed full-data reconciliation. Revenue, sales and cancellation populations must be interpreted using the [data dictionary](docs/data_dictionary/data_dictionary.md) and [SQL KPI definitions](sql/03_analysis/01_kpi_analysis.sql).

## Findings and potential decisions

- The documented analysis finds **November strongest in both complete calendar years**. Investigate stock availability and fulfilment capacity ahead of the year-end peak. The dashboard's month-name view pools years; use year-month analysis for chronological comparisons.
- The UK contributes approximately **£17.81M**, indicating geographic concentration. Compare international markets using comparable customer coverage and order definitions.
- Product rankings include operational labels such as **Manual** and **POSTAGE**. Separate merchandise from adjustments before using rankings for stock decisions.
- The documented **17.14% cancellation rate** motivates a review by product, customer and month; it is not evidence that a proposed intervention has improved performance.
- Missing customer identifiers limit customer-level segmentation and retention. Do not equate identified-customer coverage with the full transaction population.

## Workflow and implementation

```mermaid
flowchart LR
    A[UCI Excel workbook] --> B[Python profiling and cleaning notebooks]
    B --> C[Curated CSV outputs]
    C --> D[(MySQL)]
    D --> E[Validation queries and reporting views]
    E --> F[Tableau workbook and dashboard]
```

| Location | Evidence |
|---|---|
| [python/notebooks/](python/notebooks/) | Profiling, cleaning and EDA notebooks with retained outputs |
| [python/scripts/](python/scripts/) | Cleaning and MySQL loading helpers |
| [sql/01_schema/](sql/01_schema/) | Database and table definitions |
| [sql/02_cleaning/](sql/02_cleaning/) | SQL validation |
| [sql/03_analysis/](sql/03_analysis/) | KPI, monthly, product, customer, country and time analysis |
| [sql/04_views/](sql/04_views/) | Reporting views |
| [tableau/](tableau/) | Editable TWB and dashboard export |
| [docs/](docs/) | Requirements, data dictionary, architecture and business summary |

## Reproduce or review

Review the dashboard, notebook outputs and SQL directly on GitHub without a database. To rebuild, use Python 3, MySQL and Tableau Desktop/Public and work from the repository root:

```bash
python -m venv .venv
# Activate .venv for your shell, then:
python -m pip install -r requirements.txt
```

1. Download `online_retail_II.xlsx` from [UCI Online Retail II](https://archive.ics.uci.edu/dataset/502/online+retail+ii) into `data/raw/`. Raw and processed files are excluded from Git.
2. Open the three notebooks in numeric order. Review their source paths and set the project root to your clone; retained outputs contain paths from the original workstation.
3. Use the notebooks to create the cleaned and MySQL-ready exports. Copy `.env.example` to `.env` and configure your local database. Keep credentials out of Git.
4. For a fresh database, execute `sql/01_schema/001_create_schema.sql`. Load the notebook's `cleaned_sales_mysql.csv` using `python python/scripts/load_to_mysql.py`, with `PROCESSED_CSV_PATH` matching your export. The loader appends rows: do not repeat it against an already loaded table without a deliberate reload plan.
5. Execute the validation, analysis and reporting-view SQL in numeric folder order.
6. Open the [Tableau workbook](tableau/workbook/uk_retail_sales_customer_analytics_dashboard.twb) and replace its original data connection with your local MySQL views or the matching curated files.

The standalone cleaning helper uses a different column convention from the notebook-based loader. Follow the notebook export route above; the portfolio review did not change or rerun the project code.

## Validation and limitations

- **Open reconciliation item:** the screenshot shows 40,077 orders while Python records 40,079. The £20.91M revenue and 5,878-customer headlines agree at displayed precision. A fresh source-to-Tableau reconciliation is needed before claiming exact cross-tool agreement.
- Source transactions cover December 2009–December 2011. These are historical methods and findings, not current market intelligence.
- Missing customer IDs, negative quantities and cancellation conventions affect analytical populations. Aggregate sales and customer analysis have different coverage.
- The TWB is an editable connection definition, not a packaged extract. A fresh clone requires source data and a local connection to refresh it.
- No new pipeline run, live Tableau refresh or realized business improvement is claimed by this documentation review.

## Source and reuse

[UCI Online Retail II](https://archive.ics.uci.edu/dataset/502/online+retail+ii), Chen, D. (2012), provides the historical source data under CC BY 4.0. Project code and documentation use the [MIT License](LICENSE); source data retains its separate terms.
