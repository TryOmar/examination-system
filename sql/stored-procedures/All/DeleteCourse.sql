CREATE OR ALTER PROCEDURE DeleteCourse
    @course_id INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            IF EXISTS (SELECT 1 FROM courses WHERE course_id = @course_id)
            BEGIN
                -- Delete dependencies first
                DELETE FROM department_courses WHERE course_id = @course_id;
                DELETE FROM student_course WHERE course_id = @course_id;
                DELETE FROM instructor_course WHERE course_id = @course_id;
                DELETE FROM instructor_generate_course_exam WHERE course_id = @course_id;
                DELETE FROM course_questions_on_topic WHERE course_id = @course_id;
                
                -- Delete the course
                DELETE FROM courses WHERE course_id = @course_id;
            END
            ELSE
            BEGIN
                DECLARE @error_message VARCHAR(100) = 'Course with ID ' + CAST(@course_id AS VARCHAR(20)) + ' does not exist!';
                THROW 50004, @error_message, 1;
            END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
