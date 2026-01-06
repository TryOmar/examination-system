-- =============================================
-- Procedure: GetCourseTopics
-- Description: Returns all topics studied in a specific course
--              Useful for course outline reports and curriculum display
-- Parameters:
--   @CourseID INT - The course to retrieve topics for
-- Returns:
--   0  : Success (returns result set of topics)
--  -1  : CourseID is NULL
--  -2  : Course not found
--  -99 : Database error
-- =============================================
CREATE PROCEDURE GetCourseTopics
    @CourseID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate input
    IF @CourseID IS NULL
    BEGIN
        RAISERROR('Course ID cannot be NULL', 16, 1);
        RETURN -1;
    END;

    -- Check if course exists
    IF NOT EXISTS (SELECT 1 FROM courses WHERE course_id = @CourseID)
    BEGIN
        RAISERROR('Course not found', 16, 1);
        RETURN -2;
    END;

    BEGIN TRY
        -- Return course topics with enriched data
        SELECT DISTINCT
            c.course_id AS CourseID,
            c.course_title AS CourseTitle,
            c.course_code AS CourseCode,
            c.description AS CourseDescription,
            c.credits AS Credits,
            t.topic_id AS TopicID,
            t.topic_title AS TopicTitle,
            t.topic_order AS TopicOrder,
            t.topic_duration AS TopicDuration,
            -- Calculated fields for report display
            (SELECT COUNT(DISTINCT topic_id) 
             FROM course_questions_on_topic 
             WHERE course_id = @CourseID) AS TotalTopics,
            CONCAT('Topic ', t.topic_order, ' of ', 
                   (SELECT COUNT(DISTINCT topic_id) 
                    FROM course_questions_on_topic 
                    WHERE course_id = @CourseID)) AS TopicProgress
        FROM courses c
        INNER JOIN course_questions_on_topic cqt ON cqt.course_id = c.course_id
        INNER JOIN topic t ON t.topic_id = cqt.topic_id
        WHERE c.course_id = @CourseID
        ORDER BY t.topic_order;

        RETURN 0;

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
        RETURN -99;
    END CATCH
END;
GO
