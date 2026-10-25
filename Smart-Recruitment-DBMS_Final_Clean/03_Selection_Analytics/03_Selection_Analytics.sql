-- MODULE 3: SELECTION & ANALYTICS
-- Run after the project schema and sample data scripts.
-- Adds selection decision and offer/hiring records, then generates reports.

BEGIN
  EXECUTE IMMEDIATE q'~CREATE TABLE Selection_Result (
    Application_ID VARCHAR2(5) PRIMARY KEY REFERENCES Application(Application_ID),
    Decision VARCHAR2(12) NOT NULL CHECK (Decision IN ('SELECTED','REJECTED')),
    Decision_Date DATE DEFAULT SYSDATE NOT NULL,
    Final_Score NUMBER(5,2), Remarks VARCHAR2(200), Rejection_Reason VARCHAR2(200)
  )~';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE q'~CREATE TABLE Job_Offer (
    Offer_ID VARCHAR2(5) PRIMARY KEY,
    Application_ID VARCHAR2(5) NOT NULL UNIQUE REFERENCES Selection_Result(Application_ID),
    Offered_Salary NUMBER(12,2) NOT NULL CHECK (Offered_Salary > 0),
    Offer_Date DATE NOT NULL,
    Offer_Status VARCHAR2(12) DEFAULT 'PENDING' NOT NULL CHECK (Offer_Status IN ('PENDING','ACCEPTED','DECLINED')),
    Response_Date DATE, Hire_Date DATE, Joining_Status VARCHAR2(16) DEFAULT 'PENDING' NOT NULL, Joining_Date DATE
  )~';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

-- Add columns safely when upgrading a database created with an earlier version.
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE Selection_Result ADD (Rejection_Reason VARCHAR2(200))';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE Job_Offer ADD (Joining_Status VARCHAR2(16) DEFAULT ''PENDING'' NOT NULL)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE Job_Offer ADD (Joining_Date DATE)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;
END;
/

-- Use the sample set to demonstrate decisions, offers, and one hire.
UPDATE Application SET Application_Status='SELECTED' WHERE Application_ID IN ('A002','A005','A007');
MERGE INTO Selection_Result S USING (
  SELECT Application_ID,
         CASE WHEN Application_Status='SELECTED' THEN 'SELECTED' ELSE 'REJECTED' END Decision,
         Resume_Score Final_Score
  FROM Application WHERE Application_Status IN ('SELECTED','REJECTED')
) X ON (S.Application_ID=X.Application_ID)
WHEN MATCHED THEN UPDATE SET S.Decision=X.Decision, S.Final_Score=X.Final_Score
WHEN NOT MATCHED THEN INSERT (Application_ID,Decision,Decision_Date,Final_Score,Remarks)
 VALUES (X.Application_ID,X.Decision,DATE '2026-10-01',X.Final_Score,'Recorded from final selection review');
MERGE INTO Job_Offer O USING (
 SELECT 'O001' Offer_ID,'A002' Application_ID,1100000 Salary,DATE '2026-10-02' Offer_Date,'ACCEPTED' Status,DATE '2026-10-05' Response_Date,DATE '2026-10-18' Hire_Date FROM DUAL
 UNION ALL SELECT 'O002','A005',1500000,DATE '2026-10-03','PENDING',CAST(NULL AS DATE),CAST(NULL AS DATE) FROM DUAL
 UNION ALL SELECT 'O003','A007',1800000,DATE '2026-10-04','DECLINED',DATE '2026-10-07',CAST(NULL AS DATE) FROM DUAL
) X ON (O.Application_ID=X.Application_ID)
WHEN MATCHED THEN UPDATE SET O.Offered_Salary=X.Salary,O.Offer_Date=X.Offer_Date,O.Offer_Status=X.Status,O.Response_Date=X.Response_Date,O.Hire_Date=X.Hire_Date
WHEN NOT MATCHED THEN INSERT (Offer_ID,Application_ID,Offered_Salary,Offer_Date,Offer_Status,Response_Date,Hire_Date)
 VALUES (X.Offer_ID,X.Application_ID,X.Salary,X.Offer_Date,X.Status,X.Response_Date,X.Hire_Date);
