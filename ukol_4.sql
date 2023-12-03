-- Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

WITH price_deviation AS (
SELECT
        category_code,
        YEAR(date_from) AS years,
        AVG(value) AS year_average,
        ROUND(((AVG(czechia_price.value)/ LAG(AVG(czechia_price.value), 1) OVER (ORDER BY years)) - 1)* 100, 2) AS price_percent_deviation
FROM
        czechia_price
GROUP BY
        years
ORDER BY
        years)
SELECT
    payroll_year,
    price_percent_deviation,
    ROUND(((AVG(value)/ LAG(AVG(value), 1) OVER (ORDER BY payroll_year)) - 1)* 100, 2) AS payroll_percent_deviation,
    price_percent_deviation - ROUND(((AVG(value)/ LAG(AVG(value), 1) OVER (ORDER BY payroll_year)) - 1)* 100, 2) AS difference
FROM
    czechia_payroll
JOIN price_deviation ON
    price_deviation.years = czechia_payroll.payroll_year
WHERE
    value_type_code = 5958
    AND calculation_code = 100
    AND industry_branch_code IS NOT NULL
GROUP BY
    payroll_year
ORDER BY
    payroll_year;