CREATE DATABASE  IF NOT EXISTS `bp` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `bp`;
-- MySQL dump 10.13  Distrib 5.7.18, for Win64 (x86_64)
--
-- Host: localhost    Database: bp
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
-- Table structure for table `authors`
--

DROP TABLE IF EXISTS `authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `authors` (
  `author_id` int(11) NOT NULL AUTO_INCREMENT,
  `author_name` varchar(64) NOT NULL,
  `author_affiliation` varchar(64) NOT NULL,
  `author_email` varchar(64) NOT NULL,
  `author_post` int(11) NOT NULL,
  PRIMARY KEY (`author_id`),
  KEY `author_post_fk` (`author_post`),
  CONSTRAINT `author_post_fk` FOREIGN KEY (`author_post`) REFERENCES `blogposts` (`post_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authors`
--

LOCK TABLES `authors` WRITE;
/*!40000 ALTER TABLE `authors` DISABLE KEYS */;
/*!40000 ALTER TABLE `authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blogposts`
--

DROP TABLE IF EXISTS `blogposts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blogposts` (
  `post_id` int(11) NOT NULL AUTO_INCREMENT,
  `post_title` varchar(64) NOT NULL,
  `post_text` varchar(1000) NOT NULL,
  `post_date` date NOT NULL,
  PRIMARY KEY (`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blogposts`
--

LOCK TABLES `blogposts` WRITE;
/*!40000 ALTER TABLE `blogposts` DISABLE KEYS */;
/*!40000 ALTER TABLE `blogposts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `comment_creater` int(11) NOT NULL,
  `comment_date` date NOT NULL,
  `comment_text` varchar(1000) NOT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `comment_creater_fk` (`comment_creater`),
  CONSTRAINT `comment_creater_fk` FOREIGN KEY (`comment_creater`) REFERENCES `readers` (`reader_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `instances`
--

DROP TABLE IF EXISTS `instances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instances` (
  `instance_id` int(11) NOT NULL AUTO_INCREMENT,
  `instance_position` int(11) NOT NULL,
  `instance_post` int(11) DEFAULT NULL,
  `instance_comment` int(11) DEFAULT NULL,
  `instance_phrase` varchar(64) NOT NULL,
  PRIMARY KEY (`instance_id`),
  KEY `instance_phrase_fk` (`instance_phrase`),
  KEY `instance_post_fk` (`instance_post`),
  KEY `instance_comment_fk` (`instance_comment`),
  CONSTRAINT `instance_comment_fk` FOREIGN KEY (`instance_comment`) REFERENCES `comments` (`comment_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `instance_phrase_fk` FOREIGN KEY (`instance_phrase`) REFERENCES `key_phrases` (`key_phrase`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `instance_post_fk` FOREIGN KEY (`instance_post`) REFERENCES `blogposts` (`post_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instances`
--

LOCK TABLES `instances` WRITE;
/*!40000 ALTER TABLE `instances` DISABLE KEYS */;
/*!40000 ALTER TABLE `instances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `key_phrases`
--

DROP TABLE IF EXISTS `key_phrases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `key_phrases` (
  `key_phrase` varchar(64) NOT NULL,
  `key_topic` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`key_phrase`),
  KEY `key_topic_fk` (`key_topic`),
  CONSTRAINT `key_topic_fk` FOREIGN KEY (`key_topic`) REFERENCES `political_topics` (`political_topic`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `key_phrases`
--

LOCK TABLES `key_phrases` WRITE;
/*!40000 ALTER TABLE `key_phrases` DISABLE KEYS */;
/*!40000 ALTER TABLE `key_phrases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `political_topics`
--

DROP TABLE IF EXISTS `political_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `political_topics` (
  `political_topic` varchar(64) NOT NULL,
  PRIMARY KEY (`political_topic`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `political_topics`
--

LOCK TABLES `political_topics` WRITE;
/*!40000 ALTER TABLE `political_topics` DISABLE KEYS */;
/*!40000 ALTER TABLE `political_topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `readers`
--

DROP TABLE IF EXISTS `readers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `readers` (
  `reader_id` int(11) NOT NULL AUTO_INCREMENT,
  `reader_name` varchar(64) NOT NULL,
  `reader_email` varchar(64) NOT NULL,
  `reader_post` int(11) NOT NULL,
  PRIMARY KEY (`reader_id`),
  KEY `reader_post_fk` (`reader_post`),
  CONSTRAINT `reader_post_fk` FOREIGN KEY (`reader_post`) REFERENCES `blogposts` (`post_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `readers`
--

LOCK TABLES `readers` WRITE;
/*!40000 ALTER TABLE `readers` DISABLE KEYS */;
/*!40000 ALTER TABLE `readers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'bp'
--

--
-- Dumping routines for database 'bp'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-05-30 13:20:19
