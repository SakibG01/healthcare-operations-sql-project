-- Task 03 — Step 1: Appointment Data Exploration
-- How many appointments are recorded in our healthcare system, and what are their current statuses?

SELECT * FROM healthcare_ops.appointments;

-- Step 1B — Appointment Status Breakdown
SELECT appointment_status,
		COUNT(*) AS Total_appointment
        FROM appointments
        GROUP BY appointment_status
        ORDER BY Total_appointment DESC;
        
SELECT 
		COUNT(*) AS Total_appointment
        FROM appointments
        ORDER BY Total_appointment DESC;

-- Step 2: Appointment Completion Rate
SELECT
    COUNT(*) AS total_appointments,
    SUM(
        CASE
            WHEN appointment_status = 'Completed'
            THEN 1 ELSE 0
        END
    ) AS completed_appointments,

    ROUND(
        SUM(
            CASE
                WHEN appointment_status = 'Completed'
                THEN 1 ELSE 0
            END
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS completion_rate

FROM healthcare_ops.appointments;

-- Step 3A — Cancellation Rate

SELECT
    COUNT(*) AS total_appointments,

    SUM(
        CASE
            WHEN appointment_status = 'Cancelled'
            THEN 1 ELSE 0
        END
    ) AS cancelled_appointments,

    ROUND(
        SUM(
            CASE
                WHEN appointment_status = 'Cancelled'
                THEN 1 ELSE 0
            END
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS cancellation_rate

FROM healthcare_ops.appointments;

-- Step 3B — No Show Rate
SELECT 
	COUNT(*) AS total_appointments,
    SUM(
		CASE
			WHEN appointment_status = 'No Show'
            THEN 1 ELSE 0
        END
    ) AS No_Show_appointments,
    
    ROUND(
		SUM(
			CASE
				WHEN appointment_status = 'No Show'
				THEN 1 ELSE 0
			END
        ) * 100 / NULLIF(COUNT(*),0)
    ,2) AS No_Show_rate
FROM appointments;

-- Task 03 — Step 4: Appointment KPI Summary

SELECT
    COUNT(*) AS total_appointments,

    SUM(CASE
        WHEN appointment_status = 'Completed'
        THEN 1 ELSE 0
    END) AS completed_count,

    SUM(CASE
        WHEN appointment_status = 'Cancelled'
        THEN 1 ELSE 0
    END) AS cancelled_count,

    SUM(CASE
        WHEN appointment_status = 'No Show'
        THEN 1 ELSE 0
    END) AS no_show_count,

    ROUND(
        SUM(CASE
            WHEN appointment_status = 'Completed'
            THEN 1 ELSE 0
        END) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS completion_rate,

    ROUND(
        SUM(CASE
            WHEN appointment_status = 'Cancelled'
            THEN 1 ELSE 0
        END) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS cancellation_rate,

    ROUND(
        SUM(CASE
            WHEN appointment_status = 'No Show'
            THEN 1 ELSE 0
        END) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS no_show_rate

FROM healthcare_ops.appointments;

-- Step 5: Provider-wise Appointment Performance Analysis
-- Which healthcare providers handle the most appointments, and how many appointments does each provider complete?

-- Step 5A — Total Appointments by Provider

SELECT
	provider_id, 
    COUNT(*) AS total_appointment
FROM appointments
GROUP BY provider_id
ORDER BY total_appointment DESC
LIMIT 10;

-- Step 5C: Provider-wise Appointment Status Analysis

SELECT
    provider_id,
    COUNT(*) AS total_appointments,
    SUM(
        CASE
            WHEN appointment_status = 'Completed'
            THEN 1 ELSE 0
        END
    ) AS completed_count,
    SUM(
        CASE
            WHEN appointment_status = 'Cancelled'
            THEN 1 ELSE 0
        END
    ) AS cancelled_count,
    SUM(
        CASE
            WHEN appointment_status = 'No Show'
            THEN 1 ELSE 0
        END
    ) AS no_show_count
FROM healthcare_ops.appointments
GROUP BY provider_id
ORDER BY total_appointments DESC
LIMIT 10;

-- Step 5D: Provider-wise Completion Rate
SELECT	provider_id,
		COUNT(*) AS total_appointments,
        SUM(
			CASE
				WHEN appointment_status = 'completed'
                THEN 1 ELSE 0
            END
        ) AS completed_count,
        ROUND(
			SUM(
				CASE
					WHEN appointment_status = 'completed'
                THEN 1 ELSE 0
                END
            ) * 100 / NULLIF(COUNT(*),0)
        ,2) AS completed_rate,
        
        ROUND(
			SUM(
				CASE
					WHEN appointment_status = 'Cancelled'
                    THEN 1 ELSE 0
                END
            ) * 100 / NULLIF(COUNT(*),0)
        ,2) AS Cancelled_rate,
        
        ROUND(
			SUM(
				CASE
					WHEN appointment_status = 'No Show'
                    THEN 1 ELSE 0
                END
            ) * 100 / NULLIF(COUNT(*),0)
        ,2) AS  No_Show_rate

FROM appointments
GROUP BY provider_id
HAVING COUNT(*) >= 100
ORDER BY completed_rate DESC;


-- WHERE
SELECT
    provider_id,
    COUNT(*) AS completed_appointments
FROM healthcare_ops.appointments
WHERE appointment_status = 'Completed'
GROUP BY provider_id;

-- Having
SELECT
    provider_id,
    COUNT(*) AS total_appointments
FROM healthcare_ops.appointments
GROUP BY provider_id
HAVING COUNT(*) >= 100
ORDER BY total_appointments DESC;

-- Where + Having
SELECT
    provider_id,
    COUNT(*) AS completed_appointments
FROM healthcare_ops.appointments
WHERE appointment_status = 'Completed'
GROUP BY provider_id
HAVING COUNT(*) >= 120
ORDER BY completed_appointments DESC;

-- Business Question: Which providers have handled at least 170 appointments?
SELECT 
	provider_id,
    COUNT(*) total_appointment
FROM appointments
GROUP BY provider_id
HAVING COUNT(*) >=170
ORDER BY total_appointment DESC;

-- Which providers have completed at least 130 appointments?

SELECT
    provider_id,
    COUNT(*) AS completed_appointments

FROM healthcare_ops.appointments
WHERE appointment_status = 'Completed'
GROUP BY provider_id
HAVING COUNT(*) >= 130
ORDER BY completed_appointments DESC;

-- Step 9: WHERE দিয়ে Completion Rate Calculate করলে কী ভুল হতে পারে?
-- Business Question -   What is the actual appointment completion rate for Provider 70?

SELECT
    provider_id,
    COUNT(*) AS total_appointments,

    SUM(CASE
        WHEN appointment_status = 'Completed'
        THEN 1 ELSE 0
    END) AS completed_appointments,

    ROUND(
        SUM(CASE
            WHEN appointment_status = 'Completed'
            THEN 1 ELSE 0
        END) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS completion_rate

FROM healthcare_ops.appointments
WHERE provider_id = 70
GROUP BY provider_id;

-- Step 10: Provider Performance Filtering
-- Business Question- Which providers have at least 150 appointments and a completion rate of 80% or higher?

SELECT provider_id,
		COUNT(*) AS total_appointment,
        
        SUM(
			CASE
				WHEN appointment_status = 'Completed'
                THEN 1 ELSE 0
            END
        ) AS completed_appointment,
        
        ROUND(
			SUM(
				CASE
					WHEN appointment_status = 'Completed'
					THEN 1 ELSE 0
                END
            ) * 100 / NULLIF(COUNT(*),2)
        ,2) AS completed_rate

FROM appointments
GROUP BY provider_id
HAVING COUNT(*) >=150
	AND completed_rate >= 80
ORDER BY completed_rate DESC;
 
-- Step 11 — Complete Provider Performance Report
-- Create a provider-level performance report showing total appointments, completed appointments, cancellations, no-shows, and their respective rates.

SELECT * FROM appointments;

SELECT  a.provider_id,
		p.provider_name,
		COUNT(*) AS total_appointment,
        
        SUM(
			CASE
				WHEN a.appointment_status = 'Completed'
                THEN 1 ELSE 0
            END
        ) AS total_completed,
        
        SUM(
			CASE
				WHEN a.appointment_status = 'Cancelled'
                THEN 1 ELSE 0
            END
        ) AS total_cancelled,
        
        SUM(
			CASE
				WHEN a.appointment_status = 'No SHow'
                THEN 1 ELSE 0
            END
        ) AS total_NoShow,
        
        ROUND(
			SUM(
			CASE
				WHEN a.appointment_status = 'Completed'
                THEN 1 ELSE 0
            END
        ) * 100 / NULLIF(COUNT(*),0)
        ,2) AS completed_rates,
        
		   ROUND(
			SUM(
			CASE
				WHEN a.appointment_status = 'Cancelled'
                THEN 1 ELSE 0
            END
        ) * 100 / NULLIF(COUNT(*),0)
         ,2) AS cancelled_rates,
        
        ROUND(
			SUM(
			CASE
				WHEN a.appointment_status = 'No Show'
                THEN 1 ELSE 0
            END
			) * 100 / NULLIF(COUNT(*),0)
         ,2) AS No_Show_rates
        
FROM appointments AS a
LEFT JOIN providers AS p
		 ON a.provider_id = p.provider_id
GROUP BY a.provider_id,
		 p.provider_name
ORDER BY completed_rates DESC;

-- Step 12: Monthly Appointment Trend Analysis
-- How many appointments were scheduled each month, and how does appointment volume change over time?

DESCRIBE healthcare_ops.appointments;

SELECT
    appointment_id,
    appointment_at
FROM healthcare_ops.appointments
LIMIT 10;

SELECT
    appointment_id,
    appointment_at,

    STR_TO_DATE(
        appointment_at,
        '%c/%e/%Y %H:%i'
    ) AS converted_date

FROM healthcare_ops.appointments
LIMIT 10;


SELECT
    YEAR(
        STR_TO_DATE(appointment_at, '%c/%e/%Y %H:%i')
    ) AS appointment_year,

    MONTH(
        STR_TO_DATE(appointment_at, '%c/%e/%Y %H:%i')
    ) AS appointment_month,

    COUNT(*) AS total_appointments

FROM healthcare_ops.appointments
GROUP BY
    appointment_year,
    appointment_month
ORDER BY
    appointment_year,
    appointment_month;
    
    
-- Business Question:  How many appointments were completed, cancelled, or marked as no-show each month?

SELECT
    YEAR(
        STR_TO_DATE(appointment_at, '%c/%e/%Y %H:%i')
    ) AS appointment_year,

    MONTH(
        STR_TO_DATE(appointment_at, '%c/%e/%Y %H:%i')
    ) AS appointment_month,

    COUNT(*) AS total_appointments,

    SUM(CASE
        WHEN appointment_status = 'Completed'
        THEN 1 ELSE 0
    END) AS completed_count,

    SUM(CASE
        WHEN appointment_status = 'Cancelled'
        THEN 1 ELSE 0
    END) AS cancelled_count,

    SUM(CASE
        WHEN appointment_status = 'No Show'
        THEN 1 ELSE 0
    END) AS no_show_count

FROM healthcare_ops.appointments
GROUP BY
    appointment_year,
    appointment_month
ORDER BY
    appointment_year,
    appointment_month;

-- Step 12E: Monthly Appointment Performance Rates

SELECT
    YEAR(
        STR_TO_DATE(appointment_at, '%c/%e/%Y %H:%i')
    ) AS appointment_year,

    MONTH(
        STR_TO_DATE(appointment_at, '%c/%e/%Y %H:%i')
    ) AS appointment_month,

    COUNT(*) AS total_appointments,

    ROUND(
        SUM(CASE
            WHEN appointment_status = 'Completed'
            THEN 1 ELSE 0
        END) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS completion_rate,

    ROUND(
        SUM(CASE
            WHEN appointment_status = 'Cancelled'
            THEN 1 ELSE 0
        END) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS cancellation_rate,

    ROUND(
        SUM(CASE
            WHEN appointment_status = 'No Show'
            THEN 1 ELSE 0
        END) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS no_show_rate

FROM healthcare_ops.appointments
GROUP BY
    appointment_year,
    appointment_month
ORDER BY
    appointment_year,
    appointment_month;

-- Step 13: Month-over-Month (MoM) Appointment Growth Analysis
-- Business Question:  How many appointments were scheduled each month, and how did the appointment volume change compared to the previous month?


WITH monthly_appointments AS (

    SELECT
        YEAR( STR_TO_DATE(appointment_at, '%c/%e/%Y %H:%i')
        ) AS appointment_year,

        MONTH( STR_TO_DATE(appointment_at, '%c/%e/%Y %H:%i')
        ) AS appointment_month,

        COUNT(*) AS total_appointments

    FROM healthcare_ops.appointments
    GROUP BY
        appointment_year,
        appointment_month
)

SELECT
    appointment_year,
    appointment_month,
    total_appointments,

    LAG(total_appointments) OVER (
        ORDER BY appointment_year, appointment_month
    ) AS previous_month_appointments

FROM monthly_appointments
ORDER BY
    appointment_year,
    appointment_month;

-- Step 13B: Month-over-Month (MoM) Appointment Growth Rate Calculation
-- What is the percentage increase or decrease in appointment volume compared to the previous month?
SELECT * FROM appointments;

WITH  monthly_appointments AS (
	SELECT
			YEAR(
				STR_TO_DATE(appointment_at, '%c/%e/%Y %H:%i')
			) AS appointment_year,
			MONTH(
				STR_TO_DATE(appointment_at, '%c/%e/%Y %H:%i')
			) AS appointment_month,
			COUNT(*) AS total_appointment 
	FROM appointments
	GROUP BY appointment_year,
			 appointment_month
),
monthly_comparison AS (
	SELECT 
			appointment_year,
            appointment_month,
            total_appointment,
            LAG(total_appointment) OVER(
            ORDER BY appointment_year,appointment_month
            ) AS previous_month_appointments
	 FROM monthly_appointments
)
SELECT 
		appointment_year,
		appointment_month,
		total_appointment,
		previous_month_appointments,
        ROUND(
			(total_appointment - previous_month_appointments)
             * 100 / NULLIF(previous_month_appointments,0)
        ,2) AS mom_growth_rate
FROM monthly_comparison
ORDER BY
    appointment_year,
    appointment_month;

-- Step 14: Identify the Highest and Lowest Appointment Growth Months
-- Which month experienced the highest appointment growth, and which month experienced the largest decline?

WITH monthly_appointments AS (
    SELECT
        YEAR(
            STR_TO_DATE(appointment_at, '%c/%e/%Y %H:%i')
        ) AS appointment_year,
        MONTH(
            STR_TO_DATE(appointment_at, '%c/%e/%Y %H:%i')
        ) AS appointment_month,
        COUNT(*) AS total_appointment
    FROM healthcare_ops.appointments
    GROUP BY
        appointment_year,
        appointment_month
),
monthly_comparison AS (
    SELECT
        appointment_year,
        appointment_month,
        total_appointment,
        LAG(total_appointment) OVER (
            ORDER BY appointment_year, appointment_month
        ) AS previous_month_appointments
    FROM monthly_appointments
),
monthly_growth AS (
    SELECT
        appointment_year,
        appointment_month,
        total_appointment,
        ROUND(
            (total_appointment - previous_month_appointments)
            * 100.0 / NULLIF(previous_month_appointments, 0),
            2
        ) AS mom_growth_rate
    FROM monthly_comparison
)
SELECT
    appointment_year,
    appointment_month,
    total_appointment,
    mom_growth_rate,

    ROW_NUMBER() OVER (
        ORDER BY mom_growth_rate DESC
    ) AS growth_rank

FROM monthly_growth
WHERE mom_growth_rate IS NOT NULL
ORDER BY growth_rank;

-- Step 15: Provider-wise Monthly Appointment Performance Analysis
-- How many appointments did each healthcare provider handle every month?

SELECT 
	a.provider_id,
    p.provider_name,
    
    YEAR(
		STR_TO_DATE(appointment_at, '%c/%e/%Y %H:%i')
    ) AS appointment_year,
    MONTH(
		STR_TO_DATE(appointment_at, '%c/%e/%Y %H:%i')
    ) AS appointment_month,
    COUNT(*) AS total_appointment
FROM appointments AS a
LEFT JOIN providers AS p
	ON a.provider_id = p.provider_id
GROUP BY
    a.provider_id,
    p.provider_name,
    appointment_year,
    appointment_month
ORDER BY
    a.provider_id,
    appointment_year,
    appointment_month;

-- Step 16: Provider-wise Monthly Performance Analysis
-- How does each provider's appointment performance vary month by month?

SELECT
    a.provider_id,
    p.provider_name,
    YEAR(
        STR_TO_DATE(a.appointment_at, '%c/%e/%Y %H:%i')
    ) AS appointment_year,
    MONTH(
        STR_TO_DATE(a.appointment_at, '%c/%e/%Y %H:%i')
    ) AS appointment_month,
    COUNT(*) AS total_appointments,
    SUM(
        CASE
            WHEN a.appointment_status = 'Completed'
            THEN 1 ELSE 0
        END
    ) AS completed_count,
    SUM(
        CASE
            WHEN a.appointment_status = 'Cancelled'
            THEN 1 ELSE 0
        END
    ) AS cancelled_count,
    SUM(
        CASE
            WHEN a.appointment_status = 'No Show'
            THEN 1 ELSE 0
        END
    ) AS no_show_count,
    ROUND(
        SUM(
            CASE
                WHEN a.appointment_status = 'Completed'
                THEN 1 ELSE 0
            END
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS completion_rate
FROM healthcare_ops.appointments a
LEFT JOIN healthcare_ops.providers p
    ON a.provider_id = p.provider_id
GROUP BY
    a.provider_id,
    p.provider_name,
    appointment_year,
    appointment_month
ORDER BY
    a.provider_id,
    appointment_year,
    appointment_month;

-- Step 17: Appointment Data Quality Validation
-- Are there any appointments with missing IDs, missing dates, or invalid statuses?
SELECT
    COUNT(*) AS total_appointments,
    SUM(
        CASE
            WHEN appointment_id IS NULL
            THEN 1 ELSE 0
        END
    ) AS missing_appointment_id,
    SUM(
        CASE
            WHEN appointment_at IS NULL
                 OR TRIM(appointment_at) = ''
            THEN 1 ELSE 0
        END
    ) AS missing_appointment_date,
    SUM(
        CASE
            WHEN appointment_status IS NULL
                 OR TRIM(appointment_status) = ''
            THEN 1 ELSE 0
        END
    ) AS missing_appointment_status
FROM healthcare_ops.appointments;

-- Step 18: Invalid Appointment Status Validation
-- Are all appointment statuses valid and consistent?
SELECT
    appointment_status,
    COUNT(*) AS total_records
FROM healthcare_ops.appointments
WHERE appointment_status IS NULL
   OR TRIM(appointment_status) = ''
   OR TRIM(appointment_status) NOT IN (
       'Completed',
       'Cancelled',
       'No Show'
   )
GROUP BY appointment_status;

-- Step 19 — Final Appointment Operations KPI Dashboard Query
-- মোট Appointment কতটি?
-- কতটি Completed, Cancelled ও No Show?
-- Completion Rate কত?
-- Cancellation Rate কত?
-- No Show Rate কত?

 SELECT 
		COUNT(*) AS total_appointment,
        SUM(
			CASE 
				WHEN appointment_status = 'Completed'
                THEN 1 ELSE 0
            END
        ) AS completed_apppointment,
		SUM(
			CASE 
				WHEN appointment_status = 'Cancelled'
                THEN 1 ELSE 0
            END
        ) AS Cancelled_apppointment,
		SUM(
			CASE 
				WHEN appointment_status = 'No Show'
                THEN 1 ELSE 0
            END
        ) AS No_Show_apppointment,
        ROUND(
			SUM(
				CASE
					WHEN appointment_status = 'Completed'
					THEN 1 ELSE 0
                END
            ) * 100 / NULLIF(COUNT(*),0)
        ,2) AS completed_rates,
        ROUND(
			SUM(
				CASE
					WHEN appointment_status = 'Cancelled'
					THEN 1 ELSE 0
                END
            ) * 100 / NULLIF(COUNT(*),0)
        ,2) AS cancellation_rates,
        ROUND(
			SUM(
				CASE
					WHEN appointment_status = 'No Show'
					THEN 1 ELSE 0
                END
            ) * 100 / NULLIF(COUNT(*),0)
        ,2) AS No_Show_rates
FROM appointments;



























