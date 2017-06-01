-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 31, 2017 at 06:09 PM
-- Server version: 10.1.21-MariaDB
-- PHP Version: 7.1.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `starwarsfinalwanw`
--

-- --------------------------------------------------------

--
-- Table structure for table `characters`
--

CREATE TABLE `characters` (
  `character_name` varchar(45) NOT NULL,
  `race` varchar(45) DEFAULT NULL,
  `homeworld` varchar(45) DEFAULT 'Unknown',
  `affiliation` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `characters`
--

INSERT INTO `characters` (`character_name`, `race`, `homeworld`, `affiliation`) VALUES
('C-3 PO', 'Droid', 'Unknown', 'rebels'),
('Chewbacca', 'Wookie', 'Kashyyyk', 'rebels'),
('Darth Vader', 'Human', 'Unknown', 'empire'),
('Han Solo', 'Human', 'Corellia', 'rebels'),
('Jabba the Hutt', 'Hutt', 'Unknown', 'neutral'),
('Lando Calrissian', 'Human', 'Unknown', 'rebels'),
('Luke Skywalker', 'Human', 'Tatooine', 'rebels'),
('Obi-Wan Kanobi', 'Human', 'Tatooine', 'rebels'),
('Owen Lars', 'Human', 'Tatooine', 'neutral'),
('Princess Leia', 'Human', 'Alderaan', 'rebels'),
('R2-D2', 'Droid', 'Unknown', 'rebels'),
('Rancor', 'Rancor', 'Unknown', 'neutral'),
('Yoda', 'Unknown', 'Unknown', 'neutral');

-- --------------------------------------------------------

--
-- Table structure for table `movies`
--

CREATE TABLE `movies` (
  `movie_id` int(11) NOT NULL,
  `title` varchar(128) DEFAULT NULL,
  `scenes_in_db` int(11) DEFAULT NULL,
  `scenes_in_movies` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `movies`
--

INSERT INTO `movies` (`movie_id`, `title`, `scenes_in_db`, `scenes_in_movies`) VALUES
(1, 'Episode IV: A New Hope', 10, 13),
(2, 'Episode V: The Empire Strikes Back', 10, 17),
(3, 'Episode VI: Return of the Jedi', 10, 15);

-- --------------------------------------------------------

--
-- Table structure for table `planets`
--

CREATE TABLE `planets` (
  `planet_name` varchar(45) NOT NULL,
  `planet_type` varchar(30) DEFAULT NULL,
  `affiliation` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `planets`
--

INSERT INTO `planets` (`planet_name`, `planet_type`, `affiliation`) VALUES
('Alderaan', 'temperate', 'rebels'),
('Bespin', 'gas', 'neutral'),
('Corellia', 'temperate', 'rebels'),
('Dagobah', 'swamp', 'neutral'),
('Death Star', 'artificial', 'empire'),
('Endor', 'forest', 'neutral'),
('Hoth', 'ice', 'rebels'),
('Kashyyyk', 'forest', 'rebels'),
('Star Destroyer', 'artificial', 'empire'),
('Tatooine', 'desert', 'neutral'),
('Unknown', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `timetable`
--

CREATE TABLE `timetable` (
  `character_name` varchar(45) DEFAULT NULL,
  `planet_name` varchar(45) DEFAULT 'Unknown',
  `movie_id` int(11) DEFAULT NULL,
  `arrival` int(11) DEFAULT NULL,
  `departure` int(11) DEFAULT NULL,
  `time_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `timetable`
--

INSERT INTO `timetable` (`character_name`, `planet_name`, `movie_id`, `arrival`, `departure`, `time_id`) VALUES
('C-3 PO', 'Bespin', 2, 5, 9, 1),
('C-3 PO', 'Hoth', 2, 0, 2, 2),
('C-3 PO', 'Tatooine', 1, 0, 2, 3),
('C-3 PO', 'Tatooine', 3, 0, 2, 4),
('Chewbacca', 'Bespin', 2, 5, 9, 5),
('Chewbacca', 'Endor', 3, 5, 10, 6),
('Chewbacca', 'Hoth', 2, 0, 2, 7),
('Chewbacca', 'Tatooine', 1, 0, 2, 8),
('Chewbacca', 'Tatooine', 3, 0, 2, 9),
('Darth Vader', 'Bespin', 2, 5, 10, 10),
('Darth Vader', 'Death Star', 1, 9, 10, 11),
('Darth Vader', 'Death Star', 3, 1, 9, 12),
('Darth Vader', 'Hoth', 2, 3, 4, 13),
('Darth Vader', 'Star Destroyer', 1, 0, 9, 14),
('Han Solo', 'Bespin', 2, 5, 9, 15),
('Han Solo', 'Endor', 3, 5, 10, 16),
('Han Solo', 'Hoth', 2, 0, 4, 17),
('Han Solo', 'Star Destroyer', 1, 3, 5, 18),
('Han Solo', 'Tatooine', 1, 0, 2, 19),
('Han Solo', 'Tatooine', 3, 0, 2, 20),
('Jabba the Hutt', 'Tatooine', 1, 0, 10, 21),
('Jabba the Hutt', 'Tatooine', 2, 0, 10, 22),
('Jabba the Hutt', 'Tatooine', 3, 0, 2, 23),
('Lando Calrissian', 'Bespin', 2, 0, 9, 24),
('Lando Calrissian', 'Endor', 3, 9, 10, 25),
('Lando Calrissian', 'Tatooine', 3, 0, 2, 26),
('Luke Skywalker', 'Bespin', 2, 8, 10, 27),
('Luke Skywalker', 'Dagobah', 2, 4, 8, 28),
('Luke Skywalker', 'Dagobah', 3, 4, 5, 29),
('Luke Skywalker', 'Death Star', 1, 9, 10, 30),
('Luke Skywalker', 'Death Star', 3, 8, 10, 31),
('Luke Skywalker', 'Endor', 3, 5, 8, 32),
('Luke Skywalker', 'Hoth', 2, 0, 2, 33),
('Luke Skywalker', 'Star Destroyer', 1, 3, 5, 34),
('Luke Skywalker', 'Tatooine', 1, 0, 2, 35),
('Luke Skywalker', 'Tatooine', 3, 1, 2, 36),
('Obi-Wan Kanobi', 'Star Destroyer', 1, 3, 5, 37),
('Obi-Wan Kanobi', 'Tatooine', 1, 0, 2, 38),
('Owen Lars', 'Tatooine', 1, 0, 1, 39),
('Princess Leia', 'Bespin', 2, 5, 9, 40),
('Princess Leia', 'Endor', 3, 5, 10, 41),
('Princess Leia', 'Hoth', 2, 0, 4, 42),
('Princess Leia', 'Star Destroyer', 1, 1, 5, 43),
('Princess Leia', 'Tatooine', 3, 0, 2, 44),
('R2-D2', 'Bespin', 2, 8, 10, 45),
('R2-D2', 'Dagobah', 2, 4, 8, 46),
('R2-D2', 'Dagobah', 3, 4, 5, 47),
('R2-D2', 'Endor', 3, 5, 8, 48),
('R2-D2', 'Hoth', 2, 0, 2, 49),
('R2-D2', 'Tatooine', 1, 0, 10, 50),
('Rancor', 'Tatooine', 1, 0, 10, 51),
('Rancor', 'Tatooine', 2, 0, 10, 52),
('Rancor', 'Tatooine', 3, 0, 3, 53),
('Yoda', 'Dagobah', 1, 0, 10, 54),
('Yoda', 'Dagobah', 2, 0, 10, 55),
('Yoda', 'Dagobah', 3, 0, 5, 56);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `characters`
--
ALTER TABLE `characters`
  ADD PRIMARY KEY (`character_name`),
  ADD KEY `planet_fk` (`homeworld`);

--
-- Indexes for table `movies`
--
ALTER TABLE `movies`
  ADD PRIMARY KEY (`movie_id`);

--
-- Indexes for table `planets`
--
ALTER TABLE `planets`
  ADD PRIMARY KEY (`planet_name`);

--
-- Indexes for table `timetable`
--
ALTER TABLE `timetable`
  ADD PRIMARY KEY (`time_id`),
  ADD UNIQUE KEY `timetable_un` (`character_name`,`planet_name`,`movie_id`,`arrival`),
  ADD KEY `timetable_fkplanet` (`planet_name`),
  ADD KEY `timetable_fkmovie` (`movie_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `timetable`
--
ALTER TABLE `timetable`
  MODIFY `time_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `characters`
--
ALTER TABLE `characters`
  ADD CONSTRAINT `planet_fk` FOREIGN KEY (`homeworld`) REFERENCES `planets` (`planet_name`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `timetable`
--
ALTER TABLE `timetable`
  ADD CONSTRAINT `timetable_fkcharacter` FOREIGN KEY (`character_name`) REFERENCES `characters` (`character_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `timetable_fkmovie` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `timetable_fkplanet` FOREIGN KEY (`planet_name`) REFERENCES `planets` (`planet_name`) ON DELETE SET NULL ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
