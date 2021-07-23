WITH source as (

			SELECT VehicleKey, count(*) as num_of_vehicles	

				FROM(
						select *, CAST(IssueDate as date) as NewDate
						from FactParkingViolation

					)as tab1

				WHERE NewDate between '2015-01-01' and '2017-01-01'

				GROUP BY VehicleKey
		
				),


      group1 as (
				SELECT count(*) as more_then_10
				FROM source
				WHERE num_of_vehicles >=  10
				),
	
	 group2 as (
				SELECT count(*) as between_5_and_9
				FROM source
				WHERE num_of_vehicles between 5 and 9
				),

	 group3 as (
				SELECT count(*) as less_then_5
				FROM source
				WHERE num_of_vehicles < 5
				)


SELECT  (select * from group1) as more_then_10, (select * from group2)as between_5_and_9, (select * from group3) as less_then_5

