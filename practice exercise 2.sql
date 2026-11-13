use northwind;

-- Task 1: Customer Region Categorization
-- The marketing team wants to categorize customers into three regions: 'Domestic' for customers in the USA, 
-- 'Americas' for customers in Canada and Mexico, and 'International' for all other countries.
select
CustomerID, CompanyName, Country,
case
	when country = 'USA' then 'Domestic'
    when country in ('Canada', 'Mexico') then 'Americas'
    else 'International'
end as region
from customers;

-- Task 2: Fax Customer Identification
-- The sales team wants to identify which customers have a fax machine so that they can send them a special promotion. 
-- A customer is considered to have a fax machine if their Fax number is not NULL. Otherwise, they are a 'Standard' customer.
select
CustomerID, CompanyName, Fax,
if(isnull(Fax), "Standard", "Fax")
from customers;

-- Task 3: Order Urgency Flag
-- Operations needs to quickly see which orders are urgent. An order is 'Urgent' if the ShippedDate is greater than the RequiredDate. 
-- Otherwise, it is 'On-Time'.
select
CustomerID, ShippedDate,
case
	when ShippedDate > RequiredDate then 'Urgent'
    else 'On-Time'
end as urgency_flag
from orders;

-- Task 4: Customer Count by Region
-- The marketing team wants a summary of customer counts for each region you defined in Task 1.
select
case
	when country = 'USA' then 'Domestic'
    when country in ('Canada', 'Mexico') then 'Americas'
    else 'International'
end as region, count(CustomerID) as counting
from customers
group by case
	when country = 'USA' then 'Domestic'
    when country in ('Canada', 'Mexico') then 'Americas'
    else 'International'
end;

-- Task 5: Orders Shipped with Express Freight
-- The logistics manager wants to know how many orders were shipped using express freight. An order is considered 'Express' 
-- if its Freight cost is greater than $100.
select
count(CustomerID) as total,
case
	when Freight > 100 then 'Express'
    else 'Not Express'
end as status_order
from orders
group by case
	when Freight > 100 then 'Express'
    else 'Not Express'
end;

-- Task 6: High-Value Order Count by Year
-- The finance department wants to see how many orders had freight charges over $500 each year. 
-- Write a query that uses a CASE expression inside a SUM to count orders where Freight > 500, grouped by the order year.
select
year(RequiredDate) as years,
sum(
	case
		when Freight > 500 then 1
        else 0
    end
) as total
from orders
group by years;

-- Task 7: Order Price Category
-- The pricing team wants to classify entire orders based on the total number of items purchased. 
-- To do this, you should calculate the total quantity for each order by summing all Quantity values across its line items 
-- in the OrderDetails table, then assign a category according to the business rules. Orders with more than 50 total items should be 
-- labelled as 'Bulk', those with between 10 and 50 items as 'Standard', and those with fewer than 10 items as 'Small'.
select
OrderID,
sum(Quantity) as TotalQuantity,
case
	when sum(Quantity) > 50 then 'Bulk'
    when sum(Quantity) between 10 and 50 then 'Standard'
    else 'Small'
end as categorization
from orderdetails
group by OrderID;

-- Task 8: Tiered Product Discount
-- For a special promotion, the sales manager wants to apply a tiered discount to each product line item based on the quantity purchased. 
-- If the Quantity is greater than 50, a 20% discount is applied. Otherwise, if the Quantity is greater than 20, a 10% discount is applied. 
-- If it's 20 or less, no discount is applied.
select
OrderID, Quantity,
case
	when Quantity > 50 then 0.20
    when Quantity > 20 then 0.10
end as discounted_price
from orderdetails;

-- Task 9: Dynamic Shipping Flag
-- The operations team needs a flag to indicate if an order has a required shipping date on a weekend (Saturday or Sunday).
select
OrderID, ShippedDate,
dayname(ShippedDate) as day_of_the_week,
case
	when dayname(ShippedDate) in ('Saturday', 'Sunday') then 'Weekend'
end as flag
from orders;

-- Task 10: Conditional Employee Salary Bonus
-- HR is considering a bonus. All sales representatives ('Sales Representative') will receive a 5% bonus on their Salary. 
-- All other employees will receive a 2% bonus.
select
EmployeeID, Title,
case
	when Title = 'Sales Representative' then round(Salary * 0.05, 2)
    else round(Salary * 0.02, 2)
end as bonuses
from employees;
