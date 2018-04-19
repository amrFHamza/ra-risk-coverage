CREATE DATABASE  IF NOT EXISTS `tag` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `tag`;
-- MySQL dump 10.13  Distrib 5.7.21, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: tag
-- ------------------------------------------------------
-- Server version	5.7.21

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
-- Table structure for table `amx_alarm`
--

DROP TABLE IF EXISTS `amx_alarm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_alarm` (
  `ALARM_ID` int(11) NOT NULL AUTO_INCREMENT,
  `OPCO_ID` int(11) NOT NULL,
  `SEVERITY_ID` int(11) NOT NULL DEFAULT '1',
  `SEVERITY` varchar(50) NOT NULL,
  `SOURCE` varchar(50) NOT NULL,
  `OBJECT_ID` varchar(50) DEFAULT NULL,
  `OBJECT_DATE` datetime DEFAULT NULL,
  `OBJECT_VERSION` varchar(50) DEFAULT '1',
  `DESCRIPTION` text,
  `LINK` text,
  `STATUS` varchar(100) NOT NULL DEFAULT 'Pending',
  `ASSIGNED_TO` varchar(255) DEFAULT NULL,
  `NOTE` text,
  `INCIDENT_ID` int(11) DEFAULT NULL,
  `CREATED` datetime DEFAULT CURRENT_TIMESTAMP,
  `MODIFIED` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ALARM_ID`),
  UNIQUE KEY `UNIQUE` (`OPCO_ID`,`OBJECT_ID`,`OBJECT_DATE`,`OBJECT_VERSION`),
  KEY `fk_AMX_ALARM_2_idx` (`INCIDENT_ID`),
  CONSTRAINT `fk_AMX_ALARM_1` FOREIGN KEY (`OPCO_ID`) REFERENCES `amx_opco` (`OPCO_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_AMX_ALARM_2` FOREIGN KEY (`INCIDENT_ID`) REFERENCES `amx_incident` (`INCIDENT_ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_alarm`
--

LOCK TABLES `amx_alarm` WRITE;
/*!40000 ALTER TABLE `amx_alarm` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_alarm` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`amx_alarm_BEFORE_UPDATE` 
BEFORE UPDATE ON `amx_alarm` FOR EACH ROW
BEGIN
	set new.MODIFIED = CURRENT_TIMESTAMP;
    if new.INCIDENT_ID is null and old.INCIDENT_ID is not null then
		set new.STATUS = 'In progress';
        set new.NOTE = concat('Deleted incident I_',  new.OPCO_ID, '_', old.INCIDENT_ID);
    end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `amx_area`
--

DROP TABLE IF EXISTS `amx_area`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_area` (
  `AREA_ID` varchar(100) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`AREA_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_area`
--

LOCK TABLES `amx_area` WRITE;
/*!40000 ALTER TABLE `amx_area` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_area` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amx_bill_cycle`
--

DROP TABLE IF EXISTS `amx_bill_cycle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_bill_cycle` (
  `BILL_CYCLE_ID` int(11) NOT NULL AUTO_INCREMENT,
  `OPCO_ID` int(11) NOT NULL,
  `BILL_CYCLE` int(11) NOT NULL,
  `DESCRIPTION` text,
  `CYCLE_CLOSE_DAY` int(11) NOT NULL DEFAULT '0',
  `CYCLE_TYPE` varchar(255) DEFAULT 'Monthly',
  PRIMARY KEY (`BILL_CYCLE_ID`),
  UNIQUE KEY `OPCO_ID` (`OPCO_ID`,`BILL_CYCLE`),
  CONSTRAINT `fk_AMX_BILL_CYCLE_1` FOREIGN KEY (`OPCO_ID`) REFERENCES `amx_opco` (`OPCO_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_bill_cycle`
--

LOCK TABLES `amx_bill_cycle` WRITE;
/*!40000 ALTER TABLE `amx_bill_cycle` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_bill_cycle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amx_change_request`
--

DROP TABLE IF EXISTS `amx_change_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_change_request` (
  `CHANGE_ID` int(11) NOT NULL AUTO_INCREMENT,
  `OPCO_ID` int(11) NOT NULL,
  `CHANGE_TYPE` varchar(255) DEFAULT NULL,
  `OBJECT_ID` varchar(50) DEFAULT NULL,
  `OLD_OBJECT` text,
  `NEW_OBJECT` text,
  `CHANGES` text,
  `REQUESTOR` varchar(255) DEFAULT NULL,
  `REQUESTOR_COMMENT` text,
  `APPROVER` varchar(255) DEFAULT NULL,
  `APPROVER_COMMENT` text,
  `STATUS` varchar(100) DEFAULT NULL,
  `ARCHIVED` varchar(1) NOT NULL DEFAULT 'N',
  `MODIFIED` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `STATUS_DATE` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CREATED` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`CHANGE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_change_request`
--

LOCK TABLES `amx_change_request` WRITE;
/*!40000 ALTER TABLE `amx_change_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_change_request` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`amx_change_request_BEFORE_UPDATE` 
BEFORE UPDATE ON `amx_change_request` FOR EACH ROW
BEGIN
	set new.MODIFIED = CURRENT_TIMESTAMP;
    if new.STATUS != old.STATUS then 
		set new.STATUS_DATE = CURRENT_TIMESTAMP;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `amx_contact`
--

DROP TABLE IF EXISTS `amx_contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_contact` (
  `CONTACT_ID` int(11) NOT NULL AUTO_INCREMENT,
  `OPCO_ID` int(11) DEFAULT NULL,
  `CONTACT_TYPE` varchar(5) DEFAULT 'G',
  `NAME` varchar(255) DEFAULT NULL,
  `EMAIL` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`CONTACT_ID`),
  UNIQUE KEY `OPCO_ID` (`OPCO_ID`,`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_contact`
--

LOCK TABLES `amx_contact` WRITE;
/*!40000 ALTER TABLE `amx_contact` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_contact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amx_dato_catalogue`
--

DROP TABLE IF EXISTS `amx_dato_catalogue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_dato_catalogue` (
  `DATO_ID` varchar(50) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `AREA_ID` varchar(100) DEFAULT NULL,
  `METRICS` text,
  `DESCRIPTION` text,
  `RELEVANT` varchar(1) DEFAULT 'Y',
  `FREQUENCY` varchar(1) DEFAULT NULL,
  `OPCO_ID` int(11) NOT NULL,
  `IMPLEMENTED` varchar(1) NOT NULL DEFAULT 'N',
  `NOTES` text,
  `START_DATE` datetime NOT NULL,
  `END_DATE` datetime DEFAULT NULL,
  `CREATED` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `MODIFIED` datetime DEFAULT NULL,
  `AUTO_LAYOUT` varchar(1) NOT NULL DEFAULT 'Y',
  `NULLABLE` varchar(1) DEFAULT 'N',
  `UNIT` varchar(1000) DEFAULT 'Number of events',
  `PROCEDURE_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`DATO_ID`,`OPCO_ID`),
  KEY `fk_AMX_DATO_CATALOGUE_1_idx` (`OPCO_ID`),
  CONSTRAINT `fk_AMX_DATO_CATALOGUE_1` FOREIGN KEY (`OPCO_ID`) REFERENCES `amx_opco` (`OPCO_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_dato_catalogue`
--

LOCK TABLES `amx_dato_catalogue` WRITE;
/*!40000 ALTER TABLE `amx_dato_catalogue` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_dato_catalogue` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`amx_dato_catalogue_BEFORE_UPDATE` 
BEFORE UPDATE ON `amx_dato_catalogue` FOR EACH ROW
BEGIN
	set new.MODIFIED = CURRENT_TIMESTAMP;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `amx_dato_layout`
--

DROP TABLE IF EXISTS `amx_dato_layout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_dato_layout` (
  `LAYOUT_ID` int(11) NOT NULL AUTO_INCREMENT,
  `DATO_ID` varchar(50) NOT NULL,
  `OPCO_ID` int(11) NOT NULL,
  `LOB_ID` int(11) NOT NULL,
  `REGION_ID` int(11) NOT NULL,
  `PERIODICITY_ID` int(11) NOT NULL,
  `TECHNOLOGY_ID` int(11) NOT NULL,
  `SERVICE_ID` int(11) NOT NULL,
  `BILL_CYCLE` int(11) NOT NULL DEFAULT '0',
  `SYSTEM_ID` int(11) DEFAULT NULL,
  `CONTACT_ID` int(11) DEFAULT NULL,
  `DELAY` int(11) NOT NULL DEFAULT '0',
  `NOTES` text,
  `FROM_FILE_ID` int(11) DEFAULT NULL,
  `CREATED` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `MODIFIED` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`LAYOUT_ID`),
  UNIQUE KEY `UNIQUE` (`DATO_ID`,`OPCO_ID`,`LOB_ID`,`PERIODICITY_ID`,`TECHNOLOGY_ID`,`SERVICE_ID`,`BILL_CYCLE`,`REGION_ID`),
  KEY `fk_AMX_DATO_LAYOUT_3_idx` (`SERVICE_ID`),
  KEY `fk_AMX_DATO_LAYOUT_4_idx` (`TECHNOLOGY_ID`),
  KEY `fk_AMX_DATO_LAYOUT_2_idx` (`LOB_ID`),
  KEY `fk_AMX_DATO_LAYOUT_5_idx` (`REGION_ID`),
  KEY `fk_AMX_DATO_LAYOUT_1_idx` (`DATO_ID`,`OPCO_ID`),
  KEY `fk_AMX_DATO_LAYOUT_6_idx` (`CONTACT_ID`),
  KEY `fk_AMX_DATO_LAYOUT_7_idx` (`SYSTEM_ID`),
  KEY `fk_AMX_DATO_LAYOUT_8_idx` (`PERIODICITY_ID`),
  CONSTRAINT `fk_AMX_DATO_LAYOUT_1` FOREIGN KEY (`DATO_ID`, `OPCO_ID`) REFERENCES `amx_dato_catalogue` (`DATO_ID`, `OPCO_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_AMX_DATO_LAYOUT_2` FOREIGN KEY (`LOB_ID`) REFERENCES `amx_lob` (`LOB_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_AMX_DATO_LAYOUT_3` FOREIGN KEY (`SERVICE_ID`) REFERENCES `amx_service` (`SERVICE_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_AMX_DATO_LAYOUT_4` FOREIGN KEY (`TECHNOLOGY_ID`) REFERENCES `amx_technology` (`TECHNOLOGY_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_AMX_DATO_LAYOUT_5` FOREIGN KEY (`REGION_ID`) REFERENCES `amx_region` (`REGION_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_AMX_DATO_LAYOUT_6` FOREIGN KEY (`CONTACT_ID`) REFERENCES `amx_contact` (`CONTACT_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_AMX_DATO_LAYOUT_7` FOREIGN KEY (`SYSTEM_ID`) REFERENCES `amx_system` (`SYSTEM_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_AMX_DATO_LAYOUT_8` FOREIGN KEY (`PERIODICITY_ID`) REFERENCES `amx_periodicity` (`PERIODICITY_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_dato_layout`
--

LOCK TABLES `amx_dato_layout` WRITE;
/*!40000 ALTER TABLE `amx_dato_layout` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_dato_layout` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`amx_dato_layout_BEFORE_UPDATE` 
BEFORE UPDATE ON `amx_dato_layout` FOR EACH ROW
BEGIN
	set new.MODIFIED = CURRENT_TIMESTAMP;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `amx_file_dato`
--

DROP TABLE IF EXISTS `amx_file_dato`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_file_dato` (
  `FILE_ID` int(11) NOT NULL,
  `OPCO_ID` int(11) NOT NULL,
  `DATO_ID` varchar(50) NOT NULL,
  `LOB_ID` int(11) NOT NULL,
  `REGION_ID` int(11) NOT NULL,
  `TECHNOLOGY_ID` int(11) NOT NULL,
  `SERVICE_ID` int(11) NOT NULL,
  `PERIODICITY_ID` int(11) NOT NULL,
  `PERIOD` varchar(50) NOT NULL,
  `DATE` datetime NOT NULL,
  `BILL_CYCLE` int(11) DEFAULT NULL,
  `VALUE` decimal(20,5) NOT NULL,
  `FILE_ROWNUM` int(11) DEFAULT NULL,
  `ERROR_CODE` int(11) DEFAULT NULL,
  `CREATED` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `UNIQUE` (`OPCO_ID`,`DATO_ID`,`LOB_ID`,`REGION_ID`,`TECHNOLOGY_ID`,`SERVICE_ID`,`PERIODICITY_ID`,`PERIOD`),
  KEY `fk_AMX_FILE_DATO_1_idx` (`FILE_ID`),
  KEY `index3` (`OPCO_ID`,`DATO_ID`,`BILL_CYCLE`),
  KEY `index4` (`ERROR_CODE`),
  CONSTRAINT `fk_AMX_FILE_DATO_1` FOREIGN KEY (`FILE_ID`) REFERENCES `amx_file_log` (`FILE_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_file_dato`
--

LOCK TABLES `amx_file_dato` WRITE;
/*!40000 ALTER TABLE `amx_file_dato` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_file_dato` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amx_file_log`
--

DROP TABLE IF EXISTS `amx_file_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_file_log` (
  `FILE_ID` int(11) NOT NULL AUTO_INCREMENT,
  `OPCO_ID` int(11) NOT NULL,
  `FILE_NAME` text NOT NULL,
  `FILE_SIZE` int(11) DEFAULT '0',
  `FILE_NAME_DATE` datetime DEFAULT NULL,
  `FILE_HEADER_DATE` datetime DEFAULT NULL,
  `FILE_MODIFY_DATE` datetime DEFAULT NULL,
  `FILE_HEADER_DISTINCT_DATOS` int(11) DEFAULT NULL,
  `FILE_HEADER_ROWS` int(11) DEFAULT NULL,
  `TOTAL_ROWS` int(11) DEFAULT '0',
  `SUCCESS_ROWS` int(11) DEFAULT '0',
  `NEW_LAYOUT` int(11) DEFAULT '0',
  `STATUS` varchar(100) DEFAULT NULL,
  `CREATED` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`FILE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_file_log`
--

LOCK TABLES `amx_file_log` WRITE;
/*!40000 ALTER TABLE `amx_file_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_file_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amx_incident`
--

DROP TABLE IF EXISTS `amx_incident`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_incident` (
  `INCIDENT_ID` int(11) NOT NULL AUTO_INCREMENT,
  `OPCO_ID` int(11) NOT NULL,
  `METRIC_ID` varchar(2500) DEFAULT NULL,
  `METRIC_DESCRIPTION` text,
  `OPENING_DATE` date DEFAULT NULL,
  `END_DATE` date DEFAULT NULL,
  `CLOSING_DATE` date DEFAULT NULL,
  `STATUS_DATE` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DUE_DATE` date DEFAULT NULL,
  `AREA` varchar(100) DEFAULT NULL,
  `PROBLEM_DESCRIPTION` text NOT NULL,
  `CLASIFICATION` varchar(255) NOT NULL,
  `ROOT_CAUSE` text,
  `IMPACT_TYPE` varchar(255) NOT NULL,
  `IMPACT` decimal(20,2) DEFAULT NULL,
  `RECOVERED` decimal(20,2) DEFAULT NULL,
  `PREVENTED` decimal(20,2) DEFAULT NULL,
  `CORRECTIVE_ACTION` text,
  `RESPONSIBLE_TEAM` varchar(1500) DEFAULT NULL,
  `RESPONSIBLE_PERSON` varchar(1500) DEFAULT NULL,
  `RESPONSIBLE_DIRECTOR` varchar(1500) DEFAULT NULL,
  `STATUS` varchar(100) NOT NULL,
  `CREATED_BY` varchar(255) DEFAULT NULL,
  `MODIFIED_BY` varchar(255) DEFAULT NULL,
  `STATUS_BY` varchar(255) DEFAULT NULL,
  `INC_NUMBER` varchar(255) DEFAULT NULL,
  `NOTES` text,
  `PROCEDURE_AMX_ID` varchar(45) DEFAULT 'N/A',
  `ARCHIVED` varchar(1) NOT NULL DEFAULT 'N',
  `CREATED` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `MODIFIED` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`INCIDENT_ID`),
  KEY `fk_AMX_INCIDENT_1_idx` (`OPCO_ID`),
  CONSTRAINT `fk_AMX_INCIDENT_1` FOREIGN KEY (`OPCO_ID`) REFERENCES `amx_opco` (`OPCO_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_incident`
--

LOCK TABLES `amx_incident` WRITE;
/*!40000 ALTER TABLE `amx_incident` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_incident` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`amx_incident_BEFORE_UPDATE` 
BEFORE UPDATE ON `amx_incident` FOR EACH ROW
BEGIN
	set new.MODIFIED = CURRENT_TIMESTAMP;
    if new.STATUS != old.STATUS then 
		set new.STATUS_DATE = CURRENT_TIMESTAMP;
        set new.STATUS_BY = new.MODIFIED_BY;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `amx_lob`
--

DROP TABLE IF EXISTS `amx_lob`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_lob` (
  `LOB_ID` int(11) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`LOB_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_lob`
--

LOCK TABLES `amx_lob` WRITE;
/*!40000 ALTER TABLE `amx_lob` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_lob` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amx_metric_catalogue`
--

DROP TABLE IF EXISTS `amx_metric_catalogue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_metric_catalogue` (
  `METRIC_ID` varchar(50) NOT NULL,
  `OPCO_ID` int(11) NOT NULL,
  `AREA_ID` varchar(100) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `DESCRIPTION` text,
  `FORMULA` varchar(1000) NOT NULL,
  `OBJECTIVE` decimal(10,5) NOT NULL DEFAULT '0.00000',
  `TOLERANCE` decimal(10,5) NOT NULL DEFAULT '0.00000',
  `DATOS` text,
  `FREQUENCY` varchar(1) NOT NULL,
  `RELEVANT` varchar(1) DEFAULT NULL,
  `START_DATE` datetime NOT NULL,
  `END_DATE` datetime DEFAULT NULL,
  `TREND` varchar(1) DEFAULT 'N',
  `NOTES` text,
  `TASKLIST_DONE` varchar(5) DEFAULT 'N',
  `IMPLEMENTED` varchar(1) DEFAULT 'N',
  `CREATED` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `MODIFIED` datetime DEFAULT NULL,
  `CVG_CONTROL_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`METRIC_ID`,`OPCO_ID`),
  KEY `fk_AMX_METRIC_CATALOGUE_1_idx` (`OPCO_ID`),
  KEY `amx_metric_catalogue_ix1` (`CVG_CONTROL_ID`),
  CONSTRAINT `fk_AMX_METRIC_CATALOGUE_1` FOREIGN KEY (`OPCO_ID`) REFERENCES `amx_opco` (`OPCO_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_metric_catalogue`
--

LOCK TABLES `amx_metric_catalogue` WRITE;
/*!40000 ALTER TABLE `amx_metric_catalogue` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_metric_catalogue` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`amx_metric_catalogue_BEFORE_INSERT` BEFORE INSERT ON `amx_metric_catalogue` FOR EACH ROW
BEGIN
	insert into cvg_control (control_type) values ('M');
    set new.CVG_CONTROL_ID = LAST_INSERT_ID();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`amx_metric_catalogue_BEFORE_UPDATE` 
BEFORE UPDATE ON `amx_metric_catalogue` FOR EACH ROW
BEGIN
	if new.FORMULA != old.FORMULA then 
		set new.MODIFIED = CURRENT_TIMESTAMP;
	end if;   
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`amx_metric_catalogue_AFTER_UPDATE` AFTER UPDATE ON `amx_metric_catalogue` FOR EACH ROW
BEGIN
 if (old.RELEVANT <> new.RELEVANT or old.IMPLEMENTED <> new.IMPLEMENTED) then
 
		
		update cvg_risk_node_sub_risk
        set COVERAGE = cvgGetRiskNodeSubRiskCoverage(RN_SUB_RISK_ID),
			FIXED = case when FIXED = 'Y' and cvgGetRiskNodeSubRiskCoverage(RN_SUB_RISK_ID) = 0 then 'N' else FIXED end
        where RN_SUB_RISK_ID in (
			SELECT rncsrl.RN_SUB_RISK_ID FROM cvg_risk_node_control rnc
			left join cvg_risk_node_control_sub_risk_link rncsrl on rncsrl.RN_CONTROL_ID = rnc.RN_CONTROL_ID
			where rnc.CONTROL_ID in (select CVG_CONTROL_ID from amx_metric_catalogue where METRIC_ID = old.METRIC_ID and OPCO_ID = old.OPCO_ID)
		);

		
        update cvg_risk_node
		set COVERAGE = cvgGetRiskNodeCoverage(RISK_NODE_ID)
        where RISK_NODE_ID in (
			SELECT rnc.RISK_NODE_ID FROM cvg_risk_node_control rnc
			where rnc.CONTROL_ID in (select CVG_CONTROL_ID from amx_metric_catalogue where METRIC_ID = old.METRIC_ID and OPCO_ID = old.OPCO_ID)
        );
        
    end if;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`amx_metric_catalogue_BEFORE_DELETE` BEFORE DELETE ON `amx_metric_catalogue` FOR EACH ROW
BEGIN
	delete from cvg_control where control_id = old.CVG_CONTROL_ID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `amx_metric_dato_link`
--

DROP TABLE IF EXISTS `amx_metric_dato_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_metric_dato_link` (
  `METRIC_ID` varchar(50) NOT NULL,
  `OPCO_ID` int(11) NOT NULL,
  `DATO_ID` varchar(50) NOT NULL,
  `CREATED` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `UNIQUE` (`OPCO_ID`,`METRIC_ID`,`DATO_ID`),
  KEY `fk_AMX_METRIC_DATO_LINK_1_idx` (`METRIC_ID`,`OPCO_ID`),
  KEY `fk_AMX_METRIC_DATO_LINK_2_idx` (`DATO_ID`,`OPCO_ID`),
  CONSTRAINT `fk_AMX_METRIC_DATO_LINK_1` FOREIGN KEY (`METRIC_ID`, `OPCO_ID`) REFERENCES `amx_metric_catalogue` (`METRIC_ID`, `OPCO_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_AMX_METRIC_DATO_LINK_2` FOREIGN KEY (`DATO_ID`, `OPCO_ID`) REFERENCES `amx_dato_catalogue` (`DATO_ID`, `OPCO_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_metric_dato_link`
--

LOCK TABLES `amx_metric_dato_link` WRITE;
/*!40000 ALTER TABLE `amx_metric_dato_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_metric_dato_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amx_metric_result`
--

DROP TABLE IF EXISTS `amx_metric_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_metric_result` (
  `RESULT_ID` int(11) NOT NULL AUTO_INCREMENT,
  `METRIC_ID` varchar(50) NOT NULL,
  `OPCO_ID` int(11) NOT NULL,
  `PERIOD` varchar(50) NOT NULL,
  `PERIODICITY_ID` int(11) NOT NULL,
  `CNT` int(11) DEFAULT '0',
  `DATE` datetime NOT NULL,
  `BILL_CYCLE` int(11) NOT NULL DEFAULT '0',
  `OBJECTIVE` decimal(10,5) DEFAULT NULL,
  `TOLERANCE` decimal(10,5) DEFAULT NULL,
  `JSON_DATO` text,
  `JSON_DATO_SUMS` text,
  `FORMULA` varchar(1000) DEFAULT NULL,
  `FORMULA_EVAL` text,
  `VALUE` decimal(25,5) DEFAULT NULL,
  `ERROR_CODE` varchar(255) DEFAULT NULL,
  `RECALCULATE` varchar(1) DEFAULT 'N',
  `MODIFIED` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`RESULT_ID`),
  UNIQUE KEY `UNIQUE` (`METRIC_ID`,`OPCO_ID`,`DATE`,`BILL_CYCLE`),
  KEY `fk_AMX_METRIC_RESULT_1_idx` (`METRIC_ID`,`OPCO_ID`),
  CONSTRAINT `fk_AMX_METRIC_RESULT_1` FOREIGN KEY (`METRIC_ID`, `OPCO_ID`) REFERENCES `amx_metric_catalogue` (`METRIC_ID`, `OPCO_ID`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_metric_result`
--

LOCK TABLES `amx_metric_result` WRITE;
/*!40000 ALTER TABLE `amx_metric_result` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_metric_result` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`amx_metric_result_BEFORE_INSERT` BEFORE INSERT ON `amx_metric_result` FOR EACH ROW
BEGIN
	set new.CNT = getMetricResultCount(new.METRIC_ID, new.OPCO_ID, new.BILL_CYCLE, new.DATE);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`amx_metric_result_BEFORE_DELETE` BEFORE DELETE ON `amx_metric_result` FOR EACH ROW
BEGIN
	insert into amx_metric_result_hist (`RESULT_ID`, `METRIC_ID`, `OPCO_ID`, `PERIOD`, `PERIODICITY_ID`, `CNT`, `DATE`, `BILL_CYCLE`, `OBJECTIVE`, `TOLERANCE`, `JSON_DATO`, `JSON_DATO_SUMS`, `FORMULA`, `FORMULA_EVAL`, `VALUE`, `ERROR_CODE`, `RECALCULATE`, `CALCULATED`)
    values(`old`.`RESULT_ID`, `old`.`METRIC_ID`, `old`.`OPCO_ID`, `old`.`PERIOD`, `old`.`PERIODICITY_ID`, `old`.`CNT`, `old`.`DATE`, `old`.`BILL_CYCLE`, `old`.`OBJECTIVE`, `old`.`TOLERANCE`, `old`.`JSON_DATO`, `old`.`JSON_DATO_SUMS`, `old`.`FORMULA`, `old`.`FORMULA_EVAL`, `old`.`VALUE`, `old`.`ERROR_CODE`, `old`.`RECALCULATE`, `old`.`MODIFIED`);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `amx_metric_result_hist`
--

DROP TABLE IF EXISTS `amx_metric_result_hist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_metric_result_hist` (
  `RESULT_ID` int(11) NOT NULL DEFAULT '0',
  `METRIC_ID` varchar(50) NOT NULL,
  `OPCO_ID` int(11) NOT NULL,
  `PERIOD` varchar(50) NOT NULL,
  `PERIODICITY_ID` int(11) NOT NULL,
  `CNT` int(11) DEFAULT '0',
  `DATE` datetime NOT NULL,
  `BILL_CYCLE` int(11) NOT NULL DEFAULT '0',
  `OBJECTIVE` decimal(10,5) DEFAULT NULL,
  `TOLERANCE` decimal(10,5) DEFAULT NULL,
  `JSON_DATO` text,
  `JSON_DATO_SUMS` text,
  `FORMULA` varchar(1000) DEFAULT NULL,
  `FORMULA_EVAL` text,
  `VALUE` decimal(25,5) DEFAULT NULL,
  `ERROR_CODE` varchar(255) DEFAULT NULL,
  `RECALCULATE` varchar(1) DEFAULT 'N',
  `CALCULATED` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `REPLACED` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `amx_metric_result_hist` (`METRIC_ID`,`OPCO_ID`,`BILL_CYCLE`,`DATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_metric_result_hist`
--

LOCK TABLES `amx_metric_result_hist` WRITE;
/*!40000 ALTER TABLE `amx_metric_result_hist` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_metric_result_hist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amx_opco`
--

DROP TABLE IF EXISTS `amx_opco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_opco` (
  `OPCO_ID` int(11) NOT NULL,
  `OPCO_NAME` varchar(100) DEFAULT NULL,
  `COUNTRY` varchar(100) DEFAULT NULL,
  `COUNTRY_CODE` varchar(3) DEFAULT NULL,
  `CURRENCY` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`OPCO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_opco`
--

LOCK TABLES `amx_opco` WRITE;
/*!40000 ALTER TABLE `amx_opco` DISABLE KEYS */;
INSERT INTO `amx_opco` VALUES (36,'A1 Telekom','Austria','AUT','€');
/*!40000 ALTER TABLE `amx_opco` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amx_periodicity`
--

DROP TABLE IF EXISTS `amx_periodicity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_periodicity` (
  `PERIODICITY_ID` int(11) NOT NULL,
  `PERIODICITY_CODE` varchar(1) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PERIODICITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_periodicity`
--

LOCK TABLES `amx_periodicity` WRITE;
/*!40000 ALTER TABLE `amx_periodicity` DISABLE KEYS */;
INSERT INTO `amx_periodicity` VALUES (1,'D','Daily'),(3,'M','Monthly'),(5,'C','Bill Cycle');
/*!40000 ALTER TABLE `amx_periodicity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amx_procedure_catalogue`
--

DROP TABLE IF EXISTS `amx_procedure_catalogue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_procedure_catalogue` (
  `PROCEDURE_ID` int(11) NOT NULL AUTO_INCREMENT,
  `PROCEDURE_AMX_ID` tinytext,
  `PROCEDURE_NAME` tinytext,
  `PROCESS_AREA` tinytext,
  `PROCEDURE_GOAL` tinytext,
  `BUSINESS_QUESTIONS` tinytext,
  `SCOPE` tinytext,
  `CONTROL_FOCUS` tinytext,
  PRIMARY KEY (`PROCEDURE_ID`),
  UNIQUE KEY `PROCEDURE_ID_UNIQUE` (`PROCEDURE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_procedure_catalogue`
--

LOCK TABLES `amx_procedure_catalogue` WRITE;
/*!40000 ALTER TABLE `amx_procedure_catalogue` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_procedure_catalogue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amx_region`
--

DROP TABLE IF EXISTS `amx_region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_region` (
  `REGION_ID` int(11) NOT NULL,
  `OPCO_ID` int(11) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`REGION_ID`,`OPCO_ID`),
  KEY `fk_AMX_REGION_1_idx` (`OPCO_ID`),
  CONSTRAINT `fk_AMX_REGION_1` FOREIGN KEY (`OPCO_ID`) REFERENCES `amx_opco` (`OPCO_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_region`
--

LOCK TABLES `amx_region` WRITE;
/*!40000 ALTER TABLE `amx_region` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_region` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amx_service`
--

DROP TABLE IF EXISTS `amx_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_service` (
  `SERVICE_ID` int(11) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`SERVICE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_service`
--

LOCK TABLES `amx_service` WRITE;
/*!40000 ALTER TABLE `amx_service` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amx_system`
--

DROP TABLE IF EXISTS `amx_system`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_system` (
  `SYSTEM_ID` int(11) NOT NULL AUTO_INCREMENT,
  `OPCO_ID` int(11) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `DESCRIPTION` text,
  `DOCU_LINK` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`SYSTEM_ID`),
  UNIQUE KEY `UNIQUE` (`OPCO_ID`,`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_system`
--

LOCK TABLES `amx_system` WRITE;
/*!40000 ALTER TABLE `amx_system` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_system` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amx_task`
--

DROP TABLE IF EXISTS `amx_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_task` (
  `TASK_ID` int(11) NOT NULL AUTO_INCREMENT,
  `OPCO_ID` int(11) NOT NULL,
  `SOURCE` varchar(50) NOT NULL,
  `OBJECT_ID` varchar(50) DEFAULT NULL,
  `DEPENDENCIES` varchar(255) DEFAULT NULL,
  `DESCRIPTION` text,
  `STATUS` varchar(100) NOT NULL DEFAULT 'Open - OPCO' COMMENT 'Open - OPCO\nOpen - TAG\nClosed',
  `ASSIGNED_TO` varchar(255) DEFAULT NULL,
  `NOTE` text,
  `STATUS_DATE` datetime DEFAULT CURRENT_TIMESTAMP,
  `STATUS_BY` varchar(255) DEFAULT NULL,
  `CREATED` datetime DEFAULT CURRENT_TIMESTAMP,
  `CREATED_BY` varchar(255) DEFAULT NULL,
  `MODIFIED` datetime DEFAULT NULL,
  `MODIFIED_BY` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`TASK_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_task`
--

LOCK TABLES `amx_task` WRITE;
/*!40000 ALTER TABLE `amx_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_task` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`amx_task_BEFORE_INSERT` BEFORE INSERT ON `amx_task` FOR EACH ROW
BEGIN
	set new.MODIFIED = CURRENT_TIMESTAMP;
	set new.STATUS_DATE = CURRENT_TIMESTAMP;
	set new.STATUS_BY = new.MODIFIED_BY;
	set new.CREATED = CURRENT_TIMESTAMP;        
	set new.CREATED_BY = new.MODIFIED_BY;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`amx_task_BEFORE_UPDATE` BEFORE UPDATE ON `amx_task` FOR EACH ROW
BEGIN
	set new.MODIFIED = CURRENT_TIMESTAMP;
    if new.STATUS != old.STATUS then 
		set new.STATUS_DATE = CURRENT_TIMESTAMP;
        set new.STATUS_BY = new.MODIFIED_BY;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `amx_technology`
--

DROP TABLE IF EXISTS `amx_technology`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_technology` (
  `TECHNOLOGY_ID` int(11) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`TECHNOLOGY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_technology`
--

LOCK TABLES `amx_technology` WRITE;
/*!40000 ALTER TABLE `amx_technology` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_technology` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amx_time_day`
--

DROP TABLE IF EXISTS `amx_time_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_time_day` (
  `DATE` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `FULL_MONTH` varchar(50) DEFAULT NULL,
  `CALENDAR_DAY` int(11) DEFAULT NULL,
  `CALENDAR_WEEK` int(11) DEFAULT NULL,
  `CALENDAR_MONTH` int(11) DEFAULT NULL,
  `CALENDAR_QUARTER` int(11) DEFAULT NULL,
  `CALENDAR_SEMESTER` int(11) DEFAULT NULL,
  `CALENDAR_YEAR` int(11) DEFAULT NULL,
  `DAY_OF_WEEK` int(11) DEFAULT NULL,
  `DAY_OF_YEAR` int(11) DEFAULT NULL,
  PRIMARY KEY (`DATE`),
  UNIQUE KEY `UNIQUE` (`DATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_time_day`
--

LOCK TABLES `amx_time_day` WRITE;
/*!40000 ALTER TABLE `amx_time_day` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_time_day` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amx_time_month`
--

DROP TABLE IF EXISTS `amx_time_month`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_time_month` (
  `DATE` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `LAST_DATE` datetime DEFAULT NULL,
  `FULL_MONTH` varchar(50) DEFAULT NULL,
  `CALENDAR_MONTH` int(11) DEFAULT NULL,
  `CALENDAR_QUARTER` int(11) DEFAULT NULL,
  `CALENDAR_SEMESTER` int(11) DEFAULT NULL,
  `CALENDAR_YEAR` int(11) DEFAULT NULL,
  PRIMARY KEY (`DATE`),
  UNIQUE KEY `UNIQUE` (`DATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_time_month`
--

LOCK TABLES `amx_time_month` WRITE;
/*!40000 ALTER TABLE `amx_time_month` DISABLE KEYS */;
/*!40000 ALTER TABLE `amx_time_month` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amx_user`
--

DROP TABLE IF EXISTS `amx_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `amx_user` (
  `USERNAME` varchar(255) NOT NULL,
  `EMAIL` varchar(255) NOT NULL,
  `PASSWORD` varchar(255) DEFAULT NULL,
  `OPCO_ID` int(11) NOT NULL,
  `ACCESS_LEVEL` int(11) DEFAULT '100',
  `LOGIN_SUCCESS` int(11) DEFAULT '0',
  `LOGIN_FAILED` int(11) DEFAULT '0',
  `CREATED` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `MODIFIED` datetime DEFAULT NULL,
  `LAST_LOGIN_ATTEMPT` datetime DEFAULT NULL,
  PRIMARY KEY (`EMAIL`),
  KEY `fk_AMX_USER_1_idx` (`OPCO_ID`),
  CONSTRAINT `fk_AMX_USER_1` FOREIGN KEY (`OPCO_ID`) REFERENCES `amx_opco` (`OPCO_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amx_user`
--

LOCK TABLES `amx_user` WRITE;
/*!40000 ALTER TABLE `amx_user` DISABLE KEYS */;
INSERT INTO `amx_user` VALUES ('test','test@example.com','5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8',36,100,5,0,'2017-01-03 15:35:14',NULL,'2018-04-17 09:12:12');
/*!40000 ALTER TABLE `amx_user` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`amx_user_BEFORE_UPDATE` 
BEFORE UPDATE ON `amx_user` FOR EACH ROW
BEGIN
	if (ifnull(new.LOGIN_SUCCESS, 0) != ifnull(old.LOGIN_SUCCESS, 0) or ifnull(new.LOGIN_FAILED, 0) != ifnull(old.LOGIN_FAILED, 0)) then
		set new.LAST_LOGIN_ATTEMPT = CURRENT_TIMESTAMP;
    end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `cvg_business_process`
--

DROP TABLE IF EXISTS `cvg_business_process`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cvg_business_process` (
  `BUSINESS_PROCESS_ID` int(11) NOT NULL AUTO_INCREMENT,
  `BUSINESS_PROCESS` varchar(500) DEFAULT NULL,
  `DESCRIPTION` varchar(500) DEFAULT NULL,
  `SOURCE` enum('TMF','TAG','RAG') DEFAULT 'RAG',
  PRIMARY KEY (`BUSINESS_PROCESS_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_business_process`
--

LOCK TABLES `cvg_business_process` WRITE;
/*!40000 ALTER TABLE `cvg_business_process` DISABLE KEYS */;
INSERT INTO `cvg_business_process` VALUES (10,'Product and Offer management','','RAG'),(20,'Customer management','','RAG'),(30,'Order Entry and Provisioning','','RAG'),(40,'Network and usage Management','','RAG'),(60,'Rating and Billing','','RAG'),(80,'Partner management','','RAG'),(90,'Finance and Accounting','','RAG');
/*!40000 ALTER TABLE `cvg_business_process` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cvg_business_sub_process`
--

DROP TABLE IF EXISTS `cvg_business_sub_process`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cvg_business_sub_process` (
  `BUSINESS_SUB_PROCESS_ID` int(11) NOT NULL AUTO_INCREMENT,
  `BUSINESS_PROCESS_ID` int(11) DEFAULT NULL,
  `BUSINESS_SUB_PROCESS` varchar(500) DEFAULT NULL,
  `SOURCE` enum('TMF','TAG','RAG') DEFAULT 'RAG',
  PRIMARY KEY (`BUSINESS_SUB_PROCESS_ID`),
  KEY `fk_cvg_business_sub_process_1_idx` (`BUSINESS_PROCESS_ID`),
  CONSTRAINT `fk_cvg_business_sub_process_1` FOREIGN KEY (`BUSINESS_PROCESS_ID`) REFERENCES `cvg_business_process` (`BUSINESS_PROCESS_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_business_sub_process`
--

LOCK TABLES `cvg_business_sub_process` WRITE;
/*!40000 ALTER TABLE `cvg_business_sub_process` DISABLE KEYS */;
INSERT INTO `cvg_business_sub_process` VALUES (1,10,'Product and Offer Management','RAG'),(2,20,'Customer Management','RAG'),(3,30,'Order Management and Provisioning','RAG'),(4,40,'Network Management','RAG'),(5,40,'Usage Management','RAG'),(6,60,'Rating and Pricing','RAG'),(7,60,'Charging and Billing','RAG'),(8,80,'Partner Management','RAG'),(9,90,'Receiveables Management','RAG'),(10,90,'Finance and Accounting','RAG');
/*!40000 ALTER TABLE `cvg_business_sub_process` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cvg_control`
--

DROP TABLE IF EXISTS `cvg_control`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cvg_control` (
  `CONTROL_ID` int(11) NOT NULL AUTO_INCREMENT,
  `CONTROL_TYPE` varchar(1) NOT NULL DEFAULT 'C' COMMENT 'C ... Control\nM ... Metric\nI ... ICS',
  `MODIFIED` datetime DEFAULT CURRENT_TIMESTAMP,
  `CTRL_COVERAGE` decimal(10,4) DEFAULT '0.0000',
  `CTRL_COVERAGE_OVERLAP` decimal(10,4) DEFAULT '0.0000',
  PRIMARY KEY (`CONTROL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_control`
--

LOCK TABLES `cvg_control` WRITE;
/*!40000 ALTER TABLE `cvg_control` DISABLE KEYS */;
/*!40000 ALTER TABLE `cvg_control` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`cvg_control_BEFORE_UPDATE` BEFORE UPDATE ON `cvg_control` FOR EACH ROW
BEGIN
	set new.MODIFIED = CURRENT_TIMESTAMP;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`cvg_control_BEFORE_DELETE` BEFORE DELETE ON `cvg_control` FOR EACH ROW
BEGIN
	
	update cvg_risk_node_control rnc 
	set EFFECTIVENESS = 0
	where rnc.CONTROL_ID = old.CONTROL_ID;

	
    
	update cvg_risk_node_sub_risk rnsr
	set rnsr.COVERAGE = cvgGetRiskNodeSubRiskCoverage(rnsr.RN_SUB_RISK_ID),
		rnsr.FIXED = case when rnsr.FIXED = 'Y' and cvgGetRiskNodeSubRiskCoverage(rnsr.RN_SUB_RISK_ID) = 0 then 'N' else rnsr.FIXED end
	where rnsr.RN_SUB_RISK_ID in (
		select distinct rncsrl.RN_SUB_RISK_ID 
		from cvg_risk_node_control rnc 
		join cvg_risk_node_control_sub_risk_link rncsrl on rncsrl.RN_CONTROL_ID = rnc.RN_CONTROL_ID 
		where rnc.CONTROL_ID = old.CONTROL_ID
	);
    
    
	update cvg_risk_node rn
	set rn.COVERAGE = cvgGetRiskNodeCoverage(rn.RISK_NODE_ID)
	where rn.RISK_NODE_ID in (
		select distinct risk_node_id 
		from cvg_risk_node_control rnc 
		join cvg_risk_node_control_sub_risk_link rncsrl on rncsrl.RN_CONTROL_ID = rnc.RN_CONTROL_ID
		where rnc.CONTROL_ID = old.CONTROL_ID
	);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `cvg_control_system_mix`
--

DROP TABLE IF EXISTS `cvg_control_system_mix`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cvg_control_system_mix` (
  `SYSTEM_NAME` varchar(255) DEFAULT NULL,
  `SYSTEM_ID` int(11) DEFAULT NULL,
  `CONTROL_TYPE` varchar(1) NOT NULL DEFAULT '',
  `OPCO_ID` int(11) NOT NULL DEFAULT '0',
  `CVG_CONTROL_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_control_system_mix`
--

LOCK TABLES `cvg_control_system_mix` WRITE;
/*!40000 ALTER TABLE `cvg_control_system_mix` DISABLE KEYS */;
/*!40000 ALTER TABLE `cvg_control_system_mix` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cvg_key_risk_area`
--

DROP TABLE IF EXISTS `cvg_key_risk_area`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cvg_key_risk_area` (
  `KEY_RISK_AREA_ID` int(11) NOT NULL AUTO_INCREMENT,
  `KEY_RISK_AREA` varchar(255) DEFAULT NULL,
  `KEY_RISK_AREA_DESCRIPTION` text,
  PRIMARY KEY (`KEY_RISK_AREA_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_key_risk_area`
--

LOCK TABLES `cvg_key_risk_area` WRITE;
/*!40000 ALTER TABLE `cvg_key_risk_area` DISABLE KEYS */;
INSERT INTO `cvg_key_risk_area` VALUES (1,'Asset Assurance','Stranded assets, under/over capacity, assets not decommissioned in a timely manner'),(2,'Billing Assurance','Post-paid invoicing errors, usage allowed when credit limited reached, discount errors, mutually exclusive discounts applied, incorrect tax calculations, incorrect manual intervention on billing system, discounts given when contract terms not complied with, expired promotions'),(3,'Bypass Assurance','Bypass Assurance'),(4,'Charging Assurance','Pre-paid balance movement errors, concurrent real-time charging losses, prepaid service allowed with zero/negative balance, excess charges not applied'),(5,'Commission Assurance','Commission payments in-line with sales, clawback not invoked for cancelled sales, multiple commission payments for the same sale, service does not become active'),(6,'Contract Assurance','Incorrect bespoke pricing, handsets on wrong tariff, bulk rate changes applied incorrectly'),(7,'Credit Assurance','Customer risk profile too high, bad debt write off'),(8,'Customer Experience Assurance','Products not used as expected, customer complaints, adverse social media, reputational damage, customer churn, sales growth lower than expected'),(9,'Equipment Assurance','Unnecessary delay to supply of customer premises equipment, shipping of incorrect equipment, over supply of customer premises equipment, stock write-off, equipment not repossessed at end of contract'),(10,'Grey Traffic Assurance','Traffic from unknown sources, unable to determine charging zones, billable traffic made to look like unbillable traffic'),(11,'Loyalty Assurance','Awards made to non-qualifying members, over charging by suppliers of loyalty services, access to loyalty programme continues after contract terminated, expired loyalty promotions'),(12,'Marketing Assurance','Product definitions do not align with network capabilities, published tariffs do not agree with price book, marketing campaigns do not deliver expected take-up'),(13,'Mobile Money Assurance','Transactions credited more than once, over charging of transaction fees by third parties, incorrect credit transfers, cash-in not credited correctly'),(14,'Network Assurance','Network Assurance'),(15,'Number Assurance','Inefficient management of allocated number range(s)'),(16,'Partner Assurance','Partner Assurance'),(17,'Payment Assurance','Payment credited for the wrong amount, payment credited to the wrong account, payment not linked to account, payment credited more than once, employee charges not deducted from salary correctly'),(18,'Policy Assurance','Fair use policy implemented incorrectly, fair use policy not enforced'),(19,'Pricing Assurance','Incorrect event-based pricing, incorrect event-based discount applied, incorrect zero/default rated event, incorrect apportionment between time bands, expired promotions'),(20,'Process Assurance','Incorrect process steps, process gaps, high level of manual tasks, unapproved workarounds, informal hand-offs between teams, out of date business rules'),(21,'Procurement Assurance','Purchasing of third party resources at pre-negotiated rates, bought-in third party services do not align with customer sales'),(22,'Product Assurance','New product launched but cannot be billed, products with low/negative margin products, products with low take-up, product cannot provide all services and features, offers can be exploited by customers'),(23,'Profitability Assurance','Unprofitable tariffs, unprofitable subscribers, unprofitable partners, unprofitable transit services, unprofitable marketing campaigns'),(24,'Reference Data Assurance','Out of date reference data, incorrect reference data, incomplete reference data'),(25,'Reporting Assurance','Incorrect chart of account mapping, annual report does not give a true and fair reflection of the business, over statement of number of subscribers'),(26,'Sales Assurance','Service contracts do not adhere to sales guidelines, sales contracts do not align with product definitions, services are sold that cannot be implemented by existing products, withdrawn products continue to be sold'),(27,'Service Assurance','Service availability, service interruption, poor quality of service, denial of service, violation of service level agreements'),(28,'Subscription Assurance','Service before charging, charging before service, under/over provisioning of services and features, service after cease, charging after cease, customer on wrong plan, ex-employees still receive staff discount after leaving'),(29,'Tariff Assurance','Missing destinations, destinations do not align with traffic classes, rate plans do not agree with price book, incorrect fair use policy definition, incorrect provisioning strings associated with products, unauthorised tariff changes'),(30,'Usage Assurance','Incomplete/incorrect recording of service usage, billable usage removed from the billing chain, unexpected usage, duplicated usage data, usage data not sent to correct billing/settlement system');
/*!40000 ALTER TABLE `cvg_key_risk_area` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cvg_measure`
--

DROP TABLE IF EXISTS `cvg_measure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cvg_measure` (
  `MEASURE_ID` int(11) NOT NULL AUTO_INCREMENT,
  `BUSINESS_PROCESS_ID` int(11) NOT NULL,
  `BUSINESS_SUB_PROCESS_ID` int(11) DEFAULT NULL,
  `MEASURE_TYPE` varchar(100) DEFAULT NULL,
  `MEASURE_NAME` varchar(255) DEFAULT NULL,
  `MEASURE_DESCRIPTION` text,
  `TMF_REFERENCE` varchar(255) DEFAULT NULL,
  `TMF_ID` varchar(50) DEFAULT NULL,
  `RELEVANT` varchar(1) DEFAULT 'Y',
  `REQUIRED` varchar(1) DEFAULT 'Y',
  `SOURCE` enum('TMF','TAG') DEFAULT 'TMF',
  PRIMARY KEY (`MEASURE_ID`),
  KEY `fk_cvg_measure_1_idx` (`BUSINESS_PROCESS_ID`),
  CONSTRAINT `fk_cvg_measure_1` FOREIGN KEY (`BUSINESS_PROCESS_ID`) REFERENCES `cvg_business_process` (`BUSINESS_PROCESS_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=240 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_measure`
--

LOCK TABLES `cvg_measure` WRITE;
/*!40000 ALTER TABLE `cvg_measure` DISABLE KEYS */;
/*!40000 ALTER TABLE `cvg_measure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cvg_product_group`
--

DROP TABLE IF EXISTS `cvg_product_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cvg_product_group` (
  `PRODUCT_GROUP_ID` int(11) NOT NULL AUTO_INCREMENT,
  `LOB` varchar(100) DEFAULT NULL,
  `PRODUCT_GROUP` varchar(100) DEFAULT NULL,
  `MODIFIED` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`PRODUCT_GROUP_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=396 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_product_group`
--

LOCK TABLES `cvg_product_group` WRITE;
/*!40000 ALTER TABLE `cvg_product_group` DISABLE KEYS */;
INSERT INTO `cvg_product_group` VALUES (1,'Postpaid','Recurring fees','2016-06-30 16:21:58'),(2,'Postpaid','One time charges','2016-06-30 16:21:58'),(3,'Postpaid','Usage','2016-06-30 16:21:59'),(5,'Postpaid','Credits & discounts','2016-06-30 16:21:59'),(6,'Postpaid','VAS','2016-06-30 16:21:59'),(7,'Postpaid','Other','2016-06-30 16:21:59'),(8,'Prepaid','One time charges','2016-06-30 16:25:01'),(9,'Prepaid','Usage','2016-06-30 16:25:01'),(10,'Prepaid','Usage customer roaming','2016-06-30 16:25:01'),(11,'Wholesale','Interconnection','2018-04-16 20:54:57'),(13,'Wholesale','National & international Business','2016-06-30 16:25:01'),(14,'Wholesale','Roaming','2016-06-30 16:25:01'),(15,'Wholesale','VAS','2016-06-30 16:25:01'),(16,'Special Billing','Projects','2016-07-08 14:53:40'),(17,'Special Billing','Dealers & Shops','2016-11-28 14:19:20'),(18,'Special Billing','Real Estate','2016-06-30 16:25:01'),(395,'Special Billing','Other','2016-11-28 14:24:43');
/*!40000 ALTER TABLE `cvg_product_group` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`cvg_product_group_BEFORE_UPDATE` BEFORE UPDATE ON `cvg_product_group` FOR EACH ROW
BEGIN
	set new.MODIFIED = CURRENT_TIMESTAMP;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `cvg_product_group_key_risk_area_link`
--

DROP TABLE IF EXISTS `cvg_product_group_key_risk_area_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cvg_product_group_key_risk_area_link` (
  `PRODUCT_GROUP_ID` int(11) NOT NULL,
  `KEY_RISK_AREA_ID` int(11) NOT NULL,
  UNIQUE KEY `UNIQUE` (`PRODUCT_GROUP_ID`,`KEY_RISK_AREA_ID`),
  KEY `fk_cvg_product_group_key_risk_area_link_2` (`KEY_RISK_AREA_ID`),
  CONSTRAINT `fk_cvg_product_group_key_risk_area_link_1` FOREIGN KEY (`PRODUCT_GROUP_ID`) REFERENCES `cvg_product_group` (`PRODUCT_GROUP_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cvg_product_group_key_risk_area_link_2` FOREIGN KEY (`KEY_RISK_AREA_ID`) REFERENCES `cvg_key_risk_area` (`KEY_RISK_AREA_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_product_group_key_risk_area_link`
--

LOCK TABLES `cvg_product_group_key_risk_area_link` WRITE;
/*!40000 ALTER TABLE `cvg_product_group_key_risk_area_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `cvg_product_group_key_risk_area_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cvg_product_segment`
--

DROP TABLE IF EXISTS `cvg_product_segment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cvg_product_segment` (
  `PRODUCT_SEGMENT_ID` int(11) NOT NULL AUTO_INCREMENT,
  `PRODUCT_GROUP_ID` int(11) NOT NULL,
  `OPCO_ID` int(11) NOT NULL DEFAULT '36',
  `PRODUCT_SEGMENT` varchar(100) DEFAULT NULL,
  `VALUE` decimal(20,5) NOT NULL,
  `VALUE_REFFERENCE` text,
  `MODIFIED` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`PRODUCT_SEGMENT_ID`),
  KEY `fk_cvg_product_segment_1_idx` (`PRODUCT_GROUP_ID`),
  CONSTRAINT `fk_cvg_product_segment_1` FOREIGN KEY (`PRODUCT_GROUP_ID`) REFERENCES `cvg_product_group` (`PRODUCT_GROUP_ID`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_product_segment`
--

LOCK TABLES `cvg_product_segment` WRITE;
/*!40000 ALTER TABLE `cvg_product_segment` DISABLE KEYS */;
/*!40000 ALTER TABLE `cvg_product_segment` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`cvg_product_segment_BEFORE_UPDATE` BEFORE UPDATE ON `cvg_product_segment` FOR EACH ROW
BEGIN
	set new.MODIFIED = CURRENT_TIMESTAMP;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `cvg_risk`
--

DROP TABLE IF EXISTS `cvg_risk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cvg_risk` (
  `RISK_ID` int(11) NOT NULL AUTO_INCREMENT,
  `BUSINESS_SUB_PROCESS_ID` int(11) NOT NULL,
  `RISK` varchar(100) DEFAULT NULL,
  `RISK_CATEGORY` varchar(20) DEFAULT NULL,
  `RISK_DESCRIPTION` text,
  `SOURCE` enum('TMF','TAG','RAG') NOT NULL DEFAULT 'RAG',
  PRIMARY KEY (`RISK_ID`),
  KEY `fk_cvg_risk_1_idx` (`BUSINESS_SUB_PROCESS_ID`),
  CONSTRAINT `fk_cvg_risk_1` FOREIGN KEY (`BUSINESS_SUB_PROCESS_ID`) REFERENCES `cvg_business_sub_process` (`BUSINESS_SUB_PROCESS_ID`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=184 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_risk`
--

LOCK TABLES `cvg_risk` WRITE;
/*!40000 ALTER TABLE `cvg_risk` DISABLE KEYS */;
INSERT INTO `cvg_risk` VALUES (1,3,'Stranded assets',NULL,'Network resources that are available for use but are showing as in-use.  Applies to physical and logical resources.','RAG'),(4,7,'Invoice does not contain all chargeable items',NULL,'Customer invoice is missing chargeable items e.g. service usage (consumption), fixed/recurring charges, one-off charges, adjustments etc.','RAG'),(5,7,'Billing errors',NULL,'Customer invoice contains pricing errors.','RAG'),(6,7,'Manual billing errors',NULL,'Errors in invoices that require one or more manual processing steps. ','RAG'),(7,7,'Discount errors',NULL,'Customer invoice contains errors with calculation of discounts, e.g. for exceeding usage threshold, discounted destinations, etc.','RAG'),(8,7,'Invoices not issued',NULL,'Failure to generate, or despatch a customer invoice.','RAG'),(9,4,'Incoming traffic avoids interconnect gateway',NULL,'Traffic originating off-net bypasses operators interconnect gateway (international or national).','RAG'),(10,4,'Revenue bypass',NULL,'Revenue generating services provided by other organisations (e.g. alternatives voice, messaging or content services) where revenue bypasses the host network.','RAG'),(11,7,'Under-charging of customers',NULL,'Customers are not charged for all billable events or are not charged enough for the equipment supplied or services have consumed.','RAG'),(12,7,'Over-charging of customers',NULL,'Customers are charged too much for the equipment supplied or services have consumed.','RAG'),(13,7,'Charging errors',NULL,'Priced events not charged correctly, e.g. not deducted from prepaid account.','RAG'),(14,7,'Event-based discounts not applied correctly',NULL,'Events should be at a lower price, but discount not applied.','RAG'),(15,7,'Volume based discounts not applied correctly',NULL,'Events should be at a lower price because a threshold has been exceeded, but discount not applied.','RAG'),(16,7,'Cross-product discounts not applied correctly',NULL,'Discounts for product B as a result of buying product A not correctly implemented or applied.','RAG'),(17,7,'Prepaid bonuses not credited correctly',NULL,'Bonus minutes/text/data etc. not credited or credited to wrong balance in customer\'s account.','RAG'),(18,7,'Prepaid promotions not credited correctly',NULL,'Promotions not applied correctly, e.g. reduced rate for texts between 18:00-20:00 charged at normal rate.','RAG'),(19,7,'Prepaid subscription charges not applied',NULL,'Recurring charges for the provision of subscription-based prepaid services not charged.','RAG'),(20,10,'Overpayment of sales commission',NULL,'Salesperson\'s commission calculated incorrectly, or they receive commission payments that they are not entitled to.','RAG'),(21,2,'Contract does not reflect negotiated pricing',NULL,'Contract terms differ from the terms agreed by the commercial team with the customer.','RAG'),(22,2,'Discounts given when contract terms not complied with',NULL,'Level of discount applied to invoice is incorrect for level of consumption or services taken.','RAG'),(23,2,'Equipment title not enforced',NULL,'Operator owned equipment not returned at end of contract.','RAG'),(24,2,'Customer terms not known',NULL,'Contract database either; does not exist, does not contain customer contract or holds wrong version of contract.','RAG'),(25,2,'Good subscribers denied service',NULL,'Credit scoring rules too rigid and acceptable subscribers are turned away.','RAG'),(26,3,'Customer risk profile too high',NULL,'Customers are accepted who pose too great a credit risk.','RAG'),(27,2,'Bad debt caused by billing errors',NULL,'Customer invoices have missed charges owing to billing errors. When discovered these should not be treated as customer bad debt.','RAG'),(28,4,'SLA violation',NULL,'Services provided by operator has breached the Service Level Agreement with the customer and may invoke a penalty payment.','RAG'),(29,2,'Customer complaints',NULL,'Complaints received by the operator from users of their services.','RAG'),(30,2,'Early termination of order/contract',NULL,'Customer terminates their service contract before the initial term','RAG'),(31,2,'Poor quality of customer services',NULL,'Quality of customer services falls below expectations.','RAG'),(32,3,'Costs higher than expected',NULL,'Equipment costs too high for various reasons, e.g. too many handsets ordered.','RAG'),(33,3,'Stock levels not in-line with product/service utilisation',NULL,'Poor stock control means equipment levels do not accurately match sales.','RAG'),(35,3,'Over supply of customer premises equipment',NULL,'Too much CPE despatched to customer, inventory system does not hold accurate information.','RAG'),(37,6,'Revenues lower than expected',NULL,'Equipment pricing incorrect, e.g. tax not charged.','RAG'),(38,5,'Loss of A2P Bulk SMS revenue',NULL,'Revenue loss from bulk SMS that cannot be identified correctly','RAG'),(39,5,'Spoofed SMS',NULL,'Revenue loss from SMS traffic that cannot be identified correctly','RAG'),(40,5,'Phishing SMS',NULL,'Failure to identify and trap phishing SMS','RAG'),(41,5,'Outgoing traffic not received by partner settlement system',NULL,'Interconnect traffic to other operators is not identified or passed to interconnect settlement system.','RAG'),(42,5,'Incoming traffic not received by partner settlement system',NULL,'Interconnect traffic from other operators is not identified or passed to interconnect settlement system.','RAG'),(43,6,'Incorrect settlement with partner',NULL,'The settlement process with third party organisations in incorrect or incomplete, e.g. under stated traffic volumes.','RAG'),(44,6,'Over charging of partners',NULL,'Interconnect partners over charged for e.g. incorrect pricing, over stated volumes.','RAG'),(45,8,'Under charging by partners',NULL,'Interconnect partner under charges operator for traffic received.','RAG'),(46,8,'Partner agreement not managed properly',NULL,'The terms and conditions of partner agreements are not actively managed, that can result in high charges from third parties.','RAG'),(47,8,'Incorrect charging party',NULL,'Partner incorrectly identified.','RAG'),(48,4,'Inflated costs',NULL,'Higher charges than necessary are incurred for interconnect traffic, e.g. incorrect management of volume discounts.','RAG'),(49,6,'Arbitrage',NULL,'Other operators/partners taking advantage of differential rates in partner pricing.','RAG'),(50,4,'Re-file Traffic',NULL,'Terminating traffic is manipulated so that it qualifies for a lower termination rate than it should do.','RAG'),(51,2,'Awards made to non-qualifying members',NULL,'Customer rewards given to customer that do not qualify or no longer qualify for the loyalty programme.','RAG'),(52,2,'Loyalty scheme costs higher than expected',NULL,'Loyalty scheme costs too high e.g. offers not expiring when they should.','RAG'),(53,1,'New product cannot operate as advertised',NULL,'Product capabilities do not align with sales and marketing collateral.','RAG'),(54,1,'Product launched with inability to generate bills',NULL,'Product launched but supporting systems are unable to charge for it.','RAG'),(55,1,'Unprofitable sales campaign',NULL,'Sales campaign does not achieve expected margin, e.g. take-up lower than expected, costs higher than expected, revenues lower than expected, etc.','RAG'),(56,2,'Over statement of subscriber numbers',NULL,'Number of active customers not accurately measured.','RAG'),(57,8,'Partner subscribers not accounted for',NULL,'Host network fails to identify partner subscribers accurately, e.g. MVNO subscrtibers versus own subscribers.','RAG'),(58,6,'Partner usage fees calculated incorrectly',NULL,'Host network fails to calculate partner\'s usage fees correctly, e.g. MVNO usage fees.','RAG'),(59,6,'Partner service fees calculated incorrectly',NULL,'Host network fails to calculate partner\'s service fees correctly, er.g. MVNO service fees.','RAG'),(60,8,'Partner services not profitable',NULL,'Cost of providing services for or on behalf half of a partner exceeds the service fees received, e.g. Reseller, MVNO, national roaming partner.','RAG'),(61,4,'Partner service failure ',NULL,'Service configuration errors on host network denies service to MVNO customers.','RAG'),(62,5,'Unexpected service usage',NULL,'Network service available to customers with negative balance or when credit limit exceeded.','RAG'),(63,4,'Traffic allowed to unexpected services/destinations',NULL,'Barred numbers not blocked.','RAG'),(64,3,'Over allocation of numbers',NULL,'Over allocation of number ranges to customers, services etc resulting in operator\'s allocated number being exhausted too quickly.','RAG'),(65,4,'Assigned numbers not used',NULL,'Numbers allocated from the operator\'s number range(s) are not used.','RAG'),(66,4,'Numbers not re-used quickly enough',NULL,'Deactivated numbers are not recycled for reuse in a timely fashion, e.g. time before reuse exceeds quarantine period.','RAG'),(67,4,'Numbers not re-used',NULL,'Deactivated numbers are not recycled for reuse and so become stranded.','RAG'),(68,7,'Unable to charge subscribers for revenue share products',NULL,'Subscriber charging for revenue share products cannot be determined.','RAG'),(69,8,'Out payments do not align with subscriber charging',NULL,'Subscriber revenues from shared service do not match payments made to third parties.','RAG'),(70,9,'Aged debt not actively managed',NULL,'Collections process not triggered for overdue amounts.','RAG'),(71,8,'Over charging of payment transaction fees',NULL,'Service fees from payment partners are higher than they should be.','RAG'),(72,4,'Fair usage policy not enforced',NULL,'Fair usage policy is defined but it is not active so traffic profiling is not performed.','RAG'),(73,4,'Fair usage policy applied too soon',NULL,'Fair usage policy is applied before it should be.','RAG'),(74,4,'Fair usage policy applied too late',NULL,'Fair usage policy is applied after it should be.','RAG'),(75,4,'Fair usage policy not applied correctly',NULL,'Fair usage policy is triggered at the correct time but the associated traffic profiling is not applied correctly.','RAG'),(76,3,'Billing does not aligned with FUP Platform',NULL,'Fair usage policy definitions in the billing system do not agree with those on the fair usage policy management system.','RAG'),(77,1,'Policy not aligned with Tariff/Product',NULL,'Fair usage policy definitions in the fair usage policy management system do not agree with the product definitions.','RAG'),(78,5,'Traffic Class Misidentified',NULL,'Incorrect class of traffic assigned to a usage event.','RAG'),(79,3,'Pass Cap Limits Not Enforced',NULL,'Maximum number of service passes/bundles can be exceeded.','RAG'),(80,7,'Per Pass Charges Not Applied',NULL,'Fees for service passes/bundles not charged','RAG'),(81,2,'Customer does not get appropriate policy warnings',NULL,'Customer does not get usage warnings relating to consumption of service passes/bundles/caps and fair usage limits.','RAG'),(82,2,'Customers cut off when they should not have been',NULL,'Customer cut-off from service before they should have been.','RAG'),(83,6,'Zero/default rated calls',NULL,'Calls that are incorrectly priced at zero rate or a lower default rate.','RAG'),(84,6,'Incorrect event-based pricing',NULL,'The price of billable events are calculated incorrectly.','RAG'),(85,6,'Incorrect pricing of corporate services',NULL,'Pricing failures/errors specific to corporate services, e.g. customer specific dial plans, VPNs/CUGs.','RAG'),(86,6,'Billable events not priced',NULL,'Errors that cause billable events not to be priced.','RAG'),(87,6,'Bundle management applied incorrectly',NULL,'Pricing errors owing to mishandling of bundles.','RAG'),(88,7,'Changes mid-billing cycle not pro-rated correctly',NULL,'Changes to a subscriber\'s product/services/plan is not apportioned within the billing cycle correctly.','RAG'),(89,6,'Event-based discounts not applied correctly',NULL,'Discounts that can be applied at the event-level (e.g. family-and-friends, favourite destinations, etc) are not applied correctly.','RAG'),(90,6,'Rounding Errors',NULL,'Rounding errors causing the price for an event to be priced incorrectly.','RAG'),(91,7,'Incorrectly charged parties',NULL,'The charged party or parties is not identified correctly, for example: shared rate and reverse charging.','RAG'),(92,7,'Business processes allow billing errors',NULL,'Business process are susceptible to billing and charging errors.','RAG'),(93,8,'Over ordering of third party resources',NULL,'Requirements for services provided by a partner/third party are overestimated.','RAG'),(94,8,'Under ordering of third party resources',NULL,'Requirements for services provided by a partner/third party are underestimated.','RAG'),(95,8,'Unnecessary Costs',NULL,'Resources continue to be purchased from a third party even though they are no longer required.','RAG'),(96,6,'Incorrect calculation of billing units',NULL,'The number of billing/charging units is calculated incorrectly.','RAG'),(97,1,'Product/service cannot deliver the expected margin',NULL,'Product/service as implemented cannot deliver the expected level of profit to the business.','RAG'),(98,1,'Product utilisation is lower than expected',NULL,'The expected level of product/service take-up and/or usage is not achieved.','RAG'),(99,1,'Product/service cannot operated as advertised',NULL,'The product/service does not offer all of the features advertised.','RAG'),(100,1,'Product/service does operated as advertised',NULL,'Not all of the features of a product/service work correctly, i.e. it is defective in some way.','RAG'),(101,3,'Cost before charging',NULL,'Costs are incurred by the operator before product/service is accepted by customer and billing can commence.','RAG'),(102,3,'Cost with no charging',NULL,'Operator incurs costs of delivering services without any charging taking place.','RAG'),(104,3,'Over supply of resources',NULL,'Network resources are over provisioned for a particular product/service.','RAG'),(105,1,'Customers with lower margin than expected',NULL,'Based on their usage profiles, these customers do not deliver the expected/desired level of profit to the organisation.','RAG'),(106,10,'Revenue attributed to the wrong product/service',NULL,'Apportionment of revenue to component products and services are inaccurate.','RAG'),(107,10,'Costs attributed to the wrong product/service',NULL,'Apportionment of costs to component products and services are inaccurate.','RAG'),(108,1,'Maintenance costs higher than expected',NULL,'Costs of service assurance under estimated, or expected failure rates higher than forecast.','RAG'),(109,2,'Rebates higher than expected',NULL,'The level of rebates awarded in respect of customer complaints is higher than expected.','RAG'),(110,1,'Reference data is incorrect',NULL,'Reference data is complete or contains incorrect information.','RAG'),(111,1,'Reference data is out of date',NULL,'Reference data is not adequately maintained and the quality of this information declines over time.','RAG'),(112,5,'Billable data removed from billing chain',NULL,'BSS systems reject or suspend billing data as it does not conform to configured rules.','RAG'),(114,10,'Revenue incorrectly posted to general ledger',NULL,'Revenue information incorrectly handled by finance processes and wrong data entered into GL.','RAG'),(115,10,'Revenue not posted to general ledger',NULL,'Revenue information incorrectly handled by finance processes and data missing from GL.','RAG'),(116,10,'Annual report does accurately reflect the business',NULL,'Financial reporting errors lead to inaccurate annual report','RAG'),(117,7,'Incorrect charging of inbound roaming traffic',NULL,'Inbound roaming traffic mis-identified by billing system and not priced as roaming.','RAG'),(118,7,'Incomplete charging of inbound roaming traffic',NULL,'Inbound roaming traffic mis-handled by billing system so re-charging of this traffic is incomplete.','RAG'),(120,6,'Incorrect pricing of roaming traffic',NULL,'Outbound roaming traffic mis-handled by billing system so re-charging of this traffic is incomplete.','RAG'),(121,6,'Incorrect pricing of partner traffic',NULL,'Events rated on behalf of a third party are not calculated correctly, e.g. MVNO events on a host network.','RAG'),(122,6,'Inconnect pricing of roaming traffic',NULL,'*** NOT USED ***','RAG'),(123,4,'Calls not routed most cost effectively',NULL,'Route optimisation is nor performed or lags the traffic profiles.','RAG'),(124,4,'Overflow traffic higher than expected',NULL,'Traffic incorrectly passed to high cost routes or insufficient capacity for demand.','RAG'),(125,4,'Poor quality of services on chosen routes',NULL,'Traffic routing rules do not take the quality of service provided by third parties into account.','RAG'),(126,1,'Invalid products/services offered',NULL,'Incompatible or otherwise invalid service and feature combinations are offered.','RAG'),(127,1,'Offers include elements that cannot be implemented',NULL,'Services and features are offered that cannot be provided or have been decommissioned.','RAG'),(128,1,'Offers cannot deliver desired margin',NULL,'Margin analysis is inaccurate, resulting in a product offer than will never be able to expected marring, e.g. costs are higher than anticipated.','RAG'),(129,1,'Offer contains non-standard terms',NULL,'Customer offer contain terms and conditions outside of normal sales guidelines.','RAG'),(130,1,'Services cannot be used',NULL,'Service cannot be used as advertised','RAG'),(131,4,'Service not available',NULL,'Service not ready for use, or there is an outage.','RAG'),(132,4,'Service level agreement not achieved',NULL,'The service received by the customer does not meet or exceed SLAs in the contract.','RAG'),(133,3,'Service provided when it should not be',NULL,'Customer\'s account status should preclude access to service, e.g. a suspended customer.','RAG'),(134,3,'Service before charging',NULL,'Customer is provided with service before billing commences.','RAG'),(135,3,'Service with no charging',NULL,'Customer is provided with service but billing is not initiated.','RAG'),(136,3,'Service after cease',NULL,'Customer charging has stopped, but the customer can still use the service.','RAG'),(137,3,'Service level too high',NULL,'Customer has been provided with a higher level of service than expected.','RAG'),(138,3,'Service level too low',NULL,'Customer has been provided with a lower level of service than expected.','RAG'),(139,3,'Charging before service',NULL,'Customer billing starts before the service is provided.','RAG'),(140,3,'Charging with no service',NULL,'Customer billing starts but the service is never provided.','RAG'),(141,3,'Charging after cease',NULL,'Customer service is terminated but billing continues.','RAG'),(142,7,'Over charging for services provided',NULL,'Customer is charged more for the service provided/consumed than they should be.','RAG'),(143,7,'Under charging for services provided',NULL,'Customer is charged less for the service provided/consumed than they should be.','RAG'),(144,3,'Delay to service usage',NULL,'Customer cannot use service, or part of service, owing to missing operator supplied equipment, i.e. expected go-live date missed.','RAG'),(146,3,'Incorrect subscriptions',NULL,'Subscribers on an inappropriate product plan.','RAG'),(147,6,'Tariff definitions do not agree with contracts',NULL,'Tariff out of step with contract, e.g. dial plan may not match contract.','RAG'),(148,6,'Tariff definitions do not agree with published tariffs',NULL,'Tariff definition differ from published tariffs.','RAG'),(149,6,'Number plan configured incorrectly',NULL,'Dial strings do not correctly implement the local, national and/or national number plans.','RAG'),(150,6,'Customer dial-plan configured incorrectly',NULL,'Customer-specific dial plan has missing originations or destinations, e.g. closed user groups incorrectly defined etc.','RAG'),(151,6,'Failure to implement new destinations',NULL,'Dial strings for new destinations are not configured, resulting in an incomplete number plan being implemented.','RAG'),(152,6,'Subscription fees configured incorrectly ',NULL,'One off and recurring charges configured incorrectly, consequently they do not agree with published tariffs.','RAG'),(153,6,'Rate plans configured incorrectly',NULL,'Product pricing is not configured incorrectly, consequently does not agree with published tariffs.','RAG'),(154,6,'Discount plans configured incorrectly',NULL,'Product discounts are configured incorrectly, consequently they do not agree with published tariffs.','RAG'),(155,6,'Bulk changes to tariff plans not applied correctly',NULL,'Large-scale, automated changes to tariff definitions are not implemented correctly.','RAG'),(156,6,'Policy rules not configured correctly',NULL,'Fair usage policies are not configured correctly.','RAG'),(157,6,'Invalid offer definitions',NULL,'Customer offers assembled from incompatible service/tariff elements.','RAG'),(158,6,'Promotions do not agree with advertised offers',NULL,'Product promotions are configured incorrectly, consequently they do not agree with published tariffs.','RAG'),(160,3,'Service activation not as advertised',NULL,'Service activated, but does not match advertised product description.','RAG'),(161,6,'Processing costs higher than necessary',NULL,'Applying tariffs is more resource hungry than expected owing to non-optimised implementation.','RAG'),(162,5,'Incomplete recording of usage data',NULL,'Not all usage data is recorded by service nodes.','RAG'),(163,5,'Incorrect recording of usage data',NULL,'Usage data is not recorded accurately by the service node.','RAG'),(164,5,'Data loss',NULL,'Billable events are removed from the billing chain.','RAG'),(165,5,'Incorrect data preparation',NULL,'Data is not transformed correctly for a given billing process resulting in incorrect or incomplete charging.','RAG'),(167,5,'Data duplication',NULL,'Billable events are duplicated resulting in overcharging.','RAG'),(168,9,'Incorrect voucher management',NULL,'Top-up voucher management poor leading to incorrect amounts credited, or wrong accounts credited and other failures.','RAG'),(169,9,'Bulk vouchers not paid for',NULL,'Sales of vouchers in bulk to agents is not in accordance with business rules, e.g. vouchers dispatched before payment received.','RAG'),(170,9,'Pending credit too high',NULL,'Top-up events incorrectly shown as failed (pending) when the customer\'s account has actually been credited correctly. ','RAG'),(171,9,'Voucher stock too low',NULL,'Poor management of top-up voucher stocks restricts supply to customers.','RAG'),(172,8,'Reports do not agree with usage data and invoice',NULL,'Usage summary reports provided to partners do not match usage event data and/or invoices issued to them.','RAG'),(173,8,'Reseller traffic not passed correctly to third party',NULL,'Reseller traffic mishandled resulting in incomplete information passed to partner concerned or passed to the wrong third party.','RAG'),(174,8,'Wholesale recharges calculated incorrectly',NULL,'*** TO BE REMOVED ***','RAG'),(175,1,'Fines imposed by the regulator',NULL,'Telecoms regulator may fine operators if they operate outside of the terms and conditions of their operator\'s licence.','RAG'),(178,9,'Electronic vouchers not paid for',NULL,'Electronic top-up vouchers sold to customers via channel partners are not reported to the operator.','RAG'),(179,1,'Incorrect discount offered',NULL,'Discounts offered by commercial teams may not be in accordance with official price book and/or sales guidelines.','RAG'),(180,7,'Not all manual bills are being generated',NULL,'Manual billing is not performed.','RAG'),(181,4,'Fixed asset register not up-to-date',NULL,'The fixed asset register (FAR) does not accurately reflect the assets deployed by the organisation.','RAG'),(182,2,'Abuse/unauthorised use of services',NULL,'Customer are allowed to undertake unauthorised transactions or transactions that abuse service provided.','RAG'),(183,2,'Regulatory non-compliance',NULL,'Operation of mobile money services does not conform to regulatory requirements.','RAG');
/*!40000 ALTER TABLE `cvg_risk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cvg_risk_key_risk_area_link`
--

DROP TABLE IF EXISTS `cvg_risk_key_risk_area_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cvg_risk_key_risk_area_link` (
  `RISK_ID` int(11) NOT NULL,
  `KEY_RISK_AREA_ID` int(11) NOT NULL,
  UNIQUE KEY `UNIQUE` (`RISK_ID`,`KEY_RISK_AREA_ID`),
  KEY `fk_cvg_risk_key_risk_area_link_2_idx` (`KEY_RISK_AREA_ID`),
  CONSTRAINT `fk_cvg_risk_key_risk_area_link_1` FOREIGN KEY (`RISK_ID`) REFERENCES `cvg_risk` (`RISK_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cvg_risk_key_risk_area_link_2` FOREIGN KEY (`KEY_RISK_AREA_ID`) REFERENCES `cvg_key_risk_area` (`KEY_RISK_AREA_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_risk_key_risk_area_link`
--

LOCK TABLES `cvg_risk_key_risk_area_link` WRITE;
/*!40000 ALTER TABLE `cvg_risk_key_risk_area_link` DISABLE KEYS */;
INSERT INTO `cvg_risk_key_risk_area_link` VALUES (1,1),(181,1),(4,2),(5,2),(6,2),(7,2),(8,2),(180,2),(9,3),(10,3),(11,4),(12,4),(13,4),(14,4),(15,4),(16,4),(17,4),(18,4),(19,4),(20,5),(21,6),(22,6),(23,6),(24,6),(147,6),(179,6),(25,7),(26,7),(27,7),(28,8),(29,8),(30,8),(31,8),(81,8),(125,8),(23,9),(32,9),(33,9),(35,9),(37,9),(38,10),(39,10),(40,10),(51,11),(52,11),(53,12),(54,12),(55,12),(56,12),(182,13),(183,13),(61,14),(62,14),(63,14),(64,15),(65,15),(66,15),(67,15),(41,16),(42,16),(43,16),(46,16),(49,16),(50,16),(70,17),(71,17),(82,17),(168,17),(169,17),(170,17),(171,17),(178,17),(72,18),(73,18),(74,18),(75,18),(76,18),(77,18),(78,18),(79,18),(80,18),(83,19),(84,19),(85,19),(86,19),(87,19),(88,19),(89,19),(90,19),(91,19),(96,19),(120,19),(121,19),(92,20),(93,21),(94,21),(95,21),(97,22),(98,22),(99,22),(100,22),(157,22),(60,23),(68,23),(69,23),(101,23),(102,23),(104,23),(105,23),(106,23),(107,23),(108,23),(109,23),(123,23),(124,23),(175,23),(110,24),(111,24),(114,25),(115,25),(116,25),(126,26),(127,26),(128,26),(129,26),(130,27),(131,27),(132,27),(133,27),(134,28),(135,28),(136,28),(137,28),(138,28),(139,28),(140,28),(141,28),(142,28),(143,28),(144,28),(146,28),(148,29),(149,29),(150,29),(151,29),(152,29),(153,29),(154,29),(155,29),(156,29),(158,29),(160,29),(161,29),(112,30),(162,30),(163,30),(164,30),(165,30),(167,30);
/*!40000 ALTER TABLE `cvg_risk_key_risk_area_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cvg_risk_measure_link`
--

DROP TABLE IF EXISTS `cvg_risk_measure_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cvg_risk_measure_link` (
  `RISK_ID` int(11) NOT NULL,
  `MEASURE_ID` int(11) NOT NULL,
  UNIQUE KEY `UNIQUE` (`RISK_ID`,`MEASURE_ID`),
  KEY `fk_cvg_risk_measure_link_1_idx` (`RISK_ID`),
  KEY `fk_cvg_risk_measure_link_2_idx` (`MEASURE_ID`),
  CONSTRAINT `fk_cvg_risk_measure_link_1` FOREIGN KEY (`RISK_ID`) REFERENCES `cvg_risk` (`RISK_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cvg_risk_measure_link_2` FOREIGN KEY (`MEASURE_ID`) REFERENCES `cvg_measure` (`MEASURE_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_risk_measure_link`
--

LOCK TABLES `cvg_risk_measure_link` WRITE;
/*!40000 ALTER TABLE `cvg_risk_measure_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `cvg_risk_measure_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cvg_risk_node`
--

DROP TABLE IF EXISTS `cvg_risk_node`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cvg_risk_node` (
  `RISK_NODE_ID` int(11) NOT NULL AUTO_INCREMENT,
  `OPCO_ID` int(11) NOT NULL DEFAULT '36',
  `PRODUCT_SEGMENT_ID` int(11) NOT NULL,
  `RISK_ID` int(11) NOT NULL,
  `SYSTEM_ID` int(11) DEFAULT NULL,
  `COVERAGE` decimal(5,2) DEFAULT '0.00',
  `MEASURE_COVERAGE` decimal(5,2) DEFAULT '0.00',
  `COMMENT` text,
  `MODIFIED` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`RISK_NODE_ID`),
  UNIQUE KEY `UNIQUE` (`OPCO_ID`,`PRODUCT_SEGMENT_ID`,`RISK_ID`,`SYSTEM_ID`),
  KEY `fk_cvg_risk_node_1_idx` (`OPCO_ID`),
  KEY `fk_cvg_risk_node_2_idx` (`PRODUCT_SEGMENT_ID`),
  KEY `fk_cvg_risk_node_3_idx` (`RISK_ID`),
  KEY `fk_cvg_risk_node_4_idx` (`SYSTEM_ID`),
  CONSTRAINT `fk_cvg_risk_node_1` FOREIGN KEY (`OPCO_ID`) REFERENCES `amx_opco` (`OPCO_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cvg_risk_node_2` FOREIGN KEY (`PRODUCT_SEGMENT_ID`) REFERENCES `cvg_product_segment` (`PRODUCT_SEGMENT_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cvg_risk_node_3` FOREIGN KEY (`RISK_ID`) REFERENCES `cvg_risk` (`RISK_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cvg_risk_node_4` FOREIGN KEY (`SYSTEM_ID`) REFERENCES `amx_system` (`SYSTEM_ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_risk_node`
--

LOCK TABLES `cvg_risk_node` WRITE;
/*!40000 ALTER TABLE `cvg_risk_node` DISABLE KEYS */;
/*!40000 ALTER TABLE `cvg_risk_node` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`cvg_risk_node_BEFORE_UPDATE` BEFORE UPDATE ON `cvg_risk_node` FOR EACH ROW
BEGIN
	set new.MODIFIED = CURRENT_TIMESTAMP;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `cvg_risk_node_control`
--

DROP TABLE IF EXISTS `cvg_risk_node_control`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cvg_risk_node_control` (
  `RN_CONTROL_ID` int(11) NOT NULL AUTO_INCREMENT,
  `RISK_NODE_ID` int(11) NOT NULL,
  `CONTROL_ID` int(11) NOT NULL,
  `EFFECTIVENESS` decimal(5,2) DEFAULT '0.00',
  PRIMARY KEY (`RN_CONTROL_ID`),
  KEY `fk_cvg_risk_node_control_1_idx` (`RISK_NODE_ID`),
  KEY `fk_cvg_risk_node_control_2_idx` (`CONTROL_ID`),
  CONSTRAINT `fk_cvg_risk_node_control_1` FOREIGN KEY (`RISK_NODE_ID`) REFERENCES `cvg_risk_node` (`RISK_NODE_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cvg_risk_node_control_2` FOREIGN KEY (`CONTROL_ID`) REFERENCES `cvg_control` (`CONTROL_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_risk_node_control`
--

LOCK TABLES `cvg_risk_node_control` WRITE;
/*!40000 ALTER TABLE `cvg_risk_node_control` DISABLE KEYS */;
/*!40000 ALTER TABLE `cvg_risk_node_control` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`cvg_risk_node_control_AFTER_DELETE` AFTER DELETE ON `cvg_risk_node_control` FOR EACH ROW
BEGIN
	call cvgRefreshControlCoverage(old.CONTROL_ID);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `cvg_risk_node_control_measure_link`
--

DROP TABLE IF EXISTS `cvg_risk_node_control_measure_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cvg_risk_node_control_measure_link` (
  `RN_CONTROL_ID` int(11) NOT NULL,
  `MEASURE_ID` int(11) NOT NULL,
  KEY `fk_cvg_risk_node_control_measure_1_idx` (`RN_CONTROL_ID`),
  KEY `fk_cvg_risk_node_control_measure_2_idx` (`MEASURE_ID`),
  CONSTRAINT `fk_cvg_risk_node_control_measure_1` FOREIGN KEY (`RN_CONTROL_ID`) REFERENCES `cvg_risk_node_control` (`RN_CONTROL_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cvg_risk_node_control_measure_2` FOREIGN KEY (`MEASURE_ID`) REFERENCES `cvg_measure` (`MEASURE_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_risk_node_control_measure_link`
--

LOCK TABLES `cvg_risk_node_control_measure_link` WRITE;
/*!40000 ALTER TABLE `cvg_risk_node_control_measure_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `cvg_risk_node_control_measure_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cvg_risk_node_control_sub_risk_link`
--

DROP TABLE IF EXISTS `cvg_risk_node_control_sub_risk_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cvg_risk_node_control_sub_risk_link` (
  `RN_CONTROL_ID` int(11) NOT NULL,
  `RN_SUB_RISK_ID` int(11) NOT NULL,
  UNIQUE KEY `UNIQUE` (`RN_CONTROL_ID`,`RN_SUB_RISK_ID`),
  KEY `fk_cvg_risk_node_control_sub_risk_link_2_idx` (`RN_SUB_RISK_ID`),
  CONSTRAINT `fk_cvg_risk_node_control_sub_risk_link_1` FOREIGN KEY (`RN_CONTROL_ID`) REFERENCES `cvg_risk_node_control` (`RN_CONTROL_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cvg_risk_node_control_sub_risk_link_2` FOREIGN KEY (`RN_SUB_RISK_ID`) REFERENCES `cvg_risk_node_sub_risk` (`RN_SUB_RISK_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_risk_node_control_sub_risk_link`
--

LOCK TABLES `cvg_risk_node_control_sub_risk_link` WRITE;
/*!40000 ALTER TABLE `cvg_risk_node_control_sub_risk_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `cvg_risk_node_control_sub_risk_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cvg_risk_node_sub_risk`
--

DROP TABLE IF EXISTS `cvg_risk_node_sub_risk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cvg_risk_node_sub_risk` (
  `RN_SUB_RISK_ID` int(11) NOT NULL AUTO_INCREMENT,
  `RISK_NODE_ID` int(11) NOT NULL,
  `SUB_RISK_ID` int(11) NOT NULL DEFAULT '0',
  `LIKELIHOOD` int(11) NOT NULL DEFAULT '0',
  `IMPACT` int(11) NOT NULL DEFAULT '0',
  `COVERAGE` decimal(5,2) DEFAULT '0.00',
  `FIXED` varchar(1) DEFAULT 'N',
  PRIMARY KEY (`RN_SUB_RISK_ID`),
  UNIQUE KEY `UNIQUE` (`RISK_NODE_ID`,`SUB_RISK_ID`),
  KEY `fk_cvg_risk_node_sub_risk_2_idx` (`SUB_RISK_ID`),
  CONSTRAINT `fk_cvg_risk_node_sub_risk_1` FOREIGN KEY (`RISK_NODE_ID`) REFERENCES `cvg_risk_node` (`RISK_NODE_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cvg_risk_node_sub_risk_2` FOREIGN KEY (`SUB_RISK_ID`) REFERENCES `cvg_sub_risk` (`SUB_RISK_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_risk_node_sub_risk`
--

LOCK TABLES `cvg_risk_node_sub_risk` WRITE;
/*!40000 ALTER TABLE `cvg_risk_node_sub_risk` DISABLE KEYS */;
/*!40000 ALTER TABLE `cvg_risk_node_sub_risk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cvg_sub_risk`
--

DROP TABLE IF EXISTS `cvg_sub_risk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cvg_sub_risk` (
  `SUB_RISK_ID` int(11) NOT NULL AUTO_INCREMENT,
  `RISK_ID` int(11) NOT NULL,
  `SUB_RISK` text NOT NULL,
  `BASE_LIKELIHOOD` int(11) NOT NULL DEFAULT '1',
  `BASE_IMPACT` int(11) NOT NULL DEFAULT '1',
  `RELEVANT` varchar(1) NOT NULL DEFAULT 'Y',
  `REQUIRED` varchar(1) NOT NULL DEFAULT 'N',
  `SOURCE` enum('TMF','TAG','RAG') NOT NULL DEFAULT 'RAG',
  PRIMARY KEY (`SUB_RISK_ID`),
  KEY `fk_cvg_sub_risk_1_idx` (`RISK_ID`),
  CONSTRAINT `fk_cvg_sub_risk_1` FOREIGN KEY (`RISK_ID`) REFERENCES `cvg_risk` (`RISK_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=670 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_sub_risk`
--

LOCK TABLES `cvg_sub_risk` WRITE;
/*!40000 ALTER TABLE `cvg_sub_risk` DISABLE KEYS */;
INSERT INTO `cvg_sub_risk` VALUES (1,1,'Physical assets not returned to the free pool',1,1,'Y','N','RAG'),(2,1,'Logical assets not returned to the free pool',1,1,'Y','N','RAG'),(3,1,'Asset deployment not recorded in the inventory register',1,1,'Y','N','RAG'),(4,1,'Asset movement not recorded in the inventory register',1,1,'Y','N','RAG'),(5,1,'Partially provisioned assets',1,1,'Y','N','RAG'),(6,181,'Asset deployment is not reflected in the Fixed Asset Register',1,1,'Y','N','RAG'),(7,181,'Asset movement not reflected in the Fixed Asset Register',1,1,'Y','N','RAG'),(8,181,'Asset decommissioning not reflected in the Fixed Asset Register',1,1,'Y','N','RAG'),(10,4,'Invoice does not include initial set-up fees',1,1,'Y','N','RAG'),(11,4,'Invoice does not include all subscription charges',1,1,'Y','N','RAG'),(12,4,'Invoice does not include all usage charges',1,1,'Y','N','RAG'),(13,4,'Invoice does not include equipment charges',1,1,'Y','N','RAG'),(14,4,'Invoice does not include all discounts',1,1,'Y','N','RAG'),(15,4,'Invoice does not include all plan transition charges',1,1,'Y','N','RAG'),(16,4,'Invoice does not include all penalty charges',1,1,'Y','N','RAG'),(17,4,'Invoice does not include termination charges',1,1,'Y','N','RAG'),(18,4,'Incomplete processing of point of sales records',1,1,'Y','N','RAG'),(19,4,'Exceptional/one-off charges not billed ',1,1,'Y','N','RAG'),(20,4,'Billable events written off because they are too old to bill',1,1,'Y','N','RAG'),(22,5,'Multiple charging of the same chargeable event',1,1,'Y','N','RAG'),(23,5,'Invoice line items does not agree with invoice totals',1,1,'Y','N','RAG'),(24,5,'Incorrect crediting of failed services',1,1,'Y','N','RAG'),(25,5,'Incorrect interest calculation',1,1,'Y','N','RAG'),(26,5,'Incorrect currency conversion',1,1,'Y','N','RAG'),(27,5,'Incorrect calculation of taxes',1,1,'Y','N','RAG'),(28,5,'Incorrect manual billing adjustments',1,1,'Y','N','RAG'),(29,5,'Customer deposit not credited to any bill',1,1,'Y','N','RAG'),(30,5,'New home owner inherits free usage after employee moves home',1,1,'Y','N','RAG'),(31,5,'Customer reference data missing from rating engine',1,1,'Y','N','RAG'),(32,180,'Not all customers with manual billing requirements have been identified',1,1,'Y','N','RAG'),(34,180,'Delay to start of manual billing process',1,1,'Y','N','RAG'),(35,6,'Human errors with pricing for manual billing process',1,1,'Y','N','RAG'),(36,6,'Manual billing team not informed of changes that affect billing',1,1,'Y','N','RAG'),(37,7,'Aggregate-based discounts not calculated correctly',1,1,'Y','N','RAG'),(38,7,'Multiple discounts applied for the same chargeable event(s)',1,1,'Y','N','RAG'),(39,7,'Special pricing given after customer ceases to qualify',1,1,'Y','N','RAG'),(40,7,'Account hierarchy discounts not applied correctly',1,1,'Y','N','RAG'),(41,8,'Invoice not produced',1,1,'Y','N','RAG'),(42,8,'Print shop does not receive all bills for printing/distribution',1,1,'Y','N','RAG'),(43,8,'Invoice sent to wrong address',1,1,'Y','N','RAG'),(44,8,'Incomplete/inaccurate customer information',1,1,'Y','N','RAG'),(46,9,'PBX by-pass',1,1,'Y','N','RAG'),(47,9,'SIM Boxing',1,1,'Y','N','RAG'),(48,9,'Calling card by-pass',1,1,'Y','N','RAG'),(49,10,'OTT Services',1,1,'Y','N','RAG'),(56,11,'Prepaid service allowed with zero/negative balance',1,1,'Y','N','RAG'),(57,11,'Concurrent real-time charging loss',1,1,'Y','N','RAG'),(58,11,'Chargeable plan transitions not charged',1,1,'Y','N','RAG'),(59,11,'Prepaid credit does not expire as expected',1,1,'Y','N','RAG'),(60,11,'Ported-in numbers not charged',1,1,'Y','N','RAG'),(61,11,'Installation fees not charged',1,1,'Y','N','RAG'),(62,11,'Early termination fees not charged',1,1,'Y','N','RAG'),(63,11,'Reconnection fee not charged',1,1,'Y','N','RAG'),(64,11,'Incorrect employee salary deduction ',1,1,'Y','N','RAG'),(65,11,'Prepaid service not terminated when balance reaches minimum balance threshold',1,1,'Y','N','RAG'),(66,11,'Automatic prepaid recharges not applied correctly',1,1,'Y','N','RAG'),(67,11,'Credit does not expire at correct point in time',1,1,'Y','N','RAG'),(68,12,'Customers charged more than once for the same event',1,1,'Y','N','RAG'),(69,12,'Unchangeable plan transitions are charged',1,1,'Y','N','RAG'),(70,12,'Undelivered SMS are charged',1,1,'Y','N','RAG'),(71,12,'Ported-out number still charged',1,1,'Y','N','RAG'),(72,12,'Early termination fees incorrectly charged',1,1,'Y','N','RAG'),(73,12,'Incorrect employee salary deduction ',1,1,'Y','N','RAG'),(74,13,'Incorrect prepaid dedicated account credited/debited',1,1,'Y','N','RAG'),(75,13,'No prepaid account debited for priced event',1,1,'Y','N','RAG'),(76,13,'Inconsistent rates between different charging platforms',1,1,'Y','N','RAG'),(77,19,'Service registration fees not charged',1,1,'Y','N','RAG'),(78,19,'Service registration fees not charged at correct price',1,1,'Y','N','RAG'),(79,19,'Service registration renewal fees not charged',1,1,'Y','N','RAG'),(80,19,'Service registration renewal fees not charged at correct price',1,1,'Y','N','RAG'),(81,20,'Commission paid more than once',1,1,'Y','N','RAG'),(82,20,'Commission clawback for cancelled contracts not invoked',1,1,'Y','N','RAG'),(83,22,'Discount applied even though minimum holding not achieved',1,1,'Y','N','RAG'),(84,22,'Discount applied even though minimum holding period not achieved',1,1,'Y','N','RAG'),(85,22,'Penalty charge not applied even though minimum holding period not achieved',1,1,'Y','N','RAG'),(86,22,'Discount applied even though minimum spend not achieved',1,1,'Y','N','RAG'),(87,22,'Standard pricing not applied when contract not resigned',1,1,'Y','N','RAG'),(88,22,'Periodic price increases not applied at end of the minimum contract period',1,1,'Y','N','RAG'),(89,23,'Return of equipment at end of contract not requested',1,1,'Y','N','RAG'),(90,23,'Equipment not returned at end of contract',1,1,'Y','N','RAG'),(91,24,'Contracts missing from contract database',1,1,'Y','N','RAG'),(92,24,'Contract database does not contain latest versions of all contracts',1,1,'Y','N','RAG'),(93,25,'Credit scoring rules too strong',1,1,'Y','N','RAG'),(94,26,'Credit scoring rules not strong enough',1,1,'Y','N','RAG'),(95,26,'Credit scoring not performed',1,1,'Y','N','RAG'),(96,26,'Customer group not subject to credit checking',1,1,'Y','N','RAG'),(97,26,'Roaming allowed without checks/deposit',1,1,'Y','N','RAG'),(98,27,'Back billing of unbilled charges regarded as bad debt',1,1,'Y','N','RAG'),(99,30,'Delay to service activation',1,1,'Y','N','RAG'),(100,32,'Handset activated on the wrong product type/service class',1,1,'Y','N','RAG'),(101,32,'Stock requisition form can be used more than once',1,1,'Y','N','RAG'),(102,23,'Equipment not returned at end of contract',1,1,'Y','N','RAG'),(103,32,'Hardware subsidy not recovered',1,1,'Y','N','RAG'),(104,32,'Wrong equipment delivered',1,1,'Y','N','RAG'),(105,32,'Equipment delivered to the wrong address',1,1,'Y','N','RAG'),(106,32,'Defective equipment returned for replacement',1,1,'Y','N','RAG'),(107,33,'Stock levels too high',1,1,'Y','N','RAG'),(108,33,'Stock levels too low',1,1,'Y','N','RAG'),(109,35,'More units despatched than required',1,1,'Y','N','RAG'),(110,35,'Reconnecting customers sent new equipment when should reuse existing',1,1,'Y','N','RAG'),(111,35,'Replacement equipment provides better service than required',1,1,'Y','N','RAG'),(112,23,'Return of equipment not requested',1,1,'Y','N','RAG'),(113,37,'Incorrect equipment charges',1,1,'Y','N','RAG'),(114,37,'Equipment charges lower than cost price',1,1,'Y','N','RAG'),(115,37,'VAT inclusive price advertised without VAT ',1,1,'Y','N','RAG'),(116,37,'Equipment charges not applied to corporate account',1,1,'Y','N','RAG'),(117,38,'Bulk SMS A2P traffic from unknown SMSC',1,1,'Y','N','RAG'),(118,38,'Bulk SMS A2P traffic from non-chargeable partners',1,1,'Y','N','RAG'),(119,38,'Bulk SMS A2P traffic sent as P2P',1,1,'Y','N','RAG'),(120,38,'SMS incorrectly identified as inbound roamer traffic',1,1,'Y','N','RAG'),(121,38,'SMS firewall configuration incorrect ',1,1,'Y','N','RAG'),(122,38,'SMS firewall not configured against all Gateway MSCs',1,1,'Y','N','RAG'),(123,38,'SMS traffic bypasses firewall by using internal GTs',1,1,'Y','N','RAG'),(124,38,'SMS domestic SIM Boxes used to send bulk traffic',1,1,'Y','N','RAG'),(125,39,'SMS traffic delivered from false SMSC address',1,1,'Y','N','RAG'),(126,39,'SMS traffic delivered from SMSC not matching origin',1,1,'Y','N','RAG'),(127,39,'Domestic SMS traffic routed from international origin',1,1,'Y','N','RAG'),(128,40,'SMS firewall does not recognise phishing messages',1,1,'Y','N','RAG'),(129,40,'Phishing SMS originating from non controlled or whitelisted sources',1,1,'Y','N','RAG'),(130,41,'Recording of outgoing traffic not configured for all external routes',1,1,'Y','N','RAG'),(133,41,'Outgoing traffic on incoming routes',1,1,'Y','N','RAG'),(134,42,'Recording of incoming traffic not configured for all external routes',1,1,'Y','N','RAG'),(137,42,'Incoming traffic on outgoing routes',1,1,'Y','N','RAG'),(146,43,'Invoices received from partners not checked for accuracy of traffic figures',1,1,'Y','N','RAG'),(147,43,'Invoices received from partners not check for pricing accuracy',1,1,'Y','N','RAG'),(148,91,'Reverse charging rules for partner traffic not implemented correctly',1,1,'Y','N','RAG'),(151,46,'Traffic routing error causes discounted rate not to be reached',1,1,'Y','N','RAG'),(152,89,'Partner volume discounts applied incorrectly',1,1,'Y','N','RAG'),(153,91,'Wrong partner is charged',1,1,'Y','N','RAG'),(154,46,'Penalty rate incurred as volume commitment not met',1,1,'Y','N','RAG'),(155,49,'Differential tariffs exploited by another operator',1,1,'Y','N','RAG'),(156,49,'Traffic mix does not reflect blended rates',1,1,'Y','N','RAG'),(157,50,'Traffic is disguised in order to achieve a lower service fee',1,1,'Y','N','RAG'),(158,51,'Customers not removed from loyalty system at end of contract',1,1,'Y','N','RAG'),(159,52,'Loyalty points do not expire when expected',1,1,'Y','N','RAG'),(160,53,'Inaccurate sales and marketing communications',1,1,'Y','N','RAG'),(161,53,'Unauthorised changes to the product catalogue',1,1,'Y','N','RAG'),(162,54,'Marketing & sales out of step with system development',1,1,'Y','N','RAG'),(163,54,'Deficiency in product development lifecycle',1,1,'Y','N','RAG'),(164,50,'Partner uses wrong interconnect route for the class of traffic delivered',1,1,'Y','N','RAG'),(165,55,'Costs of operating sales campaign higher than expected',1,1,'Y','N','RAG'),(166,55,'Customer take-up of offer lower than expected',1,1,'Y','N','RAG'),(167,55,'Reconnection campaign waives existing debt',1,1,'Y','N','RAG'),(168,56,'Dormant accounts not deactivated',1,1,'Y','N','RAG'),(169,56,'Expired accounts not deactivated',1,1,'Y','N','RAG'),(170,56,'Artificial inflation of customer numbers',1,1,'Y','N','RAG'),(171,61,'Partner subscriber is wrongly provisioned as own subscriber',1,1,'Y','N','RAG'),(172,61,'Partner network porting process failures',1,1,'Y','N','RAG'),(173,121,'Incorrect partner rates applied',1,1,'Y','N','RAG'),(174,121,'Partner traffic not identified as such by pricing systems',1,1,'Y','N','RAG'),(175,41,'Partner traffic is removed from the settlement process',1,1,'Y','N','RAG'),(176,154,'Partner volume discounts incorrectly configured',1,1,'Y','N','RAG'),(177,121,'Partner mobile terminating traffic not billed',1,1,'Y','N','RAG'),(178,121,'Partner Voicemail traffic not billed',1,1,'Y','N','RAG'),(179,43,'Partner subscriber count incorrectly calculated',1,1,'Y','N','RAG'),(180,153,'Partner rate plans incorrectly configured',1,1,'Y','N','RAG'),(181,43,'Incorrect per subscriber service fees applied',1,1,'Y','N','RAG'),(182,61,'Partner disconnects not recognised',1,1,'Y','N','RAG'),(184,60,'Commercial contracts do not recover cost of providing partner services',1,1,'Y','N','RAG'),(185,60,'Blended usage rates set too low ',1,1,'Y','N','RAG'),(186,61,'Partner\'s customers denied services due to service profile set-ups',1,1,'Y','N','RAG'),(187,61,'Partner\'s customers provided services reserved for host',1,1,'Y','N','RAG'),(188,62,'Service allowed for post-paid subscribers when credit limit exceeded',1,1,'Y','N','RAG'),(189,62,'Service allowed for prepaid subscribers with zero/negative balance',1,1,'Y','N','RAG'),(190,62,'Service usage from unknown subscribers',1,1,'Y','N','RAG'),(191,62,'Inbound roaming from foreign networks without a roaming agreement',1,1,'Y','N','RAG'),(192,62,'Calls allowed to unallocated number ranges',1,1,'Y','N','RAG'),(193,62,'Signalling abuse by other networks',1,1,'Y','N','RAG'),(194,63,'Network barred destinations not implemented',1,1,'Y','N','RAG'),(195,64,'Over allocation of number ranges to customers',1,1,'Y','N','RAG'),(196,64,'Over allocation of number ranges to channels',1,1,'Y','N','RAG'),(197,64,'Over allocation of number ranges to third parties',1,1,'Y','N','RAG'),(198,64,'Over allocation of static number ranges to products/services',1,1,'Y','N','RAG'),(199,64,'Over allocation of restricted numbers',1,1,'Y','N','RAG'),(200,64,'Over allocation of voice mail numbers',1,1,'Y','N','RAG'),(201,64,'Over allocation of test numbers',1,1,'Y','N','RAG'),(202,64,'Numbers allocated in ranges rather than individually',1,1,'Y','N','RAG'),(203,65,'Assigned numbers not prepared in the network',1,1,'Y','N','RAG'),(204,65,'Numbers prepared for allocation are not allocated to a channel or third party',1,1,'Y','N','RAG'),(205,65,'Allocated numbers not activated',1,1,'Y','N','RAG'),(206,65,'Number allocation to redundant channels/third parties',1,1,'Y','N','RAG'),(207,65,'Reserved numbers not used',1,1,'Y','N','RAG'),(208,67,'Numbers associated with failed/cancelled orders not re-used',1,1,'Y','N','RAG'),(209,66,'Quarantine period too long',1,1,'Y','N','RAG'),(210,67,'Failure in recycling process causes delay to number re-use',1,1,'Y','N','RAG'),(211,67,'Disconnected numbers not triggering the recycling process',1,1,'Y','N','RAG'),(213,67,'Expired preactivated numbers not recycled',1,1,'Y','N','RAG'),(214,67,'Dormant numbers not recycled',1,1,'Y','N','RAG'),(215,67,'Repatriated ported numbers not reallocated',1,1,'Y','N','RAG'),(217,68,'Premium rate numbers not linked to billing accounts',1,1,'Y','N','RAG'),(218,69,'Incorrect rate used for calculating out payment',1,1,'Y','N','RAG'),(219,69,'Subscribers undercharged for revenue share products',1,1,'Y','N','RAG'),(220,69,'Settlement of revenue share products exceeds subscriber usage',1,1,'Y','N','RAG'),(221,69,'Declaration by service provider does not agree with own traffic statistics',1,1,'Y','N','RAG'),(222,70,'Cash collection process failure',1,1,'Y','N','RAG'),(223,70,'Aged debt process not trigged',1,1,'Y','N','RAG'),(224,70,'Dunning letters not generated for part-paid invoices',1,1,'Y','N','RAG'),(225,72,'Subscriber missing from FUP management platform',1,1,'Y','N','RAG'),(226,72,'Product/service not linked to fair use policy',1,1,'Y','N','RAG'),(227,72,'FUP Provisioning transaction failure',1,1,'Y','N','RAG'),(228,72,'FUP Provisioned to wrong FUP platform ',1,1,'Y','N','RAG'),(229,72,'Fair use policy definition missing',1,1,'Y','N','RAG'),(230,72,'FUP platform overloaded/congested allowing free-flow',1,1,'Y','N','RAG'),(231,73,'FUP limit in FUP management platform less than expected',1,1,'Y','N','RAG'),(232,73,'FUP period in FUP management platform shorter than expected',1,1,'Y','N','RAG'),(233,74,'FUP limit in FUP management platform greater than expected',1,1,'Y','N','RAG'),(234,74,'FUP period in FUP management platform longer than expected',1,1,'Y','N','RAG'),(235,75,'Downlink/uplink speeds before FUP limit too high',1,1,'Y','N','RAG'),(236,75,'Downlink/uplink speeds before FUP limit too low',1,1,'Y','N','RAG'),(237,75,'Downlink/uplink speeds after FUP limit too high',1,1,'Y','N','RAG'),(238,75,'Downlink/uplink speeds after FUP limit too low',1,1,'Y','N','RAG'),(239,76,'Fair usage policy not altered on change of tariff plan',1,1,'Y','N','RAG'),(240,73,'Policy applied to non-chargeable/exempt traffic types',1,1,'Y','N','RAG'),(241,74,'Usage incorrectly tagged as inclusive',1,1,'Y','N','RAG'),(242,76,'Billing system bills traffic per Mb when should be policy controlled as a FUP ',1,1,'Y','N','RAG'),(243,77,'Tariff/Product applies invalid fair use policy',1,1,'Y','N','RAG'),(244,77,'Tariff/Product applies incorrect fair use policy',1,1,'Y','N','RAG'),(245,77,'Tariff/Product combination does not match fair use policy',1,1,'Y','N','RAG'),(246,73,'Traffic mis-classified for accounting and fair usage purposes',1,1,'Y','N','RAG'),(247,74,'Data usage not calculated correctly',1,1,'Y','N','RAG'),(248,79,'Monthly pass limits not applied',1,1,'Y','N','RAG'),(249,79,'Daily pass limits not applied',1,1,'Y','N','RAG'),(250,80,'Billing system does not receive the correct pass/bundle usage counts',1,1,'Y','N','RAG'),(251,80,'Multiple passes in day/month not recognised',1,1,'Y','N','RAG'),(252,81,'Warning messages not triggered',1,1,'Y','N','RAG'),(253,81,'Warning messages not sent',1,1,'Y','N','RAG'),(254,81,'Warning messages contain incorrect information',1,1,'Y','N','RAG'),(255,81,'Warning message sent too late',1,1,'Y','N','RAG'),(256,78,'URL mis-classified for barred usage',1,1,'Y','N','RAG'),(257,78,'URL filters not provisioned for customer',1,1,'Y','N','RAG'),(258,75,'Policy configuration treats Roaming traffic as Domestic',1,1,'Y','N','RAG'),(259,75,'MCC-MNC mis-configured',1,1,'Y','N','RAG'),(260,75,'MCC-MNC missing from configuration',1,1,'Y','N','RAG'),(261,75,'SGSN IP addresses mis-configured (operator traffic in wrong origin zone)',1,1,'Y','N','RAG'),(262,75,'SGSN IP addresses missing (default treatment applied)',1,1,'Y','N','RAG'),(263,73,'Usage double counted ',1,1,'Y','N','RAG'),(264,96,'Charging interval is calculated incorrectly',1,1,'Y','N','RAG'),(265,84,'Call set up/connection fees not charged',1,1,'Y','N','RAG'),(266,84,'Call set up/connection fees charged are charged more than once',1,1,'Y','N','RAG'),(267,84,'Stepped pricing plan not implemented correctly',1,1,'Y','N','RAG'),(268,84,'Tiered pricing plan not implemented correctly',1,1,'Y','N','RAG'),(269,84,'Jersey, Guernsey & Isle of Man over-charged',1,1,'Y','N','RAG'),(270,146,'New tariff introduced without customer being aware',1,1,'Y','N','RAG'),(271,84,'Events not rated in accordance with price book/contract',1,1,'Y','N','RAG'),(272,84,'Events deliberately over-priced',1,1,'Y','N','RAG'),(273,84,'Incorrect apportionment of charges between time bands',1,1,'Y','N','RAG'),(274,84,'Local services charged at national rates',1,1,'Y','N','RAG'),(275,84,'National services priced at local rates',1,1,'Y','N','RAG'),(276,84,'Normal services charged at premium rates',1,1,'Y','N','RAG'),(277,84,'Incorrect pricing of call forwarding events',1,1,'Y','N','RAG'),(278,83,'Premium rate services charged at free-phone rates',1,1,'Y','N','RAG'),(279,90,'Incorrect rounding of billing units',1,1,'Y','N','RAG'),(280,96,'Duraton/volume calculated incorrectly',1,1,'Y','N','RAG'),(281,83,'Voicemail call back not charged',1,1,'Y','N','RAG'),(282,84,'Incorrect mark-up of pre-rated events',1,1,'Y','N','RAG'),(283,84,'Premium services charged at normal rates',1,1,'Y','N','RAG'),(284,84,'International services charged at national rates',1,1,'Y','N','RAG'),(285,90,'Event charge rounding error',1,1,'Y','N','RAG'),(286,83,'Default rate applied',1,1,'Y','N','RAG'),(287,83,'Call forwarding not charged',1,1,'Y','N','RAG'),(288,83,'Premium rate numbers not linked to billing accounts',1,1,'Y','N','RAG'),(289,84,'Incorrect distance-based pricing',1,1,'Y','N','RAG'),(290,84,'Application of minimum charges not correct',1,1,'Y','N','RAG'),(291,84,'Application of maximum charges not correct',1,1,'Y','N','RAG'),(292,84,'Dynamic discounting applied incorrectly',1,1,'Y','N','RAG'),(293,83,'Calling card platform gives free usage to some destinations',1,1,'Y','N','RAG'),(294,83,'Barred numbers allowed',1,1,'Y','N','RAG'),(295,84,'Incorrect over-ride pricing implemented',1,1,'Y','N','RAG'),(296,85,'VPN on-net services charged at VPN off-net rates',1,1,'Y','N','RAG'),(297,85,'VPN off-net services charged at on-VPN rates',1,1,'Y','N','RAG'),(298,85,'Network short codes in dial plan',1,1,'Y','N','RAG'),(299,85,'Normal numbers are charged as DDI numbers',1,1,'Y','N','RAG'),(300,85,'DDI numbers charged at out of plan rates',1,1,'Y','N','RAG'),(301,85,'Mobiles charged at out of plan rates',1,1,'Y','N','RAG'),(302,85,'Land to mobile calls not charged',1,1,'Y','N','RAG'),(303,85,'Handset linked to wrong corporate account',1,1,'Y','N','RAG'),(304,85,'Special pricing applied when minimum spend not achieved',1,1,'Y','N','RAG'),(305,86,'On-line charging platform not triggered',1,1,'Y','N','RAG'),(306,86,'Zero rated chargeable event',1,1,'Y','N','RAG'),(307,86,'Maintenance window for on-line charging platform gives free usage',1,1,'Y','N','RAG'),(308,86,'Overload of on-line charging platform results in free usage',1,1,'Y','N','RAG'),(309,86,'Short duration events not billed',1,1,'Y','N','RAG'),(310,86,'Customer reference data missing from pricing engine',1,1,'Y','N','RAG'),(311,86,'Orphaned child accounts',1,1,'Y','N','RAG'),(312,87,'Excess (out of bundle) charges not applied when bundle exhausted',1,1,'Y','N','RAG'),(313,87,'Excess (out of bundle) charges applied even though bundle purchased',1,1,'Y','N','RAG'),(314,87,'Bundle charges applied when no bundle purchased',1,1,'Y','N','RAG'),(315,87,'Inclusive services are charged',1,1,'Y','N','RAG'),(316,87,'Exclusive services are not charged',1,1,'Y','N','RAG'),(317,87,'Carry over not implemented',1,1,'Y','N','RAG'),(318,87,'Carry-over cap exceeded',1,1,'Y','N','RAG'),(319,88,'Change of tariff plan mid-billing cycle not pro-rated correctly',1,1,'Y','N','RAG'),(320,88,'Service add-on mid-billing cycle not pro-rated correctly',1,1,'Y','N','RAG'),(321,89,'Incorrect processing of shared plans',1,1,'Y','N','RAG'),(322,89,'Tariff-based event discounts not applied correctly',1,1,'Y','N','RAG'),(323,89,'Subscriber-based event discounts not applied correctly',1,1,'Y','N','RAG'),(324,89,'Discounts applied to the wrong agreement/account',1,1,'Y','N','RAG'),(325,89,'Multiple mutually exclusive discounts applied to the same account',1,1,'Y','N','RAG'),(326,91,'Incorrect apportionment of shared rated calls',1,1,'Y','N','RAG'),(327,92,'Business process flow not documented',1,1,'Y','N','RAG'),(328,92,'No definition of the business process',1,1,'Y','N','RAG'),(329,92,'Lack of standard operating procedures',1,1,'Y','N','RAG'),(330,92,'Unstructured data exchange between teams involved in the process',1,1,'Y','N','RAG'),(331,92,'Uncontrolled information used by the business process',1,1,'Y','N','RAG'),(332,92,'Lack of workflow support for the business process',1,1,'Y','N','RAG'),(333,92,'Lack of knowledge of personnel involved in business process',1,1,'Y','N','RAG'),(334,92,'No induction training for new employees',1,1,'Y','N','RAG'),(335,92,'Undocumented business rules',1,1,'Y','N','RAG'),(336,92,'Uncoordinated changes to business processes',1,1,'Y','N','RAG'),(337,92,'High level of manual tasks',1,1,'Y','N','RAG'),(338,92,'Lack of involvement of RA staff in key business processes',1,1,'Y','N','RAG'),(339,92,'Lack of primary controls',1,1,'Y','N','RAG'),(340,92,'Lack of secondary control',1,1,'Y','N','RAG'),(341,93,'Mismatch between purchasing and sales of third party resources',1,1,'Y','N','RAG'),(342,93,'Third party services continue to be purchased after customer order cancelled',1,1,'Y','N','RAG'),(343,93,'Overestimated sales forecast',1,1,'Y','N','RAG'),(344,95,'Delay to cancellation of third party services',1,1,'Y','N','RAG'),(346,95,'Negotiated rates ignored by supplier',1,1,'Y','N','RAG'),(347,95,'Charges for third party services that have been cancelled',1,1,'Y','N','RAG'),(348,97,'Services fee higher than retail charge',1,1,'Y','N','RAG'),(349,94,'Underestimated sales forecast',1,1,'Y','N','RAG'),(350,98,'Product/service not easy to use',1,1,'Y','N','RAG'),(351,98,'Lack of demand',1,1,'Y','N','RAG'),(352,98,'Poor quality of service',1,1,'Y','N','RAG'),(353,99,'New product launched without the ability to generate bills',1,1,'Y','N','RAG'),(354,99,'New product launched without the ability to deliver all services and features',1,1,'Y','N','RAG'),(355,99,'Product offers assembled from incompatible tariff components',1,1,'Y','N','RAG'),(356,100,'Inadequate testing of service',1,1,'Y','N','RAG'),(357,100,'Inadequate testing of charging and billing',1,1,'Y','N','RAG'),(358,101,'Delay to order fulfilment incurs third party costs',1,1,'Y','N','RAG'),(359,101,'Early service provisioning incurs third party costs',1,1,'Y','N','RAG'),(360,102,'Order fulfilled but no billing account created',1,1,'Y','N','RAG'),(361,102,'RIM service charge continue after subscriber contract ends',1,1,'Y','N','RAG'),(362,102,'Hosting costs of redundant assets',1,1,'Y','N','RAG'),(363,102,'Hosting costs of unused assets',1,1,'Y','N','RAG'),(364,104,'Over provisioning of network resources',1,1,'Y','N','RAG'),(365,105,'Traffic mix not as expected',1,1,'Y','N','RAG'),(366,105,'Full implementation costs not included in commercial deal',1,1,'Y','N','RAG'),(367,105,'Special pricing outside of normal guidelines',1,1,'Y','N','RAG'),(368,105,'Incorrect/inappropriate use of hardware fund',1,1,'Y','N','RAG'),(369,105,'Overspending hardware fund',1,1,'Y','N','RAG'),(370,106,'Incorrect revenue mapping in billing system',1,1,'Y','N','RAG'),(371,106,'Incorrect revenue mapping by manual billing processes',1,1,'Y','N','RAG'),(372,106,'Incorrect revenue recognition process within Finance Operations',1,1,'Y','N','RAG'),(373,106,'Revenue attributed to default GL accounts',1,1,'Y','N','RAG'),(374,107,'Incorrect cost mapping in billing system',1,1,'Y','N','RAG'),(375,107,'Incorrect cost mapping by manual billing processes',1,1,'Y','N','RAG'),(376,107,'Incorrect cost recognition process within Finance Operations',1,1,'Y','N','RAG'),(377,107,'Costs attributed to default GL accounts',1,1,'Y','N','RAG'),(378,108,'Higher level of equipment failures than expected',1,1,'Y','N','RAG'),(379,108,'Unnecessary call outs',1,1,'Y','N','RAG'),(380,108,'Chargeable call-outs not charged/charged incorrectly',1,1,'Y','N','RAG'),(381,175,'Auto-compensation for service unavailability',1,1,'Y','N','RAG'),(382,175,'Fine imposed for billing complaints',1,1,'Y','N','RAG'),(383,175,'Fine for over stating customer numbers',1,1,'Y','N','RAG'),(384,109,'Poor quality of service',1,1,'Y','N','RAG'),(385,109,'Rebates for customer complaints given too readily',1,1,'Y','N','RAG'),(386,109,'Rebates given for unsubstantiated complaints',1,1,'Y','N','RAG'),(387,109,'Rebates given to repeat complainants',1,1,'Y','N','RAG'),(388,109,'Penalty payments for SLA violations higher than expected',1,1,'Y','N','RAG'),(389,109,'Rebate value exceeds guidelines',1,1,'Y','N','RAG'),(390,111,'Owner of the master version of the reference data not known',1,1,'Y','N','RAG'),(391,110,'More than one source of the reference data is available',1,1,'Y','N','RAG'),(392,110,'Local copy of reference data maintained independently of master data',1,1,'Y','N','RAG'),(393,111,'Management of reference data is not subject to version control',1,1,'Y','N','RAG'),(394,111,'Changes to reference data not disseminated to all interested parties',1,1,'Y','N','RAG'),(395,164,'Billable events removed from the billing chain',1,1,'Y','N','RAG'),(396,164,'Rejected event records not inspected before deletion',1,1,'Y','N','RAG'),(397,91,'Calling party charged for reverse charge services ',1,1,'Y','N','RAG'),(408,114,'Error in chart of accounts',1,1,'Y','N','RAG'),(409,114,'Revenue posted to error/suspense account',1,1,'Y','N','RAG'),(415,43,'Charging data exchanged with partners is rejected',1,1,'Y','N','RAG'),(417,43,'Charging data received from partners is incomplete',1,1,'Y','N','RAG'),(423,123,'High cost routes used when lower cost routes available',1,1,'Y','N','RAG'),(424,123,'Discount rates not achieved',1,1,'Y','N','RAG'),(425,123,'Volume agreements not met',1,1,'Y','N','RAG'),(426,124,'Traffic incorrectly routed',1,1,'Y','N','RAG'),(427,124,'Insufficient network capacity',1,1,'Y','N','RAG'),(428,124,'Network congestion',1,1,'Y','N','RAG'),(429,125,'Route selection ignores quality of service',1,1,'Y','N','RAG'),(430,125,'SLA not met by supplier',1,1,'Y','N','RAG'),(431,126,'Lack of knowledge of product portfolio',1,1,'Y','N','RAG'),(432,99,'Product offers assembled from incompatible service components',1,1,'Y','N','RAG'),(433,126,'Service dependencies not included',1,1,'Y','N','RAG'),(434,126,'Withdrawn product continues to be sold',1,1,'Y','N','RAG'),(435,127,'Offered service does not exist',1,1,'Y','N','RAG'),(436,127,'Offered service has been decommissioned',1,1,'Y','N','RAG'),(437,127,'Offered pricing cannot be implemented',1,1,'Y','N','RAG'),(438,127,'Offered discounts cannot be implemented',1,1,'Y','N','RAG'),(439,128,'Discounts exceed commercial guidelines',1,1,'Y','N','RAG'),(440,128,'Customer over subsidised by business development fund',1,1,'Y','N','RAG'),(441,128,'Exploitation of sales incentive schemes',1,1,'Y','N','RAG'),(442,128,'Full implementation cost not taken into account',1,1,'Y','N','RAG'),(443,129,'Customer agreement entered into without internal approval',1,1,'Y','N','RAG'),(444,130,'Product offers assembled from incompatible tariff components',1,1,'Y','N','RAG'),(445,131,'Service outage',1,1,'Y','N','RAG'),(446,131,'Primary subscription disconnected for sharing services ',1,1,'Y','N','RAG'),(447,132,'Time to connect not achieved',1,1,'Y','N','RAG'),(448,132,'Quality of service not delivered',1,1,'Y','N','RAG'),(449,132,'Data uplink speed not delivered',1,1,'Y','N','RAG'),(450,132,'Data downlink speed not delivered',1,1,'Y','N','RAG'),(451,133,'Service provided on a suspended account',1,1,'Y','N','RAG'),(452,133,'Service provided when credit limit exceeded',1,1,'Y','N','RAG'),(453,134,'Delay to creating billing account',1,1,'Y','N','RAG'),(454,134,'Customer go-live date not communicated to billing team',1,1,'Y','N','RAG'),(455,135,'Order fulfilled but no billing account created',1,1,'Y','N','RAG'),(456,135,'Provided features not billed',1,1,'Y','N','RAG'),(457,136,'Service deactivation process failed but billing ceased',1,1,'Y','N','RAG'),(458,137,'Customer on the wrong plan',1,1,'Y','N','RAG'),(459,137,'Over provisioning of network services and features',1,1,'Y','N','RAG'),(460,137,'Replacement equipment provides better service than required',1,1,'Y','N','RAG'),(461,138,'Customer on the wrong plan',1,1,'Y','N','RAG'),(462,138,'Under provisioning of network services and features',1,1,'Y','N','RAG'),(463,139,'Delay to service activation but billing commenced',1,1,'Y','N','RAG'),(464,140,'Service activation failed but billing commenced',1,1,'Y','N','RAG'),(465,140,'Charging for services and features not provided',1,1,'Y','N','RAG'),(466,141,'Service deactivated but billing not ceased',1,1,'Y','N','RAG'),(467,141,'Billing of orders cancelled before they went live',1,1,'Y','N','RAG'),(468,141,'Service deactivated but delay to cease of billing',1,1,'Y','N','RAG'),(469,142,'Subscriber on wrong tariff',1,1,'Y','N','RAG'),(470,142,'Incorrect APNs configured',1,1,'Y','N','RAG'),(471,142,'Customer profile incorrect/out of date',1,1,'Y','N','RAG'),(472,146,'Customer on wrong tariff after product/plan swap',1,1,'Y','N','RAG'),(473,143,'Incorrect APNs configured',1,1,'Y','N','RAG'),(474,143,'Customer profile incorrect/out of date',1,1,'Y','N','RAG'),(475,143,'Subscription package missing from corporate billing system',1,1,'Y','N','RAG'),(476,143,'Incorrect standard discount applied to corporate recurring service fees',1,1,'Y','N','RAG'),(477,143,'Incorrect manual discount applied to corporate recurring service fees',1,1,'Y','N','RAG'),(478,143,'Network specific barred destinations not implemented',1,1,'Y','N','RAG'),(479,143,'Customer specific barred destinations not implemented',1,1,'Y','N','RAG'),(480,144,'Delay to supply of customer premises equipment',1,1,'Y','N','RAG'),(481,30,'Poor quality of service',1,1,'Y','N','RAG'),(482,30,'Poor customer experience',1,1,'Y','N','RAG'),(483,146,'Ex-employees retain staff discounts',1,1,'Y','N','RAG'),(484,146,'Test accounts being used for personal calls',1,1,'Y','N','RAG'),(485,147,'Incorrect dial plan recorded in the customer contract',1,1,'Y','N','RAG'),(486,148,'No master price book',1,1,'Y','N','RAG'),(487,148,'No master number plan',1,1,'Y','N','RAG'),(488,148,'Data entry errors',1,1,'Y','N','RAG'),(489,148,'Unauthorised tariff changes',1,1,'Y','N','RAG'),(490,94,'Requested third party resources not procured',1,1,'Y','N','RAG'),(491,148,'Billing migration not implemented correctly ',1,1,'Y','N','RAG'),(493,148,'Prices not held to correct level of precision',1,1,'Y','N','RAG'),(494,148,'Product offers assembled from incorrect tariff components',1,1,'Y','N','RAG'),(495,149,'Dial strings do not align with destinations',1,1,'Y','N','RAG'),(496,149,'Dial strings do not align with traffic classes',1,1,'Y','N','RAG'),(497,149,'Missing origins',1,1,'Y','N','RAG'),(498,149,'Missing destinations',1,1,'Y','N','RAG'),(500,150,'Closed user group defined in the network contains invalid entries',1,1,'Y','N','RAG'),(501,150,'Closed user group defined in the billing system contains invalid entries',1,1,'Y','N','RAG'),(502,150,'Closed user group entries clash with network short codes',1,1,'Y','N','RAG'),(503,150,'DDI range definition contain invalid entries',1,1,'Y','N','RAG'),(506,150,'Number range defined incorrectly',1,1,'Y','N','RAG'),(507,151,'Change request not implemented',1,1,'Y','N','RAG'),(508,151,'Need for change not recognised',1,1,'Y','N','RAG'),(509,151,'Not implemented in all billing systems',1,1,'Y','N','RAG'),(510,152,'One-time charges configured incorrectly',1,1,'Y','N','RAG'),(511,152,'Transition  charges configured incorrectly',1,1,'Y','N','RAG'),(512,152,'Early termination fees configured incorrectly',1,1,'Y','N','RAG'),(513,152,'Contract term configured incorrectly',1,1,'Y','N','RAG'),(514,153,'Min & max charges not configured correctly',1,1,'Y','N','RAG'),(515,153,'Charging intervals not configured correctly',1,1,'Y','N','RAG'),(516,153,'Time bands not configured correctly',1,1,'Y','N','RAG'),(517,153,'Connection charges not configured correctly',1,1,'Y','N','RAG'),(518,153,'Access charges not configured correctly',1,1,'Y','N','RAG'),(519,153,'Service charges not configured correctly',1,1,'Y','N','RAG'),(520,154,'Qualifying criteria configured incorrectly',1,1,'Y','N','RAG'),(522,154,'Discount amount configured incorrectly',1,1,'Y','N','RAG'),(523,154,'Special rates applied to normal days',1,1,'Y','N','RAG'),(524,155,'Periodic price rises not applied correctly',1,1,'Y','N','RAG'),(525,155,'Periodic price rises are applied to tariffs not subject to this increase',1,1,'Y','N','RAG'),(526,156,'Fair use period configured incorrectly',1,1,'Y','N','RAG'),(527,156,'Fair use limited configured incorrectly',1,1,'Y','N','RAG'),(528,156,'Normal QoS configured incorrectly',1,1,'Y','N','RAG'),(529,156,'Throttled QoS configured incorrectly',1,1,'Y','N','RAG'),(530,157,'Hardware options defined incorrectly',1,1,'Y','N','RAG'),(531,157,'Data bundles defined incorrectly',1,1,'Y','N','RAG'),(532,157,'Tariff transition defined configured incorrectly',1,1,'Y','N','RAG'),(533,158,'Promotional elements not configured correctly',1,1,'Y','N','RAG'),(534,158,'Promotions do not expire when expected',1,1,'Y','N','RAG'),(535,158,'Bonus entitlements configured incorrectly',1,1,'Y','N','RAG'),(536,158,'Expired promotions',1,1,'Y','N','RAG'),(540,97,'Fixed price discount based on a variable cost',1,1,'Y','N','RAG'),(541,160,'Provisioning strings configured incorrectly',1,1,'Y','N','RAG'),(542,161,'Dial string definitions not optimised',1,1,'Y','N','RAG'),(543,161,'Duplicated tariff definitions',1,1,'Y','N','RAG'),(544,161,'Inefficient tariff definitions ',1,1,'Y','N','RAG'),(545,161,'Redundant tariff definitions',1,1,'Y','N','RAG'),(547,162,'Itemised billing not configured',1,1,'Y','N','RAG'),(548,162,'Valid charging cases do not generate usage records',1,1,'Y','N','RAG'),(549,162,'Insufficient capacity to record data',1,1,'Y','N','RAG'),(551,162,'CAMEL CDRs not generated',1,1,'Y','N','RAG'),(552,162,'Failure of local storage failure on service node',1,1,'Y','N','RAG'),(553,162,'Missing usage data files',1,1,'Y','N','RAG'),(554,162,'Missing usage data blocks',1,1,'Y','N','RAG'),(555,162,'Missing usage data records',1,1,'Y','N','RAG'),(556,162,'Missing usage data sub-records',1,1,'Y','N','RAG'),(557,162,'Missing usage data fields',1,1,'Y','N','RAG'),(558,163,'Zero duration records',1,1,'Y','N','RAG'),(559,163,'Duration discrepancy',1,1,'Y','N','RAG'),(560,163,'Inaccurate time stamps',1,1,'Y','N','RAG'),(561,163,'Incorrect recording of event duration',1,1,'Y','N','RAG'),(562,163,'Incorrect duration rounding',1,1,'Y','N','RAG'),(563,163,'Incorrect number format',1,1,'Y','N','RAG'),(564,163,'Unexpected data values',1,1,'Y','N','RAG'),(565,163,'Incorrect time zone',1,1,'Y','N','RAG'),(567,163,'Missing long duration call segments',1,1,'Y','N','RAG'),(570,163,'Unsuccessful calls',1,1,'Y','N','RAG'),(573,164,'Service usage data not collected from network elements',1,1,'Y','N','RAG'),(574,164,'Data corruption',1,1,'Y','N','RAG'),(576,83,'Unknown service scenario',1,1,'Y','N','RAG'),(577,83,'Unknown charging party',1,1,'Y','N','RAG'),(578,164,'Billable events are routed to wrong end system',1,1,'Y','N','RAG'),(581,164,'Rejected billable events are discarded from the billing chain',1,1,'Y','N','RAG'),(582,164,'Billable events incorrectly identified as duplicates',1,1,'Y','N','RAG'),(583,165,'Incorrect number normalisation',1,1,'Y','N','RAG'),(584,165,'Incorrect date/time normalisation',1,1,'Y','N','RAG'),(586,165,'Incorrect duration normalisation',1,1,'Y','N','RAG'),(588,165,'Incorrect aggregation of long duration call segments',1,1,'Y','N','RAG'),(590,165,'Incorrect interpretation of encoded values',1,1,'Y','N','RAG'),(595,112,'Chargeable network short codes removed from the billing chain',1,1,'Y','N','RAG'),(596,112,'Incorrect discarding of long duration calls',1,1,'Y','N','RAG'),(597,112,'Long duration call not charged if partial record(s) missing',1,1,'Y','N','RAG'),(598,112,'Incorrect handling of call status indicator',1,1,'Y','N','RAG'),(599,167,'Usage data recorded more than once',1,1,'Y','N','RAG'),(600,167,'Usage data sent to billing more than once',1,1,'Y','N','RAG'),(601,167,'Usage data processed more than once',1,1,'Y','N','RAG'),(602,168,'Vouchers credited to wrong account',1,1,'Y','N','RAG'),(603,168,'Vouchers credited for the wrong amount',1,1,'Y','N','RAG'),(604,168,'Voucher used more than once',1,1,'Y','N','RAG'),(605,168,'Account credited without a voucher',1,1,'Y','N','RAG'),(606,168,'Account credited with an expired voucher',1,1,'Y','N','RAG'),(607,169,'Bulk vouchers issued before payment received from sales channel',1,1,'Y','N','RAG'),(608,170,'Level of failed top-ups exceeds expectations',1,1,'Y','N','RAG'),(609,170,'Top-ups fail after account credited',1,1,'Y','N','RAG'),(610,171,'Expired voucher not replaced',1,1,'Y','N','RAG'),(611,171,'Inaccurate prediction of future sales',1,1,'Y','N','RAG'),(612,180,'No billing trigger for manual billing process',1,1,'Y','N','RAG'),(613,6,'Manual billing knowledge restricted to key staff',1,1,'Y','N','RAG'),(615,179,'Incorrect discount level offered by sales/commercial team',1,1,'Y','N','RAG'),(616,175,'Compensation for service unavailability (service repair)',1,1,'Y','N','RAG'),(617,175,'Compensation for delayed broadband or fixed line installation',1,1,'Y','N','RAG'),(618,175,'Compensation for missed engineer appointment',1,1,'Y','N','RAG'),(619,175,'Compensation for late cancellation of engineer appointment',1,1,'Y','N','RAG'),(620,175,'Minimum broadband speed not achieved ',1,1,'Y','N','RAG'),(621,175,'Unfair practices between operators',1,1,'Y','N','RAG'),(622,168,'Physical voucher (e.g. scratch card) used though not officially issued',1,1,'Y','N','RAG'),(623,168,'Online top-up credited to account but transaction (payment) not completed',1,1,'Y','N','RAG'),(624,168,'Online top-up not credited to account but transaction completed (customer charged)',1,1,'Y','N','RAG'),(625,168,'Electronic voucher credited to account but transaction voided',1,1,'Y','N','RAG'),(626,178,'Electronic vouchers used but 3rd party sales channel does not record sale',1,1,'Y','N','RAG'),(627,180,'Manual bills not produced due to lack of resources',1,1,'Y','N','RAG'),(628,180,'Manual bills not produced due to lack of knowledge',1,1,'Y','N','RAG'),(629,14,'?',1,1,'Y','N','RAG'),(630,15,'?',1,1,'Y','N','RAG'),(631,16,'?',1,1,'Y','N','RAG'),(632,17,'?',1,1,'Y','N','RAG'),(633,18,'?',1,1,'Y','N','RAG'),(634,99,'Service consumption cannot be measured',1,1,'Y','N','RAG'),(635,31,'Time taken to answer calls to customer services is too long',1,1,'Y','N','RAG'),(636,31,'Call centre cannot distinguish between high value and low value customers',1,1,'Y','N','RAG'),(637,31,'Time taken to respond to customer complaints is too long',1,1,'Y','N','RAG'),(638,31,'Time taken to resolve customer complaints is too long',1,1,'Y','N','RAG'),(639,82,'Threshold for suspending customers set too low',1,1,'Y','N','RAG'),(640,82,'Customer payments not applied to account',1,1,'Y','N','RAG'),(641,108,'Maintenance call-outs for equipment not owner by operator',1,1,'Y','N','RAG'),(642,105,'Flat fee for activating new customer regardless of costs incurred',1,1,'Y','N','RAG'),(643,164,'Data lost by third party',1,1,'Y','N','RAG'),(645,120,'Incorrect pricing of inbound roaming calls',1,1,'Y','N','RAG'),(646,120,'Incorrect pricing of outbound roaming calls',1,1,'Y','N','RAG'),(647,120,'Incorrect pricing of roaming calling forwarding events',1,1,'Y','N','RAG'),(648,43,'Settlement performed by non-billing team',1,1,'Y','N','RAG'),(649,20,'Commission payments not calculated correctly',1,1,'Y','N','RAG'),(650,182,'Blacklisted customer accounts are allowed to make transactions',1,1,'Y','N','RAG'),(651,182,'Blacklisted partner/agent accounts are allowed to make transactions',1,1,'Y','N','RAG'),(652,182,'Customers able to utilise services without sufficient balance',1,1,'Y','N','RAG'),(653,182,'SIM Swap and Wallet PIN Reset exploitation',1,1,'Y','N','RAG'),(655,183,'Breach of customer transaction limits',1,1,'Y','N','RAG'),(656,183,'Breach of partner/agent transaction limits',1,1,'Y','N','RAG'),(657,183,'Insufficient verification of new partners/agents',1,1,'Y','N','RAG'),(660,21,'Customer contract does not reflect agreed terms',1,1,'Y','N','RAG'),(661,21,'Contract template copied from another customer',1,1,'Y','N','RAG'),(662,14,'?',1,1,'Y','N','RAG'),(663,15,'?',1,1,'Y','N','RAG'),(664,16,'?',1,1,'Y','N','RAG'),(665,17,'?',1,1,'Y','N','RAG'),(666,18,'?',1,1,'Y','N','RAG'),(667,71,'?',1,1,'Y','N','RAG'),(668,115,'?',1,1,'Y','N','RAG'),(669,116,'?',1,1,'Y','N','RAG');
/*!40000 ALTER TABLE `cvg_sub_risk` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`cvg_sub_risk_BEFORE_INSERT` BEFORE INSERT ON `cvg_sub_risk` FOR EACH ROW
BEGIN
	if (new.REQUIRED = 'Y') then
    
		insert ignore into cvg_risk_node_sub_risk (RISK_NODE_ID, SUB_RISK_ID, LIKELIHOOD, IMPACT)
        SELECT risk_node_id, new.SUB_RISK_ID, new.BASE_LIKELIHOOD, new.BASE_IMPACT 
        FROM cvg_risk_node where risk_id = new.RISK_ID;
	
		update cvg_risk_node 
			set coverage = cvgGetRiskNodeCoverage(RISK_NODE_ID)
		where risk_id = new.RISK_ID;
    end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`cvg_sub_risk_BEFORE_UPDATE` BEFORE UPDATE ON `cvg_sub_risk` FOR EACH ROW
BEGIN
	if (new.REQUIRED = 'Y') then
    
		insert ignore into cvg_risk_node_sub_risk (RISK_NODE_ID, SUB_RISK_ID, LIKELIHOOD, IMPACT)
        SELECT risk_node_id, new.SUB_RISK_ID, new.BASE_LIKELIHOOD, new.BASE_IMPACT 
        FROM cvg_risk_node where risk_id = new.RISK_ID;
	
		update cvg_risk_node 
			set coverage = cvgGetRiskNodeCoverage(RISK_NODE_ID)
		where risk_id = new.RISK_ID;
    end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `cvg_sub_risk_measure_link`
--

DROP TABLE IF EXISTS `cvg_sub_risk_measure_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cvg_sub_risk_measure_link` (
  `SUB_RISK_ID` int(11) NOT NULL,
  `MEASURE_ID` int(11) NOT NULL,
  UNIQUE KEY `UNIQUE` (`SUB_RISK_ID`,`MEASURE_ID`),
  KEY `fk_cvg_sub_risk_measure_link_1_idx` (`SUB_RISK_ID`),
  KEY `fk_cvg_sub_risk_measure_link_2_idx` (`MEASURE_ID`),
  CONSTRAINT `fk_cvg_sub_risk_measure_link_1` FOREIGN KEY (`SUB_RISK_ID`) REFERENCES `cvg_sub_risk` (`SUB_RISK_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cvg_sub_risk_measure_link_2` FOREIGN KEY (`MEASURE_ID`) REFERENCES `cvg_measure` (`MEASURE_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_sub_risk_measure_link`
--

LOCK TABLES `cvg_sub_risk_measure_link` WRITE;
/*!40000 ALTER TABLE `cvg_sub_risk_measure_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `cvg_sub_risk_measure_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dfl_amx_procedure_link`
--

DROP TABLE IF EXISTS `dfl_amx_procedure_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dfl_amx_procedure_link` (
  `DFL_PROCEDURE_ID` int(11) NOT NULL,
  `AMX_PROCEDURE_ID` int(11) NOT NULL,
  PRIMARY KEY (`DFL_PROCEDURE_ID`,`AMX_PROCEDURE_ID`),
  KEY `fk_dfl_amx_procedure_link_dfl_control_catalogue1_idx` (`DFL_PROCEDURE_ID`),
  KEY `fk_dfl_amx_procedure_link_amx_procedure_catalogue1_idx` (`AMX_PROCEDURE_ID`),
  CONSTRAINT `fk_dfl_amx_procedure_link_amx_procedure_catalogue1` FOREIGN KEY (`AMX_PROCEDURE_ID`) REFERENCES `amx_procedure_catalogue` (`PROCEDURE_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_dfl_amx_procedure_link_dfl_control_catalogue1` FOREIGN KEY (`DFL_PROCEDURE_ID`) REFERENCES `dfl_control_catalogue` (`PROCEDURE_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='links amx procedure_id with dfl procedure_id (subtype dfl_control_catalogue)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dfl_amx_procedure_link`
--

LOCK TABLES `dfl_amx_procedure_link` WRITE;
/*!40000 ALTER TABLE `dfl_amx_procedure_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `dfl_amx_procedure_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dfl_control_catalogue`
--

DROP TABLE IF EXISTS `dfl_control_catalogue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dfl_control_catalogue` (
  `PROCEDURE_ID` int(11) NOT NULL,
  `CONTROL_TYPE` varchar(45) DEFAULT NULL COMMENT 'A. Reconciliation\nB. Exception report\nC. Trend',
  `CONTROL_ASSERTION` varchar(255) DEFAULT NULL COMMENT '1. Existence/Occurrence/Validity: Only valid or authorized transactions are processed.\n2. Completeness: All transactions are processed that should be.\n3. Rights and obligations: Assets are the rights of the organization and the liabilities are its obligations as of a given date.\n4. Valuation: Transactions are valued accurately using the proper methodology, such as a specified means of computation or formula.\n5. Presentation and disclosure: Accounts and disclosures are properly described in the financial statements of the organization.',
  `ESCALATION_NOTES` text,
  `START_DATE` date DEFAULT NULL,
  `END_DATE` date DEFAULT NULL,
  `CVG_CONTROL_ID` int(11) DEFAULT NULL COMMENT 'This value is returned back from a trigger that inserts record in CVG_CONTROL table ',
  PRIMARY KEY (`PROCEDURE_ID`),
  KEY `dfl_control_catalogue_ix1` (`CVG_CONTROL_ID`),
  CONSTRAINT `fk_dfl_control_catalogue_1` FOREIGN KEY (`PROCEDURE_ID`) REFERENCES `dfl_procedure` (`PROCEDURE_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dfl_control_catalogue`
--

LOCK TABLES `dfl_control_catalogue` WRITE;
/*!40000 ALTER TABLE `dfl_control_catalogue` DISABLE KEYS */;
/*!40000 ALTER TABLE `dfl_control_catalogue` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`dfl_control_catalogue_BEFORE_INSERT` BEFORE INSERT ON `dfl_control_catalogue` FOR EACH ROW
BEGIN
	insert into cvg_control (control_type) values ('C');
    set new.CVG_CONTROL_ID = LAST_INSERT_ID();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`dfl_control_catalogue_BEFORE_DELETE` BEFORE DELETE ON `dfl_control_catalogue` FOR EACH ROW
BEGIN
	delete from cvg_control where control_id = old.CVG_CONTROL_ID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `dfl_data_dictionary`
--

DROP TABLE IF EXISTS `dfl_data_dictionary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dfl_data_dictionary` (
  `DDIC_ID` int(11) NOT NULL,
  `COLUMN` varchar(45) NOT NULL,
  `COMMENT` varchar(255) DEFAULT NULL COMMENT 'Comment importet from the source database',
  `DESCRIPTION` text COMMENT 'manually maintained description',
  `DATASOURCE_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`DDIC_ID`),
  KEY `fk_dfl_data_dictionary_1_idx` (`DATASOURCE_ID`),
  CONSTRAINT `fk_dfl_data_dictionary_1` FOREIGN KEY (`DATASOURCE_ID`) REFERENCES `dfl_datasource` (`DATASOURCE_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='columns documentation of datasources';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dfl_data_dictionary`
--

LOCK TABLES `dfl_data_dictionary` WRITE;
/*!40000 ALTER TABLE `dfl_data_dictionary` DISABLE KEYS */;
/*!40000 ALTER TABLE `dfl_data_dictionary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dfl_dataflow`
--

DROP TABLE IF EXISTS `dfl_dataflow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dfl_dataflow` (
  `DATAFLOW_ID` int(11) NOT NULL AUTO_INCREMENT,
  `PROCEDURE_ID` int(11) NOT NULL,
  `DATASOURCE_ID` int(11) NOT NULL,
  `DIRECTION` varchar(3) NOT NULL COMMENT 'I - IN\nO - OUT',
  PRIMARY KEY (`DATAFLOW_ID`),
  UNIQUE KEY `DATAFLOW_ID` (`DATAFLOW_ID`),
  KEY `fk_dfl_dataflow_1_idx` (`PROCEDURE_ID`),
  KEY `fk_dfl_dataflow_2_idx` (`DATASOURCE_ID`),
  CONSTRAINT `fk_dfl_dataflow_1` FOREIGN KEY (`PROCEDURE_ID`) REFERENCES `dfl_procedure` (`PROCEDURE_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_dfl_dataflow_2` FOREIGN KEY (`DATASOURCE_ID`) REFERENCES `dfl_datasource` (`DATASOURCE_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dfl_dataflow`
--

LOCK TABLES `dfl_dataflow` WRITE;
/*!40000 ALTER TABLE `dfl_dataflow` DISABLE KEYS */;
/*!40000 ALTER TABLE `dfl_dataflow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dfl_datasource`
--

DROP TABLE IF EXISTS `dfl_datasource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dfl_datasource` (
  `DATASOURCE_ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Object _ID of the I/O Object',
  `OPCO_ID` int(11) NOT NULL,
  `TYPE` varchar(1) NOT NULL COMMENT 'F=File\nD=Database Object (Table, View, Materialized View)\nE=Email',
  `NAME` varchar(255) NOT NULL,
  `DESCRIPTION` text COMMENT 'manually entered description of the datasource',
  `STATUS_CODE` varchar(1) DEFAULT 'A',
  `RETENTION_POLICY` varchar(255) DEFAULT NULL,
  `INTERFACE_ID` int(11) DEFAULT NULL COMMENT 'Required for first occurrence in RA only (source files, source database tables)',
  `MODIFIED` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`DATASOURCE_ID`),
  UNIQUE KEY `UNIQUE` (`OPCO_ID`,`TYPE`,`NAME`),
  KEY `fk_dfl_datasource_1_idx` (`INTERFACE_ID`),
  CONSTRAINT `fk_dfl_datasource_1` FOREIGN KEY (`INTERFACE_ID`) REFERENCES `dfl_interface` (`INTERFACE_ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='File, Datbase Grids (Tables, Views, Materialized Views), Mail body with data content qualify as a data source.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dfl_datasource`
--

LOCK TABLES `dfl_datasource` WRITE;
/*!40000 ALTER TABLE `dfl_datasource` DISABLE KEYS */;
/*!40000 ALTER TABLE `dfl_datasource` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`dfl_datasource_BEFORE_UPDATE` BEFORE UPDATE ON `dfl_datasource` FOR EACH ROW
BEGIN
	set new.MODIFIED = CURRENT_TIMESTAMP;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`dfl_datasource_BEFORE_DELETE` BEFORE DELETE ON `dfl_datasource` FOR EACH ROW
BEGIN
	delete from dfl_dbobject where DATASOURCE_ID = old.DATASOURCE_ID;
	delete from dfl_file where DATASOURCE_ID = old.DATASOURCE_ID;
	delete from dfl_mail where DATASOURCE_ID = old.DATASOURCE_ID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `dfl_dbobject`
--

DROP TABLE IF EXISTS `dfl_dbobject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dfl_dbobject` (
  `DATASOURCE_ID` int(11) NOT NULL,
  `OWNER` varchar(45) NOT NULL COMMENT 'Can be Owner, Database, everything that is needed to prefix the table on the HOST within the database system',
  `COMMENT` varchar(255) DEFAULT NULL COMMENT 'Object comment loaded from DB',
  PRIMARY KEY (`DATASOURCE_ID`),
  CONSTRAINT `fk_dfl_dbobject_1` FOREIGN KEY (`DATASOURCE_ID`) REFERENCES `dfl_datasource` (`DATASOURCE_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dfl_dbobject`
--

LOCK TABLES `dfl_dbobject` WRITE;
/*!40000 ALTER TABLE `dfl_dbobject` DISABLE KEYS */;
/*!40000 ALTER TABLE `dfl_dbobject` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dfl_file`
--

DROP TABLE IF EXISTS `dfl_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dfl_file` (
  `DATASOURCE_ID` int(11) NOT NULL,
  `HOST` varchar(255) NOT NULL,
  `DIRECTORY` varchar(255) NOT NULL,
  `FILEMASK` varchar(255) DEFAULT NULL,
  `FORMAT` varchar(45) DEFAULT NULL COMMENT 'Descriptive File format:\nCSV, Binary File, XML, json, etc.',
  `COMPRESSION` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`DATASOURCE_ID`),
  CONSTRAINT `fk_dfl_file_1` FOREIGN KEY (`DATASOURCE_ID`) REFERENCES `dfl_datasource` (`DATASOURCE_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dfl_file`
--

LOCK TABLES `dfl_file` WRITE;
/*!40000 ALTER TABLE `dfl_file` DISABLE KEYS */;
/*!40000 ALTER TABLE `dfl_file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dfl_interface`
--

DROP TABLE IF EXISTS `dfl_interface`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dfl_interface` (
  `INTERFACE_ID` int(11) NOT NULL AUTO_INCREMENT,
  `OPCO_ID` int(11) NOT NULL,
  `INTERFACE_TYPE` varchar(1) NOT NULL COMMENT 'F - File\nD - Database\nE - Email',
  `INTERFACE_NAME` varchar(255) NOT NULL,
  `INTERFACE_DESCRIPTION` text,
  `CONNECTION_INFO` varchar(255) DEFAULT NULL COMMENT 'User and Host where RA picks up the datasources',
  `DOCU_LINK` varchar(255) DEFAULT NULL COMMENT 'External Link/Share to Interface Documentation',
  `IFC_SYSTEM_ID` int(11) DEFAULT NULL,
  `IFC_CONTACT_ID` int(11) DEFAULT NULL COMMENT 'Contact for File delivery (mostly operations PoCs)',
  `EXPERT_NAME` varchar(255) DEFAULT NULL COMMENT 'Experts, which can help with questions regarding the interface data.',
  `MODIFIED` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`INTERFACE_ID`),
  UNIQUE KEY `INTERFACE_ID` (`INTERFACE_ID`),
  UNIQUE KEY `UNIQUE` (`OPCO_ID`,`INTERFACE_NAME`),
  KEY `fk_dfl_interface_1_idx` (`IFC_SYSTEM_ID`),
  KEY `fk_dfl_interface_2_idx` (`IFC_CONTACT_ID`),
  CONSTRAINT `fk_dfl_interface_1` FOREIGN KEY (`IFC_SYSTEM_ID`) REFERENCES `amx_system` (`SYSTEM_ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_dfl_interface_2` FOREIGN KEY (`IFC_CONTACT_ID`) REFERENCES `amx_contact` (`CONTACT_ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='File or Database Grid (Table/View)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dfl_interface`
--

LOCK TABLES `dfl_interface` WRITE;
/*!40000 ALTER TABLE `dfl_interface` DISABLE KEYS */;
/*!40000 ALTER TABLE `dfl_interface` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`dfl_interface_BEFORE_UPDATE` BEFORE UPDATE ON `dfl_interface` FOR EACH ROW
BEGIN
	set new.MODIFIED = CURRENT_TIMESTAMP;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `dfl_job_catalogue`
--

DROP TABLE IF EXISTS `dfl_job_catalogue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dfl_job_catalogue` (
  `PROCEDURE_ID` int(11) NOT NULL,
  `CODE_LOCATION` varchar(255) DEFAULT NULL,
  `JOB_PARAMETERS` varchar(1024) DEFAULT NULL COMMENT 'Optional: Parameter which fed''s a generic job within a schedule. Most likely part of the command line which calls the job.',
  PRIMARY KEY (`PROCEDURE_ID`),
  CONSTRAINT `fk_dfl_job_catalogue_1` FOREIGN KEY (`PROCEDURE_ID`) REFERENCES `dfl_procedure` (`PROCEDURE_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dfl_job_catalogue`
--

LOCK TABLES `dfl_job_catalogue` WRITE;
/*!40000 ALTER TABLE `dfl_job_catalogue` DISABLE KEYS */;
/*!40000 ALTER TABLE `dfl_job_catalogue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dfl_mail`
--

DROP TABLE IF EXISTS `dfl_mail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dfl_mail` (
  `DATASOURCE_ID` int(11) NOT NULL,
  `SUBJECT` varchar(255) DEFAULT NULL COMMENT 'Mail Subject',
  `RECIPIENTS` text COMMENT 'Mail receipient',
  PRIMARY KEY (`DATASOURCE_ID`),
  CONSTRAINT `fk_dfl_mail_1` FOREIGN KEY (`DATASOURCE_ID`) REFERENCES `dfl_datasource` (`DATASOURCE_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dfl_mail`
--

LOCK TABLES `dfl_mail` WRITE;
/*!40000 ALTER TABLE `dfl_mail` DISABLE KEYS */;
/*!40000 ALTER TABLE `dfl_mail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dfl_procedure`
--

DROP TABLE IF EXISTS `dfl_procedure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dfl_procedure` (
  `PROCEDURE_ID` int(11) NOT NULL AUTO_INCREMENT,
  `OPCO_ID` int(11) NOT NULL,
  `TYPE` enum('J','C','T','S') NOT NULL DEFAULT 'J' COMMENT 'J - Job\nC - Control\nT - Dato\nS - RA Report Solution',
  `SUB_TYPE` varchar(50) NOT NULL COMMENT 'Reference a (generic) lookup, depends on TYPE\nJ - Job\nPentaho Job\nOracle Procedure\nBatch script\nwinscp script\nperl script\nC - Control\nMoney Map\nMyRATool\nD - Dato\nS - RA Report Solution\n',
  `NAME` varchar(255) NOT NULL,
  `DESCRIPTION` text NOT NULL,
  `STATUS_CODE` char(1) NOT NULL COMMENT 'D ... in development\nA ... active\nI ... Inactive',
  `SCHEDULE_ID` int(11) DEFAULT NULL,
  `MODIFIED` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`PROCEDURE_ID`),
  UNIQUE KEY `PROCEDURE_ID` (`PROCEDURE_ID`),
  UNIQUE KEY `UNIQUE` (`OPCO_ID`,`TYPE`,`NAME`,`SUB_TYPE`),
  KEY `fk_dfl_procedure_1_idx` (`SCHEDULE_ID`),
  CONSTRAINT `fk_dfl_procedure_1` FOREIGN KEY (`SCHEDULE_ID`) REFERENCES `dfl_schedule` (`SCHEDULE_ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dfl_procedure`
--

LOCK TABLES `dfl_procedure` WRITE;
/*!40000 ALTER TABLE `dfl_procedure` DISABLE KEYS */;
/*!40000 ALTER TABLE `dfl_procedure` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`dfl_procedure_BEFORE_UPDATE` BEFORE UPDATE ON `dfl_procedure` FOR EACH ROW
BEGIN
	set new.MODIFIED = CURRENT_TIMESTAMP;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`dfl_procedure_AFTER_UPDATE` AFTER UPDATE ON `dfl_procedure` FOR EACH ROW
BEGIN
    if (old.TYPE = 'C' and new.STATUS_CODE <> old.STATUS_CODE) then
    
		
		update cvg_risk_node_sub_risk
        set COVERAGE = cvgGetRiskNodeSubRiskCoverage(RN_SUB_RISK_ID),
			FIXED = case when FIXED = 'Y' and cvgGetRiskNodeSubRiskCoverage(RN_SUB_RISK_ID) = 0 then 'N' else FIXED end
        where RN_SUB_RISK_ID in (
			SELECT rncsrl.RN_SUB_RISK_ID FROM cvg_risk_node_control rnc
			left join cvg_risk_node_control_sub_risk_link rncsrl on rncsrl.RN_CONTROL_ID = rnc.RN_CONTROL_ID
			where rnc.CONTROL_ID in (select CVG_CONTROL_ID from dfl_control_catalogue where PROCEDURE_ID = old.PROCEDURE_ID)
		);

		
        update cvg_risk_node
		set COVERAGE = cvgGetRiskNodeCoverage(RISK_NODE_ID)
        where RISK_NODE_ID in (
			SELECT rnc.RISK_NODE_ID FROM cvg_risk_node_control rnc
			where rnc.CONTROL_ID in (select CVG_CONTROL_ID from dfl_control_catalogue where PROCEDURE_ID = old.PROCEDURE_ID)
        );
        
    end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `tag`.`dfl_procedure_BEFORE_DELETE` BEFORE DELETE ON `dfl_procedure` FOR EACH ROW
BEGIN
	delete from dfl_control_catalogue where PROCEDURE_ID = old.PROCEDURE_ID;
    delete from dfl_job_catalogue where PROCEDURE_ID = old.PROCEDURE_ID;
    delete from dfl_solution_catalogue where PROCEDURE_ID = old.PROCEDURE_ID;
    update amx_dato_catalogue set PROCEDURE_ID = null where PROCEDURE_ID = old.PROCEDURE_ID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `dfl_schedule`
--

DROP TABLE IF EXISTS `dfl_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dfl_schedule` (
  `SCHEDULE_ID` int(11) NOT NULL AUTO_INCREMENT,
  `OPCO_ID` int(11) NOT NULL,
  `NAME` varchar(255) NOT NULL,
  `TYPE` varchar(255) NOT NULL COMMENT 'W: Windows, D: Database, U: UX-Cron, A: (other) Application, M: Manual',
  `FREQUENCY` varchar(50) NOT NULL COMMENT 'A: Ad-hoc, H:hourly, D:Daily, W:Weekly, M:Monthly, C:Cycle',
  `COMMENT` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`SCHEDULE_ID`),
  UNIQUE KEY `SCHEDULE_ID` (`SCHEDULE_ID`),
  UNIQUE KEY `UNIQUE` (`OPCO_ID`,`NAME`,`TYPE`,`FREQUENCY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dfl_schedule`
--

LOCK TABLES `dfl_schedule` WRITE;
/*!40000 ALTER TABLE `dfl_schedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `dfl_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dfl_solution_catalogue`
--

DROP TABLE IF EXISTS `dfl_solution_catalogue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dfl_solution_catalogue` (
  `PROCEDURE_ID` int(11) NOT NULL,
  `SOX_RELEVANT` char(1) DEFAULT 'N',
  `SOLUTION_CONTACT_ID` int(11) DEFAULT NULL,
  `DOCU_LINK` varchar(255) DEFAULT NULL COMMENT 'Referrer to Documentation Documents',
  PRIMARY KEY (`PROCEDURE_ID`),
  KEY `fk_dfl_solution_catalogue_2_idx` (`SOLUTION_CONTACT_ID`),
  CONSTRAINT `fk_dfl_solution_catalogue_1` FOREIGN KEY (`PROCEDURE_ID`) REFERENCES `dfl_procedure` (`PROCEDURE_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_dfl_solution_catalogue_2` FOREIGN KEY (`SOLUTION_CONTACT_ID`) REFERENCES `amx_contact` (`CONTACT_ID`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dfl_solution_catalogue`
--

LOCK TABLES `dfl_solution_catalogue` WRITE;
/*!40000 ALTER TABLE `dfl_solution_catalogue` DISABLE KEYS */;
/*!40000 ALTER TABLE `dfl_solution_catalogue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `v_counters`
--

DROP TABLE IF EXISTS `v_counters`;
/*!50001 DROP VIEW IF EXISTS `v_counters`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_counters` AS SELECT 
 1 AS `OPCO_ID`,
 1 AS `openChangeRequests`,
 1 AS `openIncidents`,
 1 AS `openAlarms`,
 1 AS `openTasks`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_cvg_control`
--

DROP TABLE IF EXISTS `v_cvg_control`;
/*!50001 DROP VIEW IF EXISTS `v_cvg_control`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_cvg_control` AS SELECT 
 1 AS `OPCO_ID`,
 1 AS `CONTROL_ID`,
 1 AS `CONTROL_REF`,
 1 AS `CONTROL_TYPE`,
 1 AS `CONTROL_NAME`,
 1 AS `DESCRIPTION`,
 1 AS `STATUS_CODE`,
 1 AS `STATUS_CODE_TEXT`,
 1 AS `FREQUENCY`,
 1 AS `CVG_RN_CNT`,
 1 AS `CTRL_COVERAGE`,
 1 AS `CTRL_COVERAGE_OVERLAP`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_cvg_control_system_mix`
--

DROP TABLE IF EXISTS `v_cvg_control_system_mix`;
/*!50001 DROP VIEW IF EXISTS `v_cvg_control_system_mix`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_cvg_control_system_mix` AS SELECT 
 1 AS `SYSTEM_NAME`,
 1 AS `SYSTEM_ID`,
 1 AS `CONTROL_TYPE`,
 1 AS `OPCO_ID`,
 1 AS `CVG_CONTROL_ID`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_dfl_dataflow_direct`
--

DROP TABLE IF EXISTS `v_dfl_dataflow_direct`;
/*!50001 DROP VIEW IF EXISTS `v_dfl_dataflow_direct`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_dfl_dataflow_direct` AS SELECT 
 1 AS `DATAFLOW_ID`,
 1 AS `PROCEDURE_ID`,
 1 AS `DATASOURCE_ID`,
 1 AS `DIRECTION`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_dfl_datasource_denorm`
--

DROP TABLE IF EXISTS `v_dfl_datasource_denorm`;
/*!50001 DROP VIEW IF EXISTS `v_dfl_datasource_denorm`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_dfl_datasource_denorm` AS SELECT 
 1 AS `datasource_id`,
 1 AS `datasource_name`,
 1 AS `interface_id`,
 1 AS `interface_name`,
 1 AS `system_name`,
 1 AS `SYSTEM_ID`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'tag'
--

--
-- Dumping routines for database 'tag'
--
/*!50003 DROP FUNCTION IF EXISTS `cvgGetControlCoverage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `cvgGetControlCoverage`(controlId int(11)) RETURNS decimal(10,4)
BEGIN

	select round(ifnull(sum(COVERAGE), 0), 4) into @returnValue
	from (
		select 
			rnsr.RISK_NODE_ID,
			cvgGetRiskNodeValue(rnsr.RISK_NODE_ID)/cvgGetTotalOpcoValue(rn.OPCO_ID) * sum(rnsr.LIKELIHOOD * rnsr.IMPACT * case when rnsr.FIXED = 'Y' and rnsr.COVERAGE < rnc.EFFECTIVENESS then rnsr.COVERAGE else rnc.EFFECTIVENESS end)/cvgGetRiskNodeRPN(rnsr.RISK_NODE_ID) COVERAGE       
		from cvg_risk_node_sub_risk rnsr
		join cvg_risk_node rn on rn.RISK_NODE_ID = rnsr.RISK_NODE_ID
		left join cvg_risk_node_control_sub_risk_link rncsr on rncsr.RN_SUB_RISK_ID = rnsr.RN_SUB_RISK_ID
		left join cvg_risk_node_control rnc on rnc.RN_CONTROL_ID = rncsr.RN_CONTROL_ID
		join cvg_control cc on cc.CONTROL_ID = rnc.CONTROL_ID
		left join dfl_control_catalogue dfcc on dfcc.CVG_CONTROL_ID = rnc.CONTROL_ID
		left join dfl_procedure dfp on dfp.PROCEDURE_ID = dfcc.PROCEDURE_ID and cc.CONTROL_TYPE='C' 
		left join amx_metric_catalogue mc on mc.CVG_CONTROL_ID = rnc.CONTROL_ID and cc.CONTROL_TYPE='M'
		where 1=1
			and rnc.CONTROL_ID = controlId
			and (case 
				when cc.CONTROL_TYPE = 'C' and dfp.STATUS_CODE in ('A') then 1
				when cc.CONTROL_TYPE = 'M' and mc.RELEVANT='Y' and mc.IMPLEMENTED='Y' then 1
				else 0
			end) > 0
		group by rnsr.RISK_NODE_ID
	) as sub;

	RETURN @returnValue ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cvgGetControlCoverageOverlap` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `cvgGetControlCoverageOverlap`(controlId int(11)) RETURNS decimal(10,4)
BEGIN


select
	round(ifnull(cvgGetControlCoverage(controlId) - sum((cvgGetRiskNodeValue(rn.RISK_NODE_ID)/cvgGetTotalOpcoValue(rn.OPCO_ID)) * (cvgGetRiskNodeCoverage(rn.RISK_NODE_ID) - cvgGetRiskNodeCoverageWithoutControl(rn.RISK_NODE_ID, controlId))), 0), 4) into @returnValue
from cvg_risk_node rn where risk_node_id in (
	select distinct(rnsr.risk_node_id) from cvg_risk_node_sub_risk rnsr
	left join cvg_risk_node_control_sub_risk_link rncsr on rncsr.RN_SUB_RISK_ID = rnsr.RN_SUB_RISK_ID
	left join cvg_risk_node_control rnc on rnc.RN_CONTROL_ID = rncsr.RN_CONTROL_ID
	where rnc.CONTROL_ID = controlId
);

	RETURN @returnValue ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cvgGetControlCoverageSinkEffect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `cvgGetControlCoverageSinkEffect`(controlId int(11)) RETURNS decimal(10,4)
BEGIN


select
	sum((cvgGetRiskNodeValue(rn.RISK_NODE_ID)/cvgGetTotalOpcoValue(rn.OPCO_ID)) * (cvgGetRiskNodeCoverage(rn.RISK_NODE_ID) - cvgGetRiskNodeCoverageWithoutControl(rn.RISK_NODE_ID, controlId))) into @returnValue
from cvg_risk_node rn where risk_node_id in (
	select distinct(rnsr.risk_node_id) from cvg_risk_node_sub_risk rnsr
	left join cvg_risk_node_control_sub_risk_link rncsr on rncsr.RN_SUB_RISK_ID = rnsr.RN_SUB_RISK_ID
	left join cvg_risk_node_control rnc on rnc.RN_CONTROL_ID = rncsr.RN_CONTROL_ID
	where rnc.CONTROL_ID = controlId
);

	RETURN @returnValue ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cvgGetOpcoLobValue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `cvgGetOpcoLobValue`(opcoId int(11), lob varchar(100)) RETURNS decimal(20,5)
BEGIN
	SELECT sum(abs(b.value)) into @returnValue 
    FROM tag.cvg_product_group a
	join cvg_product_segment b on b.product_group_id = a.product_group_id
	where b.opco_id = opcoId and a.lob = lob;

	RETURN @returnValue ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cvgGetProductGroupValue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `cvgGetProductGroupValue`(opcoId int(11), id int(11)) RETURNS decimal(20,5)
BEGIN
	SELECT sum(abs(b.value)) into @returnValue 
    FROM tag.cvg_product_group a
	join cvg_product_segment b on b.product_group_id = a.product_group_id
	where a.product_group_id = id and b.opco_id = opcoId;

	RETURN @returnValue ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cvgGetProductSegmentControlCount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `cvgGetProductSegmentControlCount`(id int(11)) RETURNS int(11)
BEGIN
	SELECT 
		count(*) into @returnValue 
	from cvg_risk_node rn
    join cvg_risk_node_control rnc on rnc.RISK_NODE_ID = rn.RISK_NODE_ID
	where rn.PRODUCT_SEGMENT_ID = id;

	RETURN @returnValue ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cvgGetProductSegmentCoverage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `cvgGetProductSegmentCoverage`(id int(11)) RETURNS decimal(5,2)
BEGIN
	select cvgGetProductSegmentRPN(id) into @productSegmentRPN;
    
	SELECT 
		ifnull(sum( cvgGetRiskNodeRPN(rn.RISK_NODE_ID) / @productSegmentRPN * rn.COVERAGE ),0)  into @returnValue 
	from cvg_risk_node rn
	where rn.PRODUCT_SEGMENT_ID = id;

	RETURN @returnValue ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cvgGetProductSegmentMeasureCoverage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `cvgGetProductSegmentMeasureCoverage`(id int(11)) RETURNS decimal(5,2)
BEGIN

	select 
		sum(coverage)/count(*) into @returnValue
	from
	(
		SELECT 
			count(distinct rncm.MEASURE_ID)/count(distinct m.MEASURE_ID)*100 COVERAGE
		FROM cvg_risk_node rn
		
		join cvg_risk r on r.RISK_ID = rn.RISK_ID
		join cvg_measure m on r.BUSINESS_SUB_PROCESS_ID = m.BUSINESS_SUB_PROCESS_ID and m.REQUIRED = 'Y'
		join cvg_risk_measure_link rml on rml.RISK_ID = rn.RISK_ID and rml.MEASURE_ID = m.MEASURE_ID
		
		left join cvg_risk_node_control rnc on rnc.RISK_NODE_ID = rn.RISK_NODE_ID
		left join cvg_risk_node_control_measure_link rncm on rncm.RN_CONTROL_ID = rnc.RN_CONTROL_ID and rncm.MEASURE_ID = m.MEASURE_ID
		where rn.PRODUCT_SEGMENT_ID = id
		group by 
			rn.RISK_NODE_ID
	) rnt;



	RETURN @returnValue;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cvgGetProductSegmentRiskCount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `cvgGetProductSegmentRiskCount`(id int(11)) RETURNS int(11)
BEGIN
	SELECT 
		count(*) into @returnValue 
    FROM tag.cvg_risk_node
	where PRODUCT_SEGMENT_ID = id;

	RETURN @returnValue ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cvgGetProductSegmentRPN` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `cvgGetProductSegmentRPN`(id int(11)) RETURNS int(11)
BEGIN
	SELECT 
		ifnull(sum(LIKELIHOOD * IMPACT),0)  into @returnValue 
	from cvg_risk_node rn
    join cvg_risk_node_sub_risk rnsr on rnsr.RISK_NODE_ID = rn.RISK_NODE_ID
	where rn.PRODUCT_SEGMENT_ID = id;

	RETURN @returnValue ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cvgGetProductSegmentValue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `cvgGetProductSegmentValue`(id int(11)) RETURNS decimal(20,5)
BEGIN
	SELECT 
		abs(VALUE) into @returnValue 
    FROM tag.cvg_product_segment
	where PRODUCT_SEGMENT_ID = id;

	RETURN @returnValue ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cvgGetRiskNodeCoverage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `cvgGetRiskNodeCoverage`(id int(11)) RETURNS decimal(10,4)
BEGIN
	SELECT 
		ifnull(		sum((LIKELIHOOD*IMPACT)/cvgGetRiskNodeRPN(RISK_NODE_ID)*COVERAGE)
,0) into @returnValue 
    FROM tag.cvg_risk_node_sub_risk
	where RISK_NODE_ID = id;

	RETURN @returnValue ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cvgGetRiskNodeCoverageWithoutControl` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `cvgGetRiskNodeCoverageWithoutControl`(riskNodeId int(11), controlId int(11)) RETURNS decimal(10,4)
BEGIN

select round(ifnull(sum(C2_WITHOUT), 0), 4) into @returnValue
from
(
	select
		RISK_NODE_ID,
		rn_sub_risk_id,
		rpn / cvgGetRiskNodeRPN(RISK_NODE_ID) * max(case when control_id != controlId then coverage else 0 end) C2_WITHOUT
	from
	(
	select
				rnsr.RISK_NODE_ID,
				rnsr.RN_SUB_RISK_ID,
				rnc.CONTROL_ID,
				rnsr.LIKELIHOOD * rnsr.IMPACT RPN,
				case 
					when rnsr.FIXED = 'Y' and rnsr.COVERAGE < rnc.EFFECTIVENESS then rnsr.COVERAGE 
					else rnc.EFFECTIVENESS 
				end COVERAGE
			from cvg_risk_node_sub_risk rnsr
			join cvg_risk_node rn on rn.RISK_NODE_ID = rnsr.RISK_NODE_ID
			left join cvg_risk_node_control_sub_risk_link rncsr on rncsr.RN_SUB_RISK_ID = rnsr.RN_SUB_RISK_ID
			left join cvg_risk_node_control rnc on rnc.RN_CONTROL_ID = rncsr.RN_CONTROL_ID
			join cvg_control cc on cc.CONTROL_ID = rnc.CONTROL_ID
			left join dfl_control_catalogue dfcc on dfcc.CVG_CONTROL_ID = rnc.CONTROL_ID
			left join dfl_procedure dfp on dfp.PROCEDURE_ID = dfcc.PROCEDURE_ID and cc.CONTROL_TYPE='C' 
			left join amx_metric_catalogue mc on mc.CVG_CONTROL_ID = rnc.CONTROL_ID and cc.CONTROL_TYPE='M'
			where 1=1
				and rnsr.RISK_NODE_ID = riskNodeId
				and rnsr.RN_SUB_RISK_ID in (
					select distinct RN_SUB_RISK_ID 
					from cvg_risk_node_control rnc 
					join cvg_risk_node_sub_risk rnsr on rnsr.RISK_NODE_ID = rnc.RISK_NODE_ID
					where rnc.CONTROL_ID = controlId          
				)
				and (case 
					when cc.CONTROL_TYPE = 'C' and dfp.STATUS_CODE in ('A') then 1
					when cc.CONTROL_TYPE = 'M' and mc.RELEVANT='Y' and mc.IMPLEMENTED='Y' then 1
					else 0
				end) > 0
	) as sub1
	group by risk_node_id, rn_sub_risk_id, rpn
) as sub2;

	RETURN @returnValue ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cvgGetRiskNodeMeasureCoverage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `cvgGetRiskNodeMeasureCoverage`(id int(11)) RETURNS decimal(10,4)
BEGIN

	SELECT 
		count(distinct rncm.MEASURE_ID)/count(distinct m.MEASURE_ID)*100 into @returnValue
	FROM cvg_risk_node rn
	
	join cvg_risk r on r.RISK_ID = rn.RISK_ID
	join cvg_measure m on r.BUSINESS_SUB_PROCESS_ID = m.BUSINESS_SUB_PROCESS_ID and m.REQUIRED = 'Y'
	join cvg_risk_measure_link rml on rml.RISK_ID = rn.RISK_ID and rml.MEASURE_ID = m.MEASURE_ID
	
	left join cvg_risk_node_control rnc on rnc.RISK_NODE_ID = rn.RISK_NODE_ID
	left join cvg_risk_node_control_measure_link rncm on rncm.RN_CONTROL_ID = rnc.RN_CONTROL_ID and rncm.MEASURE_ID = m.MEASURE_ID
	where rn.RISK_NODE_ID = id
	group by 
		rn.RISK_NODE_ID;

	RETURN @returnValue ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cvgGetRiskNodeRPN` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `cvgGetRiskNodeRPN`(id int(11)) RETURNS int(11)
BEGIN
	SELECT 
		ifnull(sum(LIKELIHOOD * IMPACT),0)  into @returnValue 
    FROM tag.cvg_risk_node_sub_risk
	where RISK_NODE_ID = id;

	RETURN @returnValue ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cvgGetRiskNodeSubRiskCoverage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `cvgGetRiskNodeSubRiskCoverage`(in_RN_SUB_RISK_ID int(11)) RETURNS decimal(5,2)
BEGIN
	select COVERAGE, FIXED into @fixedCoverage, @isFixed
    from cvg_risk_node_sub_risk
	where RN_SUB_RISK_ID = in_RN_SUB_RISK_ID;
    
	select 
		count(rnc.CONTROL_ID), ifnull(max(rnc.EFFECTIVENESS),0) into @controlCount, @maxControlEffectiveness
    from cvg_risk_node_sub_risk rnsr
	left join cvg_risk_node_control_sub_risk_link rncsr on rncsr.RN_SUB_RISK_ID = rnsr.RN_SUB_RISK_ID
	left join cvg_risk_node_control rnc on rnc.RN_CONTROL_ID = rncsr.RN_CONTROL_ID
	join cvg_control cc on cc.CONTROL_ID = rnc.CONTROL_ID
	left join dfl_control_catalogue dfcc on dfcc.CVG_CONTROL_ID = rnc.CONTROL_ID
	left join dfl_procedure dfp on dfp.PROCEDURE_ID = dfcc.PROCEDURE_ID and cc.CONTROL_TYPE='C' 
	left join amx_metric_catalogue mc on mc.CVG_CONTROL_ID = rnc.CONTROL_ID and cc.CONTROL_TYPE='M'
	where rnsr.RN_SUB_RISK_ID = in_RN_SUB_RISK_ID
		and (case 
			when cc.CONTROL_TYPE = 'C' and dfp.STATUS_CODE in ('A') then 1
			when cc.CONTROL_TYPE = 'M' and mc.RELEVANT='Y' and mc.IMPLEMENTED='Y' then 1
			else 0
		end) > 0;
    
    if @isFixed = 'Y' and  @controlCount > 0 then set @returnValue = @fixedCoverage;
    elseif @isFixed = 'N' and @controlCount > 0 then set @returnValue = @maxControlEffectiveness;
    else set @returnValue = 0;
    end if;

	RETURN @returnValue;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cvgGetRiskNodeSubRiskCoverageOld` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `cvgGetRiskNodeSubRiskCoverageOld`(in_RN_SUB_RISK_ID int(11)) RETURNS decimal(5,2)
BEGIN
	select COVERAGE, FIXED into @fixedCoverage, @isFixed
    from cvg_risk_node_sub_risk
	where RN_SUB_RISK_ID = in_RN_SUB_RISK_ID;
    
	select 
		count(rnc.CONTROL_ID), ifnull(max(rnc.EFFECTIVENESS),0) into @controlCount, @maxControlEffectiveness
    from cvg_risk_node_sub_risk rnsr
	left join cvg_risk_node_control_sub_risk_link rncsr on rncsr.RN_SUB_RISK_ID = rnsr.RN_SUB_RISK_ID
	left join cvg_risk_node_control rnc on rnc.RN_CONTROL_ID = rncsr.RN_CONTROL_ID
	where rnsr.RN_SUB_RISK_ID = in_RN_SUB_RISK_ID;
    
    if @isFixed = 'Y' and  @controlCount > 0 then set @returnValue = @fixedCoverage;
    elseif @isFixed = 'N' and @controlCount > 0 then set @returnValue = @maxControlEffectiveness;
    else set @returnValue = 0;
    end if;

	RETURN @returnValue;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cvgGetRiskNodeValue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `cvgGetRiskNodeValue`(id int(11)) RETURNS decimal(20,5)
BEGIN
	SELECT 
		ifnull(sum(rnsr.LIKELIHOOD * rnsr.IMPACT),0)/cvgGetProductSegmentRPN(rn.PRODUCT_SEGMENT_ID) * cvgGetProductSegmentValue(rn.PRODUCT_SEGMENT_ID) into @returnValue
    FROM cvg_risk_node_sub_risk rnsr
    join cvg_risk_node rn on rn.RISK_NODE_ID = rnsr.RISK_NODE_ID
	where rnsr.RISK_NODE_ID = id;

	RETURN @returnValue ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `cvgGetTotalOpcoValue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `cvgGetTotalOpcoValue`(opcoId int(11)) RETURNS decimal(20,5)
BEGIN
	SELECT sum(abs(a.value)) into @returnValue 
	from cvg_product_segment a
	where a.opco_id = opcoId;

	RETURN @returnValue ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cvgCloneControls` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `cvgCloneControls`(IN cloneFromRiskNodeId INT, IN cloneToRiskNodeId INT)
BEGIN

	DECLARE cloneControlsLoop boolean;
	DECLARE exitLoop boolean;    
	DECLARE v_ControlId int;  
    DECLARE v_RNControlId int;
	DECLARE v_Effectiveness decimal(5,2);         

	
	DECLARE cloneControlsCur CURSOR FOR 
		SELECT 
			RN_CONTROL_ID,
			CONTROL_ID, 
            EFFECTIVENESS 
		FROM cvg_risk_node_control 
        WHERE RISK_NODE_ID = cloneFromRiskNodeId
			and CONTROL_ID not in (select CONTROL_ID 
									from cvg_risk_node_control 
                                    where RISK_NODE_ID = cloneToRiskNodeId);

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET exitLoop = TRUE;

	
    
	OPEN cloneControlsCur;
	
	cloneControlsLoop: LOOP
		
		FETCH cloneControlsCur INTO v_RNControlId, v_ControlId, v_Effectiveness;
		
		IF exitLoop THEN
			CLOSE cloneControlsCur;
			LEAVE cloneControlsLoop;
		ELSE
			
			INSERT INTO cvg_risk_node_control
			(`RISK_NODE_ID`, `CONTROL_ID`, `EFFECTIVENESS`)
			VALUES 
			(cloneToRiskNodeId, v_ControlId, v_Effectiveness);
			set @newRNControlId = LAST_INSERT_ID();
            
            
            insert into cvg_risk_node_control_sub_risk_link (RN_CONTROL_ID, RN_SUB_RISK_ID)
            select @newRNControlId, a.RN_SUB_RISK_ID from tag.cvg_risk_node_sub_risk a
			join tag.cvg_risk_node_sub_risk b on b.SUB_RISK_ID = a.SUB_RISK_ID
			join tag.cvg_risk_node_control_sub_risk_link c on c.RN_SUB_RISK_ID = b.RN_SUB_RISK_ID and c.RN_CONTROL_ID = v_RNControlId
			where a.RISK_NODE_ID = cloneToRiskNodeId and b.RISK_NODE_ID=cloneFromRiskNodeId;
            
            
            
            
			update tag.cvg_risk_node_sub_risk a
			join tag.cvg_risk_node_sub_risk b on b.SUB_RISK_ID = a.SUB_RISK_ID
			set a.COVERAGE = b.COVERAGE, a.FIXED = b.FIXED 
			where a.RISK_NODE_ID = cloneToRiskNodeId and b.RISK_NODE_ID = cloneFromRiskNodeId;
            
            
            insert into cvg_risk_node_control_measure_link (RN_CONTROL_ID, MEASURE_ID)
            select distinct @newRNControlId, a.MEASURE_ID 
            from cvg_risk_node_control_measure_link a
            join cvg_risk_node b on b.RISK_NODE_ID = cloneToRiskNodeId
            join cvg_risk_measure_link c on c.RISK_ID = b.RISK_ID
			where a.RN_CONTROL_ID = v_RNControlId;
            
		END IF;
	END LOOP cloneControlsLoop;

	
	update tag.cvg_risk_node a
	set a.COVERAGE =cvgGetRiskNodeCoverage(a.RISK_NODE_ID)  
	where a.RISK_NODE_ID = cloneToRiskNodeId;  
            
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cvgCloneProductSegment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `cvgCloneProductSegment`(IN cloneFromProductSegmentId INT, IN cloneToProductSegmentId INT)
BEGIN

	DECLARE cloneSegmentLoop boolean;
	DECLARE exitLoop boolean; 
	DECLARE v_RiskNodeId int;      
	DECLARE v_OpcoId int;  
    DECLARE v_RiskId int;
	DECLARE v_SystemId int;
    DECLARE v_Coverage decimal(5,2);
    DECLARE v_MeasureCoverage decimal(5,2);

	
	DECLARE cloneProductSegmentCur CURSOR FOR 
		SELECT 
			`RISK_NODE_ID`, `OPCO_ID`, `RISK_ID`, `SYSTEM_ID`, `COVERAGE`, `MEASURE_COVERAGE`            
		FROM cvg_risk_node 
        WHERE PRODUCT_SEGMENT_ID = cloneFromProductSegmentId;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET exitLoop = TRUE;

	
    delete from cvg_risk_node
    where PRODUCT_SEGMENT_ID = cloneToProductSegmentId;
    
	OPEN cloneProductSegmentCur;
	
	cloneSegmentLoop: LOOP
		
		FETCH cloneProductSegmentCur INTO v_RiskNodeId, v_OpcoId, v_RiskId, v_SystemId, v_Coverage, v_MeasureCoverage;
		
		IF exitLoop THEN
			CLOSE cloneProductSegmentCur;
			LEAVE cloneSegmentLoop;
		ELSE
			
			INSERT INTO cvg_risk_node
			(`PRODUCT_SEGMENT_ID`, `OPCO_ID`, `RISK_ID`, `SYSTEM_ID`, `COVERAGE`, `MEASURE_COVERAGE`)
			VALUES 
			(cloneToProductSegmentId, v_OpcoId, v_RiskId, v_SystemId, v_Coverage, v_MeasureCoverage);
			set @newRiskNodeId = LAST_INSERT_ID();
            
            
            call cvgCloneRiskNode(v_RiskNodeId, @newRiskNodeId);
            
		END IF;
	END LOOP cloneSegmentLoop;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cvgCloneRiskNode` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `cvgCloneRiskNode`(IN cloneFromRiskNodeId INT, IN cloneToRiskNodeId INT)
BEGIN

	DECLARE cloneControlsLoop boolean;
	DECLARE exitLoop boolean;    
	DECLARE v_ControlId int;  
    DECLARE v_RNControlId int;
	DECLARE v_Effectiveness decimal(5,2);         

	
	DECLARE cloneControlsCur CURSOR FOR 
		SELECT 
			RN_CONTROL_ID,
			CONTROL_ID, 
            EFFECTIVENESS 
		FROM cvg_risk_node_control 
        WHERE RISK_NODE_ID = cloneFromRiskNodeId
			and CONTROL_ID not in (select CONTROL_ID 
									from cvg_risk_node_control 
                                    where RISK_NODE_ID = cloneToRiskNodeId);

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET exitLoop = TRUE;

	
	
	delete from cvg_risk_node_sub_risk
    where RISK_NODE_ID = cloneToRiskNodeId;
	
    
    delete from cvg_risk_node_control
    where RISK_NODE_ID = cloneToRiskNodeId;
	
	
	INSERT INTO cvg_risk_node_sub_risk
	(`RISK_NODE_ID`, `SUB_RISK_ID`, `LIKELIHOOD`, `IMPACT`, `COVERAGE`, `FIXED`)
	select  cloneToRiskNodeId, SUB_RISK_ID, LIKELIHOOD, IMPACT, COVERAGE, FIXED 
    from cvg_risk_node_sub_risk
	where RISK_NODE_ID = cloneFromRiskNodeId;    
    
	OPEN cloneControlsCur;
	
	cloneControlsLoop: LOOP
		
		FETCH cloneControlsCur INTO v_RNControlId, v_ControlId, v_Effectiveness;
		
		IF exitLoop THEN
			CLOSE cloneControlsCur;
			LEAVE cloneControlsLoop;
		ELSE
			
			INSERT INTO cvg_risk_node_control
			(`RISK_NODE_ID`, `CONTROL_ID`, `EFFECTIVENESS`)
			VALUES 
			(cloneToRiskNodeId, v_ControlId, v_Effectiveness);
			set @newRNControlId = LAST_INSERT_ID();
            
            
            insert into cvg_risk_node_control_sub_risk_link (RN_CONTROL_ID, RN_SUB_RISK_ID)
            select @newRNControlId, a.RN_SUB_RISK_ID from tag.cvg_risk_node_sub_risk a
			join tag.cvg_risk_node_sub_risk b on b.SUB_RISK_ID = a.SUB_RISK_ID
			join tag.cvg_risk_node_control_sub_risk_link c on c.RN_SUB_RISK_ID = b.RN_SUB_RISK_ID and c.RN_CONTROL_ID = v_RNControlId
			where a.RISK_NODE_ID = cloneToRiskNodeId and b.RISK_NODE_ID=cloneFromRiskNodeId;
                      
            
			update tag.cvg_risk_node_sub_risk a
			join tag.cvg_risk_node_sub_risk b on b.SUB_RISK_ID = a.SUB_RISK_ID
			set a.COVERAGE = b.COVERAGE, a.FIXED = b.FIXED 
			where a.RISK_NODE_ID = cloneToRiskNodeId and b.RISK_NODE_ID = cloneFromRiskNodeId;            
            
            
            insert into cvg_risk_node_control_measure_link (RN_CONTROL_ID, MEASURE_ID)
            select distinct @newRNControlId, a.MEASURE_ID 
            from cvg_risk_node_control_measure_link a
            join cvg_risk_node b on b.RISK_NODE_ID = cloneToRiskNodeId
            join cvg_risk_measure_link c on c.RISK_ID = b.RISK_ID
			where a.RN_CONTROL_ID = v_RNControlId;
            
		END IF;
	END LOOP cloneControlsLoop;

	
	update tag.cvg_risk_node a
	set a.COVERAGE =cvgGetRiskNodeCoverage(a.RISK_NODE_ID)  
	where a.RISK_NODE_ID = cloneToRiskNodeId; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cvgCloneRiskNodeToProductSegment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `cvgCloneRiskNodeToProductSegment`(IN cloneFromRiskNodeId INT, IN cloneToProductSegmentId INT)
BEGIN

	replace into cvg_risk_node (OPCO_ID, PRODUCT_SEGMENT_ID, RISK_ID, SYSTEM_ID, COVERAGE, MEASURE_COVERAGE)
    select OPCO_ID, cloneToProductSegmentId, RISK_ID, SYSTEM_ID, COVERAGE, MEASURE_COVERAGE
    from cvg_risk_node where RISK_NODE_ID = cloneFromRiskNodeId;
    
	set @cloneToRiskNodeId = LAST_INSERT_ID();

	call cvgCloneRiskNode(cloneFromRiskNodeId, @cloneToRiskNodeId);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cvgRefreshControlCoverage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `cvgRefreshControlCoverage`(IN controlId INT)
BEGIN
	update cvg_control a
	set 
		a.CTRL_COVERAGE = round(cvgGetControlCoverage(a.CONTROL_ID), 4), 
        a.CTRL_COVERAGE_OVERLAP = round(cvgGetControlCoverageOverlap(a.CONTROL_ID), 4)
	where a.CONTROL_ID = controlId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cvgRefreshControlSystemMix` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `cvgRefreshControlSystemMix`()
BEGIN
	truncate table cvg_control_system_mix;

	insert into cvg_control_system_mix
	select * from tag.v_cvg_control_system_mix;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `v_counters`
--

/*!50001 DROP VIEW IF EXISTS `v_counters`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `v_counters` AS select `a`.`OPCO_ID` AS `OPCO_ID`,sum((case when (`b`.`COUNTER` = 'openChangeRequests') then `b`.`CNT` else 0 end)) AS `openChangeRequests`,sum((case when (`b`.`COUNTER` = 'openIncidents') then `b`.`CNT` else 0 end)) AS `openIncidents`,sum((case when (`b`.`COUNTER` = 'openAlarms') then `b`.`CNT` else 0 end)) AS `openAlarms`,sum((case when (`b`.`COUNTER` = 'openTasks') then `b`.`CNT` else 0 end)) AS `openTasks` from (`tag`.`amx_opco` `a` left join (select 0 AS `OPCO_ID`,'openChangeRequests' AS `COUNTER`,count(0) AS `CNT` from `tag`.`amx_change_request` where (`tag`.`amx_change_request`.`STATUS` = 'Requested') union all select `tag`.`amx_change_request`.`OPCO_ID` AS `OPCO_ID`,'openChangeRequests' AS `COUNTER`,count(0) AS `CNT` from `tag`.`amx_change_request` where ((`tag`.`amx_change_request`.`ARCHIVED` = 'N') and (`tag`.`amx_change_request`.`OPCO_ID` > 0)) group by `tag`.`amx_change_request`.`OPCO_ID` union all select 0 AS `OPCO_ID`,'openIncidents' AS `COUNTER`,count(0) AS `CNT` from `tag`.`amx_incident` where (`tag`.`amx_incident`.`STATUS` <> 'Closed') union all select `tag`.`amx_incident`.`OPCO_ID` AS `OPCO_ID`,'openIncidents' AS `COUNTER`,count(0) AS `CNT` from `tag`.`amx_incident` where ((`tag`.`amx_incident`.`STATUS` <> 'Closed') and (`tag`.`amx_incident`.`OPCO_ID` > 0)) group by `tag`.`amx_incident`.`OPCO_ID` union all select 0 AS `OPCO_ID`,'openAlarms' AS `COUNTER`,count(0) AS `CNT` from `tag`.`amx_alarm` where (`tag`.`amx_alarm`.`STATUS` <> 'Closed') union all select `tag`.`amx_alarm`.`OPCO_ID` AS `OPCO_ID`,'openAlarms' AS `COUNTER`,count(0) AS `CNT` from `tag`.`amx_alarm` where ((`tag`.`amx_alarm`.`STATUS` <> 'Closed') and (`tag`.`amx_alarm`.`OPCO_ID` > 0)) group by `tag`.`amx_alarm`.`OPCO_ID` union all select 0 AS `OPCO_ID`,'openTasks' AS `COUNTER`,count(0) AS `CNT` from `tag`.`amx_task` where (`tag`.`amx_task`.`STATUS` = 'Open - TAG') union all select `tag`.`amx_task`.`OPCO_ID` AS `OPCO_ID`,'openTasks' AS `COUNTER`,count(0) AS `CNT` from `tag`.`amx_task` where ((`tag`.`amx_task`.`STATUS` = 'Open - OPCO') and (`tag`.`amx_task`.`OPCO_ID` > 0)) group by `tag`.`amx_task`.`OPCO_ID`) `b` on((`b`.`OPCO_ID` = `a`.`OPCO_ID`))) group by `a`.`OPCO_ID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_cvg_control`
--

/*!50001 DROP VIEW IF EXISTS `v_cvg_control`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `v_cvg_control` AS select `ctrl`.`OPCO_ID` AS `OPCO_ID`,`ctrl`.`CONTROL_ID` AS `CONTROL_ID`,`ctrl`.`CONTROL_REF` AS `CONTROL_REF`,`ctrl`.`CONTROL_TYPE` AS `CONTROL_TYPE`,`ctrl`.`CONTROL_NAME` AS `CONTROL_NAME`,`ctrl`.`DESCRIPTION` AS `DESCRIPTION`,`ctrl`.`STATUS_CODE` AS `STATUS_CODE`,`ctrl`.`STATUS_CODE_TEXT` AS `STATUS_CODE_TEXT`,`ctrl`.`FREQUENCY` AS `FREQUENCY`,ifnull(`cnt`.`CVG_RN_CNT`,0) AS `CVG_RN_CNT`,`ctrl`.`CTRL_COVERAGE` AS `CTRL_COVERAGE`,`ctrl`.`CTRL_COVERAGE_OVERLAP` AS `CTRL_COVERAGE_OVERLAP` from (((select `mc`.`OPCO_ID` AS `OPCO_ID`,`c`.`CONTROL_ID` AS `CONTROL_ID`,`c`.`CTRL_COVERAGE` AS `CTRL_COVERAGE`,`c`.`CTRL_COVERAGE_OVERLAP` AS `CTRL_COVERAGE_OVERLAP`,`mc`.`METRIC_ID` AS `CONTROL_REF`,`c`.`CONTROL_TYPE` AS `CONTROL_TYPE`,`mc`.`METRIC_ID` AS `CONTROL_NAME`,concat(`mc`.`NAME`,' - ',`mc`.`DESCRIPTION`) AS `DESCRIPTION`,(case when (`mc`.`RELEVANT` = 'N') then 'I' when (`mc`.`IMPLEMENTED` = 'N') then 'D' else 'A' end) AS `STATUS_CODE`,(case when (`mc`.`RELEVANT` = 'N') then 'Not relevant - inactive' when (`mc`.`IMPLEMENTED` = 'Y') then 'Active - fine-tuned' else 'In fine-tuning' end) AS `STATUS_CODE_TEXT`,`mc`.`FREQUENCY` AS `FREQUENCY` from (`tag`.`cvg_control` `c` left join `tag`.`amx_metric_catalogue` `mc` on((`mc`.`CVG_CONTROL_ID` = `c`.`CONTROL_ID`))) where (`c`.`CONTROL_TYPE` = 'M')) union select `p`.`OPCO_ID` AS `OPCO_ID`,`c`.`CONTROL_ID` AS `CONTROL_ID`,`c`.`CTRL_COVERAGE` AS `CTRL_COVERAGE`,`c`.`CTRL_COVERAGE_OVERLAP` AS `CTRL_COVERAGE_OVERLAP`,`p`.`PROCEDURE_ID` AS `CONTROL_REF`,`c`.`CONTROL_TYPE` AS `CONTROL_TYPE`,`p`.`NAME` AS `CONTROL_NAME`,`p`.`DESCRIPTION` AS `DESCRIPTION`,`p`.`STATUS_CODE` AS `STATUS_CODE`,(case when (`p`.`STATUS_CODE` = 'A') then 'Active' when (`p`.`STATUS_CODE` = 'I') then 'Inactive' when (`p`.`STATUS_CODE` = 'D') then 'Development' when (`p`.`STATUS_CODE` = 'P') then 'Plan' end) AS `STATUS_CODE_TEXT`,`sch`.`FREQUENCY` AS `FREQUENCY` from (((`tag`.`cvg_control` `c` left join `tag`.`dfl_control_catalogue` `cc` on((`cc`.`CVG_CONTROL_ID` = `c`.`CONTROL_ID`))) join `tag`.`dfl_procedure` `p` on((`p`.`PROCEDURE_ID` = `cc`.`PROCEDURE_ID`))) left join `tag`.`dfl_schedule` `sch` on((`sch`.`SCHEDULE_ID` = `p`.`SCHEDULE_ID`))) where (`c`.`CONTROL_TYPE` = 'C')) `ctrl` left join (select `tag`.`cvg_risk_node_control`.`CONTROL_ID` AS `CONTROL_ID`,count(0) AS `CVG_RN_CNT` from `tag`.`cvg_risk_node_control` group by `tag`.`cvg_risk_node_control`.`CONTROL_ID`) `cnt` on((`ctrl`.`CONTROL_ID` = `cnt`.`CONTROL_ID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_cvg_control_system_mix`
--

/*!50001 DROP VIEW IF EXISTS `v_cvg_control_system_mix`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `v_cvg_control_system_mix` AS select distinct coalesce(`ds6`.`system_name`,`ds5`.`system_name`,`ds4`.`system_name`,`ds3`.`system_name`,`ds2`.`system_name`,`ds1`.`system_name`) AS `SYSTEM_NAME`,coalesce(`ds6`.`SYSTEM_ID`,`ds5`.`SYSTEM_ID`,`ds4`.`SYSTEM_ID`,`ds3`.`SYSTEM_ID`,`ds2`.`SYSTEM_ID`,`ds1`.`SYSTEM_ID`) AS `SYSTEM_ID`,'M' AS `CONTROL_TYPE`,`p1`.`OPCO_ID` AS `OPCO_ID`,`m`.`CVG_CONTROL_ID` AS `CVG_CONTROL_ID` from (((((((((((((((((((`tag`.`amx_metric_catalogue` `m` join `tag`.`amx_metric_dato_link` `md` on(((`m`.`METRIC_ID` = `md`.`METRIC_ID`) and (`m`.`OPCO_ID` = `md`.`OPCO_ID`)))) join `tag`.`dfl_procedure` `p1` on(((`md`.`DATO_ID` = `p1`.`NAME`) and (`md`.`OPCO_ID` = `p1`.`OPCO_ID`) and (`p1`.`TYPE` = 't')))) join `tag`.`v_dfl_dataflow_direct` `dfi1` on(((`p1`.`PROCEDURE_ID` = `dfi1`.`PROCEDURE_ID`) and (`dfi1`.`DIRECTION` = 'I')))) join `tag`.`v_dfl_datasource_denorm` `ds1` on((`dfi1`.`DATASOURCE_ID` = `ds1`.`datasource_id`))) left join `tag`.`v_dfl_dataflow_direct` `dfo1` on(((`dfi1`.`DATASOURCE_ID` = `dfo1`.`DATASOURCE_ID`) and (`dfo1`.`DIRECTION` = 'O')))) left join `tag`.`v_dfl_dataflow_direct` `dfi2` on(((`dfo1`.`PROCEDURE_ID` = `dfi2`.`PROCEDURE_ID`) and (`dfi2`.`DIRECTION` = 'I')))) left join `tag`.`v_dfl_datasource_denorm` `ds2` on((`dfi2`.`DATASOURCE_ID` = `ds2`.`datasource_id`))) left join `tag`.`v_dfl_dataflow_direct` `dfo2` on(((`dfi2`.`DATASOURCE_ID` = `dfo2`.`DATASOURCE_ID`) and (`dfo2`.`DIRECTION` = 'O')))) left join `tag`.`v_dfl_dataflow_direct` `dfi3` on(((`dfo2`.`PROCEDURE_ID` = `dfi3`.`PROCEDURE_ID`) and (`dfi3`.`DIRECTION` = 'I')))) left join `tag`.`v_dfl_datasource_denorm` `ds3` on((`dfi3`.`DATASOURCE_ID` = `ds3`.`datasource_id`))) left join `tag`.`v_dfl_dataflow_direct` `dfo3` on(((`dfi3`.`DATASOURCE_ID` = `dfo3`.`DATASOURCE_ID`) and (`dfo3`.`DIRECTION` = 'O')))) left join `tag`.`v_dfl_dataflow_direct` `dfi4` on(((`dfo3`.`PROCEDURE_ID` = `dfi4`.`PROCEDURE_ID`) and (`dfi4`.`DIRECTION` = 'I')))) left join `tag`.`v_dfl_datasource_denorm` `ds4` on((`dfi4`.`DATASOURCE_ID` = `ds4`.`datasource_id`))) left join `tag`.`v_dfl_dataflow_direct` `dfo4` on(((`dfi4`.`DATASOURCE_ID` = `dfo4`.`DATASOURCE_ID`) and (`dfo4`.`DIRECTION` = 'O')))) left join `tag`.`v_dfl_dataflow_direct` `dfi5` on(((`dfo4`.`PROCEDURE_ID` = `dfi5`.`PROCEDURE_ID`) and (`dfi5`.`DIRECTION` = 'I')))) left join `tag`.`v_dfl_datasource_denorm` `ds5` on((`dfi5`.`DATASOURCE_ID` = `ds5`.`datasource_id`))) left join `tag`.`v_dfl_dataflow_direct` `dfo5` on(((`dfi5`.`DATASOURCE_ID` = `dfo5`.`DATASOURCE_ID`) and (`dfo5`.`DIRECTION` = 'O')))) left join `tag`.`v_dfl_dataflow_direct` `dfi6` on(((`dfo5`.`PROCEDURE_ID` = `dfi6`.`PROCEDURE_ID`) and (`dfi6`.`DIRECTION` = 'I')))) left join `tag`.`v_dfl_datasource_denorm` `ds6` on((`dfi6`.`DATASOURCE_ID` = `ds6`.`datasource_id`))) where ((1 = 1) and (coalesce(`ds6`.`system_name`,`ds5`.`system_name`,`ds4`.`system_name`,`ds3`.`system_name`,`ds2`.`system_name`,`ds1`.`system_name`) <> 'RA (MoneyMap)')) union all select distinct coalesce(`ds6`.`system_name`,`ds5`.`system_name`,`ds4`.`system_name`,`ds3`.`system_name`,`ds2`.`system_name`,`ds1`.`system_name`) AS `Name_exp_5`,coalesce(`ds6`.`SYSTEM_ID`,`ds5`.`SYSTEM_ID`,`ds4`.`SYSTEM_ID`,`ds3`.`SYSTEM_ID`,`ds2`.`SYSTEM_ID`,`ds1`.`SYSTEM_ID`) AS `Name_exp_6`,`p1`.`TYPE` AS `type`,`p1`.`OPCO_ID` AS `OPCO_ID`,`cc`.`CVG_CONTROL_ID` AS `CVG_CONTROL_ID` from ((((((((((((((((((`tag`.`dfl_procedure` `p1` join `tag`.`dfl_control_catalogue` `cc` on((`p1`.`PROCEDURE_ID` = `cc`.`PROCEDURE_ID`))) join `tag`.`v_dfl_dataflow_direct` `dfi1` on(((`p1`.`PROCEDURE_ID` = `dfi1`.`PROCEDURE_ID`) and (`dfi1`.`DIRECTION` = 'I')))) join `tag`.`v_dfl_datasource_denorm` `ds1` on((`dfi1`.`DATASOURCE_ID` = `ds1`.`datasource_id`))) left join `tag`.`v_dfl_dataflow_direct` `dfo1` on(((`dfi1`.`DATASOURCE_ID` = `dfo1`.`DATASOURCE_ID`) and (`dfo1`.`DIRECTION` = 'O')))) left join `tag`.`v_dfl_dataflow_direct` `dfi2` on(((`dfo1`.`PROCEDURE_ID` = `dfi2`.`PROCEDURE_ID`) and (`dfi2`.`DIRECTION` = 'I')))) left join `tag`.`v_dfl_datasource_denorm` `ds2` on((`dfi2`.`DATASOURCE_ID` = `ds2`.`datasource_id`))) left join `tag`.`v_dfl_dataflow_direct` `dfo2` on(((`dfi2`.`DATASOURCE_ID` = `dfo2`.`DATASOURCE_ID`) and (`dfo2`.`DIRECTION` = 'O')))) left join `tag`.`v_dfl_dataflow_direct` `dfi3` on(((`dfo2`.`PROCEDURE_ID` = `dfi3`.`PROCEDURE_ID`) and (`dfi3`.`DIRECTION` = 'I')))) left join `tag`.`v_dfl_datasource_denorm` `ds3` on((`dfi3`.`DATASOURCE_ID` = `ds3`.`datasource_id`))) left join `tag`.`v_dfl_dataflow_direct` `dfo3` on(((`dfi3`.`DATASOURCE_ID` = `dfo3`.`DATASOURCE_ID`) and (`dfo3`.`DIRECTION` = 'O')))) left join `tag`.`v_dfl_dataflow_direct` `dfi4` on(((`dfo3`.`PROCEDURE_ID` = `dfi4`.`PROCEDURE_ID`) and (`dfi4`.`DIRECTION` = 'I')))) left join `tag`.`v_dfl_datasource_denorm` `ds4` on((`dfi4`.`DATASOURCE_ID` = `ds4`.`datasource_id`))) left join `tag`.`v_dfl_dataflow_direct` `dfo4` on(((`dfi4`.`DATASOURCE_ID` = `dfo4`.`DATASOURCE_ID`) and (`dfo4`.`DIRECTION` = 'O')))) left join `tag`.`v_dfl_dataflow_direct` `dfi5` on(((`dfo4`.`PROCEDURE_ID` = `dfi5`.`PROCEDURE_ID`) and (`dfi5`.`DIRECTION` = 'I')))) left join `tag`.`v_dfl_datasource_denorm` `ds5` on((`dfi5`.`DATASOURCE_ID` = `ds5`.`datasource_id`))) left join `tag`.`v_dfl_dataflow_direct` `dfo5` on(((`dfi5`.`DATASOURCE_ID` = `dfo5`.`DATASOURCE_ID`) and (`dfo5`.`DIRECTION` = 'O')))) left join `tag`.`v_dfl_dataflow_direct` `dfi6` on(((`dfo5`.`PROCEDURE_ID` = `dfi6`.`PROCEDURE_ID`) and (`dfi6`.`DIRECTION` = 'I')))) left join `tag`.`v_dfl_datasource_denorm` `ds6` on((`dfi6`.`DATASOURCE_ID` = `ds6`.`datasource_id`))) where ((1 = 1) and (coalesce(`ds6`.`system_name`,`ds5`.`system_name`,`ds4`.`system_name`,`ds3`.`system_name`,`ds2`.`system_name`,`ds1`.`system_name`) <> 'RA (MoneyMap)') and (`p1`.`TYPE` = 'c')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_dfl_dataflow_direct`
--

/*!50001 DROP VIEW IF EXISTS `v_dfl_dataflow_direct`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `v_dfl_dataflow_direct` AS select `df`.`DATAFLOW_ID` AS `DATAFLOW_ID`,`df`.`PROCEDURE_ID` AS `PROCEDURE_ID`,`df`.`DATASOURCE_ID` AS `DATASOURCE_ID`,`df`.`DIRECTION` AS `DIRECTION` from (`dfl_dataflow` `df` join `dfl_procedure` `prc` on((`df`.`PROCEDURE_ID` = `prc`.`PROCEDURE_ID`))) where ((1 = 1) and ((`prc`.`TYPE` <> 'J') or (`prc`.`SUB_TYPE` <> 'Oracle Procedure') or (`prc`.`OPCO_ID` <> 36) or ((not((`prc`.`NAME` like 'UPDATE%'))) and (`prc`.`NAME` <> 'USAGEPRERUNRULEHOOK')))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_dfl_datasource_denorm`
--

/*!50001 DROP VIEW IF EXISTS `v_dfl_datasource_denorm`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `v_dfl_datasource_denorm` AS select `ds`.`DATASOURCE_ID` AS `datasource_id`,`ds`.`NAME` AS `datasource_name`,`ds`.`INTERFACE_ID` AS `interface_id`,`ifc`.`INTERFACE_NAME` AS `interface_name`,`s`.`NAME` AS `system_name`,`s`.`SYSTEM_ID` AS `SYSTEM_ID` from ((((select `tag`.`dfl_datasource`.`DATASOURCE_ID` AS `DATASOURCE_ID`,`tag`.`dfl_datasource`.`NAME` AS `NAME`,(case when ((`tag`.`dfl_datasource`.`OPCO_ID` = 36) and (`tag`.`dfl_datasource`.`NAME` like 'DS_ERP%')) then 17 when ((`tag`.`dfl_datasource`.`OPCO_ID` = 36) and (`tag`.`dfl_datasource`.`NAME` like 'DS_P05%')) then 96 else `tag`.`dfl_datasource`.`INTERFACE_ID` end) AS `INTERFACE_ID`,`tag`.`dfl_datasource`.`TYPE` AS `TYPE` from `tag`.`dfl_datasource`)) `ds` left join `tag`.`dfl_interface` `ifc` on((`ds`.`INTERFACE_ID` = `ifc`.`INTERFACE_ID`))) left join `tag`.`amx_system` `s` on((`ifc`.`IFC_SYSTEM_ID` = `s`.`SYSTEM_ID`))) where (`ds`.`TYPE` in ('D','F')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-04-19  9:54:36
