CREATE PROCEDURE InsertTrueFalseChoices
    @QuestionID INT,
    @CorrectAnswer BIT  -- 1 = True is correct, 0 = False is correct
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
        -- (1 = True, 2 = False)
        DECLARE @CorrectChoiceID INT;
        SET @CorrectChoiceID = CASE WHEN @CorrectAnswer = 1 THEN 1 ELSE 2 END;
        
        UPDATE question 
        SET correct_ans_id = @CorrectChoiceID
        WHERE question_id = @QuestionID;
        
        INSERT INTO question_choise_bridge (question_id, choice_id)
        VALUES (@QuestionID, 1);
        
        INSERT INTO question_choise_bridge (question_id, choice_id)
        VALUES (@QuestionID, 2);
        
        RETURN 0;  -- Success
    END TRY
    BEGIN CATCH
        RETURN -1;  -- Error
    END CATCH
END