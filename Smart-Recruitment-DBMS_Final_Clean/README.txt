SMART RECRUITMENT & INTERVIEW MANAGEMENT SYSTEM
Final project package (Oracle SQL)

RUN ORDER — execute each script once in the same Oracle schema:
1. 03_SQL\code.sql — creates the project tables.
2. 03_Basic_Queries.sql\02_Insert_Data.sql — inserts the complete sample dataset.
3. 03_Basic_Queries.sql\03_Basic_Queries.sql — runs the basic project queries.
4. 04_Candidate_Screening\Screening_Queries.sql — runs the screening reports.
5. 03_Selection_Analytics\03_Selection_Analytics.sql — creates selection/offer data, reporting views, and Module 3 analytics.

In SQL Developer, use Run Script (F5) for scripts containing multiple statements and PL/SQL blocks. Use the same schema/connection for all five files. Sample hiring decisions, offer outcomes, rejection reasons, and joining status are illustrative.

Within the original core package, the sample-data script is the core insert script and the duplicate schema copy has been removed. Basic queries retain the original 10-query scope, and selection analytics remain in the Selection & Analytics folder. The core package is SQL-based; the additional Module 2 folder supplies interview-management tables, a conflict-prevention trigger, and an Oracle APEX application export.

----------------------------------------------------------------
MODULE 2: INTERVIEW MANAGEMENT (ORACLE APEX)
----------------------------------------------------------------

This module extends the existing recruitment database with
interviewer management, job-specific interview rounds, scheduled
interviews, interview feedback, and reporting.

Features:
- Primary and foreign key constraints for related records.
- Checks on interview status, mode, times, and feedback scores.
- A trigger that rejects overlapping interviews for the same
  interviewer, except for cancelled or no-show appointments.
- Views for interview schedules and feedback summaries.
- Oracle APEX pages for Interviewers, Interview Rounds,
  Interviews, and Interview Feedback.

Files in 05_Interview_Management:
- 06_Interview_Management.sql
  Creates the four Module 2 tables, seeds interviewer and round
  records, creates the conflict-prevention trigger, and defines
  reporting views and queries.
- 08_Insert_Interview_Sample_Data.sql
  Inserts seven sample interviews and four feedback records.
  Run once after the Module 2 tables and master data exist.
- 07_Test_Interview_Conflict.sql
  Attempts an overlapping interview. The expected result is
  ORA-20051; the insert should be rejected.
- Module2_Documentation.md
  Table relationships, constraints, reports, and run instructions.
- Module2_ER_Diagram.png
  ER diagram for the Module 2 tables.
- APEX_Application_Export.sql
  Exported definition of APEX application 200081.

Module 2 run order:
1. Run the original core schema script:
   03_SQL/code.sql.
2. Load the core sample data:
   03_Basic_Queries.sql/02_Insert_Data.sql.
3. Run 06_Interview_Management.sql using Run Script (F5) in
   SQL Developer. Use the same Oracle schema as the core tables.
4. Run 08_Insert_Interview_Sample_Data.sql once. Do not run it
   a second time against the same data.
5. Run 07_Test_Interview_Conflict.sql separately as a negative
   test. ORA-20051 is expected for the overlapping slot.
6. Import APEX_Application_Export.sql only when recreating the
   interface in an APEX workspace. The export does not replace
   the database schema or sample data.

The sample records use fictional candidates and interviewers.
The original schema, sample data, screening queries, and
selection analytics remain part of the project.
