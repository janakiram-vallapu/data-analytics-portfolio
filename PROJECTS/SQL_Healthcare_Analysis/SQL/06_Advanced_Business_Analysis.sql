

-- Advanced Business Question 21: Top 5 Provinces by Average Patient Weight

SELECT
    pn.province_name,
    ROUND(AVG(p.weight), 2) AS average_weight,
    COUNT(p.patient_id) AS total_patients
FROM province_names AS pn
INNER JOIN patients AS p
    ON pn.province_id = p.province_id
GROUP BY pn.province_name
ORDER BY average_weight DESC
LIMIT 5;

SELECT 
	pn.province_name,
    ROUND(SUM(CASE WHEN p.gender = 'M' THEN 1 ELSE 0 END) * 100/COUNT(p.patient_id),2)  AS male_percentage,
    COUNT(p.patient_id) AS total_patients
FROM province_names pn
INNER JOIN patients p
ON pn.province_id = p.province_id
GROUP BY pn.province_name
ORDER BY male_percentage DESC
LIMIT 3;

-- Advanced Business Question 22: Top 3 Provinces by Male Patient Percentage

SELECT
    pn.province_name,
    ROUND(
        SUM(CASE WHEN p.gender = 'M' THEN 1 ELSE 0 END) * 100.0
        / COUNT(p.patient_id),
        2
    ) AS male_percentage,
    COUNT(p.patient_id) AS total_patients
FROM province_names AS pn
INNER JOIN patients AS p
    ON pn.province_id = p.province_id
GROUP BY pn.province_name
ORDER BY male_percentage DESC
LIMIT 3;

-- Advanced Business Question 23:
-- Top 5 Diagnoses by Number of Readmitted Patients

WITH readmitted_patients AS
(
    SELECT
        diagnosis,
        patient_id
    FROM admissions
    GROUP BY
        diagnosis,
        patient_id
    HAVING COUNT(*) > 1
)

SELECT
    diagnosis,
    COUNT(patient_id) AS readmitted_patients
FROM readmitted_patients
GROUP BY diagnosis
ORDER BY readmitted_patients DESC
LIMIT 5;

-- Advanced Business Question 24:
-- Top 5 Doctors by Readmission Rate

WITH patient_admissions AS
(
    SELECT
        attending_doctor_id,
        patient_id,
        COUNT(*) AS admission_count
    FROM admissions
    GROUP BY
        attending_doctor_id,
        patient_id
),

doctor_metrics AS
(
    SELECT
        attending_doctor_id,
        COUNT(*) AS unique_patients,
        SUM(
            CASE
                WHEN admission_count > 1 THEN 1
                ELSE 0
            END
        ) AS readmitted_patients
    FROM patient_admissions
    GROUP BY attending_doctor_id
)

SELECT
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    ROUND(
        dm.readmitted_patients * 100.0 / dm.unique_patients,
        2
    ) AS readmission_rate,
    dm.unique_patients
FROM doctor_metrics AS dm
INNER JOIN doctors AS d
    ON dm.attending_doctor_id = d.doctor_id
ORDER BY readmission_rate DESC
LIMIT 5;


-- Advanced Business Question 25:
-- Top 3 Diagnoses in Each Province

SELECT
    province_name,
    diagnosis,
    total_admissions,
    diagnosis_rank
FROM
(
    SELECT
        pn.province_name,
        a.diagnosis,
        COUNT(*) AS total_admissions,
        DENSE_RANK() OVER
        (
            PARTITION BY pn.province_name
            ORDER BY COUNT(*) DESC
        ) AS diagnosis_rank
    FROM patients AS p
    INNER JOIN province_names AS pn
        ON p.province_id = pn.province_id
    INNER JOIN admissions AS a
        ON a.patient_id = p.patient_id
    WHERE a.discharge_date >= a.admission_date
    GROUP BY
        pn.province_name,
        a.diagnosis
) AS ranked_diagnoses
WHERE diagnosis_rank <= 3
ORDER BY
    province_name,
    diagnosis_rank,
    diagnosis;
    

-- Advanced Business Question 26:
-- Running Total of Daily Admissions

SELECT
    admission_date,
    COUNT(*) AS daily_admissions,
    SUM(COUNT(*)) OVER
    (
        ORDER BY admission_date
    ) AS running_total_admissions
FROM admissions
WHERE discharge_date >= admission_date
GROUP BY admission_date
ORDER BY admission_date;

-- Advanced Business Question 27:
-- 7-Day Moving Average of Daily Admissions

