-- =====================================================
-- HEALTHCARE ANALYSIS PROJECT
-- Author   : Janakiram Vallapu
-- Database : healthcare_analysis
-- File     : 04_Assignment_Queries.sql
-- Purpose  : Solve the given healthcare SQL questions
-- =====================================================

/*
=========================================================
                TABLE OF CONTENTS
=========================================================

Basic Filtering
---------------
Q01 - Male patients
Q02 - Patients without allergies
Q03 - First names starting with C
Q04 - Patients weighing 100-120 kg
Q05 - Replace NULL allergies

String Functions
----------------
Q06 - Full name
Q18 - Names starting and ending with S
Q28 - Formatted patient name

Joins
-----
Q07 - Province names
Q19 - Dementia patients
Q25 - Patients and doctors
Q34 - Patient, doctor and diagnosis

Date Functions
--------------
Q08 - Patients born in 2010
Q12 - Same-day admissions
Q16 - Birth years
Q27 - Patients born in the 1970s
Q31 - Admissions by day

Aggregations
------------
Q11 - Total admissions
Q13 - Admissions for patient 579
Q17 - Unique first names
Q21 - Male vs Female count
Q22 - Male vs Female count (duplicate)
Q23 - Multiple admissions
Q24 - Patients by city
Q26 - Allergy popularity
Q29 - Province height totals
Q30 - Weight difference
Q32 - Weight groups

Conditional Logic
-----------------
Q33 - BMI obesity classification

=========================================================
*/

USE healthcare_analysis;

-- =====================================================
-- QUESTION 1
-- Show the first name, last name, and gender of male
-- patients.
-- =====================================================

SELECT
    first_name,
    last_name,
    gender
FROM patients
WHERE gender = 'M';


-- =====================================================
-- QUESTION 2
-- Show the first and last names of patients who do not
-- have allergies.
--
-- Note: Run this query before Question 5 because
-- Question 5 replaces NULL values with 'NKA'.
-- =====================================================

SELECT
    first_name,
    last_name
FROM patients
WHERE allergies IS NULL;


-- =====================================================
-- QUESTION 3
-- Show the first names of patients whose names begin
-- with the letter C.
-- =====================================================

SELECT
    first_name
FROM patients
WHERE first_name LIKE 'C%';


-- =====================================================
-- QUESTION 4
-- Show patients whose weight is between 100 and 120 kg,
-- inclusive.
-- =====================================================

SELECT
    first_name,
    last_name
FROM patients
WHERE weight BETWEEN 100 AND 120;


-- =====================================================
-- QUESTION 5
-- Replace NULL allergy values with NKA
-- (No Known Allergies).
-- =====================================================

UPDATE patients
SET allergies = 'NKA'
WHERE allergies IS NULL;


-- =====================================================
-- QUESTION 6
-- Display each patient's full name in one column.
-- =====================================================

SELECT
    CONCAT(first_name, ' ', last_name) AS full_name
FROM patients;


-- =====================================================
-- QUESTION 7
-- Show each patient's name and full province name.
-- =====================================================

SELECT
    p.first_name,
    p.last_name,
    pn.province_name
FROM patients AS p
INNER JOIN province_names AS pn
    ON p.province_id = pn.province_id;


-- =====================================================
-- QUESTION 8
-- Count patients born during the year 2010.
-- =====================================================

SELECT
    COUNT(*) AS total_patients
FROM patients
WHERE birth_date >= '2010-01-01'
  AND birth_date < '2011-01-01';


-- =====================================================
-- QUESTION 9
-- Show all patients who share the greatest height.
-- =====================================================

SELECT
    first_name,
    last_name,
    height
FROM patients
WHERE height = (
    SELECT MAX(height)
    FROM patients
);


-- =====================================================
-- QUESTION 10
-- Show all columns for the specified patient IDs.
-- =====================================================

SELECT *
FROM patients
WHERE patient_id IN (1, 45, 534, 879, 1000);


-- =====================================================
-- QUESTION 11
-- Show the total number of admissions.
-- =====================================================

SELECT
    COUNT(*) AS total_admissions
FROM admissions;


-- =====================================================
-- QUESTION 12
-- Show admissions where the patient was admitted and
-- discharged on the same day.
-- =====================================================

SELECT *
FROM admissions
WHERE admission_date = discharge_date;

-- =====================================================
-- QUESTION 13
-- Show the total number of admissions for patient 579.
-- =====================================================

SELECT
    COUNT(*) AS total_admissions
FROM admissions
WHERE patient_id = 579;


-- =====================================================
-- QUESTION 14
-- Show unique cities located in province NS.
-- =====================================================

SELECT DISTINCT
    city
FROM patients
WHERE province_id = 'NS';


-- =====================================================
-- QUESTION 15
-- Show patients whose height is greater than 160 cm
-- and whose weight is greater than 70 kg.
-- =====================================================

SELECT
    first_name,
    last_name,
    birth_date
FROM patients
WHERE height > 160
  AND weight > 70;


-- =====================================================
-- QUESTION 16
-- Show unique birth years in ascending order.
-- =====================================================

SELECT DISTINCT
    YEAR(birth_date) AS birth_year
FROM patients
ORDER BY birth_year;


-- =====================================================
-- QUESTION 17
-- Show first names that occur only once.
-- =====================================================

SELECT
    first_name
FROM patients
GROUP BY first_name
HAVING COUNT(*) = 1;


-- =====================================================
-- QUESTION 18
-- Show patients whose first name starts and ends with S
-- and contains at least six characters.
-- =====================================================

SELECT
    patient_id,
    first_name
