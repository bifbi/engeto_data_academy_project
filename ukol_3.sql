-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

-- roční průměry cen katergorií
SELECT
	*,
	YEAR(date_from) AS years,
	AVG(value) AS year_average,
	ROUND(((AVG(value)/ LAG(AVG(value), 1) OVER (PARTITION BY category_code ORDER BY years)) - 1)* 100, 2) AS percent_deviation
FROM
	czechia_price cp
GROUP BY
	category_code,
	years
ORDER BY
	category_code,
	years;

-- výpočet průměrem deviací
WITH deviations AS 
(
SELECT
		*,
		YEAR(date_from) AS years,
		AVG(value) AS year_average,
		ROUND(((AVG(value)/ LAG(AVG(value), 1) OVER (PARTITION BY category_code ORDER BY years)) - 1)* 100, 2) AS percent_deviation
FROM
		czechia_price cp
GROUP BY
		category_code,
		years
ORDER BY
		category_code,
		years)
SELECT
	category_code,
	name,
	price_value,
	price_unit,
	AVG(percent_deviation) AS average_deviation
FROM
	deviations
JOIN czechia_price_category cpc ON
	deviations.category_code = cpc.code
GROUP BY
	category_code
ORDER BY
	average_deviation;
	
	
-- výpočet lineární regresí
WITH xy_coeficients AS (WITH deviations AS 
(
SELECT
		*,
		YEAR(date_from) AS years,
		AVG(value) AS year_average,
		ROUND(((AVG(value)/ LAG(AVG(value), 1) OVER (PARTITION BY category_code ORDER BY years)) - 1)* 100, 2) AS percent_deviation
FROM
		czechia_price cp
GROUP BY
		category_code,
		years
ORDER BY
		category_code,
		years
)
SELECT
	*,
	AVG(years) OVER (PARTITION BY category_code) AS avg_x,
	AVG(percent_deviation) OVER (PARTITION BY category_code) AS avg_y,
	years - AVG(years) OVER (PARTITION BY category_code) AS 'x_avg_x',
	percent_deviation - AVG(percent_deviation) OVER (PARTITION BY category_code) AS 'y_avg_y'
FROM
	deviations
WHERE
	percent_deviation IS NOT NULL
ORDER BY
	category_code,
	years)
SELECT
	category_code,
	name,
	avg_x,
	avg_y,
	x_avg_x,
	y_avg_y,
	SUM(x_avg_x * y_avg_y) / SUM(x_avg_x * x_avg_x) AS slope,
	avg_y - SUM(x_avg_x * y_avg_y) / SUM(x_avg_x * x_avg_x) * avg_x AS intercept
FROM
	xy_coeficients
JOIN czechia_price_category ON xy_coeficients.category_code = czechia_price_category.code
GROUP BY
	category_code
ORDER BY
	slope;