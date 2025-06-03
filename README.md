# SQL Data Cleaning and Transformation – Parch & Posey Case Study

This project demonstrates a series of SQL-based data cleaning and transformation tasks using a fictional business dataset for Parch & Posey, a paper supply company.

### About Parch & Posey
Parch & Posey is a fictional paper company created for educational purposes, often featured in SQL and analytics learning platforms. It includes tables such as accounts, sales_reps, and more, designed to mimic the structure of real business data.

### Project Overview
This repository contains SQL scripts that:

Clean, parse, and analyze text-based data.

Transform fields for reporting and communication needs.

Perform exploratory transformations useful for business analytics.

### Tasks Breakdown
1. Domain Extension Analysis
Extract and count domain extensions (e.g., .com, .org) from company websites.

2. Company Name Initials Distribution
Analyze how company names are distributed by their first character (letter or number).

3. Classification by Name Type
Use a CASE statement to classify company names:

- Starting with numbers

- Starting with letters

- Calculate proportions for each group.

4. Vowel vs Other Starters
Segment companies based on whether their names begin with a vowel or not.

5. POC Name Parsing
Split the primary_poc field into first_name and last_name.

6. Sales Rep Name Parsing
Split full names in the sales_reps table into separate fields.

7. Email Generation
Construct professional email addresses for POCs using company domains.

8. Email Cleanup
Handle company names with spaces to ensure valid email format.

9. Initial Password Generation
Create secure temporary passwords using initials, name lengths, and cleaned company names.

### Skills Demonstrated
SQL string manipulation (SUBSTR, INSTR, REPLACE, LENGTH, LOWER, UPPER)

Conditional logic with CASE

Data formatting for email and password generation

Data classification and proportion analysis

Realistic business data transformation

### Technologies Used
SQL (compatible with PostgreSQL/MySQL)
