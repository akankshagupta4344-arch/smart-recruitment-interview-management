-- SMART RECRUITMENT & INTERVIEW MANAGEMENT SYSTEM
-- MODULE 2: INTERVIEW MANAGEMENT (Oracle SQL)
-- Depends on existing tables: APPLICATION, CANDIDATE, JOB.
-- Run 03_SQL/code.sql and 03_Basic_Queries.sql/02_Insert_Data.sql first.
-- Run after the core schema and sample data have been created.
-- Table creation and interviewer/round MERGE data are repeatable.
-- Load interview and feedback rows once from 08_Insert_Interview_Sample_Data.sql.

SET SERVEROUTPUT ON;

PROMPT =====================================================
PROMPT MODULE 2 - CREATE INTERVIEW MANAGEMENT TABLES
PROMPT =====================================================

-- INTERVIEWER: people who conduct interviews.
BEGIN
  EXECUTE IMMEDIATE q'~CREATE TABLE Interviewer (
    Interviewer_ID VARCHAR2(5) PRIMARY KEY,
    Interviewer_Name VARCHAR2(80) NOT NULL,
    Email VARCHAR2(100) NOT NULL UNIQUE,
    Department_ID VARCHAR2(5) REFERENCES Department(Department_ID),
    Job_Title VARCHAR2(60),
    Phone VARCHAR2(20),
    Is_Active CHAR(1) DEFAULT 'Y' NOT NULL CHECK (Is_Active IN ('Y','N'))
  )~';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

-- INTERVIEW_ROUND: reusable definitions of interview stages per job.
BEGIN
  EXECUTE IMMEDIATE q'~CREATE TABLE Interview_Round (
    Round_ID VARCHAR2(5) PRIMARY KEY,
    Job_ID VARCHAR2(5) NOT NULL REFERENCES Job(Job_ID),
    Round_Number NUMBER(2) NOT NULL CHECK (Round_Number > 0),
    Round_Name VARCHAR2(50) NOT NULL,
    Round_Type VARCHAR2(20) DEFAULT 'TECHNICAL' NOT NULL
      CHECK (Round_Type IN ('SCREENING','TECHNICAL','MANAGERIAL','HR','FINAL','OTHER')),
    Duration_Minutes NUMBER(3) DEFAULT 60 NOT NULL CHECK (Duration_Minutes BETWEEN 15 AND 240),
    Is_Mandatory CHAR(1) DEFAULT 'Y' NOT NULL CHECK (Is_Mandatory IN ('Y','N')),
    CONSTRAINT UQ_Interview_Round_Job_Number UNIQUE (Job_ID, Round_Number)
  )~';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

-- INTERVIEW: scheduled interview slot for one application and one round.
BEGIN
  EXECUTE IMMEDIATE q'~CREATE TABLE Interview (
    Interview_ID VARCHAR2(5) PRIMARY KEY,
    Application_ID VARCHAR2(5) NOT NULL REFERENCES Application(Application_ID),
    Round_ID VARCHAR2(5) NOT NULL REFERENCES Interview_Round(Round_ID),
    Interviewer_ID VARCHAR2(5) NOT NULL REFERENCES Interviewer(Interviewer_ID),
    Scheduled_Start TIMESTAMP NOT NULL,
    Scheduled_End TIMESTAMP NOT NULL,
    Interview_Mode VARCHAR2(12) DEFAULT 'ONLINE' NOT NULL
      CHECK (Interview_Mode IN ('ONLINE','IN_PERSON','PHONE')),
    Meeting_Location VARCHAR2(200),
    Interview_Status VARCHAR2(16) DEFAULT 'SCHEDULED' NOT NULL
      CHECK (Interview_Status IN ('SCHEDULED','CONFIRMED','COMPLETED','CANCELLED','NO_SHOW','RESCHEDULED')),
    Created_At TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT CK_Interview_Time CHECK (Scheduled_End > Scheduled_Start)
  )~';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

-- INTERVIEW_FEEDBACK: score and written feedback for a completed interview.
BEGIN
  EXECUTE IMMEDIATE q'~CREATE TABLE Interview_Feedback (
    Feedback_ID VARCHAR2(5) PRIMARY KEY,
    Interview_ID VARCHAR2(5) NOT NULL UNIQUE REFERENCES Interview(Interview_ID),
    Technical_Score NUMBER(3,1) CHECK (Technical_Score BETWEEN 0 AND 10),
    Communication_Score NUMBER(3,1) CHECK (Communication_Score BETWEEN 0 AND 10),
    Problem_Solving_Score NUMBER(3,1) CHECK (Problem_Solving_Score BETWEEN 0 AND 10),
    Overall_Score NUMBER(3,1) CHECK (Overall_Score BETWEEN 0 AND 10),
    Recommendation VARCHAR2(16) NOT NULL
      CHECK (Recommendation IN ('STRONG_HIRE','HIRE','HOLD','REJECT')),
    Comments VARCHAR2(1000),
    Feedback_Date DATE DEFAULT SYSDATE NOT NULL
  )~';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

