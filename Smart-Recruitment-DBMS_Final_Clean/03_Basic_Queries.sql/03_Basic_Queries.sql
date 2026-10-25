-- ============================================================
-- BASIC SQL QUERIES
-- SMART RECRUITMENT & INTERVIEW MANAGEMENT SYSTEM
-- ============================================================

-- Q1. Display all candidates
SELECT * FROM Candidate;

-- Q2. Display all open jobs
SELECT Job_ID, Job_Title, Location, Employment_Type, Salary_Min, Salary_Max
FROM Job
WHERE Job_Status = 'OPEN';

-- Q3. Display candidates with more than 2 years experience
SELECT Candidate_ID, First_Name, Last_Name, Years_of_Experience
FROM Candidate
WHERE Years_of_Experience > 2;

-- Q4. Display applications with resume score above 85
SELECT Application_ID, Candidate_ID, Job_ID, Resume_Score, Application_Status
FROM Application
WHERE Resume_Score > 85;

-- Q5. Display shortlisted candidates
SELECT Candidate_ID, Job_ID, Resume_Score
FROM Application
WHERE Application_Status = 'SHORTLISTED';

-- Q6. Display candidates and their skills
SELECT C.Candidate_ID,
       C.First_Name,
       C.Last_Name,
       S.Skill_Name,
       CS.Proficiency
FROM Candidate C
JOIN Candidate_Skill CS
ON C.Candidate_ID = CS.Candidate_ID
JOIN Skill S
ON CS.Skill_ID = S.Skill_ID;

-- Q7. Display jobs and required skills
SELECT J.Job_ID,
       J.Job_Title,
       S.Skill_Name,
       JS.Required_Level
FROM Job J
JOIN Job_Skill JS
ON J.Job_ID = JS.Job_ID
JOIN Skill S
ON JS.Skill_ID = S.Skill_ID;

-- Q8. Display candidate applications with job title
SELECT A.Application_ID,
       C.First_Name || ' ' || C.Last_Name AS Candidate_Name,
       J.Job_Title,
       A.Resume_Score,
       A.Application_Status
FROM Application A
JOIN Candidate C
ON A.Candidate_ID = C.Candidate_ID
JOIN Job J
ON A.Job_ID = J.Job_ID;

-- Q9. Count applications for each job
SELECT J.Job_Title,
       COUNT(A.Application_ID) AS Total_Applications
FROM Job J
LEFT JOIN Application A
ON J.Job_ID = A.Job_ID
GROUP BY J.Job_Title;

-- Q10. Find the highest resume score
SELECT MAX(Resume_Score) AS Highest_Resume_Score
FROM Application;

COMMIT;