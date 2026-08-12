# Project Summary and Business Insights

## Executive summary

This project transforms 1,067,371 raw UK online-retail transaction records
into a controlled analytical workflow using Python, MySQL, and Tableau. After
profiling and cleaning, 1,029,609 transaction rows were retained for analysis.
The final dashboard gives management a consolidated view of revenue, orders,
customers, products, geography, purchasing times, and cancellations.

## KPI summary

| KPI | Result |
|---|---:|
| Total revenue | £20,913,891.47 |
| Total orders | 40,079 |
| Total customers | 5,878 |
| Units sold | 11,385,368 |
| Average order value | £521.82 |
| Cancelled orders | 8,292 |
| Cancellation rate | 17.14% |

## Business insights

1. **Sales are strongly seasonal.** November produced the highest revenue in
   both complete calendar years. Inventory, marketing, and fulfillment capacity
   should be increased ahead of the year-end peak.
2. **Revenue is geographically concentrated.** The United Kingdom generated
   approximately £17.81M, far ahead of every other country. EIRE, the
   Netherlands, Germany, and France are the strongest international candidates.
3. **A small group of products drives meaningful revenue.** `REGENCY CAKESTAND
   3 TIER` was the highest-revenue named product and should be prioritized for
   availability, cross-selling, and campaign placement.
4. **Cancellations require management attention.** A 17.14% order cancellation
   rate can materially reduce realized revenue and increase operating costs.
5. **Customer analysis has a known coverage limitation.** Missing Customer IDs
   preserve aggregate reporting value but prevent customer-level retention work.
6. **Operational labels affect product rankings.** Manual entries, postage, and
   adjustments should be separated for merchandising-specific analysis.

## Recommendations

- Launch seasonal campaigns before the October-November revenue surge.
- Protect inventory availability for top-revenue products during peak months.
- Investigate cancellation rates by product, customer, country, and month.
- Develop targeted retention campaigns for high-value and frequent customers.
- Test international growth initiatives in the strongest non-UK markets.
- Improve customer identification capture to increase CRM analysis coverage.
- Maintain separate executive-sales and merchandising-product definitions.

## Deliverables

- Three executed Jupyter notebooks for profiling, cleaning, and EDA
- Reusable Python cleaning and MySQL loading scripts
- MySQL schema, validation, analysis, and reporting-view SQL
- Tableau workbook and portfolio dashboard image
- Business requirements, data dictionary, architecture, and project summary