PROMPT Tables Interviewer, Interview_Round, Interview, Interview_Feedback created or already exist.

-- =====================================================
-- INTERVIEWER AND ROUND MASTER DATA
-- These MERGE statements are repeatable and use IDs from the core sample dataset.
-- =====================================================

MERGE INTO Interviewer t
USING (
  SELECT 'I001' id, 'Kavitha Raman' nm, 'kavitha.raman@example.com' em, 'D001' dept, 'Engineering Manager' jt, '9000020001' ph, 'Y' active FROM dual UNION ALL
  SELECT 'I002', 'Arjun Mehta', 'arjun.mehta@example.com', 'D001', 'Senior Software Engineer', '9000020002', 'Y' FROM dual UNION ALL
  SELECT 'I003', 'Priya Menon', 'priya.menon@example.com', 'D002', 'Data Science Lead', '9000020003', 'Y' FROM dual UNION ALL
  SELECT 'I004', 'Nisha Kapoor', 'nisha.kapoor@example.com', 'D003', 'HR Manager', '9000020004', 'Y' FROM dual
) s ON (t.Interviewer_ID=s.id)
WHEN MATCHED THEN UPDATE SET t.Interviewer_Name=s.nm,t.Email=s.em,t.Department_ID=s.dept,t.Job_Title=s.jt,t.Phone=s.ph,t.Is_Active=s.active
WHEN NOT MATCHED THEN INSERT (Interviewer_ID,Interviewer_Name,Email,Department_ID,Job_Title,Phone,Is_Active)
VALUES (s.id,s.nm,s.em,s.dept,s.jt,s.ph,s.active);

MERGE INTO Interview_Round t
USING (
  SELECT 'RD001' id,'J001' job,1 rn,'Technical Assessment' nm,'TECHNICAL' typ,60 dur,'Y' mandatory FROM dual UNION ALL
  SELECT 'RD002','J001',2,'Technical Panel','TECHNICAL',60,'Y' FROM dual UNION ALL
  SELECT 'RD003','J001',3,'HR Discussion','HR',30,'Y' FROM dual UNION ALL
  SELECT 'RD004','J002',1,'Technical Interview','TECHNICAL',60,'Y' FROM dual UNION ALL
  SELECT 'RD005','J002',2,'Hiring Manager','MANAGERIAL',45,'Y' FROM dual UNION ALL
  SELECT 'RD006','J003',1,'Data Analysis Exercise','TECHNICAL',60,'Y' FROM dual UNION ALL
  SELECT 'RD007','J003',2,'HR Discussion','HR',30,'Y' FROM dual UNION ALL
  SELECT 'RD008','J004',1,'ML Technical Round','TECHNICAL',75,'Y' FROM dual UNION ALL
  SELECT 'RD009','J004',2,'Research & Design Discussion','MANAGERIAL',45,'Y' FROM dual UNION ALL
  SELECT 'RD010','J005',1,'Initial HR Screen','SCREENING',30,'Y' FROM dual
) s ON (t.Round_ID=s.id)
WHEN MATCHED THEN UPDATE SET t.Job_ID=s.job,t.Round_Number=s.rn,t.Round_Name=s.nm,t.Round_Type=s.typ,t.Duration_Minutes=s.dur,t.Is_Mandatory=s.mandatory
WHEN NOT MATCHED THEN INSERT (Round_ID,Job_ID,Round_Number,Round_Name,Round_Type,Duration_Minutes,Is_Mandatory)
VALUES (s.id,s.job,s.rn,s.nm,s.typ,s.dur,s.mandatory);

-- Interview and feedback rows are loaded separately so that
-- 08_Insert_Interview_Sample_Data.sql is the single sample-data source.
COMMIT;

