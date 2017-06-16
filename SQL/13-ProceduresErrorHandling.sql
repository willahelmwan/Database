USE ap;

/*    Commonly used error codes   */
--  Error Code         |   Desciption
----------------------------------------
--  1329          | Attempt to fetch data from a row that doesn't exist
--  1062   --     | Attempt to store duplicate values for a column that has UNIQUE constraint
--  1048          | Attempt to insert NULL into a column that doesn't accept NULL
--  1216          | Attempt to update/add a child row but can't because of FOREIGN KEY constraint
--  1217		  | Attempt to update/delete a parent row but can't because of FOREIGN KEY constraint



select * from general_ledger_accounts
	order by account_number;

    
Describe general_ledger_accounts;

-- account_description has the UNIQUE constraint

-- attempt to insert a duplicate value for account_description
INSERT INTO general_ledger_accounts VALUES (134, 'Cash');


DROP PROCEDURE IF EXISTS test;

-- Print out a message if the error with code 1062 is encountered

DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE duplicate_entry_for_key INT DEFAULT FALSE;

  DECLARE CONTINUE HANDLER FOR 1062
    SET duplicate_entry_for_key = TRUE;

  INSERT INTO general_ledger_accounts VALUES (134, 'Cash');
  
  IF duplicate_entry_for_key = TRUE THEN
    SELECT 'Row was not inserted - duplicate key encountered.' AS message;
  ELSE
    SELECT '1 row was inserted.' AS message;    
  END IF;

END//

DELIMITER ;

CALL test();

DROP PROCEDURE IF EXISTS test;
-- EXIT vs. CONTINUE
-- use EXIT if you want to exit the block of code is the error is encountered

-- Exit if error with code 1062 is encountered
DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE duplicate_entry_for_key INT DEFAULT FALSE;
  BEGIN
    DECLARE EXIT HANDLER FOR 1062
      SET duplicate_entry_for_key = TRUE;

    INSERT INTO general_ledger_accounts VALUES (130, 'Cash');
    
    SELECT '1 row was inserted.' AS message;    
  END;
  
  IF duplicate_entry_for_key = TRUE THEN
    SELECT 'Row was not inserted - duplicate key encountered.' AS message;
  END IF;
END//

DELIMITER ;

CALL test();


USE ap;
-- EXIT if any exception is encountered
-- use the named condition SQLEXCEPTION 
DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE sql_error INT DEFAULT FALSE;
  BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
      SET sql_error = TRUE;

    INSERT INTO general_ledger_accounts VALUES (130, 'Cash');
    
    SELECT '1 row was inserted.' AS message;    
  END;
  
  IF sql_error = TRUE THEN
    SELECT 'Row was not inserted - SQL exception encountered.' AS message;	
  END IF;
END//

DELIMITER ;

CALL test();



-- Stored procedure with multiple conditions

-- The more specific error handlers are executed first and 
-- the least specific error handlers are executed last

-- MySQl error codes and NOT FOUND condition identify specific errors
-- SQLEXCEPTION and SQLWARNING identify general errors

USE ap;

DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE duplicate_entry_for_key INT DEFAULT FALSE;
  DECLARE column_cannot_be_null   INT DEFAULT FALSE;
  DECLARE sql_exception           INT DEFAULT FALSE;
  
  BEGIN
    DECLARE EXIT HANDLER FOR 1062
      SET duplicate_entry_for_key = TRUE;
    DECLARE EXIT HANDLER FOR 1048
      SET column_cannot_be_null = TRUE;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
      SET sql_exception = TRUE;

    INSERT INTO general_ledger_accounts VALUES (NULL, 'Test');
    
    SELECT '1 row was inserted.' AS message;    
  END;
  
  IF duplicate_entry_for_key = TRUE THEN
    SELECT 'Row was not inserted - duplicate key encountered.' AS message;
  ELSEIF column_cannot_be_null = TRUE THEN
    SELECT 'Row was not inserted - column cannot be null.' AS message;
  ELSEIF sql_exception = TRUE THEN
    SELECT 'Row was not inserted - SQL exception encountered.' AS message;	
  END IF;
END//

DELIMITER ;

CALL test();

-- In class exercise

-- Write a script that creates and calls a stored procedure named test. 
-- This procedure should attempt to update the invoice _due_date column
-- so it's equal to NULL for the invoice with an invoice_id of 1
-- If the update is successful, the procedure should display this message:
-- 1 row was updated
-- If the update is unsuccessful, the procedure should display this message:
-- Row wasn't update - column cannot be NULL
USE ap;

select * from invoices
 WHERE invoice_id = 1;

describe invoices;

UPDATE invoices
  SET invoice_due_date = NULL
  WHERE invoice_id = 1;


DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE column_cannot_be_null TINYINT DEFAULT FALSE;

  DECLARE CONTINUE HANDLER FOR 1048
    SET column_cannot_be_null = TRUE;

  UPDATE invoices
  SET invoice_due_date = NULL
  WHERE invoice_number = '989319-457';
  
  IF column_cannot_be_null = TRUE THEN
    SELECT 'Row was not updated - column cannot be null.' AS message;
  ELSE
    SELECT '1 row was updated.' AS message;    
  END IF;

END//

DELIMITER ;

CALL test();
