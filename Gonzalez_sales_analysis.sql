-- Territory analyzed: New Jersey (in-store), Northeast region

USE sample_sales;

SELECT COUNT(*) AS number_of_sales
FROM store_sales
WHERE Store_ID IN (SELECT StoreId FROM store_locations WHERE State = 'New Jersey');


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
-- Answer: New Jersey's store revenue ($5,175,405.87) is about 21.4%
-- of the Northeast total ($24,237,526.98). The Northeast has 4 states,
-- so an even split would be 25% each. NJ is slightly below that.
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
SELECT State FROM management WHERE Region = 'Northeast';

-- Question 4: What is the number of transactions per month and average transaction amount by product category for the sales territory?
--  Transactions per month and average sale by category (New Jersey)
-- 288 rows, one for each month and category that had sales.
-- Technology and Accessories has the biggest average sale ($460.57) and
-- Stationery and Supplies has the smallest ($10.06). Stationery and Supplies has the most transactions of 8265
SELECT
    YEAR(s.Transaction_Date) AS sale_year,
    MONTH(s.Transaction_Date) AS sale_month,
    c.Category,
    COUNT(*) AS number_of_transactions,
    AVG(s.Sale_Amount) AS avg_sale_amount
FROM store_sales s
JOIN products p ON s.Prod_Num = p.ProdNum
JOIN inventory_categories c ON p.Categoryid = c.Categoryid
WHERE s.Store_ID IN (SELECT StoreId FROM store_locations WHERE State = 'New Jersey')
GROUP BY sale_year, sale_month, c.Category 
ORDER BY sale_year, sale_month, c.Category;

-- Question 5: Rank New Jersey stores by total revenue
-- Answer: 16 NJ stores ranked. Newark ($623,163.53) is first and
-- Trenton ($597,565.68) is second. The last-place store is Paterson at $67,112.57.
SELECT
    l.StoreLocation,
    l.StoreId,
    SUM(s.Sale_Amount) AS total_revenue
FROM store_sales s
JOIN store_locations l ON s.Store_ID = l.StoreId
WHERE l.State = 'New Jersey'
GROUP BY l.StoreLocation, l.StoreId
ORDER BY total_revenue DESC;

-- Question 6 Recommendation:
-- Next quarter, focus sales attention on Technology & Accessories.
-- Why: it has the highest average sale ($460.57) and brings in
-- $3,630,738.42 in total revenue, about 70% of New Jersey sales.
-- 70% from one category also means New Jersey depends heavily on Technology. Which can be a risk if it starts to drop in revenue.
-- Stationery has the most transactions (8,265) but only ~$10 each
-- (about 1.6% of revenue), so extra effort there adds little revenue.
SELECT
    c.Category,
    SUM(s.Sale_Amount) AS total_revenue
FROM store_sales s
JOIN products p ON s.Prod_Num = p.ProdNum
JOIN inventory_categories c ON p.Categoryid = c.Categoryid
WHERE s.Store_ID IN (SELECT StoreId FROM store_locations WHERE State = 'New Jersey')
GROUP BY c.Category
ORDER BY total_revenue DESC;
