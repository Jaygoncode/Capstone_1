-- Territory analyzed: New Jersey (in-store), Northeast region

USE sample_sales;

SELECT COUNT(*) AS number_of_sales
FROM store_sales
WHERE Store_ID IN (SELECT StoreId FROM store_locations WHERE State = 'New Jersey');
-- Territory analyzed: New Jersey (in-store), Northeast region

USE sample_sales;
-- Question 1: Total revenue and date range for New Jersey stores
-- Answer: New Jersey stores brought in about 5.2 million in total, Data covers from 12/31/2025 to 12/30/2025 all in four years
-- Result #2
SELECT
    SUM(Sale_Amount) AS total_revenue,
    MIN(Transaction_Date) AS start_date,
    MAX(Transaction_Date) AS end_date
FROM store_sales
WHERE Store_ID IN (SELECT StoreId FROM store_locations WHERE State = 'New Jersey');
-- Question 2: What is the revenue breakdown by year and month?
-- Answers: Revenue peaked in January 2022 with monthly revenue peeking at October 2025 at about $251K and the lowest was in February 2022 at about $63K. 
SELECT
    YEAR(Transaction_Date) AS sale_year,
    MONTH(Transaction_Date) AS sale_month,
    SUM(Sale_Amount) AS monthly_revenue
FROM store_sales
WHERE Store_ID IN (SELECT StoreId FROM store_locations WHERE State = 'New Jersey')
GROUP BY sale_year, sale_month
 ORDER BY monthly_revenue DESC;
-- Question 3: New Jersey vs. the Northeast region
-- -- Answer: New Jersey's store revenue ($5,175,405.87) is about 21.4% higher
-- of the Northeast region's total ($24,237,526.98).
SELECT SUM(Sale_Amount) AS northeast_revenue
FROM store_sales
WHERE Store_ID IN (
    SELECT StoreId
    FROM store_locations
    WHERE State IN (
        SELECT State FROM management WHERE Region = 'Northeast'
    )
);
SELECT ROUND(5175405.87 / 24237526.98 * 100, 1) AS nj_percent_of_northeast;
