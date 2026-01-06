-- =============================================
-- Procedure: GetAllExams
-- Description: Retrieves all exams with optional filtering.
-- =============================================
CREATE PROCEDURE GetAllExams
    @CourseID INT = NULL,
    @ExamType VARCHAR(50) = NULL,
    @InstructorID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        e.exam_id,
        e.exam_title,
        e.total_grade,
        e.exam_date,
        e.exam_type,
        e.duration_mins,
        igce.course_id,
        c.course_title,
        igce.instructor_id,
        p.first_name + ' ' + p.last_name AS instructor_name
    FROM exam e
    LEFT JOIN instructor_generate_course_exam igce ON e.exam_id = igce.exam_id
    LEFT JOIN courses c ON igce.course_id = c.course_id
    LEFT JOIN person p ON igce.instructor_id = p.person_id
    WHERE (@CourseID IS NULL OR igce.course_id = @CourseID)
      AND (@ExamType IS NULL OR e.exam_type = @ExamType)
      AND (@InstructorID IS NULL OR igce.instructor_id = @InstructorID)
    ORDER BY e.exam_date DESC;

    RETURN 0;
END
GO
