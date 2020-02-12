/* **********************
* SchoolTranscript_Data.sql
* Christian Castro 
***************** */

USE SchoolTranscript
GO

INSERT INTO Students(GivenName, Surname,DateOfBirth) -- notice no Enrolled column
VALUES ('Christian', 'Castro','19921204 19:00:00 PM'),
		('Charles','Kuhn','19990806 00:00:00 AM'),
		('Sofia','Lawson','19640401 00:00:00 AM'),
		('Sergio','Brown','19680502 00:00:00 AM'),
		('Erin','Alexander','19950207 03:15:00 AM')

	-- Ctrl + K + Ctrl + C - to comment code

SELECT * FROM Students


/*INSERT INTO Students(GivenName, Surname,DateOfBirth) -- there's a constraint on the name so it shouldn't add the information
VALUES('Dan', 'G', '19720514 10:34:09 PM') */

INSERT INTO Courses(Number,[Name], Credits, [Hours],Cost) 
VALUES ('DMIT-1508','Database Fundamentals',3.0,60,750),
	   ('CPSC-1012','Programming Fundamentals',3.0,60,750),
	   ('DMIT-1720','OOP Fundamentals',4.5,90,850),
	   ('DMIT-2210','Agile Development',4.5,90,850),
	   ('DMIT-1718','Software Testing',4.5,90,850)



SELECT * FROM Courses 

SELECT Number,[Name], Credits, [Hours] 
FROM	Courses
WHERE [NAME] LIKE'%Fundamentals%'


-- Write a query to get the first /last anme of all students whose last name starts with a "G"
SELECT GivenName, SurName
From Students
WHERE Surname LIKE '%B%'


--Removing all the data from Students table
DELETE FROM Students