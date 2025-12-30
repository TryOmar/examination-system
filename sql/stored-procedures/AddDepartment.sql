CREATE PROCEDURE AddDepartment(@name VARCHAR(255))
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			IF NOT EXISTS(SELECT * FROM department WHERE department_name = @name)
			BEGIN
				INSERT INTO department(department_name)
				VALUES(@name);
			END
			ELSE
			BEGIN
				DECLARE @error_message varchar(50) = 'Department ' + @name + ' is already exists!';
				THROW 50010, @error_message, 1;
			END
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END

EXEC AddDepartment 'PWD'
