
CREATE PROCEDURE topPopViolationBycolor @topN int
AS

SELECT ColorName, ViolationCode, num

FROM(

	SELECT * , ROW_NUMBER() over(partition by colorName Order by num DESC) as rank_id
	
	FROM(

		SELECT ColorName, ViolationCode, count(*) as num

		FROM(

			  SELECT *
			   FROM(
					select 
							ViolationCode,
							fact.VehicleKey,
							VehicleColorCode,
							colorName,
							CAST(IssueDate as date) as NewDate

						from FactParkingViolation as fact

						left join DimLocation as loc
						on fact.LocationKey = loc.LocationKey

						left join DimBorough as brg
						on loc.BoroughCode = brg.BoroughCode

						left join DimVehicle as vhc
						on fact.VehicleKey = vhc.VehicleKey
						
						left join DimColor as col
					    on vhc.VehicleColorCode= col.ColorCode
						
				  ) as tab1

				WHERE tab1.NewDate between '2015-01-01' and '2017-01-01'

		)as tab2

		WHERE ColorName not in ('UNKNOWN')

		GROUP BY ColorName, ViolationCode

	) as pre_final

) as final

WHERE rank_id <= @topN
ORDER BY 1,3 DESC

GO

