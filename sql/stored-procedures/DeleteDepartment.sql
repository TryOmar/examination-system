CREATE PROCEDURE DeleteDepartment(@id INT)
AS
BEGIN
	DELETE
	FROM department
	WHERE department_id = @id;
	IF @@ROWCOUNT = 0
	BEGIN
		DECLARE @error_message VARCHAR(50) = CONCAT('Department with id ', @id, ' does not exist!');
		THROW 50010, @error_message, 1;
	END
END

EXEC DeleteDepartment 2