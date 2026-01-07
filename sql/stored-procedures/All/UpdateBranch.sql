CREATE PROCEDURE UpdateBranch(@id int, @new_name varchar(255), @new_city varchar(255))
AS
BEGIN
	UPDATE branch
	SET branch_name = @new_name, branch_city = @new_city
	WHERE branch_id = @id;

	IF @@ROWCOUNT = 0
	BEGIN
		DECLARE @error_message VARCHAR(50) = CONCAT('Sorry branch with id ', @id, ' does not exist');
		THROW 50010, @error_message, 1;
	END
END

EXEC UpdateBranch 1, 'ITI Assiut', 'Assiut'
