-- =============================================
-- Procedure: LinkQuestionToCourseTopic
-- Description: Links a question to a specific course and topic.
--              This is required for the GenerateExam procedure to find questions.
-- =============================================
CREATE PROCEDURE LinkQuestionToCourseTopic
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

    -- Check if question exists
    IF NOT EXISTS (SELECT 1 FROM question WHERE question_id = @QuestionID)
    BEGIN
        RAISERROR('Question not found', 16, 1);
        RETURN -2;
    END

    -- Check if course exists
    IF NOT EXISTS (SELECT 1 FROM courses WHERE course_id = @CourseID)
    BEGIN
        RAISERROR('Course not found', 16, 1);
        RETURN -2;
    END

    -- Check if topic exists
    IF NOT EXISTS (SELECT 1 FROM topic WHERE topic_id = @TopicID)
    BEGIN
        RAISERROR('Topic not found', 16, 1);
        RETURN -2;
    END

    -- Check if the link already exists
    IF EXISTS (
        SELECT 1 
        FROM course_questions_on_topic 
        WHERE course_id = @CourseID 
          AND question_id = @QuestionID 
          AND topic_id = @TopicID
    )
    BEGIN
        RAISERROR('This question is already linked to the specified course and topic', 16, 1);
        RETURN -3;
    END

    BEGIN TRY
        INSERT INTO course_questions_on_topic (course_id, question_id, topic_id)
        VALUES (@CourseID, @QuestionID, @TopicID);

        SELECT 'Question linked to course and topic successfully' AS Message;
        RETURN 0;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN -4;
    END CATCH
END
GO

-- Return Codes:
-- 0  : Success
-- -1 : Invalid input (NULL parameters)
-- -2 : Entity not found (question, course, or topic)
-- -3 : Link already exists
-- -4 : Database error
