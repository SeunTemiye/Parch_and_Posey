#1. Use the DISTINCT keyword to determine if any accounts are linked to multiple regions.

SELECT DISTINCT a.name account_name, COUNT(r.name) region
FROM accounts a 
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r 
ON r.id = s.region_id
GROUP BY 1
HAVING COUNT(r.name) > 1;

#2. Have any sales representatives handled more than one account? How many sales reps are 
#managing more than five accounts each?

SELECT s.name sales_rep, COUNT(a.id) account_id
FROM sales_reps s 
JOIN accounts a 
ON a.sales_rep_id = s.id
GROUP BY 1
HAVING COUNT(a.id) > 1;

SELECT COUNT(*) no_of_sales_reps
FROM (
     SELECT s.name sales_rep, COUNT(a.id) account_id
     FROM sales_reps s 
     JOIN accounts a 
     ON a.sales_rep_id = s.id
     GROUP BY 1
     HAVING COUNT(a.id) > 5
     ) AS sub_query;

#3. How many accounts have placed over 20 orders?

SELECT COUNT(*) no_of_accounts
FROM (
     SELECT account_id, COUNT(id)
     FROM orders
     GROUP BY 1
     HAVING COUNT(id) > 20
     ) AS sub_query;

#4. Identify the account with the highest number of orders.

SELECT a.name customer, COUNT(a.id) no_of_orders
FROM orders o
JOIN accounts a 
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

#5. Which accounts have spent more than $30,000 in total across all their orders?

SELECT a.name customer, SUM(total_amt_usd) total_spent
FROM orders o 
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
HAVING SUM(total_amt_usd) > 30000
ORDER BY 2 DESC;

#6. Which accounts have spent less than $1,000 in total across all their orders?

SELECT a.name customer, SUM(total_amt_usd) total_spent
FROM orders o 
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
HAVING SUM(total_amt_usd) < 1000
ORDER BY 2 DESC;


#7. Determine which account has the highest total spending with us.

SELECT a.name customer, SUM(total_amt_usd) total_spent
FROM orders o 
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

#8. Determine which account has the lowest total spending with us.

SELECT a.name customer, SUM(total_amt_usd) total_spent
FROM orders o 
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2
LIMIT 1;

#9. Which accounts have used Facebook as a customer contact channel more than six times?

SELECT a.name, w.channel, COUNT(w.channel) no_of_use
FROM web_events w
JOIN accounts a 
ON a.id = w.account_id
WHERE channel = 'Facebook'
GROUP BY 1,2
HAVING COUNT(w.channel) > 6;

#10. Identify the account that has used Facebook as a channel the most.

SELECT a.name, w.channel, COUNT(w.channel) no_of_use
FROM web_events w
JOIN accounts a 
ON a.id = w.account_id
WHERE channel = 'Facebook'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1;

#11. Determine which channel is most frequently used by the majority of accounts.
SELECT channel, COUNT(channel) no_of_use
FROM web_events 
GROUP BY 1
ORDER BY 2 DESC;

#12. Calculate the total sales in dollars for all orders each year, sorted from highest to lowest. Do you 
#observe any patterns in the yearly sales totals?

SELECT DATE_FORMAT(occurred_at, '%Y') year, SUM(total_amt_usd) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
#There was a yearly increase in sales from 2013 to 2016, but 2017 sales was low probably because the year hasn't ended yet.

#13. In which month did Parch & Posey achieve the highest sales in total dollars? Are all months 
#equally represented in the dataset?

SELECT DATE_FORMAT(occurred_at, '%M') month, SUM(total_amt_usd) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC; 
#not all the months are equally represented because 2017 has not ended yet.

#14. Identify the year in which Parch & Posey had the highest sales by the total number of orders. Are 
#all years equally represented in the dataset?

SELECT DATE_FORMAT(occurred_at, '%Y') year, COUNT(total) total_order, SUM(total_amt_usd) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
# not all the months in 2017 are accounted for because the year hasn't ended yet.

#15. Determine the month in which Parch & Posey had the highest number of orders. Are all months 
#equally represented in the dataset?

SELECT DATE_FORMAT(occurred_at, '%M') month, COUNT(total) total_order
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
#not all the months in 2017 are accounted for because the year hasn't ended yet.

