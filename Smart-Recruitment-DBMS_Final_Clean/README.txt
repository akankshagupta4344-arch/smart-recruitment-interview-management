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

----------------------------------------------------------------
MODULE 2: INTERVIEW MANAGEMENT (ORACLE APEX)
----------------------------------------------------------------

This additive module extends the existing Smart Recruitment
project. The original database design, sample data, screening,
and selection analytics files are retained.

Features:
- Interviewer and interview-round management.
- Interview scheduling and status tracking.
- Interviewer feedback with technical, communication,
  problem-solving, and overall scores.
- Prevention of overlapping interview slots for an interviewer.
- Oracle APEX pages for Interviewers, Interview Rounds,
  Interviews, and Interview Feedback.

Files in 05_Interview_Management:
- 06_Interview_Management.sql
  Creates the Module 2 tables and supporting trigger/reporting
  logic, and seeds interviewer and round information.
- 08_Insert_Interview_Sample_Data.sql
  Adds seven sample interviews and four feedback records.
  Run once after the core seed data and Module 2 tables exist.
- 07_Test_Interview_Conflict.sql
  Intentionally attempts an overlapping interview. The expected
  result is Oracle error ORA-20051 from the conflict trigger.
- Module2_Documentation.md
  Module overview and documentation.
- Module2_ER_Diagram.png
  Module 2 entity-relationship diagram.
- APEX_Application_Export.sql
  Exported definition of Oracle APEX application 200081.

Suggested setup:
1. Follow the original core project RUN ORDER above.
2. Run 06_Interview_Management.sql in the same Oracle schema.
3. Ensure the Module 2 tables, interviewers, and rounds exist.
4. Run 08_Insert_Interview_Sample_Data.sql once to add the sample
   interviews and feedback.
5. Run the queries in 07_Test_Interview_Conflict.sql as a
   negative test; the overlapping insert should be rejected.
6. Import APEX_Application_Export.sql through Oracle APEX if
   you need to recreate the application's pages.

The APEX export stores the application definition, not a
replacement for the database schema and sample-data scripts.
The Module 2 trigger and sample data extend the original project;
they do not replace the earlier modules.
