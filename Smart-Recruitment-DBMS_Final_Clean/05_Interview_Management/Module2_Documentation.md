# Module 2 — Interview Management

## Scope
This module extends the existing Smart Recruitment & Interview Management System with interview scheduling, interviewer management, interview rounds, and interviewer feedback. It reuses the existing `APPLICATION`, `CANDIDATE`, `JOB`, and `DEPARTMENT` tables.

## Tables

| Table | Purpose | Primary key | Main relationships |
|---|---|---|---|
| `INTERVIEWER` | Interview panel members | `INTERVIEWER_ID` | Optional department FK to `DEPARTMENT` |
| `INTERVIEW_ROUND` | Defines per-job interview stages and order | `ROUND_ID` | `JOB_ID` references `JOB`; unique `(JOB_ID, ROUND_NUMBER)` |
| `INTERVIEW` | Candidate interview appointments and status | `INTERVIEW_ID` | References `APPLICATION`, `INTERVIEW_ROUND`, and `INTERVIEWER` |
| `INTERVIEW_FEEDBACK` | Scores, recommendation, written feedback | `FEEDBACK_ID` | One feedback record per interview via unique `INTERVIEW_ID` |

## Main constraints and database operations
- Primary keys and foreign keys ensure record identity and relationship integrity.
- `CHECK` constraints restrict valid interview types, states, score ranges, and round lengths.
- `UNIQUE` constraints prevent duplicate interviewer email, duplicate round numbers within a job, and multiple feedback rows for the same interview.
- `TRG_NO_INTERVIEWER_OVERLAP` is an Oracle compound trigger that rejects overlapping non-cancelled/non-no-show slots for a single interviewer.
- `MERGE` is used for repeatable demo data. `COMMIT` persists sample rows.
- Views `VW_INTERVIEW_SCHEDULE` and `VW_INTERVIEW_FEEDBACK_SUMMARY` simplify reports.

## Reports included
1. Full interview schedule joined to candidate, job, round, and interviewer.
2. Scheduled/confirmed interviews.
3. Interviewer workload with completed/cancelled counts.
4. Feedback scores and recommendations.
5. Average interview score by job.
6. Completed interviews without feedback.
7. Round-by-round application progress.
8. Interview workload by date.
9. Preview of the schedule view.
10. Preview of the feedback view.

## Run order

1. Run `03_SQL/code.sql` to create the original eight core tables.
2. Run `03_Basic_Queries.sql/02_Insert_Data.sql` to load the core sample data.
3. Run the original basic-query, candidate-screening, and selection-analytics scripts as described in the root package README.
4. Run `06_Interview_Management.sql` in the same schema. It creates the Module 2 tables if absent, merges interviewer and round master data, creates the overlap-prevention trigger, and defines the reporting views.
5. Run `08_Insert_Interview_Sample_Data.sql` once to add the seven interview records and four feedback records. Do not rerun this insert script against populated Module 2 data.
6. Run `07_Test_Interview_Conflict.sql` separately to test overlap prevention. The expected result is `ORA-20051`; the attempted insert should be rejected.

Use SQL Developer **Run Script (F5)** for the scripts containing PL/SQL blocks, `/` terminators, or `PROMPT` commands. Use the same Oracle schema for all scripts.
## Viva summary
- `INTERVIEW_ROUND` stores the interview process for each job; `ROUND_NUMBER` gives the sequence.
- `INTERVIEW` connects an application to a round, interviewer, time slot, mode, and status.
- `INTERVIEW_FEEDBACK` records technical, communication, and problem-solving scores, an overall score, a recommendation, and comments.
- The compound trigger checks time overlaps after the statement completes, avoiding the mutating-table problem associated with querying the same table from a row-level trigger.
- The sample data is fictional and intended for classroom demonstration.

## Integration note

The original project schema contains eight core tables. Module 2 adds `INTERVIEWER`, `INTERVIEW_ROUND`, `INTERVIEW`, and `INTERVIEW_FEEDBACK`, linked to the existing department, job, and application data. The Module 2 ER diagram is included in this folder; the original project ER diagram remains unchanged.
