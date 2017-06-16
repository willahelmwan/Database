/*****************   FUNCTIONS *********************/

-- CREATE FUNCTION function_name
-- (
-- [parameter_name1 data_type]
-- [parameter_name2 data_type] ..
-- )
-- RETURNS data_tpe
-- SQL_block


-- Example1
-- Create a function that return the vendor_id given the vendor_name

USE ap;

select * from vendors;
SELECT vendor_id
  INTO @vendor_id_var
  FROM vendors
  WHERE vendor_name = 'ibm';
  
Select  @vendor_id_var AS Vendor_id;

-- Input parameter: vendor_name 
-- Returned value: vendor_id 

-- Let's check out the data types to be used
describe vendors;

-- vendor_name VARCHAR(50)
-- vendor_id (INT)

DROP FUNCTION IF EXISTS get_vendor_id;

DELIMITER //

CREATE FUNCTION get_vendor_id
(
   vendor_name_param VARCHAR(50)
)
RETURNS INT
BEGIN
  DECLARE vendor_id_var INT;
  
  SELECT vendor_id
  INTO vendor_id_var
  FROM vendors
  WHERE vendor_name = vendor_name_param;
  
  RETURN(vendor_id_var);
END//

DELIMITER ;


SELECT invoice_number, invoice_total
FROM invoices
WHERE vendor_id = get_vendor_id('IBM');

-- Check solution 
SELECT v.vendor_id,vendor_name, invoice_number, invoice_total
FROM invoices i JOIN vendors v
ON i.vendor_id= v.vendor_id
where vendor_name = 'ibm';

-- Example2
-- Function that calculates balance due for a given invoice


SELECT invoice_id,invoice_total - payment_total - credit_total
 FROM invoices
  where vendor_id = 37;

describe invoices;
-- Input parameter: invoice_id INT
-- Returned value: balance due DECIMAL(9,2)   
 
USE ap;

DROP FUNCTION IF EXISTS get_balance_due;

DELIMITER //

CREATE FUNCTION get_balance_due
(
   invoice_id_param INT
)
RETURNS DECIMAL(9,2)
BEGIN
  DECLARE balance_due_var DECIMAL(9,2);
  
  SELECT invoice_total - payment_total - credit_total
  INTO balance_due_var
  FROM invoices
  WHERE invoice_id = invoice_id_param;
  
  RETURN balance_due_var;
END//

DELIMITER ;

SELECT vendor_id, invoice_number, 
       get_balance_due(invoice_id) AS balance_due 
FROM invoices
WHERE vendor_id = 37;

-- In class exercise
-- What if we wanted the sum of balance_due for a given vendor 

-- Balance due for all invoices of the vendor with id 37
SELECT invoice_id,invoice_total - payment_total - credit_total
 FROM invoices
  where vendor_id = 37;

-- SUM(Balance_due) for all invoices of the vendor with id 37
 SELECT SUM(get_balance_due(invoice_id))
  INTO @sum_balance_due_var 
  FROM invoices
  WHERE vendor_id = 37;
  
  Select @sum_balance_due_var;
  
USE ap;

DROP FUNCTION IF EXISTS get_sum_balance_due;

DELIMITER //

CREATE FUNCTION get_sum_balance_due
(
   vendor_id_param INT
)
RETURNS DECIMAL(9,2)
BEGIN
  DECLARE sum_balance_due_var DECIMAL(9,2);
  
  SELECT SUM(get_balance_due(invoice_id))
  INTO sum_balance_due_var 
  FROM invoices
  WHERE vendor_id = vendor_id_param;
  
  RETURN sum_balance_due_var;
END//

DELIMITER ;

SELECT vendor_id, invoice_number, 
       get_balance_due(invoice_id) AS balance_due, 
       get_sum_balance_due(vendor_id) AS sum_balance_due
FROM invoices
WHERE vendor_id = 37;

DROP FUNCTION get_sum_balance_due;