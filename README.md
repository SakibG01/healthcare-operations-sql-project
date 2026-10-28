# Healthcare Data Quality & Operations Monitoring SQL Project

## Project Overview

This project uses MySQL to analyze synthetic healthcare operations data, focusing on patient data quality, appointment performance, provider-level analysis, medical claims operations, financial KPIs, and monthly operational trends.

The objective is to demonstrate practical SQL skills for healthcare data analytics, operational reporting, data validation, and business decision support.

**Tools:** MySQL, MySQL Workbench, SQL, GitHub

## Project Objectives

- Identify duplicate patient references and assess patient data completeness.
- Validate appointment identifiers, dates, and status values.
- Calculate appointment completion, cancellation, and no-show rates.
- Analyze provider-level appointment performance.
- Monitor monthly appointment trends and month-over-month growth.
- Validate medical claims data and identify missing or negative claim amounts.
- Calculate medical claims acceptance and denial rates.
- Analyze payer-wise claim volumes and financial KPIs.
- Build reusable SQL queries for operational monitoring and reporting.

## Database Tables

The `healthcare_ops` database contains six tables:

- `providers`
- `patients`
- `appointments`
- `medical_claims`
- `claim_status_history`
- `quality_audits`

## Key Appointment KPIs

Analysis of 12,000 appointment records produced the following results:

| KPI | Result |
|---|---:|
| Total Appointments | 12,000 |
| Completed Appointments | 9,618 |
| Cancelled Appointments | 1,154 |
| No-Show Appointments | 1,228 |
| Completion Rate | 80.15% |
| Cancellation Rate | 9.62% |
| No-Show Rate | 10.23% |

## Key Medical Claims KPIs

Analysis of 9,618 medical claims produced the following results:

| KPI | Result |
|---|---:|
| Total Medical Claims | 9,618 |
| Accepted Claims | 6,455 |
| Denied Claims | 953 |
| Submitted Claims | 1,431 |
| Pending Claims | 779 |
| Acceptance Rate | 67.11% |
| Denial Rate | 9.91% |
| Net Claim Amount | 11,647,404.09 |
| Average Claim Amount | 1,216.69 |
| Positive Claim Amount | 11,728,241.48 |
| Negative Claim Amount | -80,837.39 |
| Missing Claim Amounts | 45 |
| Claims with Negative Amounts | 70 |

*Financial amounts are reported in dataset units; currency has not been independently verified. Claim acceptance does not necessarily indicate payment or collected revenue.*

## SQL Skills Demonstrated

- Data quality validation and duplicate detection
- `COUNT()`, `COUNT(DISTINCT ...)`, `SUM()`, `AVG()`, `MIN()`, and `MAX()`
- Conditional aggregation using `CASE WHEN`
- `INNER JOIN` and `LEFT JOIN`
- Filtering using `WHERE` and `HAVING`
- Grouping and sorting using `GROUP BY` and `ORDER BY`
- Percentage calculations using `ROUND()` and `NULLIF()`
- Date conversion using `STR_TO_DATE()`
- Monthly grouping using `YEAR()`, `MONTH()`, and `DATE_FORMAT()`
- Month-over-month analysis using `LAG()`
- Ranking using `ROW_NUMBER()`
- Financial KPI calculations
- Claims status and payer-level analysis

## Business Insights

### Appointment Operations

- The appointment completion rate was 80.15%.
- The cancellation rate was 9.62%.
- The no-show rate was 10.23%.
- Provider-level reporting supports workload and appointment outcome monitoring.
- Monthly analysis helps identify changes in appointment volume.

### Medical Claims Operations

- Analyzed 9,618 medical claims across five insurance payers.
- 67.11% of claims were accepted, while 9.91% were denied.
- Aetna recorded the highest claim volume with 1,942 claims.
- Claim volumes were relatively evenly distributed across the five payers.
- Identified 45 claims with missing amounts and 70 claims with negative amounts.
- Negative claim amounts may represent adjustments, reversals, or other financial transactions requiring business validation.

These findings highlight areas for further investigation but do not independently establish the causes of claim denials, appointment cancellations, no-shows, or provider performance differences.

## Business Recommendations

- Monitor appointment completion and no-show rates regularly.
- Investigate recurring cancellation and no-show patterns.
- Compare provider performance while considering appointment volume.
- Review denied claims to identify potential operational issues.
- Investigate missing claim amounts before preparing financial reports.
- Validate negative claim amounts against business rules.
- Monitor payer-specific claim volumes and denial rates.
- Use monthly trends to support operational planning.

## Project Limitations

- The dataset is synthetic and may not represent actual healthcare operations.
- Appointment status alone cannot explain why an appointment was cancelled or missed.
- Claim acceptance does not confirm successful payment.
- Negative claim amounts should not automatically be classified as data errors.
- Financial totals include negative amounts and exclude NULL values.
- Monthly comparisons depend on valid date parsing and correctly ordered periods.
- Provider comparisons should consider appointment volume and other operational factors.
- Findings are descriptive and should not be interpreted as causal conclusions.

## Data Privacy

This project is intended for portfolio development and learning purposes.

No real patient data, protected health information (PHI), credentials, or confidential employer data should be published.

## Project Outcome

This project demonstrates practical SQL skills in healthcare data quality validation, appointment operations monitoring, medical claims analysis, KPI reporting, provider-level analysis, financial reporting, and time-series analysis.

The analyses are designed to support data-driven operational decisions and demonstrate skills relevant to Data Analyst, Healthcare Operations Analyst, and Data Operations Analyst roles.

This is an independent portfolio project and is not an official project of any healthcare company.

## SQL Project Files

### Task 01 & 02 — Patient Data Quality Analysis

[View SQL Queries](Task%2001-02%20Data%20Quality%20Analysis.sql)

Includes database validation, duplicate detection, missing data checks, and patient completeness analysis.

**Key Result:** 59.86% patient record completeness across 5,000 records.

### Task 03 — Appointment Operations Analysis

[View SQL Queries](Task%2003%20Appointment%20Data%20Exploration.sql)

Includes appointment KPIs, provider performance, monthly trends, and month-over-month growth analysis.

**Key Result:** 80.15% appointment completion rate across 12,000 appointments.

### Task 04 — Medical Claims Operations Analysis

[View SQL Queries](Task%2004%20%E2%80%94%20Medical%20Claims%20Operations%20Analysis%281%29.sql)

Includes:

- Claim ID and appointment relationship validation
- Missing and duplicate claim analysis
- Missing and negative claim amount analysis
- Financial KPI calculations
- Claim status distribution
- Acceptance and denial rate calculations
- Payer-wise claim volume analysis
- Monthly claims trend analysis
- Missing and invalid claim date checks
- Final medical claims KPI summary

**Key Result:** 67.11% claim acceptance rate and a recorded net claim amount of 11,647,404.09 across 9,618 medical claims.

## Upcoming Analysis

### Task 05 — Claim Status History & Processing Analysis

Planned analysis of claim status transitions, processing timelines, and payer-level processing performance.

### Task 06 — Quality Audit Analysis

Planned analysis of audit records, quality indicators, and operational monitoring opportunities.

---

**Project Type:** Independent SQL Portfolio Project  
**Database:** MySQL  
**Domain:** Healthcare Operations Analytics  
**Focus:** Data Quality, Operational KPIs, Medical Claims, and Business Reporting
