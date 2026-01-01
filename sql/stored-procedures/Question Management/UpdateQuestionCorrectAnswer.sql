CREATE PROCEDURE UpdateQuestionCorrectAnswer
    @QuestionID INT,
    @NewCorrectChoiceID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @QuestionID IS NULL
        RETURN -1;

    IF @NewCorrectChoiceID IS NULL
        RETURN -2;

    IF NOT EXISTS (SELECT 1 FROM question WHERE question_id = @QuestionID)
        RETURN -3;

    DECLARE @QuestionType VARCHAR(50);

    SELECT @QuestionType = question_type 
    FROM question 
    WHERE question_id = @QuestionID;

    IF @QuestionType = 'True_False'
    BEGIN
        IF @NewCorrectChoiceID NOT IN (1, 2)
            RETURN -4;
    END
    ELSE IF @QuestionType = 'MCQ'
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM quesiton_choice WHERE choice_id = @NewCorrectChoiceID)
            RETURN -5;

        IF NOT EXISTS (
            SELECT 1 
            FROM question_choise_bridge 
            WHERE question_id = @QuestionID 
            AND choice_id = @NewCorrectChoiceID
        )
            RETURN -6;
    END
    ELSE
    BEGIN
        RETURN -7;
    END

    BEGIN TRY
        UPDATE question
        SET correct_ans_id = @NewCorrectChoiceID
        WHERE question_id = @QuestionID;

        RETURN 0;
    END TRY
    BEGIN CATCH
        RETURN -8;
    END CATCH
END
GO


-- Return Codes
-- 0  : Success
-- -1 : Question ID is NULL
-- -2 : Choice ID is NULL
-- -3 : Question not found
-- -4 : True/False question: choice must be 1 (True) or 2 (False)
-- -5 : MCQ: Choice not found
-- -6 : MCQ: Choice does not belong to this question
-- -7 : Unknown question type
-- -8 : Database error

