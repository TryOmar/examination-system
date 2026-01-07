CREATE PROCEDURE AddBranch(@name varchar(255), @city varchar(255))
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			IF NOT EXISTS (SELECT * FROM branch
			WHERE branch_name = @name COLLATE SQL_Latin1_General_CP1_CI_AS)
			BEGIN
				INSERT INTO branch(branch_name, branch_city)
				VALUES(@name, @city);
			END
			ELSE
			BEGIN
				DECLARE @error_message varchar(50) = 'Branch ' + @name + ' is already exists!';
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


EXEC AddBranch 'ITI Assiut', 'Assiut'
EXEC AddBranch 'ITI Alex', 'Alexandria'
EXEC AddBranch 'ITI Giza', 'Giza'