-- =============================================
--   Return codes:
--   0  : Success
--  -1  : Invalid parameters (NULL values)
--  -2  : Exam not found
--  -3  : Student not enrolled in course
--  -4  : Student has not submitted this exam yet
-- =============================================

CREATE PROCEDURE sp_GetExamForStudent
(
    @student_id INT,
    @exam_id INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validate input parameters
        IF @student_id IS NULL OR @exam_id IS NULL
        BEGIN
            RAISERROR('Student ID and Exam ID cannot be NULL.', 16, 1);
            RETURN -1;
        END;

        -- Check if exam exists
        IF NOT EXISTS (SELECT 1 FROM exam WHERE exam_id = @exam_id)
        BEGIN
            RAISERROR('Exam not found.', 16, 1);
            RETURN -2;
        END;

        -- Get the course_id for this exam
        DECLARE @course_id INT;
        
        SELECT @course_id = course_id
        FROM instructor_generate_course_exam
        WHERE exam_id = @exam_id;

        IF @course_id IS NULL
        BEGIN
            RAISERROR('Exam is not associated with any course.', 16, 1);
            RETURN -2;
        END;

        -- Check if student is enrolled in the course
        IF NOT EXISTS (
            SELECT 1
            FROM student_course
            WHERE student_id = @student_id
              AND course_id = @course_id
        )
        BEGIN
            RAISERROR('Student is not enrolled in the course for this exam.', 16, 1);
            RETURN -3;
        END;

        -- Check if student has submitted this exam
        IF NOT EXISTS (
            SELECT 1
            FROM student_exam
            WHERE student_id = @student_id
              AND exam_id = @exam_id
              AND state = 'Submitted'
        )
        BEGIN
            RAISERROR('Student has not submitted this exam yet.', 16, 1);
            RETURN -4;
        END;

        -- All validations passed, return exam questions with choices, student answers, and correct answers
        SELECT 
            e.exam_id AS ExamID,
            e.exam_title AS ExamTitle,
            e.total_grade AS TotalGrade,
            e.exam_date AS ExamDate,
            e.duration_mins AS DurationMinutes,
            se.grade AS StudentGrade,
            se.state AS ExamState,
            CONCAT(CAST(se.grade AS VARCHAR), ' / ', CAST(e.total_grade AS VARCHAR)) AS ScoreDisplay,
            q.question_id AS QuestionID,
            q.question_text AS QuestionText,
            q.question_type AS QuestionType,
            q.question_difficulty AS Difficulty,
            student_choice.choice_text AS StudentChoice,
            correct_choice.choice_text AS CorrectChoice,
            CASE 
                WHEN CAST(saq.student_answer AS INT) = q.correct_ans_id THEN 'Correct'
                WHEN saq.student_answer IS NOT NULL THEN 'Incorrect'
                ELSE 'Not Answered'
            END AS QuestionResult
        FROM exam e
        INNER JOIN exam_questions eq ON eq.exam_id = e.exam_id
        INNER JOIN question q ON q.question_id = eq.questoin_id
        INNER JOIN student_exam se ON se.exam_id = e.exam_id AND se.student_id = @student_id
        LEFT JOIN student_answer_question saq ON saq.exam_id = e.exam_id 
            AND saq.student_id = @student_id 
            AND saq.quesiotn_id = q.question_id
        LEFT JOIN quesiton_choice student_choice ON student_choice.choice_id = CAST(saq.student_answer AS INT)
        LEFT JOIN quesiton_choice correct_choice ON correct_choice.choice_id = q.correct_ans_id
        WHERE e.exam_id = @exam_id
        ORDER BY q.question_id;

        RETURN 0;

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
        RETURN -99;
    END CATCH
END;
GO
