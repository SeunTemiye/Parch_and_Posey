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
