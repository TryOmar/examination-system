CREATE PROCEDURE AddDepartmentToBranch(@branch_id INT, @department_id INT)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		DECLARE @error_message VARCHAR(50);
		IF NOT EXISTS(SELECT * FROM branch_department 
		WHERE branch_id = @branch_id AND department_id = @department_id)
		BEGIN
			INSERT INTO branch_department(branch_id, department_id)
			VALUES(@branch_id, @department_id);
		END
		ELSE
		BEGIN
			SET @error_message = 'This department is already exists in this branch';
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

EXEC AddDepartmentToBranch 1, 1