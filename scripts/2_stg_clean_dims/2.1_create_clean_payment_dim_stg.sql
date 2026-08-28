-- Create the clean payment channel staging table
USE [fraud_analytics_stg];


-- Recreate the clean dimension
IF OBJECT_ID(
  '[fraud_analytics_stg].[dbo].[dim_payment_channel_clean]',
  'U'
) IS NOT NULL
DROP TABLE
  [fraud_analytics_stg].[dbo].[dim_payment_channel_clean];


CREATE TABLE
  [fraud_analytics_stg].[dbo].[dim_payment_channel_clean] (
    [payment_channel_id] INT IDENTITY(1, 1) PRIMARY KEY,
    [payment_channel] NVARCHAR(100) NOT NULL
  );


-- Load standardized payment channels
INSERT INTO
  [fraud_analytics_stg].[dbo].[dim_payment_channel_clean] ([payment_channel])
SELECT
  DISTINCT CASE
    -- Standardize channel names
    WHEN UPPER(TRIM(CAST([payment_channel] AS NVARCHAR(100)))) = 'MOBILE' THEN 'MOBILE APP'
    WHEN UPPER(TRIM(CAST([payment_channel] AS NVARCHAR(100)))) = 'INTERNET' THEN 'WEB BANKING' -- Normalize case and missing values
    ELSE ISNULL(
      NULLIF(
        UPPER(TRIM(CAST([payment_channel] AS NVARCHAR(100)))),
        ''
      ),
      'UNKNOWN'
    )
  END AS [payment_channel]
FROM
  [fraud_analytics_stg].[dbo].[banking_transactions];


-- Review the clean payment dimension
SELECT
  *
FROM
  [fraud_analytics_stg].[dbo].[dim_payment_channel_clean];