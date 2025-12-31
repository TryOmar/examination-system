CREATE OR ALTER PROCEDURE InsertTopic
    @topic_order INT,
    @topic_duration VARCHAR(255),
    @topic_title VARCHAR(255),
    @topic_id INT OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO topic (topic_order, topic_duration, topic_title)
            VALUES (@topic_order, @topic_duration, @topic_title);

            SET @topic_id = SCOPE_IDENTITY();
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
