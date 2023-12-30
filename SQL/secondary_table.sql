CREATE OR REPLACE
TABLE t_minhhai_do_project_SQL_secondary_final AS
SELECT
    economies.country,
    economies.GDP,
    economies.gini,
    economies.population,
    economies.`year`
FROM economies
JOIN countries ON economies.country = countries.country
WHERE countries.continent = 'europe'
ORDER BY country, `year`;