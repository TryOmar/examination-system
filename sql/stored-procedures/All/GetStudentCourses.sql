-- =============================================
-- Procedure: GetStudentCourses
-- Description: Retrieves all courses a student is enrolled in.
-- =============================================
CREATE PROCEDURE GetStudentCourses
    @StudentID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate StudentID
    IF @StudentID IS NULL OR @StudentID <= 0
    BEGIN
        RAISERROR('Valid Student ID is required', 16, 1);
        RETURN -1;
    END

    -- Check if student exists
    IF NOT EXISTS (SELECT 1 FROM student WHERE student_id = @StudentID)
    BEGIN
        RAISERROR('Student not found', 16, 1);
        RETURN -2;
    END

    SELECT 
        c.course_id,
        c.course_code,
        c.course_title,
        c.description,
        c.credits,
        sc.enrollment_date
    FROM student_course sc
    INNER JOIN courses c ON sc.course_id = c.course_id
    WHERE sc.student_id = @StudentID
    ORDER BY sc.enrollment_date DESC;

    RETURN 0;
END
GO

-- Return Codes:
-- 0  : Success
-- -1 : Invalid input (NULL or invalid StudentID)
-- -2 : Student not found
