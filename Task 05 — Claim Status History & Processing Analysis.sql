-- Step 01: Explore the Table
describe healthcare_ops.claim_status_history;

-- Step 02: Count Status History Records
SELECT 
		COUNT(*) AS total_history_records
FROM healthcare_ops.claim_status_history;

-- Step 03: Missing Data Analysis
SELECT 	
		COUNT(*) AS total_history_records,
		SUM(
			CASE 
				WHEN event_id IS NULL
                THEN 1 ELSE 0
            END
        ) AS missing_event_ids,
        SUM(
			CASE 
				WHEN claim_id IS NULL
                THEN 1 ELSE 0
            END
        ) AS missing_claim_ids,
        SUM(
			CASE 
				WHEN status IS NULL
                OR TRIM(status) = ''
                THEN 1 ELSE 0
            END
        ) AS missing_status,
		 SUM(
			CASE 
				WHEN event_at IS NULL
                OR TRIM(status) = ''
                THEN 1 ELSE 0
            END
        ) AS missing_event_dates
FROM healthcare_ops.claim_status_history;

-- Step 04: Duplicate Event ID Analysis
SELECT
    COUNT(*) AS total_records,
	COUNT(DISTINCT event_id) AS unique_event_ids,
    COUNT(*) - COUNT(DISTINCT event_id) AS duplicate_excess
FROM healthcare_ops.claim_status_history;

-- Step 05: Claims with Multiple Status Events
-- Business Question: How many unique claims have multiple status history records?
SELECT * FROM claim_status_history;

SELECT
    claim_id,
    COUNT(*) AS total_status_events
FROM healthcare_ops.claim_status_history
GROUP BY claim_id
HAVING COUNT(*) > 1
ORDER BY total_status_events DESC;

-- Step 06 — Count Claims with Multiple Status Events
SELECT * FROM claim_status_history;
SELECT 
	COUNT(*) AS claims_with_multiple_events
FROM (
	SELECT 
		claim_id
	FROM claim_status_history
	GROUP BY claim_id
	HAVING COUNT(*) > 1
) AS claim_events;

-- Step 07: Status Transition Analysis
-- Business Question: What was each claim's previous status, and what is its current recorded status in the history sequence?

SELECT 
		claim_id,
        event_at, 
        status AS current_status,
        LAG(status) OVER(
        PARTITION BY claim_id
        ORDER BY event_id
        ) AS  previous_status
FROM claim_status_history
ORDER BY claim_id, event_at;


-- Step 08 — Count Status Transitions
-- Business Question: How many status history records represent a change from the previous status?
SELECT * FROM claim_status_history;

WITH status_history AS (
	SELECT 
			claim_id,
			event_id,
			status AS current_status,
			event_at,
			LAG(status) OVER(
				PARTITION BY claim_id
				ORDER BY STR_TO_DATE(event_at, '%%c/%e/%Y %H:%i'), event_id
			) AS previous_status
	FROM claim_status_history
)
SELECT
		COUNT(*) AS total_status_changes
FROM status_history
WHERE previous_status IS NOT NULL 
	AND current_status <> previous_status;

-- Step 09: Most Common Status Transitions
-- Business Question: Which status transitions occur most frequently in medical claims?

WITH status_history AS (
    SELECT
        claim_id,
        status AS current_status,
        LAG(status) OVER (
            PARTITION BY claim_id
            ORDER BY STR_TO_DATE(event_at, '%c/%e/%Y %H:%i'), event_id
        ) AS previous_status
    FROM healthcare_ops.claim_status_history
)
SELECT
    previous_status,
    current_status,
    COUNT(*) AS total_transitions
FROM status_history
WHERE previous_status IS NOT NULL
  AND current_status <> previous_status
GROUP BY previous_status, current_status
ORDER BY total_transitions DESC;

-- Step 10: Payer-wise Claim Denial Analysis
-- Business Question: Which insurance payer has the highest claim denial rate?

SELECT * FROM medical_claims;

SELECT 
		payer,
        COUNT(*) AS total_claims,
        SUM(
			CASE
				WHEN current_status = 'Denied'
				THEN 1 ELSE 0
			END
        ) AS total_denied,
        ROUND(
			SUM(
				CASE
					WHEN current_status = 'Denied'
					THEN 1 ELSE 0
                END
            ) * 100 / NULLIF(COUNT(*),0)
        ,2) AS denied_rate
FROM medical_claims
GROUP BY payer
ORDER BY denied_rate DESC;
		
-- Step 11: Payer-wise Denied Claim Amount Analysis
-- Business Question: Which insurance payer has the highest total denied claim amount?
SELECT * FROM medical_claims;