-- =====================================================
-- ADVANCED FEATURE: PREVENT OVERLAPPING INTERVIEWS FOR SAME INTERVIEWER
-- Compound trigger checks conflicts after the statement to avoid mutating-table errors.
-- CANCELLED and NO_SHOW entries do not block a timeslot.
-- =====================================================
CREATE OR REPLACE TRIGGER TRG_NO_INTERVIEWER_OVERLAP
FOR INSERT OR UPDATE OF Interviewer_ID, Scheduled_Start, Scheduled_End, Interview_Status ON Interview
COMPOUND TRIGGER
  TYPE t_slot_rec IS RECORD (
    interview_id Interview.Interview_ID%TYPE,
    interviewer_id Interview.Interviewer_ID%TYPE,
    scheduled_start Interview.Scheduled_Start%TYPE,
    scheduled_end Interview.Scheduled_End%TYPE,
    interview_status Interview.Interview_Status%TYPE
  );
  TYPE t_slot_tab IS TABLE OF t_slot_rec INDEX BY PLS_INTEGER;
  g_slots t_slot_tab;
  g_count PLS_INTEGER := 0;

  AFTER EACH ROW IS
  BEGIN
    g_count := g_count + 1;
    g_slots(g_count).interview_id := :NEW.Interview_ID;
    g_slots(g_count).interviewer_id := :NEW.Interviewer_ID;
    g_slots(g_count).scheduled_start := :NEW.Scheduled_Start;
    g_slots(g_count).scheduled_end := :NEW.Scheduled_End;
    g_slots(g_count).interview_status := :NEW.Interview_Status;
  END AFTER EACH ROW;

  AFTER STATEMENT IS
    l_conflicts PLS_INTEGER;
  BEGIN
    FOR i IN 1 .. g_count LOOP
      IF g_slots(i).interview_status NOT IN ('CANCELLED', 'NO_SHOW') THEN
        SELECT COUNT(*) INTO l_conflicts
        FROM Interview existing_i
        WHERE existing_i.Interviewer_ID = g_slots(i).interviewer_id
          AND existing_i.Interview_ID <> g_slots(i).interview_id
          AND existing_i.Interview_Status NOT IN ('CANCELLED', 'NO_SHOW')
          AND g_slots(i).scheduled_start < existing_i.Scheduled_End
          AND g_slots(i).scheduled_end > existing_i.Scheduled_Start;

        IF l_conflicts > 0 THEN
          RAISE_APPLICATION_ERROR(-20051,
            'Interviewer has an overlapping interview slot: ' || g_slots(i).interview_id);
        END IF;
      END IF;
    END LOOP;
  END AFTER STATEMENT;
END TRG_NO_INTERVIEWER_OVERLAP;
/

-- =====================================================
-- REPORTS / QUERIES FOR MODULE 2
-- =====================================================

PROMPT Q1 - All scheduled interviews with candidate, job, round and interviewer
SELECT I.Interview_ID, A.Application_ID, C.First_Name||' '||C.Last_Name AS Candidate_Name,
       J.Job_Title, R.Round_Number, R.Round_Name,
       I.Interviewer_ID, V.Interviewer_Name,
       I.Scheduled_Start, I.Scheduled_End, I.Interview_Mode, I.Interview_Status
FROM Interview I
JOIN Application A ON A.Application_ID=I.Application_ID
JOIN Candidate C ON C.Candidate_ID=A.Candidate_ID
JOIN Job J ON J.Job_ID=A.Job_ID
JOIN Interview_Round R ON R.Round_ID=I.Round_ID
JOIN Interviewer V ON V.Interviewer_ID=I.Interviewer_ID
ORDER BY I.Scheduled_Start;

PROMPT Q2 - Upcoming interviews (future relative to demo date)
SELECT I.Interview_ID, C.First_Name||' '||C.Last_Name AS Candidate_Name,
       J.Job_Title, R.Round_Name, V.Interviewer_Name, I.Scheduled_Start, I.Interview_Status
FROM Interview I
JOIN Application A ON A.Application_ID=I.Application_ID
JOIN Candidate C ON C.Candidate_ID=A.Candidate_ID
JOIN Job J ON J.Job_ID=A.Job_ID
JOIN Interview_Round R ON R.Round_ID=I.Round_ID
JOIN Interviewer V ON V.Interviewer_ID=I.Interviewer_ID
WHERE I.Interview_Status IN ('SCHEDULED','CONFIRMED')
ORDER BY I.Scheduled_Start;

PROMPT Q3 - Interview counts by interviewer
SELECT V.Interviewer_ID,V.Interviewer_Name,COUNT(I.Interview_ID) AS Total_Interviews,
       SUM(CASE WHEN I.Interview_Status='COMPLETED' THEN 1 ELSE 0 END) AS Completed,
       SUM(CASE WHEN I.Interview_Status='CANCELLED' THEN 1 ELSE 0 END) AS Cancelled
FROM Interviewer V LEFT JOIN Interview I ON I.Interviewer_ID=V.Interviewer_ID
GROUP BY V.Interviewer_ID,V.Interviewer_Name
ORDER BY Total_Interviews DESC,V.Interviewer_Name;

PROMPT Q4 - Feedback and recommendations
SELECT I.Interview_ID,C.First_Name||' '||C.Last_Name AS Candidate_Name,
       J.Job_Title,R.Round_Name,F.Technical_Score,F.Communication_Score,
       F.Problem_Solving_Score,F.Overall_Score,F.Recommendation,F.Comments
