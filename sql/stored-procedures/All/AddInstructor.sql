CREATE PROCEDURE AddInstructor
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @Email VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
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
        
        
        
        -- Check if email already exists
        IF EXISTS (SELECT 1 FROM [person] WHERE [email] = @Email)
        BEGIN
            RAISERROR('Email already exists in the system', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        DECLARE @NewPersonId INT;
        
        -- Insert into person table
        INSERT INTO [person] ([first_name], [last_name], [email])
        VALUES (@FirstName, @LastName, @Email);
        
        SET @NewPersonId = SCOPE_IDENTITY();
        
        -- Insert into instructor table
        INSERT INTO [instructor] ([instructor_id], [hire_date])
        VALUES (@NewPersonId, GETDATE());
        
        COMMIT TRANSACTION;
        
        -- Return the new instructor ID
        SELECT @NewPersonId AS InstructorId, 'Instructor created successfully' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
