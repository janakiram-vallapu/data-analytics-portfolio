-- =====================================================
-- HEALTHCARE ANALYSIS PROJECT
-- Author   : Janakiram Vallapu
-- Database : healthcare_analysis
-- File     : 01_Database_Setup.sql
-- Purpose  : Create and select the project database
-- =====================================================

CREATE DATABASE IF NOT EXISTS healthcare_analysis;

USE healthcare_analysis;

-- CSV files were imported using MySQL Workbench
-- Table Data Import Wizard in the following order:
--
-- 1. province_names
-- 2. patients
-- 3. doctors
-- 4. admissions