UPDATE Selection_Result SET Rejection_Reason='Resume score below the screening threshold'
WHERE Decision='REJECTED' AND Final_Score<70;
UPDATE Selection_Result SET Rejection_Reason='Not selected after comparative review'
WHERE Decision='REJECTED' AND Rejection_Reason IS NULL;
UPDATE Job_Offer SET Joining_Status='JOINED',Joining_Date=DATE '2026-10-20' WHERE Offer_Status='ACCEPTED';
UPDATE Job_Offer SET Joining_Status='PENDING',Joining_Date=NULL WHERE Offer_Status='PENDING';
UPDATE Job_Offer SET Joining_Status='NOT_APPLICABLE',Joining_Date=NULL WHERE Offer_Status='DECLINED';
COMMIT;

CREATE OR REPLACE VIEW VW_RECRUITMENT_PIPELINE AS
SELECT J.Job_ID,J.Job_Title,COUNT(A.Application_ID) Total_Applications,
 SUM(CASE WHEN A.Application_Status='SHORTLISTED' THEN 1 ELSE 0 END) Shortlisted,
 SUM(CASE WHEN A.Application_Status='SELECTED' THEN 1 ELSE 0 END) Selected,
 SUM(CASE WHEN A.Application_Status='REJECTED' THEN 1 ELSE 0 END) Rejected,
 ROUND(AVG(A.Resume_Score),2) Average_Resume_Score
FROM Job J LEFT JOIN Application A ON A.Job_ID=J.Job_ID
GROUP BY J.Job_ID,J.Job_Title;

CREATE OR REPLACE VIEW VW_RECRUITMENT_STATUS AS
SELECT Application_Status,COUNT(*) Application_Count FROM Application GROUP BY Application_Status;

CREATE OR REPLACE VIEW VW_SCREENING_SUMMARY AS
SELECT Screening_Result,COUNT(*) Application_Count FROM Application GROUP BY Screening_Result;

CREATE OR REPLACE VIEW VW_OFFER_HIRING_SUMMARY AS
SELECT O.Offer_ID,O.Application_ID,C.Candidate_ID,C.First_Name||' '||C.Last_Name Candidate_Name,
 J.Job_ID,J.Job_Title,O.Offered_Salary,O.Offer_Date,O.Offer_Status,O.Response_Date,O.Hire_Date,O.Joining_Status,O.Joining_Date
FROM Job_Offer O JOIN Application A ON A.Application_ID=O.Application_ID
JOIN Candidate C ON C.Candidate_ID=A.Candidate_ID JOIN Job J ON J.Job_ID=A.Job_ID;

-- Q1 Selection results.
SELECT SR.Application_ID,C.First_Name||' '||C.Last_Name Candidate_Name,J.Job_Title,SR.Decision,SR.Final_Score,SR.Decision_Date,SR.Remarks
FROM Selection_Result SR JOIN Application A ON A.Application_ID=SR.Application_ID
JOIN Candidate C ON C.Candidate_ID=A.Candidate_ID JOIN Job J ON J.Job_ID=A.Job_ID
ORDER BY SR.Decision,SR.Final_Score DESC;

-- Q2 Offers and hiring outcomes.
SELECT O.Offer_ID,C.First_Name||' '||C.Last_Name Candidate_Name,J.Job_Title,O.Offered_Salary,O.Offer_Status,O.Offer_Date,O.Response_Date,O.Hire_Date
FROM Job_Offer O JOIN Application A ON A.Application_ID=O.Application_ID
JOIN Candidate C ON C.Candidate_ID=A.Candidate_ID JOIN Job J ON J.Job_ID=A.Job_ID
ORDER BY O.Offer_Date;

