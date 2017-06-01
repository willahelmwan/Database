drop database test;
create database if not exists test;
USE test;

-- can check the existence of a table before dropping it
-- DDL drop command can be conditionally executed on the existence of the table
Drop table if exists simple;

-- to create a table specify the table name, the field names and the field data types. 
Create table simple(a int, b varchar(30)) ;

-- You can create a temporary table
-- temporary tables allow you to store a result set to disk when you do not have full write access to the db
-- you can also  use a temporary table as an optimization
-- the table is reaped whenever the DB decides typically set by the DBA
--  in mysql the table is reaped when the client session ends
create temporary table simpletemp(a int, b varchar(30));

-- you can also manually delete a temporary table 
drop temporary table simpletemp;

-- Here we are not providing a value for a so its value will be set to the 
INSERT INTO simple (b) VALUES ('Hello');

select * from simple;

drop table if exists simple2;
-- can use a table as a template for another table
create table simple2 LIKE simple;

-- do you think it copies the data to the new table??
select * from simple2;

-- Use the describe command to get a description of a table 
DESCRIBE simple;
-- Alias for the describe command 
desc simple;
select * from simple;
-- CONSTRAINTS are used to enforce the integrity of the data in a table  or across tables
-- a consraint is a set of rules that define the values than can be stored in a field 
-- that can be stored in the columns of the table.
-- you code column level constraints as part of the definition of the field
-- you code table level constraints as if it was a separate column definition

-- Example NOT NULL
Drop table if exists simple;
Create table simple(a int NOT NULL, b varchar(30)) ;
-- If you specify a field must have a value, then you cannot insert a record without a value for that field 
-- this generates an error 
INSERT INTO simple (b) VALUES ('Hello');
DESCRIBE simple;
select * from simple;

drop database if exists scratch;
create database if not exists scratch;
use scratch;
-- Example constrain the b columm such that all values musr be unique 
Drop table if exists simple;
Create table simple(a int NOT NULL DEFAULT 5, b varchar(30) UNIQUE) ;
INSERT INTO simple (b) VALUES ('Hello');
DESCRIBE simple;
select * from simple;
INSERT INTO simple (b) VALUES ('Good bye');
-- Cannot insert 2 records with the same b value 
select * from simple;
INSERT INTO simple (b) VALUES ('Good bye');
-- Why does this fail?
INSERT INTO simple (a,b) VALUES (NULL,'Hello');

use scratch;
-- Example: constrains the b columm such that all values must be unique 
Drop table if exists simple;
Create table simple(a int NOT NULL DEFAULT 5, b varchar(30) UNIQUE) ;



-- Example DEFAULT
Drop table if exists simple;
Create table simple(a int NOT NULL DEFAULT 5, b varchar(30)) ;
INSERT INTO simple (b) VALUES ('Hello');
DESCRIBE simple;
select * from simple;

-- Cannot insert a record that specifically claims the field should be NULL 
INSERT INTO simple (a,b) VALUES (NULL,'Hello');

-- Creating primary keys
use scratch;
use test;
drop database test;
create database test;
-- Example primary key with autoincrement
Drop table if exists simple;
Create table simple(a int primary key auto_increment,
   b varchar(30)) ;
-- ALternative representation
Drop table if exists simple;
Create table simple(a int  auto_increment, b varchar(30), 
    primary key(a)) ;
-- ALternative representation
DESCRIBE simple;
Drop table if exists simple;
-- this is defining a table level primary key constraint
Create table simple(a int  auto_increment, b varchar(30), 
constraint simple_pk primary key(a)) ;
DESCRIBE simple;
-- when you specify a field as a primary key in My SQL
-- the field values must be unique
-- the column is forced to be NON NULL
-- an index is created on the field for quick lookup
INSERT INTO simple (b) VALUES ('Hello');
INSERT INTO simple (b) VALUES ('World');
DESCRIBE simple;
select * from simple;

