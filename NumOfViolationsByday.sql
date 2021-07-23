CREATE PROCEDURE NumOfViolationsByday @dayOfWeek varchar(30)
AS

SELECT BoroughName, dw, count(*) as num_of_violations

FROM(

			SELECT *, DATENAME(dw, NewDate) as dw
			   FROM(
					select 	ParkingViolationKey,
							SummonsNumber,
							IssueDate,
							ViolationCode,
							ViolationTime,
							ViolationInFrontOfOrOpposite,
							VehicleKey,
							loc.LocationKey,
							StreetCode,
							StreetName,
							HouseNumber,
							City,
							StateCode,
							loc.BoroughCode,
							BoroughName , 
							CAST(IssueDate as date) as NewDate

						from FactParkingViolation as fact

						left join DimLocation as loc
						on fact.LocationKey = loc.LocationKey

						left join DimBorough as brg
						on loc.BoroughCode = brg.BoroughCode
				  ) as tab1

				WHERE tab1.NewDate between '2015-01-01' and '2017-01-01'
				      

) as tab2

WHERE dw = @dayOfWeek

GROUP BY BoroughName, dw

ORDER BY 1,2 


GO