-- EDA, data profiling

-- return all columns and rows 
SELECT [transaction_id]
      ,[transaction_amount]
      ,[login_attempts]
      ,[device_risk_score]
      ,[transfer_frequency]
      ,[anomaly_score]
      ,[account_age_days]
      ,[transaction_time_hour]
      ,[failed_transactions_last_30d]
      ,[avg_monthly_balance]
      ,[daily_transaction_count]
      ,[geo_distance_km]
      ,[session_duration_minutes]
      ,[transaction_velocity_score]
      ,[payment_channel]
      ,[authentication_type]
      ,[card_present_flag]
      ,[international_transaction_flag]
      ,[suspicious_ip_flag]
      ,[fraud_flag]
  FROM [fraud_analytics_stg].[dbo].[banking_transactions]

  -- check for missing values in each column
  SELECT 
   SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS [transaction_id_nulls],
    SUM(CASE WHEN transaction_amount IS NULL THEN 1 ELSE 0 END) AS [transaction_amount_nulls],
    SUM(CASE WHEN login_attempts IS NULL THEN 1 ELSE 0 END) AS [login_attempts_nulls],
    SUM(CASE WHEN device_risk_score IS NULL THEN 1 ELSE 0 END) AS [device_risk_score_nulls],
    SUM(CASE WHEN transfer_frequency IS NULL THEN 1 ELSE 0 END) AS [transfer_frequency_nulls],
    SUM(CASE WHEN anomaly_score IS NULL THEN 1 ELSE 0 END) AS [anomaly_score_nulls],
    SUM(CASE WHEN account_age_days IS NULL THEN 1 ELSE 0 END) AS [account_age_days_nulls],
    SUM(CASE WHEN geo_distance_km IS NULL THEN 1  ELSE 0 END) AS geo_distance_km_nulls,
    SUM(CASE WHEN transaction_time_hour IS NULL THEN 1 ELSE 0 END) AS [transaction_time_hour_nulls],
    SUM(CASE WHEN failed_transactions_last_30d IS NULL THEN 1 ELSE 0 END) AS [failed_transactions_last_30d_nulls],
    SUM(CASE WHEN avg_monthly_balance IS NULL THEN 1 ELSE 0 END) AS [avg_monthly_balance_nulls],
    SUM(CASE WHEN daily_transaction_count IS NULL THEN 1 ELSE 0 END) AS [daily_transaction_count_nulls],
    SUM(CASE WHEN session_duration_minutes IS NULL THEN 1 ELSE 0 END) AS [session_duration_minutes_nulls],
    SUM(CASE WHEN transaction_velocity_score IS NULL THEN 1 ELSE 0 END) AS [transaction_velocity_score_nulls],
    SUM(CASE WHEN payment_channel IS NULL THEN 1 ELSE 0 END) AS [payment_channel_nulls],
    SUM(CASE WHEN card_present_flag IS NULL THEN 1 ELSE 0 END) AS [card_present_flag_nulls],
    SUM(CASE WHEN international_transaction_flag IS NULL THEN 1 ELSE 0 END) AS [international_transaction_flag_nulls],
    SUM(CASE WHEN suspicious_ip_flag IS NULL THEN 1 ELSE 0 END) AS [suspicious_ip_flag_nulls],
    SUM(CASE WHEN fraud_flag IS NULL THEN 1 ELSE 0 END) AS [fraud_flag_nulls]

  FROM [fraud_analytics_stg].[dbo].[banking_transactions]

 -- check for duplicate rows based on all columns
  SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT transaction_id) AS unique_transaction_ids,
    COUNT(*) - COUNT(DISTINCT transaction_id) AS duplicate_transaction_ids
  FROM [fraud_analytics_stg].[dbo].[banking_transactions]

  -- check for duplicate rows based on specific columns 
  SELECT transaction_id, transaction_amount, login_attempts, COUNT(*)
 FROM [fraud_analytics_stg].[dbo].[banking_transactions]
GROUP BY transaction_id, transaction_amount, login_attempts
HAVING COUNT(*) > 1;

      