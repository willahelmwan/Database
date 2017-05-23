CREATE DATABASE  IF NOT EXISTS `starwarswanw` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `starwarswanw`;
-- MySQL dump 10.13  Distrib 5.7.18, for Win64 (x86_64)
--
-- Host: localhost    Database: starwarswanw
-- ------------------------------------------------------
-- Server version	5.7.18-log

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
  `char_name` varchar(50) NOT NULL,
  `char_race` varchar(50) DEFAULT NULL,
  `char_home` varchar(50) DEFAULT NULL,
  `char_affliliation` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`char_name`),
  KEY `characters_fk_planet` (`char_home`),
  CONSTRAINT `characters_fk_planet` FOREIGN KEY (`char_home`) REFERENCES `planets` (`planet_name`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `characters`
--

LOCK TABLES `characters` WRITE;
/*!40000 ALTER TABLE `characters` DISABLE KEYS */;
INSERT INTO `characters` VALUES ('C-3 PO','Droid',NULL,'rebels'),('Chewbacca','Wookie','Kashyyyk','rebels'),('Darth Vader','Human',NULL,'empire'),('Han Solo','Human','Corellia','rebels'),('Jabba the Hutt','Hutt',NULL,'neutral'),('Lando Calrissian','Human',NULL,'rebels'),('Luke Skywalker','Human','Tatooine','rebels'),('Obi-Wan Kanobi','Human','Tatooine','rebels'),('Owen Lars','Human','Tatooine','neutral'),('Princess Leia','Human','Alderaan','rebels'),('R2-D2','Droid',NULL,'rebels'),('Rancor','Rancor',NULL,'neutral'),('Yoda','Unknown',NULL,'neutral');
/*!40000 ALTER TABLE `characters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movies`
--

DROP TABLE IF EXISTS `movies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movies` (
  `movie_id` int(11) NOT NULL AUTO_INCREMENT,
  `movie_title` varchar(50) NOT NULL,
  `movie_scene_db` int(10) unsigned NOT NULL,
  `movie_scene` int(10) unsigned NOT NULL,
  PRIMARY KEY (`movie_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
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
  `planet_name` varchar(50) NOT NULL,
  `planet_type` varchar(50) DEFAULT NULL,
  `planet_affiliation` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`planet_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planets`
--

LOCK TABLES `planets` WRITE;
/*!40000 ALTER TABLE `planets` DISABLE KEYS */;
INSERT INTO `planets` VALUES ('Alderaan','temperate','rebels'),('Bespin','gas','neutral'),('Corellia','temperate','rebels'),('Dagobah','swamp','neutral'),('Death Star','artificial','empire'),('Endor','forest','neutral'),('Hoth','ice','rebels'),('Kashyyyk','forest','rebels'),('Star Destroyer','artificial','empire'),('Tatooine','desert','neutral');
/*!40000 ALTER TABLE `planets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timetable`
--

DROP TABLE IF EXISTS `timetable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `timetable` (
  `timetable_id` int(11) NOT NULL AUTO_INCREMENT,
  `char_name` varchar(50) NOT NULL,
  `planet_name` varchar(50) NOT NULL,
  `movie_id` int(11) NOT NULL,
  `time_arrival` int(10) unsigned NOT NULL,
  `time_departure` int(10) unsigned NOT NULL,
  PRIMARY KEY (`timetable_id`),
  KEY `timetable_fk_char` (`char_name`),
  KEY `timetable_fk_planet` (`planet_name`),
  KEY `timetable_fk_movie` (`movie_id`),
  CONSTRAINT `timetable_fk_char` FOREIGN KEY (`char_name`) REFERENCES `characters` (`char_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `timetable_fk_movie` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`movie_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `timetable_fk_planet` FOREIGN KEY (`planet_name`) REFERENCES `planets` (`planet_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timetable`
--

LOCK TABLES `timetable` WRITE;
/*!40000 ALTER TABLE `timetable` DISABLE KEYS */;
INSERT INTO `timetable` VALUES (1,'C-3 PO','Bespin',2,5,9),(2,'C-3 PO','Hoth',2,0,2),(3,'C-3 PO','Tatooine',1,0,2),(4,'C-3 PO','Tatooine',3,0,2),(5,'Chewbacca','Bespin',2,5,9),(6,'Chewbacca','Endor',3,5,10),(7,'Chewbacca','Hoth',2,0,2),(8,'Chewbacca','Tatooine',1,0,2),(9,'Chewbacca','Tatooine',3,0,2),(10,'Darth Vader','Bespin',2,5,10),(11,'Darth Vader','Death Star',1,9,10),(12,'Darth Vader','Death Star',3,1,9),(13,'Darth Vader','Hoth',2,3,4),(14,'Darth Vader','Star Destroyer',1,0,9),(15,'Han Solo','Bespin',2,5,9),(16,'Han Solo','Endor',3,5,10),(17,'Han Solo','Hoth',2,0,4),(18,'Han Solo','Star Destroyer',1,3,5),(19,'Han Solo','Tatooine',1,0,2),(20,'Han Solo','Tatooine',3,0,2),(21,'Jabba the Hutt','Tatooine',1,0,10),(22,'Jabba the Hutt','Tatooine',2,0,10),(23,'Jabba the Hutt','Tatooine',3,0,2),(24,'Lando Calrissian','Bespin',2,0,9),(25,'Lando Calrissian','Endor',3,9,10),(26,'Lando Calrissian','Tatooine',3,0,2),(27,'Luke Skywalker','Bespin',2,8,10),(28,'Luke Skywalker','Dagobah',2,4,8),(29,'Luke Skywalker','Dagobah',3,4,5),(30,'Luke Skywalker','Death Star',1,9,10),(31,'Luke Skywalker','Death Star',3,8,10),(32,'Luke Skywalker','Endor',3,5,8),(33,'Luke Skywalker','Hoth',2,0,2),(34,'Luke Skywalker','Star Destroyer',1,3,5),(35,'Luke Skywalker','Tatooine',1,0,2),(36,'Luke Skywalker','Tatooine',3,1,2),(37,'Obi-Wan Kanobi','Star Destroyer',1,3,5),(38,'Obi-Wan Kanobi','Tatooine',1,0,2),(39,'Owen Lars','Tatooine',1,0,1),(40,'Princess Leia','Bespin',2,5,9),(41,'Princess Leia','Endor',3,5,10),(42,'Princess Leia','Hoth',2,0,4),(43,'Princess Leia','Star Destroyer',1,1,5),(44,'Princess Leia','Tatooine',3,0,2),(45,'R2-D2','Bespin',2,8,10),(46,'R2-D2','Dagobah',2,4,8),(47,'R2-D2','Dagobah',3,4,5),(48,'R2-D2','Endor',3,5,8),(49,'R2-D2','Hoth',2,0,2),(50,'R2-D2','Tatooine',1,0,10),(51,'Rancor','Tatooine',1,0,10),(52,'Rancor','Tatooine',2,0,10),(53,'Rancor','Tatooine',3,0,3),(54,'Yoda','Dagobah',1,0,10),(55,'Yoda','Dagobah',2,0,10),(56,'Yoda','Dagobah',3,0,5);
/*!40000 ALTER TABLE `timetable` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger timetable_validate before insert on timetable
for each row
begin 
	select movie_scene_db into @mynum from movies where movie_id = new.movie_id;
	if (new.time_arrival > @mynum) or (new.time_departure > @mynum)
    then 
		signal sqlstate '45000' set message_text = 'bad scene';
	end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'starwarswanw'
--

--
-- Dumping routines for database 'starwarswanw'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-05-23 16:41:02
