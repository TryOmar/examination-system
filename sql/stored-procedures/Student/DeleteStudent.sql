CREATE PROCEDURE DeleteStudent
    @StudentId INT
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
        
        -- Check if student exists
        IF NOT EXISTS (SELECT 1 FROM [student] WHERE [student_id] = @StudentId)
        BEGIN
            RAISERROR('Student not found', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Check for related records ??
        
        
        -- Delete from student table first (FK constraint)
        DELETE FROM [student] WHERE [student_id] = @StudentId;
        
        -- Delete from person table
        DELETE FROM [person] WHERE [person_id] = @StudentId;
        
        COMMIT TRANSACTION;
        
        SELECT 'Student deleted successfully' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
