CREATE OR ALTER PROCEDURE GetCourseById
    @course_id INT = NULL
AS
BEGIN
    SELECT course_id, course_code, description, course_title, credits
    FROM courses
    WHERE @course_id IS NULL OR course_id = @course_id;
END
GO
