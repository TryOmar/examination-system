CREATE PROCEDURE InsertQuestion
    @QuestionText VARCHAR(255),
    @QuestionType VARCHAR(50),
    @QuestionDifficulty VARCHAR(50),
    @NewQuestionID INT OUTPUT
WITH ENCRYPTION
AS
BEGIN
    SET NOCOUNT ON;
    SET @NewQuestionID = NULL;
    
    IF @QuestionText IS NULL OR LTRIM(RTRIM(@QuestionText)) = ''
    BEGIN
        SELECT NULL AS QuestionID, 0 AS Success, 'Question text is required' AS Message;
        RETURN -1;
    END
    
    IF @QuestionType IS NULL
    BEGIN
        SELECT NULL AS QuestionID, 0 AS Success, 'Question type is required' AS Message;
        RETURN -1;
    END
    
    IF @QuestionDifficulty IS NULL
    BEGIN
        SELECT NULL AS QuestionID, 0 AS Success, 'Question difficulty is required' AS Message;
        RETURN -1;
    END
   
    BEGIN TRY
        INSERT INTO question (question_text, question_type, question_difficulty, correct_ans_id)
        VALUES (LTRIM(RTRIM(@QuestionText)), @QuestionType, @QuestionDifficulty, NULL);
        
        SET @NewQuestionID = SCOPE_IDENTITY();
        
        SELECT @NewQuestionID AS QuestionID, 1 AS Success, 'Created successfully' AS Message;
        RETURN 0;
    END TRY
    BEGIN CATCH
        SELECT NULL AS QuestionID, 0 AS Success, ERROR_MESSAGE() AS Message;
        RETURN -1;
    END CATCH
END

-- example of usage from DB

DECLARE @QuestionId INT;

EXECUTE InsertQuestion 
    @QuestionText = 'What is 1+1?',
    @QuestionType = 'MCQa',
    @QuestionDifficulty = 'easy',
    @NewQuestionID = @QuestionId OUTPUT;


SELECT @QuestionId AS 'Question ID';