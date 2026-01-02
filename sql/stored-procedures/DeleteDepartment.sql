CREATE PROCEDURE DeleteDepartment(@id INT)
AS
BEGIN
	SET NOCOUNT ON;
	
	-- Validate input
	IF @id IS NULL
	BEGIN
		RAISERROR('Department ID is required', 16, 1);
		RETURN;
	END
	
	-- Check if department exists
	IF NOT EXISTS (SELECT 1 FROM department WHERE department_id = @id)
	BEGIN
		DECLARE @not_found_message VARCHAR(100) = CONCAT('Department with id ', @id, ' does not exist!');
		RAISERROR(@not_found_message, 16, 1);
		RETURN;
	END
	
	-- Check for people assigned to this department
	IF EXISTS (SELECT 1 FROM person_jong_department_branch WHERE department_id = @id)
	BEGIN
		RAISERROR('Cannot delete department: People are assigned to this department. Remove assignments first.', 16, 1);
		RETURN;
	END
	
	BEGIN TRY
		BEGIN TRANSACTION
			-- Delete from department_courses (course-department relationships)
			DELETE FROM department_courses
			WHERE department_id = @id;
			
			-- Delete from branch_department (branch-department relationships)
			DELETE FROM branch_department
			WHERE department_id = @id;
			
			-- Delete the department itself
			DELETE FROM department
			WHERE department_id = @id;
			
		COMMIT TRANSACTION;
		
		SELECT 'Department deleted successfully' AS Message;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		THROW;
	END CATCH
END
