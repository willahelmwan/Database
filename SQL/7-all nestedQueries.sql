USE ap;
-- Which invoices have an invoice_total > AVG (invoice_total) 
SELECT AVG(invoice_total)
     FROM invoices;
     
SELECT invoice_number, invoice_date, invoice_total
     FROM invoices
		order by invoice_total DESC;     

SELECT invoice_number, invoice_date, invoice_total
FROM invoices
WHERE invoice_total > 
    (SELECT AVG(invoice_total)
     FROM invoices)
ORDER BY invoice_total;

USE ap;
-- Which vendors are from CA
-- Solution1
SELECT invoice_number, invoice_date, invoice_total
FROM invoices JOIN vendors
    ON invoices.vendor_id = vendors.vendor_id
WHERE vendor_state = 'CA'
ORDER BY invoice_date;

-- Solution2 using nested query
SELECT invoice_number, invoice_date, invoice_total
FROM invoices
WHERE vendor_id IN
    (SELECT vendor_id
     FROM vendors
     WHERE vendor_state = 'CA')
ORDER BY invoice_date;


-- List inactive vendors (vendors with no invoices)
-- Solution 1
SELECT vendor_id, vendor_name, vendor_state
FROM vendors
WHERE vendor_id NOT IN
    (SELECT DISTINCT vendor_id
     FROM invoices)
ORDER BY vendor_id;

-- Solution2
SELECT v.vendor_id, vendor_name, vendor_state
FROM vendors v LEFT JOIN invoices i
    ON v.vendor_id = i.vendor_id
WHERE i.vendor_id IS NULL
ORDER BY v.vendor_id;

/* ALL CONDITION MUST BE TRUE FOR ALL THE VALUES RETURNED BY THE SUBQUERY 
example x > ALL (1,2) same as x > 2
        x < ALL (1, 2) same as x < 1
        x = ALL (1,2) same as x = 1 and x =2 only makes sense if returns 1 value or the same value
        x <> ALL (1,2) same as x NOT IN (1,2) 
*/
-- Which vendors have an invoice total > all the Invoice total
-- of the vendor with the id 34
SELECT vendor_name, invoice_number, invoice_total
FROM invoices i JOIN vendors v ON i.vendor_id = v.vendor_id
WHERE invoice_total > ALL
    (SELECT invoice_total
     FROM invoices
     WHERE vendor_id = 34)
ORDER BY vendor_name;

USE ap;
/* TEST WHETHER A COMPARISON IS TRUE FOR ANY OF THE RECORDS RETURNED BY A SUBQUERY 
   x > any(1,2) x > 1
   x < any(1, 2) x < 2
   x = ANY(1,2) x in (1,2)
   x <> ANY(1,2) (x <> 1) OR (x <> 2) 
   SOME is a synonym for ANY - so it translate the same 
*/

-- Which vendors have an invoice total < any of the Invoice total
-- of the vendor with the id 34
SELECT vendor_name, invoice_number, invoice_total
FROM vendors JOIN invoices ON vendors.vendor_id = invoices.invoice_id
WHERE invoice_total < ANY
    (SELECT invoice_total
     FROM invoices
     WHERE vendor_id = 115);
     
     
-- Example: nested query
USE ap;

-- Find invoices that are above the average invoice price 
SELECT vendor_id, invoice_number, invoice_total
FROM invoices i
WHERE invoice_total >
    (SELECT AVG(invoice_total)
     FROM invoices
     )  
ORDER BY vendor_id, invoice_total;

-- correlated query use a value from the outer query to limit values for the inner query
-- find invoices that are above the average invoice 
-- for the specific vendor 
-- need an average per vendor 
-- like a JOIN between the INNER and OUTER query

-- Invoices of all vendors with invoice_total>AVG (invoice_total) 
-- (per vendor)
SELECT vendor_id, invoice_number, invoice_total
FROM invoices i
WHERE invoice_total >
    (SELECT AVG(invoice_total)
     FROM invoices j
     WHERE j.vendor_id = i.vendor_id)  
ORDER BY vendor_id, invoice_total;


USE ap;
-- A correlated subquery, we use the values in the outer most query
-- within the inner most query 
-- example also uses the NOT EXISTS construct 
-- EXISTS tests to see if the subquery returns a result set 
-- not exists does not return a result set - it returns TRUE OR FALSE 

-- returns all the vendors in the vendors tables 
-- that do not have invoices 
SELECT vendor_id, vendor_name, vendor_state
FROM vendors
WHERE NOT EXISTS
    (SELECT * 
     FROM invoices
     WHERE invoices.vendor_id = vendors.vendor_id);
     
-- Other ways to write this query???


/* IN can provide a canned list or a subquery */
USE ap;

/* IN example with a subquery */

SELECT vendor_id, vendor_name, vendor_state
FROM vendors
WHERE vendor_id  NOT IN
    (SELECT DISTINCT vendor_id
     FROM invoices)
ORDER BY vendor_id;

/* IN example with a subquery */

SELECT vendor_id, vendor_name, vendor_state
FROM vendors
WHERE vendor_id  IN
    (34, 37, 48)
ORDER BY vendor_id;