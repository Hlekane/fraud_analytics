-- Load the warehouse authentication dimension
USE [fraud_analytics_dw];


TRUNCATE TABLE [dbo].[dim_authentication_type_dw];


INSERT INTO
  [dbo].[dim_authentication_type_dw] ([authentication_type])
SELECT
  [authentication_type]
FROM
  [fraud_analytics_stg].[dbo].[dim_authentication_type_clean];