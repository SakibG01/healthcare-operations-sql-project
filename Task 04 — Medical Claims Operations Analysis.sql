SHOW TABLES FROM healthcare_ops;

DESCRIBE healthcare_ops.medical_claims;

Select * FROM medical_claims;

SELECT
    COUNT(*) AS total_claims
FROM healthcare_ops.medical_claims;

SHOW COLUMNS
FROM healthcare_ops.medical_claims;

-- Missing Claim ID Analysis
SELECT COUNT(*) AS total_claims,
	SUM(
		CASE
			WHEN claim_id is NULL
            THEN 1 ELSE 0
		END
    ) AS missing_claim_ids
FROM healthcare_ops.medical_claims;

-- Duplicate Claim ID Analysis
SELECT 
	COUNT(*) AS total_claim_id,
    COUNT(DISTINCT claim_id) AS unique_claim_ids,
    COUNT(*) - COUNT(DISTINCT claim_id) AS  duplicate_excess
FROM healthcare_ops.medical_claims;

-- Missing Appointment ID Analysis
SELECT 
		COUNT(*) AS total_claims,
        sum(
			CASE 
				WHEN appointment_id IS NULL 
                THEN 1 ELSE 0
			END
        ) AS missing_appointment_ids
FROM healthcare_ops.medical_claims;

-- Claim-to-Appointment Relationship Validation
SELECT 
		COUNT(*) AS total_claims,
        SUM(
			CASE 
				WHEN a.appointment_id IS NULL 
                THEN 1 ELSE 0
            END
        ) AS unmarched_claims
FROM healthcare_ops.medical_claims AS mc
	LEFT JOIN healthcare_ops.appointments AS a
    ON mc.appointment_id = a.appointment_id;

-- Missing Payer Data Analysis
SELECT
    COUNT(*) AS total_claims,
    SUM(
        CASE
            WHEN payer IS NULL
                 OR TRIM(payer) = ''
            THEN 1
            ELSE 0
        END
    ) AS missing_payers
FROM healthcare_ops.medical_claims;

-- Missing Claim Amount Analysis
select * from medical_claims;

SELECT
    COUNT(*) AS total_claims,
    SUM(
		CASE
			WHEN claim_amount is NULL 
            THEN 1 ELSE 0
        END
    ) AS missing_claim_amount
FROM medical_claims;

-- Invalid Claim Amount Validation
-- Business Question: Are there any zero or negative claim amounts?
SELECT
    COUNT(*) AS total_claims,
    SUM(
		CASE
			WHEN claim_amount IS NULL 
            THEN 1 ELSE 0
        END
    ) AS missing_claim_amount,
    SUM(
		CASE 
			WHEN claim_amount = 0 
            THEN 1 ELSE 0
        END
    ) AS zero_claim_amount,
    SUM(
		CASE 
			WHEN claim_amount < 0 
            THEN 1 ELSE 0
        END
    ) AS negative_claim_amount
FROM medical_claims;

-- Find All 70 Negative Claim Records
SELECT
    claim_id,
    appointment_id,
    payer,
    claim_amount,
    created_at,
    current_status
FROM healthcare_ops.medical_claims
WHERE claim_amount < 0;

-- Financial KPI Analysis
-- Business Question: What are the total, average, minimum, and maximum medical claim amounts?

SELECT
		COUNT(*) AS total_claims,
        ROUND(SUM(claim_amount),2) AS total_claim_amount,
        ROUND(AVG(claim_amount),2) AS Average_claim_amount,
        ROUND(MIN(claim_amount),2) AS minimum_claim_amount,
        ROUND(MAX(claim_amount),2) AS maximum_claim_amount
FROM medical_claims;

-- Positive vs Negative Claim Amount Analysis
SELECT
    ROUND(SUM(CASE
        WHEN claim_amount > 0 THEN claim_amount
        ELSE 0
    END), 2) AS total_positive_amount,
    
    ROUND(SUM(CASE
        WHEN claim_amount < 0 THEN claim_amount
        ELSE 0
    END), 2) AS total_negative_amount,
    
    ROUND(SUM(claim_amount), 2) AS net_claim_amount
    
