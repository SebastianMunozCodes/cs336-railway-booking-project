-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: localhost    Database: railway_booking
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'e577a464-4813-11f1-9bc7-a8ad6b111536:1-180';

--
-- Table structure for table `Customer`
--

DROP TABLE IF EXISTS `Customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Customer` (
  `Username` varchar(80) NOT NULL,
  `Password` varchar(80) NOT NULL,
  `FirstName` varchar(80) NOT NULL,
  `LastName` varchar(80) NOT NULL,
  `Email` varchar(100) NOT NULL,
  PRIMARY KEY (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CustomerQuestion`
--

DROP TABLE IF EXISTS `CustomerQuestion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CustomerQuestion` (
  `QuestionID` int NOT NULL AUTO_INCREMENT,
  `QuestionText` text NOT NULL,
  `QuestionDateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Username` varchar(80) NOT NULL,
  PRIMARY KEY (`QuestionID`),
  KEY `Username` (`Username`),
  CONSTRAINT `customerquestion_ibfk_1` FOREIGN KEY (`Username`) REFERENCES `Customer` (`Username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CustomerReply`
--

DROP TABLE IF EXISTS `CustomerReply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CustomerReply` (
  `ReplyID` int NOT NULL AUTO_INCREMENT,
  `ReplyText` text NOT NULL,
  `ReplyDateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `QuestionID` int NOT NULL,
  `EmployeeSSN` char(9) NOT NULL,
  PRIMARY KEY (`ReplyID`),
  KEY `QuestionID` (`QuestionID`),
  KEY `EmployeeSSN` (`EmployeeSSN`),
  CONSTRAINT `customerreply_ibfk_1` FOREIGN KEY (`QuestionID`) REFERENCES `CustomerQuestion` (`QuestionID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `customerreply_ibfk_2` FOREIGN KEY (`EmployeeSSN`) REFERENCES `Employee` (`SSN`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Employee`
--

DROP TABLE IF EXISTS `Employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Employee` (
  `SSN` char(9) NOT NULL,
  `FirstName` varchar(80) NOT NULL,
  `LastName` varchar(80) NOT NULL,
  `Username` varchar(80) NOT NULL,
  `Password` varchar(80) NOT NULL,
  `Role` varchar(20) NOT NULL,
  PRIMARY KEY (`SSN`),
  UNIQUE KEY `Username` (`Username`),
  CONSTRAINT `employee_chk_1` CHECK ((`Role` in (_utf8mb4'ADMIN',_utf8mb4'REP')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Reservation`
--

DROP TABLE IF EXISTS `Reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Reservation` (
  `ReservationNumber` int NOT NULL AUTO_INCREMENT,
  `ReservationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `TotalFare` decimal(8,2) NOT NULL,
  `TicketType` varchar(20) NOT NULL,
  `DiscountType` varchar(20) NOT NULL DEFAULT 'None',
  `Status` varchar(20) NOT NULL DEFAULT 'Current',
  `Username` varchar(80) NOT NULL,
  `ScheduleID` int NOT NULL,
  `OriginStationID` int NOT NULL,
  `DestinationStationID` int NOT NULL,
  PRIMARY KEY (`ReservationNumber`),
  KEY `Username` (`Username`),
  KEY `ScheduleID` (`ScheduleID`),
  KEY `OriginStationID` (`OriginStationID`),
  KEY `DestinationStationID` (`DestinationStationID`),
  CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`Username`) REFERENCES `Customer` (`Username`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`ScheduleID`) REFERENCES `Schedule` (`ScheduleID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `reservation_ibfk_3` FOREIGN KEY (`OriginStationID`) REFERENCES `Station` (`StationID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `reservation_ibfk_4` FOREIGN KEY (`DestinationStationID`) REFERENCES `Station` (`StationID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Schedule`
--

DROP TABLE IF EXISTS `Schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Schedule` (
  `ScheduleID` int NOT NULL AUTO_INCREMENT,
  `DepartureDateTime` datetime NOT NULL,
  `ArrivalDateTime` datetime NOT NULL,
  `TravelTime` int DEFAULT NULL,
  `TrainID` char(4) NOT NULL,
  `LineName` varchar(60) NOT NULL,
  PRIMARY KEY (`ScheduleID`),
  KEY `TrainID` (`TrainID`),
  KEY `LineName` (`LineName`),
  CONSTRAINT `schedule_ibfk_1` FOREIGN KEY (`TrainID`) REFERENCES `Train` (`TrainID`),
  CONSTRAINT `schedule_ibfk_2` FOREIGN KEY (`LineName`) REFERENCES `TransitLine` (`LineName`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Station`
--

DROP TABLE IF EXISTS `Station`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Station` (
  `StationID` int NOT NULL AUTO_INCREMENT,
  `StationName` varchar(60) NOT NULL,
  `City` varchar(60) NOT NULL,
  `State` char(2) NOT NULL,
  PRIMARY KEY (`StationID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Stop`
--

DROP TABLE IF EXISTS `Stop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Stop` (
  `ScheduleID` int NOT NULL,
  `StopNumber` int NOT NULL,
  `StationID` int NOT NULL,
  `ArrivalTime` time DEFAULT NULL,
  `DepartureTime` time DEFAULT NULL,
  PRIMARY KEY (`ScheduleID`,`StopNumber`),
  KEY `StationID` (`StationID`),
  CONSTRAINT `stop_ibfk_1` FOREIGN KEY (`ScheduleID`) REFERENCES `Schedule` (`ScheduleID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `stop_ibfk_2` FOREIGN KEY (`StationID`) REFERENCES `Station` (`StationID`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Train`
--

DROP TABLE IF EXISTS `Train`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Train` (
  `TrainID` char(4) NOT NULL,
  PRIMARY KEY (`TrainID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TransitLine`
--

DROP TABLE IF EXISTS `TransitLine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TransitLine` (
  `LineName` varchar(60) NOT NULL,
  `Fare` decimal(8,2) NOT NULL,
  `OriginID` int NOT NULL,
  `DestinationID` int NOT NULL,
  PRIMARY KEY (`LineName`),
  KEY `OriginID` (`OriginID`),
  KEY `DestinationID` (`DestinationID`),
  CONSTRAINT `transitline_ibfk_1` FOREIGN KEY (`OriginID`) REFERENCES `Station` (`StationID`),
  CONSTRAINT `transitline_ibfk_2` FOREIGN KEY (`DestinationID`) REFERENCES `Station` (`StationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-20 20:57:30
