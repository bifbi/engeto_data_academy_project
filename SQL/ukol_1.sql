-- Úkol 1 - Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

WITH decreases AS (SELECT value, industry_branch_code, payroll_year, AVG(value) AS year_average,
CASE
	WHEN AVG(value) < LAG(AVG(value), 1) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) THEN "DECREASE"
	ELSE "INCREASE"
END AS comparison
FROM czechia_payroll
WHERE value_type_code = 5958 AND calculation_code = 100 AND industry_branch_code IS NOT NULL AND payroll_year BETWEEN 2006 AND 2018
GROUP BY payroll_year, industry_branch_code
ORDER BY industry_branch_code, payroll_year, payroll_quarter)
SELECT code, name, SUM(comparison = "INCREASE") AS count_of_increases, SUM(comparison = "DECREASE") AS count_of_decreases
FROM czechia_payroll_industry_branch
LEFT JOIN decreases ON decreases.industry_branch_code = czechia_payroll_industry_branch.code
GROUP BY code;

-- dodatečné zjištění, zda je konečná mzda u všech odvětví vyšší, než na začátku období
WITH decreases AS (SELECT value, industry_branch_code, payroll_year, AVG(value) AS year_average,
CASE
    WHEN AVG(value) < LAG(AVG(value), 1) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) THEN "DECREASE"
    ELSE "INCREASE"
END AS comparison
FROM czechia_payroll
WHERE value_type_code = 5958 AND calculation_code = 100 AND industry_branch_code IS NOT NULL AND payroll_year BETWEEN 2006 AND 2018
GROUP BY payroll_year, industry_branch_code
ORDER BY industry_branch_code, payroll_year, payroll_quarter)
SELECT code, name, payroll_year, year_average,
CASE
    WHEN year_average < LAG(year_average, 1) OVER (PARTITION BY code ORDER BY payroll_year) THEN "DECREASE"
    ELSE "INCREASE"
END AS first_vs_last_year
FROM czechia_payroll_industry_branch
LEFT JOIN decreases ON decreases.industry_branch_code = czechia_payroll_industry_branch.code
WHERE payroll_year IN (2006, 2018)
ORDER BY code, payroll_year;