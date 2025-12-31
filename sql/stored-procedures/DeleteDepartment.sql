CREATE PROCEDURE DeleteDepartment(@id INT)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			DELETE 
			FROM branch_department
			WHERE department_id = @id;
			DELETE
			FROM department
			WHERE department_id = @id;
			IF @@ROWCOUNT = 0
			BEGIN
				DECLARE @error_message VARCHAR(50) = CONCAT('Department with id ', @id, ' does not exist!');
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

EXEC DeleteDepartment 1