CREATE PROCEDURE GetAllStudents
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        s.[student_id],
        p.[first_name],
        p.[last_name],
        p.[email]
    FROM [student] s
    INNER JOIN [person] p ON s.[student_id] = p.[person_id];
END