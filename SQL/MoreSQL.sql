
-- SQL is case insensitive but UNIX operating system is not so any 
-- object implemented via the file structure such as a database or a table
-- will have case sensitive names on UNIX and UNIX derived operating systems
-- Remember that in general, your server will be running on a different operating system than your client. 
-- So write portable code and build portable databases. Pick a case and stick with it. 

-- These queries could not be equivalent on certain operating systems
Select * from world.country;
Select * from world.Country;

USE world;
use World;
USE WORLD;

-- The paint brush pretty prints your query
-- highlight the query and apply the formatting
SELECT 
    *
FROM	
    country
        JOIN
    countrylanguage
        JOIN
    city ON country.code = countrylanguage.countrycode
        AND city.countrycode = country.code;
        
-- NULL is the absense of a value so we cannot use equality to identify records that do not 
-- have a value for a variable 
select * from world.country where population = NULL; -- legal statement but does not return the result set you want
select *  from world.country WHERE POPULATION IS NULL; -- special construct to identify variables with missing values

        

-- When dealing with a dataset you need to define your strategy for dealing with missing data.
-- The strategy can vary depending on what you know of the variable and the data collection process
-- OPTIONS: 
-- Remove the rows from the analysis
-- Use an approximate value for the missing values
-- If the data is normally distributed can use the average value or median value note(median function not defined in SQL)
Select IFNULL(population,0) from world.country;

Select population, IFNULL(population,0) from world.country order by population;

-- this is actually the cross product 
select case when population IS NULL then avgpopulation else population end populationcleaned from world.country cross join 
 ( select avg(population) avgpopulation  from world.country ) x ;
 
 -- look at all the fields 
 select  *, case when population IS NULL then avgpopulation else population end populationcleaned
          from world.country cross join 
 ( select avg(population) avgpopulation  from world.country ) x ;
 
 


-- Aggregated functions 
-- Remember the argument passed to count can vary its return value 
-- it counts distinct values for the argument
-- the * forces count to count records or tuples 
-- will count duplicate records for you 
SELECT COUNT(population) from world.country;
SELECT COUNT(*) from world.country;

-- More advanced filtering 
-- Where clause allows you to filter the records that contribute to the result set
select * from world.country where continent = 'Europe';

-- between allows you to easily specify a range of values to match
-- it is inclusive so endpoints are included in the result 
SELECT * FROM WORLD.COUNTRY where surfacearea between 0 and 5000 order by surfacearea;
SELECT * FROM WORLD.COUNTRY where surfacearea between .40 and 4033 order by surfacearea;

-- you can specify the opposite of the range you want to match with not between 
SELECT * from world.country where surfacearea not between 0 and 5000 order by surfacearea;

-- Aggregators in My SQL
USE world;

-- Basic aggregators provided by the SQL standard
select sum(surfacearea), avg(surfacearea), min(surfacearea), 
max(surfacearea) from country;

SELECT continent, max(lifeExpectancy) AS ContMax from world.country group by continent;

-- My SQL provides a text grouping function group_concat
-- it creates a new string for each group
-- 
SELECT continent, group_concat(name) from world.country group by continent order by continent;


SELECT * FROM country join countrylanguage on country.code = countrylanguage.countrycode;


-- the HAVING clause allows us to filter the results that are returned in the result set 
SELECT continent, MAX(surfacearea)
     from world.country GROUP BY continent HAVING MAX(surfacearea) > 8000000
     ORDER BY MAX(surfacearea);
     


-- Not efficient since you could have filtered the original tuples 
-- with a where clause  
-- select continent, MAX(surfacearea)  where continent = 'Europe' from world.country;
     SELECT continent, MAX(surfacearea)
     from world.country GROUP BY continent HAVING continent = 'Europe';
     
 -- Not legal will generate an error 
 -- country is not part of the resut set 
 
  SELECT continent, MAX(surfacearea)
     from world.country GROUP BY continent HAVING country = 'Austria';

 -- Wrong results not grouping by the variable gnp 
      
 SELECT continent, gnp, MAX(surfacearea)
     from world.country GROUP BY continent,gnp HAVING MAX(surfacearea) > 8000000 ;
 
 
 
 -- Order by clause 
 -- Default method is in ascending order 
use world;
-- print Asian country statistics in order of the GNP
select * from country where continent = 'Asia' order by gnp;
 -- equivalent query 
 select * from country where continent = 'Asia' order by gnp asc;
 -- you can specify more than one field to sort on 
 -- sort strings alphabetically
 select * from country  order by continent, gnp; 
 -- you can specify different sort orders for the different fields 
 select * from country  order by continent asc, gnp desc; 
 
 -- you can even specify the order by position in the result set
 select name, continent from world.country order by 1;

 select name, continent from world.country order by 1 desc; 
 
-- ORDERING the result set by a function is allowed   
SELECT name, continent FROM world.country  ORDER BY REVERSE(name);
SELECT name FROM world.country ORDER BY RAND();
select continent from world.country group by continent asc;
select continent from world.country group by continent order by NULL;

 
-- More ways to filter records 
-- Specify the maximum number of records in the result set with the LIMIT keyword
select * from country order by name limit 10 ;
-- you can even specify an offset as to where to start pulling the records
select * from country limit 5, 10; -- offset, limit 

