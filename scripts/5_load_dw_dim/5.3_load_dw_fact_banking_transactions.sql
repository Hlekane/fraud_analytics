-- Load the warehouse transaction fact
USE [fraud_analytics_dw];


TRUNCATE TABLE [dbo].[fact_banking_transactions_dw];


INSERT INTO
  [dbo].[fact_banking_transactions_dw] (
    [transaction_id],
    [payment_channel_id],
    [authentication_type_id],
    [transaction_amount],
    [login_attempts],
    [device_risk_score],
    [transfer_frequency],
    [anomaly_score],
    [account_age_days],
    [transaction_time_hour],
    [failed_transactions_last_30d],
    [avg_monthly_balance],
    [daily_transaction_count],
    [geo_distance_km],
    [session_duration_minutes],
    [transaction_velocity_score],
    [card_present_flag],
    [international_transaction_flag],
    [suspicious_ip_flag],
    [fraud_flag]
  )
SELECT
  f.[transaction_id],
  p.[payment_channel_id],
  a.[authentication_type_id],
  f.[transaction_amount],
  f.[login_attempts],
  f.[device_risk_score],
  f.[transfer_frequency],
  f.[anomaly_score],
  f.[account_age_days],
  f.[transaction_time_hour],
  f.[failed_transactions_last_30d],
  f.[avg_monthly_balance],
  f.[daily_transaction_count],
  f.[geo_distance_km],
  f.[session_duration_minutes],
  f.[transaction_velocity_score],
  f.[card_present_flag],
  f.[international_transaction_flag],
  f.[suspicious_ip_flag],
  f.[fraud_flag]
FROM
  [fraud_analytics_stg].[dbo].[fact_banking_transactions_clean] AS f
  INNER JOIN [fraud_analytics_stg].[dbo].[dim_payment_channel_clean] AS sp ON f.[payment_channel_id] = sp.[payment_channel_id]
  INNER JOIN [dbo].[dim_payment_channel_dw] AS p ON sp.[payment_channel] = p.[payment_channel]
  INNER JOIN [fraud_analytics_stg].[dbo].[dim_authentication_type_clean] AS sa ON f.[authentication_type_id] = sa.[authentication_type_id]
  INNER JOIN [dbo].[dim_authentication_type_dw] AS a ON sa.[authentication_type] = a.[authentication_type];