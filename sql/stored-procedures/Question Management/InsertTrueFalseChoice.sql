CREATE PROCEDURE InsertTrueFalseChoices
    @QuestionID INT,
    @CorrectAnswer BIT  -- 1 = True is correct, 0 = False is correct
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @QuestionID IS NULL
        RETURN -1;
    
    IF @CorrectAnswer IS NULL
        RETURN -1;
    
    IF NOT EXISTS (SELECT 1 FROM question WHERE question_id = @QuestionID)
        RETURN -2;  -- Question not found
    
    -- Check if question is True_False type
    IF NOT EXISTS (SELECT 1 FROM question WHERE question_id = @QuestionID AND question_type = 'True_False')
        RETURN -3;  -- Wrong question type
    
    BEGIN TRY
        -- Get True/False choice IDs dynamically from quesiton_choice
        DECLARE @TrueChoiceID INT;
        DECLARE @FalseChoiceID INT;
        DECLARE @CorrectChoiceID INT;

        SELECT @TrueChoiceID = choice_id FROM quesiton_choice WHERE LOWER(choice_text) = 'true';
        SELECT @FalseChoiceID = choice_id FROM quesiton_choice WHERE LOWER(choice_text) = 'false';

        IF @TrueChoiceID IS NULL OR @FalseChoiceID IS NULL
            RETURN -4; -- True/False choice entries missing

        SET @CorrectChoiceID = CASE WHEN @CorrectAnswer = 1 THEN @TrueChoiceID ELSE @FalseChoiceID END;

        UPDATE question 
        SET correct_ans_id = @CorrectChoiceID
        WHERE question_id = @QuestionID;

        INSERT INTO question_choise_bridge (question_id, choice_id)
        VALUES (@QuestionID, @TrueChoiceID);

        INSERT INTO question_choise_bridge (question_id, choice_id)
        VALUES (@QuestionID, @FalseChoiceID);

        RETURN 0;  -- Success
    END TRY
    BEGIN CATCH
        RETURN -1;  -- Error
    END CATCH
END