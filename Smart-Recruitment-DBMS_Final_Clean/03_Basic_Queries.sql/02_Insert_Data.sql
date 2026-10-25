-- ============================================================
-- MODULE 3: SAMPLE DATA
-- Run once after executing the project table-creation script.
-- Insert order follows the foreign-key dependencies.
-- ============================================================

-- DEPARTMENTS
INSERT INTO Department VALUES ('D001', 'Engineering', 'Chennai');
INSERT INTO Department VALUES ('D002', 'Data Science', 'Bengaluru');
INSERT INTO Department VALUES ('D003', 'Human Resources', 'Chennai');

-- RECRUITERS
INSERT INTO Recruiter VALUES ('R001', 'Ananya Rao', 'ananya.rao@example.com', '9000010001', 'D001');
INSERT INTO Recruiter VALUES ('R002', 'Vikram Shah', 'vikram.shah@example.com', '9000010002', 'D002');
INSERT INTO Recruiter VALUES ('R003', 'Meera Nair', 'meera.nair@example.com', '9000010003', 'D003');

-- JOBS
INSERT INTO Job VALUES
('J001','R001','D001','Software Engineer','Build and maintain recruitment platform services','Chennai','FULL-TIME',600000,1200000,1,DATE '2026-09-01',DATE '2026-12-31','OPEN');
INSERT INTO Job VALUES
('J002','R001','D001','Senior Java Developer','Develop enterprise Java applications','Bengaluru','FULL-TIME',1000000,1800000,3,DATE '2026-09-02',DATE '2026-12-31','OPEN');
INSERT INTO Job VALUES
('J003','R002','D002','Data Analyst','Analyze hiring and business data','Bengaluru','FULL-TIME',700000,1300000,1,DATE '2026-09-03',DATE '2026-12-31','OPEN');
INSERT INTO Job VALUES
('J004','R002','D002','Machine Learning Engineer','Build and deploy machine learning models','Hyderabad','FULL-TIME',1200000,2200000,3,DATE '2026-09-04',DATE '2026-12-31','OPEN');
INSERT INTO Job VALUES
('J005','R003','D003','HR Intern','Support recruitment and candidate communication','Chennai','INTERNSHIP',150000,300000,0,DATE '2026-09-05',DATE '2026-12-31','OPEN');
-- CANDIDATES
INSERT INTO Candidate VALUES
('C001','Aarav','Sharma','aarav@gmail.com','9000000001',
 DATE '2002-05-12','MALE','B.Tech Computer Science',2024,2,'resume/C001.pdf',DATE '2026-09-01');

INSERT INTO Candidate VALUES
('C002','Diya','Nair','diya@gmail.com','9000000002',
 DATE '2001-08-20','FEMALE','B.Tech Information Technology',2023,3,'resume/C002.pdf',DATE '2026-09-02');

INSERT INTO Candidate VALUES
('C003','Rohan','Patel','rohan@gmail.com','9000000003',
 DATE '2002-01-15','MALE','B.Tech Computer Science',2024,1,'resume/C003.pdf',DATE '2026-09-03');

INSERT INTO Candidate VALUES
('C004','Sneha','Iyer','sneha@gmail.com','9000000004',
 DATE '2001-11-10','FEMALE','MCA',2023,2,'resume/C004.pdf',DATE '2026-09-04');

INSERT INTO Candidate VALUES
('C005','Aditya','Menon','aditya@gmail.com','9000000005',
 DATE '2000-03-25','MALE','B.Tech CSE',2022,4,'resume/C005.pdf',DATE '2026-09-05');

INSERT INTO Candidate VALUES
('C006','Ishita','Rao','ishita@gmail.com','9000000006',
 DATE '2002-07-18','FEMALE','B.Tech Data Science',2024,1,'resume/C006.pdf',DATE '2026-09-06');

INSERT INTO Candidate VALUES
('C007','Karan','Joshi','karan@gmail.com','9000000007',
 DATE '1999-12-02','MALE','B.Tech CSE',2021,5,'resume/C007.pdf',DATE '2026-09-07');

INSERT INTO Candidate VALUES
('C008','Megha','Krishnan','megha@gmail.com','9000000008',
 DATE '2001-06-30','FEMALE','MCA',2023,2,'resume/C008.pdf',DATE '2026-09-08');

-- SKILLS
INSERT INTO Skill VALUES ('S001','Java');
INSERT INTO Skill VALUES ('S002','Python');
INSERT INTO Skill VALUES ('S003','SQL');
INSERT INTO Skill VALUES ('S004','Machine Learning');
INSERT INTO Skill VALUES ('S005','HTML');
INSERT INTO Skill VALUES ('S006','CSS');
INSERT INTO Skill VALUES ('S007','JavaScript');
INSERT INTO Skill VALUES ('S008','Data Analysis');
INSERT INTO Skill VALUES ('S009','Git');
INSERT INTO Skill VALUES ('S010','Communication');

