# Healthcare Data Quality & Operations Monitoring SQL Project

## Project Overview

This project uses MySQL to analyze synthetic healthcare operations data. It focuses on data quality validation, appointment performance, provider-level analysis, and monthly appointment trends.

**Tools:** MySQL, MySQL Workbench, SQL, GitHub

## Project Objectives

- Identify duplicate patient references and assess data completeness.
- Validate appointment identifiers, dates, and status values.
- Calculate appointment completion, cancellation, and no-show rates.
- Analyze provider-level appointment performance.
- Monitor monthly appointment trends and month-over-month growth.
- Build SQL queries for operational reporting.

## Database Tables

The `healthcare_ops` database contains six tables:

- `providers`
- `patients`
- `appointments`
- `claims`
- `encounters`
- `notes`

## Key Appointment KPIs

Analysis of 12,000 appointment records produced these results:

| KPI | Result |
|---|---:|
| Total Appointments | 12,000 |
| Completed Appointments | 9,618 |
| Cancelled Appointments | 1,154 |
| No-Show Appointments | 1,228 |
| Completion Rate | 80.15% |
| Cancellation Rate | 9.62% |
| No-Show Rate | 10.23% |

## SQL Skills Demonstrated

- Data quality checks and duplicate detection
- `COUNT()`, `COUNT(DISTINCT ...)`, and `SUM()`
- Conditional aggregation with `CASE WHEN`
- `INNER JOIN` and `LEFT JOIN`
- Filtering with `WHERE` and `HAVING`
- Date conversion with `STR_TO_DATE()`
- Monthly grouping using `YEAR()` and `MONTH()`
- Month-over-month analysis with `LAG()`
- Ranking with `ROW_NUMBER()`
- KPI calculations using `ROUND()` and `NULLIF()`

## Business Insights

- The appointment completion rate was 80.15%.
- The cancellation rate was 9.62%.
- The no-show rate was 10.23%.
- Provider-level reporting supports workload and appointment outcome monitoring.
- Monthly analysis helps identify changes in appointment volume.

These results identify areas for further investigation; they do not establish the causes of cancellations, no-shows, or provider performance differences.

## Limitations

- The dataset is synthetic and may not represent actual healthcare operations.
- Appointment status alone cannot explain why an appointment was cancelled or missed.
- Monthly comparisons depend on valid date parsing and correctly ordered periods.
- Provider comparisons should consider appointment volume and other relevant operational factors.

## Data Privacy

This project is intended for portfolio and learning purposes. No real patient data, protected health information, credentials, or confidential employer data should be published.

## Project Outcome

This project demonstrates practical SQL skills in data quality validation, healthcare operations monitoring, KPI reporting, provider analysis, and time-series analysis.

This is an independent portfolio project and is not an official project of any healthcare company.
## SQL Project Files

### Task 01 & 02 — Data Quality Analysis
[View SQL Queries](Task%2001-02%20Data%20Quality%20Analysis.sql)

Includes database validation, duplicate detection, missing data checks, and patient completeness analysis.

### Task 03 — Appointment Operations Analysis
[View SQL Queries](Task%2003%20Appointment%20Data%20Exploration.sql)

Includes appointment KPIs, provider performance, monthly trends, and month-over-month growth analysis.
