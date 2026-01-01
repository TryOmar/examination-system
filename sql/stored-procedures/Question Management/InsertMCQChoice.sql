CREATE PROCEDURE InsertMCQChoice
    @QuestionID INT,
    @ChoiceText VARCHAR(255),
    @IsCorrect BIT,
    @NewChoiceID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @NewChoiceID = NULL;
    
    
    IF @QuestionID IS NULL
        RETURN -1;
    
    IF @ChoiceText IS NULL OR LTRIM(RTRIM(@ChoiceText)) = ''
        RETURN -1;
    
    IF @IsCorrect IS NULL
        RETURN -1;
    
    IF NOT EXISTS (SELECT 1 FROM question WHERE question_id = @QuestionID)
        RETURN -2;  -- Question not found
    
    
    BEGIN TRY
        INSERT INTO quesiton_choice(choice_text)
        VALUES (LTRIM(RTRIM(@ChoiceText)));
      
        SET @NewChoiceID = SCOPE_IDENTITY();
        
        IF @IsCorrect = 1
        BEGIN
            UPDATE question 
            SET correct_ans_id = @NewChoiceID
            WHERE question_id = @QuestionID;
        END
        
        INSERT INTO question_choise_bridge(question_id, choice_id)
        VALUES (@QuestionID, @NewChoiceID);
        
        RETURN 0;  
    END TRY
    BEGIN CATCH
        RETURN -1;
    END CATCH
END