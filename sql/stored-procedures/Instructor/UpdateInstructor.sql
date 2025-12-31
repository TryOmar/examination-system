CREATE PROCEDURE UpdateInstructor
    @InstructorId INT,
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @Email VARCHAR(255),
    @HireDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Validate InstructorId
        IF @InstructorId IS NULL OR @InstructorId <= 0
        BEGIN
            RAISERROR('Invalid Instructor ID', 16, 1);
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
        
        IF @HireDate IS NULL
        BEGIN
            RAISERROR('Hire date cannot be empty', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Validate hire date is not in the future
        IF @HireDate > GETDATE()
        BEGIN
            RAISERROR('Hire date cannot be in the future', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Check if instructor exists
        IF NOT EXISTS (SELECT 1 FROM [instructor] WHERE [instructor_id] = @InstructorId)
        BEGIN
            RAISERROR('Instructor not found', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Check if email already exists for another person
        IF EXISTS (SELECT 1 FROM [person] WHERE [email] = @Email AND [person_id] != @InstructorId)
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
        WHERE [person_id] = @InstructorId;
        
        -- Update instructor table
        UPDATE [instructor]
        SET [hire_date] = @HireDate
        WHERE [instructor_id] = @InstructorId;
        
        COMMIT TRANSACTION;
        
        SELECT 'Instructor updated successfully' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