-- Q3 Hiring report with recruiter and department.
SELECT O.Hire_Date,C.First_Name||' '||C.Last_Name Candidate_Name,J.Job_Title,D.Department_Name,R.Recruiter_Name,O.Offered_Salary
FROM Job_Offer O JOIN Application A ON A.Application_ID=O.Application_ID
JOIN Candidate C ON C.Candidate_ID=A.Candidate_ID JOIN Job J ON J.Job_ID=A.Job_ID
JOIN Department D ON D.Department_ID=J.Department_ID JOIN Recruiter R ON R.Recruiter_ID=J.Recruiter_ID
WHERE O.Offer_Status='ACCEPTED' ORDER BY O.Hire_Date;

-- Q4 Offer acceptance report by job.
SELECT J.Job_ID,J.Job_Title,COUNT(O.Offer_ID) Offers_Made,
 SUM(CASE WHEN O.Offer_Status='ACCEPTED' THEN 1 ELSE 0 END) Accepted,
 SUM(CASE WHEN O.Offer_Status='PENDING' THEN 1 ELSE 0 END) Pending,
 SUM(CASE WHEN O.Offer_Status='DECLINED' THEN 1 ELSE 0 END) Declined,
 ROUND(100*SUM(CASE WHEN O.Offer_Status='ACCEPTED' THEN 1 ELSE 0 END)/NULLIF(COUNT(O.Offer_ID),0),2) Acceptance_Percent
FROM Job J LEFT JOIN Application A ON A.Job_ID=J.Job_ID LEFT JOIN Job_Offer O ON O.Application_ID=A.Application_ID
GROUP BY J.Job_ID,J.Job_Title ORDER BY Offers_Made DESC,J.Job_ID;

-- Q5 Department hiring and average accepted salary.
SELECT D.Department_Name,COUNT(CASE WHEN O.Offer_Status='ACCEPTED' THEN O.Offer_ID END) Hires,
 ROUND(AVG(CASE WHEN O.Offer_Status='ACCEPTED' THEN O.Offered_Salary END),2) Average_Hire_Salary
FROM Department D LEFT JOIN Job J ON J.Department_ID=D.Department_ID
LEFT JOIN Application A ON A.Job_ID=J.Job_ID LEFT JOIN Job_Offer O ON O.Application_ID=A.Application_ID
GROUP BY D.Department_Name ORDER BY Hires DESC,D.Department_Name;

-- Q6 Advanced: rank selected candidates per job.
SELECT Job_ID,Job_Title,Candidate_Name,Final_Score,DENSE_RANK() OVER(PARTITION BY Job_ID ORDER BY Final_Score DESC) Selection_Rank
FROM (SELECT J.Job_ID,J.Job_Title,C.First_Name||' '||C.Last_Name Candidate_Name,SR.Final_Score
 FROM Selection_Result SR JOIN Application A ON A.Application_ID=SR.Application_ID
 JOIN Candidate C ON C.Candidate_ID=A.Candidate_ID JOIN Job J ON J.Job_ID=A.Job_ID WHERE SR.Decision='SELECTED')
ORDER BY Job_ID,Selection_Rank;

-- Q7 Advanced: cumulative offer value over time.
SELECT Offer_ID,Offer_Date,Offered_Salary,Offer_Status,
 SUM(Offered_Salary) OVER(ORDER BY Offer_Date,Offer_ID ROWS UNBOUNDED PRECEDING) Cumulative_Offer_Value
FROM Job_Offer ORDER BY Offer_Date,Offer_ID;

