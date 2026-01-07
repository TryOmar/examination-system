CREATE PROCEDURE DeleteChoice
    @ChoiceID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @ChoiceID IS NULL
        RETURN -1;

    DECLARE @TrueChoiceID INT;
    DECLARE @FalseChoiceID INT;

    SELECT @TrueChoiceID = choice_id FROM quesiton_choice WHERE LOWER(choice_text) = 'true';
    SELECT @FalseChoiceID = choice_id FROM quesiton_choice WHERE LOWER(choice_text) = 'false';

    IF (@TrueChoiceID IS NOT NULL AND @ChoiceID = @TrueChoiceID) OR
       (@FalseChoiceID IS NOT NULL AND @ChoiceID = @FalseChoiceID)
        RETURN -2;

    IF NOT EXISTS (SELECT 1 FROM quesiton_choice WHERE choice_id = @ChoiceID)
        RETURN -3;


    IF EXISTS (SELECT 1 FROM question WHERE correct_ans_id = @ChoiceID)
        RETURN -5;
        
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Step 1: Delete from bridge table
        DELETE FROM question_choise_bridge
        WHERE choice_id = @ChoiceID;

        -- Step 2: Delete from choice table
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