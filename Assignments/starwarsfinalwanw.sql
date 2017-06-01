use starwarsfinalwanw;
/*
Question 1
The schema in starwarsfinalwanw is 99% the same compare to my original starwars
schema design. The only difference is that I did not specify the constraint on 
what the user can input the affiliation as. However, this does not cause any data 
integrity violations. 
*/

-- Question 2

-- Question 3 Assume the number of planets is the number of distinct planets.
select character_name, count(distinct planet_name) AS planet_count FROM timetable
GROUP by character_name;

-- Question 4
select planet_type, count(distinct character_name) as Num_of_characters 
	from planets, timetable
	where planets.planet_type = 'desert' 
		and timetable.planet_name = (select planet_name from planets where planet_type = 'desert');

-- Question 5 assume the number of characters is the number of distinct characters
select planet_name, count(distinct character_name) as character_count from timetable
	group by planet_name
    order by character_count desc
    limit 1;


select * from timetable;
select * from planets;
-- Question 6
select planet_name, count(distinct character_name) as character_count from timetable
	where character_count = 11;
    
-- Question 7
drop table if exists Movie1Timings;
create table Movie1Timings
	select *
      from timetable
		where movie_id = 1; 
select * from movie1timings;

-- Question 8



