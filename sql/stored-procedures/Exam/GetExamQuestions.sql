-- =============================================
-- Procedure: GetExamQuestions
-- Description: Retrieves all questions for an exam.
-- =============================================
CREATE PROCEDURE GetExamQuestions
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

    -- Return exam questions with their choices
    SELECT 
        q.question_id,
        q.question_text,
        q.question_type,
        q.question_difficulty,
        qc.choice_id,
        qc.choice_text,
        CASE WHEN q.correct_ans_id = qc.choice_id THEN 1 ELSE 0 END AS is_correct
    FROM exam_questions eq
    INNER JOIN question q ON eq.questoin_id = q.question_id
    LEFT JOIN question_choise_bridge qcb ON q.question_id = qcb.question_id
    LEFT JOIN quesiton_choice qc ON qcb.choice_id = qc.choice_id
    WHERE eq.exam_id = @ExamID
    ORDER BY q.question_id, qc.choice_id;

    RETURN 0;
END
GO

-- Return Codes:
-- 0  : Success
-- -1 : Invalid ExamID
-- -2 : Exam not found
