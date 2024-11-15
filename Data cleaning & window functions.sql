-- DATA CLEANING QUIZ SOLUTIONS
/* Question 1*/

SELECT RIGHT(website, 3) AS domain, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

/* Question 2*/
SELECT LEFT(UPPER(name), 1) AS first_letter, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

/* Question 3*/
SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 1 ELSE 0 END AS num, 
				   CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 0 ELSE 1 END AS letter
	  FROM accounts) t1;
         
/* Question 4*/
SELECT SUM(vowels) vowels, SUM(other) other
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') THEN 1 ELSE 0 END AS vowels, 
				   CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') THEN 0 ELSE 1 END AS other
	  FROM accounts) t1;         
      
/* Question 5*/
SELECT LEFT(primary_poc, POSITION(' ' IN primary_poc) -1 ) first_name, 
RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) last_name
FROM accounts;      

/* Question 6*/
SELECT LEFT(name, POSITION(' ' IN name) -1 ) first_name, 
    RIGHT(name, LENGTH(name) - POSITION(' ' IN name)) last_name
FROM sales_reps;

/* Question 7*/
WITH t1 AS (
 SELECT LEFT(primary_poc, POSITION(' ' IN primary_poc) -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) last_name, name
 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com')
FROM t1;

/* Question 8*/
WITH t1 AS (
 SELECT LEFT(primary_poc, POSITION(' ' IN primary_poc) -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) last_name, name
 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', REPLACE(name, ' ', ''), '.com')
FROM  t1;

/* Question 9*/
WITH t1 AS (
 SELECT LEFT(primary_poc, POSITION(' ' IN primary_poc) -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) last_name, name
 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com'), LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) || LEFT(LOWER(last_name), 1) || RIGHT(LOWER(last_name), 1) || LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '')
FROM t1;

-- WINDOW FUNCTIONS QUIZ SOLUTIONS

/* Question 1*/
SELECT standard_amt_usd,
       SUM(standard_amt_usd) OVER (ORDER BY occurred_at) AS running_total
FROM orders;

/* Question 2*/
SELECT standard_amt_usd,
       DATE_FORMAT(occurred_at, "%Y") as year,
       SUM(standard_amt_usd) OVER (PARTITION BY DATE_FORMAT(occurred_at, "%Y") ORDER BY occurred_at) AS running_total
FROM orders;


/* Question 3*/
SELECT id,
       account_id,
       total,
       RANK() OVER (PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders;

/* Question 4*/
SELECT
       account_id,
       occurred_at,
       standard_qty,
       NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty) AS standard_quartile
  FROM orders 
 ORDER BY account_id DESC;
 
 /* Question 5*/
 SELECT
       account_id,
       occurred_at,
       gloss_qty,
       NTILE(2) OVER (PARTITION BY account_id ORDER BY gloss_qty) AS gloss_half
  FROM orders 
 ORDER BY account_id DESC;
 
 /* Question 6*/
 SELECT
       account_id,
       occurred_at,
       total_amt_usd,
       NTILE(100) OVER (PARTITION BY account_id ORDER BY total_amt_usd) AS total_percentile
  FROM orders 
 ORDER BY account_id DESC;
 
 /* Question 7*/
 /* 
 
 Remeber to add alias for all the other queries just for practice
 Below solution is window function alias for question 6*/
SELECT
       account_id,
       occurred_at,
       total_amt_usd,
       NTILE(100) OVER account_id_window AS total_percentile
       FROM orders 
WINDOW account_id_window AS (PARTITION BY account_id ORDER BY total_amt_usd)
ORDER BY account_id DESC;