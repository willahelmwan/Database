/*************** Triggers ********************/
-- A trigger is a named block of code that is 
-- executed "fired" in response to an INSERT/DELETE/UPDATE


-- CREATE TRIGGER trigger_name
--   (BEFORE|AFTER) (INSERT|DELETE|UPDATE)
-- 				ON table_name
--    FOR EACH ROW
-- 	  SQLblock	 	

USE ap;

DROP TRIGGER IF EXISTS vendors_before_update;

DELIMITER //

CREATE TRIGGER vendors_before_update
  BEFORE UPDATE ON vendors -- Trigger fired before any UPDATE on the table Vendors
  FOR EACH ROW  -- this creates a row level trigger that is fired for each row being modified
                -- MySQL ony supports row_level triggers
BEGIN -- block of code executed once the trigger is fired
  SET NEW.vendor_state = UPPER(NEW.vendor_state); -- NEW refers to the new value of state after the UPDATE
END//

DELIMITER ;

SELECT vendor_name, vendor_state
FROM vendors
WHERE vendor_id = 1;

UPDATE vendors
SET vendor_state = 'ri'
WHERE vendor_id = 1;

-- check new value
SELECT vendor_name, vendor_state
FROM vendors
WHERE vendor_id = 1;

-- Reset data
UPDATE vendors
SET vendor_state = 'wi'
WHERE vendor_id = 1;

-- Triggers are commonly used to enforce data consistency
-- If a rule can't be enforced using a constraint, 
-- then you use a trigger for that purpose.

-- Triggers are more flexible than constraints since you can program a trigger

USE ap;

-- Let's say we have to enforce the following constraint:
-- SUM(line_item_amount) = invoice_total
-- for all invoices

SELECT SUM(line_item_amount) 
  -- INTO @sum_line_item_amount
  FROM invoice_line_items
  WHERE invoice_id = 100;
  
SELECT invoice_total
  FROM invoices
  WHERE invoice_id = 100;

-- Now if we change the invoice_total for the invoice_id 100
/*
UPDATE invoices
SET invoice_total = 600
WHERE invoice_id = 100;
*/

-- This update can't be completed and an error should be thrown

DROP TRIGGER IF EXISTS invoices_before_update;

DELIMITER //

CREATE TRIGGER invoices_before_update
  BEFORE UPDATE ON invoices
  FOR EACH ROW
BEGIN
  DECLARE sum_line_item_amount DECIMAL(9,2);
  
  SELECT SUM(line_item_amount) 
  INTO sum_line_item_amount
  FROM invoice_line_items
  WHERE invoice_id = NEW.invoice_id;
  
  IF sum_line_item_amount != NEW.invoice_total THEN
    SIGNAL SQLSTATE 'HY000' -- 'HY000' indicates a general error
      SET MESSAGE_TEXT = 'Line item total must match invoice total.';
  END IF;
END//

DELIMITER ;

UPDATE invoices
SET invoice_total = 600
WHERE invoice_id = 100;

SELECT invoice_id, invoice_total, credit_total, payment_total 
FROM invoices WHERE invoice_id = 100;

-- Triggers are also used to store information a statement after 
-- it executes
USE ap;

-- Let's say we want to keep track of all new invoices and
-- deleted invoices
/*
INSERT INTO invoices VALUES 
(115, 34, 'ZXA-080', '2014-08-30', 14092.59, 0, 0, 3, '2014-09-30', NULL);

DELETE FROM invoices WHERE invoice_id = 115;
*/


-- Audit Table

DROP TABLE if exists invoices_audit;

CREATE TABLE invoices_audit
(
  vendor_id           INT             NOT NULL,
  invoice_number      VARCHAR(50)     NOT NULL,
  invoice_total       DECIMAL(9,2)    NOT NULL,
  action_type         VARCHAR(50)     NOT NULL,
  action_date         DATETIME        NOT NULL
);

DROP TRIGGER IF EXISTS invoices_after_insert;

DELIMITER //

CREATE TRIGGER invoices_after_insert
  AFTER INSERT ON invoices
  FOR EACH ROW
BEGIN   -- You can use NEW to refer to values after a given action is completed
        -- Use OLD to refer to values before a given action is completed
    INSERT INTO invoices_audit VALUES   -- can't use OLD with a row being inserted
    (NEW.vendor_id, NEW.invoice_number, NEW.invoice_total, 
    'INSERTED', NOW());
END//

DELIMITER ;

INSERT INTO invoices VALUES 
(115, 34, 'ZXA-080', '2014-08-30', 14092.59, 0, 0, 3, '2014-09-30', NULL);

-- Check out data in the table invoices_audit
Select * from invoices_audit;

-- In-class exercise
-- Create 2 triggers: invoices_after_delete and invoices_after_update
-- The first should insert the data deleted in the table invoices_audit
-- and the second should insert the old data after the row
-- is updated
-- Test your triggers to make sure they work properly


DROP TRIGGER IF EXISTS invoices_after_delete;

DELIMITER //
CREATE TRIGGER invoices_after_delete
  AFTER DELETE ON invoices
  FOR EACH ROW
BEGIN
    INSERT INTO invoices_audit VALUES -- can't use NEW with a row being deleted
    (OLD.vendor_id, OLD.invoice_number, OLD.invoice_total, 
    'DELETED', NOW());
END//

DELIMITER ;

-- make sure that there is at least one record to delete
DELETE FROM invoices WHERE invoice_id = 115;

SELECT * FROM invoices_audit;

DROP TRIGGER IF EXISTS invoices_after_update;

DELIMITER //
CREATE TRIGGER invoices_after_update
  AFTER UPDATE ON invoices
  FOR EACH ROW
BEGIN
    INSERT INTO invoices_audit VALUES -- can use both NEW and OLD
    (OLD.vendor_id, OLD.invoice_number, OLD.invoice_total, 
    'UPDATED', NOW());
END//

DELIMITER ;

select * from invoices where invoice_id=115; -- vendor_id=34
-- update data 
Update invoices set vendor_id=20 WHERE invoice_id = 115;

SELECT * FROM invoices_audit;


-- clean up
-- DELETE FROM invoices_audit;
-- Update invoices set vendor_id=34 WHERE invoice_id = 115;


SHOW TRIGGERS IN ap; -- lists triggers in the ap database

SHOW TRIGGERS IN ap LIKE 'ven%';

DROP TRIGGER IF EXISTS vendors_before_update;




