-- Territory analyzed: New Jersey (in-store), Northeast region

USE sample_sales;

SELECT COUNT(*) AS number_of_sales
FROM store_sales
WHERE Store_ID IN (SELECT StoreId FROM store_locations WHERE State = 'New Jersey');
-- Question 1: Total revenue and date range for New Jersey stores
SELECT
    SUM(Sale_Amount) AS total_revenue,
    MIN(Transaction_Date) AS start_date,
    MAX(Transaction_Date) AS end_date
FROM store_sales
WHERE Store_ID IN (SELECT StoreId FROM store_locations WHERE State = 'New Jersey');

