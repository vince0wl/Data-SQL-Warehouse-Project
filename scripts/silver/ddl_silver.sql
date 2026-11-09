/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

USE DataWarehouse;
GO

IF OBJECT_ID('silver.artist', 'U') IS NOT NULL
    DROP TABLE silver.artist;
GO

CREATE TABLE silver.artist (
    artist_id              INT,
    full_name              NVARCHAR(50),
    first_name             NVARCHAR(30),
    middle_names           NVARCHAR(30),
    last_name              NVARCHAR(30),
    nationality            NVARCHAR(30),
    style                  NVARCHAR(50),
    birth                  INT,
    death                  INT,
    dwh_create_date        DATETIME2 DEFAULT GETDATE()
);
GO
IF OBJECT_ID('silver.canvas_size', 'U') IS NOT NULL
    DROP TABLE silver.canvas_size;
GO

CREATE TABLE silver.canvas_size (
    size_id                INT,
    width                  INT,
    height                 INT,
    label                  NVARCHAR(50),
    dwh_create_date        DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.image_link', 'U') IS NOT NULL
    DROP TABLE silver.image_link;
GO

CREATE TABLE silver.image_link (
    work_id                INT,
    url                    NVARCHAR(MAX),
    thumbnail_small_url    NVARCHAR(MAX),
    thumbnail_large_url    NVARCHAR(MAX),
    dwh_create_date        DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.museum', 'U') IS NOT NULL
    DROP TABLE silver.museum;
GO

CREATE TABLE silver.museum (
    museum_id               INT,
    [name]                  NVARCHAR(100),
    [address]               NVARCHAR(50),
    city                    NVARCHAR(50),
    [state]                 NVARCHAR(50),
    postal                  NVARCHAR(50),
    country                 NVARCHAR(50),
    phone                   NVARCHAR(50),
    [url]                   NVARCHAR(MAX),
    dwh_create_date         DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.museum_hours', 'U') IS NOT NULL
    DROP TABLE silver.museum_hours;
GO

CREATE TABLE silver.museum_hours (
    museum_id               INT,
    [day]                   NVARCHAR(10),
    [open]                  TIME(0),
    [close]                 TIME(0),
    dwh_create_date         DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.product_size', 'U') IS NOT NULL
    DROP TABLE silver.product_size;
GO

CREATE TABLE silver.product_size (
    work_id                 INT,
    size_id                 INT,
    sale_price              DECIMAL(10,2),
    regular_price           DECIMAL(10,2),
    dwh_create_date         DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('silver.[subject]', 'U') IS NOT NULL
    DROP TABLE silver.[subject];
GO

CREATE TABLE silver.[subject] (
    work_id                 INT,
    [subject]               NVARCHAR(50),
    dwh_create_date         DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.work', 'U') IS NOT NULL
    DROP TABLE silver.work;
GO

CREATE TABLE silver.work (
    work_id                 INT,
    [name]                  NVARCHAR(500),
    artist_id               INT,
    style                   NVARCHAR(150),
    museum_id               INT,
    dwh_create_date         DATETIME2 DEFAULT GETDATE()
);
GO