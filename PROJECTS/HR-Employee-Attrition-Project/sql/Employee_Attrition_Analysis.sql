-- HR Employee Attrition Analysis - Final MySQL Queries
-- Assumes the cleaned data has already been imported as:
-- HR_Employee_Attrition_Cleaned

CREATE DATABASE IF NOT EXISTS hr_employee_attrition_analysis;
USE hr_employee_attrition_analysis;

-- 1. Display the first 10 rows from the table.
SELECT *
FROM HR_Employee_Attrition_Cleaned
LIMIT 10;

-- 2. Find the total number of employees in the company.
SELECT COUNT(*) AS total_employees
FROM HR_Employee_Attrition_Cleaned;

-- 3. List all unique departments.
SELECT DISTINCT Department
FROM HR_Employee_Attrition_Cleaned
ORDER BY Department;

-- 4. Show how many employees have left and how many are still working.
SELECT
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS employees_stayed
FROM HR_Employee_Attrition_Cleaned;

-- 5. Retrieve employees who work overtime.
SELECT EmployeeNumber, Department, JobRole, OverTime
FROM HR_Employee_Attrition_Cleaned
WHERE OverTime = 'Yes';

-- 6. Find the average monthly income of all employees.
SELECT ROUND(AVG(MonthlyIncome), 2) AS average_monthly_income
FROM HR_Employee_Attrition_Cleaned;

-- 7. Identify employees whose number of companies worked is missing.
SELECT EmployeeNumber, NumCompaniesWorked
FROM HR_Employee_Attrition_Cleaned
WHERE NumCompaniesWorked IS NULL;

-- 8. Find the employee(s) with the maximum monthly income.
SELECT EmployeeNumber, MonthlyIncome
FROM HR_Employee_Attrition_Cleaned
WHERE MonthlyIncome = (
    SELECT MAX(MonthlyIncome)
    FROM HR_Employee_Attrition_Cleaned
);

-- 9. Count the number of employees by gender.
SELECT Gender, COUNT(*) AS employee_count
FROM HR_Employee_Attrition_Cleaned
GROUP BY Gender
ORDER BY employee_count DESC;

-- 10. List employees who have just joined (less than one year at the company).
SELECT EmployeeNumber, Department, JobRole, YearsAtCompany
FROM HR_Employee_Attrition_Cleaned
WHERE YearsAtCompany < 1;

-- 11. Calculate the attrition rate by department.
SELECT
    Department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS attrition_rate
FROM HR_Employee_Attrition_Cleaned
GROUP BY Department
ORDER BY attrition_rate DESC;

-- 12. List the top 10 employees with the highest total working years.
SELECT EmployeeNumber, TotalWorkingYears
FROM HR_Employee_Attrition_Cleaned
ORDER BY TotalWorkingYears DESC, EmployeeNumber
LIMIT 10;

-- 13. Group employees into tenure categories and count employees in each.
SELECT
    CASE
        WHEN YearsAtCompany < 1 THEN '<1 year'
        WHEN YearsAtCompany BETWEEN 1 AND 3 THEN '1-3 years'
        WHEN YearsAtCompany BETWEEN 4 AND 6 THEN '4-6 years'
        ELSE '7+ years'
    END AS tenure_category,
    COUNT(*) AS employee_count
FROM HR_Employee_Attrition_Cleaned
GROUP BY tenure_category
ORDER BY
    CASE tenure_category
        WHEN '<1 year' THEN 1
        WHEN '1-3 years' THEN 2
        WHEN '4-6 years' THEN 3
        ELSE 4
    END;

-- 14. Find average monthly income by job level and attrition status.
SELECT
    JobLevel,
    Attrition,
    COUNT(*) AS employee_count,
    ROUND(AVG(MonthlyIncome), 2) AS average_monthly_income
FROM HR_Employee_Attrition_Cleaned
GROUP BY JobLevel, Attrition
ORDER BY JobLevel, Attrition;

-- 15. Identify the top 5 job roles with the highest number of employees who left.
SELECT
    JobRole,
    COUNT(*) AS employees_left
FROM HR_Employee_Attrition_Cleaned
WHERE Attrition = 'Yes'
GROUP BY JobRole
ORDER BY employees_left DESC, JobRole
LIMIT 5;

