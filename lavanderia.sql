-- MySQL dump 10.13  Distrib 8.0.16, for Win64 (x86_64)
--
-- Host: localhost    Database: lavanderia
-- ------------------------------------------------------
-- Server version	8.0.16

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `inquilino`
--

DROP TABLE IF EXISTS `inquilino`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `inquilino` (
  `identificacion` varchar(30) NOT NULL,
  `nombres` varchar(20) NOT NULL,
  `apartamento` int(11) NOT NULL,
  PRIMARY KEY (`identificacion`,`apartamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inquilino`
--

LOCK TABLES `inquilino` WRITE;
/*!40000 ALTER TABLE `inquilino` DISABLE KEYS */;
INSERT INTO `inquilino` VALUES ('4567886','Ana Reyes',509),('49596596','Luis Burgo',508),('50769192','Jorge Gonzales',506),('50769192','Jorge Gonzales',507),('9508151253','Sara Lopez',506);
/*!40000 ALTER TABLE `inquilino` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lavadoras`
--

DROP TABLE IF EXISTS `lavadoras`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `lavadoras` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(250) NOT NULL,
  `tipo` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lavadoras`
--

LOCK TABLES `lavadoras` WRITE;
/*!40000 ALTER TABLE `lavadoras` DISABLE KEYS */;
INSERT INTO `lavadoras` VALUES (1,'lavadora 1',1),(2,'lavadora 2',1),(3,'lavadora 3',1),(4,'secadora 1',2),(5,'secadora 2',2);
/*!40000 ALTER TABLE `lavadoras` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservas`
--

DROP TABLE IF EXISTS `reservas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `reservas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hora` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `lavadora` int(11) DEFAULT NULL,
  `inquilino` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lavadora` (`lavadora`),
  KEY `inquilino` (`inquilino`),
  CONSTRAINT `reservas_ibfk_1` FOREIGN KEY (`lavadora`) REFERENCES `lavadoras` (`id`),
  CONSTRAINT `reservas_ibfk_2` FOREIGN KEY (`inquilino`) REFERENCES `inquilino` (`identificacion`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservas`
--

LOCK TABLES `reservas` WRITE;
/*!40000 ALTER TABLE `reservas` DISABLE KEYS */;
INSERT INTO `reservas` VALUES (3,'2020-11-22 17:34:49',1,'50769192'),(5,'2020-11-22 17:36:30',2,'9508151253');
/*!40000 ALTER TABLE `reservas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servicios`
--

DROP TABLE IF EXISTS `servicios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `servicios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hora_inicial` timestamp NULL DEFAULT NULL,
  `estado` tinyint(1) DEFAULT NULL,
  `reserva` int(11) DEFAULT NULL,
  `inquilino` varchar(30) DEFAULT NULL,
  `hora_final` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `reserva` (`reserva`),
  KEY `inquilino` (`inquilino`),
  CONSTRAINT `servicios_ibfk_1` FOREIGN KEY (`reserva`) REFERENCES `reservas` (`id`),
  CONSTRAINT `servicios_ibfk_2` FOREIGN KEY (`inquilino`) REFERENCES `inquilino` (`identificacion`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicios`
--

LOCK TABLES `servicios` WRITE;
/*!40000 ALTER TABLE `servicios` DISABLE KEYS */;
INSERT INTO `servicios` VALUES (2,'2020-11-22 17:45:00',1,5,NULL,'2020-11-22 18:45:00'),(3,'2020-11-22 17:48:00',1,3,NULL,'2020-11-22 18:48:00');
/*!40000 ALTER TABLE `servicios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-11-23 16:07:18
