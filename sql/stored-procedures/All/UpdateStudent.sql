CREATE PROCEDURE UpdateStudent
    @StudentId INT,
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @Email VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Validate StudentId
        IF @StudentId IS NULL OR @StudentId <= 0
        BEGIN
            RAISERROR('Invalid Student ID', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Validate input parameters
        IF @FirstName IS NULL OR LTRIM(RTRIM(@FirstName)) = ''
        BEGIN
            RAISERROR('First name cannot be empty', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        IF @LastName IS NULL OR LTRIM(RTRIM(@LastName)) = ''
        BEGIN
            RAISERROR('Last name cannot be empty', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        IF @Email IS NULL OR LTRIM(RTRIM(@Email)) = ''
        BEGIN
            RAISERROR('Email cannot be empty', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Check if student exists
        IF NOT EXISTS (SELECT 1 FROM [student] WHERE [student_id] = @StudentId)
        BEGIN
            RAISERROR('Student not found', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Check if email already exists for another person
        IF EXISTS (SELECT 1 FROM [person] WHERE [email] = @Email AND [person_id] != @StudentId)
        BEGIN
            RAISERROR('Email already exists for another user', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Update person table
        UPDATE [person]
        SET [first_name] = @FirstName,
            [last_name] = @LastName,
            [email] = @Email
        WHERE [person_id] = @StudentId;
        
        COMMIT TRANSACTION;
        
        SELECT 'Student updated successfully' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
