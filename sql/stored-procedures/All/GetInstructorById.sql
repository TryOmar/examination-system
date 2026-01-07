CREATE PROCEDURE GetInstructorById
    @InstructorId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validate input parameter
    IF @InstructorId IS NULL OR @InstructorId <= 0
    BEGIN
        RAISERROR('Invalid Instructor ID', 16, 1);
        RETURN;
    END
    
    SELECT 
        i.[instructor_id],
        p.[first_name],
        p.[last_name],
        p.[email],
        i.[hire_date]
    FROM [instructor] i
    INNER JOIN [person] p ON i.[instructor_id] = p.[person_id]
    WHERE i.[instructor_id] = @InstructorId;
    
    -- Check if instructor exists
    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Instructor not found', 16, 1);
        RETURN;
    END
END
