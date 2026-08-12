# 🏥 Healthcare Analysis using SQL & Power BI

## 📌 Project Overview

Healthcare Analysis is an end-to-end data analytics project focused on understanding hospital operations, patient demographics, doctor workload, diagnosis patterns, admissions, and hospital performance.

The project uses **MySQL** for database creation, data cleaning, SQL analysis, and business problem solving, followed by **Power BI** for data modeling, DAX calculations, visualization, and interactive dashboard development.

The project demonstrates the complete analytics workflow:

**Data → Cleaning → SQL Analysis → Business Insights → Power BI Dashboard**

---

## 🎯 Objectives

- Analyze patient demographics
- Evaluate doctor workload and performance
- Study hospital admission patterns
- Analyze diagnosis trends
- Measure hospital stay duration
- Analyze patient geographic distribution
- Identify high-volume diagnoses
- Monitor hospital admissions and discharges
- Calculate key hospital performance KPIs
- Build an interactive healthcare analytics dashboard

---

## 🗂 Dataset

The project uses four datasets:

| Table | Description |
|---|---|
| Patients | Patient demographic information |
| Admissions | Hospital admission records |
| Doctors | Doctor information |
| Province_Names | Province reference table |

---

## 🛠 Tools & Technologies

- **MySQL**
- **MySQL Workbench**
- **Power BI**
- **DAX**
- **Power Query**
- **Excel / CSV**
- **GitHub**

---

## 🧠 SQL Concepts Demonstrated

### SQL Fundamentals

- SELECT
- WHERE
- ORDER BY
- GROUP BY
- HAVING
- CASE
- Aggregate Functions

### Data Analysis

- INNER JOIN
- LEFT JOIN
- Subqueries
- EXISTS
- UNION
- UNION ALL

### Advanced SQL

- Common Table Expressions (CTEs)
- Recursive CTEs
- Window Functions
- ROW_NUMBER
- RANK
- DENSE_RANK
- LAG
- LEAD

### Database & Optimization

- Database Creation
- Data Cleaning
- Data Type Modification
- Primary Keys
- Foreign Keys
- Constraints
- Indexes
- Query Optimization

### Business Analytics

- KPI calculations
- Patient analysis
- Doctor performance analysis
- Admission analysis
- Diagnosis analysis
- Hospital performance analysis

---

## 📂 Project Structure

```text
Healthcare_Analysis/
│
├── Dataset/
│   ├── admissions.csv
│   ├── doctors.csv
│   ├── patients.csv
│   └── province_names.csv
│
├── SQL/
│   ├── 01_Database_Setup.sql
│   ├── 02_Data_Cleaning.sql
│   ├── 03_Constraints.sql
│   ├── 04_Assignment_Queries.sql
│   ├── 05_Business_Analysis.sql
│   └── 06_Advanced_Business_Analysis.sql
│
├── PowerBI/
│   └── Healthcare_Analysis.pbix
│
├── Images/
│   ├── Executive_Overview.png
│   ├── Patient_Analysis.png
│   ├── Doctor_Performance.png
│   ├── Diagnosis_Analysis.png
│   └── Hospital_Insights.png
│
└── README.md