-- Example of a INNER JOIN
-- INNER key word is optional as INNER JOIN is the default customers
USE  ap;

-- List vendors with at least one invoice
select * from invoices order by vendor_id;
select * from vendors;

SELECT Distinct vendors.vendor_id, vendor_name
	FROM vendors INNER JOIN invoices
		ON vendors.vendor_id = invoices.vendor_id
		ORDER BY invoice_number;

SELECT invoice_number, vendor_name
	FROM vendors INNER JOIN invoices
		ON vendors.vendor_id = invoices.vendor_id
		ORDER BY invoice_number;

-- Example of an INNER JOIN
-- where  we are aliasing the table names
-- the WHERE clause can be used to further restrict the records in the result set

USE ap;

-- List the invoice_number and vendor_name of all invoices
-- with a balance >0
-- sort the result by invoice_due_date 
SELECT invoice_number, vendor_name, invoice_due_date,
    invoice_total - payment_total - credit_total AS balance_due
	FROM vendors v JOIN invoices i
		ON v.vendor_id = i.vendor_id
		WHERE invoice_total - payment_total - credit_total > 0
			ORDER BY invoice_due_date DESC;

-- another example of a JOIN across a foreign key
-- LIst invoice_number, line_item_amount, line_item_description
-- for the account_number 540 
SELECT invoice_number, line_item_amount, line_item_description
	FROM invoices JOIN invoice_line_items line_items
		ON invoices.invoice_id = line_items.invoice_id
		WHERE account_number = 540
			ORDER BY invoice_date;

-- INNER JOIN example where the
-- JOIN fields are not defined as related
-- also demonstrates JOIN across 2 fields 
USE ex;
-- List emplyees who are also customers 

SELECT customer_first_name, customer_last_name
	FROM customers c JOIN employees e 
		ON c.customer_first_name = e.first_name 
		   AND c.customer_last_name = e.last_name;
   
-- example of a SELF JOIN

-- List vendors where there is another vendor also within the same city and state
-- must use table aliases to distinguish the two copies of the same table 
-- each field needs to be prefixed with the table name for disambiguation
use ap;
SELECT v1.vendor_name firstvendor, v1.vendor_city, 
    v1.vendor_state,
    v2.vendor_name secondvendor, v2.vendor_city, 
    v2.vendor_state
	FROM vendors v1 JOIN vendors v2
        ON v1.vendor_city = v2.vendor_city AND
         v1.vendor_state = v2.vendor_state AND
         v1.vendor_name <> v2.vendor_name -- excludes same vendor matching itself 
		ORDER BY v1.vendor_state, v1.vendor_city;

-- use DISTINCT so a vendor only appears once in the result set 
SELECT DISTINCT v1.vendor_name firstvendor, v1.vendor_city, 
    v1.vendor_state,
    v2.vendor_name secondvendor, v2.vendor_city, -- use DISTINCT so a vendor only appears once in the result set 
    v2.vendor_state
FROM vendors v1 JOIN vendors v2
    ON v1.vendor_city = v2.vendor_city AND
       v1.vendor_state = v2.vendor_state AND
       v1.vendor_name <> v2.vendor_name -- excludes same vendor matching itself 
ORDER BY v1.vendor_state, v1.vendor_city;


-- implicit JOIN
-- not the standard method for writing a JOIN
-- will be found in legacy code 
USE ap;

SELECT invoice_number, vendor_name
	FROM vendors v, invoices i
		WHERE v.vendor_id = i.vendor_id
			ORDER BY invoice_number;

-- implicit JOIN with 4 tables 
SELECT vendor_name, invoice_number, invoice_date,
    line_item_amount, account_description
FROM  vendors v, invoices i, invoice_line_items li, 
    general_ledger_accounts gl
WHERE v.vendor_id = i.vendor_id
  AND i.invoice_id = li.invoice_id
  AND li.account_number = gl.account_number
  AND invoice_total - payment_total - credit_total > 0
ORDER BY vendor_name, line_item_amount DESC;

-- STUDENTS -> rewrite both JOINs to be explicit 

-- Outer Joins allow you to specify that all of the records from one of the tables
-- should be part of the result set
-- will also pull all records in the other table that satisfies the JOIN condition
-- NULL values are returned for the fields without a matching value
-- the OUTER keyword is optional 

-- this query returns at least one  record for each vendor
-- and appends the invoice fields to the corresponding vendor record

-- What if we wanted to track vendors without activiy (with no invoices)
SELECT vendor_name, invoice_number, invoice_total
FROM vendors LEFT JOIN invoices
    ON vendors.vendor_id = invoices.vendor_id
		ORDER BY vendor_name;

