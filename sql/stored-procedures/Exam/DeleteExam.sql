-- =============================================
-- Procedure: DeleteExam
-- Description: Deletes an exam and all related records.
--              Use with caution as this removes all student answers and grades.
-- =============================================
CREATE PROCEDURE DeleteExam
    @ExamID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate ExamID
    IF @ExamID IS NULL OR @ExamID <= 0
    BEGIN
        RAISERROR('Valid Exam ID is required', 16, 1);
        RETURN -1;
    END

    -- Check if exam exists
    IF NOT EXISTS (SELECT 1 FROM exam WHERE exam_id = @ExamID)
    BEGIN
        RAISERROR('Exam not found', 16, 1);
        RETURN -2;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Delete student answers for this exam
        DELETE FROM student_answer_question
        WHERE exam_id = @ExamID;

        -- Delete student exam records
        DELETE FROM student_exam
        WHERE exam_id = @ExamID;

        -- Delete exam questions associations
        DELETE FROM exam_questions
        WHERE exam_id = @ExamID;

        -- Delete instructor-exam-course association
        DELETE FROM instructor_generate_course_exam
        WHERE exam_id = @ExamID;

        -- Delete the exam itself
        DELETE FROM exam
        WHERE exam_id = @ExamID;

        COMMIT TRANSACTION;

        SELECT 'Exam deleted successfully' AS Message,
               @ExamID AS DeletedExamID;
        RETURN 0;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN -3;
    END CATCH
END
GO

-- Return Codes:
-- 0  : Success
-- -1 : Invalid ExamID
-- -2 : Exam not found
-- -3 : Database error
