/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading Tables';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.artist';
		TRUNCATE TABLE bronze.artist;
		PRINT '>> Inserting Data Into: bronze.artist';
		BULK INSERT bronze.artist
		FROM 'C:\Users\do199\Documents\SQL\Datasets\painting\artist.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.canvas_size';
		TRUNCATE TABLE bronze.canvas_size;

		PRINT '>> Inserting Data Into: bronze.canvas_size';
		BULK INSERT bronze.canvas_size
		FROM 'C:\Users\do199\Documents\SQL\Datasets\painting\canvas_size.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.image_link';
		TRUNCATE TABLE bronze.image_link;
		PRINT '>> Inserting Data Into: bronze.image_link';
		BULK INSERT bronze.image_link
		FROM 'C:\Users\do199\Documents\SQL\Datasets\painting\image_link.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.museum';
		TRUNCATE TABLE bronze.museum;
		PRINT '>> Inserting Data Into: bronze.museum';
		BULK INSERT bronze.museum
		FROM 'C:\Users\do199\Documents\SQL\Datasets\painting\museum.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.museum_hours';
		TRUNCATE TABLE bronze.museum_hours;
		PRINT '>> Inserting Data Into: bronze.museum_hours';
		BULK INSERT bronze.museum_hours
		FROM 'C:\Users\do199\Documents\SQL\Datasets\painting\museum_hours.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.product_size';
		TRUNCATE TABLE bronze.product_size;
		PRINT '>> Inserting Data Into: bronze.product_size';
		BULK INSERT bronze.product_size
		FROM 'C:\Users\do199\Documents\SQL\Datasets\painting\product_size.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.[subject]';
		TRUNCATE TABLE bronze.[subject];
		PRINT '>> Inserting Data Into: bronze.[subject]';
		BULK INSERT bronze.[subject]
		FROM 'C:\Users\do199\Documents\SQL\Datasets\painting\subject.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.work';
		TRUNCATE TABLE bronze.work;
		PRINT '>> Inserting Data Into: bronze.work';
		BULK INSERT bronze.work
		FROM 'C:\Users\do199\Documents\SQL\Datasets\painting\work.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		CODEPAGE = '65001',
		FORMAT = 'CSV',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';



		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
