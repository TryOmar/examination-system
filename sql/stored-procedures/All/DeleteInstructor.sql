CREATE PROCEDURE DeleteInstructor
    @InstructorId INT
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
        
        -- Check if instructor exists
        IF NOT EXISTS (SELECT 1 FROM [instructor] WHERE [instructor_id] = @InstructorId)
        BEGIN
            RAISERROR('Instructor not found', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Check for related records in instructor_course
        IF EXISTS (SELECT 1 FROM [instructor_course] WHERE [instructor_id] = @InstructorId)
        BEGIN
            RAISERROR('Cannot delete instructor: Instructor is assigned to courses', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Check for related records in instructor_generate_course_exam
        IF EXISTS (SELECT 1 FROM [instructor_generate_course_exam] WHERE [instructor_id] = @InstructorId)
        BEGIN
            RAISERROR('Cannot delete instructor: Instructor has generated exams', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Delete from instructor table first (FK constraint)
        DELETE FROM [instructor] WHERE [instructor_id] = @InstructorId;
        
        -- Delete from person table
        DELETE FROM [person] WHERE [person_id] = @InstructorId;
        
        COMMIT TRANSACTION;
        
        SELECT 'Instructor deleted successfully' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
