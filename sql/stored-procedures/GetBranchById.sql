CREATE PROCEDURE GetBranchById(@id INT)
AS
BEGIN
	SELECT branch_name AS [Branch Name], branch_city AS [Branch City]
	FROM branch
	WHERE branch_id = @id;
	IF @@ROWCOUNT = 0
	BEGIN
		DECLARE @error_message VARCHAR(50) = CONCAT('Branch with id ', @id, ' does not exist!');
		THROW 50010, @error_message, 1;
	END
END

EXEC GetBranchById 1