FROM patients
WHERE first_name LIKE 's%s'
  AND LENGTH(first_name) >= 6;


-- =====================================================
-- QUESTION 19
-- Show patients diagnosed with Dementia.
-- =====================================================

SELECT
    p.patient_id,
    p.first_name,
    p.last_name
FROM patients AS p
INNER JOIN admissions AS a
    ON p.patient_id = a.patient_id
WHERE a.diagnosis = 'Dementia';


-- =====================================================
-- QUESTION 20
-- Display every patient's first name, ordered first by
-- name length and then alphabetically.
-- =====================================================

SELECT
    first_name
FROM patients
ORDER BY
    LENGTH(first_name),
    first_name;


-- =====================================================
-- QUESTION 21
-- Show total male and female patients in the same row.
-- =====================================================

SELECT
    SUM(
        CASE
            WHEN gender = 'M' THEN 1
            ELSE 0
        END
    ) AS male_count,
    SUM(
        CASE
            WHEN gender = 'F' THEN 1
            ELSE 0
        END
    ) AS female_count
FROM patients;


-- =====================================================
-- QUESTION 22
-- This question is duplicated in the assignment.
-- The solution is the same as Question 21.
-- =====================================================

SELECT
    SUM(
        CASE
            WHEN gender = 'M' THEN 1
            ELSE 0
        END
    ) AS male_count,
    SUM(
        CASE
            WHEN gender = 'F' THEN 1
            ELSE 0
        END
    ) AS female_count
FROM patients;


-- =====================================================
-- QUESTION 23
-- Find patients admitted multiple times for the same
-- diagnosis.
-- =====================================================

SELECT
    patient_id,
    diagnosis
FROM admissions
GROUP BY
    patient_id,
    diagnosis
HAVING COUNT(*) > 1;


-- =====================================================
-- QUESTION 24
-- Show the number of patients in each city. Order from
-- highest to lowest count, then by city name.
-- =====================================================

SELECT
    city,
    COUNT(*) AS no_of_patients
FROM patients
GROUP BY city
ORDER BY
    no_of_patients DESC,
    city ASC;
    
-- =====================================================
-- QUESTION 25
-- Show the first name, last name, and role of every
-- patient and doctor.
-- =====================================================

SELECT
    first_name,
    last_name,
    'Patient' AS role
FROM patients

UNION ALL

SELECT
    first_name,
    last_name,
    'Doctor' AS role
FROM doctors;


-- =====================================================
-- QUESTION 26
-- Show allergies ordered by popularity and exclude
-- NULL values.
-- =====================================================

SELECT
    allergies,
    COUNT(*) AS popularity
FROM patients
WHERE allergies IS NOT NULL
GROUP BY allergies
ORDER BY popularity DESC;

-- NULL allergies were replaced with 'NKA' in Question 5.

-- =====================================================
-- QUESTION 27
-- Show patients born in the 1970s, ordered by earliest
-- birth date.
-- =====================================================

SELECT
    first_name,
    last_name,
    birth_date
FROM patients
WHERE YEAR(birth_date) BETWEEN 1970 AND 1979
ORDER BY birth_date;


-- =====================================================
-- QUESTION 28
-- Display each patient's full name as:
-- LAST_NAME,first_name
-- Last name uppercase, first name lowercase, ordered by
-- first name descending.
-- =====================================================

SELECT
    CONCAT(
        UPPER(last_name),
        ',',
        LOWER(first_name)
    ) AS full_name
FROM patients
ORDER BY first_name DESC;


-- =====================================================
-- QUESTION 29
-- Show province IDs where the total patient height is
-- at least 7,000.
-- =====================================================

SELECT
    province_id,
    SUM(height) AS total_height
FROM patients
GROUP BY province_id
HAVING SUM(height) >= 7000;


-- =====================================================
-- QUESTION 30
-- Show the difference between the maximum and minimum
-- weight of patients whose last name is Maroni.
-- =====================================================

SELECT
    MAX(weight) - MIN(weight) AS weight_difference
FROM patients
WHERE last_name = 'Maroni';


-- =====================================================
-- QUESTION 31
-- Show admission counts for each day of the month,
-- ordered from most to least admissions.
-- =====================================================

SELECT
    DAY(admission_date) AS day_of_month,
    COUNT(*) AS total_admissions
FROM admissions
GROUP BY DAY(admission_date)
ORDER BY total_admissions DESC;


-- =====================================================
-- QUESTION 32
-- Group patients into 10-kg weight groups and show the
-- number of patients in each group.
-- =====================================================

SELECT
    weight - MOD(weight, 10) AS weight_group,
    COUNT(*) AS total_patients
FROM patients
GROUP BY weight - MOD(weight, 10)
ORDER BY weight_group DESC;


-- =====================================================
-- QUESTION 33
-- Show whether each patient is obese.
-- Obesity is defined as BMI greater than or equal to 30.
-- =====================================================

SELECT
    patient_id,
    weight,
    height,
    CASE
        WHEN weight / POWER(height / 100, 2) >= 30 THEN 1
        ELSE 0
    END AS isObese
FROM patients;


-- =====================================================
-- QUESTION 34
-- Show Epilepsy patients treated by a doctor named Lisa,
-- together with the doctor's specialty.
-- =====================================================

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    d.specialty
FROM patients AS p
INNER JOIN admissions AS a
    ON p.patient_id = a.patient_id
INNER JOIN doctors AS d
    ON a.attending_doctor_id = d.doctor_id
WHERE a.diagnosis = 'Epilepsy'
  AND d.first_name = 'Lisa';
  
  