SELECT 
		payer,
        COUNT(*) AS denied_claims,
        ROUND(
			SUM(claim_amount)
            ,2) AS total_denied_amount
            
FROM medical_claims
WHERE current_status = 'Denied'
GROUP BY payer
ORDER BY total_denied_amount DESC;

-- Step 12: Average Denied Claim Amount by Payer
-- Business Question: Which insurance payer has the highest average denied claim amount?

SELECT
    payer,
    COUNT(*) AS denied_claims,
    ROUND(SUM(claim_amount), 2) AS total_denied_amount,
    ROUND(AVG(claim_amount), 2) AS avg_denied_amount
FROM healthcare_ops.medical_claims
WHERE current_status = 'Denied'
GROUP BY payer
ORDER BY avg_denied_amount DESC;

-- Step 13: Find High-Value Denied Claims
-- Business Question: Which denied medical claims have an amount greater than $2,000?

SELECT
    claim_id,
    payer,
    claim_amount,
    current_status
FROM healthcare_ops.medical_claims
WHERE current_status = 'Denied'
  AND claim_amount > 2000
ORDER BY claim_amount DESC;

-- Step 14: Claim Processing Time Analysis
-- Business QuestionHow many hours does each claim take from its first recorded event to its last recorded event?

SELECT
    claim_id,

    MIN(
        STR_TO_DATE(event_at, '%Y-%m-%d %H:%i:%s')
    ) AS first_event_time,

    MAX(
        STR_TO_DATE(event_at, '%Y-%m-%d %H:%i:%s')
    ) AS last_event_time,

    TIMESTAMPDIFF(
        HOUR,
        MIN(STR_TO_DATE(event_at, '%Y-%m-%d %H:%i:%s')),
        MAX(STR_TO_DATE(event_at, '%Y-%m-%d %H:%i:%s'))
    ) AS processing_hours

FROM healthcare_ops.claim_status_history
GROUP BY claim_id
ORDER BY processing_hours DESC;

-- Step 15: Average Claim Processing Time Analysis
-- Business Question: What is the average time between the first and last recorded status events for medical claims?

SELECT
    ROUND(AVG(processing_hours), 2) AS avg_processing_hours
FROM (
    SELECT
        claim_id,
        TIMESTAMPDIFF(
            HOUR,
            MIN(STR_TO_DATE(event_at, '%Y-%m-%d %H:%i:%s')),
            MAX(STR_TO_DATE(event_at, '%Y-%m-%d %H:%i:%s'))
        ) AS processing_hours
    FROM healthcare_ops.claim_status_history
    GROUP BY claim_id
) AS claim_processing;

-- Step 16: Identify Claims with Long Processing Times
-- Business Question: How many medical claims have a recorded processing duration longer than 72 hours?

SELECT
    COUNT(*) AS claims_over_72_hours
FROM (
    SELECT
        claim_id,
        TIMESTAMPDIFF(
            HOUR,
            MIN(STR_TO_DATE(event_at, '%Y-%m-%d %H:%i:%s')),
            MAX(STR_TO_DATE(event_at, '%Y-%m-%d %H:%i:%s'))
        ) AS processing_hours
    FROM healthcare_ops.claim_status_history
    GROUP BY claim_id
) AS claim_processing
WHERE processing_hours > 72;

-- Step 17: Payer-wise Average Claim Processing Time
-- Business Question: Which insurance payer has the longest average claim processing duration?

SELECT
    m.payer,
    COUNT(*) AS total_claims,
    ROUND(AVG(h.processing_hours), 2) AS avg_processing_hours
FROM healthcare_ops.medical_claims AS m
JOIN (
    SELECT
        claim_id,
        TIMESTAMPDIFF(
            HOUR,
            MIN(STR_TO_DATE(event_at, '%Y-%m-%d %H:%i:%s')),
            MAX(STR_TO_DATE(event_at, '%Y-%m-%d %H:%i:%s'))
        ) AS processing_hours
    FROM healthcare_ops.claim_status_history
    GROUP BY claim_id
) AS h
    ON m.claim_id = h.claim_id
GROUP BY m.payer
ORDER BY avg_processing_hours DESC;

-- Step 18: Find the Payer with the Most Long-Duration Claims
-- Business Question: Which insurance payer has the highest number of claims with a recorded duration greater than 72 hours?

SELECT
    m.payer,
    COUNT(*) AS claims_over_72_hours
FROM healthcare_ops.medical_claims AS m
JOIN (
    SELECT
        claim_id,
        TIMESTAMPDIFF(
            HOUR,
            MIN(STR_TO_DATE(event_at, '%Y-%m-%d %H:%i:%s')),
            MAX(STR_TO_DATE(event_at, '%Y-%m-%d %H:%i:%s'))
        ) AS processing_hours
    FROM healthcare_ops.claim_status_history
    GROUP BY claim_id
) AS h
    ON m.claim_id = h.claim_id
