-- EDA, data profiling


-- check total number of records
SELECT 
    COUNT(*) AS total_rows
FROM fraud_analytics_stg.dbo.banking_transactions;


-- check the column definitions and data types
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'banking_transactions'
ORDER BY ORDINAL_POSITION;


-- check for missing values in each column
SELECT  
    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS transaction_id_nulls,
    SUM(CASE WHEN transaction_amount IS NULL THEN 1 ELSE 0 END) AS transaction_amount_nulls,
    SUM(CASE WHEN login_attempts IS NULL THEN 1 ELSE 0 END) AS login_attempts_nulls,
    SUM(CASE WHEN device_risk_score IS NULL THEN 1 ELSE 0 END) AS device_risk_score_nulls,
    SUM(CASE WHEN transfer_frequency IS NULL THEN 1 ELSE 0 END) AS transfer_frequency_nulls,
    SUM(CASE WHEN anomaly_score IS NULL THEN 1 ELSE 0 END) AS anomaly_score_nulls,
    SUM(CASE WHEN account_age_days IS NULL THEN 1 ELSE 0 END) AS account_age_days_nulls,
    SUM(CASE WHEN transaction_time_hour IS NULL THEN 1 ELSE 0 END) AS transaction_time_hour_nulls,
    SUM(CASE WHEN failed_transactions_last_30d IS NULL THEN 1 ELSE 0 END) AS failed_transactions_last_30d_nulls,
    SUM(CASE WHEN avg_monthly_balance IS NULL THEN 1 ELSE 0 END) AS avg_monthly_balance_nulls,
    SUM(CASE WHEN daily_transaction_count IS NULL THEN 1 ELSE 0 END) AS daily_transaction_count_nulls,
    SUM(CASE WHEN geo_distance_km IS NULL THEN 1 ELSE 0 END) AS geo_distance_km_nulls,
    SUM(CASE WHEN session_duration_minutes IS NULL THEN 1 ELSE 0 END) AS session_duration_minutes_nulls,
    SUM(CASE WHEN transaction_velocity_score IS NULL THEN 1 ELSE 0 END) AS transaction_velocity_score_nulls,
    SUM(CASE WHEN payment_channel IS NULL THEN 1 ELSE 0 END) AS payment_channel_nulls,
    SUM(CASE WHEN authentication_type IS NULL THEN 1 ELSE 0 END) AS authentication_type_nulls,
    SUM(CASE WHEN card_present_flag IS NULL THEN 1 ELSE 0 END) AS card_present_flag_nulls,
    SUM(CASE WHEN international_transaction_flag IS NULL THEN 1 ELSE 0 END) AS international_transaction_flag_nulls,
    SUM(CASE WHEN suspicious_ip_flag IS NULL THEN 1 ELSE 0 END) AS suspicious_ip_flag_nulls,
    SUM(CASE WHEN fraud_flag IS NULL THEN 1 ELSE 0 END) AS fraud_flag_nulls
FROM fraud_analytics_stg.dbo.banking_transactions;


-- check for duplicate transaction IDs
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT transaction_id) AS unique_transaction_ids,
    COUNT(*) - COUNT(DISTINCT transaction_id) AS duplicate_transaction_ids
FROM fraud_analytics_stg.dbo.banking_transactions;


-- show duplicated transaction IDs
SELECT
    transaction_id,
    COUNT(*) AS occurrence_count
FROM fraud_analytics_stg.dbo.banking_transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;


-- check whether numeric columns stored as nvarchar can be converted
SELECT
    COUNT(*) AS total_rows,

    SUM(CASE 
        WHEN TRY_CONVERT(decimal(18,2), transaction_amount) IS NULL
             AND transaction_amount IS NOT NULL
        THEN 1 ELSE 0
    END) AS invalid_transaction_amount,

    SUM(CASE 
        WHEN TRY_CONVERT(decimal(10,2), login_attempts) IS NULL
             AND login_attempts IS NOT NULL
        THEN 1 ELSE 0
    END) AS invalid_login_attempts,

    SUM(CASE 
        WHEN TRY_CONVERT(decimal(10,4), device_risk_score) IS NULL
             AND device_risk_score IS NOT NULL
        THEN 1 ELSE 0
    END) AS invalid_device_risk_score,

    SUM(CASE 
        WHEN TRY_CONVERT(decimal(10,4), transfer_frequency) IS NULL
             AND transfer_frequency IS NOT NULL
        THEN 1 ELSE 0
    END) AS invalid_transfer_frequency,

    SUM(CASE 
        WHEN TRY_CONVERT(decimal(10,4), anomaly_score) IS NULL
             AND anomaly_score IS NOT NULL
        THEN 1 ELSE 0
    END) AS invalid_anomaly_score,

    SUM(CASE 
        WHEN TRY_CONVERT(int, transaction_time_hour) IS NULL
             AND transaction_time_hour IS NOT NULL
        THEN 1 ELSE 0
    END) AS invalid_transaction_time_hour,

    SUM(CASE 
        WHEN TRY_CONVERT(int, failed_transactions_last_30d) IS NULL
             AND failed_transactions_last_30d IS NOT NULL
        THEN 1 ELSE 0
    END) AS invalid_failed_transactions,

    SUM(CASE 
        WHEN TRY_CONVERT(decimal(18,2), avg_monthly_balance) IS NULL
             AND avg_monthly_balance IS NOT NULL
        THEN 1 ELSE 0
    END) AS invalid_avg_monthly_balance,

    SUM(CASE 
        WHEN TRY_CONVERT(int, daily_transaction_count) IS NULL
             AND daily_transaction_count IS NOT NULL
        THEN 1 ELSE 0
    END) AS invalid_daily_transaction_count,

    SUM(CASE 
        WHEN TRY_CONVERT(decimal(18,2), geo_distance_km) IS NULL
             AND geo_distance_km IS NOT NULL
        THEN 1 ELSE 0
    END) AS invalid_geo_distance,

    SUM(CASE 
        WHEN TRY_CONVERT(decimal(18,2), session_duration_minutes) IS NULL
             AND session_duration_minutes IS NOT NULL
        THEN 1 ELSE 0
    END) AS invalid_session_duration,

    SUM(CASE 
        WHEN TRY_CONVERT(decimal(10,4), transaction_velocity_score) IS NULL
             AND transaction_velocity_score IS NOT NULL
        THEN 1 ELSE 0
    END) AS invalid_velocity_score

