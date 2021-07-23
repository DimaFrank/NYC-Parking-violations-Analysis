

WITH source_tab as (
				SELECT *
					FROM(
							select 	    	     
									SummonsNumber,
									IssueDate,
									ViolationCode,
									loc.LocationKey,
									StreetCode,
									StreetName,
									HouseNumber,
									City,
									StateCode,
									loc.BoroughCode,
									BoroughName , 
									CAST(IssueDate as date) as NewDate,
									vhc.* 

								from FactParkingViolation as fact

								left join DimLocation as loc
								on fact.LocationKey = loc.LocationKey

								left join DimBorough as brg
								on loc.BoroughCode = brg.BoroughCode

								left join DimVehicle as vhc
								on fact.VehicleKey = vhc.VehicleKey

						) as tab1

		),

		vehicle_2015 as (
						  select RegistrationStateCode, count(*) as year_2015
						  from source_tab
						  where NewDate between '2015-01-01' and '2015-12-31'
						  group by RegistrationStateCode

						),

		vehicle_2016 as (
						  select RegistrationStateCode, count(*) as year_2016
						  from source_tab
						  where NewDate between '2016-01-01' and '2016-12-31'
						  group by RegistrationStateCode

						),

		vehicle_2017 as (
						  select RegistrationStateCode, count(*) as year_2017
						  from source_tab
						  where NewDate between '2017-01-01' and '2017-12-31'
						  group by RegistrationStateCode
						)


				select v15.RegistrationStateCode,
					   StateName,
					   year_2015,
					   year_2016,
					   year_2017,
					CONCAT(CONVERT(varchar,(1 - ROUND( ( convert(float,year_2015) / convert(float,year_2017) ),3)  )*100),'%') as percent_of_change_2015_2017
					
				
					from vehicle_2015 as v15
					
					left join vehicle_2016  as v16
					on v15.RegistrationStateCode = v16.RegistrationStateCode

					left join vehicle_2017 as v17
					on v15.RegistrationStateCode = v17.RegistrationStateCode

					left join DimState as st
					on v15.RegistrationStateCode = st.StateCode
				
				order by 1,2

				
