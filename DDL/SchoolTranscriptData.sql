/* **********************
* SchoolTranscript_Data.sql
* Christian Castro 
***************** */

USE SchoolTranscript
GO

INSERT INTO Students(StudentID, GivenName, Surname,DateOfBirth) -- notice no Enrolled column
VALUES (123456,'Christian', 'Castro','19921204 19:00:00')

SELECT * FROM Students