SELECT vendor_name, invoice_number, invoice_total
FROM vendors  JOIN invoices
    ON vendors.vendor_id = invoices.vendor_id
ORDER BY vendor_name;


-- you can mix both INNER and OUTER JOINs projects
-- compare to an inner join on both department/ employees

-- List employees assigned to a department 
-- whether they are part of a project or not
use ex;
SELECT department_name, last_name, project_number
FROM departments d
    JOIN employees e
        ON d.department_number = e.department_number
    LEFT JOIN projects p
        ON e.employee_id = p.employee_id
          ORDER BY department_name, last_name;
          
-- Now only list those who are part of a project
SELECT department_name, last_name, project_number
FROM departments d
    JOIN employees e
        ON d.department_number = e.department_number
	JOIN projects p
        ON e.employee_id = p.employee_id
ORDER BY department_name, last_name;

-- example of an equi-join: using the same named field from both tables
-- simplify the code with the USING clause
-- tables must be joined by a column that has the same name in both tables
-- equality is the operator for the USING clause
-- List the invoice_number and the corresponding vendor_name
use ap;
SELECT invoice_number, vendor_name
	FROM vendors 
		JOIN invoices USING (vendor_id)
			ORDER BY invoice_number;

-- INNER JOIN of employees assigned to departments
-- find the projects for the employees assigned to departments
-- multiple fields for the join? USING  (field1, field2)

-- List employees assigned to a department 
-- whether they are part of a project or not
-- Now using Equijoin on the same named field from both tables 
use ex;
SELECT department_name, last_name, project_number
FROM departments
    JOIN employees USING (department_number)
    LEFT JOIN projects USING (employee_id)
ORDER BY department_name;

USE ap;

-- Example of a NATURAL JOIN
-- JOIN is done across all fields that are common across the two tables
-- Natural JOIN  is not the safest method for writing a JOIN 

-- LIst the invoice_number and the corresponding vendor_name
SELECT invoice_number, vendor_name
FROM vendors 
    NATURAL JOIN invoices
ORDER BY invoice_number;
 
USE ex;
-- List employees assigned to a department 
-- whether they are part of a project or not
-- NATURAL JOIN across the departments and employees
-- what are the common fields ?
SELECT department_name AS dept_name, last_name, project_number
FROM departments
    NATURAL JOIN employees -- what fields compose the JOIN condition??
    LEFT JOIN projects USING (employee_id)
ORDER BY department_name;

-- CROSS JOIN EXAMPLE
-- CROSS JOIN produces a result set that includes each row from the first 
-- table joined with each row from the second table
-- it is a cartesian product of the two tables
-- there is no qualifying clause for the result set
-- how many records in the result set?? number of tuples in table 1 * number of tuples in table 2
Select * from departments;
Select * from employees;

SELECT departments.department_number, department_name, employee_id, 
    last_name
FROM departments CROSS JOIN employees
ORDER BY departments.department_number;

-- Implicit representation for the CROSS JOIN
SELECT departments.department_number, department_name, employee_id, 
    last_name
FROM departments, employees
ORDER BY departments.department_number;

-- ON left out
SELECT departments.department_number, department_name, employee_id, 
    last_name
FROM departments JOIN employees
ORDER BY departments.department_number;

-- Same definition as SET UNION
-- create a result set that contains elements from both sets
-- remove duplicates acress the sets

-- in order for the sets to be UNION compatible 
-- 1) the number of columns need to be the same in both sets
-- 2) and the corresponding data types must be  compatible
--  if there are differences in the colun names the first table
-- determines the field names in the result set 
SELECT 'Active' AS source, invoice_number, invoice_date, invoice_total
    FROM active_invoices
    WHERE invoice_date >= '2014-06-01'
UNION
    SELECT 'Paid' AS source, invoice_number, invoice_date, invoice_total
    FROM paid_invoices
    WHERE invoice_date >= '2014-06-01'
ORDER BY invoice_total DESC;

-- UNION  ALL does not remove duplicates from the result set 
SELECT 'Active' AS source, invoice_number, invoice_date, invoice_total
    FROM active_invoices
    WHERE invoice_date >= '2014-06-01'
UNION ALL 
    SELECT 'Paid' AS source, invoice_number, invoice_date, invoice_total
    FROM paid_invoices
    WHERE invoice_date >= '2014-06-01'
ORDER BY invoice_total DESC;

use ex; 
-- will remove duplicate customer who is an employee 
SELECT first_name, last_name from employees 
UNION
SELECT customer_first_name as first_name, customer_last_name from customers ORDER by last_name;

-- will not remove duplicate customer who is an employee 
SELECT first_name, last_name from employees 
UNION ALL 
SELECT customer_first_name as first_name, customer_last_name from customers ORDER by last_name;
   