-- APPLICATIONS
INSERT INTO Application VALUES
('A001','C001','J001',DATE '2026-09-10',88,'SHORTLISTED','PASS');

INSERT INTO Application VALUES
('A002','C002','J001',DATE '2026-09-11',92,'SHORTLISTED','PASS');

INSERT INTO Application VALUES
('A003','C003','J001',DATE '2026-09-12',68,'REJECTED','FAIL');

INSERT INTO Application VALUES
('A004','C004','J002',DATE '2026-09-12',85,'SHORTLISTED','PASS');

INSERT INTO Application VALUES
('A005','C005','J002',DATE '2026-09-13',95,'SHORTLISTED','PASS');

INSERT INTO Application VALUES
('A006','C006','J003',DATE '2026-09-14',90,'SHORTLISTED','PASS');

INSERT INTO Application VALUES
('A007','C007','J004',DATE '2026-09-15',96,'SHORTLISTED','PASS');

INSERT INTO Application VALUES
('A008','C008','J003',DATE '2026-09-16',75,'APPLIED','PENDING');

INSERT INTO Application VALUES
('A009','C001','J002',DATE '2026-09-17',82,'APPLIED','PENDING');

INSERT INTO Application VALUES
('A010','C005','J004',DATE '2026-09-18',94,'SHORTLISTED','PASS');

-- CANDIDATE SKILLS
INSERT INTO Candidate_Skill VALUES ('C001','S001','ADVANCED');
INSERT INTO Candidate_Skill VALUES ('C001','S003','ADVANCED');
INSERT INTO Candidate_Skill VALUES ('C001','S009','INTERMEDIATE');

INSERT INTO Candidate_Skill VALUES ('C002','S001','ADVANCED');
INSERT INTO Candidate_Skill VALUES ('C002','S003','ADVANCED');
INSERT INTO Candidate_Skill VALUES ('C002','S007','INTERMEDIATE');

INSERT INTO Candidate_Skill VALUES ('C003','S002','INTERMEDIATE');
INSERT INTO Candidate_Skill VALUES ('C003','S003','BEGINNER');

INSERT INTO Candidate_Skill VALUES ('C004','S001','ADVANCED');
INSERT INTO Candidate_Skill VALUES ('C004','S003','INTERMEDIATE');
INSERT INTO Candidate_Skill VALUES ('C004','S009','INTERMEDIATE');

INSERT INTO Candidate_Skill VALUES ('C005','S001','EXPERT');
INSERT INTO Candidate_Skill VALUES ('C005','S003','ADVANCED');
INSERT INTO Candidate_Skill VALUES ('C005','S009','ADVANCED');

INSERT INTO Candidate_Skill VALUES ('C006','S002','ADVANCED');
INSERT INTO Candidate_Skill VALUES ('C006','S008','ADVANCED');
INSERT INTO Candidate_Skill VALUES ('C006','S003','INTERMEDIATE');

INSERT INTO Candidate_Skill VALUES ('C007','S002','EXPERT');
INSERT INTO Candidate_Skill VALUES ('C007','S004','EXPERT');
INSERT INTO Candidate_Skill VALUES ('C007','S003','ADVANCED');

INSERT INTO Candidate_Skill VALUES ('C008','S002','ADVANCED');
INSERT INTO Candidate_Skill VALUES ('C008','S008','INTERMEDIATE');

-- JOB SKILLS
INSERT INTO Job_Skill VALUES ('J001','S001','INTERMEDIATE');
INSERT INTO Job_Skill VALUES ('J001','S003','INTERMEDIATE');
INSERT INTO Job_Skill VALUES ('J001','S009','BEGINNER');

INSERT INTO Job_Skill VALUES ('J002','S001','ADVANCED');
INSERT INTO Job_Skill VALUES ('J002','S003','INTERMEDIATE');
INSERT INTO Job_Skill VALUES ('J002','S009','INTERMEDIATE');

INSERT INTO Job_Skill VALUES ('J003','S002','INTERMEDIATE');
INSERT INTO Job_Skill VALUES ('J003','S003','INTERMEDIATE');
INSERT INTO Job_Skill VALUES ('J003','S008','ADVANCED');

INSERT INTO Job_Skill VALUES ('J004','S002','ADVANCED');
INSERT INTO Job_Skill VALUES ('J004','S004','ADVANCED');
INSERT INTO Job_Skill VALUES ('J004','S003','INTERMEDIATE');

INSERT INTO Job_Skill VALUES ('J005','S010','INTERMEDIATE');

COMMIT;
