CREATE PROCEDURE UpdateDepartment(@id INT, @new_name VARCHAR(255))
AS
BEGIN
	UPDATE department
	SET department_name = @new_name
	WHERE department_id = @id;

	IF @@ROWCOUNT = 0
	BEGIN
		DECLARE @error_message VARCHAR(50) = CONCAT('Department with id ', @id, ' does not exist!');
		THROW 50010, @error_message, 1;
	END
END

EXEC UpdateDepartment 1, 'PWD'