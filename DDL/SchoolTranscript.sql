/* ********************
* File: SchoolTranscript.sql
*Author: Christian Castro Rodriguez
** CREATE DATABASE SchoolTranscript

***************** */
USE SchoolTranscript
GO
/* === Drop Statements === */
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'StudentCourses')
    DROP TABLE StudentCourses
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Courses')
    DROP TABLE Courses
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Students')
    DROP TABLE Students
/* === Create Tables === */ 
CREATE TABLE Students
(
    StudentID       int
        CONSTRAINT PK_Students_StudentID
            PRIMARY KEY 
            IDENTITY(20200001, 1)   NOT NULL,
    GivenName       varchar(50)     NOT NULL,
    Surname         varchar(50) 
		CONSTRAINT CK_Students_Surname
				CHECK (Surname LIKE '__%')			-- % is a wildcard for zero or more characters(letter, digit, or other character), LIKE allows us to go a "pattern-match of values"
				-- _ is a wildcard for a  single character (letter, digit, or other character)
--				CHECK (Surname LIKE '[a-z] [a-z]%')				-- two letters plus any other chars , [] are used to represent a range or set of characters that are allowed
									NOT NULL,
    DateOfBirth     datetime        
			CONSTRAINT CK_Students_DateOfBirth
					CHECK (DateOfBirth < GETDATE())
									NOT NULL,
    Enrolled        bit             
        CONSTRAINT DF_Students_Enrolled
            DEFAULT(1)              NOT NULL
)

CREATE TABLE Courses
(
    Number          varchar(10) 
        CONSTRAINT PK_Courses_Number
            PRIMARY KEY              NOT NULL,
    [Name]           varchar(50)     NOT NULL,
    Credits          decimal(3,1)  
		CONSTRAINT CK_Courses_Credits
			CHECK (Credits > 0 AND Credits <=6)
								     NOT NULL,
	[Hours] tinyint								
    CONSTRAINT CK_Courses_HOurs
		CHECK ([Hours] BETWEEN 15 and 180) -- BETWEEN Operator is inclusive
--		CHECK [Hours] >=15 and [Hours] <=180	                  
									 NOT NULL,
    Active           bit             
        CONSTRAINT DF_Courses_Active
            DEFAULT(1)               NOT NULL,
    Cost             money
	CONSTRAINT Cost 
	 CHECK (Cost >=0)	             NOT NULL
) 

CREATE TABLE StudentCourses
(
    StudentID       int   
        CONSTRAINT FK_StudentCourses_StudentID_Students_StudentID
        FOREIGN KEY REFERENCES Students(StudentID)           
                                     NOT NULL,
    CourseNumber    varchar(10)  
    CONSTRAINT FK_StudentCourses_CourseNumber_Courses_Number
    FOREIGN KEY REFERENCES Courses(Number)
                                     NOT NULL,
    [Year]          tinyint          NOT NULL,
    Term            char(3)          NOT NULL,
    FinalMark       tinyint              NULL,
    [Status]        char(1)      
		CONSTRAINT CK_StudentCourses_Status
			CHECK([Status] = 'E'		 OR 
				  [Status] = 'C'		 OR
				  [Status] = 'W')
--		CHECK ([Status] IN ('E','C','W'))	 -- just another way to do the checking			  
								    NOT NULL,
    -- Table-level constraint for composite keys
    CONSTRAINT PK_StudentCourses_StudentID_CourseNumber
    PRIMARY KEY(StudentID, CourseNumber),
	-- Table- level constraint involving more than one column
	CONSTRAINT CK_StudentCourses_FinalMark_Status
	CHECK (([Status]='C' AND FinalMark is NOT NULL)
		OR
		([Status] IN ('E', 'W')AND FinalMark IS NULL))
) 

/* ------- Indexes ------------ */
-- For all foreign keys
CREATE NONCLUSTERED INDEX IX_StudentCourses_StudentID
	ON StudentCourses (StudentID)


CREATE NONCLUSTERED INDEX IX_StudentCourses_CourseNumber
	ON StudentCourses (CourseNumber)

-- For other columns where searching/sorting might be important

/* --------- ALTER TABLE statements -------------- */ 

ALTER TABLE Students
	ADD PostalCode char(6) NULL
	-- Adding this as a mullable column,because students already exist, and we don't have postal codes for those students.
	GO -- I have to break the above code as a separate batch from the following code 
	--2)make sure the PostalCode follows the correct Pater A#A#A#

ALTER TABLE Students
	ADD CONSTRAINT CK_Students_PostalCode
		CHECK (PostalCode LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]')
			--Match for			  T	   4    R    1    H    2