-- 16. List employees who left within their first year.
SELECT EmployeeNumber, Department, JobRole, YearsAtCompany
FROM HR_Employee_Attrition_Cleaned
WHERE Attrition = 'Yes'
  AND YearsAtCompany < 1;

-- 17. Calculate approximate new monthly income after the salary-hike percentage.
SELECT
    EmployeeNumber,
    MonthlyIncome AS current_monthly_income,
    PercentSalaryHike,
    ROUND(MonthlyIncome * (1 + PercentSalaryHike / 100.0), 2)
        AS estimated_new_monthly_income
FROM HR_Employee_Attrition_Cleaned;

-- 18. Count employees grouped by overtime status and attrition.
SELECT
    OverTime,
    Attrition,
    COUNT(*) AS employee_count
FROM HR_Employee_Attrition_Cleaned
GROUP BY OverTime, Attrition
ORDER BY OverTime, Attrition;

-- 19. Display the top 10 employees who attended the most training sessions last year.
SELECT EmployeeNumber, TrainingTimesLastYear
FROM HR_Employee_Attrition_Cleaned
ORDER BY TrainingTimesLastYear DESC, EmployeeNumber
LIMIT 10;

-- 20. Rank employees by total working years (most experienced = rank 1).
SELECT
    EmployeeNumber,
    TotalWorkingYears,
    DENSE_RANK() OVER (ORDER BY TotalWorkingYears DESC) AS experience_rank
FROM HR_Employee_Attrition_Cleaned
ORDER BY experience_rank, EmployeeNumber;

-- 21. For each department, find employees whose income is in its top 25%.
WITH department_income_quartiles AS (
    SELECT
        EmployeeNumber,
        Department,
        JobRole,
        MonthlyIncome,
        NTILE(4) OVER (
            PARTITION BY Department
            ORDER BY MonthlyIncome DESC
        ) AS income_quartile
    FROM HR_Employee_Attrition_Cleaned
)
SELECT EmployeeNumber, Department, JobRole, MonthlyIncome
FROM department_income_quartiles
WHERE income_quartile = 1
ORDER BY Department, MonthlyIncome DESC;

-- 22. Divide employees into 10 income deciles and find attrition rate for each decile.
WITH income_deciles AS (
    SELECT
        EmployeeNumber,
        MonthlyIncome,
        Attrition,
        NTILE(10) OVER (ORDER BY MonthlyIncome) AS income_decile
    FROM HR_Employee_Attrition_Cleaned
)
SELECT
    income_decile,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS attrition_rate
FROM income_deciles
GROUP BY income_decile
ORDER BY income_decile;

-- 23. Score employees on four pre-defined risk signals and list the top 50.
-- PerformanceRating is 3 or 4 in this dataset; 3 is treated as the lower rating.
WITH risk_scores AS (
    SELECT
        EmployeeNumber,
        Department,
        JobRole,
        YearsAtCompany,
        PerformanceRating,
        OverTime,
        WorkLifeBalance,
        (
            CASE WHEN YearsAtCompany <= 2 THEN 1 ELSE 0 END
            + CASE WHEN PerformanceRating = 3 THEN 1 ELSE 0 END
            + CASE WHEN OverTime = 'Yes' THEN 1 ELSE 0 END
            + CASE WHEN WorkLifeBalance <= 2 THEN 1 ELSE 0 END
        ) AS risk_score
    FROM HR_Employee_Attrition_Cleaned
)
SELECT
    EmployeeNumber,
    Department,
    JobRole,
    YearsAtCompany,
    PerformanceRating,
    OverTime,
    WorkLifeBalance,
    risk_score
FROM risk_scores
ORDER BY risk_score DESC, EmployeeNumber
LIMIT 50;

-- 24. Create a reusable department and job-level attrition summary view.
CREATE OR REPLACE VIEW vw_department_joblevel_attrition_summary AS
SELECT
    Department,
    JobLevel,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS number_of_leavers,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS attrition_rate,
    ROUND(AVG(MonthlyIncome), 2) AS average_monthly_income
FROM HR_Employee_Attrition_Cleaned
GROUP BY Department, JobLevel;

SELECT *
FROM vw_department_joblevel_attrition_summary
ORDER BY Department, JobLevel;
