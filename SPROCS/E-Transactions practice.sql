-- Practice transactions
   USE [A01-School]
   GO
/*
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'DisolveClub')
    DROP PROCEDURE DisolveClub
GO
CREATE PROCEDURE DisolveClub
    -- Parameters here
AS
    -- Body of procedure here
RETURN
GO
*/


--1. Create a store procedure called DisolveClub that will accept a club id as its parameter. Ensure that the club exists before attempting to disolve the club. You are to dissolve the club by first removing all the members of the club and then removing the club itself.
-- -Delete of rows in the Activity table
-- -Delete of rows in the Club table
/*
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'DisolveClub')
    DROP PROCEDURE DisolveClub
GO
CREATE PROCEDURE DisolveClub
    -- Parameters here
    @ClubId varchar(10)
AS
    -- Body of procedure here
    IF @ClubId IS NULL 
    BEGIN
    RAISERROR('Parameter is required',16,1)
    END

    ELSE
    BEGIN
        BEGIN TRANSACTION
        DELETE 
        BEGIN
        RAISERROR('Unable to delete club',16,1);
RETURN
GO*/

--Solution--

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'DisolveClub')
    DROP PROCEDURE DisolveClub
GO
CREATE PROCEDURE DisolveClub
    -- Parameters here
    @ClubId varchar(10)
AS
    IF @ClubId IS NULL
    BEGIN
        RAISERROR('Parameter is required',16,1)
    END
    ELSE
    BEGIN
    IF NOT EXISTS(SELECT ClubId FROM Club WHERE ClubId=@ClubId)
    BEGIN
        RAISERROR('Club does not exist',16,1)
   END
    ELSE 
    BEGIN
            BEGIN TRANSACTION -- start transaction - everything is temporary
            --remove members of the club (from activity)    
            DELETE FROM Activity WHERE ClubId=@ClubId
            IF @@ERROR <>0 --then there's a problem with the delete,no need to check @@ROWCOUNT 
            BEGIN
            RAISERROR('Unable to remove members of the club',16,1)
    END
    ELSE
        BEGIN
            DELETE FROM Club WHERE ClubId=@ClubId
            IF @@ERROR <> 0 OR @@ROWCOUNT=0 -- there's a problem
            BEGIN
             ROLLBACK TRANSACTION
             RAISERROR('Unable to delete club',16,1)
            END
            ELSE
            BEGIN
                   COMMIT TRANSACTION
            END 
   END
   END
   END
   RETURN
    GO

    --Test Stored procedure
    -- 
SELECT * from Club
SELECT * from Activity
EXEC DisolveClub 'CSS'
EXEC DisolveClub 'NASA1'
EXEC DisolveClub 'AWW'