FROM fraud_analytics_stg.dbo.banking_transactions;


-- check minimum and maximum values for important numeric columns
SELECT
    MIN(TRY_CONVERT(decimal(18,2), transaction_amount)) AS min_transaction_amount,
    MAX(TRY_CONVERT(decimal(18,2), transaction_amount)) AS max_transaction_amount,

    MIN(account_age_days) AS min_account_age_days,
    MAX(account_age_days) AS max_account_age_days,

    MIN(TRY_CONVERT(decimal(10,4), device_risk_score)) AS min_device_risk_score,
    MAX(TRY_CONVERT(decimal(10,4), device_risk_score)) AS max_device_risk_score,

    MIN(TRY_CONVERT(decimal(10,4), anomaly_score)) AS min_anomaly_score,
    MAX(TRY_CONVERT(decimal(10,4), anomaly_score)) AS max_anomaly_score,

    MIN(TRY_CONVERT(decimal(10,4), transaction_velocity_score)) AS min_transaction_velocity_score,
    MAX(TRY_CONVERT(decimal(10,4), transaction_velocity_score)) AS max_transaction_velocity_score

FROM fraud_analytics_stg.dbo.banking_transactions;


-- check for values that violate basic business rules
SELECT
    COUNT(*) AS invalid_transaction_amounts
FROM fraud_analytics_stg.dbo.banking_transactions
WHERE TRY_CONVERT(decimal(18,2), transaction_amount) < 0;


SELECT
    COUNT(*) AS invalid_account_age
FROM fraud_analytics_stg.dbo.banking_transactions
WHERE account_age_days < 0;


SELECT
    COUNT(*) AS invalid_transaction_hours
FROM fraud_analytics_stg.dbo.banking_transactions
WHERE TRY_CONVERT(int, transaction_time_hour) NOT BETWEEN 0 AND 23;


-- check for categorical value consistency in payment_channel
SELECT
    payment_channel,
    COUNT(*) AS transaction_count
FROM fraud_analytics_stg.dbo.banking_transactions
GROUP BY payment_channel
ORDER BY transaction_count DESC;


-- check for categorical value consistency in authentication_type
SELECT
    authentication_type,
    COUNT(*) AS transaction_count
FROM fraud_analytics_stg.dbo.banking_transactions
GROUP BY authentication_type
ORDER BY transaction_count DESC;


-- check for categorical value consistency in card_present_flag, international_transaction_flag, suspicious_ip_flag
SELECT
    'card_present_flag' AS column_name,
    card_present_flag AS value,
    COUNT(*) AS occurrences
FROM fraud_analytics_stg.dbo.banking_transactions
GROUP BY card_present_flag

UNION ALL

SELECT
    'international_transaction_flag',
    international_transaction_flag,
    COUNT(*)
FROM fraud_analytics_stg.dbo.banking_transactions
GROUP BY international_transaction_flag

UNION ALL

SELECT
    'suspicious_ip_flag',
    suspicious_ip_flag,
    COUNT(*)
FROM fraud_analytics_stg.dbo.banking_transactions
GROUP BY suspicious_ip_flag;


-- check how many transactions are flagged as fraudulent vs non-fraudulent
SELECT
    fraud_flag,
    COUNT(*) AS transaction_count,
    CAST(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()
        AS decimal(5,2)
    ) AS percentage
FROM fraud_analytics_stg.dbo.banking_transactions
GROUP BY fraud_flag
ORDER BY fraud_flag;


-- compare important transaction characteristics between fraudulent and legitimate transactions
SELECT
    fraud_flag,
    COUNT(*) AS transaction_count,

    AVG(TRY_CONVERT(decimal(18,2), transaction_amount)) AS avg_transaction_amount,

    AVG(TRY_CONVERT(decimal(10,4), device_risk_score)) AS avg_device_risk_score,

    AVG(TRY_CONVERT(decimal(10,4), anomaly_score)) AS avg_anomaly_score,

    AVG(TRY_CONVERT(decimal(10,4), transaction_velocity_score)) AS avg_transaction_velocity_score,

    AVG(account_age_days) AS avg_account_age_days

FROM fraud_analytics_stg.dbo.banking_transactions
GROUP BY fraud_flag
ORDER BY fraud_flag;