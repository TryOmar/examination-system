CREATE PROCEDURE GetStudentById
    @StudentId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validate input parameter
    IF @StudentId IS NULL OR @StudentId <= 0
    BEGIN
        RAISERROR('Invalid Student ID', 16, 1);
        RETURN;
    END
    
    SELECT 
        s.[student_id],
        p.[first_name],
        p.[last_name],
        p.[email]
    FROM [student] s
    INNER JOIN [person] p ON s.[student_id] = p.[person_id]
    WHERE s.[student_id] = @StudentId;
    
    -- Check if student exists
    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Student not found', 16, 1);
        RETURN;
    END
END
