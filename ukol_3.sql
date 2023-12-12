-- úkol 3
-- Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

-- roční průměry cen katergorií a jejich deviace
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

-- výpočet průměrem deviací u jednotlivých category code
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