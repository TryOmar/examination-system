CREATE OR ALTER PROCEDURE UpdateTopic
    @topic_id INT,
    @topic_order INT,
    @topic_duration VARCHAR(255),
    @topic_title VARCHAR(255)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            IF EXISTS (SELECT 1 FROM topic WHERE topic_id = @topic_id)
            BEGIN
                UPDATE topic
                SET topic_order = @topic_order,
                    topic_duration = @topic_duration,
                    topic_title = @topic_title
                WHERE topic_id = @topic_id;
            END
            ELSE
            BEGIN
                 DECLARE @error_message VARCHAR(100) = 'Topic with ID ' + CAST(@topic_id AS VARCHAR(20)) + ' does not exist!';
                 THROW 50005, @error_message, 1;
            END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
