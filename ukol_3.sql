-- úkol 3
-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

WITH 
deviations AS (
    SELECT
        category_code,
        name,
        YEAR,
        price_average,
        (price_average / LAG(price_average, 1) OVER (PARTITION BY category_code ORDER BY category_code, YEAR) - 1)* 100 AS percent_deviation
    FROM
        t_minhhai_do_project_SQL_primary_final
    ORDER BY
        category_code,
        YEAR),
xy_coeficients AS (
    SELECT  
        *,
        AVG(year) OVER (PARTITION BY category_code) AS avg_x,
        AVG(percent_deviation) OVER (PARTITION BY category_code) AS avg_y,
        year - AVG(year) OVER (PARTITION BY category_code) AS 'x_avg_x',
        percent_deviation - AVG(percent_deviation) OVER (PARTITION BY category_code) AS 'y_avg_y'
    FROM deviations
    WHERE percent_deviation IS NOT NULL
    ORDER BY category_code, year)
SELECT
    xy_coeficients.category_code,
    xy_coeficients.name,
    SUM(x_avg_x * y_avg_y) / SUM(x_avg_x * x_avg_x) AS slope,
    avg_y - SUM(x_avg_x * y_avg_y) / SUM(x_avg_x * x_avg_x) * avg_x AS intercept
FROM
    xy_coeficients
GROUP BY
    category_code
ORDER BY
    slope;