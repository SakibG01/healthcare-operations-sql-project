SELECT COUNT(*) FROM healthcare_ops.patients;
SELECT * FROM healthcare_ops.patients;

-- Duplicate Detection এবং Reference Uniqueness KPI

SELECT patient_reference,
		COUNT(*) AS Total_records
FROM healthcare_ops.patients
GROUP BY patient_reference
HAVING Total_records > 1;

SELECT 
	COUNT(*) AS Total_patient_records,
    COUNT(DISTINCT patient_reference)
		AS unique_patient_reference,
	COUNT(*) - COUNT(DISTINCT patient_reference) AS excess_duplicate_records
FROM patients;
    
SELECT 
	ROUND(
    COUNT(DISTINCT patient_reference) 
    * 100 / NULLIF(COUNT(*), 0),
    2) AS reference_uniqueness_rate
FROM healthcare_ops.patients;


-- All 6 tables row count verified

SELECT 'claim_status_history' AS Table_name,
COUNT(*) AS Total_row
FROM claim_status_history

UNION ALL
SELECT 'appointments', COUNT(*) 
FROM appointments

UNION ALL
SELECT 'medical_claims', COUNT(*) 
FROM medical_claims

UNION ALL
SELECT 'patients', COUNT(*) 
FROM patients

UNION ALL
SELECT 'providers', COUNT(*) 
FROM providers

UNION ALL
SELECT 'quality_audits', COUNT(*) 
FROM quality_audits;

-- Primary key uniqueness checked
SELECT
    COUNT(*) AS total_provider_records,
    COUNT(DISTINCT provider_id) AS unique_ids
FROM providers;

SELECT 
	COUNT(*) AS total_appointments_record,
    COUNT(DISTINCT appointment_id) AS unique_ids
FROM appointments;

SELECT 
	COUNT(*) AS total_claim_status_record,
    COUNT(DISTINCT event_id) AS unique_ids
FROM claim_status_history;

SELECT 
	COUNT(*) AS total_medical_claims_record,
    COUNT(DISTINCT claim_id) AS unique_ids
FROM medical_claims;

SELECT 
	COUNT(*) AS total_patient_record,
    COUNT(DISTINCT patient_id) AS unique_ids
FROM patients;

SELECT 
	COUNT(*) AS total_audit_record,
    COUNT(DISTINCT audit_id) AS unique_ids
FROM quality_audits;

-- Foreign key relationships checked

SELECT
    'Appointment-Patient' AS relationship,
    COUNT(*) AS invalid_links
FROM appointments a
LEFT JOIN patients p
    ON a.patient_id = p.patient_id
WHERE p.patient_id IS NULL

UNION ALL

SELECT
    'Appointment-Provider',
    COUNT(*)
FROM appointments a
LEFT JOIN providers p
    ON a.provider_id = p.provider_id
WHERE p.provider_id IS NULL

UNION ALL

SELECT
    'Claim-Appointment',
    COUNT(*)
FROM medical_claims c
LEFT JOIN appointments a
    ON c.appointment_id = a.appointment_id
WHERE a.appointment_id IS NULL

UNION ALL

SELECT
    'History-Claim',
    COUNT(*)
FROM claim_status_history h
LEFT JOIN medical_claims c
    ON h.claim_id = c.claim_id
WHERE c.claim_id IS NULL

UNION ALL

SELECT
    'Audit-Claim',
    COUNT(*)
FROM quality_audits q
LEFT JOIN medical_claims c
    ON q.claim_id = c.claim_id
WHERE c.claim_id IS NULL;

-- Missing Data Detection
SELECT 
	COUNT(*) AS Total_patient,
    SUM(
		CASE 
			WHEN birth_date IS NULL THEN 1
            ELSE 0
		END
    ) AS Missing_birth_date,
    SUM(
		CASE
			WHEN sex IS NULL OR sex = '' THEN 1
            ELSE 0
		END
    ) AS missing_sex
FROM patients;

-- Missing birth date Rate KPI
SELECT 
	ROUND(
    (COUNT(*) - COUNT(birth_date))
    * 100 / NULLIF(COUNT(*),0) 
    ,2) AS Missing_birth_date_rate
FROM patients;

-- Missing Sex Rate KPI
SELECT 
	ROUND(
		(COUNT(*) - COUNT(sex))
        *100 / NULLIF(COUNT(*),0)
	,2) AS missing_sex_KPI
FROM patients;
-- alternative logic
SELECT 
	ROUND(
		SUM(
			CASE
				WHEN sex IS NULL OR sex = '' THEN 1
                ELSE 0
			END
        )
        * 100 / NULLIF(COUNT(*),0)
	,2) AS missing_sex_rate
FROM patients;

-- Step 4: Patient Data Completeness KPI
SELECT COUNT(*) AS total_patient,
	SUM(
		CASE 
			WHEN birth_date IS NOT NULL
            AND sex IS NOT NULL
            AND sex <> ''
            THEN 1
            ELSE 0
		END
    ) AS complete_record
