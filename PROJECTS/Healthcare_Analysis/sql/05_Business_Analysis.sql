-- =====================================================
-- HEALTHCARE ANALYSIS PROJECT
-- Author   : Janakiram Vallapu
-- Database : healthcare_analysis
-- File     : 05_Business_Analysis.sql
-- Purpose  : Perform additional healthcare business analysis
-- =====================================================

USE healthcare_analysis;

-- ===========================================
-- Patient Analysis
-- ===========================================

-- Business Question 1: Total Patients by Gender

SELECT
    gender,
    COUNT(*) AS no_of_patients
FROM patients
GROUP BY gender;

-- Business Question 2: Average Height and Weight by Gender

SELECT
    gender,
    AVG(height) AS avg_height,
    AVG(weight) AS avg_weight
FROM patients
GROUP BY gender;

-- Business Question 3: Find the Oldest Patient(s)

SELECT
    patient_id,
    first_name,
    last_name,
    birth_date
FROM patients
WHERE birth_date = (
    SELECT MIN(birth_date)
    FROM patients
);

-- Business Question 4: Find the Youngest Patient(s)

SELECT
    patient_id,
    first_name,
    last_name,
    birth_date
FROM patients
WHERE birth_date = (
    SELECT MAX(birth_date)
    FROM patients
);

-- Business Question 5: Top 10 Cities by Patient Count

SELECT
    city,
    COUNT(*) AS total_patients
FROM patients
GROUP BY city
ORDER BY total_patients DESC
LIMIT 10;

SELECT * FROM patients;

-- Business Question 6: Top 5 Provinces by Patient Count

SELECT
    pn.province_name,
    COUNT(p.patient_id) AS total_patients
FROM province_names AS pn
INNER JOIN patients AS p
    ON pn.province_id = p.province_id
GROUP BY pn.province_name
ORDER BY total_patients DESC
LIMIT 5;

-- Business Question 7: Percentage of Patients with No Known Allergies

