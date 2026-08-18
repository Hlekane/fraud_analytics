# Project: Fraud Detection & Risk Analytics Pipeline
### Purpose

The purpose of this project is to build an end-to-end data engineering pipeline for banking fraud detection and transaction risk analytics.

The project will demonstrate practical data engineering principles by taking a deliberately messy transaction dataset through the stages of data ingestion, profiling, data quality assessment, transformation, dimensional modelling, analytical processing and business intelligence.

The project is designed not only to produce analytical results, but to demonstrate the engineering practices required to transform unreliable source data into a structured, trustworthy and analysis-ready data platform.

The pipeline will be developed using Microsoft SQL Server and T-SQL, with version control, documentation, testing and basic CI/CD practices incorporated throughout the project.

## Business Problem

As banking becomes increasingly dependent on digital and online transactions, financial institutions are exposed to increasingly sophisticated forms of fraudulent activity.

### Fraud detection is therefore not solely a technical problem. It has implications for:

Financial loss
Customer trust
Operational risk
Regulatory compliance
Fraud investigation
Transaction monitoring
Business decision-making

Large volumes of transactions make manual identification of suspicious activity impractical. Financial institutions require reliable data platforms capable of identifying patterns, measuring risk and providing analysts with trustworthy information for further investigation.

However, effective fraud analytics depends heavily on the quality and structure of the underlying data.

### Raw transaction data may contain:

Missing values
Duplicate records
Inconsistent categorical values
Invalid values
Incorrect data types
Inconsistent representations
Other data-quality issues

Therefore, before meaningful fraud analysis can take place, the source data must be profiled, validated, cleaned, transformed and modelled appropriately.

## Business Objective

The objective of this project is to build a reliable and repeatable data pipeline that transforms raw transaction data into trusted, analysis-ready information that can support fraud detection and transaction risk analysis.

The solution will provide a structured analytical environment that enables stakeholders to:

Identify potentially fraudulent transactions
Analyse transaction risk indicators
Measure fraudulent transaction volumes
Quantify the financial impact of fraud
Identify transaction patterns associated with fraudulent activity
Compare fraud risk across transaction channels and authentication methods
Analyse behavioural indicators associated with suspicious transactions
Support further investigation of high-risk transactions

The project will focus specifically on transaction-level fraud and risk analytics, based on the entities and attributes available in the source dataset.

## Key Business Questions

The analytical solution should ultimately help answer questions such as:

### Fraud
What proportion of transactions are fraudulent?
How many fraudulent transactions occur?
Which transactions exhibit the highest concentration of risk indicators?
Which characteristics are most commonly associated with fraudulent transactions?
### Financial Risk
What is the total value of fraudulent transactions?
What is the average value of fraudulent transactions?
What percentage of total transaction value is associated with fraud?
Which transaction channels contribute the greatest financial exposure?
### Channel & Authentication Risk
Which payment channels have the highest fraud rates?
Which authentication methods are associated with higher fraud rates?
Are international transactions associated with higher fraud rates?
Are card-present and card-not-present transactions associated with different levels of risk?
### Behavioural & Risk Indicators
Are higher device-risk scores associated with fraudulent transactions?
Are higher anomaly scores associated with fraud?
Does transaction velocity differ between fraudulent and legitimate transactions?
Are suspicious IP transactions more likely to be fraudulent?
Are higher login attempts associated with fraudulent activity?
Are higher transaction frequencies associated with increased fraud risk?
