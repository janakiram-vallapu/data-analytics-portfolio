-- =====================================================
-- HEALTHCARE ANALYSIS PROJECT
-- Author   : Janakiram Vallapu
-- Database : healthcare_analysis
-- File     : 03_Constraints.sql
-- Purpose  : Define table relationships and enforce data integrity
-- =====================================================

USE healthcare_analysis;

-- =====================================================
-- 1. Check for duplicate primary key values
-- =====================================================

-- province_names
SELECT
    province_id,
    COUNT(*) AS duplicate_count
FROM province_names
GROUP BY province_id
HAVING COUNT(*) > 1;

-- patients
SELECT
    patient_id,
    COUNT(*) AS duplicate_count
FROM patients
GROUP BY patient_id
HAVING COUNT(*) > 1;

-- doctors
SELECT
    doctor_id,
    COUNT(*) AS duplicate_count
FROM doctors
GROUP BY doctor_id
HAVING COUNT(*) > 1;

-- admissions
SELECT
    patient_id,
    admission_date,
    COUNT(*) AS duplicate_count
FROM admissions
GROUP BY patient_id, admission_date
HAVING COUNT(*) > 1;

-- =====================================================
-- 2. Add Primary Keys
-- =====================================================

ALTER TABLE province_names
ADD PRIMARY KEY (province_id);

ALTER TABLE patients
ADD PRIMARY KEY (patient_id);

ALTER TABLE doctors
ADD PRIMARY KEY (doctor_id);

ALTER TABLE admissions
ADD PRIMARY KEY (patient_id, admission_date);

-- =====================================================
-- 3. Verify Foreign Key Values
-- =====================================================

-- Check province_id values

SELECT DISTINCT
    p.province_id
FROM patients p
LEFT JOIN province_names pn
    ON p.province_id = pn.province_id
WHERE pn.province_id IS NULL;

-- Check patient_id values

SELECT DISTINCT
    a.patient_id
FROM admissions a
LEFT JOIN patients p
    ON a.patient_id = p.patient_id
WHERE p.patient_id IS NULL;

-- Check doctor_id values

SELECT DISTINCT
    a.attending_doctor_id
FROM admissions a
LEFT JOIN doctors d
    ON a.attending_doctor_id = d.doctor_id
WHERE d.doctor_id IS NULL;

-- =====================================================
-- 4. Add Foreign Keys
-- =====================================================

ALTER TABLE patients
ADD CONSTRAINT fk_patients_province
FOREIGN KEY (province_id)
REFERENCES province_names(province_id);

ALTER TABLE admissions
ADD CONSTRAINT fk_admissions_patient
FOREIGN KEY (patient_id)
REFERENCES patients(patient_id);

ALTER TABLE admissions
ADD CONSTRAINT fk_admissions_doctor
FOREIGN KEY (attending_doctor_id)
REFERENCES doctors(doctor_id);

-- =====================================================
-- 5. Verify Constraints
-- =====================================================

SHOW CREATE TABLE province_names;

SHOW CREATE TABLE patients;

SHOW CREATE TABLE doctors;

SHOW CREATE TABLE admissions;