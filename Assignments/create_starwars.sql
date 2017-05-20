-- *************************************************************
-- This script creates the starwar databases (starwarswanw)
-- by Willahelm Wan
-- *************************************************************

-- ********************************************
-- CREATE THE starwarswanw DATABASE
-- *******************************************

-- create the database
DROP DATABASE IF EXISTS starwarswanw;
CREATE DATABASE starwarswanw;

-- select the database
USE starwarswanw;

-- create the tables
CREATE TABLE planets
(
  planet_name                   varchar(50)            PRIMARY KEY,
  planet_type					varchar(50),
  planet_affiliation			varchar(50)
);

CREATE TABLE characters
(
  char_name       	varchar(50)            PRIMARY KEY,
  char_race   		varchar(50), 
  char_home			varchar(50),
  char_affliliation varchar(50),
  CONSTRAINT characters_fk_planet
    FOREIGN KEY (char_home)
    REFERENCES planets (planet_name)
);

CREATE TABLE movies
(
  movie_id              INT         	   PRIMARY KEY,
  movie_title     		varchar(50)		   NOT NULL,
  movie_scene_db        INT				   NOT NULL,
  movie_scene			INT   			   NOT NULL
);


CREATE TABLE timetable
(
  timetable_id			INT				PRIMARY KEY 	auto_increment,
  char_name				varchar(50)		not null,
  planet_name			varchar(50)		not null,
  movie_id				INT				not null,
  time_arrival			int				not null,
  time_departure		int				not null,
  CONSTRAINT timetable_fk_char
    FOREIGN KEY (char_name)
    REFERENCES characters (char_name),
  CONSTRAINT timetable_fk_planet
    FOREIGN KEY (planet_name)
    REFERENCES planets (planet_name), 
  CONSTRAINT timetable_fk_movie
    FOREIGN KEY (movie_id)
    REFERENCES movies (movie_id)
);
