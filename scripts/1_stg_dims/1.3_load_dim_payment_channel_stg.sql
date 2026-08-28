-- Load the payment channel staging dimension
CREATE
OR ALTER PROCEDURE [dbo].[load_dim_payment_channel_stg] AS BEGIN
SET
  NOCOUNT ON;


-- Refresh the dimension
TRUNCATE TABLE [dbo].[dim_payment_channel_stg];


-- Load source values
INSERT INTO
  [dbo].[dim_payment_channel_stg] ([payment_channel])
SELECT
  [payment_channel]
FROM
  [dbo].[banking_transactions];


END;