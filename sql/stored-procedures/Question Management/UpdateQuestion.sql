CREATE PROCEDURE UpdateQuestion
    @QuestionID INT,
    @QuestionText VARCHAR(255) = NULL,
    @QuestionDifficulty VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @QuestionID IS NULL
        RETURN -1;

    IF @QuestionText IS NULL AND @QuestionDifficulty IS NULL
        RETURN -2;

    IF @QuestionText IS NOT NULL AND LTRIM(RTRIM(@QuestionText)) = ''
        RETURN -3;

    IF @QuestionDifficulty IS NOT NULL 
        AND @QuestionDifficulty NOT IN ('easy', 'medium', 'hard')
        RETURN -4;

    IF NOT EXISTS (SELECT 1 FROM question WHERE question_id = @QuestionID)
        RETURN -5;

    BEGIN TRY
        UPDATE question
        SET 
            question_text = CASE 
                WHEN @QuestionText IS NOT NULL 
                THEN LTRIM(RTRIM(@QuestionText)) 
                ELSE question_text 
            END,
            question_difficulty = CASE 
                WHEN @QuestionDifficulty IS NOT NULL 
                THEN @QuestionDifficulty 
                ELSE question_difficulty 
            END
        WHERE question_id = @QuestionID;

        RETURN 0;
    END TRY
    BEGIN CATCH
        RETURN -6;
    END CATCH
END
GO

-- Return Codes
-- 0  : Success
-- -1 : Question ID is NULL
-- -2 : No fields to update (both NULL)
-- -3 : Question text is empty
-- -4 : Question not found
-- -5 : Database error


