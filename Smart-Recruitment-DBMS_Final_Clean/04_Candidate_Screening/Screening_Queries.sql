-- ============================================================
-- CANDIDATE SCREENING
-- ============================================================

-- 1. Candidates who passed screening
SELECT C.Candidate_ID,
       C.First_Name || ' ' || C.Last_Name AS Candidate_Name,
       A.Job_ID,
       A.Resume_Score,
       A.Screening_Result
FROM Candidate C
JOIN Application A
ON C.Candidate_ID = A.Candidate_ID
WHERE A.Screening_Result = 'PASS';


-- 2. Candidates with high resume score
SELECT C.Candidate_ID,
       C.First_Name || ' ' || C.Last_Name AS Candidate_Name,
       A.Resume_Score
FROM Candidate C
JOIN Application A
ON C.Candidate_ID = A.Candidate_ID
WHERE A.Resume_Score >= 85
ORDER BY A.Resume_Score DESC;


-- 3. Shortlisted candidates with job details
SELECT C.Candidate_ID,
       C.First_Name || ' ' || C.Last_Name AS Candidate_Name,
       J.Job_Title,
       A.Resume_Score,
       A.Application_Status
FROM Candidate C
JOIN Application A
ON C.Candidate_ID = A.Candidate_ID
JOIN Job J
ON A.Job_ID = J.Job_ID
WHERE A.Application_Status = 'SHORTLISTED'
ORDER BY A.Resume_Score DESC;


-- 4. Candidates with relevant skills for each job
SELECT C.First_Name || ' ' || C.Last_Name AS Candidate_Name,
       J.Job_Title,
       S.Skill_Name,
       CS.Proficiency,
       JS.Required_Level
FROM Candidate C
JOIN Candidate_Skill CS
ON C.Candidate_ID = CS.Candidate_ID
JOIN Skill S
ON CS.Skill_ID = S.Skill_ID
JOIN Job_Skill JS
ON S.Skill_ID = JS.Skill_ID
JOIN Job J
ON JS.Job_ID = J.Job_ID;


-- 5. Top candidates based on resume score
SELECT C.Candidate_ID,
       C.First_Name || ' ' || C.Last_Name AS Candidate_Name,
       A.Resume_Score,
       A.Application_Status
FROM Candidate C
JOIN Application A
ON C.Candidate_ID = A.Candidate_ID
WHERE A.Resume_Score >= 90
ORDER BY A.Resume_Score DESC;

COMMIT;