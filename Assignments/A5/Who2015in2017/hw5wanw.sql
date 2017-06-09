use who2015v6;
-- 1.	How many people have died from cause 'B54'? (5 points)
select cause, sum(deaths1) as deaths from deaths group by cause having cause ='B54';

-- 2.	What is the description of ‘B54’ that is listed in the icd9 table? (5 points) 
select description from icd9 where cause = 'B54';

-- 3.	How many tuples in the admin1 table do not have a description listed as = ‘Country’? (5 points)
select count(*) as description_count from admin1 where description <> 'Country';

-- 4.	What are the names of the countries that have reported death counts using ICD9?  (5 points) 
select distinct country_name from country natural join 
		(select * from deaths natural join icd9) x;

-- 5.	What countries have reported deaths due to leprosy? (5 points) 
select distinct country_name from country natural join 
		(select * from deaths natural join icd9 where description = 'leprosy') x;

/* 6.	How many people are coded as dying from AIDS ? (Remember not all countries represent 
 		their data in ICD9 or report data to WHO so the count will be lower than what you would 
 		expect; also the country table has statistics on subpopulations make sure you limit the 
 		results to countries) (5 points) */

select sum(deaths1) as dying_from_AIDS from deaths join (select * from icd9 where description like '%AIDS%') x 
	on deaths.cause = x.cause;
-- assume both causes B184 and B185 count as dying from AIDS. 

-- 7.	What countries have reported deaths attributed to AIDS? (5 points) 
select distinct country_name from country where country in 
	(select distinct country from deaths join (select * from icd9 where description like '%AIDS%') x 
	on deaths.cause = x.cause);

-- 8.	What was the first year that reported a death due to AIDS? (5 points) 
select ryear from deaths join (select * from icd9 where description like '%AIDS%') x 
	on deaths.cause = x.cause
    order by ryear limit 1;

-- 9.	How many people are coded (using ICD9) as dying from AIDS in the US (Unites States of America)? (5 points)
select sum(deaths1) as dying_from_AIDS_US from deaths join (select cause from icd9 where description like '%AIDS%') x 
	on deaths.cause = x.cause
    group by country
    having deaths.country = (select country from country where country_name = 'United States of America');
-- assume both causes B184 and B185 count as dying from AIDS. 
 
-- 10.	In what years did the US report deaths from AIDS using ICD9? (5 points) 
select distinct ryear from deaths join (select * from icd9 where description like '%AIDS%') x 
	on deaths.cause = x.cause
    where deaths.country = (select country from country where country_name = 'United States of America');
-- assume both causes B184 and B185 count as dying from AIDS. 

-- 11.	In 1980, what is the most commonly coded cause of death for women in the United Kingdom? (5 points)
select * from icd9 
	where cause = (select cause from deaths 
			where deaths.country = (select country from country where country_name = 'United Kingdom') and ryear = 1980 and sex = 2
			order by deaths1 desc limit 1,1);

-- 12.	In 1980, what percentage of the United Kingdom’s female population died from the leading cause of death ? (10 points) 
select concat(((select deaths1 from deaths 
	where deaths.country = (select country from country where country_name = 'United Kingdom') and ryear = 1980 and sex = 2
    order by deaths1 desc limit 1,1)/
(select pop1 from population 
	where population.country = (select country from country where country_name = 'United Kingdom') and ryear = 1980 and sex = 2
    order by pop1 desc limit 1))*100, '%') as percetage;

-- 13.	What are the ten topmost reported cause of death in the United Kingdom for the year 1979? (10 points) 
select * from icd9 natural join 
	(select cause from deaths 
		where deaths.country = (select country from country where country_name = 'United Kingdom') and ryear = 1979 
		group by cause
		order by sum(deaths1) desc limit 1, 10) x;
-- assume the remainder of B27 count as a different cause than B27


/* 14.	Determine the number of deaths associated with malignant neoplasms for each year that has 
		reported a death associated with malignant neoplasms. Malignant neoplasm icd9 codes can be 
        retrieved from the icd9 table where the description can be matched to  ‘%MN OF %’ (10 points) */
select ryear, sum(deaths1) as MN_deaths from deaths 
	natural join (select cause from icd9 where description like '%MN OF %') x
    group by ryear;       

/* 15.	The admin1 table and the subdiv1 table were introduced to allow reporting on subdivisions of a 
		country’s population. Was the concept of subpopulations properly introduced into the schema with 
        these tables? Can you suggest an alternative method? (5 points) */
/*		
		The concept of subpopulations is not properly introduced into the schema. 
        A sub division A00 can be added to the subdiv1 table, which represent the total population. 
        Then in the population table three of the columns (country, admin1, subdiv1) can be used 
        together as the primary key. That way the population can be reported as subdivisions. 
        Whatever combination of country and admin1 plus subdiv1 = A00 would be the total population. 
        Any other subdiv1 would represent a subdivision of the country's pouplation. 
        
*/
         

-- 16.	Please name at least 5 ways you could improve the layout of this database. (5 points) 
/*		1. Add foreign key constraints. 
		2. Use more descriptive names for the columns.
        3. Increase data integrity by adding contraints. 
        4. Data redundancy can be reduced. 
        5. Add another attribute in the country table named admin1 then make that a foreign key references to 
			admin1 table's primary key, instead of the other way around. 
*/

/* 17.	Currently there is no systematic representation of the merging and dividing of countries throughout
		the years. The schema does not even represent countries that are currently in existence versus defunct.
        Can you suggest a method to represent country evolution within the schema? Can you describe a method 
        that would enforce statistical collection only on currently existing countries? (5 points) */
/*
		You can create another table with the country code, the year, and another column represent whether the
        country is in existence or defunct. The country code and the year together would be the primary key. 
        After the table is created, you can filter all the countries based on current year and the existence of
        the country, then only collect data on those existing countries. 
*/