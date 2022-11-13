/*
This quuery displays the correlation coefficient (r) and
coefficient of determination (r^2) between 2 fields for
every country in the world. Use of CTE is necessary to
for different layers of aggregation.

In this example:
--X: [new_cases]
--Y: [icu_patients]
*/

WITH resultSet AS
(
	SELECT
		[iso_code]
		,[continent]
		,[location]
		,[X_sd] = STDEV([new_cases]) OVER(PARTITION BY [iso_code], [continent], [location])
		,[T_sd] = STDEV([icu_patients]) OVER(PARTITION BY [iso_code], [continent], [location])
		,[SampleSize] = COUNT(*) OVER(PARTITION BY [iso_code], [continent], [location])
		,[ExpectedValue] = ([new_cases] - AVG([new_cases]) OVER(PARTITION BY [iso_code], [continent], [location])) * 
						   ([icu_patients] - AVG([icu_patients]) OVER(PARTITION BY [iso_code], [continent], [location]))
	FROM
		[dbo].[covid] s
)

SELECT
	[iso_code]
	,[continent]
	,[location]
	,[Correlation]
	,[Determination]=POWER([Correlation], 2)
FROM
(
	SELECT DISTINCT
		[iso_code]
		,[continent]
		,[location]
		,IIF(X_sd * T_sd = 0 or SampleSize - 1 = 0, 0,
		 SUM(ExpectedValue) OVER(PARTITION BY [iso_code], [continent], [location]) / (SampleSize - 1 ) / (X_sd * T_sd)) AS Correlation

	FROM
		resultSet 
) x
ORDER BY
	Correlation DESC