-- Module 2 negative test.
-- Run after loading the seven sample interviews.
-- Expected result: ORA-20051 due to an overlapping interviewer slot.
-- This insert should NOT succeed.

INSERT INTO INTERVIEW
(INTERVIEW_ID, APPLICATION_ID, ROUND_ID, INTERVIEWER_ID,
 SCHEDULED_START, SCHEDULED_END, INTERVIEW_MODE,
 INTERVIEW_STATUS, MEETING_LOCATION)
VALUES
('IV008', 'A008', 'RD006', 'I002',
 TIMESTAMP '2026-10-30 09:30:00',
 TIMESTAMP '2026-10-30 10:30:00',
 'ONLINE', 'SCHEDULED', 'Conflict test');
