-- Create the warehouse transaction fact
USE [fraud_analytics_dw];


IF OBJECT_ID('[dbo].[fact_banking_transactions_dw]', 'U') IS NULL BEGIN
CREATE TABLE
  [dbo].[fact_banking_transactions_dw] (
    [transaction_id] INT NOT NULL PRIMARY KEY,
    [payment_channel_id] INT NULL,
    [authentication_type_id] INT NULL,
    [transaction_amount] DECIMAL(18, 2) NULL,
    [login_attempts] INT NULL,
    [device_risk_score] DECIMAL(5, 2) NULL,
    [transfer_frequency] INT NULL,
    [anomaly_score] DECIMAL(5, 4) NULL,
    [account_age_days] INT NULL,
    [transaction_time_hour] INT NULL,
    [failed_transactions_last_30d] INT NULL,
    [avg_monthly_balance] DECIMAL(18, 2) NULL,
    [daily_transaction_count] INT NULL,
    [geo_distance_km] DECIMAL(10, 2) NULL,
    [session_duration_minutes] DECIMAL(5, 2) NULL,
    [transaction_velocity_score] DECIMAL(5, 2) NULL,
    [card_present_flag] BIT NULL,
    [international_transaction_flag] BIT NULL,
    [suspicious_ip_flag] BIT NULL,
    [fraud_flag] BIT NULL
  );


END;