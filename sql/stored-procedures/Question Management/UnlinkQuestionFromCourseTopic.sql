-- =============================================
-- Procedure: UnlinkQuestionFromCourseTopic
-- Description: Removes the link between a question and a course/topic.
-- =============================================
CREATE PROCEDURE UnlinkQuestionFromCourseTopic
    @QuestionID INT,
    @CourseID INT,
    @TopicID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate QuestionID
    IF @QuestionID IS NULL
    BEGIN
        RAISERROR('Question ID is required', 16, 1);
        RETURN -1;
    END

    -- Validate CourseID
    IF @CourseID IS NULL
    BEGIN
        RAISERROR('Course ID is required', 16, 1);
        RETURN -1;
    END

    -- Validate TopicID
    IF @TopicID IS NULL
    BEGIN
        RAISERROR('Topic ID is required', 16, 1);
        RETURN -1;
    END

    -- Check if the link exists
    IF NOT EXISTS (
        SELECT 1 
        FROM course_questions_on_topic 
        WHERE course_id = @CourseID 
          AND question_id = @QuestionID 
          AND topic_id = @TopicID
    )
    BEGIN
        RAISERROR('Link not found between specifed question, course, and topic', 16, 1);
        RETURN -2;
    END

    BEGIN TRY
        DELETE FROM course_questions_on_topic 
        WHERE course_id = @CourseID 
          AND question_id = @QuestionID 
          AND topic_id = @TopicID;

        SELECT 'Question unlinked from course and topic successfully' AS Message;
        RETURN 0;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN -3;
    END CATCH
END
GO

-- Return Codes:
-- 0  : Success
-- -1 : Invalid input (NULL parameters)
-- -2 : Link not found
-- -3 : Database error
