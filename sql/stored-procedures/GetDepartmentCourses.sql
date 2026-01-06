-- =============================================
-- Procedure: GetDepartmentCourses
-- Description: Retrieves all courses linked to a department.
-- =============================================
CREATE PROCEDURE GetDepartmentCourses
    @DepartmentID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate DepartmentID
    IF @DepartmentID IS NULL OR @DepartmentID <= 0
    BEGIN
        RAISERROR('Valid Department ID is required', 16, 1);
        RETURN -1;
    END

    -- Check if department exists
    IF NOT EXISTS (SELECT 1 FROM department WHERE department_id = @DepartmentID)
    BEGIN
        RAISERROR('Department not found', 16, 1);
        RETURN -2;
    END

    SELECT 
        c.course_id,
        c.course_code,
        c.course_title,
        c.description,
        c.credits
    FROM department_courses dc
    INNER JOIN courses c ON dc.course_id = c.course_id
    WHERE dc.department_id = @DepartmentID
    ORDER BY c.course_title;

    RETURN 0;
END
GO

-- Return Codes:
-- 0  : Success
-- -1 : Invalid input (NULL or invalid DepartmentID)
-- -2 : Department not found
