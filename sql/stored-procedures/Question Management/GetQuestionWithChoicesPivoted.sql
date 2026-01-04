-- =============================================
-- Procedure: GetQuestionWithChoicesPivoted
-- Description: Returns question details with all choices in a single row
--              Useful for report generation where each question needs 
--              to display with its choices in columns (Ch1, Ch2, Ch3, Ch4)
-- Returns:
--   0  : Success
--  -1  : QuestionID is NULL
--  -2  : Question not found
-- =============================================
CREATE PROCEDURE GetQuestionWithChoicesPivoted
    @QuestionID INT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate input
    IF @QuestionID IS NULL
        RETURN -1;

    IF NOT EXISTS (SELECT 1 FROM question WHERE question_id = @QuestionID)
        RETURN -2;

    -- Return question with choices pivoted into columns
    -- Uses ROW_NUMBER to assign choice positions (Ch1, Ch2, Ch3, Ch4)
    SELECT 
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
    FROM question q
    LEFT JOIN (
        SELECT 
            qcb.question_id,
            qc.choice_id,
            qc.choice_text,
            ROW_NUMBER() OVER (PARTITION BY qcb.question_id ORDER BY qc.choice_id) AS rn
        FROM question_choise_bridge qcb
        JOIN quesiton_choice qc ON qc.choice_id = qcb.choice_id
    ) c ON c.question_id = q.question_id
    WHERE q.question_id = @QuestionID
    GROUP BY 
        q.question_id,
        q.question_text,
        q.question_type,
        q.question_difficulty,
        q.correct_ans_id;

    RETURN 0;
END
GO

-- =============================================
-- Procedure: GetAllQuestionsWithChoicesPivoted
-- Description: Returns ALL questions with their choices in a single row each
--              Perfect for bulk report generation
-- Returns:
--   0  : Success (returns result set of all questions)
-- =============================================
CREATE PROCEDURE GetAllQuestionsWithChoicesPivoted
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
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
    FROM question q
    LEFT JOIN (
        SELECT 
            qcb.question_id,
            qc.choice_id,
            qc.choice_text,
            ROW_NUMBER() OVER (PARTITION BY qcb.question_id ORDER BY qc.choice_id) AS rn
        FROM question_choise_bridge qcb
        JOIN quesiton_choice qc ON qc.choice_id = qcb.choice_id
    ) c ON c.question_id = q.question_id
    GROUP BY 
        q.question_id,
        q.question_text,
        q.question_type,
        q.question_difficulty,
        q.correct_ans_id
    ORDER BY q.question_id;

    RETURN 0;
END
GO