WHERE h.processing_hours > 72
GROUP BY m.payer
ORDER BY claims_over_72_hours DESC;

-- Step 19: Payer-wise Long-Duration Claim Rate Analysis


SELECT
    m.payer,
    COUNT(*) AS total_claims,
    SUM(
        CASE
            WHEN h.processing_hours > 72 THEN 1
            ELSE 0
        END
    ) AS claims_over_72_hours,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN h.processing_hours > 72 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS long_duration_rate
FROM healthcare_ops.medical_claims AS m
JOIN (
    SELECT
        claim_id,
        TIMESTAMPDIFF(
            HOUR,
            MIN(STR_TO_DATE(event_at, '%Y-%m-%d %H:%i:%s')),
            MAX(STR_TO_DATE(event_at, '%Y-%m-%d %H:%i:%s'))
        ) AS processing_hours
    FROM healthcare_ops.claim_status_history
    GROUP BY claim_id
) AS h
    ON m.claim_id = h.claim_id
GROUP BY m.payer
ORDER BY long_duration_rate DESC;

-- Step 20: Status-wise Average Processing Duration
SELECT * FROM healthcare_ops.claim_status_history;

WITH claim_events AS (
    SELECT
        claim_id,
        status,
        STR_TO_DATE(event_at, '%Y-%m-%d %H:%i:%s') AS event_time,

        ROW_NUMBER() OVER (
            PARTITION BY claim_id
            ORDER BY STR_TO_DATE(event_at, '%Y-%m-%d %H:%i:%s') DESC,
                     event_id DESC
        ) AS rn

    FROM healthcare_ops.claim_status_history
),

claim_summary AS (
    SELECT
        claim_id,

        TIMESTAMPDIFF(
            HOUR,
            MIN(event_time),
            MAX(event_time)
        ) AS processing_hours

    FROM claim_events
    GROUP BY claim_id
)

SELECT
    e.status AS last_status,
    COUNT(*) AS total_claims,
    ROUND(AVG(s.processing_hours), 2) AS avg_processing_hours

FROM claim_events AS e

JOIN claim_summary AS s
    ON e.claim_id = s.claim_id

WHERE e.rn = 1

GROUP BY e.status

ORDER BY avg_processing_hours DESC;


-- Step 21 — Repeated Claim Status Events
-- usiness Question: How many claims have experienced the Denied status more than once?

SELECT
    claim_id,
    COUNT(*) AS denied_count
FROM healthcare_ops.claim_status_history
WHERE status = 'Denied'
GROUP BY claim_id
HAVING COUNT(*) > 1
ORDER BY denied_count DESC;

-- Step 22: Data Quality Check
-- Step 22.1 — Unique Claim Count
SELECT
    COUNT(DISTINCT claim_id) AS unique_claims
FROM healthcare_ops.claim_status_history;

SELECT
    COUNT(DISTINCT claim_id) AS unique_claims
FROM healthcare_ops.medical_claims;

-- Are there any claims in medical_claims that are missing from claim_status_history?
SELECT 
		COUNT(*) AS claims_without_history
FROM healthcare_ops.medical_claims AS m
LEFT JOIN healthcare_ops.claim_status_history AS h
    ON m.claim_id = h.claim_id
WHERE h.claim_id IS NULL;

-- Are there any claims in claim_status_history that do not exist in medical_claims?
SELECT 
		COUNT(*) AS claims_without_main_record
FROM healthcare_ops.claim_status_history AS h
LEFT JOIN healthcare_ops.medical_claims AS m
    ON h.claim_id = m.claim_id
WHERE m.claim_id IS NULL;

-- Step 23 — Final KPI Summary
-- Business Question: What are the key performance indicators (KPIs) of the healthcare claims processing system?
SELECT
    COUNT(*) AS total_claims,
    
    SUM(
		CASE 
			WHEN current_status = 'Accepted'
			THEN 1 ELSE 0 
		END) AS accepted_claims,
        
    SUM(
		CASE 
			WHEN current_status = 'Denied'
			THEN 1 ELSE 0
		END) AS denied_claims,

    SUM(
		CASE 
			WHEN current_status = 'Pending'
			THEN 1 ELSE 0 
		END) AS pending_claims,

    ROUND(
        SUM(
			CASE 
				WHEN current_status = 'Denied'
				THEN 1 ELSE 0 
			END)*100 / NULLIF(COUNT(*),0)
    ,2) AS denial_rate,

    ROUND(SUM(claim_amount), 2) AS total_claim_amount,

    ROUND(AVG(claim_amount), 2) AS avg_claim_amount

FROM healthcare_ops.medical_claims;