FROM healthcare_ops.medical_claims;

-- Claim Status Distribution
SELECT 
		current_status,
		COUNT(*) AS total_claim
   
FROM medical_claims
GROUP BY current_status
ORDER BY total_claim DESC;

-- Claim Acceptance & Denial Rates


SELECT 
		COUNT(*) AS total_claim,
        ROUND(
			SUM(
				CASE
					WHEN current_status = 'Accepted'
                    THEN 1 ELSE 0
                END
            ) * 100 / NULLIF(COUNT(*),0)
        ,2) AS acceptence_rate,
		   ROUND(
			SUM(
				CASE
					WHEN current_status = 'Denied'
                    THEN 1 ELSE 0
                END
            ) * 100 / NULLIF(COUNT(*),0)
        ,2) AS denial_rate
FROM healthcare_ops.medical_claims;

-- Claims Distribution by Payer

SELECT payer,
		COUNT(*) AS total_claim
FROM medical_claims
GROUP BY payer
ORDER BY total_claim DESC;

-- Monthly Claims Trend Analysis
describe medical_claims;

SELECT
    created_at
FROM healthcare_ops.medical_claims
WHERE created_at IS NOT NULL
LIMIT 10;

SELECT
    DATE_FORMAT(
        STR_TO_DATE(created_at, '%c/%e/%Y %H:%i'),
        '%Y-%m'
    ) AS claim_month,
    COUNT(*) AS total_claims

FROM healthcare_ops.medical_claims
GROUP BY claim_month
ORDER BY claim_month ASC;

-- Alternative method
SELECT
		YEAR(STR_TO_DATE(created_at, '%c/%e/%Y %H:%i')) AS claim_year,
	    MONTH(STR_TO_DATE(created_at, '%c/%e/%Y %H:%i')) AS claim_month,
    COUNT(*) AS total_claims

FROM healthcare_ops.medical_claims
GROUP BY claim_month,claim_year
ORDER BY claim_month ASC;

-- Claims Data Validation (Missing & Invalid Claim Dates)
select * from medical_claims;

SELECT
    COUNT(*) AS total_claims,

    SUM(
        CASE
            WHEN created_at IS NULL
                 OR TRIM(created_at) = ''
            THEN 1 ELSE 0
        END
    ) AS missing_dates,

    SUM(
        CASE
            WHEN created_at IS NOT NULL
                 AND TRIM(created_at) <> ''
                 AND STR_TO_DATE(
                     created_at, '%c/%e/%Y %H:%i'
                 ) IS NULL
            THEN 1 ELSE 0
        END
    ) AS invalid_dates

FROM healthcare_ops.medical_claims;

-- Final KPI Summary
-- Business Question: How can we summarize the most important Medical Claims KPIs in a single SQL Query?

SELECT
    COUNT(*) AS total_claims,

    SUM(CASE
        WHEN current_status = 'Accepted'
        THEN 1 ELSE 0
    END) AS accepted_claims,

    SUM(CASE
        WHEN current_status = 'Denied'
        THEN 1 ELSE 0
    END) AS denied_claims,

    ROUND(
        SUM(CASE
            WHEN current_status = 'Accepted'
            THEN 1 ELSE 0
        END) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS acceptance_rate,

    ROUND(
        SUM(CASE
            WHEN current_status = 'Denied'
            THEN 1 ELSE 0
        END) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS denial_rate,

    ROUND(SUM(claim_amount), 2) AS net_claim_amount,

    ROUND(AVG(claim_amount), 2) AS avg_claim_amount,

    SUM(CASE
        WHEN claim_amount IS NULL
        THEN 1 ELSE 0
    END) AS missing_amounts,

    SUM(CASE
        WHEN claim_amount < 0
        THEN 1 ELSE 0
    END) AS negative_claims

FROM healthcare_ops.medical_claims;









