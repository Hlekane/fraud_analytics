-- Create the staging and warehouse databases
-- Create the staging database
IF DB_ID ('fraud_analytics_stg') IS NULL BEGIN CREATE DATABASE fraud_analytics_stg;


END GO -- Create the warehouse database
IF DB_ID ('fraud_analytics_dw') IS NULL BEGIN CREATE DATABASE fraud_analytics_dw;


END GO