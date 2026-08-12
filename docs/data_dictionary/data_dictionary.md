# Data Dictionary

This file explains what each column in the retail dataset means.

## Columns

Invoice  
This is the invoice or order number for each transaction.

StockCode  
This is the unique code given to each product.

Description  
This shows the name or description of the product.

Quantity  
This tells us how many units of the product were purchased.

InvoiceDate  
This shows the date and time when the transaction happened.

Price  
This is the price of one unit of the product.

Customer ID  
This is the unique ID given to each customer.

Country  
This shows the country where the customer is located.

## Things I noticed before cleaning

While checking the dataset, I noticed that some rows may need cleaning before analysis.

Some customer IDs are missing.

Some quantity values may be negative because of returns or cancelled orders.

Some invoice numbers may represent cancelled transactions.

Some product descriptions may be missing or inconsistent.

I will keep the original raw file unchanged and do all cleaning on a separate copy or processed dataset.

## Initial Data Quality Check

I reviewed both sheets in the raw workbook without making any changes.

Year 2009–2010:
- 525,461 data rows
- 107,927 blank Customer IDs
- 12,326 negative Quantity values
- 10,206 invoices starting with "C"
- 2,928 blank Description values
- 3,687 Price values equal to 0
- 3 negative Price values

Year 2010–2011:
- 541,910 data rows
- 135,080 blank Customer IDs
- 10,624 negative Quantity values
- 9,288 invoices starting with "C"
- 1,454 blank Description values
- 2,515 Price values equal to 0
- 2 negative Price values

Total records across both sheets: 1,067,371.

The raw workbook was kept unchanged.