-- Example of a composite key constraint
drop table if exists simple;
Create table simple(a int  auto_increment, b varchar(30),
  constraint simple_pk primary key(a,b)) ;
DESCRIBE simple;
-- when you specify a field as a primary key in My SQL
-- the field values must be unique
-- the column is forced to be NON NULL
-- an index is created on the field for quick lookup
INSERT INTO simple (b) VALUES ('Hello');
-- Will this code fail or run??
INSERT INTO simple (b) VALUES ('Hello');
INSERT INTO simple (b) VALUES ('World');
DESCRIBE simple;
select * from simple;

-- describe relationships between 2 tables via the foreign key constraint 
-- a foreign key constraint requires values from one table to match values in another table 
-- This defines a relaitonship between the two tables and enforces referential integrity 
-- Database ensures that references are always accurate and that records do not have illegal values in
-- fields that reference other tables
drop table if exists simple;
Create table simple(id int  auto_increment, 
b varchar(30), constraint simple_pk primary key(id)) ;
Create table simpleref(a int  auto_increment,
                       b varchar(30), 
                       refsimplea int, 
                       constraint simple_pk primary key(a),
					   constraint simple_fk 
                       foreign key (refsimplea) references simple (id) );

DESCRIBE simpleref;

INSERT INTO simple (b) VALUES ('Hello');

INSERT INTO simple (b) VALUES ('World');

select * from simple;
select * from simpleref;

INSERT INTO simpleref (b,refsimplea) VALUES ('Hello', 1);

select * from simpleref;

INSERT INTO simpleref (b,refsimplea) VALUES ('World', 15);

DESCRIBE simple;
select * from simple where id = 1;

-- Can I delete a record that has another table pointing at its key???
delete from simple where id = 1;

-- You can change the behavior that occurs when you delete a record that has other tables referencing it
-- by specifying an action to occur to the referencing object 
drop table if exists simple;
Create table simple(id int  auto_increment,
         b varchar(30), constraint simple_pk primary key(id)) ;
Create table simpleref(a int  auto_increment,
                       b varchar(30), 
                       refsimplea int, 
                       constraint simple_pk primary key(a),
					   constraint simple_fk foreign key (refsimplea)
                       references simple (id) );

DESCRIBE simpleref;

INSERT INTO simple (b) VALUES ('Hello');

INSERT INTO simple (b) VALUES ('World');

INSERT INTO simpleref (b,refsimplea) VALUES ('Hello', 1);

INSERT INTO simpleref (b,refsimplea) VALUES ('World', 15);
DESCRIBE simple;
select * from simple where id = 1;

-- Can I delete a record that has another table pointing at its key???
delete from simple where id = 1;

drop table if exists simpleref;
drop table if exists simple;
Create table simple(id int  auto_increment, b varchar(30), constraint simple_pk primary key(id)) ;
Create table simpleref(a int  auto_increment,
                       b varchar(30), 
                       refsimplea int, 
                       constraint simple_pk primary key(a),
					   constraint simple_fk foreign key (refsimplea) 
                        references simple (id)
					   on delete cascade);

DESCRIBE simpleref;

INSERT INTO simple (b) VALUES ('Hello');

INSERT INTO simple (b) VALUES ('World');

INSERT INTO simpleref (b,refsimplea) VALUES ('Hello', 1);

INSERT INTO simpleref (b,refsimplea) VALUES ('World', 2);

DESCRIBE simple;

select * from simple where id = 1;

-- Can I delete a record that has another table pointing at its key???
delete from simple where id = 1;

select * from simpleref;

show index from simple;
show index from simpleref;

-- Action set the foreign key field to NULL when the referent has been deleted 
drop table if exists simpleref;
drop table if exists simple;
Create table simple(id int  auto_increment, b varchar(30), constraint simple_pk primary key(id)) ;
Create table simpleref(a int  auto_increment,
                       b varchar(30), 
                       refsimplea int, 
                       constraint simple_pk primary key(a),
					   constraint simple_fk foreign key (refsimplea) references simple (id)
					   on delete set null);

