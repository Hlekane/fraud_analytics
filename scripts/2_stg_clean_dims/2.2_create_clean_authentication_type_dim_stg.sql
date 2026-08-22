/* create clean dim_authentication_type table staging*/

-- dim_authentication_type dimension table clean
IF OBJECT_ID('[fraud_analytics_stg].[dbo].[fact_banking_transactions_clean]', 'U') IS NOT NULL
    DROP TABLE [fraud_analytics_stg].[dbo].[fact_banking_transactions_clean];

CREATE TABLE [fraud_analytics_stg].[dbo].[dim_authentication_type_clean] (
    [authentication_type_id] INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    [authentication_type] NVARCHAR(100) NOT NULL
);
GO

-- insert clean and standardized authentication types into the staging table
INSERT INTO [fraud_analytics_stg].[dbo].[dim_authentication_type_clean] (
    [authentication_type]
)
SELECT DISTINCT 
    CASE 
        -- give 2FA to standard name
        WHEN UPPER(TRIM(CAST([authentication_type] AS NVARCHAR(100)))) = '2FA' 
            THEN 'TWO-FACTOR AUTHENTICATION'
        -- Capitalize all strings to force duplicate elimination
        ELSE ISNULL(UPPER(TRIM(CAST([authentication_type] AS NVARCHAR(100)))), 'UNKNOWN')
    END AS [authentication_type]
FROM [fraud_analytics_stg].[dbo].[banking_transactions];
GO

-- Verify the inserted data
SELECT * FROM [fraud_analytics_stg].[dbo].[dim_authentication_type_clean];