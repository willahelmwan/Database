use starwarsfinalwanw;

/*1.	Write a procedure track_character(character)  that accepts a character name 
		and returns a result set that contains a list of the movie scenes the 
        character is in.  For each movie, track the total number of scenes and the 
        planet where the character appears. The result set should contain the 
        character’s name, the planet name, the movie name, and the sum of the movie 
        scene length for that specific planet in that movie for that character. */
        
DROP PROCEDURE IF EXISTS track_character;

DELIMITER //

CREATE PROCEDURE track_character(character1 varchar(45))

BEGIN

if character1 in (select character_name from characters) then
  select timetable.character_name, timetable.planet_name, movies.title, 
	sum(timetable.departure - timetable.arrival) as screen_time
	from timetable
		join movies on movies.movie_id = timetable.movie_id
			group by timetable.character_name, timetable.planet_name, timetable.movie_id
            having timetable.character_name = character1;
else
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Please enter a valid character name.';
end if;
END//

DELIMITER ;

-- Test cases:
-- call track_character('Han Solo');
-- call track_character(1); -- This will throw an error asking the user to enter a valid
						 -- character name. 

/*2.	Write a procedure track_planet(planet)  that accepts a planet name and 
		returns a result set that contain the planet name, the movie name, and 
        the number of characters that appear on that planet during that movie. */

DROP PROCEDURE IF EXISTS track_planet;

DELIMITER //

CREATE PROCEDURE track_planet(planet varchar(45))

BEGIN
if planet in (select planet_name from planets) then
	select timetable.planet_name, movies.title, count(distinct timetable.character_name) as num_of_characters
		from timetable
			join movies on timetable.movie_id = movies.movie_id
			group by planet_name, movies.title
			having planet_name = planet;
else
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Please enter a valid planet name.';
end if;
  
END//

DELIMITER ;

-- Test cases:
-- call track_planet('Death Star');
-- call track_planet('hi'); -- This will throw an error asking the user to enter a valid planet name. 


/*3.	Write a function named planet_hopping(character). It accepts a character 
		name and returns the number of planets the character has appeared on. */

DROP FUNCTION IF EXISTS planet_hopping;

DELIMITER //

CREATE FUNCTION planet_hopping (character1 varchar(45))
returns int
BEGIN
  DECLARE number_appeared INT;
  
  SELECT count(distinct planet_name)
  INTO number_appeared
  FROM timetable
  WHERE character_name = character1;
  
  RETURN(number_appeared);
END//

DELIMITER ;

-- Test Cases:
-- select planet_hopping('Han Solo') as number_of_planets;

/*4.	Write a function named planet_most_visited(character) that accepts a character 
		name and returns the name of the planet where the character appeared the most 
        ( as measured in scene counts). */

DROP FUNCTION IF EXISTS planet_most_visited;

DELIMITER //

CREATE FUNCTION planet_most_visited (character1 varchar(45))
returns varchar(45)
BEGIN
  DECLARE visited_planet_name varchar(45);
  
  select planet_name
  into visited_planet_name
  from timetable
  group by character_name, planet_name
  having character_name = character1
  order by sum(departure-arrival) desc limit 1;
  
  RETURN(visited_planet_name);
END//

DELIMITER ;

select * from timetable;
-- Test cases:
-- select planet_most_visited('Han Solo');
-- select planet_most_visited('Luke Skywalker');

/*5.	Write a function named home_affiliation_same(character) that accepts a character 
		name and returns TRUE if the character has the same affiliation as his home planet,
        FALSE if the character has a different affiliation than his home planet or NULL if 
        the home planet or the affiliation is not known. */

DROP FUNCTION IF EXISTS home_affiliation_same;

DELIMITER //