SELECT
    admission_date,
    COUNT(*) AS daily_admissions,
    ROUND(
        AVG(COUNT(*)) OVER
        (
            ORDER BY admission_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS moving_average_7_days
FROM admissions
WHERE discharge_date >= admission_date
GROUP BY admission_date
ORDER BY admission_date;



-- Advanced Business Question 28:
-- Compare Monthly Admissions with the Previous Month

WITH monthly_admissions AS
(
    SELECT
        YEAR(admission_date) AS admission_year,
        MONTH(admission_date) AS admission_month,
        COUNT(*) AS total_admissions
    FROM admissions
    WHERE discharge_date >= admission_date
    GROUP BY
        YEAR(admission_date),
        MONTH(admission_date)
)

SELECT
    admission_year,
    admission_month,
    total_admissions,
    LAG(total_admissions) OVER
    (
        ORDER BY admission_year, admission_month
    ) AS previous_month_admissions,
    total_admissions
        - LAG(total_admissions) OVER
        (
            ORDER BY admission_year, admission_month
        ) AS admission_difference
FROM monthly_admissions
ORDER BY
    admission_year,
    admission_month;
    

-- Advanced Business Question 29:
-- Each Doctor's Percentage Contribution to Valid Admissions

SELECT
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    COUNT(*) AS doctor_admissions,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS admission_percentage
FROM admissions AS a
INNER JOIN doctors AS d
    ON a.attending_doctor_id = d.doctor_id
WHERE a.discharge_date >= a.admission_date
GROUP BY
    d.doctor_id,
    d.first_name,
    d.last_name
ORDER BY admission_percentage DESC;


-- Advanced Business Question 30:
-- Top 5 Doctors by Average Admissions per Patient

SELECT
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    COUNT(DISTINCT a.patient_id) AS unique_patients,
    COUNT(*) AS total_admissions,
    ROUND(
        COUNT(*) * 1.0 / COUNT(DISTINCT a.patient_id),
        2
    ) AS average_admissions_per_patient
FROM admissions AS a
INNER JOIN doctors AS d
    ON a.attending_doctor_id = d.doctor_id
WHERE a.discharge_date >= a.admission_date
GROUP BY
    d.doctor_id,
    d.first_name,
    d.last_name
ORDER BY average_admissions_per_patient DESC
LIMIT 5;


-- =====================================================
-- Advanced Business Question 31
-- Top 10 Patients Who Visited the Most Different Doctors
-- =====================================================

SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_full_name,
    COUNT(DISTINCT d.doctor_id) AS different_doctors_visited
FROM patients AS p
INNER JOIN admissions AS a
    ON p.patient_id = a.patient_id
INNER JOIN doctors AS d
    ON a.attending_doctor_id = d.doctor_id
WHERE a.discharge_date >= a.admission_date
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name
ORDER BY
    different_doctors_visited DESC,
    patient_full_name ASC
LIMIT 10;


-- =====================================================
-- Advanced Business Question 32
-- Top 10 Patients by Total Hospital Stay
-- =====================================================

SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_full_name,
    COUNT(a.patient_id) AS total_admissions,
    SUM(
        DATEDIFF(a.discharge_date, a.admission_date)
    ) AS total_hospital_days,
    ROUND(
        AVG(DATEDIFF(a.discharge_date, a.admission_date)),
        2
    ) AS average_length_of_stay
FROM patients AS p
INNER JOIN admissions AS a
    ON p.patient_id = a.patient_id
WHERE a.discharge_date >= a.admission_date
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name
ORDER BY total_hospital_days DESC
LIMIT 10;

-- =====================================================
-- Advanced Business Question 33
-- Top 10 Admission Dates with the Highest Average
-- Length of Stay
-- =====================================================

SELECT
    admission_date,
    COUNT(*) AS total_admissions,
    ROUND(
        AVG(DATEDIFF(discharge_date, admission_date)),
        2
    ) AS average_length_of_stay
FROM admissions
WHERE discharge_date >= admission_date
GROUP BY admission_date
ORDER BY
    average_length_of_stay DESC,
    admission_date
LIMIT 10;


-- =====================================================
-- Advanced Business Question 34
-- Doctors Whose Average Stay Is Above the Hospital Average
-- =====================================================

WITH hospital_average_stay AS
(
    SELECT
        AVG(DATEDIFF(discharge_date, admission_date)) AS hospital_average_stay
    FROM admissions
    WHERE discharge_date >= admission_date
),

doctor_average_stay AS
(
    SELECT
        attending_doctor_id,
        AVG(DATEDIFF(discharge_date, admission_date)) AS doctor_average_stay
    FROM admissions
    WHERE discharge_date >= admission_date
    GROUP BY attending_doctor_id
)

SELECT
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    ROUND(das.doctor_average_stay, 2) AS doctor_average_stay,
    ROUND(has.hospital_average_stay, 2) AS hospital_average_stay
FROM doctor_average_stay AS das
INNER JOIN doctors AS d
    ON das.attending_doctor_id = d.doctor_id
CROSS JOIN hospital_average_stay AS has
WHERE das.doctor_average_stay > has.hospital_average_stay
ORDER BY doctor_average_stay DESC;

-- =====================================================
-- Advanced Business Question 35
-- Top 5 Doctors by Difference Between Longest and
-- Shortest Valid Patient Stay
-- =====================================================

SELECT
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    MAX(DATEDIFF(a.discharge_date, a.admission_date)) AS longest_stay,
    MIN(DATEDIFF(a.discharge_date, a.admission_date)) AS shortest_stay,
    MAX(DATEDIFF(a.discharge_date, a.admission_date))
        - MIN(DATEDIFF(a.discharge_date, a.admission_date)) AS stay_range
FROM doctors AS d
INNER JOIN admissions AS a
    ON d.doctor_id = a.attending_doctor_id
WHERE a.discharge_date >= a.admission_date
GROUP BY
    d.doctor_id,
    d.first_name,
    d.last_name
ORDER BY
    stay_range DESC,
    d.doctor_id
LIMIT 5;

-- =====================================================
-- Advanced Business Question 36
-- Top 5 Most Consistent Doctors Based on Patient Stay
-- =====================================================

SELECT
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    ROUND(
        AVG(DATEDIFF(a.discharge_date, a.admission_date)),
        2
    ) AS average_stay,
    ROUND(
        STDDEV(DATEDIFF(a.discharge_date, a.admission_date)),
        2
    ) AS standard_deviation
FROM doctors AS d
INNER JOIN admissions AS a
    ON d.doctor_id = a.attending_doctor_id
WHERE a.discharge_date >= a.admission_date
GROUP BY
    d.doctor_id,
    d.first_name,
    d.last_name
ORDER BY
    standard_deviation ASC,
    average_stay DESC
LIMIT 5;

-- =====================================================
-- Advanced Business Question 37
-- Patients with Multiple Admissions to the Same Doctor
-- =====================================================

SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_full_name,
    COUNT(a.patient_id) AS total_admissions,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name
FROM patients AS p
INNER JOIN admissions AS a
    ON p.patient_id = a.patient_id
INNER JOIN doctors AS d
    ON a.attending_doctor_id = d.doctor_id
WHERE a.discharge_date >= a.admission_date
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name,
    d.doctor_id,
    d.first_name,
    d.last_name
HAVING
    COUNT(a.patient_id) > 1
    AND COUNT(DISTINCT d.doctor_id) = 1
ORDER BY
    total_admissions DESC,
    patient_full_name;
    

-- =====================================================
-- Advanced Business Question 38
-- Top 10 Patients Whose Average Stay Is Above the
-- Overall Hospital Average
-- =====================================================

WITH patient_average_stay AS
(
    SELECT
        patient_id,
        COUNT(*) AS total_admissions,
        AVG(DATEDIFF(discharge_date, admission_date)) AS patient_average_stay
    FROM admissions
    WHERE discharge_date >= admission_date
    GROUP BY patient_id
),

hospital_average_stay AS
(
    SELECT
        AVG(DATEDIFF(discharge_date, admission_date)) AS hospital_average_stay
    FROM admissions
    WHERE discharge_date >= admission_date
)

SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_full_name,
    pas.total_admissions,
    ROUND(pas.patient_average_stay, 2) AS patient_average_stay,
    ROUND(has.hospital_average_stay, 2) AS hospital_average_stay
FROM patient_average_stay AS pas
INNER JOIN patients AS p
    ON pas.patient_id = p.patient_id
CROSS JOIN hospital_average_stay AS has
WHERE pas.patient_average_stay > has.hospital_average_stay
ORDER BY
    patient_average_stay DESC,
    total_admissions DESC
LIMIT 10;


-- =====================================================
-- Advanced Business Question 39
-- Top 5 Diagnoses by Readmission Percentage
-- =====================================================

WITH patient_diagnosis_admissions AS
(
    SELECT
        diagnosis,
        patient_id,
        COUNT(*) AS admission_count
    FROM admissions
    WHERE discharge_date >= admission_date
    GROUP BY
        diagnosis,
        patient_id
)

SELECT
    diagnosis,
    COUNT(*) AS unique_patients,
    SUM(
        CASE
            WHEN admission_count > 1 THEN 1
            ELSE 0
        END
    ) AS readmitted_patients,
    ROUND(
        SUM(
            CASE
                WHEN admission_count > 1 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS readmission_percentage
FROM patient_diagnosis_admissions
GROUP BY diagnosis
ORDER BY readmission_percentage DESC
LIMIT 5;

-- =====================================================
-- Advanced Business Question 40
-- Doctor Performance Scorecard
-- =====================================================

SELECT
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    COUNT(a.patient_id) AS total_admissions,
    COUNT(DISTINCT a.patient_id) AS unique_patients,
    ROUND(
        AVG(DATEDIFF(a.discharge_date, a.admission_date)),
        2
    ) AS average_length_of_stay,
    MAX(DATEDIFF(a.discharge_date, a.admission_date)) AS longest_stay,
    MIN(DATEDIFF(a.discharge_date, a.admission_date)) AS shortest_stay
FROM doctors AS d
INNER JOIN admissions AS a
    ON d.doctor_id = a.attending_doctor_id
WHERE a.discharge_date >= a.admission_date
GROUP BY
    d.doctor_id,
    d.first_name,
    d.last_name
ORDER BY
    total_admissions DESC,
    doctor_name ASC;