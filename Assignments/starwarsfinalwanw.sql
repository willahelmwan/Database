-- Created by Willahelm Wan
use starwarsfinalwanw;
/*
-- Question 1
The schema in starwarsfinalwanw is 99% the same compare to my original starwars
schema design. The only difference is that I did not specify the constraint on 
what the user can input the affiliation as. However, this does not cause any data 
integrity violations. 
*/

-- Question 2
select timetable.character_name, timetable.planet_name, movies.title, 
	sum(timetable.departure - timetable.arrival) as screen_time
	from timetable
		join movies on movies.movie_id = timetable.movie_id
			group by timetable.character_name, timetable.planet_name, timetable.movie_id;

-- Question 3 Assume the number of planets is the number of distinct planets.
select character_name, count(distinct planet_name) as planet_count from timetable
	group by character_name;

-- Question 4
select planet_type, count(distinct character_name) as Num_of_characters 
	from planets, timetable
	where planets.planet_type = 'desert' 
		and (select planet_type from planets 
				where planet_name = timetable.planet_name) = 'desert';

-- Question 5 assume the number of characters is the number of distinct characters
select planet_name, count(distinct character_name) as character_count from timetable
	group by planet_name
    order by character_count desc
    limit 1;

-- Question 6 
select ifnull(
	(select count(distinct character_name) as character_count 
		from timetable
		group by planet_name
		having character_count = (select count(character_name) from characters)),
			convert('none' using utf8)) 
            as Planet_has_been_visited_by_all_characters;

-- Question 7
drop table if exists Movie1Timings;
create table Movie1Timings
	select *
      from timetable
		where movie_id = 1; 
select * from movie1timings;

-- Question 8
select title from
(select timetable.character_name, timetable.planet_name, movies.title, 
	sum(timetable.departure - timetable.arrival) as screen_time
	from timetable
		join movies on movies.movie_id = timetable.movie_id
			group by timetable.character_name, timetable.movie_id) y
where character_name = 'Lando Calrissian'
order by screen_time desc
limit 1;

select * from timetable;
select * from planets;
select * from characters;
select * from movies;
-- Question 9
select planet_name, group_concat(distinct character_name separator ', ') 
	as characters
	from timetable
    group by planet_name;

-- Question 10
select planet_type from 
(select timetable.character_name, planets.planet_type, timetable.movie_id from timetable
	join planets on planets.planet_name = timetable.planet_name
					and timetable.movie_id = 2) x
    group by planet_type
    order by count(distinct character_name)
    limit 1;

-- Question 11
select affiliation, count(character_name) as character_count from characters
	where affiliation = 'rebels'; 

-- Question 12
select character_name from characters where affiliation = 'rebels';
drop table if exists RebelsinMovie1Timings;
create table RebelsinMovie1Timings
	select *
		from timetable
			where movie_id = 1 
				and (select affiliation from characters
						where character_name = timetable.character_name) = 'rebels';
select * from RebelsinMovie1Timings;

-- Question 13
select character_name from characters
	where affiliation = (select affiliation from planets 
							where planet_name = characters.homeworld);
