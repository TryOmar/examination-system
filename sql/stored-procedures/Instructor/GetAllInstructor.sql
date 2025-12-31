CREATE PROCEDURE GetAllInstructors
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        i.[instructor_id],
        p.[first_name],
        p.[last_name],
        p.[email],
        i.[hire_date]
    FROM [instructor] i
    INNER JOIN [person] p ON i.[instructor_id] = p.[person_id];
END
