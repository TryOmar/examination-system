-- =============================================
-- Procedure: GetExamById
-- Description: Retrieves exam details by ID.
-- =============================================
CREATE PROCEDURE GetExamById
    @ExamID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate ExamID
    IF @ExamID IS NULL OR @ExamID <= 0
    BEGIN
        RAISERROR('Valid Exam ID is required', 16, 1);
        RETURN -1;
    END

    -- Check if exam exists
    IF NOT EXISTS (SELECT 1 FROM exam WHERE exam_id = @ExamID)
    BEGIN
        RAISERROR('Exam not found', 16, 1);
        RETURN -2;
    END

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
    WHERE e.exam_id = @ExamID;

    RETURN 0;
END
GO

-- Return Codes:
-- 0  : Success
-- -1 : Invalid input (NULL or invalid ExamID)
-- -2 : Exam not found
