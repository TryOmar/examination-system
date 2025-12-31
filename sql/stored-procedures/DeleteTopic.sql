CREATE OR ALTER PROCEDURE DeleteTopic
    @topic_id INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            IF EXISTS (SELECT 1 FROM topic WHERE topic_id = @topic_id)
            BEGIN
                -- Delete dependencies
                DELETE FROM course_questions_on_topic WHERE topic_id = @topic_id;

                -- Delete topic
                DELETE FROM topic WHERE topic_id = @topic_id;
            END
            ELSE
            BEGIN
                DECLARE @error_message VARCHAR(100) = 'Topic with ID ' + CAST(@topic_id AS VARCHAR(20)) + ' does not exist!';
                THROW 50006, @error_message, 1;
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
