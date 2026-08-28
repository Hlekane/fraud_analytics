-- Load the authentication staging dimension
CREATE
OR ALTER PROCEDURE [dbo].[load_dim_authentication_type_stg] AS BEGIN
SET
  NOCOUNT ON;


-- Refresh the dimension
TRUNCATE TABLE [dbo].[dim_authentication_type_stg];


-- Load source values
INSERT INTO
  [dbo].[dim_authentication_type_stg] ([authentication_type])
SELECT
  [authentication_type]
FROM
  [dbo].[banking_transactions];


END;