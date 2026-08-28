-- Create and load the clean transaction fact
USE [fraud_analytics_stg];


IF OBJECT_ID('[dbo].[fact_banking_transactions_clean]', 'U') IS NOT NULL BEGIN
DROP TABLE
  [dbo].[fact_banking_transactions_clean];


END;


CREATE TABLE
  [dbo].[fact_banking_transactions_clean] (
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


-- Clean and deduplicate transactions
;


WITH
  DeduplicatedTransactions AS (
    SELECT
      *,
      ROW_NUMBER() OVER (
        PARTITION BY TRY_CONVERT(INT, TRIM(CAST([transaction_id] AS VARCHAR(50))))
        ORDER BY
          CASE
            WHEN TRY_CONVERT(DECIMAL(18, 2), [transaction_amount]) IS NOT NULL THEN 0
            ELSE 1
          END,
          [transaction_id] ASC
      ) AS row_num
    FROM
      [dbo].[banking_transactions]
  )
INSERT INTO
  [dbo].[fact_banking_transactions_clean] (
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
  TRY_CONVERT(INT, TRIM(CAST(dt.[transaction_id] AS VARCHAR(50)))),
  dp.[payment_channel_id],
  da.[authentication_type_id],
  TRY_CONVERT(DECIMAL(18, 2), dt.[transaction_amount]),
  CASE
    WHEN TRY_CONVERT(
      INT,
      TRY_CONVERT(DECIMAL(10, 2), dt.[login_attempts])
    ) BETWEEN 0 AND 100 THEN TRY_CONVERT(
      INT,
      TRY_CONVERT(DECIMAL(10, 2), dt.[login_attempts])
    )
    ELSE NULL
  END,
  TRY_CONVERT(DECIMAL(5, 2), dt.[device_risk_score]),
  TRY_CONVERT(INT, dt.[transfer_frequency]),
  TRY_CONVERT(DECIMAL(5, 4), dt.[anomaly_score]),
  TRY_CONVERT(INT, dt.[account_age_days]),
  CASE
    WHEN TRY_CONVERT(
      INT,
      TRY_CONVERT(DECIMAL(10, 2), dt.[transaction_time_hour])
    ) BETWEEN 0 AND 23 THEN TRY_CONVERT(
      INT,
      TRY_CONVERT(DECIMAL(10, 2), dt.[transaction_time_hour])
    )
    ELSE NULL
  END,
  TRY_CONVERT(INT, dt.[failed_transactions_last_30d]),
  TRY_CONVERT(DECIMAL(18, 2), dt.[avg_monthly_balance]),
  TRY_CONVERT(INT, dt.[daily_transaction_count]),
  TRY_CONVERT(DECIMAL(10, 2), dt.[geo_distance_km]),
  TRY_CONVERT(DECIMAL(5, 2), dt.[session_duration_minutes]),
  TRY_CONVERT(DECIMAL(5, 2), dt.[transaction_velocity_score]),
  CASE
    WHEN UPPER(TRIM(CAST(dt.[card_present_flag] AS VARCHAR(10)))) IN ('1', 'TRUE', 'Y', 'YES') THEN 1
    WHEN UPPER(TRIM(CAST(dt.[card_present_flag] AS VARCHAR(10)))) IN ('0', 'FALSE', 'N', 'NO') THEN 0
    ELSE NULL
  END,
  CASE
    WHEN UPPER(
      TRIM(
        CAST(dt.[international_transaction_flag] AS VARCHAR(10))
      )
    ) IN ('1', 'TRUE', 'Y', 'YES') THEN 1
    WHEN UPPER(
      TRIM(
        CAST(dt.[international_transaction_flag] AS VARCHAR(10))
      )
    ) IN ('0', 'FALSE', 'N', 'NO') THEN 0
    ELSE NULL
  END,
  CASE
    WHEN UPPER(TRIM(CAST(dt.[suspicious_ip_flag] AS VARCHAR(10)))) IN ('1', 'TRUE', 'Y', 'YES') THEN 1
    WHEN UPPER(TRIM(CAST(dt.[suspicious_ip_flag] AS VARCHAR(10)))) IN ('0', 'FALSE', 'N', 'NO') THEN 0
    ELSE NULL
  END,
  CASE
    WHEN UPPER(TRIM(CAST(dt.[fraud_flag] AS VARCHAR(10)))) IN ('1', 'TRUE', 'Y', 'YES') THEN 1
    WHEN UPPER(TRIM(CAST(dt.[fraud_flag] AS VARCHAR(10)))) IN ('0', 'FALSE', 'N', 'NO') THEN 0
    ELSE NULL
  END
FROM
  DeduplicatedTransactions AS dt CROSS APPLY (
    SELECT
      CASE
        WHEN UPPER(TRIM(CAST(dt.[payment_channel] AS NVARCHAR(100)))) = 'MOBILE' THEN 'MOBILE APP'
        WHEN UPPER(TRIM(CAST(dt.[payment_channel] AS NVARCHAR(100)))) = 'INTERNET' THEN 'WEB BANKING'
        ELSE ISNULL(
          NULLIF(
            UPPER(TRIM(CAST(dt.[payment_channel] AS NVARCHAR(100)))),
            ''
          ),
          'UNKNOWN'
        )
      END AS [clean_payment_channel]
  ) AS pc CROSS APPLY (
    SELECT
      CASE
        WHEN UPPER(
          TRIM(CAST(dt.[authentication_type] AS NVARCHAR(100)))
        ) = '2FA' THEN 'TWO-FACTOR AUTHENTICATION'
        ELSE ISNULL(
          NULLIF(
            UPPER(
              TRIM(CAST(dt.[authentication_type] AS NVARCHAR(100)))
            ),
            ''
          ),
          'UNKNOWN'
        )
      END AS [clean_authentication_type]
  ) AS at
  LEFT JOIN (
    SELECT
      [payment_channel],
      MIN([payment_channel_id]) AS [payment_channel_id]
    FROM
      [dbo].[dim_payment_channel_clean]
    GROUP BY
      [payment_channel]
  ) AS dp ON pc.[clean_payment_channel] = dp.[payment_channel]
  LEFT JOIN (
    SELECT
      [authentication_type],
      MIN([authentication_type_id]) AS [authentication_type_id]
    FROM
      [dbo].[dim_authentication_type_clean]
    GROUP BY
      [authentication_type]
  ) AS da ON at.[clean_authentication_type] = da.[authentication_type]
WHERE
  dt.[row_num] = 1
  AND TRY_CONVERT(INT, TRIM(CAST(dt.[transaction_id] AS VARCHAR(50)))) IS NOT NULL;