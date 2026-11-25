use md_water_services;

select audit.location_id as audit_location, 
	   audit.true_water_source_score as auditor_score,
-- vis.location_id as visit_location, this confirms that the location records for our auditor and visit are similar
		quali.record_id,
		quali.subjective_quality_score as employee_score
from auditor_report as audit
join visits as vis on audit.location_id = vis.location_id
join water_quality as quali on quali.record_id = vis.record_id
where audit.true_water_source_score = quali.subjective_quality_score
and vis.visit_count = 1
limit 10000;

-- to understand duplicated data
select
	audit.location_id as auditor_location,
	audit.type_of_water_source as audit_recording_source,
	sos.type_of_water_source as employee_recording_source,
	vis.record_id,
	audit.true_water_source_score as auditor_score,
	quali.subjective_quality_score as employee_score
from auditor_report as audit
join visits as vis on audit.location_id = vis.location_id
join water_source as sos on vis.source_id = sos.source_id
join water_quality as quali on vis.record_id = quali.record_id 
where audit.true_water_source_score != quali.subjective_quality_score;

-- we now look at the employees who made these errors
with incorrect_records as(
select
	audit.location_id as auditor_location,
	quali.record_id,
    emp.assigned_employee_id,
    emp.employee_name,
	audit.true_water_source_score as auditor_score,
	quali.subjective_quality_score as employee_score,
    audit.statements
from auditor_report as audit
join visits as vis on audit.location_id = vis.location_id
join water_quality as quali on quali.record_id = vis.record_id
join employee as emp on emp.assigned_employee_id = vis.assigned_employee_id
where audit.true_water_source_score != quali.subjective_quality_score
)
select
distinct employee_name
from incorrect_records;

-- but a CTE can not easily be called or used easily
-- so we create a view
create view Inconsistent_records as
select
	audit.location_id as auditor_location,
	quali.record_id,
    emp.assigned_employee_id,
    emp.employee_name,
	audit.true_water_source_score as auditor_score,
	quali.subjective_quality_score as employee_score,
    audit.statements
from auditor_report as audit
join visits as vis on audit.location_id = vis.location_id
join water_quality as quali on quali.record_id = vis.record_id
join employee as emp on emp.assigned_employee_id = vis.assigned_employee_id
where audit.true_water_source_score != quali.subjective_quality_score
and vis.visit_count = 1;

-- to count number of mistakes made by an employee
create view counting_errors as
select
employee_name,
count(employee_name) as number_of_mistakes
from inconsistent_records
group by employee_name;

-- corrupt employees would make more mistakes than the average
with suspect_list as(
select 
	emp1.employee_name, 
    emp1.number_of_mistakes
from counting_errors as emp1
where emp1.number_of_mistakes > (select avg(emp2.number_of_mistakes)
								from counting_errors as emp2)
),
classified as(
select
*
from inconsistent_records
)
select*
from classified
where employee_name in (select employee_name from suspect_list)
and statements like '%cash%'
;

-- we can save a view for our suspects
create view suspect_list as
select 
	emp1.employee_name, 
    emp1.number_of_mistakes
from counting_errors as emp1
where emp1.number_of_mistakes > (select avg(emp2.number_of_mistakes)
								from counting_errors as emp2);

select*
from inconsistent_records
where employee_name in (select employee_name from suspect_list)
and statements like '%cash%';

select*
from inconsistent_records
where statements like '%cash%'
and employee_name not in (select employee_name from suspect_list);