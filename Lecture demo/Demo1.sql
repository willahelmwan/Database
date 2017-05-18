use ap;
-- Select payment_total, credit_total, payment_total + credit_total from invoices;
-- * / DIV(integer division) % + - 
-- Select invoice_id, invoice_id/3 AS decimalQuotient, invoice_id DIV 3, invoice_id % 3 from invoices;
-- Select invoice_number, invoice_date, invoice_total from invoices where invoice_date = '2014-06-01'
-- Select invoice_number, invoice_date, invoice_total from invoices where invoice_date not between '2014-06-01' AND '2014-06-30';
-- Select vendor_city, vendor_state, vendor_zip_code, concat(vendor_city, ', ' , vendor_state, ' ', vendor_zip_code) AS address from vendors; 
-- Select vendor_contact_first_name, vendor_contact_last_name, concat(left(vendor_contact_first_name,1), left(vendor_contact_last_name, 1))AS initials from vendors;
-- Select invoice_total, round(invoice_total) as nearest_dollar, round(invoice_total, 1) as nearest_dime from invoices;
-- Select invoice_due_date, date_format(invoice_due_date, '%m/%d/%y'), date_format(invoice_due_date, '%e-%b-%y') from invoices;
-- Select Distinct vendor_city, vendor_state from vendors;
-- Select invoice_total, invoice_date from invoices where NOT(invoice_total>=5000 OR NOT(invoice_date <= '2014-08-01'));
-- Select invoice_total, invoice_date from invoices where invoice_total<5000 AND invoice_date <= '2014-08-01';
-- Select vendor_name from vendors where vendor_state IN ('DC', 'WI', 'OR');
-- Select vendor_name, vendor_city from vendors where vendor_city like 'san%';
-- Select vendor_name, vendor_city from vendors where vendor_name like 'compu_er%';
-- Select vendor_name, vendor_city from vendors where vendor_city REGEXP 'SA'; -- contains SA 
-- Select vendor_name, vendor_city from vendors where vendor_city REGEXP '^SA'; -- starts with SA
-- Select vendor_name, vendor_city from vendors where vendor_city REGEXP 'NA$'; -- ends with NA
-- Select vendor_name, vendor_city from vendors where vendor_city REGEXP 'RS|SN'; -- contains RS or SN
-- Select vendor_name, vendor_city from vendors where vendor_city REGEXP 'N[CV]'; -- contains either NC or NV
-- Select vendor_name, vendor_city from vendors where vendor_city REGEXP 'N[C-F]'; -- contains NC, ND, NE, or NF
-- Select vendor_name, vendor_city from vendors where vendor_city REGEXP 'N[CV][FG]';
-- Select vendor_name, vendor_city from vendors order by vendor_name desc; -- sort in descending order
-- Select vendor_name, vendor_city from vendors order by vendor_city, vendor_name;
-- Select vendor_name, vendor_city from vendors order by 2, 1;
-- Select vendor_name, vendor_city, 2+2 as addition from vendors order by addition; -- by ordering with the new column name
-- Select vendor_name, vendor_city, 2+2 as addition from vendors order by addition limit 4;




