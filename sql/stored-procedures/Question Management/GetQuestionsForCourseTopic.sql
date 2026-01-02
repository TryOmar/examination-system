-- =============================================
-- Procedure: GetQuestionsForCourseTopic
-- Description: Retrieves all questions linked to a specific course and optionally a topic.
-- =============================================
CREATE PROCEDURE GetQuestionsForCourseTopic
    @CourseID INT,
    @TopicID INT = NULL,
    @QuestionType VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate CourseID
    IF @CourseID IS NULL
    BEGIN
        RAISERROR('Course ID is required', 16, 1);
        RETURN -1;
    END

    -- Check if course exists
    IF NOT EXISTS (SELECT 1 FROM courses WHERE course_id = @CourseID)
    BEGIN
        RAISERROR('Course not found', 16, 1);
        RETURN -2;
    END

    -- If TopicID is provided, check if it exists
    IF @TopicID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM topic WHERE topic_id = @TopicID)
    BEGIN
        RAISERROR('Topic not found', 16, 1);
        RETURN -2;
    END

    SELECT 
        q.question_id,
        q.question_text,
        q.question_type,
        q.question_difficulty,
        q.correct_ans_id,
        cqt.topic_id,
        t.topic_title,
        cqt.course_id
    FROM question q
    INNER JOIN course_questions_on_topic cqt 
        ON q.question_id = cqt.question_id
    INNER JOIN topic t 
        ON cqt.topic_id = t.topic_id
    WHERE cqt.course_id = @CourseID
      AND (@TopicID IS NULL OR cqt.topic_id = @TopicID)
      AND (@QuestionType IS NULL OR q.question_type = @QuestionType)
    ORDER BY t.topic_order, q.question_id;

    RETURN 0;
END
GO

-- Return Codes:
-- 0  : Success
-- -1 : Invalid input (NULL CourseID)
-- -2 : Entity not found (course or topic)
