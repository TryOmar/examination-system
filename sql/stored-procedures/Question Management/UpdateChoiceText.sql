CREATE PROCEDURE UpdateChoiceText
    @ChoiceID INT,
    @ChoiceText VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    IF @ChoiceID IS NULL
        RETURN -1;

    IF @ChoiceText IS NULL OR LTRIM(RTRIM(@ChoiceText)) = ''
        RETURN -2;

    IF NOT EXISTS (SELECT 1 FROM quesiton_choice WHERE choice_id = @ChoiceID)
        RETURN -3;

    -- Protect global True/False choice entries (lookup dynamically)
    DECLARE @TrueChoiceID INT;
    DECLARE @FalseChoiceID INT;

    SELECT @TrueChoiceID = choice_id FROM quesiton_choice WHERE LOWER(choice_text) = 'true';
    SELECT @FalseChoiceID = choice_id FROM quesiton_choice WHERE LOWER(choice_text) = 'false';

    IF (@TrueChoiceID IS NOT NULL AND @ChoiceID = @TrueChoiceID) OR
       (@FalseChoiceID IS NOT NULL AND @ChoiceID = @FalseChoiceID)
        RETURN -4;

    BEGIN TRY
        UPDATE quesiton_choice
        SET choice_text = LTRIM(RTRIM(@ChoiceText))
        WHERE choice_id = @ChoiceID;

        RETURN 0;
    END TRY
    BEGIN CATCH
        RETURN -5;
    END CATCH
END
GO


-- Return Codes
-- 0  : Success
-- -1 : Choice ID is NULL
-- -2 : Choice text is NULL or empty
-- -3 : Choice not found
-- -4 : Cannot update True/False choices (protected)
-- -5 : Database error