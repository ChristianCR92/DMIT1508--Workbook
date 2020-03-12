-- Stored Procedures (Sprocs)
-- File: C - Stored Procedures.sql

USE [A01-School]
GO

-- Take the following queries and turn them into stored procedures.

-- 1.   Selects the studentID's, CourseID and mark where the Mark is between 70 and 80
SELECT  StudentID, CourseId, Mark
FROM    Registration
WHERE   Mark BETWEEN 70 AND 80 -- BETWEEN is inclusive
--      Place this in a stored procedure that has two parameters,
--      one for the upper value and one for the lower value.
--      Call the stored procedure ListStudentMarksByRange


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'ListStudentMarksByRange')
    DROP PROCEDURE ListStudentMarksByRange
GO
CREATE PROCEDURE ListStudentMarksByRange
@StudentID int, 
@CourseId char(7)
AS
        IF @StudentID IS NULL OR @CourseId IS NULL  
      BEGIN
             RAISERROR('All parameters are required',16,1)
   END
    ELSE
    BEGIN
        SELECT R.StudentID,R.CourseId,R.Mark
            FROM Registration AS R
            WHERE StudentID=@StudentID AND CourseId=@CourseId AND Mark BETWEEN 70 AND 80
            END
            RETURN
             GO

EXEC ListStudentMarksByRange 199899200, 'DMIT168'
GO

/* ----------------------------------------------------- */

-- 2.   Selects the Staff full names and the Course ID's they teach.
SELECT  DISTINCT -- The DISTINCT keyword will remove duplate rows from the results
        FirstName + ' ' + LastName AS 'Staff Full Name',
        CourseId
FROM    Staff S
    INNER JOIN Registration R
        ON S.StaffID = R.StaffID
ORDER BY 'Staff Full Name', CourseId
--      Place this in a stored procedure called CourseInstructors.

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'CourseInstructors')
    DROP PROCEDURE CourseInstructors
GO
CREATE PROCEDURE CourseInstructors
AS
        BEGIN 
        SELECT DISTINCT S.FirstName, S.LastName AS 'Staff Full Name',R.CourseId
            FROM Staff as S
                    INNER JOIN Registration AS R ON S.StaffID=R.StaffID
                        ORDER BY 'Staff Full Name',CourseId
        END
        RETURN 
        GO

EXEC CourseInstructors

/* ----------------------------------------------------- */

-- 3.   Selects the students first and last names who have last names starting with S.
SELECT  FirstName, LastName
FROM    Student
WHERE   LastName LIKE 'S%'
--      Place this in a stored procedure called FindStudentByLastName.
--      The parameter should be called @PartialName.
--      Do NOT assume that the '%' is part of the value in the parameter variable;
--      Your solution should concatenate the @PartialName with the wildcard.

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'FindStudentByLastName')
    DROP PROCEDURE FindStudentByLastName
GO
CREATE PROCEDURE FindStudentByLastName
@PartialName char(1)
AS
        IF @PartialName IS NULL
        BEGIN
        RAISERROR('All parameters required',16,1)
        END
        ELSE
        BEGIN
        SELECT FirstName,LastName
        FROM Student
        WHERE LastName LIKE 'S%'
        END
   RETURN
   GO

   EXEC FindStudentByLastName S
   GO

/* ----------------------------------------------------- */

-- 4.   Selects the CourseID's and Coursenames where the CourseName contains the word 'programming'.
SELECT  CourseId, CourseName
FROM    Course
WHERE   CourseName LIKE '%programming%'
--      Place this in a stored procedure called FindCourse.
--      The parameter should be called @PartialName.
--      Do NOT assume that the '%' is part of the value in the parameter variable.


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'FindCourse')
    DROP PROCEDURE FindCourse
GO
CREATE PROCEDURE FindCourse
@PartialName varchar(20)
AS
        IF @PartialName IS NULL
        BEGIN
        RAISERROR('All parameters required',16,1)
        END
        ELSE
        BEGIN 
            SELECT CourseId,CourseName
                FROM Course
                    WHERE CourseName LIKE '%programming%'
         END
        RETURN
        GO

EXEC FindCourse 'programming'
GO
    

/* ----------------------------------------------------- */

-- 5.   Selects the Payment Type Description(s) that have the highest number of Payments made.
SELECT PaymentTypeDescription
FROM   Payment 
    INNER JOIN PaymentType 
        ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
GROUP BY PaymentType.PaymentTypeID, PaymentTypeDescription 
HAVING COUNT(PaymentType.PaymentTypeID) >= ALL (SELECT COUNT(PaymentTypeID)
                                                FROM Payment 
                                                GROUP BY PaymentTypeID)
--      Place this in a stored procedure called MostFrequentPaymentTypes.



IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'MostFrequentPaymentTypes')
    DROP PROCEDURE MostFrequentPaymentTypes
GO
CREATE PROCEDURE MostFrequentPaymentTypes
AS
    BEGIN
    SELECT PaymentTypeDescription
        FROM Payment
            INNER JOIN PaymentType ON Payment.PaymentTypeID=PaymentType.PaymentTypeID
            GROUP BY PaymentType.PaymentTypeID, PaymentTypeDescription
                HAVING COUNT(PaymentType.PaymentTypeID) >= ALL (SELECT COUNT(PaymentTypeID)
                                                                    FROM Payment
                                                                    GROUP  BY PaymentTypeID)
           END
           RETURN 
           GO

EXEC MostFrequentPaymentTypes
GO


/* ----------------------------------------------------- */

-- 6.   Selects the current staff members that are in a particular job position.
SELECT  FirstName + ' ' + LastName AS 'StaffFullName'
FROM    Position P
    INNER JOIN Staff S ON S.PositionID = P.PositionID
WHERE   DateReleased IS NULL
  AND   PositionDescription = 'Instructor'
--      Place this in a stored procedure called StaffByPosition

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'StaffByPosition')
    DROP PROCEDURE StaffByPosition
GO
CREATE PROCEDURE StaffByPosition
AS
    BEGIN
        SELECT S.FirstName + ' '+ S.LastName AS 'StaffFullName'
            FROM Position AS P
                INNER JOIN Staff AS S ON P.PositionID=S.PositionID
            WHERE DateReleased IS NULL
                AND PositionDescription='Instructor'
        END
        RETURN
        GO

EXEC StaffByPosition
GO
/* ----------------------------------------------------- */

-- 7.   Selects the staff members that have taught a particular course (e.g.: 'DMIT101').
SELECT  DISTINCT FirstName + ' ' + LastName AS 'StaffFullName',
        CourseId
FROM    Registration R
    INNER JOIN Staff S ON S.StaffID = R.StaffID
WHERE   DateReleased IS NULL
  AND   CourseId = 'DMIT101'
--      This select should also accommodate inputs with wildcards. (Change = to LIKE)
--      Place this in a stored procedure called StaffByCourseExperience

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'StaffByCourseExperience')
    DROP PROCEDURE StaffByCourseExperience
GO
CREATE PROCEDURE StaffByCourseExperience
AS
    BEGIN
        SELECT DISTINCT S.FirstName + ' '+S.LastName AS 'StaffFullName', R.CourseId 
            FROM Registration AS R
                INNER JOIN Staff AS S On R.StaffID=S.StaffID
                WHERE DateReleased IS NULL 
                    AND CourseId= 'DMIT101'
    END
    RETURN
    GO
   
EXEC StaffByCourseExperience
GO