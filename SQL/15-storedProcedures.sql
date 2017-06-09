USE ap;



-- CREATE PROCEDURE procedure_name
-- (
--    [parameter_name1 data type]
--    [parameter_name2 data type]...
-- )
-- SQL_block

-- Example1
-- update the credit_total of a given invoice in the table invoices

-- UPDATE invoices
--  SET credit_total = input value 1
--  WHERE invoice_id = input value 2

DROP PROCEDURE IF EXISTS update_invoices_credit_total;

DELIMITER //

CREATE PROCEDURE update_invoices_credit_total
(
  invoice_id_param      INT,
  credit_total_param    DECIMAL(9,2) 
)
BEGIN
  DECLARE sql_error INT DEFAULT FALSE;
  
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    SET sql_error = TRUE;

  START TRANSACTION;  

  UPDATE invoices
  SET credit_total = credit_total_param
  WHERE invoice_id = invoice_id_param;

  IF sql_error = FALSE THEN
    COMMIT;
  ELSE
    ROLLBACK;
  END IF;
END//

DELIMITER ;

-- Use the CALL statement
CALL update_invoices_credit_total(56, 200);

SELECT invoice_id, credit_total 
FROM invoices WHERE invoice_id = 56;

-- Use the CALL statement within a stored procedure
-- Create the procedure first, then call it
DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN
  CALL update_invoices_credit_total(56, 300);
END//

DELIMITER ;

CALL test();

SELECT invoice_id, credit_total 
FROM invoices WHERE invoice_id = 56;

-- Reset data to original value
CALL update_invoices_credit_total(56, 0);

SELECT invoice_id, credit_total 
FROM invoices WHERE invoice_id = 56;

-- Syntax to declare input/output parameters
--  [IN|OUT|INOUT] parameter_name data_type

-- Example2
-- update the credit_total of a given invoice in the table invoices(same as example1)
-- return the count of updates made

USE ap;

DROP PROCEDURE IF EXISTS update_invoices_credit_total;

DELIMITER //

CREATE PROCEDURE update_invoices_credit_total
(
  IN invoice_id_param    INT,
  IN credit_total_param  DECIMAL(9,2), 
  OUT update_count       INT
)
BEGIN
  DECLARE sql_error INT DEFAULT FALSE;
  
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    SET sql_error = TRUE;

  START TRANSACTION;
  
  UPDATE invoices
  SET credit_total = credit_total_param
  WHERE invoice_id = invoice_id_param;
  
  IF sql_error = FALSE THEN
    SET update_count = 1;
    COMMIT;
  ELSE
    SET update_count = 0;
    ROLLBACK;
  END IF;
END//

DELIMITER ;

CALL update_invoices_credit_total(56, 200, @row_count);

SELECT CONCAT('row_count: ', @row_count) AS update_count;

-- Reset the data to original value
CALL update_invoices_credit_total(56, 0, @row_count);


-- Example 3
-- update the credit_total of a given invoice in the table invoices
-- Set default value for NULL values
USE ap;

DROP PROCEDURE IF EXISTS update_invoices_credit_total;

DELIMITER //

CREATE PROCEDURE update_invoices_credit_total
(
  invoice_id_param     INT,
  credit_total_param   DECIMAL(9,2)
)
BEGIN
  DECLARE sql_error INT DEFAULT FALSE;
  
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    SET sql_error = TRUE;
    
  -- Set default values for NULL values
  IF credit_total_param IS NULL THEN
    SET credit_total_param = 100;
  END IF;

  START TRANSACTION;
  
  UPDATE invoices
  SET credit_total = credit_total_param
  WHERE invoice_id = invoice_id_param;
  
  IF sql_error = FALSE THEN
    COMMIT;
  ELSE
    ROLLBACK;
  END IF;
END//

DELIMITER ;

-- call with param
CALL update_invoices_credit_total(56, 200);

SELECT invoice_id, credit_total 
FROM invoices WHERE invoice_id = 56;

-- call without param
CALL update_invoices_credit_total(56, NULL);

SELECT invoice_id, credit_total 
FROM invoices WHERE invoice_id = 56;

-- reset data
CALL update_invoices_credit_total(56, 0);

SELECT invoice_id, credit_total 
FROM invoices WHERE invoice_id = 56;