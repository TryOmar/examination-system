CREATE PROCEDURE DeleteChoice
    @ChoiceID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @ChoiceID IS NULL
        RETURN -1;

    IF @ChoiceID IN (1, 2)
        RETURN -2;

    IF NOT EXISTS (SELECT 1 FROM quesiton_choice WHERE choice_id = @ChoiceID)
        RETURN -3;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Step 1: Update questions that have this choice as correct answer
        UPDATE question
        SET correct_ans_id = NULL
        WHERE correct_ans_id = @ChoiceID;

        -- Step 2: Delete from bridge table
        DELETE FROM question_choise_bridge
        WHERE choice_id = @ChoiceID;

        -- Step 3: Delete from choice table
        DELETE FROM quesiton_choice
        WHERE choice_id = @ChoiceID;

        COMMIT TRANSACTION;

        RETURN 0;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        RETURN -4;
    END CATCH
END
GO