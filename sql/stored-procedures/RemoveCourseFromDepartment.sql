-- =============================================
-- Procedure: RemoveCourseFromDepartment
-- Description: Removes the link between a course and a department.
-- =============================================
CREATE PROCEDURE RemoveCourseFromDepartment
    @CourseID INT,
    @DepartmentID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate CourseID
    IF @CourseID IS NULL
    BEGIN
        RAISERROR('Course ID is required', 16, 1);
        RETURN -1;
    END

    -- Validate DepartmentID
    IF @DepartmentID IS NULL
    BEGIN
        RAISERROR('Department ID is required', 16, 1);
        RETURN -1;
    END

    -- Check if link exists
    IF NOT EXISTS (
        SELECT 1 
        FROM department_courses 
        WHERE course_id = @CourseID 
          AND department_id = @DepartmentID
    )
    BEGIN
        RAISERROR('Link not found between specified course and department', 16, 1);
        RETURN -2;
    END

    BEGIN TRY
        DELETE FROM department_courses 
        WHERE course_id = @CourseID 
          AND department_id = @DepartmentID;

        SELECT 'Course removed from department successfully' AS Message;
        RETURN 0;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN -3;
    END CATCH
END
GO

-- Return Codes:
-- 0  : Success
-- -1 : Invalid input (NULL parameters)
-- -2 : Link not found
-- -3 : Database error
