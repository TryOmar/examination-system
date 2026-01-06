CREATE PROCEDURE DeleteDepartment(@id INT)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			DELETE FROM department_courses
			WHERE department_id = @id;

			DELETE FROM branch_department
			WHERE department_id = @id;

			DELETE FROM person_jong_department_branch
			WHERE department_id = @id;
			
			DELETE FROM department
			WHERE department_id = @id;
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
