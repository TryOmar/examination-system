
CREATE PROCEDURE DeleteQuestion
    @QuestionID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @QuestionID IS NULL
        RETURN -1;

    IF NOT EXISTS (SELECT 1 FROM question WHERE question_id = @QuestionID)
        RETURN -2;

    BEGIN TRY
        BEGIN TRANSACTION;

        DELETE FROM question_choise_bridge
        WHERE question_id = @QuestionID;

        DELETE FROM question
        WHERE question_id = @QuestionID;

        COMMIT TRANSACTION;

        RETURN 0;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        RETURN -3;
    END CATCH
END
GO


-- Return Codes

-- 0  : Success
-- -1 : Question ID is NULL
-- -2 : Question not found
-- -3 : Database error
