/*
a)	How many databases are created by the script? 
Answer: 3

b)	List the database names and the tables created for each database. 
Answer: 
om: 
customers
items
order_details
orders

ex:
active_invoices
color_sample
customers
date_sample
departments
employees
float_sample
null_sample
paid_invoices
projects
string_sample

ap:
general_ledger_accounts
invoice_archive
invoice_line_items
invoices
terms
vendor_contacts
vendors

c)	How many records does the script insert into the om.order_details table? 
Answer: 68

d)	What is the primary key for the om.customers table? 
Answer: customer_id
*/

-- e)	Write SQL queries to answer the following questions on the om database. Include a comment that specifies the problem number before each SQL statement i.e. 2.f, 2.g 
SELECT * FROM om.orders; -- 2.f
SELECT title, artist FROM om.items; -- 2.g
