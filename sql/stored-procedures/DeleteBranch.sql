CREATE PROCEDURE DeleteBranch(@id INT)
AS
BEGIN
	DELETE
	FROM branch
	WHERE branch_id = @id;
	IF @@ROWCOUNT = 0
	BEGIN
		DECLARE @error_message VARCHAR(50) = CONCAT('Sorry branch with id ', @id, ' does not exist!');
		THROW 50010, @error_message, 1;
	END
END

EXEC DeleteBranch 3