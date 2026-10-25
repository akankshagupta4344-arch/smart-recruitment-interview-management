CREATE TABLE Department (
    Department_ID VARCHAR2(5) PRIMARY KEY,
    Department_Name VARCHAR2(50) NOT NULL,
    Location VARCHAR2(40) NOT NULL,

    CONSTRAINT UQ_Department_Name
        UNIQUE (Department_Name)
);

CREATE TABLE Recruiter (
    Recruiter_ID VARCHAR2(5) PRIMARY KEY,
    Recruiter_Name VARCHAR2(50) NOT NULL,
    Email VARCHAR2(60) NOT NULL,
    Phone VARCHAR2(15),
    Department_ID VARCHAR2(5) NOT NULL,

    CONSTRAINT UQ_Recruiter_Email
        UNIQUE (Email),

    CONSTRAINT FK_Recruiter_Department
        FOREIGN KEY (Department_ID)
        REFERENCES Department(Department_ID)
);

CREATE TABLE Job (
    Job_ID VARCHAR2(5) PRIMARY KEY,
    Recruiter_ID VARCHAR2(5) NOT NULL,
    Department_ID VARCHAR2(5) NOT NULL,
    Job_Title VARCHAR2(80) NOT NULL,
    Job_Description VARCHAR2(500),
    Location VARCHAR2(50),
    Employment_Type VARCHAR2(20) NOT NULL,
    Salary_Min NUMBER(10,2),
    Salary_Max NUMBER(10,2),
    Experience_Required NUMBER(2) DEFAULT 0,
    Posted_Date DATE DEFAULT SYSDATE,
    Closing_Date DATE,
    Job_Status VARCHAR2(20) DEFAULT 'OPEN',

    CONSTRAINT FK_Job_Recruiter
        FOREIGN KEY (Recruiter_ID)
        REFERENCES Recruiter(Recruiter_ID),

    CONSTRAINT FK_Job_Department
        FOREIGN KEY (Department_ID)
        REFERENCES Department(Department_ID),

    CONSTRAINT CK_Job_Salary
        CHECK (Salary_Max >= Salary_Min),

    CONSTRAINT CK_Job_Status
        CHECK (Job_Status IN ('OPEN', 'CLOSED', 'ON_HOLD')),

    CONSTRAINT CK_Employment_Type
        CHECK (Employment_Type IN ('FULL-TIME', 'PART-TIME', 'CONTRACT', 'INTERNSHIP'))
);

CREATE TABLE Candidate (
    Candidate_ID VARCHAR2(5) PRIMARY KEY,
    First_Name VARCHAR2(30) NOT NULL,
    Last_Name VARCHAR2(30) NOT NULL,
    Email VARCHAR2(60) NOT NULL,
    Phone VARCHAR2(15),
    Date_of_Birth DATE,
    Gender VARCHAR2(10),
    Highest_Qualification VARCHAR2(50),
    Graduation_Year NUMBER(4),
    Years_of_Experience NUMBER(2) DEFAULT 0,
    Resume_Link VARCHAR2(200),
    Registration_Date DATE DEFAULT SYSDATE,

    CONSTRAINT UQ_Candidate_Email
        UNIQUE (Email),

    CONSTRAINT CK_Candidate_Gender
        CHECK (Gender IN ('MALE', 'FEMALE', 'OTHER'))
);

CREATE TABLE Application (
    Application_ID VARCHAR2(5) PRIMARY KEY,
    Candidate_ID VARCHAR2(5) NOT NULL,
    Job_ID VARCHAR2(5) NOT NULL,
    Application_Date DATE DEFAULT SYSDATE,
    Resume_Score NUMBER(5,2),
    Application_Status VARCHAR2(20) DEFAULT 'APPLIED',
    Screening_Result VARCHAR2(20),

    CONSTRAINT FK_Application_Candidate
        FOREIGN KEY (Candidate_ID)
        REFERENCES Candidate(Candidate_ID),

    CONSTRAINT FK_Application_Job
        FOREIGN KEY (Job_ID)
        REFERENCES Job(Job_ID),

    CONSTRAINT CK_Application_Status
        CHECK (Application_Status IN
        ('APPLIED', 'SHORTLISTED', 'REJECTED', 'SELECTED')),

    CONSTRAINT CK_Resume_Score
        CHECK (Resume_Score BETWEEN 0 AND 100),

    CONSTRAINT CK_Screening_Result
        CHECK (Screening_Result IN
        ('PASS', 'FAIL', 'PENDING'))
);

CREATE TABLE Skill (
    Skill_ID VARCHAR2(5) PRIMARY KEY,
    Skill_Name VARCHAR2(50) NOT NULL,

    CONSTRAINT UQ_Skill_Name
        UNIQUE (Skill_Name)
);

CREATE TABLE Candidate_Skill (
    Candidate_ID VARCHAR2(5) NOT NULL,
    Skill_ID VARCHAR2(5) NOT NULL,
    Proficiency VARCHAR2(20),

    CONSTRAINT PK_Candidate_Skill
        PRIMARY KEY (Candidate_ID, Skill_ID),

    CONSTRAINT FK_CS_Candidate
        FOREIGN KEY (Candidate_ID)
        REFERENCES Candidate(Candidate_ID),

    CONSTRAINT FK_CS_Skill
        FOREIGN KEY (Skill_ID)
        REFERENCES Skill(Skill_ID),

    CONSTRAINT CK_CS_Proficiency
        CHECK (Proficiency IN ('BEGINNER', 'INTERMEDIATE', 'ADVANCED', 'EXPERT'))
);

CREATE TABLE Job_Skill (
    Job_ID VARCHAR2(5) NOT NULL,
    Skill_ID VARCHAR2(5) NOT NULL,
    Required_Level VARCHAR2(20),

    CONSTRAINT PK_Job_Skill
        PRIMARY KEY (Job_ID, Skill_ID),

    CONSTRAINT FK_JS_Job
        FOREIGN KEY (Job_ID)
        REFERENCES Job(Job_ID),

    CONSTRAINT FK_JS_Skill
        FOREIGN KEY (Skill_ID)
        REFERENCES Skill(Skill_ID),

    CONSTRAINT CK_JS_Level
        CHECK (Required_Level IN ('BEGINNER', 'INTERMEDIATE', 'ADVANCED', 'EXPERT'))
);

