-- 1. What proportion and total value of transactions are fraudulent?
SELECT 
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN [fraud_flag] = 1 THEN 1 ELSE 0 END) AS fraudulent_transactions,
    SUM(CASE WHEN [fraud_flag] = 1 THEN [transaction_amount] ELSE 0 END) AS total_fraudulent_value,
    CAST(
        100.0 * SUM(CASE WHEN [fraud_flag] = 1 THEN 1 ELSE 0 END) 
        / NULLIF(COUNT(*), 0) 
        AS DECIMAL(5, 2)
    ) AS fraud_rate_percent
FROM [dbo].[fact_banking_transactions_dw];

-- 2. Which payment channels have the highest fraud rates and financial exposure?

SELECT 
    dp.[payment_channel],
    COUNT(f.[transaction_id]) AS total_transactions,
    SUM(CASE WHEN f.[fraud_flag] = 1 THEN 1 ELSE 0 END) AS fraudulent_transactions,
    SUM(CASE WHEN f.[fraud_flag] = 1 THEN f.[transaction_amount] ELSE 0 END) AS total_fraudulent_value,
    CAST(
        100.0 * SUM(CASE WHEN f.[fraud_flag] = 1 THEN 1 ELSE 0 END) 
        / NULLIF(COUNT(f.[transaction_id]), 0) 
        AS DECIMAL(5, 2)
    ) AS fraud_rate_percent
FROM [dbo].[fact_banking_transactions_dw] AS f
LEFT JOIN [dbo].[dim_payment_channel_dw] AS dp
    ON f.[payment_channel_id] = dp.[payment_channel_id]
GROUP BY 
    dp.[payment_channel]
ORDER BY 
    fraud_rate_percent DESC,
    total_fraudulent_value DESC;

-- 3. Which authentication methods are most strongly associated with fraudulent transactions?

SELECT 
    da.[authentication_type],
    COUNT(f.[transaction_id]) AS total_transactions,
    SUM(CASE WHEN f.[fraud_flag] = 1 THEN 1 ELSE 0 END) AS fraudulent_transactions,
    SUM(CASE WHEN f.[fraud_flag] = 1 THEN f.[transaction_amount] ELSE 0 END) AS total_fraudulent_value,
    CAST(
        100.0 * SUM(CASE WHEN f.[fraud_flag] = 1 THEN 1 ELSE 0 END) 
        / NULLIF(COUNT(f.[transaction_id]), 0) 
        AS DECIMAL(5, 2)
    ) AS fraud_rate_percent
FROM [dbo].[fact_banking_transactions_dw] AS f
LEFT JOIN [dbo].[dim_authentication_type_dw] AS da
    ON f.[authentication_type_id] = da.[authentication_type_id]
GROUP BY 
    da.[authentication_type]
ORDER BY 
    fraud_rate_percent DESC,
    total_fraudulent_value DESC;
    

 -- 4. Are international or card-not-present transactions more likely to be fraudulent?
SELECT 
    CASE 
        WHEN f.[international_transaction_flag] = 1 AND f.[card_present_flag] = 0 
            THEN 'International Card-Not-Present'
        WHEN f.[international_transaction_flag] = 1 AND f.[card_present_flag] = 1 
            THEN 'International Card Present'
        WHEN f.[international_transaction_flag] = 0 AND f.[card_present_flag] = 0 
            THEN 'Domestic Card-Not-Present'
        ELSE 'Domestic Card Present'
    END AS risk_category,
    
    COUNT(f.[transaction_id]) AS total_transactions,
    SUM(CASE WHEN f.[fraud_flag] = 1 THEN 1 ELSE 0 END) AS fraudulent_transactions,
    SUM(CASE WHEN f.[fraud_flag] = 1 THEN f.[transaction_amount] ELSE 0 END) AS total_fraudulent_value,
    
    CAST(
        100.0 * SUM(CASE WHEN f.[fraud_flag] = 1 THEN 1 ELSE 0 END) 
        / NULLIF(COUNT(f.[transaction_id]), 0) 
        AS DECIMAL(5, 2)
    ) AS fraud_rate_percent

FROM [dbo].[fact_banking_transactions_dw] AS f
GROUP BY 
    CASE 
        WHEN f.[international_transaction_flag] = 1 AND f.[card_present_flag] = 0 
            THEN 'International Card-Not-Present'
        WHEN f.[international_transaction_flag] = 1 AND f.[card_present_flag] = 1 
            THEN 'International Card Present'
        WHEN f.[international_transaction_flag] = 0 AND f.[card_present_flag] = 0 
            THEN 'Domestic Card-Not-Present'
        ELSE 'Domestic Card Present'
    END
