/* create dim_authentication_type table staging*/

-- dim_authentication_type dimension table staging
IF OBJECT_ID('[fraud_analytics_stg].[dbo].[dim_authentication_type_stg]', 'U') IS NULL

CREATE TABLE [fraud_analytics_stg].[dbo].[dim_authentication_type_stg] 
	([authentication_type] NVARCHAR (100));

INSERT INTO [fraud_analytics_stg].[dbo].[dim_authentication_type_stg] 
	( [authentication_type])

SELECT 
	[authentication_type]
FROM [fraud_analytics_stg].[dbo].[banking_transactions];
