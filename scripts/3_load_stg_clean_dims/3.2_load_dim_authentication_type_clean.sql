USE [fraud_analytics_stg];


GO -- Load the authentication dimension
CREATE
OR ALTER PROCEDURE [dbo].[load_dim_authentication_type_clean] AS BEGIN
SET
  NOCOUNT ON;


-- Refresh the dimension
TRUNCATE TABLE [dbo].[dim_authentication_type_clean];


INSERT INTO
  [dbo].[dim_authentication_type_clean] ([authentication_type])
SELECT
  DISTINCT CASE
    -- Standardize 2FA
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


END;


GO -- Execute the procedure
-- EXEC [dbo].[load_dim_authentication_type_clean];