ORDER BY 
    fraud_rate_percent DESC,
    total_fraudulent_value DESC;

-- 5. Are suspicious IP addresses associated with higher fraud rates?
SELECT 
    CASE 
        WHEN f.[suspicious_ip_flag] = 1 THEN 'Suspicious IP' 
        ELSE 'Non-Suspicious IP' 
    END AS ip_status,
    COUNT(f.[transaction_id]) AS total_transactions,
    SUM(CASE WHEN f.[fraud_flag] = 1 THEN 1 ELSE 0 END) AS fraudulent_transactions,
    SUM(CASE WHEN f.[fraud_flag] = 1 THEN f.[transaction_amount] ELSE 0 END) AS total_fraudulent_value,
    CAST(
        100.0 * SUM(CASE WHEN f.[fraud_flag] = 1 THEN 1 ELSE 0 END) 
        / NULLIF(COUNT(f.[transaction_id]), 0) 
        AS DECIMAL(5, 2)
    ) AS fraud_rate_percent
FROM [dbo].[fact_banking_transactions_dw] AS f
GROUP BY 
    CASE 
        WHEN f.[suspicious_ip_flag] = 1 THEN 'Suspicious IP' 
        ELSE 'Non-Suspicious IP' 
    END
ORDER BY 
    fraud_rate_percent DESC;

-- 6. Which behavioural indicators, such as device risk, anomaly score, login attempts, or transaction velocity, are most commonly associated with fraud?

SELECT 
    CASE 
        WHEN [fraud_flag] = 1 THEN 'Fraudulent' 
        ELSE 'Legitimate' 
    END AS [transaction_category],
    
    COUNT([transaction_id]) AS [total_transactions],
    
    -- Risk Score Averages
    ROUND(AVG(CAST([anomaly_score] AS FLOAT)), 4) AS [avg_anomaly_score],
    ROUND(AVG(CAST([device_risk_score] AS FLOAT)), 2) AS [avg_device_risk_score],
    ROUND(AVG(CAST([transaction_velocity_score] AS FLOAT)), 2) AS [avg_velocity_score],
    
    -- Behavioral Volume & History Averages
    ROUND(AVG(CAST([login_attempts] AS FLOAT)), 2) AS [avg_login_attempts],
    ROUND(AVG(CAST([failed_transactions_last_30d] AS FLOAT)), 2) AS [avg_failed_tx_30d],
    ROUND(AVG(CAST([geo_distance_km] AS FLOAT)), 2) AS [avg_geo_distance_km],
    ROUND(AVG(CAST([transaction_amount] AS FLOAT)), 2) AS [avg_transaction_amount]
FROM [dbo].[fact_banking_transactions_dw]
GROUP BY 
    CASE 
        WHEN [fraud_flag] = 1 THEN 'Fraudulent' 
        ELSE 'Legitimate' 
    END
ORDER BY 
    [transaction_category] DESC;

-- 7. Which individual transactions exhibit the highest concentration of fraud risk indicators and should be prioritised for investigation?

SELECT TOP (20)
    f.[transaction_id],
    f.[transaction_amount],
    dp.[payment_channel],
    da.[authentication_type],
    f.[anomaly_score],
    f.[device_risk_score],
    f.[transaction_velocity_score],
    f.[login_attempts],
    f.[suspicious_ip_flag],
    f.[international_transaction_flag],
    f.[fraud_flag],
    
    -- Weighted Composite Risk Score
    ROUND(
        (CAST(f.[anomaly_score] AS FLOAT) * 2.0) + 
        (CAST(ISNULL(f.[device_risk_score], 50) AS FLOAT) / 100.0) + 
        (CAST(f.[transaction_velocity_score] AS FLOAT) / 100.0) + 
        (CASE WHEN f.[suspicious_ip_flag] = 1 THEN 0.5 ELSE 0.0 END) + 
        (CASE WHEN f.[login_attempts] BETWEEN 5 AND 50 THEN 0.3 ELSE 0.0 END),
        3
    ) AS [composite_risk_score]
FROM [dbo].[fact_banking_transactions_dw] AS f
LEFT JOIN [dbo].[dim_payment_channel_dw] AS dp
    ON f.[payment_channel_id] = dp.[payment_channel_id]
LEFT JOIN [dbo].[dim_authentication_type_dw] AS da
    ON f.[authentication_type_id] = da.[authentication_type_id]
WHERE 
    f.[login_attempts] <= 50 
    AND (
        f.[anomaly_score] >= 0.70 
        OR f.[device_risk_score] >= 80 
        OR f.[suspicious_ip_flag] = 1
    )
ORDER BY 
    [composite_risk_score] DESC,
    f.[transaction_amount] DESC;