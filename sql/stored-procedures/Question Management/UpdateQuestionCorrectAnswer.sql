CREATE PROCEDURE UpdateQuestionCorrectAnswer
    @QuestionID INT,
    @NewCorrectChoiceID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @QuestionID IS NULL
        RETURN -1;
    IF @NewCorrectChoiceID IS NULL
        RETURN -1;
    IF NOT EXISTS (SELECT 1 FROM question WHERE question_id = @QuestionID)
        RETURN -2;
    IF NOT EXISTS (SELECT 1 FROM quesiton_choice WHERE choice_id = @NewCorrectChoiceID)
        RETURN -3;

    -- Check if choice belongs to this question (exists in bridge table)
    IF NOT EXISTS (
        SELECT 1 
        FROM question_choise_bridge 
        WHERE question_id = @QuestionID 
        AND choice_id = @NewCorrectChoiceID
    )
        RETURN -4;

    BEGIN TRY
        UPDATE question
        SET correct_ans_id = @NewCorrectChoiceID
        WHERE question_id = @QuestionID;

        RETURN 0;
    END TRY
    BEGIN CATCH
        RETURN -5;
    END CATCH
END
GO

-- 0  : Success
-- -1 : Validation error (NULL parameter)
-- -2 : Question not found
-- -3 : Choice not found
-- -4 : Choice does not belong to this question
-- -5 : Database error
