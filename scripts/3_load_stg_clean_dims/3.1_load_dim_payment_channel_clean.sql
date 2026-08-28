USE [fraud_analytics_stg];


GO -- Load the payment channel dimension
CREATE
OR ALTER PROCEDURE [dbo].[load_dim_payment_channel_clean] AS BEGIN
SET
  NOCOUNT ON;


-- Refresh the dimension
TRUNCATE TABLE [dbo].[dim_payment_channel_clean];


-- Load standardized values
INSERT INTO
  [dbo].[dim_payment_channel_clean] ([payment_channel])
SELECT
  DISTINCT CASE
    WHEN UPPER(TRIM(CAST([payment_channel] AS NVARCHAR(100)))) = 'MOBILE' THEN 'MOBILE APP'
    WHEN UPPER(TRIM(CAST([payment_channel] AS NVARCHAR(100)))) = 'INTERNET' THEN 'WEB BANKING'
    ELSE ISNULL(
      UPPER(TRIM(CAST([payment_channel] AS NVARCHAR(100)))),
      'UNKNOWN'
    )
  END AS [payment_channel]
FROM
  [fraud_analytics_stg].[dbo].[banking_transactions];


END;


GO -- Execute the procedure
-- EXEC load_dim_payment_channel_clean;