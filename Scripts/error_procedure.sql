USE sme_credit
GO;
CREATE OR ALTER PROCEDURE sme_geterror
AS
SELECT ERROR_NUMBER() AS error_number,
	   ERROR_SEVERITY() AS error_severity,
	   ERROR_LINE() AS error_line,
	   ERROR_MESSAGE() AS error_message;
GO;
