-- Create the payment channel staging table
USE [fraud_analytics_stg];


IF OBJECT_ID('[dbo].[dim_payment_channel_stg]', 'U') IS NOT NULL BEGIN
DROP TABLE
  [dbo].[dim_payment_channel_stg];


END;


CREATE TABLE
  [dbo].[dim_payment_channel_stg] ([payment_channel] NVARCHAR(100));


INSERT INTO
  [dbo].[dim_payment_channel_stg] ([payment_channel])
SELECT
  [payment_channel]
FROM
  [dbo].[banking_transactions];