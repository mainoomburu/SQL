-- Question 1
-- a report of all customers, showing their CustomerId and their Email address after removing any leading or trailing whitespace.
select CustomerId,
trim(Email)
from customer;

-- Question 2
-- For a personalized email campaign, the marketing team wants a single column for the full name of each customer
select
upper(concat(LastName, ' ', FirstName)) as full_name
from customer;

-- Question 3
-- The HR department wants a clean report of all employees. They need a single column that combines the FirstName, LastName, Title, and Phone number.
-- formatted as "Firstname Lastname, Title: Phone"
select
concat(FirstName, ' ', LastName, ', ', Title, ': ', Phone) as employee_contact
from employee;

-- Question 4
-- The CityCode should be the first three characters of the City column, in lowercase.
select CustomerId, FirstName, LastName, City,
substring(lower(City), 1,3) as CityCode
from customer;

-- or

select CustomerId, FirstName, LastName, City,
lower(substring (City, 1,3)) as CityCode
from customer;

-- Question 5
-- The accounting department needs a report of all invoices. They want the Date formatted as a string in the YYYY-MM-DD format.
select InvoiceId, CustomerId,
date_format(InvoiceDate, '%Y-%m-%d') as invoice_date
from invoice;

-- or 

select InvoiceId, CustomerId,
str_to_date(InvoiceDate, '%Y-%m-%d') as invoice_date_2
from invoice;

-- Question 6
-- Create a report with CustomerId and a new column called CustomerID_Hash
-- customerid hash = hash first 2 letters First name and first 2 letters of last name both in lower case
select CustomerId,
concat(
substring(lower(FirstName), 1,2),
substring(lower(LastName), 1,2)
) as customerID_hash
from customer;

-- or

select CustomerId,
concat(
lower(substring(FirstName, 1,2)),
lower(substring(LastName, 1,2))
) as customerID_hash
from customer;

-- Question 7
-- Convert customer id to varchar
select 
cast(InvoiceId AS CHAR) as InvoiceId_char, CustomerId,
Total
from invoice;

-- Question 8
-- The IT team wants to audit the email domains used by customers.
-- email domain is the portion that comes after the @ symbol
select FirstName, LastName, Email,
substring(Email, locate('@', Email) + 1) as email_domain
from customer;

-- Question 9
-- CustomerId, FirstName, and a new column called NameLength that shows the number of characters in their first name.
select CustomerId, FirstName, 
length(FirstName) as NameLength
from customer;

-- Question 10
--  Create a report showing EmployeeId, LastName, and a new column Title_Lowercase with the title in all lowercase.
select EmployeeId, LastName,
lower(Title) as Title_Lowercase
from employee;
