#1, Retrieve all data from the accounts table and all data from the orders table. Also, extract the 
#columns standard_qty, gloss_qty, and poster_qty from the orders table, along with the website 
#and primary_poc from the accounts table.
SELECT o.standard_qty, o.gloss_qty, o.poster_qty, a.website, a.primary_poc
FROM accounts a
JOIN orders o
ON a.id= o.account_id;

#2, Create a table listing all web events associated with the account name "Walmart." Include three 
#columns: primary_poc, event time, and event channel. Optionally, add a fourth column to 
#confirm that only Walmart events are selected.
SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON a.id = w.account_id AND a.name = 'Walmart';

#3, Generate a table that shows the region for each sales representative along with their associated 
#accounts. The table should have three columns: region name, sales rep name, and account name.
#Sort the accounts alphabetically by account name.
SELECT r.name region_name, s.name sales_rep_name, a.name account_name
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name;

#4, Display the region name, account name, and unit price (total_amt_usd/total) for each order. 
#Include a safety measure to avoid division by zero by using (total + 0.01) in the denominator.
SELECT r.name region_name, a.name account_name, (total_amt_usd/total)/(total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;

#5, Create a table showing the region for each sales representative and their associated accounts, 
#specifically for the Midwest region. Include three columns: region name, sales rep name, and 
#account name. Sort the accounts alphabetically by account name.
SELECT r.name region_name, s.name sales_rep_name, a.name account_name
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest'
ORDER BY account_name;

#6. List the region for each sales representative and their associated accounts, only for sales reps 
#with a first name starting with 'S' in the Midwest region. The table should have three columns: 
#region name, sales rep name, and account name, sorted alphabetically by account name
SELECT r.name region_name, s.name sales_rep_name, a.name account_name
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE s.name LIKE 'S%' AND r.name = 'Midwest'
ORDER BY account_name;

#7. Create a table showing the region for each sales representative and their associated accounts, 
#limited to sales reps with a last name starting with 'K' in the Midwest region. Include three 
#columns: region name, sales rep name, and account name, sorted alphabetically by account name.
SELECT r.name region_name, s.name sales_rep_name, a.name account_name
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND SUBSTRING_INDEX(s.name, ' ', -1) LIKE 'K%'
ORDER BY account_name;

#8. Display the region name, account name, and unit price (total_amt_usd/total) for orders where 
#the standard order quantity exceeds 100. Use (total + 0.01) to prevent division by zero.
SELECT r.name region_name, a.name account_name, (total_amt_usd/total)/(total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100;

#9. List the region name, account name, and unit price (total_amt_usd/total) for orders where the 
#standard order quantity exceeds 100 and the poster order quantity exceeds 50. Sort the results 
#by the smallest unit price first, and use (total + 0.01) to avoid division by zero.
SELECT r.name region_name, a.name account_name, (total_amt_usd/total)/(total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER by unit_price;

#10. List the region name, account name, and unit price (total_amt_usd/total) for orders where the 
#standard order quantity exceeds 100 and the poster order quantity exceeds 50. Sort the results 
#by the largest unit price first, and use (total + 0.01) to avoid division by zero.
SELECT r.name region_name, a.name account_name, (total_amt_usd/total)/(total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER by unit_price DESC;

#11. Identify the different channels used by account ID 1001. The table should have two columns: 
#account name and the unique channels, which can be achieved using SELECT DISTINCT
SELECT DISTINCT a.name account_name, channel
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
WHERE account_id = 1001;

#12. Find all orders that occurred in 2015. The table should have four columns: occurred_at, account 
#name, order total, and order total_amt_usd.
SELECT o.occurred_at, a.name account_name, o.total, o.total_amt_usd
FROM orders o 
JOIN accounts a
ON o.account_id = a.id
WHERE occurred_at BETWEEN '2015-01-01' AND '2015-12-31';

#13. Calculate the total amount of poster_qty paper ordered in the orders table.
SELECT SUM(poster_qty) total_poster_order
FROM orders;

#14. Calculate the total amount of standard_qty paper ordered in the orders table.
SELECT SUM(standard_qty) total_standard_order
FROM orders;

#15. Determine the total sales in USD using the total_amt_usd in the orders table.
SELECT SUM(total_amt_usd) total_sales
FROM orders;

#16. Calculate the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order, 
#giving a dollar amount for each order.
SELECT SUM(standard_amt_usd), SUM(gloss_amt_usd)
FROM orders;

#17. Find the standard_amt_usd per unit of standard_qty paper using both aggregation and a 
#mathematical operator.
SELECT SUM(standard_amt_usd/standard_qty) total_unit_price
FROM orders;

#18. Identify the earliest order date ever placed.
SELECT MIN(occurred_at) 
FROM orders;

#19. Perform the same query as in question 18 without using an aggregation function.
SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1;

#20. Determine the date of the most recent web_event.
SELECT MAX(occurred_at)
FROM web_events;

#21. Perform the query from question 20 without using an aggregation function.
SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

#22. Find the average amount spent per order on each paper type and the average amount of each 
#paper type purchased per order. The result should have six values.
SELECT AVG(standard_amt_usd) avg_standard_amt_usd, AVG(gloss_amt_usd) avg_gloss_amt_usd, 
       AVG(poster_amt_usd) avg_poster_amt_usd, AVG(standard_qty) avg_standard_qty, 
       AVG(gloss_qty) avg_gloss_qty, AVG(poster_qty) avg_poster_qty
FROM orders;

#23. Calculate the median total_usd spent on all orders. 
SELECT total_amt_usd median_total_amt_usd
FROM (SELECT total_amt_usd
,row_number() OVER (ORDER BY total_amt_usd ASC) AS row_asc
,row_number() OVER (ORDER BY total_amt_usd DESC) AS row_desc
FROM orders ) median_total_amt_usd
WHERE row_asc IN ( row_desc = 0, row_desc - 1, row_desc + 1);

#24. Identify the account (by name) that placed the earliest order, including the account name and 
#the date of the order
SELECT a.name account_name, MIN(occurred_at) earliest_order
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY 1
LIMIT 1;

#25. Calculate the total sales in USD for each account, including two columns: the total sales in USD 
#and the company name.
SELECT a.name account_name, SUM(total_amt_usd) total_sales_usd
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY 1;

#26. Determine the channel of the most recent web_event and the associated account. The query 
#should return three values: the date, channel, and account name.
SELECT a.name account_name, channel, MAX(occurred_at)
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
GROUP BY 1,2
LIMIT 1;

#27. Count the total number of times each type of channel from the web_events table was used. The 
#final table should have two columns: the channel and the number of times it was used.
SELECT channel, COUNT(channel) total_no_of_times_used
FROM web_events
GROUP BY 1;

#28. Identify the primary contact associated with the earliest web_event.
SELECT a.primary_poc, channel, MIN(occurred_at)
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
GROUP BY 1,2
LIMIT 1;

#29. Determine the smallest order placed by each account in terms of total USD. Provide two 
#: account name and total USD, ordered from smallest to largest.
SELECT a.name account_name, SUM(total_amt_usd) total_sales_usd
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY 1
ORDER BY total_sales_usd;

#30. Count the number of sales reps in each region. The table should have two columns: region and 
#the number of sales reps, ordered from fewest to most.
SELECT r.name region, COUNT(s.id) no_sales_reps
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
GROUP BY 1
ORDER BY no_sales_reps;

#31. Calculate the average amount of each type of paper purchased across all orders for each 
#account. The result should have four columns: account name and the average quantity 
#purchased for each paper type.
SELECT a.name account_name, AVG(standard_qty) avg_standard_qty, 
       AVG(gloss_qty) avg_gloss_qty, AVG(poster_qty) avg_poster_qty
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1;

#32. Determine the average amount spent per order on each paper type for each account. The result 
#should have four columns: account name and the average amount spent on each paper type.
SELECT a.name account_name, AVG(standard_amt_usd) avg_standard_amt_usd, AVG(gloss_amt_usd) avg_gloss_amt_usd, 
       AVG(poster_amt_usd) avg_poster_amt_usd
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY 1;

#33. Count the number of times each channel was used in the web_events table for each sales rep. 
#The table should have three columns: sales rep name, channel, and number of occurrences, 
#ordered by highest to lowest.
SELECT s.name sales_rep_name, w.channel, COUNT(w.channel) no_of_occurrence
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY 1,2
ORDER BY no_of_occurrence DESC;

#34. Count the number of times each channel was used in the web_events table for each region. The 
#table should have three columns: region name, channel, and number of occurrences, ordered by 
#highest to lowest
SELECT r.name region_name, w.channel, COUNT(w.channel) no_of_occurrence
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r 
ON s.region_id = r.id
GROUP BY 1,2
ORDER BY no_of_occurrence DESC;