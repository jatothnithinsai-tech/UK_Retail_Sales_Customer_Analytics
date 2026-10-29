# Dataset attribution

Chen, D. (2012). **Online Retail II** [Dataset]. UCI Machine Learning Repository. https://doi.org/10.24432/C5CG6D.

Dataset page: https://archive.ics.uci.edu/dataset/502/online+retail+ii

The dataset is distributed under [Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/). The repository's MIT licence applies to project code; it does not replace the dataset licence.

The included `sales_clean.hyper` extract and packaged Tableau workbook are derived from the original `online_retail_II.xlsx`. Both source worksheets were combined with their source-sheet labels before duplicate removal. Cancellation invoices were separated, and positive quantity/price sales with descriptions were retained. Revenue is quantity multiplied by unit price, without silent per-row rounding. Customer identifiers are the original dataset's numeric identifiers. `transaction_id` is a generated row key; the unknown historical load timestamp is left null.

The original workbook contains 1,067,371 rows. The curated positive-sales extract contains 1,029,609 rows. Changes and reconciliation are recorded in [redesign validation](docs/design/redesign_validation.json). Original raw Excel and bulk CSV files are excluded from Git.
