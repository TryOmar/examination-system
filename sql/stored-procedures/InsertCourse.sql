CREATE OR ALTER PROCEDURE InsertCourse
    @course_code INT,
    @description VARCHAR(255),
    @course_title VARCHAR(255),
    @credits VARCHAR(255),
    @course_id INT OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            IF NOT EXISTS (SELECT 1 FROM courses WHERE course_code = @course_code)
            BEGIN
                INSERT INTO courses (course_code, description, course_title, credits)
                VALUES (@course_code, @description, @course_title, @credits);

                SET @course_id = SCOPE_IDENTITY();
            END
            ELSE
            BEGIN
                DECLARE @error_message VARCHAR(100) = 'Course with code ' + CAST(@course_code AS VARCHAR(20)) + ' already exists!';
                THROW 50001, @error_message, 1;
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
