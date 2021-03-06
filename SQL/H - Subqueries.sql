--Subquery Exercise
--Use the IQSchool database for this exercise. Each question must use a subquery in its solution.
--**If the questions could also be solved without a subquery, solve it without one as well**
USE [A01-School]
GO

--1. Select the Payment dates and payment amount for all payments that were Cash
SELECT PaymentDate, Amount
FROM   Payment
WHERE  PaymentTypeID =                                               -- Using the = means that the RH side must be a single value
                                                                     -- Assuming that every PaymentTypeDescription will be UNIQUE,
                                                                     -- the following subquery will return a single column and a single row
    (SELECT PaymentTypeID
     FROM   PaymentType
     WHERE  PaymentTypeDescription = 'cash')

-- Here is the Inner Join version of the above
SELECT PaymentDate, Amount
FROM   Payment P
    INNER JOIN PaymentType AS PT
            ON PT.PaymentTypeID = P.PaymentTypeID
WHERE  PaymentTypeDescription = 'cash'


--2. Select The Student ID's of all the students that are in the 'Association of Computing Machinery' club
-- TODO: Student Answer Here

SELECT StudentID
FROM Activity 
WHERE ClubId =(SELECT ClubId FROM  Club
                WHERE  ClubName='Association of Computing Machinery')

-- 2.b. Select the names of all the students in the 'Association of Computing Machinery' club. Use a subquery for your answer. When you make your answer, ensure the outmost query only uses the Student table in its FROM clause.
SELECT S.FirstName + ' '+ S.LastName AS 'Student Name'
FROM Student as S
WHERE StudentID IN ( SELECT StudentID FROM Activity
                    WHERE ClubId=(SELECT ClubID FROM Club
                    WHERE ClubName=
                    'Association of Computing Machinery'))


--JOIN 
            SELECT FirstName, + ' ' + LastName AS 'Student Name'
            from Student AS S
                INNER JOIN Activity AS A ON S.StudentID=A.StudentID
                        INNER JOIN Club as C ON A.ClubId=C.ClubId
                        WHERE ClubName='Association of Computing Machinery'






--3. Select All the staff full names for staff that have taught a course.
SELECT FirstName + ' ' + LastName AS 'Staff'
FROM   Staff
WHERE  StaffID IN -- I used IN because the subquery returns many rows
    (SELECT DISTINCT StaffID FROM Registration)

-- The above can also be done as an INNER JOIN...
SELECT DISTINCT FirstName + ' ' + LastName AS 'Staff'
FROM Staff
    INNER JOIN Registration
        ON Staff.StaffID = Registration.StaffID 


--4. Select All the staff full names that taught DMIT172.
-- TODO: Student Answer Here
SELECT S.FirstName + ' '+S.LastName AS 'Staff Name'  
FROM Staff AS S
WHERE StaffID IN
 (SELECT DISTINCT StaffID FROM Registration WHERE CourseId = 'DMIT172')


--4.b Who has taught DMIT101
SELECT FirstName+ ' '+LastName AS 'Staff'
FROM Staff
WHERE StaffID IN 
(SELECT DISTINCT StaffID FROM Registration WHERE CourseId='DMIT101')

--5. Select All the staff full names of staff that have never taught a course
SELECT FirstName + ' ' + LastName AS 'Staff'
FROM   Staff
WHERE  StaffID NOT IN -- I used IN because the subquery returns many rows
    (SELECT DISTINCT StaffID FROM Registration)

-- To do the above questions with a JOIN requires that we use an OUTER JOIN...
SELECT FirstName + ' ' + LastName AS 'Staff'
FROM   Staff
    LEFT OUTER JOIN Registration
        ON Staff.StaffID = Registration.StaffID
WHERE Registration.StaffID IS NULL

--6. Select the Payment TypeID(s) that have the highest number of Payments made.
-- Explore the counts of payment types, before we try the subquery
SELECT  PaymentTypeID, COUNT(PaymentTypeID) AS 'How many times'
FROM    Payment
GROUP BY PaymentTypeID

-- To get the payment type IDs whose count is greater than or equal to all the others
-- (i.e.: whose count is the highest)
SELECT  PaymentTypeID
FROM    Payment
GROUP BY PaymentTypeID
HAVING COUNT(PaymentTypeID)  >= ALL (SELECT COUNT(PaymentTypeID)
                                     FROM Payment 
                                     GROUP BY PaymentTypeID)

--7. Select the Payment Type Description(s) that have the highest number of Payments made.
SELECT PaymentTypeDescription
FROM   Payment 
    INNER JOIN PaymentType 
        ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
GROUP BY PaymentType.PaymentTypeID, PaymentTypeDescription 
HAVING COUNT(PaymentType.PaymentTypeID) >= ALL (SELECT COUNT(PaymentTypeID)
                                                FROM Payment 
                                                GROUP BY PaymentTypeID)
