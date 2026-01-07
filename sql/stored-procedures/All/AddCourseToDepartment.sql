-- =============================================
-- Procedure: AddCourseToDepartment
-- Description: Links a course to a department.
-- =============================================
CREATE PROCEDURE AddCourseToDepartment
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

    -- Check if course exists
    IF NOT EXISTS (SELECT 1 FROM courses WHERE course_id = @CourseID)
    BEGIN
        RAISERROR('Course not found', 16, 1);
        RETURN -2;
    END

    -- Check if department exists
    IF NOT EXISTS (SELECT 1 FROM department WHERE department_id = @DepartmentID)
    BEGIN
        RAISERROR('Department not found', 16, 1);
        RETURN -2;
    END

    -- Check if already linked
    IF EXISTS (
        SELECT 1 
        FROM department_courses 
        WHERE course_id = @CourseID 
          AND department_id = @DepartmentID
    )
    BEGIN
        RAISERROR('Course is already linked to this department', 16, 1);
        RETURN -3;
    END

    BEGIN TRY
        INSERT INTO department_courses (course_id, department_id)
        VALUES (@CourseID, @DepartmentID);

        SELECT 'Course added to department successfully' AS Message,
               @CourseID AS CourseID,
               @DepartmentID AS DepartmentID;
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
-- -2 : Entity not found (course or department)
-- -3 : Already linked
-- -4 : Database error
