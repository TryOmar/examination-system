-- =============================================
-- Procedure: EnrollStudentInCourse
-- Description: Enrolls a student in a course.
--              Required for students to submit exam answers.
-- =============================================
CREATE PROCEDURE EnrollStudentInCourse
    @StudentID INT,
    @CourseID INT,
    @EnrollmentDate DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Set default enrollment date to now if not provided
    IF @EnrollmentDate IS NULL
        SET @EnrollmentDate = GETDATE();

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

    -- Check if student exists
    IF NOT EXISTS (SELECT 1 FROM student WHERE student_id = @StudentID)
    BEGIN
        RAISERROR('Student not found', 16, 1);
        RETURN -2;
    END

    -- Check if course exists
    IF NOT EXISTS (SELECT 1 FROM courses WHERE course_id = @CourseID)
    BEGIN
        RAISERROR('Course not found', 16, 1);
        RETURN -2;
    END

    -- Check if already enrolled
    IF EXISTS (
        SELECT 1 
        FROM student_course 
        WHERE student_id = @StudentID 
          AND course_id = @CourseID
    )
    BEGIN
        RAISERROR('Student is already enrolled in this course', 16, 1);
        RETURN -3;
    END

    BEGIN TRY
        INSERT INTO student_course (student_id, course_id, enrollment_date)
        VALUES (@StudentID, @CourseID, @EnrollmentDate);

        SELECT 'Student enrolled in course successfully' AS Message,
               @StudentID AS StudentID,
               @CourseID AS CourseID,
               @EnrollmentDate AS EnrollmentDate;
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
-- -2 : Entity not found (student or course)
-- -3 : Already enrolled
-- -4 : Database error
