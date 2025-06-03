# SQL Data Cleaning – Parch & Posey project
### Introduction
This project demonstrates core SQL data cleaning techniques applied to a customer and sales dataset. The objective is to clean, structure, and transform raw business data for downstream analysis, communication workflows, and operational readiness.

### Project Overview
This repository contains SQL scripts that:

- Clean, parse, and analyze data.

- Generate cleaned fields such as names, email addresses, and formatted passwords.

- Apply string manipulation, conditional logic, and aggregation using SQL.

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
