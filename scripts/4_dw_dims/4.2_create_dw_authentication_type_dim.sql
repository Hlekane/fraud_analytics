-- Create the warehouse authentication dimension
USE [fraud_analytics_dw];


IF OBJECT_ID('[dbo].[dim_authentication_type_dw]', 'U') IS NULL BEGIN
CREATE TABLE
  [dbo].[dim_authentication_type_dw] (
    [authentication_type_id] INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
    [authentication_type] NVARCHAR(100) NOT NULL
  );


END;


-- Load from the clean staging dimension
TRUNCATE TABLE [dbo].[dim_authentication_type_dw];


INSERT INTO
  [dbo].[dim_authentication_type_dw] ([authentication_type])
SELECT
  [authentication_type]
FROM
  [fraud_analytics_stg].[dbo].[dim_authentication_type_clean];