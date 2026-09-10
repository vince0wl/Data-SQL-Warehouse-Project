/*
=======================================================================
CREATE THE DATABASE AND SCHEMAS
=======================================================================
This script creates a new database DataWarehouse after checking if it already exists. If it does, it's dropped and recreated.
In the next step, the script set up three schemas within the database: 'bronze', 'silver' and 'gold'.
*/

USE master;
GO

-- check and drop if DataWarehouse already exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

-- create database 'DataWarehouse
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- create the schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