FROM Interview_Feedback F
JOIN Interview I ON I.Interview_ID=F.Interview_ID
JOIN Application A ON A.Application_ID=I.Application_ID
JOIN Candidate C ON C.Candidate_ID=A.Candidate_ID
JOIN Job J ON J.Job_ID=A.Job_ID
JOIN Interview_Round R ON R.Round_ID=I.Round_ID
ORDER BY F.Overall_Score DESC;

PROMPT Q5 - Average interview score by job
SELECT J.Job_ID,J.Job_Title,COUNT(F.Feedback_ID) AS Feedback_Count,
       ROUND(AVG(F.Overall_Score),2) AS Average_Interview_Score
FROM Job J
LEFT JOIN Application A ON A.Job_ID=J.Job_ID
LEFT JOIN Interview I ON I.Application_ID=A.Application_ID
LEFT JOIN Interview_Feedback F ON F.Interview_ID=I.Interview_ID
GROUP BY J.Job_ID,J.Job_Title
ORDER BY Average_Interview_Score DESC NULLS LAST;

PROMPT Q6 - Completed interviews without feedback
SELECT I.Interview_ID,I.Application_ID,I.Interviewer_ID,I.Scheduled_Start
FROM Interview I LEFT JOIN Interview_Feedback F ON F.Interview_ID=I.Interview_ID
WHERE I.Interview_Status='COMPLETED' AND F.Feedback_ID IS NULL;

PROMPT Q7 - Round progress for each candidate application
SELECT A.Application_ID,C.First_Name||' '||C.Last_Name AS Candidate_Name,J.Job_Title,
       R.Round_Number,R.Round_Name,I.Interview_Status,I.Scheduled_Start,
       F.Overall_Score,F.Recommendation
FROM Application A
JOIN Candidate C ON C.Candidate_ID=A.Candidate_ID
JOIN Job J ON J.Job_ID=A.Job_ID
JOIN Interview I ON I.Application_ID=A.Application_ID
JOIN Interview_Round R ON R.Round_ID=I.Round_ID
LEFT JOIN Interview_Feedback F ON F.Interview_ID=I.Interview_ID
ORDER BY A.Application_ID,R.Round_Number;

PROMPT Q8 - Interview workload per day
SELECT TRUNC(CAST(Scheduled_Start AS DATE)) AS Interview_Date,COUNT(*) AS Interviews_Scheduled
FROM Interview
WHERE Interview_Status NOT IN ('CANCELLED','NO_SHOW')
GROUP BY TRUNC(CAST(Scheduled_Start AS DATE))
ORDER BY Interview_Date;

-- =====================================================
-- OPTIONAL VIEWS
-- =====================================================
CREATE OR REPLACE VIEW VW_INTERVIEW_SCHEDULE AS
SELECT I.Interview_ID,A.Application_ID,C.Candidate_ID,C.First_Name||' '||C.Last_Name AS Candidate_Name,
       J.Job_ID,J.Job_Title,R.Round_Number,R.Round_Name,V.Interviewer_Name,
       I.Scheduled_Start,I.Scheduled_End,I.Interview_Mode,I.Interview_Status
FROM Interview I JOIN Application A ON A.Application_ID=I.Application_ID
JOIN Candidate C ON C.Candidate_ID=A.Candidate_ID JOIN Job J ON J.Job_ID=A.Job_ID
JOIN Interview_Round R ON R.Round_ID=I.Round_ID JOIN Interviewer V ON V.Interviewer_ID=I.Interviewer_ID;

CREATE OR REPLACE VIEW VW_INTERVIEW_FEEDBACK_SUMMARY AS
SELECT I.Interview_ID,A.Application_ID,C.First_Name||' '||C.Last_Name AS Candidate_Name,
       J.Job_Title,R.Round_Name,F.Overall_Score,F.Recommendation,F.Feedback_Date
FROM Interview_Feedback F JOIN Interview I ON I.Interview_ID=F.Interview_ID
JOIN Application A ON A.Application_ID=I.Application_ID JOIN Candidate C ON C.Candidate_ID=A.Candidate_ID
JOIN Job J ON J.Job_ID=A.Job_ID JOIN Interview_Round R ON R.Round_ID=I.Round_ID;

PROMPT Q9 - Preview schedule view
SELECT * FROM VW_INTERVIEW_SCHEDULE ORDER BY Scheduled_Start;

PROMPT Q10 - Preview feedback view
SELECT * FROM VW_INTERVIEW_FEEDBACK_SUMMARY ORDER BY Feedback_Date;
