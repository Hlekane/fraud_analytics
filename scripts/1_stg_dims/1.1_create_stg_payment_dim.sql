-- create dim_payment_channel dimension table
IF OBJECT_ID('[fraud_analytics_stg].[dbo].[dim_payment_channel_stg]', 'U') IS NULL

CREATE TABLE [fraud_analytics_stg].[dbo].[dim_payment_channel_stg] 
	(
	[payment_channel] NVARCHAR (100)
	
);

INSERT INTO [fraud_analytics_stg].[dbo].[dim_payment_channel_stg] (
	
	[payment_channel]
)
SELECT 
	[payment_channel]
FROM [fraud_analytics_stg].[dbo].[banking_transactions]

