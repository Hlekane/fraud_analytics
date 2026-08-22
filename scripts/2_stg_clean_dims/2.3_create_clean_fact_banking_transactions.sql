USE [fraud_analytics_stg];
GO

-- Create a clean fact table for banking transactions 
IF OBJECT_ID('[fraud_analytics_stg].[dbo].[fact_banking_transactions_clean]', 'U') IS NOT NULL
    DROP TABLE [fraud_analytics_stg].[dbo].[fact_banking_transactions_clean];
GO

-- create clean fact table with appropriate data types and foreign key constraints
CREATE TABLE [fraud_analytics_stg].[dbo].[fact_banking_transactions_clean] (
    [transaction_id] INT PRIMARY KEY,
    [payment_channel_id] INT NOT NULL,
    [authentication_type_id] INT NOT NULL,
    [transaction_amount] DECIMAL(18, 2),
    [login_attempts] INT,
    [device_risk_score] DECIMAL(5, 2),
    [transfer_frequency] INT,
    [anomaly_score] DECIMAL(5, 4),
    [account_age_days] INT,
    [transaction_time_hour] INT,
    [failed_transactions_last_30d] INT,
    [avg_monthly_balance] DECIMAL(18, 2),
    [daily_transaction_count] INT,
    [geo_distance_km] DECIMAL(10, 2),
    [session_duration_minutes] DECIMAL(5, 2),
    [transaction_velocity_score] DECIMAL(5, 2),
    [card_present_flag] BIT NULL,
    [international_transaction_flag] BIT NULL,
    [suspicious_ip_flag] BIT NULL,
    [fraud_flag] BIT NULL,

    -- Foreign Keys referencing clean dimension table Primary Keys
    CONSTRAINT fk_payment_channel
        FOREIGN KEY ([payment_channel_id]) 
        REFERENCES [fraud_analytics_stg].[dbo].[dim_payment_channel_clean]([payment_channel_id]),
        
    CONSTRAINT fk_authentication_type 
        FOREIGN KEY ([authentication_type_id]) 
        REFERENCES [fraud_analytics_stg].[dbo].[dim_authentication_type_clean]([authentication_type_id])
);
GO

