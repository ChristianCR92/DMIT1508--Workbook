/* **********************
* SchoolTranscript_Data.sql
* Christian Castro 
***************** */

USE SchoolTranscript
GO

INSERT INTO Students(GivenName, Surname,DateOfBirth) -- notice no Enrolled column
VALUES ('Christian', 'Castro','19921204 19:00:00')

SELECT * FROM Students