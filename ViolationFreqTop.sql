CREATE PROCEDURE ViolationPopularTop @topN int
AS


SELECT top (@topN) ViolationCode, count(*) as num
			   FROM(
					select 
							ViolationCode,
							CAST(IssueDate as date) as NewDate

						from FactParkingViolation as fact

						left join DimLocation as loc
						on fact.LocationKey = loc.LocationKey

						left join DimBorough as brg
						on loc.BoroughCode = brg.BoroughCode
				  ) as tab1

				WHERE tab1.NewDate between '2015-01-01' and '2017-01-01'

	GROUP BY ViolationCode
	ORDER BY 2 DESC

GO


