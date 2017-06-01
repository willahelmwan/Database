USE ap;

select vendor_id, invoice_id 
     from invoices;
	
    
select vendor_id, invoice_id 
     from invoices
		order by vendor_id;

-- Total number of invoices per vendor
SELECT vendor_id, count(*) AS num_invoices 
	FROM invoices
		GROUP by vendor_id;

-- Average invoice amount per vendor. Order by AVG(average_invoice_total)
SELECT vendor_id as id, ROUND(AVG(invoice_total), 2) AS average_invoice_amount
	FROM invoices
		GROUP BY vendor_id
			ORDER BY average_invoice_amount DESC;

use ap;

-- calculate aggregated functions on the complete table 

-- Total number of invoices with a total due > 0 AND
-- the total amount due=  invoice_total- payment_total- credit_total
select * from invoices
	where invoice_totaL - payment_total- credit_total > 0;
    
select SUM(invoice_total- payment_total- credit_total) from invoices
	where invoice_totaL - payment_total- credit_total > 0;    
    
SELECT COUNT(*) AS number_of_invoices,
    SUM(invoice_total- payment_total- credit_total) AS total_due
		FROM invoices
			WHERE invoice_totaL - payment_total- credit_total > 0;

-- this should be illegal statement but in MySQL is not illegal
SELECT COUNT(*) , payment_total from invoices;

-- Sense of Values
SELECT * from invoices;
SELECT count(*) from invoices;
SELECT payment_total from invoices; 

-- field_list needs to contain the group by field_list 
-- total payment per vendor
SELECT vendor_id, sum(payment_total) 
     FROM invoices 
		group by vendor_id;

-- count the number of vendors from the table invoices
SELECT COUNT(vendor_id) as vendor_instances 
	FROM invoices;
    
-- Check this out, what do you notice?
Select vendor_id from invoices;


-- remove duplicates 
SELECT COUNT(DISTINCT vendor_id) as vendor_nums 
    FROM invoices;

-- determine the number of different vendors for each terms_id
SELECT terms_id, vendor_id from invoices;
SELECT DISTINCT terms_id, vendor_id 
		from invoices;
 
SELECT terms_id, COUNT(DISTINCT vendor_id) as vendor_nums 
	from invoices 
		group by terms_id;
        
-- What is the total number of vendors 
Select Count(vendor_id) from invoices;
Select Count(distinct vendor_id) from invoices;
Select Count(vendor_id) from vendors;
-- COUNT ignores NULL values--
-------------------------------------------------
-- HAVING clause allows you to create a filter for the aggregated data
use ap;
-- What are all the payments made by vendors after 06/24/2014
SELECT vendor_id As ID, invoice_date AS Idate, payment_total 
	from invoices
       where invoice_date >= '2014-06-24'
		order by ID, Idate;

-- What is the total amount payed by each vendor after 06/24/2014
SELECT vendor_id As ID, invoice_date AS Idate, SUM(payment_total) 
	from invoices
       where invoice_date >= '2014-06-24'
		order by ID, Idate;
        
-- Sense of data        
SELECT SUM(payment_total) 
	from invoices
      where invoice_date >= '2014-06-24';
      
-- Correct answer
SELECT vendor_id As ID, invoice_date AS Idate, SUM(payment_total) 
	from invoices
       where invoice_date >= '2014-06-24'
          group by vendor_id, invoice_date
		      order by ID, Idate;

-- Order of execution              
SELECT vendor_id As ID, invoice_date AS Idate, SUM(payment_total) 
	from invoices
       where invoice_date >= '2014-06-24'
          group by ID, Idate
		      order by ID, Idate;
              
-- List the vendors with a total amount paid >1000 after 06/24/2014
SELECT vendor_id As ID, SUM(payment_total) 
	from invoices
       where invoice_date >= '2014-06-24'
          group by ID
		      order by SUM(payment_total) DESC;
              
SELECT vendor_id As ID, SUM(payment_total) AS paymentTotal 
	from invoices
       where invoice_date >= '2014-06-24'
          group by ID
            having paymentTotal > 1000;
        
-- Vendors with an average invoice total >2000
SELECT vendor_id, ROUND(AVG(invoice_total), 2) AS average_invoice_amount
	FROM invoices
		GROUP BY vendor_id
			HAVING AVG(invoice_total) > 2000
				ORDER BY average_invoice_amount DESC;



-- create a table that includes invoice_id, invoice_date,
-- and payment_total for invoices with a total payment
-- above the average total payment. Use the table paid_invoices
Drop Table if exists above_avg;
CREATE TABLE above_avg
	SELECT invoice_id, invoice_date, payment_total
      FROM paid_invoices
		where payment_total > (SELECT AVG(payment_total) FROM paid_invoices); 


-- using ex schema
-- identify the invoices with a total payment above the average payment 
-- total and return the difference between the total payment
-- and the average payment
USE ex;
SELECT invoice_id, invoice_date, 
  payment_total - (select avg(payment_total) from paid_invoices)
	FROM paid_invoices
		 where payment_total > (SELECT AVG(payment_total) FROM paid_invoices); 
         
SELECT invoice_id, invoice_date,
payment_total - (select avg(payment_total) from paid_invoices) AS aboveAvg
	FROM paid_invoices
		where payment_total > (SELECT AVG(payment_total) FROM paid_invoices); 