SELECT * FROM world.country ORDER BY name LIMIT 0, 10;

-- CASE alternating result set via data values 
-- Simple case check for specific values in a field
-- Method for creating a dummy variable in statistics 

-- What data is in the DB?
select continent, count(*) from country group by continent;

select continent, case continent
 when 'Asia' then 1
 when 'Europe' then 2
 when 'North America' then 3
 when 'Africa' then 4
 when 'Oceana' then 5
 when 'Antartica' then 6
 when 'South America' then 7 
 else -1 end ContinentCode from country;
 
 -- More complex example: matching expressions instead of values 
 select case when surfacearea is null or surfacearea < 100000 then 'Small country'
             when surfacearea < 2000000 then 'Medium sized country'
             when surfacearea < 3000000 then 'Large sized country'
             else 'Oversized country' end sizecategory, name, surfacearea
             from country order by surfacearea;
 
 
SELECT 
    name,
    CASE
        WHEN continent LIKE 'A%' THEN 1
        ELSE 0
    END AS AsianCountry
FROM
    country;


-- Simple string matching function LIKE EXPRESSION

-- % matches 0 or more characters in a row, ending wih a string 
-- _ underscore matches a single character '_d%'
-- if you want to match the percent sign need to preceed with a backslash \% match percent character 
-- to search for '\' use  \\\\ since 2 copies needed to represent, 2 to quote 
use world;
select * from country where name like 'A%';
--  underscore matches 1 character 
select * from country where continent like 'A___';
-- typically match is not case sensitive 
select * from country where continent like 'A__A';
use scratch;
-- Create a simple table 
drop table scratch;
create table  scratch (a int, b int, c TEXT);

-- Insert some hard coded values 
insert into scratch (b,c) VALUES (3,'T%his');
insert into scratch (b,c) VALUES (2,'This');
-- To actually insert a backslash it takes two \\
insert into scratch (b,c) VALUES (5,'T%hi\\s');

-- backslash allows me to match the first percent sign , second percent sign matches 0 or more characters
select * from scratch where c LIKE 'T\%%';
select * from scratch;
DESCRIBE scratch;

-- match backslash ??
select * from scratch where c LIKE '%\\_';
-- it does not match because it takes 2 copies to represent the value 

select * from scratch where c LIKE '%\\\\_';

select * from scratch where c LIKE '%\\\\s';

select * from scratch where c LIKE '%\\\\_';
insert into scratch (b,c) VALUES (3,'This');

select * from scratch where c like '%\%%';

-- INSERT and UPDATE Commands
-- Playing with NULLs 

-- start from scratch
use scratch;
drop database if exists  scratch;    
-- Create a database 
create database scratch;
-- Create a simple table 
create table  scratch (a int, b int, c TEXT);

-- Insert some hard coded values 
insert into scratch (b,c) VALUES (3,'This');
insert into scratch (b,c) VALUES (3,'Hello');

-- See how the values are stored in the table
SELECT * FROM SCRATCH;
-- Cannot match a NULL 
SELECT * from scratch where a = NULL;
-- Proper way to match a NULL
SELECT * FROM scratch where c IS NULL;
-- Change the text value to be an empty string - so highlighting the difference between NULL and ''
UPDATE scratch set c = '';
-- can set a field to a compuation

-- can use a computation for an update
update scratch set b = b * 2;

-- trying to update a field that does not exist in the table 
update scratch set d = d * 2;

select * from scratch;

-- what happens when I try to update a NULL field value 
update scratch set a = a * 2;

-- you can use another field in the table to determine which records to update

update scratch set a = a * 2 where b = 6;
describe scratch;

-- Look at the way the empty string is stored 
select * from scratch;
-- '' is a value so we can use equality to match records with that value 
select * from scratch where c = '';
-- it is NOT EQUIVALENT to NULL
select * from scratch where c IS NULL;

-- It is not just equality that cannot match NULL the other Boolean operations 
SELECT (NULL=NULL) OR (NULL<>NULL) OR (NOT NULL);
-- NULL not part of the sort order for numbers 
 SELECT (1 < NULL) OR (1 > NULL) OR (1 LIKE NULL);



drop table if exists america;
-- Accelarator create a table using the results of a query
CREATE TABLE america SELECT * from country where continent = 'South America';
select * from america;
-- If the table is already created can insert result tuples 
insert into america select * from country where continent = 'North America';
select * from america;
-- Update command

-- create some simple scratch tables 
use scratch;
create table scratch1 (id int, name char(20));
create table scratch2 (id int, name char(20));
-- insert some values 
insert scratch1 (id, name) VALUES( 1, 'Hello');
insert scratch1 (id, name) VALUES( 2, 'Their');
insert scratch2 (id, name) VALUES( 1, 'Bye');

select * from scratch1;

-- Let's update some values 
-- Simple update where the updated value is not computed 
UPDATE scratch1 SET name = 'There' where id = 2;
-- can compute the updated value from other tables 
update scratch1 join scratch2 on scratch1.id = scratch2.id set scratch1.name = scratch2.name;
select * from scratch1;
-- can apply a function to determine the update 
UPDATE scratch1 SET name = REPLACE(name, 'Bye', 'Bye Bye');
select * from scratch1;