FROM healthcare_ops.patients;

-- Althernative Logic without WHEN 
SELECT COUNT(*) AS total_patient,
	SUM(
		birth_date IS NOT NULL
        AND sex IS NOT NULL
        AND sex <> ''
    ) AS complete_record 
FROM patients;


-- Step 4A — Complete Records Count
SELECT COUNT(*) AS total_patient,
	SUM(
		CASE 
			WHEN birth_date IS NOT NULL
            AND sex IS NOT NULL
            AND sex <> ''
            THEN 1
            ELSE 0
		END
    ) AS complete_record
FROM healthcare_ops.patients;

-- Step 4B — Completeness Rate KPI
SELECT 
	ROUND(
		SUM(
			CASE 
				WHEN birth_date IS NOT NULL
				AND sex IS NOT NULL
				AND sex <> ''
				THEN 1
				ELSE 0
			END
		) * 100 / NULLIF(COUNT(*),0)
    ,2) AS patient_completeness_rate

FROM healthcare_ops.patients;

-- Task 02 — Step 5: Incomplete Records Investigation
SELECT
    patient_id,
    patient_reference,
    birth_date,
    sex
FROM healthcare_ops.patients
WHERE birth_date IS NULL
   OR sex IS NULL
   OR sex = ''
ORDER BY patient_id;

SELECT
    COUNT(*) AS total_incomplete_records
FROM healthcare_ops.patients
WHERE birth_date IS NULL
   OR sex IS NULL
   OR sex = '';

SELECT
    COUNT(*) AS both_fields_missing
FROM healthcare_ops.patients
WHERE birth_date IS NULL
  AND (sex IS NULL OR sex = '');

-- Step 7 — Missing Data Category Analysis

SELECT
    COUNT(*) AS only_birth_date_missing
FROM healthcare_ops.patients
WHERE birth_date IS NULL
  AND sex IS NOT NULL
  AND sex <> '';


SELECT
    COUNT(*) AS only_sex_missing
FROM healthcare_ops.patients
WHERE birth_date IS NOT NULL
  AND (sex IS NULL OR sex = '');


SELECT
    SUM(
        CASE
            WHEN birth_date IS NULL
             AND sex IS NOT NULL
             AND sex <> ''
            THEN 1 ELSE 0
        END
    ) AS only_birth_date_missing,

    SUM(
        CASE
            WHEN birth_date IS NOT NULL
             AND (sex IS NULL OR sex = '')
            THEN 1 ELSE 0
        END
    ) AS only_sex_missing,

    SUM(
        CASE
            WHEN birth_date IS NULL
             AND (sex IS NULL OR sex = '')
            THEN 1 ELSE 0
        END
    ) AS both_missing,

    SUM(
        CASE
            WHEN birth_date IS NOT NULL
             AND sex IS NOT NULL
             AND sex <> ''
            THEN 1 ELSE 0
        END
    ) AS both_present

FROM healthcare_ops.patients;


-- Create a report showing patient records with missing demographic information and identify the type of issue for each record.

SELECT
    patient_id,
    patient_reference,
    birth_date,
    sex,
	CASE
		WHEN birth_date IS NULL
         AND (sex IS NULL OR sex = '')
			THEN 'Both Missing'
		
        WHEN birth_date IS NULL
			THEN "Birth Date Missing"
            
		WHEN sex IS NULL
			THEN 'Sex IS Missing'
		
        ELSE 'Complete'
	END AS issue_type
FROM patients;

-- Task 02 — Step 9: Final Data Quality Summary Report
-- Create a single SQL report showing total patients, missing data counts, incomplete records, and overall data completeness rate.

SELECT
    COUNT(*) AS total_patients,
    
    COUNT(*) - COUNT(birth_date)
        AS missing_birth_date,
	
    SUM(
        CASE
            WHEN sex IS NULL OR sex = ''
            THEN 1 ELSE 0
        END
    ) AS missing_sex,

    SUM(
        CASE
            WHEN birth_date IS NULL
              OR sex IS NULL
              OR sex = ''
            THEN 1 ELSE 0
        END
    ) AS incomplete_records,

    SUM(
        CASE
            WHEN birth_date IS NOT NULL
             AND sex IS NOT NULL
             AND sex <> ''
            THEN 1 ELSE 0
        END
    ) AS complete_records,

    ROUND(
        SUM(
            CASE
                WHEN birth_date IS NOT NULL
                 AND sex IS NOT NULL
                 AND sex <> ''
                THEN 1 ELSE 0
            END
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS completeness_rate
FROM healthcare_ops.patients;
-- 4. Business Insight
-- এই report থেকে আমরা বলতে পারি:
-- Out of 5,000 patient records, 2,007 records have missing birth date or sex information. The overall completeness rate for these two demographic fields is 59.86%, indicating a need for data quality improvement.



