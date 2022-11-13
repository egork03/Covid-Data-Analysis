-- Simple query that shows the total amount of cases and total amount of deaths
-- for a valid location inputed in the WHERE clause. This particular case is
-- for all of America.
SELECT
	 [iso_code]
	,[continent]
	,[location]
	,[date]=MAX([date])
	,Total_Cases=CAST(SUM(new_cases) AS int)
	,Total_Deaths=CAST(SUM(new_deaths) AS int)
FROM
	[dbo].[covid]
WHERE
	[iso_code] = 'USA' AND
	[continent] = 'North America' AND
	[location] = 'United States'
GROUP BY
	 [iso_code]
	,[continent]
	,[location]