-- Create the authentication staging table
USE [fraud_analytics_stg];


IF OBJECT_ID('[dbo].[dim_authentication_type_stg]', 'U') IS NOT NULL BEGIN
DROP TABLE
  [dbo].[dim_authentication_type_stg];


END;


CREATE TABLE
  [dbo].[dim_authentication_type_stg] ([authentication_type] NVARCHAR(100));


INSERT INTO
  [dbo].[dim_authentication_type_stg] ([authentication_type])
SELECT
  [authentication_type]
FROM
  [dbo].[banking_transactions];