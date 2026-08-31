-- Create the warehouse payment dimension
USE [fraud_analytics_dw];


IF OBJECT_ID('[dbo].[dim_payment_channel_dw]', 'U') IS NULL BEGIN
CREATE TABLE
  [dbo].[dim_payment_channel_dw] (
    [payment_channel_id] INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    [payment_channel] NVARCHAR(100) NOT NULL
  );


END;


-- Load from the clean staging dimension
TRUNCATE TABLE [dbo].[dim_payment_channel_dw];


INSERT INTO
  [dbo].[dim_payment_channel_dw] ([payment_channel])
SELECT
  [payment_channel]
FROM
  [fraud_analytics_stg].[dbo].[dim_payment_channel_clean];