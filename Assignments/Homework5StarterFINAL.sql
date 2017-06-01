CREATE DATABASE  IF NOT EXISTS `starwarsFINALwanw` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `starwarsFINALwanw`;
-- MySQL dump 10.13  Distrib 5.7.9, for Win32 (AMD64)
--
-- Host: 127.0.0.1    Database: starwars
-- ------------------------------------------------------
-- Server version	5.7.9-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `characters`
--

DROP TABLE IF EXISTS `characters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `characters` (
  `character_name` varchar(45) NOT NULL,
  `race` varchar(45) DEFAULT NULL,
  `homeworld` varchar(45) DEFAULT 'Unknown',
  `affiliation` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`character_name`),
  KEY `planet_fk` (`homeworld`),
  CONSTRAINT `planet_fk` FOREIGN KEY (`homeworld`) REFERENCES `planets` (`planet_name`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `characters`
--

LOCK TABLES `characters` WRITE;
/*!40000 ALTER TABLE `characters` DISABLE KEYS */;
INSERT INTO `characters` VALUES ('C-3 PO','Droid','Unknown','rebels'),('Chewbacca','Wookie','Kashyyyk','rebels'),('Darth Vader','Human','Unknown','empire'),('Han Solo','Human','Corellia','rebels'),('Jabba the Hutt','Hutt','Unknown','neutral'),('Lando Calrissian','Human','Unknown','rebels'),('Luke Skywalker','Human','Tatooine','rebels'),('Obi-Wan Kanobi','Human','Tatooine','rebels'),('Owen Lars','Human','Tatooine','neutral'),('Princess Leia','Human','Alderaan','rebels'),('R2-D2','Droid','Unknown','rebels'),('Rancor','Rancor','Unknown','neutral'),('Yoda','Unknown','Unknown','neutral');
/*!40000 ALTER TABLE `characters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movies`
--

DROP TABLE IF EXISTS `movies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movies` (
  `movie_id` int(11) NOT NULL,
  `title` varchar(128) DEFAULT NULL,
  `scenes_in_db` int(11) DEFAULT NULL,
  `scenes_in_movies` int(11) DEFAULT NULL,
  PRIMARY KEY (`movie_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movies`
--

LOCK TABLES `movies` WRITE;
/*!40000 ALTER TABLE `movies` DISABLE KEYS */;
INSERT INTO `movies` VALUES (1,'Episode IV: A New Hope',10,13),(2,'Episode V: The Empire Strikes Back',10,17),(3,'Episode VI: Return of the Jedi',10,15);
/*!40000 ALTER TABLE `movies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planets`
--

DROP TABLE IF EXISTS `planets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `planets` (
  `planet_name` varchar(45) NOT NULL,
  `planet_type` varchar(30) DEFAULT NULL,
  `affiliation` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`planet_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planets`
--

LOCK TABLES `planets` WRITE;
/*!40000 ALTER TABLE `planets` DISABLE KEYS */;
INSERT INTO `planets` VALUES ('Alderaan','temperate','rebels'),('Bespin','gas','neutral'),('Corellia','temperate','rebels'),('Dagobah','swamp','neutral'),('Death Star','artificial','empire'),('Endor','forest','neutral'),('Hoth','ice','rebels'),('Kashyyyk','forest','rebels'),('Star Destroyer','artificial','empire'),('Tatooine','desert','neutral'),('Unknown','','');
/*!40000 ALTER TABLE `planets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timetable`
--

DROP TABLE IF EXISTS `timetable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `timetable` (
  `character_name` varchar(45) DEFAULT NULL,
  `planet_name` varchar(45) DEFAULT 'Unknown',
  `movie_id` int(11) DEFAULT NULL,
  `arrival` int(11) DEFAULT NULL,
  `departure` int(11) DEFAULT NULL,
  `time_id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`time_id`),
  UNIQUE KEY `timetable_un` (`character_name`,`planet_name`,`movie_id`,`arrival`),
  KEY `timetable_fkplanet` (`planet_name`),
  KEY `timetable_fkmovie` (`movie_id`),
  CONSTRAINT `timetable_fkcharacter` FOREIGN KEY (`character_name`) REFERENCES `characters` (`character_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `timetable_fkmovie` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `timetable_fkplanet` FOREIGN KEY (`planet_name`) REFERENCES `planets` (`planet_name`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timetable`
--

LOCK TABLES `timetable` WRITE;
/*!40000 ALTER TABLE `timetable` DISABLE KEYS */;
INSERT INTO `timetable` VALUES ('C-3 PO','Bespin',2,5,9,1),('C-3 PO','Hoth',2,0,2,2),('C-3 PO','Tatooine',1,0,2,3),('C-3 PO','Tatooine',3,0,2,4),('Chewbacca','Bespin',2,5,9,5),('Chewbacca','Endor',3,5,10,6),('Chewbacca','Hoth',2,0,2,7),('Chewbacca','Tatooine',1,0,2,8),('Chewbacca','Tatooine',3,0,2,9),('Darth Vader','Bespin',2,5,10,10),('Darth Vader','Death Star',1,9,10,11),('Darth Vader','Death Star',3,1,9,12),('Darth Vader','Hoth',2,3,4,13),('Darth Vader','Star Destroyer',1,0,9,14),('Han Solo','Bespin',2,5,9,15),('Han Solo','Endor',3,5,10,16),('Han Solo','Hoth',2,0,4,17),('Han Solo','Star Destroyer',1,3,5,18),('Han Solo','Tatooine',1,0,2,19),('Han Solo','Tatooine',3,0,2,20),('Jabba the Hutt','Tatooine',1,0,10,21),('Jabba the Hutt','Tatooine',2,0,10,22),('Jabba the Hutt','Tatooine',3,0,2,23),('Lando Calrissian','Bespin',2,0,9,24),('Lando Calrissian','Endor',3,9,10,25),('Lando Calrissian','Tatooine',3,0,2,26),('Luke Skywalker','Bespin',2,8,10,27),('Luke Skywalker','Dagobah',2,4,8,28),('Luke Skywalker','Dagobah',3,4,5,29),('Luke Skywalker','Death Star',1,9,10,30),('Luke Skywalker','Death Star',3,8,10,31),('Luke Skywalker','Endor',3,5,8,32),('Luke Skywalker','Hoth',2,0,2,33),('Luke Skywalker','Star Destroyer',1,3,5,34),('Luke Skywalker','Tatooine',1,0,2,35),('Luke Skywalker','Tatooine',3,1,2,36),('Obi-Wan Kanobi','Star Destroyer',1,3,5,37),('Obi-Wan Kanobi','Tatooine',1,0,2,38),('Owen Lars','Tatooine',1,0,1,39),('Princess Leia','Bespin',2,5,9,40),('Princess Leia','Endor',3,5,10,41),('Princess Leia','Hoth',2,0,4,42),('Princess Leia','Star Destroyer',1,1,5,43),('Princess Leia','Tatooine',3,0,2,44),('R2-D2','Bespin',2,8,10,45),('R2-D2','Dagobah',2,4,8,46),('R2-D2','Dagobah',3,4,5,47),('R2-D2','Endor',3,5,8,48),('R2-D2','Hoth',2,0,2,49),('R2-D2','Tatooine',1,0,10,50),('Rancor','Tatooine',1,0,10,51),('Rancor','Tatooine',2,0,10,52),('Rancor','Tatooine',3,0,3,53),('Yoda','Dagobah',1,0,10,54),('Yoda','Dagobah',2,0,10,55),('Yoda','Dagobah',3,0,5,56);
/*!40000 ALTER TABLE `timetable` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-10-27 16:03:00
