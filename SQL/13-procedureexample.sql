/*****************************Procedures vs. Functions****************************/
-- Procedures can be called from an application that has access to the database
-- Functions can be called from a SQL statement (work likke functions provided by MySQL)

-- Simple example of a function that prints a message
-- USE Select to retrieve content 
 DROP PROCEDURE IF EXISTS test;

 Use ap;
 DELIMITER $$
 
 CREATE PROCEDURE test()
 BEGIN 
 SELECT "This is a test" as msg; 
 END$$
 
 -- SET THE DELIMITER BACK TO ITS DEFAULT 
 DELIMITER ;
 CALL test();


-- SQL control flow statements 
-- - IF ... ELSEIF .... ELSE....alter
-- -- CASE ....WHEN EXPRESSION THEN ... WHEN EXPRESSION2 THEN ... ELSE END 
-- - WHILE ...DO...LOOP
-- - REPEAT ... UNTIL ... END ... REPEAT
-- -- DECLARE CURSOR FOR
-- -- DECLARE ... HANDLER 

DROP PROCEDURE IF EXISTS counter;

 
DELIMITER $$ 
CREATE PROCEDURE counter() 
BEGIN 
	DECLARE x INT; -- example of DECLARE
	SET x = 1; -- EXAMPLE OF SET
	
    WHILE x <= 5 DO -- WHILE LOOP 
		SET x = x + 1;
	END WHILE; -- CLOSE OF WHILE LOOP 
	
    -- REPEAT loop
  /*
  REPEAT
    SET x = x + 1;
  UNTIL x = 6
  END REPEAT;
  */
  
  -- LOOP with LEAVE statement
  /*
  testLoop : LOOP
    SET x = x + 1;

    IF x = 6 THEN
       LEAVE testLoop;
    END IF;        
  END LOOP testLoop;
  */
    
    
    SELECT x; -- 6 -- THIS WILL PRINT THE VALUE OF THE VARIABLE 
END$$ 

DELIMITER ;
-- Example on how to call a procedure 
call counter();


USE ap;

DROP PROCEDURE IF EXISTS test;
SELECT SUM(invoice_total - payment_total - credit_total)
  FROM invoices 
  WHERE vendor_id = 37; -- Has a balance due

SELECT SUM(invoice_total - payment_total - credit_total)
  FROM invoices 
  WHERE vendor_id = 95;-- Doesn't have a balance due
  
-- Change statement delimiter from semicolon to double front slash
DELIMITER //
CREATE PROCEDURE test()
BEGIN
  DECLARE sum_balance_due_var DECIMAL(9, 2);

  SELECT SUM(invoice_total - payment_total - credit_total)
  INTO sum_balance_due_var
  FROM invoices 
  WHERE vendor_id = 95;
  -- for testing, the vendor with an ID of 37 has a balance due

  IF sum_balance_due_var > 0 THEN
    SELECT CONCAT('Balance due: $', sum_balance_due_var) AS message;
  ELSE
    SELECT 'Balance paid in full' AS message;
  END IF;  
END//

-- Change statement delimiter from semicolon to double front slash
DELIMITER ;
CALL test();


-- Student work -- 
-- Change the procedure such that you the max(invoice), min(invoice), and %difference
-- for vendor with id 95
DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE max_invoice_total  DECIMAL(9,2);
  DECLARE min_invoice_total  DECIMAL(9,2);
  DECLARE percent_difference DECIMAL(9,4);
  DECLARE count_invoice_id   INT;
  DECLARE vendor_id_var      INT;
  
  SET vendor_id_var = 95;

  SELECT MAX(invoice_total), MIN(invoice_total), COUNT(invoice_id)
  INTO max_invoice_total, min_invoice_total, count_invoice_id
  FROM invoices WHERE vendor_id = vendor_id_var;

  SET percent_difference = (max_invoice_total - min_invoice_total) / 
                         min_invoice_total * 100;
  
  SELECT CONCAT('$', max_invoice_total) AS 'Maximum invoice', 
         CONCAT('$', min_invoice_total) AS 'Minimum invoice', 
         CONCAT('%', ROUND(percent_difference, 2)) AS 'Percent difference',
         count_invoice_id AS 'Number of invoices';
END//

DELIMITER ;

CALL test();

---------------------------------------

-- Using CASE vs. IF
-- check whether there are overdue invoices
-- invoices with a balance where invoice_due_date < current date

USE ap;

SELECT MIN(invoice_due_date)
  FROM invoices
  WHERE invoice_total - payment_total - credit_total > 0;


SELECT MIN(invoice_due_date)
  INTO @first_invoice_due_date
  FROM invoices
  WHERE invoice_total - payment_total - credit_total > 0;

select @first_invoice_due_date;



DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE first_invoice_due_date DATE;

  SELECT MIN(invoice_due_date)
  INTO first_invoice_due_date
  FROM invoices
  WHERE invoice_total - payment_total - credit_total > 0;

  IF first_invoice_due_date < NOW() THEN   -- current date
    SELECT 'Outstanding invoices overdue!';
  ELSEIF first_invoice_due_date = NOW() THEN
    SELECT 'Outstanding invoices are due today!';
  ELSE
    SELECT 'No invoices are overdue.';
  END IF;

  -- the IF statement rewritten as a Searched CASE statement
  /*
  CASE  
    WHEN first_invoice_due_date < NOW() THEN
      SELECT 'Outstanding invoices overdue!' AS Message;
    WHEN first_invoice_due_date = NOW() THEN
      SELECT 'Outstanding invoices are due today!' AS Message;
    ELSE
      SELECT 'No invoices are overdue.' AS Message;
  END CASE;
  */
  
END//

DELIMITER ;

CALL test();


-- using cursor
-- declare Handler

-- UPDATE credit_total 
--             = credit_total + (invoice_total * .1)
-- if invoice_total > 1000    

USE ap;
SELECT invoice_id, invoice_total FROM invoices
    WHERE invoice_total - payment_total - credit_total > 0
     AND invoice_total>1000;
 

DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE invoice_id_var    INT;
  DECLARE invoice_total_var DECIMAL(9,2);  
  DECLARE row_not_found     TINYINT DEFAULT FALSE; -- FALSE is an alias to 0, that is why this works
  DECLARE update_count      INT DEFAULT 0;

  DECLARE invoices_cursor CURSOR FOR  -- step1: declare cursor
    SELECT invoice_id, invoice_total  FROM invoices
    WHERE invoice_total - payment_total - credit_total > 0;
    
  -- step2 : declare an error handler that is executed
  --         when NO rows are FOUND in the cursor 
  
  -- Condition handler
  -- DECLARE {CONTINUE|EXIT} HANDLER
  --    FOR{MySQLerrorCode|SQLstateCode|named condition
  --    handler_actions; 
  DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET row_not_found = TRUE;

  OPEN invoices_cursor; -- step3: open the cursor
    
  WHILE row_not_found = FALSE DO
    -- step4: get column values from each row at a time and assign them to variables 
    FETCH invoices_cursor INTO invoice_id_var, invoice_total_var;

    IF invoice_total_var > 1000 THEN
      UPDATE invoices
      SET credit_total = credit_total + (invoice_total * .1)
      WHERE invoice_id = invoice_id_var;

      SET update_count = update_count + 1;
    END IF;
  END WHILE;
  
  CLOSE invoices_cursor; -- step5: close the cursor
    
  SELECT CONCAT(update_count, ' row(s) updated.');
  
END//

DELIMITER ;

CALL test();


/*    Built-in named conditions   */
--  Named COndition    |   Desciption
----------------------------------------
--  NOT FOUND          |  No data is found using FETCH or select
--  SQLEXCEPTION       |  Any error condition other than NOT FOUND
--  SQLWARNING         |  Any error condition other than NOT FOUND
--                        OR when a warning message occurs
		

-- Standard DB access is faster and uses fewer server 
-- resources than cursor-based access.
-- Only use cursor where it makes sense and you can accomplish
-- what you need to do using a regular query

-- in-class exercise

-- Write a script that creates a stored procedure names test.
-- It should create a cursor for the result set that consists
-- of venndor_name, invoice_number, and balance_due
-- for each invoice with a balance >=$5000
-- the result should in descending order by balance due
-- Display a string variable that includes the balance_due, 
-- invoice_numer, and vendor_name for each invoice
-- separate each column by a pipe character and each row by (//)

-- SOlution

USE ap;

SELECT vendor_name, invoice_number,
      invoice_total - payment_total - credit_total AS balance_due
    FROM vendors v JOIN invoices i
      ON v.vendor_id = i.vendor_id
    WHERE invoice_total - payment_total - credit_total >= 5000
    ORDER BY balance_due DESC;


DROP PROCEDURE IF EXISTS test;

-- Change statement delimiter from semicolon to double front slash
DELIMITER //

CREATE PROCEDURE test()
BEGIN
  DECLARE vendor_name_var     VARCHAR(50);
  DECLARE invoice_number_var  VARCHAR(50);
  DECLARE balance_due_var     DECIMAL(9,2);

  DECLARE s                   VARCHAR(400)   DEFAULT '';
  DECLARE row_not_found       INT            DEFAULT FALSE;
  
  DECLARE invoices_cursor CURSOR FOR
    SELECT vendor_name, invoice_number,
      invoice_total - payment_total - credit_total AS balance_due
    FROM vendors v JOIN invoices i
      ON v.vendor_id = i.vendor_id
    WHERE invoice_total - payment_total - credit_total >= 5000
    ORDER BY balance_due DESC;

  BEGIN
    DECLARE EXIT HANDLER FOR NOT FOUND
      SET row_not_found = TRUE;

    OPEN invoices_cursor;
    
    WHILE row_not_found = FALSE DO
      FETCH invoices_cursor 
      INTO vendor_name_var, invoice_number_var, balance_due_var;

      SET s = CONCAT(s, balance_due_var, '|',
                        invoice_number_var, '|',
                        vendor_name_var, '//');
    END WHILE;
  END;

  CLOSE invoices_cursor;    
  
  SELECT s AS message;
END//

-- Change statement delimiter from semicolon to double front slash
DELIMITER ;

CALL test();





