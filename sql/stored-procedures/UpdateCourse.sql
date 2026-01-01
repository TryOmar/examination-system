CREATE OR ALTER PROCEDURE UpdateCourse
    @course_id INT,
    @course_code INT,
    @description VARCHAR(255),
    @course_title VARCHAR(255),
    @credits VARCHAR(255)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            IF EXISTS (SELECT 1 FROM courses WHERE course_id = @course_id)
            BEGIN
                -- Check for duplicate code on other courses
                IF NOT EXISTS (SELECT 1 FROM courses WHERE course_code = @course_code AND course_id <> @course_id)
                BEGIN
                    UPDATE courses
                    SET course_code = @course_code,
                        description = @description,
                        course_title = @course_title,
                        credits = @credits
                    WHERE course_id = @course_id;
                END
                ELSE
                BEGIN
                     DECLARE @msg VARCHAR(100) = 'Course code ' + CAST(@course_code AS VARCHAR(20)) + ' is already used by another course!';
                     THROW 50002, @msg, 1;
                END
            END
            ELSE
            BEGIN
                DECLARE @error_message VARCHAR(100) = 'Course with ID ' + CAST(@course_id AS VARCHAR(20)) + ' does not exist!';
                THROW 50003, @error_message, 1;
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
