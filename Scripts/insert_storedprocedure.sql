-- =============================================
-- Stored Procedure: insert_into_owner_sme_sector
-- Description: Inserts owner and SME business data with automatic sector management
-- =============================================

CREATE OR ALTER PROCEDURE insert_into_owner_sme_sector
    -- Owner Information Parameters
    @first_name NVARCHAR(50),
    @last_name NVARCHAR(50),
    @date_of_birth DATE,
    @phone_no BIGINT,
    @email NVARCHAR(100),
    @bvn BIGINT,
    @gender NVARCHAR(50),
    
    -- Small Medium Enterprise Parameters
    @business_name NVARCHAR(100),
    @rc_number INT,
    @size_category NVARCHAR(50),
    @reg_date DATE,
    @address NVARCHAR(200),
    @city NVARCHAR(50),
    @state NVARCHAR(50),
    @country NVARCHAR(50),
    @status NVARCHAR(50),
    @sector_name NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Step 1: Check if sector exists and get sector_id
        DECLARE @sector_id INT;
        
        SELECT @sector_id = sector_id 
        FROM msmes.sector 
        WHERE sector_name = @sector_name;
        
        -- Step 2: Create sector if it doesn't exist
        IF @sector_id IS NULL
        BEGIN
            INSERT INTO msmes.sector (sector_name)
            VALUES (@sector_name);
            
            SET @sector_id = SCOPE_IDENTITY();
        END
        
        -- Step 3: Insert owner information
        INSERT INTO msmes.owner (
            first_name, 
            last_name, 
            date_of_birth, 
            phone_no, 
            email, 
            bvn,
            gender
        )
        VALUES (
            @first_name, 
            @last_name, 
            @date_of_birth, 
            @phone_no, 
            @email, 
            @bvn,
            @gender
        );
        
        -- Get the newly created owner ID
        DECLARE @new_owner_id INT = SCOPE_IDENTITY();
        
        -- Step 4: Insert SME business information
        INSERT INTO msmes.small_medium_enterprice (
            business_name,
            rc_number,
            owner_id,
            size_category,
            reg_date,
            address,
            city,
            state,
            country,
            sector_id,
            status
        )
        VALUES (
            @business_name,
            @rc_number,
            @new_owner_id,
            @size_category,
            @reg_date,
            @address,
            @city,
            @state,
            @country,
            @sector_id,
            @status
        );
        
        COMMIT TRANSACTION;
        
        -- Return success message with IDs
        SELECT 
            'SUCCESS' AS Result,
            @new_owner_id AS OwnerID,
            SCOPE_IDENTITY() AS BusinessID,
            @sector_id AS SectorID,
            'Business registration completed successfully' AS Message;
            
    END TRY
    BEGIN CATCH
        -- Rollback transaction on error
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        -- Return error information
        SELECT 
            'ERROR' AS Result,
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine;
    END CATCH
END;
GO



EXEC insert_into_owner_sme_sector
    @first_name = 'Musa',
    @last_name = ' Busari',
    @date_of_birth = '1971-03-28',
    @phone_no = 2349028692688,
    @email = 'akanni16@hotmail.com',
    @bvn = 23975614556,
    @gender = 'male',
    @business_name = 'WICHTECH INDUSTRIES LIMITED',
    @rc_number = 1802351,
    @size_category = 'medium',
    @reg_date = '2021-05-04',
    @address = '5 Wema Terrace 2-9 Udi Street, Ikoyi, Lagos Nigeria',
    @city = 'Ikoyi',
    @state = 'Lagos',
    @country = 'Nigeria',
    @sector_name = 'General Contracts',
    @status = 'active';



select * from msmes.owner
select * from msmes.small_medium_enterprice
select * from msmes.sector




