CREATE DATABASE loan_approval_analysis;
USE loan_approval_analysis;
-- ============================================================
-- LOAN APPROVAL DATA ANALYSIS
-- SQL ANALYSIS
-- Table: loan_approved_clean
-- ============================================================


-- ============================================================
-- SECTION 1: BASIC SQL
-- ============================================================

-- Q1. View the first 10 records
SELECT *
FROM loan_approved_clean
LIMIT 10;


-- Q2. Total number of loan applications
SELECT
    COUNT(*)
FROM loan_approved_clean;


-- Q3. List all unique property areas
SELECT DISTINCT
    Property_Area
FROM loan_approved_clean;


-- Q4. Applicants who are self-employed and have applicant
-- income above 5000
SELECT *
FROM loan_approved_clean
WHERE Self_Employed = "Yes"
  AND ApplicantIncome > 5000;


-- Q5. Total number of approved loans
SELECT
    COUNT(*)
FROM loan_approved_clean
WHERE Loan_Status = "Y";


-- ============================================================
-- SECTION 2: AGGREGATION & GROUPING
-- ============================================================

-- Q6. Average loan amount by education level
SELECT
    Education,
    AVG(LoanAmount)
FROM loan_approved_clean
GROUP BY Education;


-- Q7. Average total income by marital status
SELECT
    Married,
    AVG(ApplicantIncome + CoapplicantIncome)
FROM loan_approved_clean
GROUP BY Married;


-- Q8. Average loan amount by credit history
SELECT
    Credit_History,
    AVG(LoanAmount)
FROM loan_approved_clean
GROUP BY Credit_History;


-- Q9. Total applications and approval rate by gender
SELECT
    Gender,
    COUNT(*) AS Total_Applications,
    COUNT(CASE WHEN Loan_Status = "Y" THEN 1 END)
        * 100 / COUNT(*) AS Approval_Rate
FROM loan_approved_clean
GROUP BY Gender;


-- Q10. Approval rate by property area
SELECT
    Property_Area,
    COUNT(CASE WHEN Loan_Status = "Y" THEN 1 END)
        * 100 / COUNT(*) AS Approval_Rate
FROM loan_approved_clean
GROUP BY Property_Area;


-- ============================================================
-- SECTION 3: FILTERING & CONDITIONS
-- ============================================================

-- Q11. Graduates who are not self-employed and have
-- loan amount greater than 150
SELECT
    Loan_ID
FROM loan_approved_clean
WHERE Education = "Graduate"
  AND Self_Employed = "No"
  AND LoanAmount > 150;


-- Q12. Approved loans from urban area with good credit history
SELECT *
FROM loan_approved_clean
WHERE Property_Area = "Urban"
  AND Credit_History = 1
  AND Loan_Status = "Y";


-- Q13. Top 5 applicants with the highest total income
SELECT
    Loan_ID,
    SUM(ApplicantIncome + CoapplicantIncome) AS Total_Income
FROM loan_approved_clean
GROUP BY Loan_ID
ORDER BY Total_Income DESC
LIMIT 5;


-- ============================================================
-- SECTION 4: CASE WHEN / DERIVED COLUMNS
-- ============================================================

-- Q14. Total income for each applicant
SELECT
    Loan_ID,
    ApplicantIncome + CoapplicantIncome AS Total_Income
FROM loan_approved_clean;


-- Q15. Classify applicants into Low, Medium and High
-- income groups
SELECT
    Loan_ID,
    ApplicantIncome,
    CASE
        WHEN ApplicantIncome < 3000 THEN "Low"
        WHEN ApplicantIncome < 5000 THEN "Medium"
        ELSE "High"
    END AS Income_Group
FROM loan_approved_clean;


-- Q16. Average loan amount for each income group
SELECT
    CASE
        WHEN ApplicantIncome < 3000 THEN "LOW"
        WHEN ApplicantIncome < 5000 THEN "MEDIUM"
        ELSE "High"
    END AS Income_Range,
    AVG(LoanAmount) AS Avg_Loan_Amount
FROM loan_approved_clean
GROUP BY
    CASE
        WHEN ApplicantIncome < 3000 THEN "LOW"
        WHEN ApplicantIncome < 5000 THEN "MEDIUM"
        ELSE "High"
    END;


-- ============================================================
-- SECTION 5: SUBQUERIES
-- ============================================================

-- Q17. Applicants whose loan amount is greater than
-- the overall average loan amount
SELECT
    Loan_ID
FROM loan_approved_clean
WHERE LoanAmount >
(
    SELECT
        AVG(LoanAmount)
    FROM loan_approved_clean
);


-- Q18. Property area with the highest average total income
SELECT
    Property_Area,
    AVG(ApplicantIncome + CoapplicantIncome) AS Avg_Total_Income
FROM loan_approved_clean
GROUP BY Property_Area
ORDER BY Avg_Total_Income DESC
LIMIT 1;


-- Q19. Applicants whose income is above the average income
-- of their education category
SELECT
    Loan_ID,
    Education,
    ApplicantIncome
FROM loan_approved_clean l
WHERE ApplicantIncome >
(
    SELECT
        AVG(l2.ApplicantIncome)
    FROM loan_approved_clean l2
    WHERE l2.Education = l.Education
);


-- ============================================================
-- SECTION 6: WINDOW FUNCTIONS
-- ============================================================

-- Q20. Rank applicants based on total income
-- Highest income gets rank 1
SELECT
    Loan_ID,
    DENSE_RANK() OVER
    (
        ORDER BY ApplicantIncome + CoapplicantIncome DESC
    ) AS Income_Rank
FROM loan_approved_clean;


-- Q21. Average loan amount per property area
-- using a window function
SELECT
    Property_Area,
    AVG(LoanAmount) OVER
    (
        PARTITION BY Property_Area
    ) AS Avg_Loan_Amount
FROM loan_approved_clean;


-- Q22. Approval rate by education
SELECT
    Education,
    COUNT(CASE WHEN Loan_Status = "Y" THEN 1 END)
        * 100 / COUNT(*) AS Approval_Rate
FROM loan_approved_clean
GROUP BY Education;


-- ============================================================
-- SECTION 7: BUSINESS ANALYSIS
-- ============================================================

-- Q23. Approval rate by credit history and education
SELECT
    Credit_History,
    Education,
    COUNT(CASE WHEN Loan_Status = "Y" THEN 1 END)
        * 100 / COUNT(*) AS Approval_Rate
FROM loan_approved_clean
GROUP BY Credit_History, Education;


-- Q24. Average loan amount and approval rate for
-- self-employed vs non-self-employed applicants
SELECT DISTINCT
    Self_Employed,
    AVG(LoanAmount) OVER
    (
        PARTITION BY Self_Employed
    ) AS Avg_Loan_Amount,

    COUNT(CASE WHEN Loan_Status = "Y" THEN 1 END)
        OVER (PARTITION BY Self_Employed)
        * 100
        / COUNT(*) OVER (PARTITION BY Self_Employed)
        AS Approval_Rate

FROM loan_approved_clean;


-- Q25. Top 10 applicants by loan amount
SELECT
    Loan_ID,
    Loan_Status,
    Credit_History,
    Property_Area
FROM loan_approved_clean
ORDER BY LoanAmount DESC
LIMIT 10;


-- ============================================================
-- END OF SQL ANALYSIS
-- ============================================================