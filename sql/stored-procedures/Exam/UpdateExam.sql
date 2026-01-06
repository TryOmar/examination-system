-- =============================================
-- Procedure: UpdateExam
-- Description: Updates exam properties.
--              Note: Cannot change associated course or add/remove questions.
--              For that, use GenerateExam to create a new exam.
-- =============================================
CREATE PROCEDURE UpdateExam
    @ExamID INT,
    @ExamTitle VARCHAR(255) = NULL,
    @ExamDate DATETIME = NULL,
    @ExamType VARCHAR(50) = NULL,
    @DurationMins INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate ExamID
    IF @ExamID IS NULL OR @ExamID <= 0
    BEGIN
        RAISERROR('Valid Exam ID is required', 16, 1);
        RETURN -1;
    END

    -- Check if at least one field to update
    IF @ExamTitle IS NULL AND @ExamDate IS NULL AND @ExamType IS NULL AND @DurationMins IS NULL
    BEGIN
        RAISERROR('At least one field must be provided for update', 16, 1);
        RETURN -2;
    END

    -- Check if exam exists
    IF NOT EXISTS (SELECT 1 FROM exam WHERE exam_id = @ExamID)
    BEGIN
        RAISERROR('Exam not found', 16, 1);
        RETURN -3;
    END

    -- Check if exam has already ended (prevent updates to completed exams)
    DECLARE @ExamEndTime DATETIME;
    SELECT @ExamEndTime = DATEADD(MINUTE, duration_mins, exam_date)
    FROM exam
    WHERE exam_id = @ExamID;

    IF GETDATE() > @ExamEndTime
    BEGIN
        RAISERROR('Cannot update exam that has already ended. Students may have completed it.', 16, 1);
        RETURN -7;
    END

    -- Validate exam type if provided
    IF @ExamType IS NOT NULL AND @ExamType NOT IN ('final', 'mid', 'semifinal')
    BEGIN
        RAISERROR('Invalid exam type. Must be: final, mid, or semifinal', 16, 1);
        RETURN -4;
    END

    -- Validate duration if provided
    IF @DurationMins IS NOT NULL AND @DurationMins <= 0
    BEGIN
        RAISERROR('Duration must be greater than 0', 16, 1);
        RETURN -5;
    END

    BEGIN TRY
        UPDATE exam
        SET 
            exam_title = COALESCE(@ExamTitle, exam_title),
            exam_date = COALESCE(@ExamDate, exam_date),
            exam_type = COALESCE(@ExamType, exam_type),
            duration_mins = COALESCE(@DurationMins, duration_mins)
        WHERE exam_id = @ExamID;

        SELECT 'Exam updated successfully' AS Message,
               @ExamID AS ExamID;
        RETURN 0;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN -6;
    END CATCH
END
GO

-- Return Codes:
-- 0  : Success
-- -1 : Invalid ExamID
-- -2 : No fields to update
-- -3 : Exam not found
-- -4 : Invalid exam type
-- -5 : Invalid duration
-- -6 : Database error
-- -7 : Exam has already ended (cannot update completed exams)