#16. In which month and year did Walmart spend the most on gloss paper in terms of dollars?

SELECT a.name customer, DATE_FORMAT(occurred_at, '%Y-%m') date, SUM(gloss_amt_usd) gloss_sales
FROM orders o 
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1;

#17. Write a query to show, for each order, the account ID, the total order amount, and classify the 
#order as 'Large' if it is $3000 or more, and 'Small' if it is less than $3000.

SELECT DISTINCT account_id, total_amt_usd,
        CASE 
        WHEN total_amt_usd > 3000 THEN 'Large'
        WHEN total_amt_usd < 3000 THEN 'Small' END AS 'groups', COUNT(*) no_of_group
FROM orders
GROUP BY 1,2,3;
       
#18. Write a query to count the number of orders within three categories based on the total items 
#per order: 'At Least 2000', 'Between 1000 and 2000', and 'Less than 1000'.
SELECT 
        CASE 
        WHEN total >= 2000 THEN 'at least 2000'
        WHEN total BETWEEN 1000 AND 2000 THEN 'between 1000 and 2000'
        WHEN total < 1000 THEN 'less than 1000' END AS 'order', count(*) total_order
FROM orders
GROUP BY 1;

#19. We want to analyze customers at three different levels based on their total purchase amounts. 
#The top level includes customers with a Lifetime Value (total sales of all orders) above $200,000. 
#The second level is for those between $200,000 and $100,000. The lowest level is for those 
#under $100,000. Create a table showing each account's name, their total sales, and their level, 
#sorted by the highest spending customers first.

SELECT a.name customer,
        CASE 
        WHEN SUM(total_amt_usd) > 200000 THEN 'top level'
        WHEN SUM(total_amt_usd) BETWEEN 100000 AND 200000 THEN 'second level'
        WHEN SUM(total_amt_usd) < 100000 THEN 'lowest level' END AS 'level', SUM(total_amt_usd) total_sales
FROM orders o
JOIN accounts a 
ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC;

#20. Perform a similar calculation to the previous one, but only include total amounts spent by 
#customers in 2016 and 2017. Keep the same customer levels as before, and sort by the highest 
#spending customers first.

SELECT a.name customer, DATE_FORMAT(occurred_at, '%Y') year,
        CASE 
        WHEN SUM(total_amt_usd) > 200000 THEN 'top level'
        WHEN SUM(total_amt_usd) BETWEEN 100000 AND 200000 THEN 'second level'
        WHEN SUM(total_amt_usd) < 100000 THEN 'lowest level' END AS 'level', SUM(total_amt_usd) total_sales
FROM orders o
JOIN accounts a 
ON a.id = o.account_id
WHERE year(occurred_at) BETWEEN 2016 AND 2017
GROUP BY 1,2
ORDER BY 3 DESC;

#21. Identify the top-performing sales representatives, defined as those associated with more than 
#200 orders. Create a table with the sales rep's name, the total number of orders, and a column
#indicating 'Top' or 'Not' based on the 200-order threshold, with top performers listed first.

SELECT s.name sales_reps, COUNT(total) total_order, 
       CASE 
       WHEN COUNT(total) > 200 THEN 'Top' ELSE 'Not' END AS 'performance'
FROM sales_reps s
JOIN accounts a 
ON a.sales_rep_id = s.id
JOIN orders o 
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC;

#22. The previous analysis didn't include the middle group or account for the total sales amount. 
#Management now wants to see these aspects. Identify top-performing sales reps as those with 
#more than 200 orders or over $750,000 in sales. The middle group includes reps with more than 
#150 orders or over $500,000 in sales. Create a table with the sales rep's name, total number of 
#orders, total sales, and a column categorizing them as 'Top', 'Middle', or 'Low' based on these 
#criteria. Sort the table by the total sales amount, listing the top performers first. This new criteria 
#might cause some discontent among the sales team!

SELECT s.name sales_reps, COUNT(total) total_order, SUM(total_amt_usd) total_sales,
       CASE 
       WHEN COUNT(total) > 200 OR SUM(total_amt_usd) > 750000 THEN 'Top' 
       WHEN COUNT(total) > 150 OR SUM(total_amt_usd) > 500000 THEN 'Middle' ELSE 'Low' END AS 'performance'
