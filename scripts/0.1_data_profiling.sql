-- Profile the source data
-- Review payment channels
SELECT
  [payment_channel]
FROM
  fraud_analytics_stg.[dbo].[banking_transactions] -- Review authentication types
SELECT
  [authentication_type]
FROM
  fraud_analytics_stg.[dbo].[banking_transactions] -- Check missing fact values
SELECT
  SUM(
    CASE
      WHEN [transaction_id] IS NULL THEN 1
      ELSE 0
    END
  ) AS Trans_id_nulls,
  SUM(
    CASE
      WHEN [transaction_amount] IS NULL THEN 1
      ELSE 0
    END
  ) AS Trans_amount_nulls,
  SUM(
    CASE
      WHEN [login_attempts] IS NULL THEN 1
      ELSE 0
    END
  ) AS login_attempt_nulls,
  SUM(
    CASE
      WHEN [device_risk_score] IS NULL THEN 1
      ELSE 0
    END
  ) AS device_risk_nulls,
  SUM(
    CASE
      WHEN [transfer_frequency] IS NULL THEN 1
      ELSE 0
    END
  ) AS trans_frequency,
  SUM(
    CASE
      WHEN [anomaly_score] IS NULL THEN 1
      ELSE 0
    END
  ) AS anomaly_score_nulls,
  SUM(
    CASE
      WHEN [account_age_days] IS NULL THEN 1
      ELSE 0
    END
  ) AS account_age_nulls,
  SUM(
    CASE
      WHEN [transaction_time_hour] IS NULL THEN 1
      ELSE 0
    END
  ) AS trans_time_nulls,
  SUM(
    CASE
      WHEN [failed_transactions_last_30d] IS NULL THEN 1
      ELSE 0
    END
  ) AS failed_trans_nulls,
  SUM(
    CASE
      WHEN [avg_monthly_balance] IS NULL THEN 1
      ELSE 0
    END
  ) AS avg_mon_balance_nulls,
  SUM(
    CASE
      WHEN [daily_transaction_count] IS NULL THEN 1
      ELSE 0
    END
  ) AS daily_trans_nulls,
  SUM(
    CASE
      WHEN [geo_distance_km] IS NULL THEN 1
      ELSE 0
    END
  ) AS geo_dist_nulls,
  SUM(
    CASE
      WHEN [session_duration_minutes] IS NULL THEN 1
      ELSE 0
    END
  ) AS session_duration_nulls,
  SUM(
    CASE
      WHEN [transaction_velocity_score] IS NULL THEN 1
      ELSE 0
    END
  ) AS transaction_velocity_score_nulls,
  SUM(
    CASE
      WHEN [card_present_flag] IS NULL THEN 1
      ELSE 0
    END
  ) AS card_present_nulls,
  SUM(
    CASE
      WHEN [international_transaction_flag] IS NULL THEN 1
      ELSE 0
    END
  ) AS international_transaction_nulls,
  SUM(
    CASE
      WHEN [suspicious_ip_flag] IS NULL THEN 1
      ELSE 0
    END
  ) AS card_present_flag_nulls,
  SUM(
    CASE
      WHEN [fraud_flag] IS NULL THEN 1
      ELSE 0
    END
  ) AS suspicious_ip_flag_nulls
FROM
  fraud_analytics_stg.[dbo].[banking_transactions] -- Check missing payment channels
SELECT
  [payment_channel]
FROM
  fraud_analytics_stg.[dbo].[banking_transactions]
WHERE
  [payment_channel] IS NULL -- Check missing authentication types
SELECT
  [authentication_type]
FROM
  fraud_analytics_stg.[dbo].[banking_transactions]
WHERE
  [authentication_type] IS NULL -- Count source rows
SELECT
  COUNT (*) AS total_rows
FROM
  fraud_analytics_stg.[dbo].[banking_transactions] -- List source columns
SELECT
  *
FROM
  INFORMATION_SCHEMA.COLUMNS
WHERE
  TABLE_NAME = 'banking_transactions' -- Review sample source rows
SELECT
  TOP 10 *
FROM
  fraud_analytics_stg.[dbo].[banking_transactions] -- Check duplicate transaction IDs
SELECT
  [transaction_id],
  COUNT (*)
FROM
  fraud_analytics_stg.[dbo].[banking_transactions]
GROUP BY
  [transaction_id]
HAVING
  COUNT (*) > 1;