--Data cleaning
/*1. In the accounts table, there's a column with each company's website. The last three characters 
indicate the type of web address. Extract these extensions and count how many of each type 
exist in the accounts table*/.

SELECT RIGHT(website, 3) extensions, COUNT(website) number_of_extensions
FROM accounts
GROUP BY 1;

/*2. There's a lot of discussion about the impact of a company's name (or even the first letter). Use 
the accounts table to extract the first letter of each company name and analyze the distribution 
of company names starting with each letter (or number)*/.

SELECT SUBSTR(name, 1,1) first_letter, COUNT(name) distribution
FROM accounts
GROUP BY 1;

/*3. Use the accounts table and a CASE statement to create two groups: one with company names 
starting with a number and the other with names starting with a letter. Determine the 
proportion of company names that begin with a letter*/.

SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 1 ELSE 0 END AS num, 
		   CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 0 ELSE 1 END AS letter
     FROM accounts) num_name;

/*4. Consider vowels as a, e, i, o, and u. Calculate the proportion of company names that start with a 
vowel and the percentage that start with other characters*/.

SELECT 
        CASE 
        WHEN SUBSTR(name, 1, 1) IN ('a', 'e', 'i', 'o', 'u') THEN 'Vowel' ELSE 'Other' END AS company_name,
        COUNT(name) number_of_names,
        100 * COUNT(name) / (SELECT COUNT(name) FROM accounts) proportion
FROM accounts
GROUP BY 1;

/*5. Use the accounts table to split the primary_poc field into separate first and last name columns*/.

SELECT SUBSTR(primary_poc, 1, INSTR(primary_poc, ' ')-1) first_name,
       SUBSTR(primary_poc, INSTR(primary_poc, ' ')+1) last_name
FROM accounts;

/*6. Do the same for every rep name in the sales_reps table, creating first and last name columns*/

SELECT SUBSTR(name, 1, INSTR(name, ' ')-1) first_name,
       SUBSTR(name, INSTR(name, ' ')+1) last_name
FROM sales_reps;

/*7. Each company in the accounts table wants to create an email address for their primary_poc. The 
email should follow the format: firstname.lastname@companyname.com.*/
SELECT CONCAT(
       SUBSTR(primary_poc, 1, INSTR(primary_poc, ' ')-1), '.',
       SUBSTR(primary_poc, INSTR(primary_poc, ' ')+1), '@', 
       SUBSTR(website,5)
       ) email
FROM accounts;

/*8. Some company names include spaces, which won't work in an email address. Create a valid 
email address by removing all spaces from the company name while following the same format 
as the previous question.*/

SELECT CONCAT(
       SUBSTR(primary_poc, 1, INSTR(primary_poc, ' ')-1), '.',
       SUBSTR(primary_poc, INSTR(primary_poc, ' ')+1), '@', 
       REPLACE(
       SUBSTR(website,5), ' ', '')
       ) email
FROM accounts;

/*9. Create an initial password for each primary_poc, which they will change after their first login. 
The password should be: the first letter of their first name (lowercase), the last letter of their first 
name (lowercase), the first letter of their last name (lowercase), the last letter of their last name 
(lowercase), the number of letters in their first name, the number of letters in their last name, 
and the company name (uppercase with no spaces)*/

SELECT CONCAT(
       LOWER(SUBSTR(primary_poc,1,1)),  -- step 1- create first letter of first name(lowercase)
       LOWER(SUBSTR(primary_poc, INSTR(primary_poc,' ')-1,1)), -- step 2- create last letter of their first name(lowercase)
       LOWER(SUBSTR(primary_poc, INSTR(primary_poc,' ')+1,1)), -- step 3- create first letter of their last name(lowercase)
	   LOWER(SUBSTR(
	   SUBSTR(primary_poc, INSTR(primary_poc, ' ') + 1),  -- step 4- create last letter of their last name(lowercase)
	   LENGTH(
       SUBSTR(primary_poc, INSTR(primary_poc, ' ') + 1)), 1)),
       LENGTH(SUBSTR(primary_poc, 1, INSTR(primary_poc, ' ') - 1)), -- step 5 - create number of letters in their first name
       LENGTH(SUBSTR(primary_poc, INSTR(primary_poc, ' ') + 1)), -- step 6 - create number of letters in their last name 
       UPPER(REPLACE(name, ' ', ''))                             -- step 7- company name (upper case no spaces)
	 ) initial_password
FROM accounts;

-- Window functions
/*1. Create a running total of standard_amt_usd from the orders table over order time without 
truncating the date. Your final table should include two columns: one for the amount added with 
each new row and another for the running total.*/

SELECT standard_amt_usd, 
       SUM(standard_amt_usd) OVER (ORDER BY occurred_at) AS running_total
FROM orders;

/*2. Modify your query from the previous task to include partitions. Create a running total of 
standard_amt_usd from the orders table over order time, truncating the occurred_at date by 
year and partitioning by the year-truncated occurred_at variable.*/

SELECT DATE_FORMAT(occurred_at, '%Y') year, standard_amt_usd,
       SUM(standard_amt_usd) OVER date_format_window AS running_total
FROM orders
WINDOW date_format_window AS (PARTITION BY DATE_FORMAT(occurred_at, '%Y') ORDER BY occurred_at);

/*3. Select the id, account_id, and total from the orders table, then create a column called total_rank 
that ranks the total amount of paper ordered (from highest to lowest) for each account using a 
partition. Your final table should include these four columns.*/

SELECT id, account_id, total,
       RANK() OVER account_id_window AS total_rank
FROM orders
WINDOW account_id_window AS (PARTITION BY account_id ORDER BY total DESC);

/*4. Use the NTILE function to divide the accounts into four levels based on the amount of 
standard_qty in their orders. Your resulting table should include the account_id, the occurred_at 
time for each order, the total amount of standard_qty paper purchased, and one of four levels in 
a standard_quartile column.*/

SELECT
    account_id,
    occurred_at,
    standard_qty,
    NTILE(4) OVER account_id_window AS standard_quartile
FROM 
    orders
    WINDOW 
    account_id_window AS (PARTITION BY account_id ORDER BY total_amt_usd)
ORDER BY 
    account_id DESC, occurred_at;


/*5. Use the NTILE functionality to divide the accounts into two levels in terms of the amount of 
gloss_qty for their orders. Your resulting table should have the account_id, the occurred_at time 
for each order, the total amount of gloss_qty paper purchased, and one of two levels in a 
gloss_half column.*/

SELECT
    account_id,
    occurred_at,
    gloss_qty,
    NTILE(2) OVER account_id_window AS gloss_half
FROM 
    orders
    WINDOW 
    account_id_window AS (PARTITION BY account_id ORDER BY total_amt_usd)
ORDER BY 
    account_id DESC, occurred_at;


/*6. Use an alias for each window function you wrote in all of the queries above.
Use the NTILE functionality to divide the orders for each account into 100 levels in terms of the amount 
of total_amt_usd for their orders. Your resulting table should have the account_id, the occurred_at time 
for each order, the total amount of total_amt_usd paper purchased, and one of 100 levels in a 
total_percentile column*/

SELECT 
    account_id,
    occurred_at,
    total_amt_usd,
    NTILE(100) OVER account_id_window AS total_percentile
FROM 
    orders
WINDOW 
    account_id_window AS (PARTITION BY account_id ORDER BY total_amt_usd)
ORDER BY 
    account_id DESC, occurred_at;


