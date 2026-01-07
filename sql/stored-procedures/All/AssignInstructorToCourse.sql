-- =============================================
-- Procedure: AssignInstructorToCourse
-- Description: Assigns an instructor to a course.
--              Required for instructors to generate exams.
-- =============================================
CREATE PROCEDURE AssignInstructorToCourse
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

    -- Check if instructor exists
    IF NOT EXISTS (SELECT 1 FROM instructor WHERE instructor_id = @InstructorID)
    BEGIN
        RAISERROR('Instructor not found', 16, 1);
        RETURN -2;
    END

    -- Check if course exists
    IF NOT EXISTS (SELECT 1 FROM courses WHERE course_id = @CourseID)
    BEGIN
        RAISERROR('Course not found', 16, 1);
        RETURN -2;
    END

    -- Check if already assigned
    IF EXISTS (
        SELECT 1 
        FROM instructor_course 
        WHERE instructor_id = @InstructorID 
          AND course_id = @CourseID
    )
    BEGIN
        RAISERROR('Instructor is already assigned to this course', 16, 1);
        RETURN -3;
    END

    BEGIN TRY
        INSERT INTO instructor_course (instructor_id, course_id)
        VALUES (@InstructorID, @CourseID);

        SELECT 'Instructor assigned to course successfully' AS Message,
               @InstructorID AS InstructorID,
               @CourseID AS CourseID;
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
-- -2 : Entity not found (instructor or course)
-- -3 : Already assigned
-- -4 : Database error
