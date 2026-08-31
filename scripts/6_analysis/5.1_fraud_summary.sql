-- Summarize fraud results
USE [fraud_analytics_dw];


-- Summarize overall fraud
SELECT
  COUNT(*) AS total_transactions,
  SUM(
    CASE
      WHEN [fraud_flag] = 1 THEN 1
      ELSE 0
    END
  ) AS fraud_transactions,
  CAST(
    100.0 * SUM(
      CASE
        WHEN [fraud_flag] = 1 THEN 1
        ELSE 0
      END
    ) / NULLIF(COUNT(*), 0) AS DECIMAL(5, 2)
  ) AS fraud_rate_percent,
  SUM(
    CASE
      WHEN [fraud_flag] = 1 THEN [transaction_amount]
      ELSE 0
    END
  ) AS fraud_transaction_value
FROM
  [dbo].[fact_banking_transactions_dw];


-- Summarize fraud by payment channel
SELECT
  [payment_channel],
  COUNT(*) AS total_transactions,
  SUM(
    CASE
      WHEN f.[fraud_flag] = 1 THEN 1
      ELSE 0
    END
  ) AS fraud_transactions,
  CAST(
    100.0 * SUM(
      CASE
        WHEN f.[fraud_flag] = 1 THEN 1
        ELSE 0
      END
    ) / NULLIF(COUNT(*), 0) AS DECIMAL(5, 2)
  ) AS fraud_rate_percent
FROM
  [dbo].[fact_banking_transactions_dw] AS f
  LEFT JOIN [dbo].[dim_payment_channel_dw] AS p ON f.[payment_channel_id] = p.[payment_channel_id]
GROUP BY
  [payment_channel]
ORDER BY
  fraud_rate_percent DESC;


-- Summarize fraud by authentication type
SELECT
  [authentication_type],
  COUNT(*) AS total_transactions,
  SUM(
    CASE
      WHEN f.[fraud_flag] = 1 THEN 1
      ELSE 0
    END
  ) AS fraud_transactions,
  CAST(
    100.0 * SUM(
      CASE
        WHEN f.[fraud_flag] = 1 THEN 1
        ELSE 0
      END
    ) / NULLIF(COUNT(*), 0) AS DECIMAL(5, 2)
  ) AS fraud_rate_percent
FROM
  [dbo].[fact_banking_transactions_dw] AS f
  LEFT JOIN [dbo].[dim_authentication_type_dw] AS a ON f.[authentication_type_id] = a.[authentication_type_id]
GROUP BY
  [authentication_type]
ORDER BY
  fraud_rate_percent DESC;