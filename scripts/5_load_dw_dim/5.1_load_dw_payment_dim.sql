-- Load the warehouse payment dimension
USE [fraud_analytics_dw];


TRUNCATE TABLE [dbo].[dim_payment_channel_dw];


INSERT INTO
  [dbo].[dim_payment_channel_dw] ([payment_channel])
SELECT
  [payment_channel]
FROM
  [fraud_analytics_stg].[dbo].[dim_payment_channel_clean];