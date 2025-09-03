USE sme_credit;
GO;
CREATE SCHEMA msmes;
GO;
BEGIN TRY 
	DROP TABLE IF EXISTS msmes.small_medium_enterprice;
	CREATE TABLE msmes.small_medium_enterprice(
		sme_id INT IDENTITY(1, 1) CONSTRAINT PK_sme PRIMARY KEY CLUSTERED,
		business_name NVARCHAR(50) NOT NULL,
		reg_number INT NOT NULL UNIQUE,
		owner_id INT NOT NULL UNIQUE,
		size_category NVARCHAR(50) NOT NULL CHECK (size_category IN ('micro, small, medium')),
		established_on DATE	NOT NULL DEFAULT SYSDATETIME(),
		years_of_operation INT NOT NULL CHECK(years_of_operation > 0),
		location NVARCHAR(50) NOT NULL,
		sector_id INT NOT NULL,
		created_at DATETIME2 DEFAULT SYSDATETIME(),
		updated_at DATETIME2 DEFAULT SYSDATETIME()
	);

	DROP TABLE IF EXISTS msmes.owner;
	CREATE TABLE msmes.owner(
		owner_id INT IDENTITY(1,1) CONSTRAINT PK_owner PRIMARY KEY CLUSTERED,
		first_name NVARCHAR(50) NOT NULL,
		last_name NVARCHAR(50) NOT NULL,
		date_of_birth DATE NOT NULL CHECK(DATEDIFF(YEAR,date_of_birth, GETDATE()) >= 18),
		phone_no INT NOT NULL UNIQUE,
		email NVARCHAR(50) NOT NULL UNIQUE,
		bvn INT NOT NULL UNIQUE,
		created_at DATETIME2 DEFAULT SYSDATETIME(),
		updated_at DATETIME2 DEFAULT SYSDATETIME()
	);
	DROP TABLE IF EXISTS msmes.loans
	CREATE TABLE msmes.loans(
		loan_id INT IDENTITY(1,1) CONSTRAINT Pk_loans PRIMARY KEY CLUSTERED,
		sme_id INT NOT NULL,
		lenders_id INT NOT NULL, 
		amount_requested DECIMAL(18,2) NOT NULL CHECK(amount_requested > = 0),
		amount_approved DECIMAL(18,2) NOT NULL CHECK(amount_approved  > = 0),
		purpose NVARCHAR(100) NOT NULL,
		interest_rate DECIMAL(18,2)  NOT NULL  CHECK( interest_rate BETWEEN 0 AND 100),
		tenure INT NOT NULL CHECK(tenure >0),
		current_status NVARCHAR(50)  NOT NULL CHECK (current_status IN('Pending,Approved,Rejected,Closed')),
		application_date DATE NOT NULL DEFAULT SYSDATETIME(),
		Created_at DATETIME2 DEFAULT SYSDATETIME(),
		Updated_at DATETIME2 DEFAULT SYSDATETIME()
	);
	DROP TABLE IF EXISTS msmes.repayment
	CREATE TABLE msmes.repayment(
		repayment_id INT IDENTITY(1,1) CONSTRAINT Pk_repayment PRIMARY KEY CLUSTERED,
		loan_id INT NOT NULL, 
		amount_paid DECIMAL(18,2)  NOT NULL CHECK (amount_paid > 0),
		payment_date DATE NOT NULL, 
		remaining_balance DECIMAL (18,2) NOT NULL CHECK (remaining_balance >= 0),
		created_at DATETIME2 DEFAULT SYSDATETIME(),
		updated_at DATETIME2 DEFAULT SYSDATETIME()
	);

	DROP TABLE IF EXISTS msmes.lenders
	CREATE TABLE msmes.lenders(
		lenders_id INT IDENTITY(1,1) NOT NULL CONSTRAINT Pk_lenders PRIMARY KEY CLUSTERED,
		lenders_name NVARCHAR(50) Not NuLL,
		lenders_type NVARCHAR(50) NOT NULL CHECK (lenders_type IN ('Bank','Fintech','Cooperative, Goverment, individual, Others')),
		license_number INT NULL,
		created_at DATETIME2 DEFAULT SYSDATETIME(),
		updated_at DATETIME2 DEFAULT SYSDATETIME()
	);

	DROP TABLE IF EXISTS msmes.sector
	CREATE TABLE msmes.sector(
		sector_id INT IDENTITY(1,1) NOT NULL CONSTRAINT Pk_sector PRIMARY KEY CLUSTERED,
		sector_name NVARCHAR(50) NOT NULL,
		Created_at DATETIME2 DEFAULT SYSDATETIME(),
		Updated_at DATETIME2 DEFAULT SYSDATETIME()
	);
	DROP TABLE IF EXISTS msmes.cashflow
	CREATE TABLE msmes.cashflow(
		cashflow_id INT IDENTITY(1,1) CONSTRAINT Pk_cashflow PRIMARY KEY CLUSTERED,
		sme_id INT NOT NULL, 
		transaction_type NVARCHAR(50) not null,
		transcation_date DATE NOT NULL ,
		amount DECIMAL (18,2) NOT NULL CHECK (amount > 0),
		source NVARCHAR(50) NOT NULL CHECK (source in('pos, mobile, money, cash, deposit, others')),
		Created_at DATETIME2 DEFAULT SYSDATETIME(),
		Updated_at DATETIME2 DEFAULT SYSDATETIME()
	)
END TRY
BEGIN CATCH 
	EXECUTE [dbo].[sme_geterror]
END CATCH

-- ADD FORIGN KEY CONSTRAINT TO EACH COLUMNS

ALTER TABLE msmes.small_medium_enterprice
ADD CONSTRAINT FK_sme_owner FOREIGN KEY(owner_id) REFERENCES msmes.owner(owner_id)

ALTER TABLE msmes.small_medium_enterprice 
ADD CONSTRAINT FK_sme_sector FOREIGN KEY(sector_id) REFERENCES msmes.sector(sector_id)

ALTER TABLE msmes.loans 
ADD CONSTRAINT FK_loans_sme FOREIGN KEY (sme_id ) REFERENCES msmes.small_medium_enterprice(sme_id)

ALTER TABLE msmes.loans 
ADD CONSTRAINT FK_loans_lender FOREIGN KEY(lenders_id)REFERENCES msmes.lenders(lenders_id) 

ALTER TABLE msmes.repayment
ADD CONSTRAINT Fk_repayment_loans FOREIGN KEY(loan_id) REFERENCES msmes.loans(loan_id)

ALTER TABLE msmes.cashflow 
ADD CONSTRAINT Fk_cashflow_small_medium_enterprice FOREIGN KEY(sme_id) REFERENCES msmes.small_medium_enterprice(sme_id)