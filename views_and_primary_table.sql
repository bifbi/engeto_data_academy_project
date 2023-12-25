-- průměry mezd dle let a průměry cen jednotlivých potravin, opět podle let.

-- průměry mezd dle let
CREATE OR REPLACE VIEW payrolls_average_by_year AS
SELECT payroll_year, AVG(value) AS payroll_average
FROM czechia_payroll
WHERE value_type_code = 5958 AND calculation_code = 100
GROUP BY payroll_year
ORDER BY payroll_year;

-- průměry cen jednotlivých potravin dle let
CREATE OR REPLACE VIEW czechia_price_averages_by_year AS
SELECT category_code, czechia_price_category.name, YEAR(date_to) AS year, AVG(value) AS price_average
FROM czechia_price
JOIN czechia_price_category ON czechia_price_category.code = czechia_price.category_code
GROUP BY category_code, YEAR(date_to);

-- vytvoření primární tabulky
CREATE OR REPLACE TABLE t_minhhai_do_project_SQL_primary_final AS 
SELECT year, category_code, name, price_average, payroll_average
FROM czechia_price_averages_by_year
INNER JOIN payrolls_average_by_year ON payrolls_average_by_year.payroll_year = czechia_price_averages_by_year.YEAR
ORDER BY category_code, payroll_year;