SELECT
    ROUND(
        SUM(CASE WHEN allergies = 'NKA' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS percentage_no_known_allergies
FROM patients;

-- Business Question 8: Top 5 Most Common Allergies

SELECT
    allergies,
    COUNT(*) AS total_patients
FROM patients
WHERE allergies <> 'NKA'
GROUP BY allergies
ORDER BY total_patients DESC
LIMIT 5;

-- Business Question 9: Average Age by Gender

SELECT
    gender,
    ROUND(AVG(TIMESTAMPDIFF(YEAR, birth_date, CURDATE())), 2) AS average_age
FROM patients
GROUP BY gender;

-- Business Question 10: Patient Distribution by Age Group

WITH patient_age AS
(
    SELECT
        TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age
    FROM patients
)

SELECT
    CASE
        WHEN age BETWEEN 0 AND 17 THEN 'Child'
        WHEN age BETWEEN 18 AND 59 THEN 'Adult'
        ELSE 'Senior'
    END AS age_group,
    COUNT(*) AS total_patients
FROM patient_age
GROUP BY age_group;

-- Business Question 10: Patient Distribution by Age Group

SELECT 
    CASE 
    WHEN TIMESTAMPDIFF(YEAR,birth_date,CURDATE()) BETWEEN 0 AND 17 THEN 'CHILD'
    WHEN TIMESTAMPDIFF(YEAR,birth_date,CURDATE()) BETWEEN 18 AND 59 THEN 'ADULT'
    ELSE 'SENIOR'
    END AS age_group,
    COUNT(*) AS total_patients
    FROM patients
    GROUP BY age_group;
    
-- Business Question 11: Average Hospital Stay by Diagnosis

SELECT
    diagnosis,
    ROUND(
        AVG(DATEDIFF(discharge_date, admission_date)),
        2
    ) AS avg_length_of_stay
FROM admissions
WHERE discharge_date >= admission_date
GROUP BY diagnosis
ORDER BY avg_length_of_stay DESC;

-- Business Question 12: Top 10 Diagnoses by Valid Admissions

SELECT
    diagnosis,
    COUNT(*) AS total_admissions
FROM admissions
WHERE discharge_date >= admission_date
GROUP BY diagnosis
ORDER BY total_admissions DESC
LIMIT 10;

-- Business Question 13: Doctor(s) Who Treated the Most Patients

WITH doctor_patient_count AS
(
    SELECT
        d.doctor_id,
        CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
        COUNT(a.patient_id) AS total_patients
    FROM doctors AS d
    INNER JOIN admissions AS a
        ON a.attending_doctor_id = d.doctor_id
    GROUP BY
        d.doctor_id,
        d.first_name,
        d.last_name
)

SELECT *
FROM doctor_patient_count
WHERE total_patients = (
    SELECT MAX(total_patients)
    FROM doctor_patient_count
);


-- Business Question 14: Top 5 Doctors by Unique Patients Treated

SELECT
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    COUNT(DISTINCT a.patient_id) AS unique_patients
FROM admissions AS a
INNER JOIN doctors AS d
    ON a.attending_doctor_id = d.doctor_id
GROUP BY
    d.doctor_id,
    d.first_name,
    d.last_name
ORDER BY unique_patients DESC
LIMIT 5;


-- Business Question 15: Doctor with the Highest Average Length of Stay

SELECT
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    ROUND(
        AVG(DATEDIFF(a.discharge_date, a.admission_date)),
        2
    ) AS average_length_of_stay
FROM admissions AS a
INNER JOIN doctors AS d
    ON a.attending_doctor_id = d.doctor_id
WHERE a.discharge_date >= a.admission_date
GROUP BY
    d.doctor_id,
    d.first_name,
    d.last_name
ORDER BY average_length_of_stay DESC
LIMIT 1;



-- Business Question 16: Monthly Admission Trend

SELECT
    YEAR(admission_date) AS admission_year,
    MONTH(admission_date) AS admission_month,
    COUNT(*) AS total_valid_admissions
FROM admissions
WHERE discharge_date >= admission_date
GROUP BY
    YEAR(admission_date),
    MONTH(admission_date)
ORDER BY
    admission_year,
    admission_month;
   
-- Business Question 17: Diagnosis with the Longest Average Hospital Stay

SELECT
    diagnosis,
    ROUND(
        AVG(DATEDIFF(discharge_date, admission_date)),
        2
    ) AS average_length_of_stay
FROM admissions
WHERE discharge_date >= admission_date
GROUP BY diagnosis
ORDER BY average_length_of_stay DESC
LIMIT 1;


-- Business Question 18: Top 5 Doctors by Total Hospital Days

SELECT
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    SUM(DATEDIFF(a.discharge_date, a.admission_date)) AS total_hospital_days
FROM doctors AS d
INNER JOIN admissions AS a
    ON a.attending_doctor_id = d.doctor_id
WHERE a.discharge_date >= a.admission_date
GROUP BY
    d.doctor_id,
    d.first_name,
    d.last_name
ORDER BY total_hospital_days DESC
LIMIT 5;


-- Business Question 19: Patients with Multiple Admissions

SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_full_name,
    COUNT(a.patient_id) AS total_admissions
FROM patients AS p
INNER JOIN admissions AS a
    ON p.patient_id = a.patient_id
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name
HAVING COUNT(a.patient_id) > 1
ORDER BY total_admissions DESC;

-- Business Question 20: Patients with the Greatest Total Hospital Stay

SELECT
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_full_name,
    SUM(DATEDIFF(a.discharge_date, a.admission_date)) AS total_hospital_days
FROM patients AS p
INNER JOIN admissions AS a
    ON p.patient_id = a.patient_id
WHERE a.discharge_date >= a.admission_date
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name
ORDER BY
    total_hospital_days DESC,
    patient_full_name;

