-- Úkol 1 - Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

-- výběr dat [mzdy, fyzický, ne NULL]
SELECT *
FROM czechia_payroll
WHERE value_type_code = 5958 AND calculation_code = 100 AND industry_branch_code IS NOT NULL
ORDER BY industry_branch_code, payroll_year, payroll_quarter;

-- výpočet průměru pro jednotlivé odvětví v jednotlivých letech
SELECT value, industry_branch_code, payroll_year, AVG(value) AS year_average
FROM czechia_payroll
WHERE value_type_code = 5958 AND calculation_code = 100 AND industry_branch_code IS NOT NULL
GROUP BY payroll_year, industry_branch_code
ORDER BY industry_branch_code, payroll_year, payroll_quarter;

-- výpočet, zda je současný rok větší než předchozí rok
WITH year_average AS (SELECT value, industry_branch_code, payroll_year, AVG(value) AS year_average
FROM czechia_payroll
WHERE value_type_code = 5958 AND calculation_code = 100 AND industry_branch_code IS NOT NULL
GROUP BY payroll_year, industry_branch_code
ORDER BY industry_branch_code, payroll_year, payroll_quarter)
SELECT industry_branch_code, payroll_year, year_average,
CASE
	WHEN year_average < LAG(year_average, 1) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) THEN "DECREASE"
	ELSE "INCREASE"
END AS comparison
FROM year_average;

-- filtrace dat
WITH year_comparisons AS (WITH year_average AS (SELECT value, industry_branch_code, payroll_year, AVG(value) AS year_average
FROM czechia_payroll
WHERE value_type_code = 5958 AND calculation_code = 100 AND industry_branch_code IS NOT NULL
GROUP BY payroll_year, industry_branch_code
ORDER BY industry_branch_code, payroll_year, payroll_quarter)
SELECT industry_branch_code, payroll_year, year_average,
CASE
	WHEN year_average < LAG(year_average, 1) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) THEN "DECREASE"
	ELSE "INCREASE"
END AS comparison
FROM year_average)
SELECT DISTINCT(industry_branch_code), comparison
FROM year_comparisons
WHERE comparison = 'DECREASE';

-- finální kód
WITH decreases AS (WITH year_comparisons AS (WITH year_average AS (SELECT value, industry_branch_code, payroll_year, AVG(value) AS year_average
FROM czechia_payroll
WHERE value_type_code = 5958 AND calculation_code = 100 AND industry_branch_code IS NOT NULL
GROUP BY payroll_year, industry_branch_code
ORDER BY industry_branch_code, payroll_year, payroll_quarter)
SELECT industry_branch_code, payroll_year, year_average,
CASE
	WHEN year_average < LAG(year_average, 1) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) THEN "DECREASE"
	ELSE "INCREASE"
END AS comparison
FROM year_average)
SELECT DISTINCT(industry_branch_code), comparison
FROM year_comparisons
WHERE comparison = 'DECREASE')
SELECT code, name, comparison
FROM czechia_payroll_industry_branch
LEFT JOIN decreases ON decreases.industry_branch_code = czechia_payroll_industry_branch.code;

-- finální kód, optimalizovaný
WITH decreases AS (SELECT value, industry_branch_code, payroll_year, AVG(value) AS year_average,
CASE
	WHEN AVG(value) < LAG(AVG(value), 1) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) THEN "DECREASE"
	ELSE "INCREASE"
END AS comparison
FROM czechia_payroll
WHERE value_type_code = 5958 AND calculation_code = 100 AND industry_branch_code IS NOT NULL
GROUP BY payroll_year, industry_branch_code
ORDER BY industry_branch_code, payroll_year, payroll_quarter)
SELECT DISTINCT(code), name, comparison
FROM czechia_payroll_industry_branch
LEFT JOIN decreases ON decreases.industry_branch_code = czechia_payroll_industry_branch.code AND decreases.comparison = 'DECREASE';