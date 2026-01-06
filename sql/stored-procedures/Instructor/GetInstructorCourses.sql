-- =============================================
-- Procedure: GetInstructorCourses
-- Description: Retrieves all courses assigned to an instructor.
-- =============================================
CREATE PROCEDURE GetInstructorCourses
    @InstructorID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate InstructorID
    IF @InstructorID IS NULL OR @InstructorID <= 0
    BEGIN
        RAISERROR('Valid Instructor ID is required', 16, 1);
        RETURN -1;
    END

    -- Check if instructor exists
    IF NOT EXISTS (SELECT 1 FROM instructor WHERE instructor_id = @InstructorID)
    BEGIN
        RAISERROR('Instructor not found', 16, 1);
        RETURN -2;
    END

    SELECT 
        c.course_id,
        c.course_code,
        c.course_title,
        c.description,
        c.credits
    FROM instructor_course ic
    INNER JOIN courses c ON ic.course_id = c.course_id
    WHERE ic.instructor_id = @InstructorID
    ORDER BY c.course_title;

    RETURN 0;
END
GO

-- Return Codes:
-- 0  : Success
-- -1 : Invalid input (NULL or invalid InstructorID)
-- -2 : Instructor not found