-- Q8 Advanced: shortlisted candidates missing required skills.
SELECT A.Application_ID,C.First_Name||' '||C.Last_Name Candidate_Name,J.Job_Title,COUNT(JS.Skill_ID) Missing_Skills
FROM Application A JOIN Candidate C ON C.Candidate_ID=A.Candidate_ID JOIN Job J ON J.Job_ID=A.Job_ID
JOIN Job_Skill JS ON JS.Job_ID=J.Job_ID LEFT JOIN Candidate_Skill CS ON CS.Candidate_ID=C.Candidate_ID AND CS.Skill_ID=JS.Skill_ID
WHERE A.Application_Status='SHORTLISTED' AND CS.Skill_ID IS NULL
GROUP BY A.Application_ID,C.First_Name,C.Last_Name,J.Job_Title ORDER BY Missing_Skills DESC;
-- Q9 Total number of applications and application status counts.
SELECT COUNT(*) Total_Applications FROM Application;
SELECT Application_Status,COUNT(*) Application_Count FROM Application
GROUP BY Application_Status ORDER BY Application_Status;

-- Q10 Shortlisted and rejected candidate/application details.
SELECT A.Application_ID,C.Candidate_ID,C.First_Name||' '||C.Last_Name Candidate_Name,
       J.Job_Title,A.Application_Status,SR.Rejection_Reason
FROM Application A JOIN Candidate C ON C.Candidate_ID=A.Candidate_ID
JOIN Job J ON J.Job_ID=A.Job_ID LEFT JOIN Selection_Result SR ON SR.Application_ID=A.Application_ID
WHERE A.Application_Status IN ('SHORTLISTED','REJECTED')
ORDER BY A.Application_Status,J.Job_Title,C.Last_Name;

-- Q11 Applications per job, including jobs with zero applications.
SELECT J.Job_ID,J.Job_Title,COUNT(A.Application_ID) Application_Count
FROM Job J LEFT JOIN Application A ON A.Job_ID=J.Job_ID
GROUP BY J.Job_ID,J.Job_Title ORDER BY Application_Count DESC,J.Job_ID;

-- Q12 Average resume score per job, including jobs with zero scored applications.
SELECT J.Job_ID,J.Job_Title,COUNT(A.Resume_Score) Scored_Applications,
       ROUND(AVG(A.Resume_Score),2) Average_Resume_Score
FROM Job J LEFT JOIN Application A ON A.Job_ID=J.Job_ID
GROUP BY J.Job_ID,J.Job_Title ORDER BY Average_Resume_Score DESC NULLS LAST,J.Job_ID;

-- Q13 Screening pass/fail/pending statistics.
SELECT Screening_Result,COUNT(*) Application_Count
FROM Application GROUP BY Screening_Result ORDER BY Screening_Result;

-- Q14 Top scoring candidates across all jobs.
SELECT Candidate_ID,Candidate_Name,Job_Title,Resume_Score,Score_Rank
FROM (SELECT C.Candidate_ID,C.First_Name||' '||C.Last_Name Candidate_Name,J.Job_Title,A.Resume_Score,
             DENSE_RANK() OVER(ORDER BY A.Resume_Score DESC) Score_Rank
      FROM Application A JOIN Candidate C ON C.Candidate_ID=A.Candidate_ID
      JOIN Job J ON J.Job_ID=A.Job_ID WHERE A.Resume_Score IS NOT NULL)
WHERE Score_Rank<=5 ORDER BY Score_Rank,Candidate_ID;

-- Q15 Rejection summary by reason.
SELECT COALESCE(SR.Rejection_Reason,'Reason not recorded') Rejection_Reason,COUNT(*) Rejected_Applications
FROM Selection_Result SR WHERE SR.Decision='REJECTED'
GROUP BY COALESCE(SR.Rejection_Reason,'Reason not recorded') ORDER BY Rejected_Applications DESC;

-- Q16 Joining report for accepted hires.
SELECT Candidate_Name,Job_Title,Offered_Salary,Hire_Date,Joining_Status,Joining_Date
FROM VW_OFFER_HIRING_SUMMARY WHERE Offer_Status='ACCEPTED' ORDER BY Joining_Date;
