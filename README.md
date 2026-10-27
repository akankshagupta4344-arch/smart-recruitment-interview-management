# Smart Recruitment and Interview Management System

Oracle SQL database project with an Oracle APEX interface for interview management.

## Project contents

- `Smart-Recruitment-DBMS_Final_Clean/01_Database_Design/` — entity list, normalization, and relational schema.
- `Smart-Recruitment-DBMS_Final_Clean/02_ER_Diagram/` — original system ER diagram.
- `Smart-Recruitment-DBMS_Final_Clean/03_SQL/` — core database schema.
- `Smart-Recruitment-DBMS_Final_Clean/03_Basic_Queries.sql/` — sample data and basic queries.
- `Smart-Recruitment-DBMS_Final_Clean/04_Candidate_Screening/` — screening queries.
- `Smart-Recruitment-DBMS_Final_Clean/03_Selection_Analytics/` — selection, offer, and hiring analytics.
- `Smart-Recruitment-DBMS_Final_Clean/05_Interview_Management/` — interview scheduling, feedback, conflict checking, documentation, ER diagram, and APEX export.

## Main database features

- Relational tables with primary keys, foreign keys, unique constraints, and check constraints.
- Candidate skill matching and screening queries.
- Selection results, job offers, and hiring reports.
- Interviewer and interview-round management.
- Interview schedules and interviewer feedback.
- Oracle trigger to reject overlapping interview slots for the same interviewer.

## Setup

Open the detailed `README.txt` in `Smart-Recruitment-DBMS_Final_Clean/` for the original database run order. Use Oracle SQL Developer with **Run Script (F5)** for scripts containing PL/SQL blocks and script commands.

For Module 2, follow `Smart-Recruitment-DBMS_Final_Clean/05_Interview_Management/Module2_Documentation.md`. Run `Smart-Recruitment-DBMS_Final_Clean/05_Interview_Management/08_Insert_Interview_Sample_Data.sql` only once after the Module 2 tables and master data exist. The conflict-test script intentionally attempts an invalid overlapping booking and should be run separately.

The APEX export contains the application definition. The database schema and sample data must be set up separately.

Sample candidate and recruitment records are fictional and intended for classroom demonstration.
