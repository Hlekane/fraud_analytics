/* create clean im_payment_channel table staging*/

-- create dim_payment_channel dimension table
IF OBJECT_ID('[fraud_analytics_stg].[dbo].[dim_payment_channel_clean]', 'U') IS NOT NULL
    DROP TABLE [fraud_analytics_stg].[dbo].[dim_payment_channel_clean];
GO

CREATE TABLE [fraud_analytics_stg].[dbo].[dim_payment_channel_clean] (
    [payment_channel_id] INT IDENTITY(1,1) PRIMARY KEY,
    [payment_channel] NVARCHAR(100) NOT NULL
);
GO

-- insert clean and standardized data into dim_payment_channel_stg table
INSERT INTO [fraud_analytics_stg].[dbo].[dim_payment_channel_clean] ([payment_channel])
SELECT DISTINCT 
    CASE 
        -- Standardize raw synonyms
        WHEN UPPER(TRIM(CAST([payment_channel] AS NVARCHAR(100)))) = 'MOBILE' THEN 'MOBILE APP'
        WHEN UPPER(TRIM(CAST([payment_channel] AS NVARCHAR(100)))) = 'INTERNET' THEN 'WEB BANKING'
        -- Capitalize all values and replace NULLs
        ELSE ISNULL(UPPER(TRIM(CAST([payment_channel] AS NVARCHAR(100)))), 'UNKNOWN')
    END AS [payment_channel]
FROM [fraud_analytics_stg].[dbo].[banking_transactions];
GO

-- check the data in the dim_payment_channel_stg table
SELECT * FROM [fraud_analytics_stg].[dbo].[dim_payment_channel_clean];