CREATE FUNCTION home_affiliation_same (character1 varchar(45))
returns varchar(45)
BEGIN
  declare affiliation_same varchar(45);
  declare char_affiliation varchar(45);
  declare char_home varchar(45);
  declare planet_affiliation varchar(45);
  
  select affiliation 
  into char_affiliation
  from characters
  where character_name = character1;
  
  select homeworld
  into char_home
  from characters
  where character_name = character1;
  
  select affiliation
  into planet_affiliation
  from planets
  where planet_name = char_home;
  
  if (char_home = 'Unknown' or planet_affiliation = 'Unknown' or char_affiliation = 'Unknown') then
	select null into affiliation_same;
  else 
	  if char_affiliation = planet_affiliation then
		select 'TRUE' into affiliation_same;
	  else
		select 'FALSE' into affiliation_same;
	  end if;
  end if;

  return(affiliation_same);
end//
DELIMITER ;

-- Test cases:
-- select home_affiliation_same('Chewbacca'); -- Should return TRUE
-- select home_affiliation_same('C-3 PO'); -- Should return null
-- select home_affiliation_same('Luke Skywalker'); -- Should return FALSE

/*6.	Write a function named planet_in_num_movies that accepts a planet’s name as an 
		argument and returns the number of movies that the planet appeared in. */

DROP FUNCTION IF EXISTS planet_in_num_movies;

DELIMITER //

CREATE FUNCTION planet_in_num_movies (planet varchar(45))
returns int
BEGIN
	declare num_of_movies int;
    
    select count(distinct movie_id) 
    into num_of_movies 
    from timetable 
	group by planet_name 
    having planet_name = planet;
  

	return(num_of_movies);
end//
DELIMITER ;

-- Test cases:
-- select planet_in_num_movies('Endor'); -- should return 3.
-- select planet_in_num_movies('T'); -- should return null. 

/*7.	Write a procedure  named character_with_affiliation(affiliation) that accepts 
		an affiliation and returns the character records  (all fields associated with 
		the character) with that affiliation. */
        
DROP PROCEDURE IF EXISTS character_with_affiliation;

DELIMITER //

CREATE PROCEDURE character_with_affiliation(char_affiliation varchar(45))

BEGIN
if char_affiliation in (select affiliation from characters) then
	select * from characters where affiliation = char_affiliation;
else
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Please enter rebels, neutral, or empire.';
end if;
  
END//

DELIMITER ;

-- Test cases:
-- call character_with_affiliation('rebels'); 



/*8.	Write a trigger that updates the field scenes_in_db for the movie records in 
		the Movies table. The field should contain the maximum scene number found in the 
        timetable table for that movie.  Call the trigger timetable_after_insert. Insert 
        the following records into the database.  Insert records into the timetable table 
        that places 'Chewbacca’, and ‘Princess Leia’ on 'Endor' in scenes 11 through 12 
        for movie 3. Ensure that the scenesinDB is properly updated for this data. */
        
DROP TRIGGER IF EXISTS timetable_after_insert;

DELIMITER //

CREATE TRIGGER timetable_after_insert
  after insert on timetable
  for each row 
BEGIN 
  update movies
  set scenes_in_db = (select max(departure) from timetable where movie_id = new.movie_id)
  WHERE movie_id = new.movie_id;
END//

DELIMITER ;

insert into timetable(character_name, planet_name, movie_id, arrival, departure) values
		('Chewbacca', 'Endor', 3, 11, 12);
insert into timetable(character_name, planet_name, movie_id, arrival, departure) values
		('Princess Leia', 'Endor', 3, 11, 12);



/*9.	Create and execute a prepared statement from the SQL workbench that calls 
		track_character with the argument ‘Princess Leia’. Use a user session variable 
        to pass the argument to the function. */

set @b := "Princess Leia";
set @s := "call track_character(?)";
prepare stmt from @s;
execute stmt using @b;
deallocate prepare stmt;



/*10.	Create and execute a prepared statement that calls planet_in_num_movies() with the 
		argument ‘Bespin’. Once again use a user session variable to pass the argument to 
		the function. */

set @a := "Bespin";
set @s1 := "select planet_in_num_movies(?)";
prepare stmt1 from @s1;
execute stmt1 using @a;
deallocate prepare stmt1;


        

