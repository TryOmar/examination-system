
CREATE PROCEDURE GetChoicesByQuestionId
    @QuestionID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @QuestionID IS NULL
        RETURN -1;

    IF NOT EXISTS (SELECT 1 FROM question WHERE question_id = @QuestionID)
        RETURN -2;

    SELECT 
        qc.choice_id,
        qc.choice_text
    FROM quesiton_choice qc
    JOIN question_choise_bridge qcb
        ON qc.choice_id = qcb.choice_id
    WHERE qcb.question_id = @QuestionID;

    RETURN 0;
END

GO

CREATE PROCEDURE GetQuestionWithChoices
    @QuestionID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @QuestionID IS NULL
        RETURN -1;

    IF NOT EXISTS (SELECT 1 FROM question WHERE question_id = @QuestionID)
        RETURN -2;

    SELECT 
        q.question_id,
        q.question_text,
        q.question_type,
        q.question_difficulty,
        q.correct_ans_id
    FROM question q
    WHERE q.question_id = @QuestionID;

    -- make sure here to use the correct schema name 
    EXEC dbo.GetChoicesByQuestionId @QuestionID = @QuestionID;

    RETURN 0;
END