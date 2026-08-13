-- =====================================================
-- HEALTHCARE ANALYSIS PROJECT
-- Author   : Janakiram Vallapu
-- Database : healthcare_analysis
-- File     : 02_Data_Cleaning.sql
-- Purpose  : Clean imported data and standardize data types
-- =====================================================

USE healthcare_analysis;

-- =====================================================
-- 1. Inspect imported table structures
-- =====================================================

DESCRIBE province_names;
DESCRIBE patients;
DESCRIBE doctors;
DESCRIBE admissions;

-- =====================================================
-- 2. Inspect imported date formats
-- =====================================================

SELECT birth_date
FROM patients
LIMIT 5;

SELECT
    admission_date,
    discharge_date
FROM admissions
LIMIT 5;

-- =====================================================
-- 3. Convert imported date columns from TEXT to DATE
-- =====================================================

ALTER TABLE patients
MODIFY COLUMN birth_date DATE;

ALTER TABLE admissions
MODIFY COLUMN admission_date DATE,
MODIFY COLUMN discharge_date DATE;

-- =====================================================
-- 4. Standardize province_names data types
-- =====================================================

ALTER TABLE province_names
MODIFY COLUMN province_id CHAR(2),
MODIFY COLUMN province_name VARCHAR(50);

-- =====================================================
-- 5. Standardize patients data types
-- =====================================================

ALTER TABLE patients
MODIFY COLUMN first_name VARCHAR(50),
MODIFY COLUMN last_name VARCHAR(50),
MODIFY COLUMN gender CHAR(1),
MODIFY COLUMN city VARCHAR(100),
MODIFY COLUMN province_id CHAR(2),
MODIFY COLUMN allergies VARCHAR(100);

-- =====================================================
-- 6. Standardize doctors data types
-- =====================================================

ALTER TABLE doctors
MODIFY COLUMN first_name VARCHAR(50),
MODIFY COLUMN last_name VARCHAR(50),
MODIFY COLUMN specialty VARCHAR(100);

-- =====================================================
-- 7. Standardize admissions data types
-- =====================================================

ALTER TABLE admissions
MODIFY COLUMN diagnosis VARCHAR(100);

-- =====================================================
-- 8. Replace missing allergy values
-- =====================================================

UPDATE patients
SET allergies = 'NKA'
WHERE allergies IS NULL;

-- =====================================================
-- 9. Verify final table structures
-- =====================================================

DESCRIBE province_names;
DESCRIBE patients;
DESCRIBE doctors;
DESCRIBE admissions;

-- Identify invalid admission records where discharge
-- occurred before admission.

SELECT
    patient_id,
    admission_date,
    discharge_date,
    diagnosis
FROM admissions
WHERE discharge_date < admission_date;

-- Data Quality Check: Invalid admission records

SELECT
    COUNT(*) AS invalid_admission_records
FROM admissions
WHERE discharge_date < admission_date;

