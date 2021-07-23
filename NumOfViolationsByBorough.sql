CREATE PROCEDURE NumOfViolationsByBorough @BoroughName nvarchar(30)
AS

		SELECT BoroughName, count(*) as n_of_violations

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
			and BoroughName = @BoroughName

		GROUP BY BoroughName

		ORDER BY 2 DESC

GO