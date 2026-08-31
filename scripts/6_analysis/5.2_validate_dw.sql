-- Validate the warehouse load
USE [fraud_analytics_dw];


-- Check warehouse tables
SELECT
  'Warehouse tables exist' AS check_name,
  CASE
    WHEN OBJECT_ID('[dbo].[dim_payment_channel_dw]', 'U') IS NOT NULL
    AND OBJECT_ID('[dbo].[dim_authentication_type_dw]', 'U') IS NOT NULL
    AND OBJECT_ID('[dbo].[fact_banking_transactions_dw]', 'U') IS NOT NULL THEN 'PASS'
    ELSE 'FAIL'
  END AS check_result;


-- Check row counts
SELECT
  'Payment dimension row count' AS check_name,
  COUNT(*) AS row_count
FROM
  [dbo].[dim_payment_channel_dw]
UNION ALL
SELECT
  'Authentication dimension row count',
  COUNT(*)
FROM
  [dbo].[dim_authentication_type_dw]
UNION ALL
SELECT
  'Banking fact row count',
  COUNT(*)
FROM
  [dbo].[fact_banking_transactions_dw];


-- Check unique transaction IDs
SELECT
  'Fact transaction IDs are unique' AS check_name,
  CASE
    WHEN COUNT(*) = COUNT(DISTINCT [transaction_id]) THEN 'PASS'
    ELSE 'FAIL'
  END AS check_result
FROM
  [dbo].[fact_banking_transactions_dw];


-- Check missing transaction IDs
SELECT
  'Fact transaction IDs are not NULL' AS check_name,
  CASE
    WHEN COUNT(*) = 0 THEN 'PASS'
    ELSE 'FAIL'
  END AS check_result
FROM
  [dbo].[fact_banking_transactions_dw]
WHERE
  [transaction_id] IS NULL;


-- Check missing dimension keys
SELECT
  'Fact dimension keys are populated' AS check_name,
  CASE
    WHEN COUNT(*) = 0 THEN 'PASS'
    ELSE 'FAIL'
  END AS check_result
FROM
  [dbo].[fact_banking_transactions_dw]
WHERE
  [payment_channel_id] IS NULL
  OR [authentication_type_id] IS NULL;


-- Check orphaned payment keys
SELECT
  'Payment dimension keys are valid' AS check_name,
  CASE
    WHEN COUNT(*) = 0 THEN 'PASS'
    ELSE 'FAIL'
  END AS check_result
FROM
  [dbo].[fact_banking_transactions_dw] AS f
  LEFT JOIN [dbo].[dim_payment_channel_dw] AS p ON f.[payment_channel_id] = p.[payment_channel_id]
WHERE
  f.[payment_channel_id] IS NOT NULL
  AND p.[payment_channel_id] IS NULL;


-- Check orphaned authentication keys
SELECT
  'Authentication dimension keys are valid' AS check_name,
  CASE
    WHEN COUNT(*) = 0 THEN 'PASS'
    ELSE 'FAIL'
  END AS check_result
FROM
  [dbo].[fact_banking_transactions_dw] AS f
  LEFT JOIN [dbo].[dim_authentication_type_dw] AS a ON f.[authentication_type_id] = a.[authentication_type_id]
WHERE
  f.[authentication_type_id] IS NOT NULL
  AND a.[authentication_type_id] IS NULL;


-- Check login-attempt range
SELECT
  'Login attempts are between 0 and 100' AS check_name,
  CASE
    WHEN COUNT(*) = 0 THEN 'PASS'
    ELSE 'FAIL'
  END AS check_result
FROM
  [dbo].[fact_banking_transactions_dw]
WHERE
  [login_attempts] IS NOT NULL
  AND [login_attempts] NOT BETWEEN 0 AND 100;


-- Check transaction-hour range
SELECT
  'Transaction hours are between 0 and 23' AS check_name,
  CASE
    WHEN COUNT(*) = 0 THEN 'PASS'
    ELSE 'FAIL'
  END AS check_result
FROM
  [dbo].[fact_banking_transactions_dw]
WHERE
  [transaction_time_hour] IS NOT NULL
  AND [transaction_time_hour] NOT BETWEEN 0 AND 23;


-- Check fraud flags
SELECT
  'Fraud flags are valid' AS check_name,
  CASE
    WHEN COUNT(*) = 0 THEN 'PASS'
    ELSE 'FAIL'
  END AS check_result
FROM
  [dbo].[fact_banking_transactions_dw]
WHERE
  [fraud_flag] IS NOT NULL
  AND [fraud_flag] NOT IN (0, 1);