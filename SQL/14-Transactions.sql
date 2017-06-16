/*********************   TRANSACTIONS  ********************/
-- A transaction is a group of SQL statements combined into a single logical unit. 
-- Transactins are used when you:
-- 1) code >= 2 insert/update/delete statements tha affect related data
-- 2) move rows from one table to another by using insert/delete
-- 3) whevever the failure of insert/update/delete would violate data integrity  

select * from invoices;
-- Write the 3 insert statement as a transaction
  INSERT INTO invoices
  VALUES (115, 34, 'ZXA-080', '2014-06-30', 
          14092.59, 0, 0, 3, '2014-09-30', NULL);

  INSERT INTO invoice_line_items 
  VALUES (115, 1, 160, 4447.23, 'HW upgrade');
  
  INSERT INTO invoice_line_items 
  VALUES (115, 2, 167, 9645.36, 'OS upgrade');
  

USE ap;

DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE sql_error INT DEFAULT FALSE;
  
  -- executed if an error occurs
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    SET sql_error = TRUE;

  START TRANSACTION;   -- beginning of the transaction
					   -- autocommit mode is turned off	
  
  INSERT INTO invoices
  VALUES (115, 34, 'ZXA-080', '2014-06-30', 
          14092.59, 0, 0, 3, '2014-09-30', NULL);

  INSERT INTO invoice_line_items 
  VALUES (116, 1, 160, 4447.23, 'HW upgrade');
  
  INSERT INTO invoice_line_items 
  VALUES (115, 2, 167, 9645.36, 'OS upgrade');
  
  /*IF sql_error = FALSE THEN
    COMMIT;
    SELECT 'The transaction was committed.';
  ELSE
	ROLLBACK;
    SELECT 'The transaction was rolled back.';
  END IF;*/
END//

DELIMITER ;

SELECT invoice_id, invoice_number
FROM invoices WHERE invoice_id = 115;

CALL test();

-- Check data
SELECT invoice_id, invoice_number
FROM invoices WHERE invoice_id = 115;

SELECT invoice_id, invoice_sequence, line_item_description
FROM invoice_line_items WHERE invoice_id = 115;

SELECT invoice_id, invoice_sequence, line_item_description
FROM invoice_line_items WHERE invoice_id = 115;

-- Clean up
DELETE FROM invoice_line_items WHERE invoice_id = 115;
DELETE FROM invoices WHERE invoice_id = 115;

-- In class exercise
-- Write a script that creates and calls a stored procedure named test. 
-- This procedure should include a set of three SQL statements coded as a transaction
-- to reflect the following changes: Inited Parcel Service has been purchached by 
-- Federal Express Corporaction and the new company is names FedUP. Rename one of 
-- the vendor and delete the other after updating the vendor_id column in the Invoices 
-- table.
-- If these statements execute successfully, commit the changes. Otherwise, rollback the changes.

select * from vendors where vendor_id=123; -- Federal Express Corporation / new name: FedUP
select * from vendors where vendor_id=122; -- United Parcel Services
select * from invoices where vendor_id=123;
USE ap;

DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE sql_error INT DEFAULT FALSE;
  
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    SET sql_error = TRUE;

  START TRANSACTION;
  
  UPDATE invoices
  SET vendor_id = 123
  WHERE vendor_id = 122;

  DELETE FROM vendors
  WHERE vendor_id = 122;

  UPDATE vendors
  SET vendor_name = 'FedUP'
  WHERE vendor_id = 123;

  IF sql_error = FALSE THEN
    COMMIT;
    SELECT 'The transaction was committed.';
  ELSE
    ROLLBACK;
    SELECT 'The transaction was rolled back.';
  END IF;
END//

DELIMITER ;

CALL test();