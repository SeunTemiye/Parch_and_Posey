#1,Write a query to retrieve the first 15 rows of the `occurred_at`, `account_id`, and `channel` 
#columns from the `web_events` table.
SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 15;

#2,Write a query that fetches the 10 earliest entries in the `orders` table, displaying the `id`, 
#`occurred_at`, and `total_amt_usd` columns. 
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY id, occurred_at, total_amt_usd
LIMIT 10;

#3,Develop a query to obtain the top 5 entries with the highest `total_amt_usd` from the `orders` 
#table, including the `id`, `account_id`, and `total_amt_usd` fields.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

#4, Write a query to select the bottom 20 entries with the lowest `total_amt_usd` in the `orders` 
#table, showing the `id`, `account_id`, and `total_amt_usd` columns. 
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;

#5, Create a query that displays the `order ID`, `account ID`, and `total dollar amount` for all entries, 
#sorted first by `account ID` in ascending order and then by `total dollar amount` in descending order.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id ASC, total_amt_usd DESC;

#6, Compose a query that lists the `Order ID`, `account ID`, and `total dollar amount` for all entries, 
#this time sorted first by `total dollar amount` in descending order and then by `account ID` in ascending order. 
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id ASC;

# Question 7 answer: In question 5 SQL first arranged the account_id according to the query given that is from smallest to highest,
# then arranged the total_amt_usd from highest to the smallest amount
# While in question 6 SQL only arranged the total_amt_usd in descending order but didn't arrange the account_id in asc order

#8, Retrieve the first 5 rows and all columns from the `orders` table where `gloss_amt_usd` is 
#greater than or equal to 1000.
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

#9, Fetch the first 10 rows and all columns from the `orders` table where `total_amt_usd` is less than 500. 
SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

#10, Filter the `accounts` table to show the `company name`, `website`, and `primary point of 
#contact` for the company "Exxon Mobil".
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

#11, Generate a column that calculates the unit price for standard paper by dividing 
#`standard_amt_usd` by `standard_qty` for each order, and limit the results to the first 10 orders, 
#including the `id` and `account_id` columns.
SELECT id, account_id, (standard_amt_usd/standard_qty) AS Standard_paper
FROM orders
LIMIT 10;

#Question 12, Write a query to determine the percentage of revenue from poster paper for each order, using 
#only columns ending in `_usd`. Also, include the `id` and `account_id` fields, and limit the results 
#to the first 10 orders to avoid division by zero errors.
SELECT id, account_id, (poster_amt_usd/total_amt_usd)*100 percentage_poster_revenue
FROM orders
LIMIT 10;

#13, List all companies whose names start with 'C'.
SELECT *
FROM accounts
WHERE name LIKE 'C%';

#14,  List all companies whose names contain the substring 'one'.
SELECT *
FROM accounts
WHERE name LIKE '%1%';

#15, List all companies whose names end with 's'.
SELECT *
FROM accounts
WHERE name LIKE '%S';

#16, Use the `accounts` table to find the `account name`, `primary_poc`, and `sales_rep_id` for 
#"Walmart", "Target", and "Nordstrom". 
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

#17, Query the `web_events` table to find all details about individuals contacted via "organic" or 
#"adwords" channels.
SELECT *
FROM web_events
WHERE channel IN ('organic') OR channel IN ('adwords');

#18, Use the `accounts` table to find the `account name`, `primary poc`, and `sales rep id` for all 
#companies except "Walmart", "Target", and "Nordstrom".
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

#19, Query the `web_events` table to find all details about individuals contacted via any method 
#except "organic" or "adwords".
SELECT *
FROM web_events
WHERE channel NOT IN ('organic','adwords');

#20, Using the `accounts` table, find all companies whose names do not start with 'C'. 
SELECT *
FROM accounts
WHERE name  NOT LIKE'C%';

#21, Using the `accounts` table, find all companies whose names do not contain the substring 'one'.
SELECT *
FROM accounts
WHERE name  NOT LIKE'%1%';

#22, Using the `accounts` table, find all companies whose names do not end with 's'
SELECT *
FROM accounts
WHERE name  NOT LIKE'%S';

#23, Write a query to select all orders where `standard_qty` exceeds 1000, and both `poster_qty` and 
#`gloss_qty` are zero
SELECT *
FROM orders
WHERE standard_qty >1000 AND (poster_qty = 0 AND gloss_qty = 0);

#24, Use the `accounts` table to find all companies whose names do not start with 'C' and do not end 
#with 's'.
SELECT *
FROM accounts
WHERE name  NOT LIKE 'C%' AND name NOT LIKE '%S';

#25, Investigate whether the `BETWEEN` operator includes endpoint values by writing a query that 
#displays the `order date` and `gloss_qty` for all orders where `gloss_qty` is between 24 and 29, 
#then check the results
SELECT occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29;

#26, Use the `web_events` table to find all information about individuals contacted via "organic" or 
#"adwords" channels who started their account in 2016, sorted from newest to oldest.
SELECT *
FROM web_events
WHERE channel IN ('organic','adwords') 
     AND (occurred_at BETWEEN '2016-01-01' AND '2016-12-31')
ORDER BY occurred_at DESC;

#27, Find the list of `order ids` where either `gloss_qty` or `poster_qty` exceeds 4000, and include 
#only the `id` column in the results
SELECT id
FROM orders
WHERE (gloss_qty > 4000 OR poster_qty > 4000);

#28, Create a query to return orders where `standard_qty` is zero and either `gloss_qty` or 
#`poster_qty` is over 1000
SELECT *
FROM orders
WHERE (standard_qty = 0) AND (gloss_qty > 1000 OR poster_qty > 1000);

#29, Find all company names starting with 'C' or 'W', and where the primary contact contains 'ana' or 
#'Ana' but not 'eana'
SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%')
	  AND (primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%')
	  AND (primary_poc NOT LIKE '%eana%');
      
