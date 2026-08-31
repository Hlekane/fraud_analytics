# Fraud Analytics Project

This project is a SQL Server data engineering solution for banking fraud analytics. The goal is to take raw transaction data, clean it, standardize it, model it properly, and use it to answer business questions around fraud risk.

I built the pipeline using a staged warehouse approach. The raw data is first profiled and validated, then transformed into cleaned staging tables, and finally loaded into warehouse dimensions and fact tables. The final data is used to answer key fraud and risk questions.

## What this project does

- profiles and checks raw banking transaction data
- cleans inconsistent values and fixes data types
- removes duplicate records
- standardizes payment channel and authentication fields
- loads a dimensional warehouse in SQL Server
- answers fraud-related business questions using SQL queries
- supports SSIS orchestration for the ETL flow

## Tech stack

- SQL Server
- T-SQL
- SSIS for orchestration
- SQL views for key business questions
- Dimensional modeling

## Folder structure

- scripts/
  - 0.0_create_databases.sql
  - 0.1_data_profiling.sql
  - 0.2_column grouping.sql
  - 1_stg_dims/
    - 1.1_create_stg_payment_dim.sql
    - 1.2_create_stg_authentication_type_dim.sql
    - 1.3_load_dim_payment_channel_stg.sql
    - 1.4_load_dim_authentication_type_stg.sql
  - 2_stg_clean_dims/
    - 2.1_create_clean_payment_dim_stg.sql
    - 2.2_create_clean_authentication_type_dim_stg.sql
    - 2.3_create_clean_fact_banking_transactions.sql
  - 3_load_stg_clean_dims/
    - 3.1_load_dim_payment_channel_clean.sql
    - 3.2_load_dim_authentication_type_clean.sql
    - 3.3_load_banking_fact_transactions_clean.sql
  - 4_dw_dims/
    - 4.1_create_dw_payment_dim.sql
    - 4.2_create_dw_authentication_type_dim.sql
    - 4.3_create_dw_fact_banking_transactions.sql
  - 5_load_dw_dim/
    - 5.1_load_dw_payment_dim.sql
    - 5.2_load_dw_authentication_type_dim.sql
    - 5.3_load_dw_fact_banking_transactions.sql
  - 6_analysis/
    - 5.1_fraud_summary.sql
    - 5.2_validate_dw.sql
    - 5.3_key_business_questions.sql
- dataset/
  - banking_transactions.csv
- documentation/
- README.md

## Data model

The project uses a simple dimensional warehouse model with:

- staging database for raw and cleaned data
- warehouse database for final analytical tables
- fact table for transaction-level analysis
- dimension tables for payment channel and authentication type

The key warehouse table is:

- fact_banking_transactions_dw

## Business questions being answered

This project is focused on answering questions like:

- What percentage of transactions are fraudulent?
- Which payment channels have the highest fraud rate?
- Which authentication methods are linked to fraud?
- Are international or card-not-present transactions riskier?
- Are suspicious IPs associated with higher fraud levels?
- Which transactions should be reviewed first?

These are built as reusable SQL views and reporting queries so they can be reused outside the ETL logic.

## SSIS and orchestration

This project is designed to be orchestrated with SSIS. In practice, SSIS would control the sequence of ETL tasks, package execution, logging, and scheduling. The SQL scripts in this repo provide the actual transformation logic that the SSIS packages would run.

## Data quality work

A big part of this project is fixing messy source data. I worked through:

- null values
- incorrect data types
- inconsistent category labels
- duplicate transaction IDs
- boolean-like flags stored in different formats

This is important because fraud analysis is only useful if the data is trustworthy.

## Why this project matters

The main value is not just creating tables. It is building a reliable data pipeline that supports real business decisions. In a fraud context, the work helps identify risky transactions and gives analysts a cleaner structure for monitoring and investigation.

## Portfolio summary

This project shows that I can work with:

- SQL Server development
- ETL process design
- data profiling and cleanup
- dimensional modeling
- warehouse loading
- business-facing analytical queries
- SSIS orchestration thinking

It is a solid example of a data engineering project using SQL Server and ETL principles in a real-world fraud analytics scenario.
