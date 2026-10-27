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
1. Existing project table creation script: `03_SQL/code.sql`.
2. Existing sample data script: `03_Basic_Queries.sql/02_Insert_Data.sql`.
3. `06_Interview_Management.sql`.
4. Optional trigger test: `07_Test_Interview_Conflict.sql`.

Use the same Oracle schema for every script. In Oracle SQL Developer, open a `.sql` file and use **Run Script (F5)** because the script contains PL/SQL blocks, slash terminators, and SQL*Plus-style `PROMPT` commands. If the base tables and data are already loaded, do not recreate/reinsert them; run only Module 2.

## Viva summary
- `INTERVIEW_ROUND` stores the interview process for each job; `ROUND_NUMBER` gives the sequence.
- `INTERVIEW` connects an application to a round, interviewer, time slot, mode, and status.
- `INTERVIEW_FEEDBACK` records technical, communication, and problem-solving scores, an overall score, a recommendation, and comments.
- The compound trigger checks time overlaps after the statement completes, avoiding the mutating-table problem associated with querying the same table from a row-level trigger.
- The sample data is fictional and intended for classroom demonstration.

## Important integration note
The current repository's documented base schema has no interview tables. This module therefore adds these four tables without changing the eight existing core tables. Update the final ER diagram and project documentation to show the new Module 2 entities and relationships before submission.
