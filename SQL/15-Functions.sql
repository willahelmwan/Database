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
-- Function that calculates balance due

SELECT invoice_id,invoice_total - payment_total - credit_total
 FROM invoices
  where vendor_id = 37;
 
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