--   Examining the solution:
--   - First, take a look at the results of the subquery by itself - this gives us
--     the counts and we can visually see what the highest value is
                                               (SELECT COUNT(PaymentTypeID)
                                                FROM Payment 
                                                GROUP BY PaymentTypeID)
--   - Second, take a look at the outer query, but leave out the filtering of aggregates.
--     Also, display the count that is used in the HAVING clause. This should give you
--     an idea of what the right answers should be.
SELECT PaymentTypeDescription
       , COUNT(PaymentType.PaymentTypeID)
FROM   Payment 
    INNER JOIN PaymentType 
        ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
GROUP BY PaymentType.PaymentTypeID, PaymentTypeDescription 

--8. What is the total avg mark for the students from Edm?
SELECT AVG(Mark) AS 'Average'
FROM   Registration 
WHERE  StudentID IN (SELECT StudentID FROM Student WHERE City = 'Edm')

-- The above results, done as a JOIN instead of a subquery
SELECT AVG(Mark) AS 'Average'
FROM   Registration 
    INNER JOIN Student
        ON Registration.StudentID = Student.StudentID
WHERE City = 'Edm'

-- 9. What is the avg mark for each of the students from Edm? Display their StudentID and avg(mark)
-- TODO: Student Answer Here...

SELECT AVG(Mark) AS 'Average',StudentID
FROM Registration
WHERE StudentID IN (SELECT StudentID FROM Student WHERE City = 'Edm')
GROUP BY StudentID

-- 10. Which student(s) have the highest average mark? Hint - This can only be done by a subquery.
-- TODO: Student Answer Here...
--DOUBLE READ Subqueries content
SELECT StudentID
FROM Registration
GROUP BY StudentID
HAVING AVG(Mark) >= ALL -- A number can't be " GREATER THAN or EQUAL TO' a NULL value
        (SELECT AVG(Mark) AS 'Highest Average mark'
        FROM Registration
        WHERE Mark IS NOT NULL -- Ah, tricky!
        GROUP BY StudentID)


-- 11. Which course(s) allow the largest classes? Show the course id, name, and max class size.
-- TODO: Student Answer Here...
SELECT CourseId
FROM Course
group by courseid

SELECT CourseId,CourseName,MaxStudents AS 'Largest class'
FROM Course
GROUP BY CourseId,CourseName,MaxStudents
HAVING MAX(MaxStudents) >= ALL
                  (SELECT MAX(MaxStudents) 
                   FROM Course)

                   -- DAN CODING--
SELECT  CourseId, CourseName, MaxStudents
FROM    Course
WHERE   MaxStudents >= ALL (SELECT MaxStudents FROM Course)
                   
        --- THINK ABOUT THE SUBQUERY FIRST , THEN APPLY THE SUBQUERY TO THE LARGER QUERY, THEN APPLY THE AGGREGATION 



-- 12. Which course(s) are the most affordable? Show the course name and cost.
-- TODO: Student Answer Here...


SELECT CourseName,CourseCost AS 'Most affordable course(s)'
FROM Course
GROUP BY CourseName,CourseCost
    HAVING MIN(CourseCost)<= ALL
                    (SELECT MIN (CourseCost) 
                    FROM Course)
-- DAN CODING--
SELECT  CourseName, CourseCost
FROM    Course
WHERE   CourseCost <= ALL (SELECT CourseCost FROM Course)

-- 13. Which staff have taught the largest classes? (Be sure to group registrations by course and semester.)
-- TODO: Student Answer Here...
  
SELECT DISTINCT S.FirstName + ' '+ S.LastName AS 'Staff Name',CourseId,COUNT(CourseId)
FROM Staff AS S
        INNER JOIN Registration AS R ON S.StaffID=R.StaffID
        GROUP BY S.FirstName+ ' '+ S.LastName,CourseId
HAVING COUNT(CourseId) >= ALL (SELECT COUNT(CourseId)
                                FROM Registration
                                Group by StaffID,CourseId)

-- DAN CODING--

SELECT  DISTINCT FirstName + ' ' + LastName AS 'StaffName'
        , CourseId
        , COUNT(CourseId)
FROM    Staff AS S
    INNER JOIN Registration AS R
        ON S.StaffID = R.StaffID
GROUP BY FirstName + ' ' + LastName, CourseId
HAVING  COUNT(CourseId) >= ALL (SELECT COUNT(CourseId)
                                FROM   Registration
                                GROUP BY StaffID, CourseId)

-- use HAVING when filtering by an aggregate function, anything else, use WHERE


-- 14. Which students are most active in the clubs?
-- TODO: Student Answer Here...

SELECT FirstName+ ' ' + LastName AS 'Student Name'
from Student AS S
    INNER JOIN Activity AS A 
    ON S.StudentID=A.StudentID          
GROUP BY FirstName +' '+ LastName
HAVING COUNT(ClubId) >= ALL (SELECT COUNT(ClubId)
                                    FROM Activity
                                    GROUP BY StudentID)