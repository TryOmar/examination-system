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
        
        -- Check for related records in student_course
        IF EXISTS (SELECT 1 FROM [student_course] WHERE [student_id] = @StudentId)
        BEGIN
            RAISERROR('Cannot delete student: Student is enrolled in courses. Unenroll the student first.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Check for related records in student_exam
        IF EXISTS (SELECT 1 FROM [student_exam] WHERE [student_id] = @StudentId)
        BEGIN
            RAISERROR('Cannot delete student: Student has exam records.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Check for related records in student_answer_question
        IF EXISTS (SELECT 1 FROM [student_answer_question] WHERE [student_id] = @StudentId)
        BEGIN
            RAISERROR('Cannot delete student: Student has submitted exam answers.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Check for related records in person_jong_department_branch
        IF EXISTS (SELECT 1 FROM [person_jong_department_branch] WHERE [person_id] = @StudentId)
        BEGIN
            RAISERROR('Cannot delete student: Student is assigned to a department/branch.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
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
