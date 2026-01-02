-- =============================================
-- Procedure: RemoveInstructorFromCourse
-- Description: Removes an instructor's assignment from a course.
-- =============================================
CREATE PROCEDURE RemoveInstructorFromCourse
    @InstructorID INT,
    @CourseID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate InstructorID
    IF @InstructorID IS NULL
    BEGIN
        RAISERROR('Instructor ID is required', 16, 1);
        RETURN -1;
    END

    -- Validate CourseID
    IF @CourseID IS NULL
    BEGIN
        RAISERROR('Course ID is required', 16, 1);
        RETURN -1;
    END

    -- Check if assignment exists
    IF NOT EXISTS (
        SELECT 1 
        FROM instructor_course 
        WHERE instructor_id = @InstructorID 
          AND course_id = @CourseID
    )
    BEGIN
        RAISERROR('Assignment not found', 16, 1);
        RETURN -2;
    END

    -- Check if instructor has generated exams for this course
    IF EXISTS (
        SELECT 1 
        FROM instructor_generate_course_exam 
        WHERE instructor_id = @InstructorID 
          AND course_id = @CourseID
    )
    BEGIN
        RAISERROR('Cannot remove: Instructor has generated exams for this course', 16, 1);
        RETURN -3;
    END

    BEGIN TRY
        DELETE FROM instructor_course 
        WHERE instructor_id = @InstructorID 
          AND course_id = @CourseID;

        SELECT 'Instructor removed from course successfully' AS Message;
        RETURN 0;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN -4;
    END CATCH
END
GO

-- Return Codes:
-- 0  : Success
-- -1 : Invalid input (NULL parameters)
-- -2 : Assignment not found
-- -3 : Cannot remove due to generated exams
-- -4 : Database error
