# Fraud Analytics Data Warehouse

A SQL Server data engineering project focused on building a clean, reliable fraud analytics warehouse from raw banking transaction data. The solution covers profiling, standardization, dimensional modeling, transformation, and analytical reporting for suspicious transaction detection.

## Project Summary

This project was designed to demonstrate a practical end-to-end data engineering workflow in a financial risk context. Starting from a noisy source dataset, the pipeline validates raw data quality, normalizes inconsistent values, removes duplicate records, builds dimensional tables, and loads an analytics-ready warehouse that supports fraud investigation and business reporting.

The work combines core warehouse concepts with real-world data cleanup challenges, making it a strong example of ETL, staging, and dimensional modeling using T-SQL.

## Why This Project

As financial institutions process large volumes of digital transactions, they need dependable systems to detect anomalies and interpret risk indicators consistently. Fraud analysis depends not only on the modeling logic, but also on data trustworthiness: clean categorical values, consistent types, valid flags, and well-structured dimensions are essential before meaningful analytical insight can be produced.

This project addresses that challenge by building a repeatable pipeline that converts raw banking data into a curated analytical layer for fraud assessment.

## Solution Architecture

The project follows a staged warehouse model with separation between raw/staging and curated analytical layers:

- Stage 1: source data profiling and validation
- Stage 2: staging dimensions for payment channel and authentication type
- Stage 3: standardized and cleaned fact table construction
- Stage 4: warehouse dimension and fact tables
- Stage 5: analytical queries for fraud assessment and validation

### Databases

- fraud_analytics_stg: staging and transformation layer
- fraud_analytics_dw: analytics layer for reporting and business use

### Core Tables

- fact_banking_transactions_dw
- dim_payment_channel_dw
- dim_authentication_type_dw

## Data Source

The raw source dataset is located in:

- dataset/banking_transactions.csv

This file contains transaction-level fields including transaction amount, payment channel, authentication type, risk score signals, behavioural indicators, and a fraud flag. The dataset reflects common data quality issues such as inconsistent casing, mixed channel labels, missing or invalid values, and duplicate rows.

## Technical Stack

- Microsoft SQL Server
- T-SQL
- SQL Server Integration Services (SSIS) for orchestration and ETL workflow management
- SQL Server Management Studio (SSMS)
- CSV source ingestion
- Dimensional data modeling
- SQL views for business-facing analytical questions

## Repository Structure

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

## Data Engineering Workflow

The implementation follows a staged ETL approach designed to be orchestrated in SSIS:

1. Create the staging and warehouse databases.
2. Profile raw source data to identify quality issues and transformation requirements.
3. Standardize dimension values for payment channel and authentication type.
4. Convert inconsistent values and invalid data types using SQL-safe transformations.
5. Remove duplicate records while preserving valid transaction identifiers.
6. Build cleaned staging dimensions and fact tables.
7. Load the final warehouse fact and dimension tables through controlled ETL steps.
8. Validate data integrity and expose the results through SQL views for analytical consumption.

In a production workflow, SSIS packages would orchestrate these steps in sequence, handle scheduling, logging, and package-level error handling, while the SQL scripts in this repository provide the data transformation logic used by the packages.

## Data Quality and Transformation Highlights

This project includes several practical engineering patterns that are common in real data warehousing work:

- null and invalid-value assessment
- duplicate detection using row-numbering logic
- type conversion with TRY_CONVERT
- flag normalization for boolean-like values
- categorical standardization across payment methods and authentication methods
- alignment of surrogate keys between staging and warehouse tables

## Analytical Use Cases

The analytical layer is built to answer key business questions through SQL views and reporting queries. These views encapsulate the business logic and make the output easier to consume in downstream dashboards, SSIS-driven data refresh pipelines, and stakeholder reporting.

Examples of analytical use cases include:

- What share of transactions are fraudulent?
- Which payment channels have the highest fraud exposure?
- Which authentication methods are most associated with fraudulent activity?
- Are international or card-not-present transactions more risky?
- Are suspicious IP flags correlated with fraud outcomes?
- Which behavioural signals are most indicative of fraud risk?
- Which transactions should be prioritized for investigation?

These questions are designed to be exposed as reusable SQL views that can be connected to BI tools or used by SSIS packages to populate reporting layers without duplicating the underlying logic.

## Validation and Quality Assurance

The dataset and warehouse are checked through SQL validation logic to ensure the transformation pipeline produces usable data. Validation activities include:

- confirming table creation and load completeness
- checking row counts and key integrity
- reviewing dimension-to-fact relationships
- ensuring fraud flags and risk indicators are correctly stored and interpreted

## Portfolio Positioning

This project demonstrates practical capabilities in:

- SQL development and T-SQL transformation logic
- ETL workflow design with SSIS orchestration in mind
- data profiling, validation, and troubleshooting
- dimensional modeling and warehouse design
- fact/dimension design for analytical reporting
- quality assurance in analytical data pipelines
- business-oriented fraud analytics using warehouse data
- packaging analytical logic into reusable SQL views for stakeholder questions

This project is a strong example of an end-to-end data engineering solution that balances technical implementation with business impact and is well suited to a GitHub portfolio focused on SQL Server, ETL, and analytics engineering.

## Potential Next Steps

Future improvements could include:

- automated SQL validation in CI/CD
- incremental loading for larger datasets
- date dimension and customer dimension expansion
- dashboarding with Power BI or Excel
- advanced anomaly detection and model-driven fraud scoring
- a full metadata and lineage documentation layer

## Conclusion

This repository reflects a complete SQL-based data engineering workflow for fraud analytics: it starts with raw transaction data, applies data quality principles, structures the solution as a dimensional warehouse, and creates an analytical foundation for decision-making in a financial risk context.
