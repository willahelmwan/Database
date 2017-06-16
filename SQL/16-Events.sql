/***************  EVENTS *********************/
-- An event is a named block of code that executes
-- "fires" according to the event scheduler
-- Event scheduler is OFF by default
-- Turn on the event scheduler to use events
-- Make sure you turn it off if not needed to save 
-- system resources

 
-- Check if event scheduler is ON
SHOW VARIABLES LIKE 'event_scheduler';

-- Turn on event scheduler
SET GLOBAL event_scheduler = ON;  
SET GLOBAL event_scheduler = OFF;  

-- An event can be a one time event or a recurring event

-- Syntax to create an event:

-- CREATE EVENT event_name
-- ON SCHEDULE
-- 	{AT timestamp |EVERY interval [STARTS timestamp] [ENDS timestamp]}
-- DO
--  SQLblock

drop table if exists test1;
create table test1
(
test_id		int 	auto_increment primary key,
test_date	datetime
);

DROP EVENT IF EXISTS one_time_delete_audit_rows;
DROP EVENT IF EXISTS monthly_delete_audit_rows;


-- CREATE A one-time event(ON SCHEDULE AT ..) scheduled
-- to be executed one month from the current date
-- the event will delete all rows from the invoices_audit table 
-- that are more than one month old
DELIMITER //

CREATE EVENT one_time_delete_audit_rows
ON SCHEDULE AT NOW() + INTERVAL 1 MONTH
DO BEGIN
  DELETE FROM invoices_audit WHERE action_date < NOW() - INTERVAL 1 MONTH LIMIT 100;
END//


-- Create a recurring event (ON SCHEDULE EVERY..STARTS)
-- that executes every month so it deletes all rows from the 
-- audit table that are more than one month old
CREATE EVENT monthly_delete_audit_rows
ON SCHEDULE EVERY 1 MONTH
STARTS '2015-06-30 00:00:00'
DO BEGIN
  DELETE FROM invoices_audit WHERE action_date < NOW() - INTERVAL 1 MONTH LIMIT 100;
END//

DELIMITER ;

Delimiter //
Create event every_time_add_date
on schedule every 5 second
starts '2017-06-12 13:16:00'
do begin
	insert into test1(test_date) value (now());
end//
delimiter ;

select * from test1;
-- List all events on the server
SHOW EVENTS;

-- List all events on a DB
SHOW EVENTS IN ap;

-- List all events on a DB that begins with mon
SHOW EVENTS IN ap LIKE 'mon%';

-- Disable an event
ALTER EVENT monthly_delete_audit_rows DISABLE;

-- Enable an event
ALTER EVENT monthly_delete_audit_rows ENABLE;

-- Rename an event
ALTER EVENT one_time_delete_audit_rows RENAME TO one_time_delete_audits;

-- Drop an event
DROP EVENT monthly_delete_audit_rows;

-- Drop an event if it exists
DROP EVENT IF EXISTS monthly_delete_audit_rows;






USE ap;

SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS minute_test;
-- In-class exercise
-- Check whether the event scheduler is ON. If it isn't
-- code a statement that turns it on. Then create an event that 
-- inserts a test row that contains test values into the 
-- Invoices_audit every minute. To make sure that this event has
-- been created, code a SHOW EVENTS statement to view the event
-- and a SELECT statement to view the data in the Invoices_audit
-- table.
-- Once you make sure the event sorks correctly, code a DROP 
-- EVENT statement that drops the event

-- change the EVENT to run:
--       a. only run once today
--       b. run every week until 2016-09-01

DELIMITER //

CREATE EVENT minute_test
ON SCHEDULE EVERY 1 MINUTE
DO BEGIN
    INSERT INTO invoices_audit VALUES
    (9999, 'test', 999.99, 'INSERTED', NOW());
END//

DELIMITER ;

SHOW EVENTS LIKE '%min';

SELECT * FROM invoices_audit;

DROP EVENT minute_test;

DROP table test1;
