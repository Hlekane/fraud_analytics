/* exploratory data analysis*/

-- dim_payment_channel 
SELECT 
	[payment_channel]
FROM fraud_analytics_stg.[dbo].[banking_transactions]


-- dim_authentication_type
SELECT 
	[authentication_type]
FROM fraud_analytics_stg.[dbo].[banking_transactions]


-- fact_banking_transactions
-- there are columns with missing values. 
SELECT
 	SUM(CASE WHEN [transaction_id] IS NULL THEN 1 ELSE 0 END) AS Trans_id_nulls,
	SUM(CASE WHEN [transaction_amount] IS NULL THEN 1 ELSE 0 END) AS Trans_amount_nulls,
	SUM(CASE WHEN [login_attempts] IS NULL THEN 1 ELSE 0 END) AS login_attempt_nulls , 
	SUM(CASE WHEN [device_risk_score] IS NULL THEN 1 ELSE 0 END) AS device_risk_nulls, 
	SUM(CASE WHEN [transfer_frequency] IS NULL THEN 1 ELSE 0 END) AS trans_frequency,
	SUM(CASE WHEN [anomaly_score] IS NULL THEN 1 ELSE 0 END) AS anomaly_score_nulls,
	SUM(CASE WHEN [account_age_days] IS NULL THEN 1 ELSE 0 END) AS account_age_nulls,
	SUM(CASE WHEN [transaction_time_hour] IS NULL THEN 1 ELSE 0 END) AS trans_time_nulls,
	SUM(CASE WHEN [failed_transactions_last_30d] IS NULL THEN 1 ELSE 0 END) AS failed_trans_nulls,
	SUM(CASE WHEN [avg_monthly_balance] IS NULL THEN 1 ELSE 0 END) AS avg_mon_balance_nulls,
	SUM(CASE WHEN [daily_transaction_count] IS NULL THEN 1 ELSE 0 END) AS daily_trans_nulls,
	SUM(CASE WHEN [geo_distance_km] IS NULL THEN 1 ELSE 0 END) AS geo_dist_nulls, 
	SUM(CASE WHEN [session_duration_minutes] IS NULL THEN 1 ELSE 0 END) AS session_duration_nulls, 
	SUM(CASE WHEN [transaction_velocity_score] IS NULL THEN 1 ELSE 0 END) AS transaction_velocity_score_nulls,
	SUM(CASE WHEN [card_present_flag] IS NULL THEN 1 ELSE 0 END) AS card_present_nulls,
	SUM(CASE WHEN [international_transaction_flag] IS NULL THEN 1 ELSE 0 END) AS international_transaction_nulls,
	SUM(CASE WHEN [suspicious_ip_flag] IS NULL THEN 1 ELSE 0 END) AS card_present_flag_nulls,
	SUM(CASE WHEN [fraud_flag] IS NULL THEN 1 ELSE 0 END) AS suspicious_ip_flag_nulls
FROM fraud_analytics_stg.[dbo].[banking_transactions]

-- check missing values in payment_channel and authentication_type columns
SELECT 
	[payment_channel]
FROM fraud_analytics_stg.[dbo].[banking_transactions]
WHERE [payment_channel] IS NULL

-- dim_authentication_type
SELECT 
	[authentication_type]
FROM fraud_analytics_stg.[dbo].[banking_transactions]
WHERE [authentication_type] IS NULL

-- count number of rows in the fact_banking_transactions table

SELECT COUNT (*) AS total_rows
FROM fraud_analytics_stg.[dbo].[banking_transactions]

-- what columns are in the banking_transactions dataset

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'banking_transactions'

-- retrieve the first 10 rows of the banking_transactions dataset

SELECT TOP 10 *
FROM fraud_analytics_stg.[dbo].[banking_transactions]

-- check for duplicate transaction_id values in the banking_transactions dataset

SELECT   
	[transaction_id], COUNT (*)
FROM fraud_analytics_stg.[dbo].[banking_transactions]
GROUP BY [transaction_id]
HAVING COUNT (*) > 1 -- returned 50 rows.


