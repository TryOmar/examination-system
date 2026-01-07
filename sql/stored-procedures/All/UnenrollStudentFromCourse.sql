-- =============================================
-- Procedure: UnenrollStudentFromCourse
-- Description: Removes a student's enrollment from a course.
-- =============================================
CREATE PROCEDURE UnenrollStudentFromCourse
    @StudentID INT,
    @CourseID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate StudentID
    IF @StudentID IS NULL
    BEGIN
        RAISERROR('Student ID is required', 16, 1);
        RETURN -1;
    END

    -- Validate CourseID
    IF @CourseID IS NULL
    BEGIN
        RAISERROR('Course ID is required', 16, 1);
        RETURN -1;
    END

    -- Check if enrollment exists
    IF NOT EXISTS (
        SELECT 1 
        FROM student_course 
        WHERE student_id = @StudentID 
          AND course_id = @CourseID
    )
    BEGIN
        RAISERROR('Enrollment not found', 16, 1);
        RETURN -2;
    END

    -- Check if student has exams in this course
    IF EXISTS (
        SELECT 1 
        FROM student_exam se
        INNER JOIN instructor_generate_course_exam igce ON se.exam_id = igce.exam_id
        WHERE se.student_id = @StudentID 
          AND igce.course_id = @CourseID
    )
    BEGIN
        RAISERROR('Cannot unenroll: Student has exam records in this course', 16, 1);
        RETURN -3;
    END

    BEGIN TRY
        DELETE FROM student_course 
        WHERE student_id = @StudentID 
          AND course_id = @CourseID;

        SELECT 'Student unenrolled from course successfully' AS Message;
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
-- -2 : Enrollment not found
-- -3 : Cannot unenroll due to exam records
-- -4 : Database error
