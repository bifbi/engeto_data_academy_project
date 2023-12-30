-- úkol 2
-- Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

-- výpočet průměrů ročních platů
SELECT payroll_year, AVG(value) AS avg_salary
FROM czechia_payroll cp
WHERE value_type_code = 5958 AND calculation_code = 100
GROUP BY payroll_year;

-- výpočet průměrné ceny mléka a chleba za rok
SELECT category_code, YEAR(date_from) AS year, avg(value) AS avg_price
FROM czechia_price cp
WHERE category_code IN (114201,111301)
GROUP BY YEAR(date_from), category_code;

-- výpočet L mléka a KG chleba za srovnatelné období
WITH salary_avg AS (SELECT payroll_year, AVG(value) AS avg_salary
FROM czechia_payroll cp
WHERE value_type_code = 5958 AND calculation_code = 100
GROUP BY payroll_year),
prices_avg AS (SELECT category_code, YEAR(date_from) AS year, avg(value) AS avg_price
FROM czechia_price cp
WHERE category_code IN (114201,111301)
GROUP BY YEAR(date_from), category_code)
SELECT *, FLOOR(avg_salary/avg_price) AS pieces
FROM prices_avg pa
JOIN salary_avg sa ON pa.YEAR = sa.payroll_year;