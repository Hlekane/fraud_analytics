USE [fraud_analytics_stg];


-- Create the clean authentication staging table
IF OBJECT_ID(
  '[fraud_analytics_stg].[dbo].[dim_authentication_type_clean]',
  'U'
) IS NOT NULL
DROP TABLE
  [fraud_analytics_stg].[dbo].[dim_authentication_type_clean];


CREATE TABLE
  [fraud_analytics_stg].[dbo].[dim_authentication_type_clean] (
    [authentication_type_id] INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    [authentication_type] NVARCHAR(100) NOT NULL
  );


-- Load standardized authentication types
INSERT INTO
  [fraud_analytics_stg].[dbo].[dim_authentication_type_clean] ([authentication_type])
SELECT
  DISTINCT CASE
    WHEN UPPER(TRIM(CAST([authentication_type] AS NVARCHAR(100)))) = '2FA' THEN 'TWO-FACTOR AUTHENTICATION' -- Standardize 2FA
    ELSE ISNULL(
      NULLIF(
        UPPER(TRIM(CAST([authentication_type] AS NVARCHAR(100)))),
        ''
      ),
      'UNKNOWN'
    )
  END AS [authentication_type]
FROM
  [fraud_analytics_stg].[dbo].[banking_transactions];


-- Review the clean authentication dimension
SELECT
  *
FROM
  [fraud_analytics_stg].[dbo].[dim_authentication_type_clean];