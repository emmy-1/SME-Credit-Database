CREATE OR ALTER PROCEDURE insert_into_owner_sme_sector
	-- insert owners information
	@first_name NVARCHAR(50),@last_name NVARCHAR(50),@date_of_birth DATE,@phone_no INT,@email NVARCHAR(50),@bvn INT,
	-- insert details of their small_medium_enterprice
	@business_name NVARCHAR(50),@reg_number INT, @size_category NVARCHAR(50),@years_of_operation INT, 
	@established_on DATE,@location NVARCHAR(50), @sector_name NVARCHAR(50)
AS
BEGIN
	-- check if the sme id exisit in the msmes.sector
	DECLARE @sector_id INT 
	SELECT @sector_id = sector_id 
    FROM msmes.sector 
    WHERE sector_name = @sector_name;
	-- if it doesnt create a new one using the sector_name and collect a new id for the sector
IF @sector_id IS NULL 
	INSERT INTO msmes.sector(sector_name)
	VALUES (@sector_name);

        SET @sector_id = SCOPE_IDENTITY();
    END

INSERT INTO msmes.owner(first_name, last_name, date_of_birth,phone_no,email,bvn) VALUES(@first_name, @last_name, @date_of_birth,@phone_no,@email, @bvn);
DECLARE @new_owner_id INT = SCOPE_IDENTITY();
INSERT INTO msmes.small_medium_enterprice(business_name, reg_number, owner_id, size_category, established_on, years_of_operation, location,sector_id)
VALUES(@business_name, @reg_number, @new_owner_id, @size_category,@established_on, @years_of_operation, @location, @sector_id)
