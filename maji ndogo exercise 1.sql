use md_water_services;

-- Question 1 --
-- Identify potentially suspicious field worker whose phone number contains 86 or 11 and their last name starts with either A or M
select*
from employee
where position = 'Field Surveyor'
and (employee_name like '%_ A__%'
or employee_name like '%_ M__%'
)
and (
phone_number like '%86' or phone_number like '%11%'
);


-- Question 2
-- What is the population of maji ndogo
SELECT sum(number_of_people_served)
FROM md_water_services.water_source;


-- Question 3
-- How many provinces does maji ndogo have
select distinct province_name
from location;

-- Question 4--
-- Identify fiekd surveyors from Kilimani province
select*
from employee
where position = 'Field Surveyor'
and province_name = 'Kilimani';

-- Question 5
-- Which employees are civil engineers residing in Dahabu or living on an avenue
select*
from employee
where position = 'Civil Engineer'
and (
	province_name = 'Dahabu'
    or address like '%Avenue%'
);

-- Question 6
-- Among the sources that recorded a queue time of 538 minutes and above, how many are from rural and urban
select A.location_id, A.time_in_queue, B.town_name, B.location_type
from visits as A
join location as B
	on A.location_id = B.location_id
where time_in_queue >= 538;

-- Question 7
-- Are there sources that were not visited
select*
from visits
where visit_count < 1
or null;

-- Question 8
-- Which source ID refers to water source shared by the most people
select max(number_of_people_served)
from water_source;

select*
from water_source
where number_of_people_served > 3990;


-- Question 9
-- The wells at maji ndogo are at risk of being contaminated by which two viruses
select*
from well_pollution
where description like '%virus%'
;