CREATE OR ALTER PROCEDURE GetTopicById
    @topic_id INT = NULL
AS
BEGIN
    SELECT topic_id, topic_order, topic_duration, topic_title
    FROM topic
    WHERE @topic_id IS NULL OR topic_id = @topic_id;
END
GO