-- load data from the staging table to the clean fact table 
WITH DeduplicatedTransactions AS (
    SELECT *,
        -- Deduplicate while giving priority to non-null transaction amounts
        ROW_NUMBER() OVER(
            PARTITION BY [transaction_id] 
            ORDER BY CASE WHEN [transaction_amount] IS NOT NULL THEN 0 ELSE 1 END
        ) AS row_num
    FROM [fraud_analytics_stg].[dbo].[banking_transactions]
)
INSERT INTO [fraud_analytics_stg].[dbo].[fact_banking_transactions_clean] (
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

-- Select and clean data from the deduplicated transactions
SELECT
    TRY_CONVERT(INT, src.[transaction_id]),
    
    -- Lookup Dimension Keys (fallback via COALESCE and LEFT JOIN)
    COALESCE(dp.[payment_channel_id], dp_unk.[payment_channel_id]) AS [clean_payment_channel_id],
    COALESCE(da.[authentication_type_id], da_unk.[authentication_type_id]) AS [clean_authentication_type_id],

    TRY_CONVERT(DECIMAL(18,2), src.[transaction_amount]),

    -- Clean login attempts range (0 to 100)
    CASE 
        WHEN TRY_CONVERT(INT, TRY_CONVERT(DECIMAL(10,2), src.[login_attempts])) BETWEEN 0 AND 100 
            THEN TRY_CONVERT(INT, TRY_CONVERT(DECIMAL(10,2), src.[login_attempts]))
        ELSE NULL 
    END,

    TRY_CONVERT(DECIMAL(5,2), src.[device_risk_score]),
    TRY_CONVERT(INT, src.[transfer_frequency]),
    TRY_CONVERT(DECIMAL(5,4), src.[anomaly_score]),
    TRY_CONVERT(INT, src.[account_age_days]),
    
    -- Clean transaction hours range (0 to 23)
    CASE 
        WHEN TRY_CONVERT(INT, TRY_CONVERT(DECIMAL(10,2), src.[transaction_time_hour])) BETWEEN 0 AND 23 
            THEN TRY_CONVERT(INT, TRY_CONVERT(DECIMAL(10,2), src.[transaction_time_hour]))
        ELSE NULL 
    END,

    TRY_CONVERT(INT, src.[failed_transactions_last_30d]),
    TRY_CONVERT(DECIMAL(18,2), src.[avg_monthly_balance]),
    TRY_CONVERT(INT, src.[daily_transaction_count]),
    TRY_CONVERT(DECIMAL(10,2), src.[geo_distance_km]),
    TRY_CONVERT(DECIMAL(5,2), src.[session_duration_minutes]),
    TRY_CONVERT(DECIMAL(5,2), src.[transaction_velocity_score]),

    -- Standardize Flags (Preserve NULLs to avoid false negatives)
    CASE 
        WHEN UPPER(TRIM(CAST(src.[card_present_flag] AS VARCHAR(10)))) IN ('1', 'TRUE', 'Y', 'YES') THEN 1 
        WHEN UPPER(TRIM(CAST(src.[card_present_flag] AS VARCHAR(10)))) IN ('0', 'FALSE', 'N', 'NO') THEN 0 
        ELSE NULL 
    END,
    CASE 
        WHEN UPPER(TRIM(CAST(src.[international_transaction_flag] AS VARCHAR(10)))) IN ('1', 'TRUE', 'Y', 'YES') THEN 1 
        WHEN UPPER(TRIM(CAST(src.[international_transaction_flag] AS VARCHAR(10)))) IN ('0', 'FALSE', 'N', 'NO') THEN 0 
        ELSE NULL 
    END,
    CASE 
        WHEN UPPER(TRIM(CAST(src.[suspicious_ip_flag] AS VARCHAR(10)))) IN ('1', 'TRUE', 'Y', 'YES') THEN 1 
        WHEN UPPER(TRIM(CAST(src.[suspicious_ip_flag] AS VARCHAR(10)))) IN ('0', 'FALSE', 'N', 'NO') THEN 0 
        ELSE NULL 
    END,
    CASE 
        WHEN UPPER(TRIM(CAST(src.[fraud_flag] AS VARCHAR(10)))) IN ('1', 'TRUE', 'Y', 'YES') THEN 1 
        WHEN UPPER(TRIM(CAST(src.[fraud_flag] AS VARCHAR(10)))) IN ('0', 'FALSE', 'N', 'NO') THEN 0 
        ELSE NULL 
    END

FROM DeduplicatedTransactions AS src

-- Primary Dimension Joins
LEFT JOIN [fraud_analytics_stg].[dbo].[dim_payment_channel_clean] AS dp
    ON CASE 
        WHEN UPPER(TRIM(CAST(src.[payment_channel] AS NVARCHAR(100)))) = 'MOBILE' THEN 'MOBILE APP'
        WHEN UPPER(TRIM(CAST(src.[payment_channel] AS NVARCHAR(100)))) = 'INTERNET' THEN 'WEB BANKING'
        ELSE ISNULL(NULLIF(UPPER(TRIM(CAST(src.[payment_channel] AS NVARCHAR(100)))), ''), 'UNKNOWN') 
       END = dp.[payment_channel]

LEFT JOIN [fraud_analytics_stg].[dbo].[dim_authentication_type_clean] AS da
    ON CASE 
        WHEN UPPER(TRIM(CAST(src.[authentication_type] AS NVARCHAR(100)))) = '2FA' THEN 'TWO-FACTOR AUTHENTICATION'
        ELSE ISNULL(NULLIF(UPPER(TRIM(CAST(src.[authentication_type] AS NVARCHAR(100)))), ''), 'UNKNOWN') 
       END = da.[authentication_type]

-- Fallback UNKNOWN Joins 
LEFT JOIN [fraud_analytics_stg].[dbo].[dim_payment_channel_clean] AS dp_unk 
    ON dp_unk.[payment_channel] = 'UNKNOWN'

LEFT JOIN [fraud_analytics_stg].[dbo].[dim_authentication_type_clean] AS da_unk 
    ON da_unk.[authentication_type] = 'UNKNOWN'

WHERE src.row_num = 1;
GO

-- check the loaded data
SELECT * FROM [fraud_analytics_stg].[dbo].[fact_banking_transactions_clean];
GO