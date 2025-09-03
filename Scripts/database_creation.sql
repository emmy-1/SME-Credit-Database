/*
=======================================================================================
CREATE OR REPLACE DATABASE AND SCHEMA 
=======================================================================================
The following script creates a database called "sme_credit."
It first checks if the database already exists; if it does, the script drops 
the existing database and creates a new one. After that, it creates schema called sme.

WARNING:
	If you run this script, it will drop the sme_database Database and its data content
	if it happens to exist. Please ensure you have backed up the database before running this script. 
	Please visit:https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/create-a-full-database-backup-sql-server?view=sql-server-ver16
	for more information about backing up a database.
*/


-- USE MASTER USER 
USE MASTER;
GO;
-- check if sme_credit db exist. drop if it does
IF DB_ID('sme_credit') IS NOT NULL DROP DATABASE sme_credit;
CREATE DATABASE sme_credit;
GO;
USE sme_credit;
GO;
CREATE SCHEMA MSMEs;