FROM sales_reps s
JOIN accounts a 
ON a.sales_rep_id = s.id
JOIN orders o 
ON o.account_id = a.id
GROUP BY 1
ORDER BY 3 DESC;

#subquery quiz
#1. Identify the sales representative in each region with the highest total sales in USD.

WITH regions AS(
				SELECT s.name sales_reps, r.name region, SUM(total_amt_usd) total_sales
                FROM sales_reps s 
                JOIN region r 
                ON r.id = s.region_id
                JOIN accounts a 
                ON a.sales_rep_id = s.id
                JOIN orders o 
                ON o.account_id = a.id
                GROUP BY 1,2
                ORDER BY 3 DESC
                ),
  max_sales AS (
              SELECT region, MAX(total_sales) max_sales
              FROM regions
              GROUP BY 1
              )
SELECT r.sales_reps, r.region, ms.max_sales
FROM max_sales ms
JOIN regions r
ON r.region = ms.region AND r.total_sales = ms.max_sales;

#2. In the region with the highest cumulative sales in USD, how many orders were placed?

WITH regions AS(
				SELECT r.name region, COUNT(total) no_of_orders, SUM(total_amt_usd) total_sales
                FROM sales_reps s 
                JOIN region r 
                ON r.id = s.region_id
                JOIN accounts a 
                ON a.sales_rep_id = s.id
                JOIN orders o 
                ON o.account_id = a.id
                GROUP BY 1
                ORDER BY 3 DESC
                ),
  max_order AS (
              SELECT region, MAX(no_of_orders) total_count
              FROM regions
              GROUP BY 1
              )
SELECT r.region, mo.total_count
FROM max_order mo
JOIN regions r
ON r.region = mo.region
AND r.no_of_orders = mo.total_count
LIMIT 1;

#3. How many accounts have made more total purchases than the account with the highest lifetime 
#purchases of standard quantity paper?
WITH max_standard AS (
                SELECT a.name customer, SUM(standard_qty) max_standard, SUM(total) total_order
                FROM orders o 
                JOIN accounts a 
                ON o.account_id = a.id
                GROUP BY 1
                ORDER BY 2 DESC
                LIMIT 1
                )
SELECT COUNT(*) no_of_customers
FROM (
      SELECT a.name
      FROM accounts a 
      JOIN orders o 
      ON o.account_id = a.id
      GROUP BY 1
      HAVING SUM(total) > (SELECT total_order 
                           FROM max_standard)
	) sub_query;

#4. For the customer who has spent the most in USD over their lifetime, how many web events did 
#they have for each channel?

WITH total_amt AS (
                     SELECT a.name customer, SUM(o.total_amt_usd) AS total_spent
                     FROM accounts a
                     JOIN orders o 
                     ON o.account_id = a.id
                     GROUP BY 1
                     ),
    max_customer AS (
                SELECT customer, total_spent
                FROM total_amt
                ORDER BY 2 DESC
                LIMIT 1
				),
     web_events AS (
                SELECT a.name customer, w.channel channel, COUNT(channel) AS web_count
                FROM web_events w
                JOIN accounts a 
                ON w.account_id = a.id
                JOIN max_customer mc 
                ON a.name = mc.customer
                GROUP BY 1,2
                )
SELECT customer, channel, web_count
FROM web_events we;

#5. #What is the lifetime average spending in USD for the top 10 highest spending accounts?

SELECT AVG(total_spent) lifetime_avg_spending
FROM (
	 SELECT a.name customer, SUM(total_amt_usd) total_spent
	 FROM accounts a 
     JOIN orders o 
     ON a.id = o.account_id
     GROUP BY 1
     ORDER BY 2 DESC
     LIMIT 10) subquery;

#6. What is the lifetime average spending in USD for companies that have a higher average spending 
#per order than the overall order average?

WITH overall_avg AS (
				SELECT AVG(total_amt_usd) avg_order_spending
                FROM orders
                ),
   company_avg AS (
			   SELECT account_id, SUM(total_amt_usd) total_spent,
               AVG(total_amt_usd) avg_spending_per_order
               FROM orders
               GROUP BY 1
               )

SELECT AVG(c.total_spent) lifetime_avg_spending
FROM company_avg c
JOIN overall_avg oa 
ON c.avg_spending_per_order > oa.avg_order_spending;

