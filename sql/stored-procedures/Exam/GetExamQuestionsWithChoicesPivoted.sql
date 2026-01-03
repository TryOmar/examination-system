-- =============================================
-- Procedure: GetExamQuestionsWithChoicesPivoted
-- Description: Returns all questions for a specific exam with their 
--              choices pivoted into columns (single row per question)
--              Ideal for generating printable exam papers/reports
-- Parameters:
--   @ExamID INT - The exam to retrieve questions for
-- Returns:
--   0  : Success
--  -1  : ExamID is NULL
--  -2  : Exam not found
-- =============================================
CREATE PROCEDURE GetExamQuestionsWithChoicesPivoted
    @ExamID INT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate input
    IF @ExamID IS NULL
        RETURN -1;

    IF NOT EXISTS (SELECT 1 FROM exam WHERE exam_id = @ExamID)
        RETURN -2;

    -- Return all questions for this exam with choices pivoted into columns
    SELECT 
        e.exam_id AS ExamID,
        e.exam_title AS ExamTitle,
        q.question_id AS QuestionID,
        q.question_text AS QuestionText,
        q.question_type AS QuestionType,
        q.question_difficulty AS Difficulty,
        q.correct_ans_id AS CorrectAnswerID,
        MAX(CASE WHEN rn = 1 THEN c.choice_id END) AS Choice1_ID,
        MAX(CASE WHEN rn = 1 THEN c.choice_text END) AS Choice1_Text,
        MAX(CASE WHEN rn = 2 THEN c.choice_id END) AS Choice2_ID,
        MAX(CASE WHEN rn = 2 THEN c.choice_text END) AS Choice2_Text,
        MAX(CASE WHEN rn = 3 THEN c.choice_id END) AS Choice3_ID,
        MAX(CASE WHEN rn = 3 THEN c.choice_text END) AS Choice3_Text,
        MAX(CASE WHEN rn = 4 THEN c.choice_id END) AS Choice4_ID,
        MAX(CASE WHEN rn = 4 THEN c.choice_text END) AS Choice4_Text
    FROM exam e
    JOIN exam_questions eq ON eq.exam_id = e.exam_id
    JOIN question q ON q.question_id = eq.questoin_id
    LEFT JOIN (
        SELECT 
            qcb.question_id,
            qc.choice_id,
            qc.choice_text,
            ROW_NUMBER() OVER (PARTITION BY qcb.question_id ORDER BY qc.choice_id) AS rn
        FROM question_choise_bridge qcb
        JOIN quesiton_choice qc ON qc.choice_id = qcb.choice_id
    ) c ON c.question_id = q.question_id
    WHERE e.exam_id = @ExamID
    GROUP BY 
        e.exam_id,
        e.exam_title,
        q.question_id,
        q.question_text,
        q.question_type,
        q.question_difficulty,
        q.correct_ans_id
    ORDER BY q.question_id;

    RETURN 0;
END
GO
