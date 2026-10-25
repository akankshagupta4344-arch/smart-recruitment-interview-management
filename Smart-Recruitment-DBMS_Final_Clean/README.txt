SMART RECRUITMENT & INTERVIEW MANAGEMENT SYSTEM
Final project package (Oracle SQL)

RUN ORDER — execute each script once in the same Oracle schema:
1. 03_SQL\code.sql — creates the project tables.
2. 03_Basic_Queries.sql\02_Insert_Data.sql — inserts the complete sample dataset.
3. 03_Basic_Queries.sql\03_Basic_Queries.sql — runs the basic project queries.
4. 04_Candidate_Screening\Screening_Queries.sql — runs the screening reports.
5. 03_Selection_Analytics\03_Selection_Analytics.sql — creates selection/offer data, reporting views, and Module 3 analytics.

In SQL Developer, use Run Script (F5) for scripts containing multiple statements and PL/SQL blocks. Use the same schema/connection for all five files. Sample hiring decisions, offer outcomes, rejection reasons, and joining status are illustrative.

The complete sample-data file is the only insert script in this clean package, preventing duplicate primary-key inserts. The duplicate schema copy has been removed. Basic queries retain the original 10-query scope; Module 3 reports stay in the Selection & Analytics folder. Procedures and triggers were optional and are omitted. No GUI is included.