DESCRIBE simpleref;

INSERT INTO simple (b) VALUES ('Hello');

INSERT INTO simple (b) VALUES ('World');

INSERT INTO simpleref (b,refsimplea) VALUES ('Hello', 1);

INSERT INTO simpleref (b,refsimplea) VALUES ('World', 2);

DESCRIBE simple;
-- Make sure you understand what you plan to delete 
select * from simple where id = 1;

-- Can I delete a record that has another table pointing at its key???
delete from simple where id = 1;

select * from simpleref;


-- Handling updates of foreign keys 
-- Action set the foreign key field to NULL when the referent has been deleted 
drop table if exists simpleref;
drop table if exists simple;
Create table simple(id int, b varchar(30),
                     constraint simple_pk primary key(id)) ;
Create table simpleref(a int  auto_increment,
                       b varchar(30), 
                       refsimplea int, 
                       constraint simple_pk primary key(a),
					   constraint simple_fk foreign key (refsimplea) references simple (id)
					   on update set null);

DESCRIBE simpleref;

INSERT INTO simple (id, b) VALUES (1, 'Hello');

INSERT INTO simple (id, b) VALUES (2, 'World');

INSERT INTO simpleref (b,refsimplea) VALUES ('This', 1);

INSERT INTO simpleref (b,refsimplea) VALUES ('That', 2);

DESCRIBE simpleref;
-- Make sure you understand what you plan to delete 
select * from simple where id = 1;
select * from simpleref;

-- can I update my key that has a reference? 
update simple set id = 3 where b='Hello';

-- what happens to simpleref when I have a successful update 
 select * from simpleref;
 
 
-- Can I delete a record that has another table pointing at its key???
delete from simple where id = 3;




-- What is an index??
-- 

use test;
drop table simpleref;

Drop table if exists simple;
Create table simple(a int NOT NULL, b varchar(30), index(a)) ;
-- If you specify a field must have a value, then you cannot insert a record without a value for that field 
INSERT INTO simple (a, b) VALUES (1, 'Hello');
DESCRIBE simple;
show index from simple;
select * from simple;

-- DROP COMMAND
-- you have seen this earlier you can drop a database or drop a table
-- you can use the exists qualifer
drop database if exists test;
drop schema if exists test;

drop table if exists simple;

create database if not exists test;
USE test;

-- USE ALTER to add or delete fields, or constraints from a table
-- Implementation:  ensure all data writes to the table are complete, 
  --  make a copy of the table, and modify this copy
  -- delete the original copy, rename the new copy to the old name 
drop table if exists test;
CREATE TABLE test ( id int primary key auto_increment, 
   b VARCHAR(10), c VARCHAR(10) );
-- Can use alter to rename a table
-- This will change the names of the files associated with this table
ALTER table test RENAME to test1;

CREATE TABLE test ( id int primary key auto_increment, 
   b VARCHAR(10), c VARCHAR(10) );
INSERT INTO test (b,c) VALUES ('This', 'That');
INSERT INTO test (b,c) VALUES ('Kit', 'Kaboodle');
-- Can do multiple operations in one line;
ALTER TABLE test ADD d INT, drop column c;
select * from test; 
DESCRIBE test;
ALTER TABLE test DROP d;

ALTER TABLE test DROP b;
ALTER TABLE test ADD bb VARCHAR(10) AFTER id;
ALTER TABLE test ADD aa INT FIRST;
DESCRIBE test;
select * from test;

-- Can specify all of the  field attributes specified at create table time 
ALTER TABLE test ADD d VARCHAR(10) DEFAULT 'noun';
DESCRIBE test;
-- Can I add another field that is an auto_number
ALTER TABLE test ADD id2 SERIAL FIRST;
SHOW CREATE TABLE test;

DROP TABLE test;

