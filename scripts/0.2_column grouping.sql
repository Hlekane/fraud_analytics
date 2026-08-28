-- Group source columns for analysis
-- Group payment channel columns
SELECT
  [payment_channel]
FROM
  fraud_analytics_stg.[dbo].[banking_transactions] -- Group authentication columns
SELECT
  [authentication_type]
FROM
  fraud_analytics_stg.[dbo].[banking_transactions] -- Group fact columns
SELECT
  [transaction_id],
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
FROM
  fraud_analytics_stg.[dbo].[banking_transactions]