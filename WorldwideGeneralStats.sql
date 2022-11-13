/*
This query displays:
	- Total cases
	- Percent of total cases relative to total population
	- Total deaths
	- Percent of total deaths relative to total population
	- Percent of total deaths relative to total cases (death rate among the infected)
	- Total population (for reference)

across all locations in the world.
*/
SELECT
	 [iso_code]
	,[continent]
	,[location]
	,Total_Cases=CAST(MAX(total_cases) as int)
	,[Total%Cases]=CAST((MAX(total_cases) / MAX([population])) * 100 as float)
	,Total_Deaths=CAST(MAX(total_deaths) as int)
	,[Total%Death]=CAST((MAX(total_deaths) / MAX([population])) * 100 as float)
	,[InfectedDeath%]=IIF(MAX([total_cases]) = 0, 0, CAST((MAX(total_deaths) / MAX([total_cases])) * 100 as float)) --IIF needed incase total_cases = 0
	,[population]=CAST(MAX([population]) as int)
FROM
	[dbo].[covid]
WHERE
	[iso_code] not like 'OWID%' -- codes starting with OWID is already aggregated data (i.e. 'OWID_WRL' contains covid data for the entire world)
GROUP BY
	 [iso_code]
	,[continent]
	,[location]
ORDER BY
	 [continent] DESC
	,[Total_Cases] DESC
