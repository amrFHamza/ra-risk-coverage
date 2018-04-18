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
  `SOURCE` enum('TMF','TAG') DEFAULT 'TMF',
  PRIMARY KEY (`BUSINESS_PROCESS_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_business_process`
--

LOCK TABLES `cvg_business_process` WRITE;
/*!40000 ALTER TABLE `cvg_business_process` DISABLE KEYS */;
INSERT INTO `cvg_business_process` VALUES (10,'Product and Offer management','Commercial issues associated with product conception that may result in the development of unprofitable products and services as well as the timing of product launches and special offers which may be made from time to time, or relates to product mix versus business targets and market dynamics.','TMF'),(20,'Customer management','Issues relating to the on-going relationship with customers, including subscriber identity issues, customer adjustments and rebates, SLA penalty payments, incorrect charging and discounting.','TMF'),(30,'Order Entry and Provisioning','Issues in the process of capturing and fulfilling orders from both domestic subscribers and commercial organisations, including errors in customer contracts, service activation faults or delays that impact revenues and/or costs as well as the coordination of suppliers and third party costs.','TMF'),(40,'Network and usage Management','Issues relating to the accurate accounting of service usage within the network and its recording as well as the management of that information as it is collected from the switching infrastructure to its delivery to the various rating and billing processes.','TMF'),(60,'Rating and Billing','Issues within the rating and billing processes, from tariff identification, tariff definition, pricing, discounting, charging, billing and invoice production.','TMF'),(80,'Partner management','Issues associated with the management of relationships with third parties, primarily business-to-business interactions with organizations such as content providers, interconnect partners, dealers, roaming partners, wholesale partners and resellers.  \nExamples include under-billing of partners, over-billing by partners, mismanagement of interconnect agreements, route optimization, charging errors, data exchange with external organizations and dealer commission payments.','TMF'),(90,'Finance and Accounting','Issues that affect the accurate reporting of the financial performance of an organization, including issues with general ledger mapping from the billing environment, tax payments with government agencies, incomplete processing of information from the billing environment and incorrect posting of entries in the chart of accounts.','TMF');
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
  `SOURCE` enum('TMF','TAG') DEFAULT 'TMF',
  PRIMARY KEY (`BUSINESS_SUB_PROCESS_ID`),
  KEY `fk_cvg_business_sub_process_1_idx` (`BUSINESS_PROCESS_ID`),
  CONSTRAINT `fk_cvg_business_sub_process_1` FOREIGN KEY (`BUSINESS_PROCESS_ID`) REFERENCES `cvg_business_process` (`BUSINESS_PROCESS_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_business_sub_process`
--

LOCK TABLES `cvg_business_sub_process` WRITE;
/*!40000 ALTER TABLE `cvg_business_sub_process` DISABLE KEYS */;
INSERT INTO `cvg_business_sub_process` VALUES (1,10,'Configuration','TMF'),(2,30,'Order Entry','TMF'),(3,30,'Provisioning','TMF'),(4,30,'Configuration','TMF'),(5,40,'Events Generation','TMF'),(6,40,'Events Collection','TMF'),(7,40,'Authentication','TMF'),(8,40,'Quality of Service','TMF'),(9,60,'Events Rating','TMF'),(10,60,'Reference','TMF'),(11,60,'Error management','TMF'),(12,60,'Rating & Billing Calculation','TMF'),(13,60,'Bill Dispersment','TMF'),(14,90,'General Ledger','TMF'),(15,90,'Margins','TMF'),(16,90,'Credit management','TMF'),(17,20,'Collection','TMF'),(18,20,'Adjustment management','TMF'),(19,20,'Customer Care','TMF'),(20,80,'Settlement','TMF'),(21,80,'Margins','TMF'),(22,80,'Commissions','TMF'),(23,80,'Disputes reconciliation','TMF'),(24,80,'Arbitrage and Bypass','TMF'),(25,60,'Receivables Management','TMF'),(26,40,'Assets Management','TMF'),(27,90,'Accruals','TMF'),(28,90,'Deferrals','TMF'),(29,30,'Invoicing','TAG');
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
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_key_risk_area`
--

LOCK TABLES `cvg_key_risk_area` WRITE;
/*!40000 ALTER TABLE `cvg_key_risk_area` DISABLE KEYS */;
INSERT INTO `cvg_key_risk_area` VALUES (1,'Asset Assurance','Stranded assets, under/over capacity, assets not decommissioned in a timely manner'),(2,'Billing Assurance','Post-paid invoicing errors, usage allowed when credit limited reached, discount errors, mutually exclusive discounts applied, incorrect tax calculations, incorrect manual intervention on billing system, discounts given when contract terms not complied with, expired promotions'),(3,'By-pass Assurance','SIM Boxing, PBX by-pass, VoIP by-pass, OTT by-pass'),(4,'Charging Assurance','Pre-paid balance movement errors, concurrent real-time charging losses, prepaid service allowed with zero/negative balance, excess charges not applied'),(5,'Commission Assurance','Commission payments in-line with sales, clawback not invoked for cancelled sales, multiple commission payments for the same sale, service does not become active'),(6,'Contract Assurance','Incorrect bespoke pricing, handsets on wrong tariff, bulk rate changes applied incorrectly'),(7,'Credit Assurance','Customer risk profile too high, bad debt write off'),(8,'Customer Experience Assurance','Products not used as expected, customer complaints, adverse social media, reputational damage, customer churn, sales growth lower than expected'),(9,'Equipment Assurance','Unnecessary delay to supply of customer premises equipment, shipping of incorrect equipment, over supply of customer premises equipment, stock write-off, equipment not repossessed at end of contract'),(10,'Error/Suspense Assurance','Revenues and costs accruing in general ledger suspense accounts'),(11,'Grey Traffic Assurance','Traffic from unknown sources, unable to determine charging zones, billable traffic made to look like unbillable traffic'),(12,'Interconnect Assurance','Under and over charging of interconnect partners, under and over payment by interconnect partners, under and over charging by interconnect partners, re-file traffic, arbitrage, unexpected traffic mix'),(13,'Loyalty Assurance','Awards made to non-qualifying members, over charging by suppliers of loyalty services, access to loyalty programme continues after contract terminated, expired loyalty promotions'),(14,'Marketing Assurance','Product definitions do not align with network capabilities, published tariffs do not agree with price book, marketing campaigns do not deliver expected take-up'),(15,'Migration Assurance','Not all customers migrated, not all products migrated, not all offers migrated, customer balance incorrect after migration, manual billing required after migration'),(16,'Mobile Money Assurance','Transactions credited more than once, over charging of transaction fees by third parties, incorrect credit transfers, cash-in not credited correctly'),(17,'MVNO Assurance','Under and over charging of MVNO partners, under and over payment by MVNO partners, under and over charging by MVNO partners, MVNO traffic not sent to third party'),(18,'Number Assurance','Inefficient management of allocated number range(s)'),(19,'Out-payment Assurance','Revenue share not calculated correctly, out-payment of value added services fees do not align with subscriber charging, under charging of content owner, over charging by content owner'),(20,'Payment Assurance','Payment credited for the wrong amount, payment credited to the wrong account, payment not linked to account, payment credited more than once, employee charges not deducted from salary correctly'),(21,'Policy Assurance','Fair use policy implemented incorrectly, fair use policy not enforced'),(22,'Pricing Assurance','Incorrect event-based pricing, incorrect event-based discount applied, incorrect zero/default rated event, incorrect apportionment between time bands, expired promotions'),(23,'Process Assurance','Incorrect process steps, process gaps, high level of manual tasks, unapproved workarounds, informal hand-offs between teams, out of date business rules'),(24,'Procurement Assurance','Purchasing of third party resources at pre-negotiated rates, bought-in third party services do not align with customer sales'),(25,'Product Assurance','New product launched but cannot be billed, products with low/negative margin products, products with low take-up, product cannot provide all services and features, offers can be exploited by customers'),(26,'Profitability Assurance','Unprofitable tariffs, unprofitable subscribers, unprofitable partners, unprofitable transit services, unprofitable marketing campaigns'),(27,'Rebate Assurance','Incorrect implementation of customer services policy, exploitation of customer services policy, repeated rebates to the same customers'),(28,'Reference Data Assurance','Out of date reference data, incorrect reference data, incomplete reference data'),(29,'Reject Assurance','Billable usage data removed from billing chain, unexpected growth in rejected billing events, rejected billable events not analysed, rejected billable events discarded'),(30,'Reporting Assurance','Incorrect chart of account mapping, annual report does not give a true and fair reflection of the business, over statement of number of subscribers'),(31,'Roaming Assurance','Incorrect identification of roaming zones, unexpected inbound roaming, double charging of roaming usage, under/over charging of roaming service charges, roaming traffic not sent to third party'),(32,'Routing Assurance','High cost routes selected, penalty rates incurred, discount rates not achieved, poor quality routes selected'),(33,'Sales Assurance','Service contracts do not adhere to sales guidelines, sales contracts do not align with product definitions, services are sold that cannot be implemented by existing products, withdrawn products continue to be sold'),(34,'Service Assurance','Service availability, service interruption, poor quality of service, denial of service, violation of service level agreements'),(35,'Subscription Assurance','Service before charging, charging before service, under/over provisioning of services and features, service after cease, charging after cease, customer on wrong plan, ex-employees still receive staff discount after leaving'),(36,'Tariff Assurance','Missing destinations, destinations do not align with traffic classes, rate plans do not agree with price book, incorrect fair use policy definition, incorrect provisioning strings associated with products, unauthorised tariff changes'),(37,'Third Party Quality Assurance','Products not used as expected, customer complaints, adverse social media, reputational damage, customer churn, sales growth lower than expected'),(38,'Usage Assurance','Incomplete/incorrect recording of service usage, billable usage removed from the billing chain, unexpected usage, duplicated usage data, usage data not sent to correct billing/settlement system'),(39,'Voucher Assurance','Top-ups applied to the wrong account, top-ups applied more than once, top-ups not credited, pending credit, ghost top-ups'),(40,'Wholesale Assurance','Under and over charging of wholesale partners, under and over payment by wholesale partners, under and over charging by wholesale partners, wholesale traffic not sent to third party');
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
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_measure`
--

LOCK TABLES `cvg_measure` WRITE;
/*!40000 ALTER TABLE `cvg_measure` DISABLE KEYS */;
INSERT INTO `cvg_measure` VALUES (1,20,18,'Completeness','Verify that all credits are not granted the “permitted” period','Look illegally granted credits. (e.g. by: count, cost and percentages)',NULL,'CM_1','Y','Y','TMF'),(2,20,18,'Completeness','Look for accounts receiving credits , exceeding a pre-defined percentage of the overall bill','Look “violating” credits. (e.g. by: count, cost and percentages)',NULL,'CM_2','Y','Y','TMF'),(3,20,18,'Completeness','Look for accounts receiving repetitive credits (of the same type or different) , exceeding a pre-defined percentage of the overall bill/s','Look “violating” credits(e.g. by: count, cost and percentages)','G.1 (2.7.1)','CM_3','Y','Y','TMF'),(4,20,18,'Completeness','Look for accounts receiving repetitive credits,  delivered  by the same agent/process','Look “violating” credits. (e.g. by: count, cost and percentages)',NULL,'CM_4','Y','Y','TMF'),(5,20,18,'Completeness','Look for Credit values higher than the organization policy (by credit type, by account type, etc.)','Look “violating” credits(e.g. by: count, cost and percentages)',NULL,'CM_5','Y','Y','TMF'),(6,20,18,'Completeness','Look for Good Will Credit values higher than the organization policy (by credit type, by account type, etc.)','Look “violating” credits. (e.g. by: count, cost and percentages)',NULL,'CM_6','Y','Y','TMF'),(7,20,18,'Completeness','Look for repetitive Good Will Credits to an account','Look “violating” credits. (e.g. by: count, cost and percentages)',NULL,'CM_7','Y','Y','TMF'),(8,20,18,'Completeness','Look for prompt delivery of “late” credits within the next invoice ','Look for the right amount of money to be rewarded',NULL,'CM_8','Y','Y','TMF'),(9,20,18,'Correctness','Analyze Credits accuracies against organizational policies','Analyze from all Credit types',NULL,'CM_9','Y','Y','TMF'),(10,20,18,'Trend','Look for deviation of Credits, against previous period.','e.g. by: credit types, customer segments, counts, total coat, percentages',NULL,'CM_10','Y','Y','TMF'),(11,20,19,'Completeness','Verify the extend of Customer’s addressing CC','e.g. by: type of complain/issue,  status, counts, percentage/','B.12 (2.2.12)\nB.16 (2.2.16)\nD.11 (2.4.11)\nG.2 (2.7.2)\nG.4 (2.7.4)','CM_19','Y','Y','TMF'),(12,20,19,'Trend','Look for deviation of Customer’s addressing CC, occurrences','e.g. by: discount  types, customer segments, counts, total coat, percentages',NULL,'CM_20','Y','Y','TMF'),(13,20,19,'Trend','Look for deviation of Customer’s addressing CC, occurrences','e.g. by: discount  types, customer segments, counts, total coat, percentages',NULL,'CM_21','Y','Y','TMF'),(14,20,18,'Completeness','Verify that all credits are not granted the “permitted” period','Look illegally granted credits. (e.g. by: count, cost and percentages)',NULL,'CM_11','Y','Y','TMF'),(15,20,18,'Completeness','Look for accounts receiving discounts , exceeding a pre-defined percentage of the overall bill','Look “violating” discounts. (e.g. by: count, cost and percentages)',NULL,'CM_12','Y','Y','TMF'),(16,20,18,'Completeness','Look for accounts receiving repetitive discounts (of the same type or different) , exceeding a pre-defined percentage of the overall bill/s','Look “violating” discounts. (e.g. by: count, cost and percentages)',NULL,'CM_13','Y','Y','TMF'),(17,20,18,'Completeness','Look for accounts receiving repetitive discounts,  delivered  by the same agent/process','Look “violating” discounts. (e.g. by: count, cost and percentages)',NULL,'CM_14','Y','Y','TMF'),(18,20,18,'Completeness','Look for Discount values higher than the organization policy (by discount type, by account type, etc.)','Look “violating” discounts. (e.g. by: count, cost and percentages)',NULL,'CM_15','Y','Y','TMF'),(19,20,18,'Completeness','Look for prompt delivery of “late” discounts within the next invoice ','Look for the right amount of money to be rewarded',NULL,'CM_16','Y','Y','TMF'),(20,20,18,'Correctness','Analyze Discounts accuracies against organizational policies','Analyze from all Discount types',NULL,'CM_17','Y','Y','TMF'),(21,20,18,'Trend','Look for deviation of Discounts, against previous period.','e.g. by: discount  types, customer segments, counts, total coat, percentages',NULL,'CM_18','Y','Y','TMF'),(22,90,16,'Completeness','Verify that all credits are registered in the Accounting system','Look for missing, non justified credits as well as those with different money values. (count, cost and percentages)',NULL,'FA_28','Y','Y','TMF'),(23,90,14,'Completeness','Verify that all Invoice lines are registered in Accounting','Look for missing and unmatched registries (e.g. by: count, cost, percentages)',NULL,'FA_1','Y','Y','TMF'),(24,90,14,'Trend','Look for deviation of missing Invoice lines in Accounting','Look for deviation of missing and unmatched registries ((e.g. by: count, cost, percentages)','F.1 (2.6.1)','FA_2','Y','Y','TMF'),(25,90,14,'Completeness','Verify that all payment lines are registered in Accounting','Look for missing and unmatched registries (e.g. by: count, cost, percentages)',NULL,'FA_3','Y','Y','TMF'),(26,90,14,'Trend','Look for deviation of missing payment lines in Accounting','Look for deviation of missing and unmatched registries (e.g. by: count, cost, percentages)',NULL,'FA_4','Y','Y','TMF'),(27,90,14,'Completeness','Verify that all manual Invoice lines are registered in Accounting','Look for missing and unmatched registries (e.g. by: count, cost, percentages)',NULL,'FA_5','Y','Y','TMF'),(28,90,14,'Trend','Look for deviation of missing  manual Invoice lines in Accounting','Look for deviation of missing and unmatched registries (e.g. by: count, cost, percentages)',NULL,'FA_6','Y','Y','TMF'),(29,90,14,'Completeness','Verify that all manual payment lines are registered in Accounting','Look for missing and unmatched registries (e.g. by: count, cost, percentages)',NULL,'FA_7','Y','Y','TMF'),(30,90,14,'Trend','Look for deviation of missing  manual payment  lines in Accounting','Look for deviation of missing and unmatched registries (e.g. by: count, cost, percentages)',NULL,'FA_8','Y','Y','TMF'),(31,90,14,'Completeness','Verify that all interconnect parties invoice lines are registered in Accounting','Look for missing and unmatched registries (e.g. by: count, cost, percentages)',NULL,'FA_9','Y','Y','TMF'),(32,90,14,'Trend','Look for deviation of  all interconnect  parties invoice lines not registered in Accounting','Look for deviation of  registries (e.g. by: count, cost, percentages)',NULL,'FA_10','Y','Y','TMF'),(33,90,14,'Completeness','Verify that all payments from  interconnect parties are registered in Accounting ','Look for missing and unmatched registries (e.g. by: count, cost, percentages)',NULL,'FA_11','Y','Y','TMF'),(34,90,14,'Trend','Look for deviation of  all interconnect  parties payment  lines not registered in Accounting','Look for deviation of  registries (e.g. by: count, cost, percentages)',NULL,'FA_12','Y','Y','TMF'),(35,90,14,'Completeness','Verify that all Roaming parties invoice lines are registered in Accounting','Look for missing and unmatched registries (e.g. by: count, cost, percentages)',NULL,'FA_13','Y','Y','TMF'),(36,90,14,'Trend','Look for deviation of  all Roaming parties invoice lines not registered in Accounting','Look for deviation of  registries (e.g. by: count, cost, percentages)',NULL,'FA_14','Y','Y','TMF'),(37,90,14,'Completeness','Verify that all payments from  Roaming  parties are registered in Accounting ','Look for missing and unmatched registries (e.g. by: count, cost, percentages)',NULL,'FA_15','Y','Y','TMF'),(38,90,14,'Trend','Look for deviation of  all Roaming  parties payment  lines not registered in Accounting','Look for deviation of  registries (e.g. by: count, cost, percentages)',NULL,'FA_16','Y','Y','TMF'),(39,90,14,'Completeness','Verify that all 3rd parties invoice lines are registered in Accounting','3rd Parties: premium, SPs, VAS\nLook for missing and unmatched registries (e.g. by: count, cost, percentages)','F.2 (2.6.2)','FA_17','Y','Y','TMF'),(40,90,14,'Trend','Look for deviation of  all 3rd parties invoice lines not registered in Accounting','3rd Parties: premium, SPs, VAS\nLook for deviation of  registries (e.g. by: count, cost, percentages)',NULL,'FA_18','Y','Y','TMF'),(41,90,14,'Completeness','Verify that all payments from  3rd parties are registered in Accounting ','Look for missing and unmatched registries (e.g. by: count, cost, percentages)',NULL,'FA_19','Y','Y','TMF'),(42,90,14,'Trend','Look for deviation for all payments from  3rd parties not registered in Accounting ','Look for deviation of  registries (e.g. by: count, cost, percentages)',NULL,'FA_20','Y','Y','TMF'),(43,90,14,'Correctness','Verify the accuracy of reports submitted to the Organization management: C and F levels.','Look for discrepant calculations',NULL,'FA_29','Y','Y','TMF'),(44,90,14,'Correctness','Verify the accuracy of reports submitted to externally out of the organization','Look for discrepant calculations',NULL,'FA_30','Y','Y','TMF'),(45,10,1,'Margins','Verify positive Margin above pre-defined level with services/destinations','Calculate the revenue Margin between direct costs and receivables from customers utilizing those services (cost and percentage)','D.7 (2.4.7)\nD.14 (2.4.14)\nD.15 (2.4.15)\nD.19 (2.4.19)\nH.8 (2.8.8)\nH.10 (2.810)\nH.11 (2.8.11)','FA_21','Y','Y','TMF'),(46,10,1,'Margins','Verify positive Margin above pre-defined level with interconnect  parties ','Calculate the revenue Margin between paid amount to interconnect  party and the receivables from customers utilizing those services (cost and percentage)','A.4 (2.1.4)\nA.7 (2.1.7)','FA_22','Y','Y','TMF'),(47,10,1,'Margins','Verify positive Margin above pre-defined level with 3rd parties ','3rd party: SPs, VAS, Access providers, etc.\n\nCalculate the revenue Margin between paid amount to 3r party and the receivables from customers utilizing those services (cost and percentage)','B.5 (2.2.5)\nB.6 (2.2.6)\nB.7 (2.2.7)\nB.19 (2.2.19)','FA_23','Y','Y','TMF'),(48,10,1,'Margins','Verify positive Margin above pre-defined level with Roaming Partners','Calculate the revenue Margin between paid amount to Roaming partners  and the receivables from customers utilizing those services (cost and percentage)',NULL,'FA_24','Y','Y','TMF'),(49,10,1,'Margins','Verify acceptable (positive / or negative) Margin for equipment sold','In many case equipment is heavily subsidized - yet it is important that the Margins/subside is according to the business rules','A.5 (2.1.5)\nB.20 (2.2.20)\nD.7 (2.4.7)','FA_25','Y','Y','TMF'),(50,10,1,'Trend','Look for deviations in the revenue Margin associated with 3rd parties (interconnects SPs, VAS, Access providers, etc.)','Calculate the revenue Margin between paid amount to 3r party and the receivables from customers utilizing those services (cost and percentage)','B.19 (2.2.19)\nH.4 (2.8.4)','FA_26','Y','Y','TMF'),(51,10,1,'Trend','Look for deviations in the revenue Margin  associated with Roaming traffic','Calculate the revenue Margin between paid amount to Roaming partners  and the receivables from customers utilizing those services (cost and percentage)',NULL,'FA_27','Y','Y','TMF'),(52,40,26,'Correctness','Stranded Assets in Inventory ','Look for assets that appear in the inventory as being allocated but in practice are not provisioned','B.6 (2.2.6)\nB.21 (2.2.21)','NU_51','Y','Y','TMF'),(53,40,26,'Correctness','Stranded Assets in Network ','Look for assets that appear in the inventory and in the Network as being allocated but in practice are not in use','B.22 (2.2.22)','NU_52','Y','Y','TMF'),(54,40,26,'Correctness','Incorrect free Assets in Inventory','Look for assets that appear in the inventory as free Network but in practice are provisioned',NULL,'NU_53','Y','Y','TMF'),(55,40,26,'Correctness','Incorrect free Assets in Network','Look for assets that appear in the inventory and in the Network as being free but in practice in use',NULL,'NU_54','Y','Y','TMF'),(56,40,26,'Correctness','Phantom Assets in Network','Look for existing  assets that do not appear in the inventory',NULL,'NU_55','Y','Y','TMF'),(57,40,26,'Correctness','Missing Assets in Network','Look for assets that exist in the inventory, but do not exist in reality',NULL,'NU_56','Y','Y','TMF'),(58,40,7,'Completeness','Look for usage generated by “illegal” users/customers','“Illegal usage” (i.e. non existence in Billing, not-active, suspended, service “not allowed”, etc.).\n(e.g. by: illegality type, call type, counts, aggregated units, pseudo rate and percentages)\nAssociate the “billed ID” with the customers’ information  (e.g. from billing system) ','C.1 (2.3.1)\nC.7 (2.3.7)','NU_40','Y','Y','TMF'),(59,40,7,'Completeness','Look for “denied” usage generated for “legal” user/customer. Indicate when thresholds are superseded.','“Legal subscriber” (i.e. active in billing).\n(e.g. by: reject type, call type, counts, and percentages)\nAssociate the “billed ID” with the customers’ information  (e.g. from billing system)',NULL,'NU_41','Y','Y','TMF'),(60,40,7,'Completeness','Look for usage generated by customer exceeding their credit allowance ','e.g. Prepaid subscriber \n(e.g. by: call type, counts, aggregated units, pseudo rate and percentages)','D.24 (2.4.24)','NU_42','Y','Y','TMF'),(61,40,7,'Completeness','Look for Authentication platform unavailability periods','Authentication platform unavailability  can cause both opportunity losses, and  revenue leakages',NULL,'NU_43','Y','Y','TMF'),(62,40,7,'Trend','Look for deviation of illegal usage generated by “illegal” users/customers, against past period.','e.g. by: illegality type, call type, counts, aggregated units, pseudo rate and percentages',NULL,'NU_44','Y','Y','TMF'),(63,40,7,'Trend','Look for deviation of “denied” usage generated by “legal” users/customers, against past period.','e.g. by: reject type, call type, counts, and percentages','C.9 (2.3.9)','NU_45','Y','Y','TMF'),(64,40,7,'Trend','Look for deviation of usage generated by customers exceeding their credit allowance (i.e. prepaid), against past period.','e.g. by: illegality type, call type, counts, aggregated units, pseudo rate and percentages',NULL,'NU_46','Y','Y','TMF'),(65,40,6,'Completeness','Usage records’  Files  arrival completeness','Verify that all the relevant Usage files generated by the network elements  process arrive to the MD process ','C.13 (2.3.13)\nC.20 (2.3.20)','NU_20','Y','Y','TMF'),(66,40,6,'Completeness','Usage records’  Files  File integrity','Verify that all the relevant Usage files generated by the network elements arrive uncorrupted to the MD process (e.g., no broken file)','C.13 (2.3.13)','NU_21','Y','Y','TMF'),(67,40,6,'Completeness','Inputs usage records integrity','Verify that all the Usage information in the files generated by the network elements arrive without corruption to the MD process (e.g., no missing values  or gaps in records)','C.13 (2.3.13)','NU_22','Y','Y','TMF'),(68,40,6,'Completeness','Verify that the Mediation (usage collectors) process all Retail usage records, ','Compare MD-in vs., MD-out (for Retail Billing output), take into account all the error and dropped usage records as well.\n(e.g. by: call type,  counts, aggregated units (payload), pseudo rating and percentages)','D.5 (2.4.5)','NU_23','Y','Y','TMF'),(69,40,6,'Correctness','Verify that the Mediation (usage collectors) accurately process the units’ rounding of all Retail usage records ','Look for processed records with “biased” units (payload) value  (e.g. by: call type,  counts, aggregated payloads, pseudo rating and percentages)','C.5 (2.3.5)','NU_24','Y','Y','TMF'),(70,40,6,'Correctness','Verify that the Mediation (usage collectors) accurately process the Retail usage records ','Look for processed records with “biased” units (payload) value \n (e.g. by: call type,  counts, aggregated payloads, pseudo rating and percentages)\nNote: such processing may include consolidation of partial usage records by the Mediation.','C.15 (2.3.15)','NU_25','Y','Y','TMF'),(71,40,6,'Correctness','Verify  long calls  handling','Verify that long calls are mediated correctly - specially when they are compound from many partial CDRs','D.10 (2.4,10)','NU_26','Y','Y','TMF'),(72,40,6,'Trend','Trend of calls/minutes/value  by destination / call duration / call type /time of day / day of week','Verify that there has not been a drastic deviation in the calls/minutes/value against previous similar period',NULL,'NU_27','Y','Y','TMF'),(73,40,6,'Trend','Look for deviations of missing usage records in the Retail MD-out against past period. ','Look for suspicious deviation distances (by : call type, counts, aggregated payloads ,pseudo rating and percentages)',NULL,'NU_28','Y','Y','TMF'),(74,40,6,'Trend','Look for deviations of MD non accuracies   of units (payload ) values for Retail, against past period','Look for suspicious deviation distances (by  call types, counts, aggregated payloads, pseudo rating and percentages)',NULL,'NU_29','Y','Y','TMF'),(75,40,6,'Completeness','Verify that the Mediation (usage collectors) process all Interconnect usage records, ','Compare MD-in vs., MD-out (for Interconnect Billing output), take into account all the error and dropped usage records as well.\n(e.g. by: call type,  counts, aggregated units (payload), pseudo rating and percentages)',NULL,'NU_30','Y','Y','TMF'),(76,40,6,'Correctness','Verify that the Mediation (usage collectors) accurately process the units’ rounding of all Interconnect  usage records ','Look for processed records with “biased” units (payload) value  \n(e.g. by: call type,  counts, aggregated payloads, pseudo rating and percentages)','H.12 (2.8.12)','NU_31','Y','Y','TMF'),(77,40,6,'Correctness','Verify that the Mediation (usage collectors) accurately process the Interconnect usage records ','Look for processed records with “biased” units (payload) value \n (e.g. by: call type,  counts, aggregated payloads, pseudo rating and percentages)\nNote: such processing may include consolidation of partial usage records by the Mediation.','H.2 (2.8.2)','NU_32','Y','Y','TMF'),(78,40,6,'Trend','Look for deviations of missing usage records in the Interconnect MD-out against past period. ','Look for suspicious deviation distances (e.g. by : call type, counts, aggregated payloads ,pseudo rating and percentages)',NULL,'NU_33','Y','Y','TMF'),(79,40,6,'Trend','Look for deviations of MD non accuracies   of units (payload ) values for Interconnect, against past period','Look for suspicious deviation distances (e.g. by:  call types, counts, aggregated payloads, pseudo rating and percentages)',NULL,'NU_34','Y','Y','TMF'),(80,40,6,'Completeness','Look for MD Error/Dropped ratios exceeding pre-defined threshold values ','Look for suspicious ratio values of errors and dropped processed usage records (e.g. by: billing system output type, error/drop cause, call type,   counts, aggregated units (payload),  pseudo rating and percentages)',NULL,'NU_35','Y','Y','TMF'),(81,40,6,'Trend','Look for deviations of Dropped rates, against past period.','Look for suspicious deviations of dropped processed usage records (e.g. by: billing system output type, error/drop cause, call type,   counts, aggregated units (payload),  pseudo rating and percentages)','C.13 (2.3.14)\nC.16 (2.3.16)\nC.17 (2.3.17)','NU_36','Y','Y','TMF'),(82,40,6,'Trend','Look for deviations of Error rates, against past period.','Look for suspicious deviations of errors processed usage records (e.g. by: billing system output type, error/drop cause, call type,   counts, aggregated units (payload),  pseudo rating and percentages)','D.5 (2.4.5)','NU_37','Y','Y','TMF'),(83,40,6,'Correctness','Analyze correctness of Drops.','Analyze and trace Dropped usage records of all Drop causes, for all billing system output types and for all call types.','\nC.14 (2.3.14)\nC.16 (2.3.16)\nD.5 (2.4.5)\nH.1 (2.8.1)\nH.2 (2.8.2)','NU_38','Y','Y','TMF'),(84,40,6,'Correctness','Analyze correctness of Errors .','Analyze and trace Error usage records of all Error causes, for all billing system output types and for all call types.','C.3 (2.3.3)','NU_39','Y','Y','TMF'),(85,40,5,'Completeness','Verify that the Switches  (MSCs, GW, Softswitches, Exchanges)  generate all required usage records  ','Look for missing (or excessive) usage records. (e.g. by:  counts, aggregated durations,  pseudo rating and percentages)\nUsually by comparing to a reference source (e.g. probe, TCG, other peer switch)','C.2 (2.3.2)\nC.11 (2.3.11)\nC.20 (2.3.20)\nC.12 (2.3.12)','NU_1','Y','Y','TMF'),(86,40,5,'Correctness','Verify that the Switches  (MSCs, GW, Softswitches, Exchanges)  accurately generate usage records  ','Look for usage records with incorrect or missing information (e.g. missing  A-number, or corrupted A-number, or start time) ','B.13 (2.2.13)\nD.9 (2.4.9)','NU_2','Y','Y','TMF'),(87,40,5,'Correctness','Verify that the Switches  (MSCs, GW, Softswitches, Exchanges)  accurately records the duration in usage records  ','Look for usage records with “biased” duration. (e.g. by:  counts, aggregated durations,  pseudo rating and percentages)\nFor example: May be as a result of rounding, or error in processing/configuration','C.4 (2.3.4)','NU_3','Y','Y','TMF'),(88,40,5,'Trend','Look for deviations of missing usage records by Switches (MSCs, GW, Softswitches, Exchanges), against past period. ','Look for suspicious deviation distances. (e.g. by:  counts, aggregated durations,  pseudo rating and percentages)','C.2 (2.3.2)','NU_4','Y','Y','TMF'),(89,40,5,'Trend','Look for deviations of non-accurate duration in usage records by Switches  (MSCs, GW, Softswitches, Exchanges)  , against past period','Look for suspicious deviation distances. (e.g. by:  counts, aggregated durations,  pseudo rating and percentages)',NULL,'NU_5','Y','Y','TMF'),(90,40,5,'Completeness','Verify that the messaging platforms (MSC, SMSC)  generate all required usage records  ','Look for missing (or excessive) usage records. (e.g. by:  counts,,  pseudo rating and percentages)\nUsually by comparing to a reference source (e.g. probe, TCG, other peer platform)',NULL,'NU_6','Y','Y','TMF'),(91,40,5,'Correctness','Verify that the messaging platforms ( SMSC)  generate usage accurately generate records  with correct information','Look for usage records with incorrect or missing information (e.g. incorrect status, missing A-Number) ','D.23 (2.4.23)','NU_7','Y','Y','TMF'),(92,40,5,'Trend','Look for deviations of missing usage records by messaging platforms (SMSC), against past period. ','Look for suspicious deviation distances. (e.g. by:  counts,,  pseudo rating and percentages)',NULL,'NU_8','Y','Y','TMF'),(93,40,5,'Correctness','Verify that the media messaging platforms (MMSC)  generate all required usage records  ','Look for missing (or excessive) usage records. (e.g. by:  contents types, counts,,  pseudo rating and percentages)\nUsually by comparing to a reference source (e.g. probe or TCG)',NULL,'NU_9','Y','Y','TMF'),(94,40,5,'Trend','Look for deviations of missing usage records by media messaging platforms (MMSC), against past period. ','Look for suspicious deviation distances. (e.g. by: contents types, counts,,  pseudo rating and percentages)',NULL,'NU_10','Y','Y','TMF'),(95,40,5,'Correctness','Verify that the media messaging platforms ( MMSC)  generate usage accurately generate records  with correct information','Look for usage records with incorrect or missing information (e.g. incorrect status, missing A-Number) ',NULL,'NU_11','Y','Y','TMF'),(96,40,5,'Completeness','Verify that the data platform (SGSN, GGSN, CHG)  generate all required usage records  ','Look for missing (or excessive) usage records. (e.g. by: APN, Uplink, Downlink,  counts, aggregated KB,  pseudo rating and percentages)\nUsually by comparing to a reference source (e.g. probe, TCG, other application server)',NULL,'NU_12','Y','Y','TMF'),(97,40,5,'Correctness','Verify that the data platform (SGSN, GGSN, CHG)  accurately generate usage records  ','Look for usage records with “biased” KB. (e.g. by: APN, Uplink, Downlink,  counts, aggregated KB,  pseudo rating and percentages))For example: May be as a result of rounding, or error in processing/configuration',NULL,'NU_13','Y','Y','TMF'),(98,40,5,'Trend','Look for deviations of missing usage records by the data platform (SGSN, GGSN, CHG), against past period. ','Look for suspicious deviation distances. (e.g. by: APN, Uplink, Downlink,  counts, aggregated KB,  pseudo rating and percentages)',NULL,'NU_14','Y','Y','TMF'),(99,40,5,'Trend','Look for deviations of non accurate KB in usage records by the data platform (SGSN, GGSN, CHG)  , against past period','Look for suspicious deviation distances. (e.g. by: APN, Uplink, Downlink,  counts, aggregated KB,  pseudo rating and percentages)',NULL,'NU_15','Y','Y','TMF'),(100,40,5,'Completeness','Verify that the Service Platforms  (IN, Service Node)  generate all required usage/Topup records  ','Look for missing (or excessive) usage/Topups records. (e.g. by:  service type, record type, counts, aggregated units (payload),  pseudo rating and percentages)\nUsually by comparing to a reference source (e.g. probe, TCG, other peer switch, Topup platform)',NULL,'NU_16','Y','Y','TMF'),(101,40,5,'Correctness','Verify that the Service Platforms  (IN, Service Node) accurately generate usage/Topup records  ','Look for usage records with “biased” duration. (e.g. by:  service type, record type, counts, aggregated units (payload),  pseudo rating and percentages)\nFor example: May be as a result of rounding, or error in processing/configuration','G.2 (2.7.2)','NU_17','Y','Y','TMF'),(102,40,5,'Trend','Look for deviations of missing usage records by Service Platforms (IN, Service Node) against past period. ','Look for suspicious deviation distances. (e.g. by:  service type, record type, counts, aggregated units (payload),  pseudo rating and percentages)',NULL,'NU_18','Y','Y','TMF'),(103,40,5,'Trend','Look for deviations of unmatched units (payload) in usage/Topup records by Service Platforms  (IN, Service Node), against past period','Look for suspicious deviation distances. (e.g. by:  service type, record type, counts, aggregated units (payload),  pseudo rating and percentages)',NULL,'NU_19','Y','Y','TMF'),(104,40,8,'Trend','Look for deviation of calls/sessions’ Release Causes across “monitored entities”, against past period.','“Monitored entities”: such as: Routes, network elements, processes, valuable customers, service providers, etc.\ne.g. by: release cause group type, call type, counts and  percentages',NULL,'NU_47','Y','Y','TMF'),(105,40,8,'Correctness','Look for degraded calls/sessions’ Release Causes values  exceeding pre-defined thresholds, ','e.g. by: release cause group type, call type, counts and  percentages',NULL,'NU_48','Y','Y','TMF'),(106,40,8,'Trend','Look for deviation of QoS measurements across “monitored entities”, against past period.','“Monitored entities”: such as: Routes, network elements, processes, valuable customers, service providers, etc.\n“QoS measurements: ASR, ABR, PDD, Short calls distribution.\ne.g. by: QoS measurement  type, call type, counts and  percentages',NULL,'NU_49','Y','Y','TMF'),(107,40,8,'Correctness','Look for degraded QoS measurements, with values below pre-defined thresholds, across “monitored entities“','e.g. by: QoS measurement  type, call type, counts and  percentages',NULL,'NU_50','Y','Y','TMF'),(108,30,4,'Correctness','Verify that routes information (Trunks, Domains, etc.) are configured in the Network ','Look by all related information such as remote network element, type (interconnect, other), direction, prefixes, etc.\nLook for missing or unmatched entities (e.g. by: counts, percentage)','A.7 (2.1.7)\nC.17 (2.3.17)','OP_17','Y','Y','TMF'),(109,30,4,'Correctness','Verify that routes information (Trunks, Domains, etc.) are configured in the Processing elements (Mediation, Billing systems)','Look by all related information such as remote network element, type (interconnect, other), direction, prefixes, etc.\nLook for missing or unmatched entities (e.g. by: counts, percentage)','D.1 (2.4.1)','OP_18','Y','Y','TMF'),(110,30,4,'Correctness','Verify that 3rd parties information (interconnects, service providers, peers, access, etc..) are configured in the Processing elements (Mediation, Billing systems)','Look by all related information such as rates, type (interconnect, SP, other), prefixes, etc.\nLook for missing or unmatched entities (e.g. by: counts, percentage)','C.18 (2.3.18)','OP_19','Y','Y','TMF'),(111,30,4,'Correctness','Verify that Local Number Portability information (interconnects, service providers, peers, access, etc..) are configured in the Network elements','Look by all related information such as Donor/Recipient PLMNs entities (e.g. by: counts, percentage)','B.16 (2.2.16)\nC.2 (2.3.2)','OP_20','Y','Y','TMF'),(112,30,4,'Correctness','Verify that Local Number Portability information is configured in the Processing systems ','Look by all related information such as Donor/Recipient PLMNs entities (e.g. by: counts, percentage)','B.12 (2.2.12)','OP_21','Y','Y','TMF'),(113,30,4,'Correctness','Verify correct assignment of number ranges','Look that the same number range is not allocated to two operators/MVOs','C.6 (2.3.6)','OP_22','Y','Y','TMF'),(114,30,2,'Completeness','Verify that Customers’ orders/cancelations/updates are registered in the CRM','Verify that the customer order/registration is registered correctly in CRM.\nFor all order’s channels: Customer Care, Web Portals, SMS, Shops, Dealers, etc.\n(e.g. by: action type, counts, pseudo revenues, percentages, product)','B.1 (2.2.1)','OP_1','Y','Y','TMF'),(115,30,2,'Trend','Look for deviation of Customers’ orders/cancelations/updates types ','Look for “suspicious deviations” against values of a  previous period (e.g. by: action type, counts, pseudo revenues, percentages)','B.8 (2.2.8)','OP_2','Y','Y','TMF'),(116,30,2,'Correctness','Verify new customers’ details ','Verify identity and payment method','B.3 (2.2.3)','OP_3','Y','Y','TMF'),(117,30,2,'Correctness','Valid data entered to the order systems','Verify that the data entered is valid, and that appropriate validation processes are taking place as part of the operational process (e.g. address validation)','B.2 (2.2.2)','OP_4','Y','Y','TMF'),(118,30,2,'Correctness','Consistent data entered to the order systems','When the ordering data is entered to multiple systems, especially when it is done manually  the consistency of the data (and specially of the cross-identifiers between the systems) should be validated',NULL,'OP_5','Y','Y','TMF'),(119,30,2,'Correctness','Correct Reference data used when entering an order','Verify that the reference data used when entering an order is correct and up-to-date','A.2 (2.1.2)\nB.14 (2.2.14)\nD.13 (2.4.3)','OP_6','Y','Y','TMF'),(120,30,2,'Correctness','Credit check','Verify that credit checks are performed according to the business policy','E.1 (2.5.1)\nE.2 (2.5.2)','OP_7','Y','Y','TMF'),(121,30,3,'Correctness','Verify that Customers’ orders/cancelations/updates are registered in Billing systems (customer information)','Look for discrepancies at accounts, service and service attributes levels (e.g. by: action type, counts, pseudo revenues, percentages)','B.9 (2.2.9)\nB.10 (2.2.10)','OP_8','Y','Y','TMF'),(122,30,3,'Correctness','Verify that Customers’ orders/cancelations/updates are registered in the network systems (customer related information)','Look for discrepancies at accounts, service and service attributes levels (e.g. by: action type, counts, pseudo revenues, percentages)','B.11 (2.2.11)\nC.21 (2.3.21)','OP_9','Y','Y','TMF'),(123,30,3,'Correctness','Verify that Customers’ orders/cancelations/updates are registered On-Time in the Billing systems (customer information)','Look for violating service level latencies (e.g. by: action type, counts, pseudo revenues, percentages)','B.18 (2.2.18)\nD.22 (2,4,22)\n','OP_10','Y','Y','TMF'),(124,30,3,'Correctness','Verify that Customers’ orders/cancelations/updates are registered On-Time in the network systems ','Look for violating service level latencies (e.g. by: action type, counts, pseudo revenues, percentages)','B.4 (2.2.4)\nB.5 (2.2.5)\n','OP_11','Y','Y','TMF'),(125,30,3,'Correctness','Verify the level of rejected orders/cancelations/updates ','Look for superseded thresholds  (e.g. by: action type, counts, pseudo revenues, percentages)','B.8 (2.2.8)\nB.22 (2.2.22)','OP_12','Y','Y','TMF'),(126,30,3,'Trend','Look for deviation in rejected orders/cancelations/updaters ','Look for “suspicious deviations” against values of a  previous period (e.g. by: action type, counts, pseudo revenues, percentages)','B.8 (2.2.8)','OP_13','Y','Y','TMF'),(127,30,3,'Trend','Look for deviation in discrepancies between CRM and Billing ','Look for “suspicious deviations” against values of a  previous period (e.g. by: action type, counts, pseudo revenues, percentages)','C.1 (2.3.1)','OP_14','Y','Y','TMF'),(128,30,3,'Trend','Look for deviation in discrepancies between CRM and Network elements ','Look for “suspicious deviations” against values of a  previous period (e.g. by: action type, counts, pseudo revenues, percentages)','C.1 (2.3.1)','OP_15','Y','Y','TMF'),(129,30,3,'Trend','Look for deviation in provisioning latency','Look for “suspicious deviations” against values of a  previous period (both by average latency and violations of the  SLA per product/service/customer segment)','B.8 (2.2.8)','OP_16','Y','Y','TMF'),(130,80,20,'Correctness','Verify the accuracy of the invoice and invoice lines sent to Interconnect  parties ','Look for discrepancies (e.g. by interconnect partner, cost, percentages)','C.18 (2.3.18)','PM_1','Y','Y','TMF'),(131,80,20,'Correctness','Verify the accuracy of the invoice and invoice lines received from Interconnect parties ','Look for discrepancies (e.g. by interconnect partner, cost, percentages)','H.3 (2.8.3)','PM_2','Y','Y','TMF'),(132,80,20,'Correctness','Analyze disputes with interconnect parties ','Analyze the disputes (e.g., by reason, service, etc.)','C.6 (2.3.6)\nC.18 (2.3.18)\nH.2 (2.8.2)\n','PM_3','Y','Y','TMF'),(133,80,20,'Trend','Look for deviation of invoices sent to Interconnect parties','Look for deviation of invoices sent to Interconnect parties (e.g. by: count, cost, percentages)',NULL,'PM_4','Y','Y','TMF'),(134,80,20,'Trend','Look for deviation of invoices received from Interconnect parties','Look for deviation of invoices received from Interconnect parties (e.g. by: count, cost, percentages)','C.8 (2.3.8)','PM_5','Y','Y','TMF'),(135,80,20,'Correctness','Verify the accuracy of the invoice and invoice lines sent to MVNOs','Look for discrepancies (e.g. by interconnect partner, cost, percentages)','H.7 (2.8.7)','PM_6','Y','Y','TMF'),(136,80,20,'Correctness','Analyze disputes with MVNOs ','Analyze the disputes (e.g., by reason, service, etc.)','\n','PM_7','Y','Y','TMF'),(137,80,20,'Trend','Look for deviation of invoices sent to MVNOs','Look for deviation of invoices sent to Interconnect parties (e.g. by: count, cost, percentages)','H.7 (2.8.7)','PM_8','Y','Y','TMF'),(138,80,20,'Correctness','Verify the accuracy of the invoice and invoice lines sent to Roaming parties / clearing ','Look for discrepancies (e.g. by interconnect partner, cost, percentages)','C.7 (2.3.7)\nH.1 (2.8.1) ','PM_9','Y','Y','TMF'),(139,80,20,'Correctness','Verify the accuracy of the invoice and invoice lines received from Roaming parties / clearing ','Look for discrepancies (e.g. by interconnect partner, cost, percentages)',NULL,'PM_10','Y','Y','TMF'),(140,80,20,'Correctness','Analyze disputes with Roaming parties ','Analyze the disputes (e.g., by reason, service, etc.)','C.7 (2.3.7)','PM_11','Y','Y','TMF'),(141,80,20,'Trend','Look for deviation of invoices sent to Roaming parties / clearing ','Look for deviation of invoices sent to Roaming parties / clearing  (e.g. by: count, cost, percentages)',NULL,'PM_12','Y','Y','TMF'),(142,80,20,'Trend','Look for deviation of invoices received from Roaming parties / clearing ','Look for deviation of invoices received from Roaming parties / clearing  (e.g. by: count, cost, percentages)',NULL,'PM_13','Y','Y','TMF'),(143,80,20,'Correctness','Verify the accuracy of the invoice and invoice lines sent  to dealers/stores parties ','Look for discrepancies (e.g. by interconnect partner, cost, percentages)',NULL,'PM_14','Y','Y','TMF'),(144,80,20,'Correctness','Verify the accuracy of the invoice and invoice lines received  to dealers/stores parties','Look for discrepancies (e.g. by interconnect partner, cost, percentages)',NULL,'PM_15','Y','Y','TMF'),(145,80,20,'Correctness','Verify the accuracy of commissions paid to dealers/stores 3rd parties','Look for discrepancies (e.g. by interconnect partner, cost, percentages)','H.5 (2.8.5)','PM_16','Y','Y','TMF'),(146,80,20,'Correctness','Verify the accuracy of revenue shares with 3rd parties','Look for inconsistencies between amount paid to the SP by the subscribers and amounts paid by the SP to 3rd parties (look for situations were the subscriber did not pay to the operator, e.g., due to failure to deliver the service, but the SP paid to the 3rd party) ','H.6 (2.8.6)','PM_17','Y','Y','TMF'),(147,80,20,'Correctness','Verify the accuracy of adjustments aimed for dealers/stores parties','Look for discrepancies (e.g. by interconnect partner, cost, percentages)',NULL,'PM_18','Y','Y','TMF'),(148,80,20,'Correctness','Analyze disputes with dealers/stores parties ','Analyze the disputes (e.g., by reason, service, etc.)',NULL,'PM_19','Y','Y','TMF'),(149,80,20,'Trend','Look for deviation of invoices received from dealers/store parties ','Look for deviation of invoices  received from dealers/store parties   (e.g. by: count, cost, percentages)',NULL,'PM_20','Y','Y','TMF'),(150,80,20,'Trend','Look for deviation of invoices sent to dealers/stores parties ','Look for deviation of invoices sent to dealers/stores parties   (e.g. by: count, cost, percentages)',NULL,'PM_21','Y','Y','TMF'),(151,80,20,'Correctness','Verify the accuracy of the invoice and invoice lines sent  to 3rd  parties ','3rd parties: premium, VAS, SPs ,Look for discrepancies (e.g. by interconnect partner, cost, percentages)',NULL,'PM_22','Y','Y','TMF'),(152,80,20,'Correctness','Verify the accuracy of the invoice and invoice lines received  from 3rd parties ','3rd parties: premium, VAS, SPs\nLook for discrepancies (e.g. by interconnect partner, cost, percentages)','B.17 (2.2.17)','PM_23','Y','Y','TMF'),(153,80,20,'Correctness','Analyze disputes with 3rd parties','Analyze the disputes (e.g., by reason, service, etc.)',NULL,'PM_24','Y','Y','TMF'),(154,80,20,'Trend','Look for deviation of invoices received from 3rd parties  ','Look for deviation of invoices  received from 3rd parties e.g., premium, VAS, SPs,  (e.g. by: count, cost, percentages)',NULL,'PM_25','Y','Y','TMF'),(155,80,20,'Trend','Look for deviation of invoices sent to 3rd parties','Look for deviation of invoices sent to 3rd parties e.g., premium, VAS, SPs,    (e.g. by: count, cost, percentages)',NULL,'PM_26','Y','Y','TMF'),(156,10,1,'Correctness','Verify the product catalog’ Service Attributes are defined according to Marketing specification ','Check all products',NULL,'PO_1','Y','Y','TMF'),(157,10,1,'Correctness','Verify the product catalog’ Rating Attributes are defined according to Marketing specification ','Check all products',NULL,'PO_2','Y','Y','TMF'),(158,10,1,'Correctness','Verify all Marketing Campaign  Service Parameters are defined according to Marketing specifications','Verify that the authorized customers population is awarded','A.3 (2.1.3)','PO_3','Y','Y','TMF'),(159,10,1,'Correctness','Verify all Marketing Campaign  Rating attributes are defined according to Marketing specifications','Verify the start and end timestamps',NULL,'PO_4','Y','Y','TMF'),(160,60,13,'Completeness','Print house receives all the Invoices’ information','Verify that the printing house receives all the Invoices  generated by the billing system for a Bill Run','D.11 (2.4.11)','RB_34','Y','Y','TMF'),(161,60,13,'Completeness','Print house receives all the Annexes  information','Verify that the printing house receives all the Annexes for a Bill Run',NULL,'RB_35','Y','Y','TMF'),(162,60,13,'Completeness','Print Process  bills for all the Invoices  it received','Verify that the printing house processes s all the invoices for a Bill Run',NULL,'RB_36','Y','Y','TMF'),(163,60,13,'Completeness','Print generates and store Invoice images','Verify that the printing house stores  all the invoice images for a Bill Run',NULL,'RB_37','Y','Y','TMF'),(164,60,13,'Completeness','Print mails all  Paper Invoices to customers','Verify that the printing house mails all  the Paper invoices to the Paper receiving customers for a Bill Run',NULL,'RB_38','Y','Y','TMF'),(165,60,13,'Completeness','Level of  total of dropped/erroneous invoices at the Print House','Verify that Levels of  total of dropped/erroneous invoices at the Print House  do not exceed a pre-defined level\n(by overall and for each type of dropped/error)\n',NULL,'RB_39','Y','Y','TMF'),(166,60,13,'Trend','Trend of  total of dropped/erroneous invoices at the Print House','Verify that there has not been a drastic deviation in the  total of dropped/erroneous invoices at the Print House\nagainst previous (moving window) Bill Runs\n(by overall and for each type of dropped/error)',NULL,'RB_40','Y','Y','TMF'),(167,60,13,'Completeness','Verify delivery of Invoices to be Paid by Banks','Verify that all paid by Banks invoices’ information was sent to the appropriate banks or clearing house. for a Bill Run',NULL,'RB_41','Y','Y','TMF'),(168,60,13,'Completeness','Verify delivery of Invoices to be Paid by Credit Agencies','Verify that all paid by Credit agencies invoices’ information was sent to the appropriate agencies or clearing house. for a Bill Run','E.3 (2.5.3)','RB_42','Y','Y','TMF'),(169,60,13,'Completeness','Invoices to be collected','Verify that all invoices to be collected, are sent to the  collection system for a Bill Run',NULL,'RB_43','Y','Y','TMF'),(170,60,11,'Completeness','Level of Error events amount/percentage (for overall and each error type)','Verify that the amount/percentage of Error events during the whole billing process does not exceed a pre-defined level',NULL,'RB_19','Y','Y','TMF'),(171,60,11,'Trend','Trend of Error events amount/percentage (for overall and each error type)','Verify that the amount/percentage of Error events during the whole billing process is reasonable with accepted deviation from previous (moving window) Bill Runs','D.6 (2.4.6)','RB_20','Y','Y','TMF'),(172,60,11,'Correctness','Analyze validity of Errors ','Analyze for all Error causes.','B.2 (2.2.2)\nB.10 (2.2.10)\nB.11 (2.2.11)\nD.3 (2.4.3)','RB_21','Y','Y','TMF'),(173,60,11,'Completeness','Level of Dropped / Zero-rate events amount/percentage','Verify that the amount/percentage of Dropped  during the whole billing process does not exceed a pre-defined level \n(for overall and each dropped type)','A.6 (2.1.6)','RB_22','Y','Y','TMF'),(174,60,11,'Trend','Trend of Dropped / Zero-rate events amount/percentage(for overall and each dropped type)','Verify that the amount/percentage of Dropped events during the whole billing process is reasonable with accepted deviation from previous (moving window) Bill Runs','A.6 (2.1.6)','RB_23','Y','Y','TMF'),(175,60,11,'Correctness','Analyze validity of Drops / Zero-rated','Analyze for all Drop causes.','A.6 (2.1.6)\nC.19 (2.3.19)\nD.12 (2.4.12)\nD.22 (2.4.22)','RB_24','Y','Y','TMF'),(176,60,11,'Trend','Trend of Invoice Write-Offs amount/percentage','Verify that the amount/percentage of Invoice Write-Offs during the whole billing process is reasonable with accepted deviation against previous (moving window) Bill Runs',NULL,'RB_25','Y','Y','TMF'),(177,60,11,'Correctness','Analyze validity of write-offs','Analyze for all write-off causes.',NULL,'RB_26','Y','Y','TMF'),(178,60,9,'Completeness','Events Files  arrival completeness','Verify that all the relevant Usage files generated by the Mediation  process arrive to the Billing  process ','C.13 (2.3.13)','RB_1','Y','Y','TMF'),(179,60,9,'Completeness','Events File integrity','Verify that all the relevant Usage files generated by the Mediation process arrive uncorrupted to the Billing  process (e.g., no broken file)','C.13 (2.3.13)','RB_2','Y','Y','TMF'),(180,60,9,'Completeness','Inputs Events integrity','Verify that all the Usage information in the files generated by the Mediation process arrive without corruption to the Billing  process (e.g., no missing values in CDRs)','C.13 (2.3.13)','RB_3','Y','Y','TMF'),(181,60,9,'Completeness','Verify that the relevant rating/billing system process all required usage records, ','Billing Type: Retail, Wholesale, Interconnect, Roaming, etc.\nCompare Rate-in vs., Rate-out (for each Billing type output), take into account all the error and dropped usage records as well.\n(e.g. by:  Billing Type Output, counts, aggregated units (payload), pseudo rating and percentages)','D.20 (2.4.20)','RB_4','Y','Y','TMF'),(182,60,9,'Correctness','Verify that the relevant rating/billing process accurately process usage records','In case of units rounding or consolidation of partial records.\nLook for processed records with “non-accurate” units (payload) values (duration, Bytes, etc.)\n(e.g. by:  Billing Type Output, counts, aggregated units (payload), pseudo rating and percentages)','A.1 (2.1.1)\nD.1 (2.4.1)\nD.18 (2.4.18)','RB_5','Y','Y','TMF'),(183,60,9,'Trend','Look for deviations of missing usage records in Rate-out  against past period. ','Look for suspicious deviation distances (e.g. by:  Billing Type Output, counts, aggregated units (payload), pseudo rating and percentages)',NULL,'RB_6','Y','Y','TMF'),(184,60,9,'Trend','Look for deviations of non-accurate processed units, against past period','Look for suspicious deviation distances (e.g. by:  counts, aggregated units (e.g. by:  Billing Type Output, counts, aggregated units (payload), pseudo rating and percentages)','D.1 (2.4.1)','RB_7','Y','Y','TMF'),(185,60,9,'Completeness','Roaming Files  arrival completeness','Verify that all the relevant TAP-in files arrive to the Billing  process ',NULL,'RB_8','Y','Y','TMF'),(186,60,9,'Completeness','Roaming File integrity','Verify that all the relevant TAP-in files arrive uncorrupted to the Billing  process (e.g., no broken file)',NULL,'RB_9','Y','Y','TMF'),(187,60,9,'Completeness','Inputs Roaming Events integrity','Verify that all the information in the TAP-in files arrive without corruption to the Billing  process (e.g., no missing values in CDRs)',NULL,'RB_10','Y','Y','TMF'),(188,60,9,'Completeness','Output Roaming Events integrity','Verify that all the information in the TAP-out files are sent without corruption to the original operator/clearing house (e.g., no missing values in CDRs)',NULL,'RB_11','Y','Y','TMF'),(189,60,9,'Completeness','Output Roaming Events delays','Verify that all the information in the TAP-out files arrive without excessive  delays to the original operator/clearing house ','D.2 (2.4.2)','RB_12','Y','Y','TMF'),(190,60,9,'Completeness','Inputs Adjustment Events integrity','Verify that all the Adjustment information arrive without corruption to the Billing  process (e.g., no missing  transactions and no corrupted values in transaction)',NULL,'RB_13','Y','Y','TMF'),(191,60,9,'Completeness','Billed Customers integrity','Verify that all the Usage data  for all the Customers assigned to a Bill Cycle Participate in that Bill Run',NULL,'RB_15','Y','Y','TMF'),(192,60,9,'Completeness','One-Time Charges integrity ','Verify that all the one-time charges, as registered in the products catalog and/or assigned to Customers are included  in that Bill Run','D.16 (2.4.16)','RB_16','Y','Y','TMF'),(193,60,9,'Completeness','Recurrent  Charges integrity ','Verify that all the recurrent charges, as registered in the products catalog and assigned to Customers are included  in that Bill Run','D.15 (2.4.15)\nD.16 (2.4.16)','RB_17','Y','Y','TMF'),(194,60,9,'Completeness','Postponed  Payments integrity ','Verify that all the Postponed Payments, as registered in the Collection system  and assigned to Customers are included  in that Bill Run',NULL,'RB_18','Y','Y','TMF'),(195,60,12,'Trend','Trend of Total Invoice Amounts','Verify that there has not been a drastic deviation in the total Invoice Amounts against previous (moving window) Bill Runs',NULL,'RB_27','Y','Y','TMF'),(196,60,12,'Trend','Trend of total Invoice Lines  Amounts (by each line type)','Verify that there has not been a drastic deviation in the total Invoice Lines  Amounts against previous (moving window) Bill Runs',NULL,'RB_28','Y','Y','TMF'),(197,60,12,'Trend','Trend of calls/minutes/value per destination / call duration / call type /time of day / day of week','Verify that there has not been a drastic deviation in the total Invoice calls/minutes/value against previous (moving window) Bill Runs','D.9 (2.4.9)','RB_29','Y','Y','TMF'),(198,60,12,'Trend','Trend of Total Manual billed amount per actual period vs. similar period','Verify that there has not been a drastic change in the total Manual billed amount against previous (moving window) Bill Runs',NULL,'RB_30','Y','Y','TMF'),(199,60,12,'Completeness','Manual billing completeness','Verify that each manual billing considers all the relevant events, services and equipment ','D.4 (2.4.4)\nG.4 (2.7.4)','RB_31','Y','Y','TMF'),(200,60,12,'Correctness','Verify the accuracy of Online billing','Verify that all usage events are charged by the  Online (Hot) Billing, ','C.11 (2.3.11)\n','RB_32','Y','Y','TMF'),(201,60,12,'Trend','Trend of total online charged usage events','Verify that there has not been a drastic deviation in the periodic  total of online charged usage events against previous (moving window) periods','C.11 (2.3.11)','RB_33','Y','Y','TMF'),(202,60,12,'Correctness','Correct one time and recurrent charges  tariffs applied','Verify that all one-time and recurrent tariffs are set correctly in the billing system','D.13 (2.4.13)\nD14 (2.4.14)\nD.16 (2.4.16)','RB_47','Y','Y','TMF'),(203,60,12,'Trend','Trend of Tax ratio by customer segment','Verify that there has not been a drastic deviation in the  Tax ratio (taxes/billed) \nagainst previous (moving window) Bill Runs\nbuild the customers segments according to different \"tax zones\" (if exist)','D.17 (2.4.17)','RB_48','Y','Y','TMF'),(204,60,12,'Correctness','Events rating use reference data that is appropriate for the date of the event','e.g. a tariff change on a certain date normally should not affect the rating of events that occur before A (unless the business logic states otherwise)','D.19 (2.4.19)','RB_49','Y','Y','TMF'),(205,60,12,'Correctness','Identification of duplicate events','Verify that the billing system does not erroneously handle duplicate entities as separate events','D.8 (2.4.8)','RB_50','Y','Y','TMF'),(206,60,12,'Correctness','Correct identification of duplicate events','Verify that the billing system does not erroneously identifies different events as a duplication (and charges only once)',NULL,'RB_51','Y','Y','TMF'),(207,60,12,'Correctness','Verify accurate Enrichment ','Verify that the data enrichments done by the billing system are correct',NULL,'RB_52','Y','Y','TMF'),(208,60,12,'Correctness','Long Calls Rating','Verify that long calls are rated correctly',NULL,'RB_54','Y','Y','TMF'),(209,60,12,'Correctness','Short Calls Rating','Verify that short calls are rated correctly, and not ignored (according to policies)',NULL,'RB_55','Y','Y','TMF'),(210,60,12,'Correctness','Rounding','Verify that calls are rounded according to the business rules',NULL,'RB_56','Y','Y','TMF'),(211,60,12,'Correctness','Guiding','Verify that all the events are guided to the appropriate billing/settlement system','D.6 (2.4.6)','RB_57','Y','Y','TMF'),(212,60,12,'Correctness','TAX Region','Verify that Tax is applied according to the subscriber region/country','F.4 (2.6.4)','RB_58','Y','Y','TMF'),(213,60,12,'Correctness','TAX','Verify that the correct tax amount is applied to each  line item','D.17 (2.4.17)','RB_59','Y','Y','TMF'),(214,60,12,'Correctness','Negative TAX','Verify that correct Tax calculations are applied on Negative sums (discounts, credits…)',NULL,'RB_60','Y','Y','TMF'),(215,60,12,'Correctness','Tax Reference data used by the billing system is accurate','Verify that all Taxation reference data is accurate','F.3 (2.6.3)','RB_61','Y','Y','TMF'),(216,60,12,'Correctness','The allowance given beyond the Effective date','Verify whether no allowance used out of effective period. E.g., in case an allowance is given with an expiration date but the billing system continues to apply it after the expiration date.',NULL,'RB_62','Y','Y','TMF'),(217,60,12,'Correctness','Allowance is applied to correct events','Sometimes allowance applied out of business rule, for example allowance for local calls is applied for long distance calls too.',NULL,'RB_63','Y','Y','TMF'),(218,60,12,'Correctness','Verify proper handling when allowance is exhausted in midst of a call/session.','Allowance like free minutes usually ends in the middle of a call therefore the call has to be split and charged partially.',NULL,'RB_64','Y','Y','TMF'),(219,60,12,'Correctness','Discounts calculation','Verify that discount are calculated according to their business definition','B.15 (2.2.15)','RB_65','Y','Y','TMF'),(220,60,12,'Correctness','Discounts Stacking','Verify that discounts stacking (more than one discount to the same subscriber on the same item) are applied accordingly and in the order defined by the business rules/contracts','D.21 (2.4.21)\nG.3 (2.7.3)','RB_66','Y','Y','TMF'),(221,60,12,'Correctness','Discount expiration date','Verify that discounts are applied only before their expiration date','A.2 (2.1.2)','RB_67','Y','Y','TMF'),(222,60,12,'Correctness','Discount start date','Verify that discounts are applied only after their start date',NULL,'RB_68','Y','Y','TMF'),(223,60,12,'Correctness','Balance updated after events','Verify that balance is updated correctly according to business rules after  events','D.12 (2.4.12)','RB_69','Y','Y','TMF'),(224,60,12,'Correctness','Balance updated during  events','Verify that balance is updated correctly according to business during events',NULL,'RB_70','Y','Y','TMF'),(225,60,12,'Correctness','Verify balance level accuracy for Prepaid account','Find non-zero balanced accounts (for a monitored period) by subtracting usage and adding to-ups against the difference between credit amounts at the end and beginning of that period.',NULL,'RB_72','Y','Y','TMF'),(226,60,12,'Trend','Look for deviations of non zero balances for Prepaid account','Find non-zero balanced accounts (for a monitored period) by subtracting usage and adding to-ups against the difference between credit amounts at the end and beginning of that period.',NULL,'RB_73','Y','Y','TMF'),(227,60,25,'Trend','Trend of Collection Ratio','Analyze the ratio of collection vs. billed compared to other similar periods',NULL,'RB_44','Y','Y','TMF'),(228,60,25,'Trend','Bed Debt write off Ratio','Analyze the Bed Debt write off vs. billed compared to other similar periods',NULL,'RB_45','Y','Y','TMF'),(229,60,25,'Correctness','Analyze Bed Debt write off','Analyze the Bed Debt write off reasons and process','E.1 (2.5.1)','RB_46','Y','Y','TMF'),(230,60,10,'Completeness','Billed Customers integrity','Verify that all the Customers assigned to a Bill Cycle Participate in that Bill Run','B.13 (2.2.13)','RB_14','Y','Y','TMF'),(231,60,10,'Correctness','Marketing definitions vs. Rate Plans','Verify that the rate planes are defined and operate in the rating engine accordingly to the Marketing definitions','B.23 (2.2.23)\nD.13 (2.4.13)','RB_53','Y','Y','TMF'),(232,60,10,'Completeness','Verify that Campaign information is registered in the Billing systems ','Look by all related information such as time-stamps, rates, entities (counts, pseudo periodic revenue loss, percentage)',NULL,'RB_71','Y','Y','TMF'),(233,90,27,'Trend','Look for deviations of unbilled accruals','Identify the deviation between  revenue accruals unbilled revenues and billed revenues corresponding to previous revenue accruals','AMX','FA_J','Y','Y','TAG'),(234,90,27,'Completeness','Verify that all accruals are reversed','Confirmation that the revenue accruals are reversed in the following month','AMX','FA_K','Y','Y','TAG'),(235,90,28,'Completeness','Verify that the deferrals are reversed','Identify if debt by air time (deferred revenues) has been cancelled according to the prepaid´s air time consumption','AMX','FA_L','Y','Y','TAG'),(236,30,3,'Completeness','Look for devations of\r  the shipments between\r  warehouses and to the dealers','*) Determine the relation between the equipment delivery from the Central Warehouse and the receptions of equipment in the Distribution Centre\r *) Determine the proportion between the equipment deliveries from the Distribution Centre and the equipment received by the Dealers','AMX','L_B','Y','Y','TAG'),(237,30,3,'Trend','Look for devations of\n the timeliness and credit\n notes of the technical service','*) Determine the proportion of equipment in warranty with overdue in the delivery date according to their contract\n*) Determine the proportion of equipment with penalization in the technical service that has a Credit Note','AMX','L_C','Y','Y','TAG'),(238,30,3,'Trend','Look for devations of the \r timeliness of the order\r  processing and technical service','*) Determine the relation\n between the requested \norders and the dispatched orders\n*) Determine the relation between the receptions and exit of equipment from the technical service (due to incidents)','AMX','L_A','Y','Y','TAG'),(239,30,29,'Completeness','Look for devation\ns of invoiced orders','Determines the proportion of output orders that have not been invoiced','AMX','L_D','Y','Y','TAG');
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
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;
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
INSERT INTO `cvg_product_group_key_risk_area_link` VALUES (1,1),(2,1),(3,1),(5,1),(6,1),(7,1),(8,1),(9,1),(10,1),(11,1),(13,1),(14,1),(15,1),(16,1),(17,1),(18,1),(19,1),(1,2),(2,2),(3,2),(5,2),(6,2),(7,2),(11,3),(8,4),(17,5),(1,6),(2,6),(3,6),(5,6),(6,6),(7,6),(1,7),(2,7),(3,7),(5,7),(6,7),(7,7),(1,9),(2,9),(7,9),(16,9),(1,10),(2,10),(3,10),(5,10),(6,10),(7,10),(8,10),(9,10),(10,10),(11,10),(13,10),(14,10),(15,10),(16,10),(17,10),(18,10),(19,10),(3,11),(9,11),(10,11),(11,11),(14,11),(15,11),(11,12),(1,13),(5,13),(1,14),(2,14),(3,14),(5,14),(6,14),(7,14),(8,14),(9,14),(10,14),(11,17),(15,19),(17,19),(1,20),(2,20),(3,20),(5,20),(6,20),(7,20),(8,20),(9,20),(10,20),(11,20),(13,20),(14,20),(15,20),(16,20),(17,20),(18,20),(19,20),(11,24),(13,24),(14,24),(15,24),(16,24),(19,24),(1,25),(2,25),(3,25),(5,25),(6,25),(7,25),(8,25),(9,25),(10,25),(1,26),(2,26),(3,26),(5,26),(6,26),(7,26),(8,26),(9,26),(10,26),(11,26),(13,26),(14,26),(15,26),(16,26),(17,26),(18,26),(19,26),(1,27),(5,27),(3,29),(9,29),(10,29),(11,29),(14,29),(1,30),(2,30),(3,30),(5,30),(6,30),(7,30),(8,30),(9,30),(10,30),(11,30),(13,30),(14,30),(15,30),(16,30),(17,30),(18,30),(19,30),(14,31),(11,32),(1,33),(2,33),(3,33),(5,33),(6,33),(7,33),(3,34),(9,34),(14,34),(1,35),(2,35),(3,35),(5,35),(6,35),(7,35),(3,38),(9,38),(10,38),(8,39),(9,39),(10,39),(11,40),(13,40),(14,40),(15,40);
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
  `SOURCE` enum('TMF','TAG') NOT NULL DEFAULT 'TMF',
  PRIMARY KEY (`RISK_ID`),
  KEY `fk_cvg_risk_1_idx` (`BUSINESS_SUB_PROCESS_ID`),
  CONSTRAINT `fk_cvg_risk_1` FOREIGN KEY (`BUSINESS_SUB_PROCESS_ID`) REFERENCES `cvg_business_sub_process` (`BUSINESS_SUB_PROCESS_ID`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_risk`
--

LOCK TABLES `cvg_risk` WRITE;
/*!40000 ALTER TABLE `cvg_risk` DISABLE KEYS */;
INSERT INTO `cvg_risk` VALUES (1,4,'Incorrect Reference data','Revenue Leakage','Leakage due to Incorrect reference data: Routing (including Least cost, Best quality and best value routings), numbering schemes/portability, etc. are not configured accurately in the network and/or processing platforms, interconnect, VAS, trunks, trunk groups. ','TMF'),(2,2,'Delay in order processing','Opportunity Loss','Delay in OE processing: from the time the customer sign to the time he is connected, non-technical delay','TMF'),(3,2,'Failure in order processing','Opportunity Loss','Error or loss due to Failure in order processing','TMF'),(4,2,'Wrong order inputs','Opportunity Loss','Insufficient or Erroneous data entered by CSR or automated system. Order with errors (including \"non recognizable\" products/add-ons) Products or services incorrectly allocated to customer','TMF'),(5,3,'Failure in provisioning resulting in lack of charging','Revenue Leakage','Usage without payment: Customer/Related Service exists on network but not provisioned for billing.  Or active customers in CRM not configured in billing  - customers are not invoiced. Delay in suspension of services resulted in unbilled trafic. Wrong assignment of promortion, discounts, numbering range to a customer resulted in undercharging.','TMF'),(6,3,'Failure in provisioning resulting in lack of service','Revenue Leakage','No usage or illegitimate charges: Customers and related services live in billing, but not configured on network. E.G DSL  Service','TMF'),(7,3,'Failure in equipment provisioning','Opportunity Loss','Missing or non paid provisioning, errors in ERP \"warehouses\",  etc.','TMF'),(8,3,'Provisioning delay','Opportunity Loss','Delay in provisioning (only)','TMF'),(9,3,'Stranded Assets ','Revenue Leakage','Stranded Assets (not using your infrastructures) + unnecessary licenses. Over payment for purchasing new equipment for the network, where idle equipment in the existing infrastructure can be re-used instead. Customers can not use resources . In certain cases can also affect CAPEX (cost).','TMF'),(10,3,'Over allocation of 3rd party\'s resources','Cost Leakage',' (Access, bandwidth, etc.)','TMF'),(11,3,'Under allocation of 3rd party\'s resources ','Opportunity Loss',' (Access, bandwidth, etc.)','TMF'),(12,7,'Authentication/Authorization erroneously block service','Revenue Leakage','Failure, blocks legal users','TMF'),(13,7,'Authentication/Authorization erroneously permit service','Revenue Leakage','Authentication/Authorization Failure, grants access to no registered users (including: prepaid with negative balance, roaming, etc.)','TMF'),(14,6,'Failure in collecting of events records (File not sent to mediation platform)','Revenue Leakage','Missing, corrupted (at files and records levels)','TMF'),(15,6,'Missing processed events in Mediation output','Revenue Leakage','Missing, corrupted (at files and records levels), Incomplete file loaded into Mediation ','TMF'),(16,6,'Incorrectly ignored events records','Revenue Leakage','Wrongly dropped or  marked as errors - CDRs incorrectly rejected in Mediation, include chargeable, rejected, suspended and dropped XDRs','TMF'),(17,6,'Miss-Processing of events records','Revenue Leakage','Errors in rounding or consolidation (partial events records), Incorrect transformation of file in Mediation / Missing XDRs in Mediation output (not in errors or dropped)','TMF'),(18,5,'Failure in usage records generation','Revenue Leakage','Failure at generation: Lossed, missing and errored events, including over-metering and under-metering, incorrect rounding. Note: implies to either usage record or prepaid deduction, can be detected by SDP vs. MSC descrepancies.','TMF'),(19,8,'Compromised Service level (network outage)','Revenue Leakage','Outage, errors, etc. at network or at peer networks, congestion, prepaid down time. ','TMF'),(20,13,'Billing file not produced (detected through usage compared to billing)','Revenue Leakage','At invoice (records) or files levels','TMF'),(21,13,'Bills not generated or not sent for payments','Revenue Leakage','To banks, credit agencies or clearing houses','TMF'),(22,11,'Rating suspense/non resolved validation write-off','Revenue Leakage','Old suspended events, CDR too old to be billed','TMF'),(23,12,'Miss-Processing of rated records','Revenue Leakage','Wrongly or erroneously guided records','TMF'),(24,12,'Missing billable events for invoicing','Opportunity Loss','Includes: rated records, adjustments, postponed payments, product catalog, customers data, TAP files (roaming) etc.','TMF'),(25,12,'Miss-Processing of Invoices','Revenue Leakage','Over and under charges, rounding errors, taxation errors, etc.','TMF'),(26,12,'Miss-configuration of \"aggregated\" billing (Interconnect, MVNO)','Revenue Leakage','Usually associated with \"aggregated\" billing such as interconnect, wholesale or MVNO. Note: I/C includes voice and messaging e.g. Interworking SMS)','TMF'),(27,12,'Manual Billing inaccuracies','Revenue Leakage',NULL,'TMF'),(28,12,'Incentives applied incorrectly (also expiration date of promotions)','Revenue Leakage',NULL,'TMF'),(29,12,'Prepaid charges miss-processing','Revenue Leakage','Missing or miss-processed prepaid billing (incl. under/over charges, rounding errors, etc.)','TMF'),(30,12,'Prepaid top-ups miss-processing','Revenue Leakage','Missing or miss-processed top-ups','TMF'),(31,10,'Non-usage pricing structure set up incorrectly, or any other standing data incorrectly configured','Revenue Leakage','Related to non-usage pricing (e.g. customer\'s contract, product catalog, equipment, flat rates, taxation,\\service, etc.) but also to usage pricing','TMF'),(32,10,'Rate Plans, price schemes, are not configured accurately in Billing system','Revenue Leakage','Related to usage records (for regular, premium, interconnect and roaming). New Products that are not configured in the billing and therefore  cannot be billed','TMF'),(33,9,'Failure in collection of events records for rating','Revenue Leakage','Missing, corrupted (at files and records levels) including: TAP-in, etc.)','TMF'),(34,9,'Missing processed events in output of rating','Revenue Leakage','Missing, corrupted (at rated records level) including: TAP-out, etc.','TMF'),(35,9,'Incorrectly ignored events records','Revenue Leakage','Incorrectly dropped or wrongly marked as errors','TMF'),(36,16,'Failure in collections process','Revenue Leakage','Inconstancies between invoices and payments, missing manual payments, postponed payments, etc.','TMF'),(37,14,'Missing or wrongly postings to accounting systems','Revenue Leakage','including: general ledger, ERP, SAP, etc.','TMF'),(38,18,'Credit Notes - Goodwill and discounts','Revenue Leakage','Wrong or non authorized credits or discounts to customers; or excessive goodwill credits','TMF'),(39,18,'Staff applying unauthorized credits to customer accounts','Revenue Leakage',NULL,'TMF'),(40,17,'Failure in credit vetting (new and existing customer)','Revenue Leakage','New customers are not thoroughly checked when registering to postpaid services','TMF'),(41,24,'Lower revenues due to arbitrage or bypass','Revenue Leakage','Most relevant for illegal activities, but may apply to legal ones','TMF'),(42,23,'Lower revenues due to high accepted dispute level','Revenue Leakage','The accepted dispute level is too high, causing over payments or lower revenues','TMF'),(43,22,'Missing receivables from dealers','Cost leakage','Not all revenues received from dealers, agents, resellers','TMF'),(44,22,'Commission payments not according to contract','Revenue Leakage','Unjustified level of commissions to resellers, agents, etc.','TMF'),(45,21,'Low/Negative revenue Margins with 3rd parties','Cost Leakage','Margins with interconnect, roaming and access, partners as well as: service, contents,  infrastructure providers and contractors.','TMF'),(46,20,'Costs Overpayment to peer operators','Revenue Leakage','Over Payments to interconnect, roaming and access.','TMF'),(47,20,'Under payments from  peer operators','Cost Leakage','Under payments from interconnect and roaming  or MVNOs (including: non fully utilized service/usage levels)','TMF'),(48,20,'Costs Overpayment to 3rd parties','Revenue Leakage','Payments to service, contents,  infrastructure providers and contractors.','TMF'),(49,1,'Discrepancies between product/offer definitions and implementation','Revenue Leakage','Products catalogs reside in billing or IN or application servers','TMF'),(50,1,'Discrepancies between campaigns definitions and implementation','Revenue Leakage','Expiry dates, promotion values, etc.','TMF'),(51,1,'No profit/Low margin','Revenue Leakage','Non involvment in Change management','TMF'),(52,14,'Incorrect  processing','Revenue Leakage','Including Taxation','TAG'),(53,20,'Under payments from  3rd parties','Revenue Leakage','Payments from 3rd parties','TAG'),(100,26,'Assets Management',NULL,'Assets Management','TAG'),(101,25,'Collections and write offs','Revenue Leakage','Anomalous deviations in billing, collections and bad debts / write offs','TAG'),(102,15,'Deficient margins on services or products','Revenue Leakage','Revenue or cost leakage due to deficient margins on services or products','TAG'),(103,19,'Operational overload of Customer Care','Cost Leakage','Operational overload of Customer Care','TAG'),(104,27,'Deviations of unbilled accruals','Revenue Leakage','Deviations of unbilled accruals','TAG'),(105,28,'Deviations of Deferrals',NULL,'Deviations of Deferrals','TAG'),(106,29,'Invoicing','Revenue Leakage','Deviations between fulfilled shipments and invoiced shipments','TAG'),(107,12,'test','Revenue Leakage',NULL,'TAG');
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
INSERT INTO `cvg_risk_key_risk_area_link` VALUES (9,1),(10,1),(11,1),(100,1),(103,1),(20,2),(21,2),(24,2),(25,2),(27,2),(28,2),(31,2),(32,2),(41,3),(13,4),(27,4),(29,4),(30,4),(43,5),(44,5),(38,6),(39,6),(40,6),(49,6),(50,6),(103,6),(38,7),(39,7),(40,7),(2,9),(3,9),(4,9),(7,9),(9,9),(10,9),(11,9),(103,9),(37,10),(104,10),(105,10),(1,11),(5,11),(13,11),(22,11),(46,11),(48,11),(15,12),(16,12),(17,12),(18,12),(20,12),(21,12),(23,12),(24,12),(25,12),(26,12),(32,12),(33,12),(34,12),(35,12),(37,12),(45,12),(46,12),(47,12),(102,12),(104,12),(38,13),(49,14),(50,14),(1,15),(3,15),(5,15),(6,15),(7,15),(12,15),(13,15),(19,15),(20,15),(21,15),(25,15),(26,15),(27,15),(31,15),(32,15),(37,15),(49,15),(50,15),(106,15),(26,17),(37,17),(45,17),(46,17),(47,17),(102,17),(1,18),(103,18),(36,19),(37,19),(43,19),(44,19),(45,19),(46,19),(47,19),(48,19),(53,19),(102,19),(36,20),(43,20),(101,20),(9,24),(10,24),(11,24),(45,24),(46,24),(47,24),(48,24),(53,24),(100,24),(49,25),(50,25),(51,25),(10,26),(43,26),(44,26),(45,26),(46,26),(47,26),(48,26),(51,26),(53,26),(38,27),(39,27),(5,29),(16,29),(22,29),(35,29),(37,30),(52,30),(104,30),(105,30),(14,31),(15,31),(16,31),(17,31),(18,31),(20,31),(21,31),(22,31),(23,31),(24,31),(25,31),(27,31),(33,31),(34,31),(37,31),(45,31),(46,31),(48,31),(53,31),(104,31),(1,32),(12,32),(13,32),(17,32),(46,32),(2,33),(3,33),(4,33),(40,33),(49,33),(103,33),(1,34),(2,34),(3,34),(4,34),(5,34),(6,34),(7,34),(8,34),(12,34),(13,34),(19,34),(103,34),(2,35),(3,35),(4,35),(5,35),(6,35),(8,35),(12,35),(13,35),(19,35),(21,35),(27,35),(28,35),(31,35),(32,35),(37,35),(52,35),(101,35),(102,35),(106,35),(14,38),(15,38),(16,38),(17,38),(18,38),(22,38),(23,38),(24,38),(33,38),(34,38),(35,38),(43,38),(103,38),(106,38),(30,39),(37,40),(41,40),(42,40),(44,40),(45,40),(46,40),(47,40),(48,40),(53,40),(102,40);
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
INSERT INTO `cvg_risk_measure_link` VALUES (1,108),(1,109),(1,110),(1,111),(1,112),(1,113),(2,114),(2,115),(2,116),(2,117),(2,118),(2,119),(2,120),(3,115),(4,114),(4,116),(4,117),(4,118),(4,120),(5,121),(5,122),(5,123),(5,124),(5,125),(5,126),(5,127),(5,128),(5,129),(6,122),(6,124),(6,125),(6,126),(6,128),(6,129),(7,122),(7,124),(7,128),(7,129),(7,237),(7,238),(8,124),(8,125),(8,126),(8,129),(9,122),(9,125),(9,126),(9,128),(9,129),(10,121),(10,122),(10,123),(10,124),(10,125),(10,126),(10,128),(10,129),(11,121),(11,122),(11,123),(11,124),(11,125),(11,126),(11,128),(11,129),(12,59),(12,61),(12,63),(13,58),(13,59),(13,60),(13,61),(13,62),(13,63),(13,64),(14,65),(14,66),(14,67),(15,65),(15,72),(15,73),(15,78),(16,65),(16,66),(16,67),(16,68),(16,71),(16,72),(16,73),(16,74),(16,75),(16,78),(16,79),(16,80),(16,81),(16,82),(16,83),(16,84),(17,67),(17,68),(17,69),(17,70),(17,71),(17,72),(17,73),(17,74),(17,75),(17,76),(17,77),(17,78),(17,79),(17,80),(17,81),(17,82),(17,83),(17,84),(18,85),(18,86),(18,87),(18,88),(18,89),(18,90),(18,91),(18,92),(18,93),(18,94),(18,95),(18,96),(18,97),(18,98),(18,99),(18,100),(18,101),(18,102),(18,103),(19,104),(19,105),(19,106),(21,160),(21,161),(21,162),(21,163),(21,164),(21,165),(21,166),(21,167),(21,168),(21,169),(22,170),(22,171),(22,172),(22,173),(22,174),(22,175),(22,176),(22,177),(23,195),(23,196),(23,197),(23,198),(23,199),(23,200),(23,201),(23,202),(23,203),(23,204),(23,205),(23,206),(23,207),(23,208),(23,209),(23,210),(23,211),(23,212),(23,213),(23,214),(23,216),(23,217),(23,218),(23,219),(23,220),(23,223),(23,224),(23,225),(23,226),(24,195),(24,196),(24,197),(24,198),(24,199),(24,200),(24,201),(24,202),(24,204),(24,207),(24,208),(24,209),(24,219),(25,195),(25,196),(25,197),(25,198),(25,199),(25,200),(25,201),(25,202),(25,203),(25,204),(25,206),(25,207),(25,212),(25,213),(25,214),(25,215),(25,216),(25,217),(25,218),(25,219),(25,220),(25,221),(25,222),(25,223),(25,224),(26,198),(26,199),(26,202),(26,219),(26,220),(26,221),(26,222),(27,198),(27,199),(28,219),(28,220),(28,221),(28,222),(28,223),(28,224),(28,225),(28,226),(29,200),(29,201),(29,202),(29,207),(29,216),(29,217),(29,219),(29,220),(29,221),(29,222),(29,223),(29,224),(29,225),(29,226),(30,200),(30,216),(30,217),(30,218),(30,219),(30,220),(30,221),(30,222),(30,223),(30,224),(30,225),(30,226),(31,230),(31,231),(31,232),(32,230),(32,231),(32,232),(33,178),(33,179),(33,180),(33,181),(33,182),(33,183),(33,184),(33,185),(33,186),(33,187),(33,188),(33,189),(33,190),(33,191),(33,192),(33,193),(33,194),(34,178),(34,179),(34,180),(34,181),(34,183),(34,191),(34,193),(34,194),(35,178),(35,179),(35,180),(35,181),(35,183),(35,184),(35,190),(35,191),(35,192),(35,193),(35,194),(36,22),(37,23),(37,24),(37,25),(37,26),(37,27),(37,28),(37,29),(37,30),(37,31),(37,32),(37,33),(37,34),(37,35),(37,36),(37,37),(37,38),(37,39),(37,40),(37,41),(37,42),(38,1),(38,2),(38,3),(38,4),(38,5),(38,6),(38,7),(38,8),(38,9),(38,10),(39,14),(39,15),(39,16),(39,17),(39,18),(39,19),(39,20),(39,21),(46,130),(46,131),(46,132),(46,133),(46,134),(46,135),(46,136),(46,137),(46,138),(46,139),(46,140),(46,141),(46,142),(47,130),(47,131),(47,132),(47,133),(47,134),(47,135),(47,136),(47,137),(47,138),(47,139),(47,140),(47,141),(47,142),(48,143),(48,144),(48,145),(48,146),(48,147),(48,148),(48,149),(48,150),(48,151),(48,152),(48,153),(48,154),(48,155),(49,156),(49,157),(50,158),(50,159),(51,156),(51,157),(51,158),(51,159),(52,43),(52,44),(53,143),(53,144),(53,145),(53,146),(53,147),(53,148),(53,149),(53,150),(53,151),(53,152),(53,153),(53,154),(53,155),(100,52),(100,53),(100,54),(100,55),(100,56),(100,57),(101,227),(101,228),(101,229),(102,45),(102,46),(102,47),(102,48),(102,49),(102,50),(102,51),(103,11),(103,12),(103,13),(104,233),(104,234),(105,235),(106,239);
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
  `BASE_LIKELIHOOD` int(11) NOT NULL DEFAULT '0',
  `BASE_IMPACT` int(11) NOT NULL DEFAULT '0',
  `RELEVANT` varchar(1) NOT NULL DEFAULT 'N',
  `REQUIRED` varchar(1) NOT NULL DEFAULT 'N',
  `SOURCE` enum('TMF','TAG') NOT NULL DEFAULT 'TMF',
  PRIMARY KEY (`SUB_RISK_ID`),
  KEY `fk_cvg_sub_risk_1_idx` (`RISK_ID`),
  CONSTRAINT `fk_cvg_sub_risk_1` FOREIGN KEY (`RISK_ID`) REFERENCES `cvg_risk` (`RISK_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cvg_sub_risk`
--

LOCK TABLES `cvg_sub_risk` WRITE;
/*!40000 ALTER TABLE `cvg_sub_risk` DISABLE KEYS */;
INSERT INTO `cvg_sub_risk` VALUES (1001,49,'New product launched without ability to generate bills',2,1,'Y','N','TMF'),(1002,49,'Withdrawn product sold even though not able to bill ',2,1,'Y','N','TMF'),(1003,51,'Product/service with negative margin',3,1,'Y','N','TMF'),(1004,51,'Unprofitable equipment sales',2,1,'Y','N','TMF'),(1005,51,'Unprofitable wholesale products',2,1,'Y','N','TMF'),(1006,51,'Products and services with lower margin than expected',2,1,'Y','N','TMF'),(1007,1,'Inaccurate bandwidth charged',1,1,'Y','N','TMF'),(1008,5,'Service provided but with insufficient information to bill customer',1,1,'Y','N','TMF'),(1009,4,'Service provided but with invalid customer information',1,2,'Y','Y','TMF'),(1010,5,'Service provided but with no billing account',1,1,'Y','N','TMF'),(1011,38,'Service still provided even though order cancelled and billing ceased',1,3,'Y','N','TMF'),(1012,5,'Provided features not billed',1,3,'Y','N','TMF'),(1013,6,'Charged non active and/or non ordered features',1,3,'Y','N','TMF'),(1014,42,'Expired promotion: discounted still applied',3,1,'Y','N','TMF'),(1015,9,'Stranded assets',2,1,'Y','N','TMF'),(1016,8,'Delays to service provisioning incurs third party costs',2,1,'Y','N','TMF'),(1017,10,'Early service provisiong incurs third party costs',1,1,'Y','N','TMF'),(1018,10,'Mismatch between rented and sold circuits (same as 9027)',3,1,'Y','N','TMF'),(1019,8,'Order cancelled due to delay in a service activation',2,1,'Y','N','TMF'),(1020,24,'One-time charges not applied',2,1,'Y','N','TMF'),(1021,1,'Ported-out number not delisted from billing',1,1,'Y','Y','TMF'),(1022,1,'Ported-in numbers not charged',1,1,'Y','N','TMF'),(1023,5,'PREPAID MSISDN  activated with POSTPAID contract, i.e. ICCID from  Prepaid Billing entered as Postpaid SIM for contract without activation (prepaid) and conversion (to postpaid) so no new pairing triggered in ressource management',1,1,'Y','N','TMF'),(1024,48,'Payment for third party services that have been cancelled',3,2,'Y','N','TMF'),(1025,24,'Changes in services not charged mid-billing cycle',1,1,'Y','N','TMF'),(1026,48,'Delay in cancelling third party services incurred additional cost',3,2,'Y','N','TMF'),(1027,10,'Over provisioning of network resources',2,1,'Y','N','TMF'),(1028,25,'Installation fees charged but should have been free of charge',1,1,'Y','N','TMF'),(1029,24,'Installation fees not charged when they should have been',2,1,'Y','N','TMF'),(1030,1,'Number ranges already in use assigned to new interconnect operator',0,0,'N','N','TMF'),(1031,25,'Incorrect charging of customer premises equipment',2,1,'Y','N','TMF'),(1032,4,'Wrong ISDN implemented',0,0,'N','N','TMF'),(1033,5,'Pre-paid subscriber not allocated to IN platform',1,2,'Y','N','TMF'),(1034,4,'Subscribers on wrong plan',1,2,'Y','N','TMF'),(1035,5,'Invalid roaming flag',1,2,'Y','N','TMF'),(1036,5,'Pre-paid subscriber in multiple IN platforms',1,2,'Y','N','TMF'),(1037,6,'HLR points to wrong IN platform',1,2,'Y','N','TMF'),(1038,1,'Invalid test call numbers',1,1,'Y','N','TMF'),(1039,1,'Invalid employee numbers',1,1,'Y','N','TMF'),(1040,7,'Non-activated MSISDN',1,1,'Y','N','TMF'),(1041,24,'Initial contract fee not charged/charge incorrectly',2,1,'Y','N','TMF'),(1042,24,'Upgrade fee not charge/charged incorrectly',2,1,'Y','N','TMF'),(1043,24,'Early termination/cancellation fee not charged/charged incorrectly',1,2,'Y','N','TMF'),(1044,38,'Customer deposit not credited to first/any bill',1,1,'Y','N','TMF'),(1045,7,'Over supply of customer premises equipment',1,1,'Y','N','TMF'),(1046,7,'Under supply of customer premises equipment',3,1,'Y','N','TMF'),(1047,7,'Delay to supply of customer premises equipment',3,1,'Y','N','TMF'),(1048,1,'Unexpected routing prefixes',1,2,'Y','N','TMF'),(1049,1,'Unexpected carrier selection code prefixes',1,2,'Y','N','TMF'),(1050,18,'Incorrect recording of call duration',1,2,'Y','N','TMF'),(1051,18,'Inaccurate timestamps',1,2,'Y','N','TMF'),(1052,17,'Duration rounding errors',1,1,'Y','N','TMF'),(1053,17,'Truncation of fractional part of call duration caused under charging of partner',1,1,'Y','N','TMF'),(1054,13,'Inbound roaming from operators with no roaming agreement',1,2,'Y','N','TMF'),(1055,13,'Overflow traffic higher than expected',1,2,'Y','N','TMF'),(1056,12,'Countries closed off',1,2,'Y','N','TMF'),(1057,46,'Interconnect traffic using higher cost routes than necessary',1,2,'Y','N','TMF'),(1058,13,'Pre-paid platform down time gives free usage',1,5,'Y','N','TMF'),(1059,13,'Unjustified testcard, testline or team tariff causing unrated / unbilled / not generated / missing CDRs',1,1,'Y','N','TMF'),(1060,13,'Usage not generated after employees move home',1,1,'Y','N','TMF'),(1061,14,'Incorrect transformation of usage data',1,3,'Y','N','TMF'),(1062,16,'Zero duration calls',1,1,'Y','N','TMF'),(1063,46,'Reallocation of trunk groups caused wrong partner to be charged',1,2,'Y','N','TMF'),(1064,13,'Staff handset used overseas',0,0,'N','N','TMF'),(1065,18,'Loss of CDRs caused by local storage failure on switch',1,4,'Y','N','TMF'),(1066,18,'Missing long duration call segments',1,1,'Y','N','TMF'),(1067,17,'Usage files discarded',1,4,'Y','N','TMF'),(1068,1,'Non-optimal routing',1,2,'Y','N','TMF'),(1069,18,'Incomplete CDRs',1,4,'Y','N','TMF'),(1070,18,'Incorrect number format',1,1,'Y','N','TMF'),(1071,12,'Prepaid subscribers not triggering IN platform',2,2,'Y','N','TMF'),(1072,17,'Incorrect aggregation of long duration call segments',1,1,'Y','N','TMF'),(1073,17,'Incorrect discarding of long duration calls',1,1,'Y','N','TMF'),(1074,16,'Long duration call not charged if partial record(s) missing',1,1,'Y','N','TMF'),(1075,18,'Inaccurate timestamps cause wrong rate to be applied',1,1,'Y','N','TMF'),(1076,17,'Time-shifting of usage records',1,1,'Y','N','TMF'),(1077,22,'Billable usage records incorrectly discarded',2,2,'Y','N','TMF'),(1078,16,'Billable usage rejected by mediation process',1,3,'Y','N','TMF'),(1079,16,'Billable usage discarded by mediation process',1,3,'Y','N','TMF'),(1080,17,'Incorrect handling of call status',1,1,'Y','N','TMF'),(1081,15,'Data not collected from network elements',1,4,'Y','N','TMF'),(1082,17,'Incorrect routing of usage data to end systems',1,3,'Y','N','TMF'),(1083,17,'Interconnect traffic not sent to settlement system',2,2,'Y','N','TMF'),(1084,23,'Call duration not calculated correctly (hh:mm:ss versus ssss)',1,1,'Y','N','TMF'),(1085,23,'Duplicated usage data',1,1,'Y','N','TMF'),(1086,21,'Roaming traffic not sent to clearing system',2,2,'Y','N','TMF'),(1087,23,'Incorrect number normalisation',2,2,'Y','N','TMF'),(1088,23,'Misidentification of service',0,0,'N','N','TMF'),(1089,9,'Unused trunk groups',2,1,'Y','N','TMF'),(1090,16,'Rejected usage data not found in error/suspense files',1,1,'Y','N','TMF'),(1091,18,'Valid charging cases do not generate usage records',1,2,'Y','N','TMF'),(1092,15,'Missing usage data files',1,3,'Y','N','TMF'),(1093,15,'Missing usage data blocks',1,3,'Y','N','TMF'),(1094,15,'Missing usage data records',1,3,'Y','N','TMF'),(1095,17,'Duplicated usage data - same filename and same content',1,2,'Y','N','TMF'),(1096,17,'Duplicated usage data - different filename and same content',2,2,'Y','N','TMF'),(1097,17,'Duplicated usage data - same filename and different content',1,1,'Y','N','TMF'),(1098,17,'Duplicate usage record',1,2,'Y','N','TMF'),(1099,18,'Mandatory data missing from usage data ',1,2,'Y','N','TMF'),(1100,1,'Data does not agree with the specification',1,2,'Y','N','TMF'),(1101,31,'Incorrect date normalisation',1,1,'Y','N','TMF'),(1102,31,'Incorrect duration normalisation',1,1,'Y','N','TMF'),(1103,31,'Incorrect currency normalilsation',1,1,'Y','N','TMF'),(1104,41,'International calling card caused bypass traffic not to be charged',3,1,'Y','N','TMF'),(1105,13,'Incoming traffic on outgoing routes',1,3,'Y','N','TMF'),(1106,13,'Outgoing traffic on incoming routes',1,3,'Y','N','TMF'),(1107,13,'Signalling abuse',1,2,'Y','N','TMF'),(1108,41,'SIM boxes bypassing interconnect settlement process',3,1,'Y','N','TMF'),(1109,17,'Not all interconnect traffic received by interconnect settlement system',1,3,'Y','N','TMF'),(1110,24,'Traffic routing error caused discounted rate not be reached ',1,2,'Y','N','TMF'),(1111,21,'Outbound TAP CDRs dropped between clearing house and TAP module',1,2,'Y','N','TMF'),(1112,17,'Inbound TAP CDRs dropped between clearing house and TAP module',1,3,'Y','N','TMF'),(1113,18,'Operator unable to bill for SMS due to missing delivery acknowledgement',1,1,'Y','N','TMF'),(1114,20,'Print shop does not receive all bills for printing/distribution',1,1,'Y','N','TMF'),(1115,22,'Short duration calls rounded to zero duration and not billed',1,1,'Y','N','TMF'),(1116,22,'Short duration calls not billed',1,1,'Y','N','TMF'),(1117,25,'Events not correctly rated due to logic errors in rating/billing engines',1,3,'Y','N','TMF'),(1118,31,'Events not correctly rated due to inaccurate reference data, wrong set-up of tariff plans',1,3,'Y','N','TMF'),(1119,31,'Customer reference data missing from rating engine',1,2,'Y','N','TMF'),(1120,22,'Event records written off because they are too old to bill',3,1,'Y','N','TMF'),(1121,22,'Rejected event records not actively managed',3,1,'Y','N','TMF'),(1122,27,'Manual billing inaccuracies',4,2,'Y','N','TMF'),(1123,25,'Bills do not include all services provided',1,3,'Y','N','TMF'),(1124,25,'Events incorrectly identified as duplicates',1,1,'Y','N','TMF'),(1125,25,'Billable usage rejected by billing process',2,1,'Y','N','TMF'),(1126,25,'Billable usage discarded by billing process',2,1,'Y','N','TMF'),(1127,31,'Countries not in correct charging band',2,1,'Y','N','TMF'),(1128,31,'Premium rate numbers not linked to billing accounts',1,3,'Y','N','TMF'),(1129,25,'Bundle allowance / accounting applied incorrectly (due to GB941D 2.4.12)',0,0,'N','N','TMF'),(1130,22,'Suspense file deleted',1,1,'Y','N','TMF'),(1131,23,'Duration and charge rounding',1,1,'Y','N','TMF'),(1132,31,'Tariff implementation does not agree with published rates',2,1,'Y','N','TMF'),(1133,25,'Bills produced do not cover all services provided',1,3,'Y','N','TMF'),(1134,31,'Pre-paid tariffs set up incorrectly',1,3,'Y','N','TMF'),(1135,31,'Retail tariffs set up incorrectly',1,3,'Y','N','TMF'),(1136,31,'Equipment tariff set up incorrectly',1,2,'Y','N','TMF'),(1137,31,'Non-usage pricing structure set up incorrectly. Wrong set-up of tariff plans related to one-time and recurring fees.',1,4,'Y','N','TMF'),(1138,25,'Too much tax charged to subscribers',3,1,'Y','N','TMF'),(1139,23,'Incorrect distance charge applied to call',1,1,'Y','N','TMF'),(1140,29,'Concurrent real-time charging loss',0,0,'N','N','TMF'),(1141,38,'Credit for unsuccessful pre-paid SMS given even when successful',3,1,'Y','Y','TMF'),(1142,13,'Pre-paid service allowed with zero balance',1,2,'Y','N','TMF'),(1143,31,'Customer reference information missing from rating engine',1,1,'Y','N','TMF'),(1144,25,'Excess (out of bundle) charges not applied when bundle exhaused',1,2,'Y','N','TMF'),(1145,25,'Excess (out of bundle) charges applied even though bundle purchased',1,1,'Y','N','TMF'),(1146,25,'Bundle charges applied when bundle had not been purchased',1,1,'Y','N','TMF'),(1147,29,'Pre-paid promotions not credited correctly',1,2,'Y','N','TMF'),(1148,29,'Pre-paid bonuses not credited correctly',1,2,'Y','N','TMF'),(1149,29,'Pre-paid registration fees not charged',0,0,'N','N','TMF'),(1150,29,'Pre-paid registration renewal fees not charged',3,1,'Y','N','TMF'),(1151,29,'Pre-paid service not terminated when balance reaches zero',1,3,'Y','N','TMF'),(1152,23,'Double charging of PREPAID roaming fees from TAP IN or CAML',1,1,'Y','N','TMF'),(1153,30,'Automatic pre-paid recharges not applied correctly',0,0,'N','N','TMF'),(1154,38,'Event-based discounts not applied correctly',2,2,'Y','N','TMF'),(1155,38,'Volume discounts not applied correctly',2,2,'Y','Y','TMF'),(1156,38,'Cross-product discounts not applied correctly',3,3,'Y','N','TMF'),(1157,38,'Account hierarchy discounts not applied correctly',1,3,'Y','N','TMF'),(1158,31,'Billing units determined incorrectly',2,1,'Y','N','TMF'),(1159,23,'Call set up fees not charged',1,3,'Y','N','TMF'),(1160,23,'Call set up fees charged for each partial record for long calls',1,2,'Y','N','TMF'),(1161,32,'Incorrect apportionment between time bands',0,0,'N','N','TMF'),(1162,32,'Application of minimum charges not correct',1,2,'Y','N','TMF'),(1163,32,'Application of maximum charges not correct',1,2,'Y','N','TMF'),(1164,25,'Tariff plan changes mid-billing cycle not charged correctly',1,2,'Y','N','TMF'),(1165,32,'Pre-paid tariff plan charges not debited/debited incorrectly',1,3,'Y','N','TMF'),(1166,26,'Out-payments for revenue share products calclulated incorrectly',2,3,'Y','N','TMF'),(1167,25,'Invoice line items do not agree with invoice summary',1,2,'Y','N','TMF'),(1168,25,'Usage data does not agree with invoice',1,2,'Y','N','TMF'),(1169,25,'Reports do not agree with usage data and invoice',1,1,'Y','N','TMF'),(1170,25,'Incorrect interest calculations',2,2,'Y','N','TMF'),(1171,31,'Incorrect currency conversion',2,2,'Y','N','TMF'),(1172,21,'Invoice produced but not issued or delayed',2,1,'Y','N','TMF'),(1173,21,'Invoice production/issue delayed',1,4,'Y','N','TMF'),(1174,34,'Bundle roll-over not carried forward',0,0,'N','N','TMF'),(1175,34,'Bundle roll-over carried forward incorrectly',0,0,'N','N','TMF'),(1176,5,'Orphaned child accounts',2,1,'Y','N','TMF'),(1177,28,'Discounting applied incorrectly',2,2,'Y','N','TMF'),(1178,28,'Incorrect pre-paid dedicated account credited/debited',2,2,'Y','N','TMF'),(1179,32,'Inconsistent rates between different pre-paid IN platforms',1,2,'Y','N','TMF'),(1180,28,'Promotion/credit does not expire at correct point in time',1,2,'Y','N','TMF'),(1181,29,'Pre-paid event priced correctly but not debited',1,2,'Y','N','TMF'),(1182,45,'Subscriber charging not in line with VAS outpayments',1,2,'Y','N','TMF'),(1183,25,'Incorrect party charged',1,1,'Y','N','TMF'),(1184,13,'Calling card service gives free calls to certain destinations',0,0,'N','N','TMF'),(1185,32,'Missing destination in number plan causes free/default rated call',0,0,'N','N','TMF'),(1186,1,'Dial strings do not align with traffic classes',0,0,'N','N','TMF'),(1187,31,'Destinations associated with incorrect rate bands',1,2,'Y','N','TMF'),(1188,31,'New rates not introduced on time',1,1,'Y','N','TMF'),(1189,31,'Tariff data entry errors result in incorrect pricing',1,2,'Y','N','TMF'),(1190,32,'Premium SMS numbers charged at normal rates',1,3,'Y','N','TMF'),(1191,32,'Inbound roaming charged at domestic rates',1,4,'Y','N','TMF'),(1192,32,'Mark-up rating incorrectly configured for several roaming partners',0,0,'N','N','TMF'),(1193,32,'Roaming charges for premium SMS set incorrectly',1,3,'Y','N','TMF'),(1194,32,'Off-net calls charged as on-net prices for certain traffic classes',1,3,'Y','N','TMF'),(1195,32,'Holiday rates applied to normal days',0,0,'N','N','TMF'),(1196,32,'Prices not held to correct level of precision',0,0,'N','N','TMF'),(1197,31,'Product offers assembled from incorrect tariff components',1,1,'Y','N','TMF'),(1198,13,'Barred numbers allowed',2,1,'Y','N','TMF'),(1199,25,'Wholesale recharges calculated incorrectly',2,3,'Y','N','TMF'),(1200,26,'Interconnect charging inaccuracies due to use of time of day blended rate',0,0,'N','N','TMF'),(1201,22,'Bad debt write-off',2,1,'Y','N','TMF'),(1202,40,'Cash collection process failure',1,3,'Y','Y','TMF'),(1203,40,'Cash collection process not triggered',1,3,'Y','N','TMF'),(1204,40,'Aged debt process not triggered',1,1,'Y','N','TMF'),(1205,40,'Dunning letters not generated for part-paid invoices',2,1,'Y','N','TMF'),(1206,30,'Pre-paid credit without a valid voucher',1,3,'Y','N','TMF'),(1207,30,'Multiple top-ups with the same pre-paid voucher',1,2,'Y','N','TMF'),(1208,30,'Pre-paid top-ups from stolen vouchers',1,2,'Y','N','TMF'),(1209,30,'Pre-paid top-ups without a valid voucher',1,2,'Y','N','TMF'),(1210,37,'Revenue incorrectly posted to general ledger',2,4,'Y','N','TMF'),(1211,43,'Incomplete processing of point of sales records ',2,2,'Y','N','TMF'),(1212,37,'Revenue not posted to general ledger',2,4,'Y','N','TMF'),(1213,36,'Tax over payment to tax authority',2,3,'Y','N','TMF'),(1214,36,'Tax under payment to tax authority',2,3,'Y','N','TMF'),(1215,46,'Pending credit not identified correctly',1,1,'Y','N','TMF'),(1216,38,'Rebates for customer complaints given too readily ',1,2,'Y','N','TMF'),(1217,30,'Pre-paid tops are credited to wrong account',1,2,'Y','N','TMF'),(1218,30,'Pre-paid tops are credit for wrong value',1,2,'Y','N','TMF'),(1219,28,'Discounts applied repeatedly within same account hierarchy',2,2,'Y','N','TMF'),(1220,27,'Incorrect manual intervention on the billing system ',3,2,'Y','N','TMF'),(1221,19,'Penalty payments for quality of service (SLA) violations ',2,2,'Y','N','TMF'),(1222,5,'Ported out numbers still active in billing system',1,1,'Y','N','TMF'),(1223,7,'Inactive MSISDN',1,1,'Y','N','TMF'),(1225,1,'Under charging of interconnect partner due to out of date route information',1,2,'Y','N','TMF'),(1226,46,'Over charging by interconnect partner',1,3,'Y','N','TMF'),(1227,11,'Penalty rate incurred as volume commitment not met',2,2,'Y','N','TMF'),(1228,41,'Arbitrage due to blended rates',0,0,'N','N','TMF'),(1229,41,'Arbitrage due to re-filing of traffic',0,0,'N','N','TMF'),(1230,44,'Over payment of commissions',4,3,'Y','N','TMF'),(1231,48,'Revenue is shared with partners incorrectly',2,2,'Y','N','TMF'),(1232,41,'Reseller traffic not correctly passed to third party',1,2,'Y','N','TMF'),(1233,46,'Settlement rate set up incorrectly in interconnect system',1,3,'Y','N','TMF'),(1234,24,'Missing usage data from clearing house',1,3,'Y','N','TMF'),(1235,24,'Inbound roaming TAP files rejected by clearing house',1,1,'Y','N','TMF'),(1236,24,'Inbound roaming TAP files rejected by clearing house due to incorrect SDR rate',1,1,'Y','N','TMF'),(1237,24,'Inbound roaming TAP files rejected by clearing house due to age of data',1,1,'Y','N','TMF'),(1238,24,'Inbound roaming TAP files do not contain all inbound roaming usage',1,2,'Y','N','TMF'),(1239,8,'Unnecessary call-outs due to incorrect reference data',2,1,'Y','N','TMF'),(1240,46,'Chargeable call-outs not charged/charged incorrectly',2,1,'Y','N','TMF'),(1241,19,'Unnecessary delay to service call-out',2,1,'Y','N','TMF'),(1242,1,'Circuits not purchased on correct tariff / wrong charge code id',1,3,'Y','N','TMF'),(1243,9,'Unused/cancelled/inactive circuits still purchased',2,1,'Y','N','TMF'),(1244,9,'Over ordering of customer premises equipment',2,1,'Y','N','TMF'),(1245,1,'Out of date reference data',2,2,'Y','N','TMF'),(9000,24,'SPI transactions (pre-rated charges) not loaded or rejected in billing',2,3,'Y','N','TAG'),(9001,1,'Circuit parameters do not correspond to the tariff (length, bandwidth, SLA)',2,2,'Y','N','TAG'),(9002,38,'Credit does not expire at correct point in time',2,2,'Y','Y','TAG'),(9003,34,'Calls crossing peak and offpeak time are not splitted.',1,1,'Y','N','TAG'),(9004,20,'Printable invoice not produced',1,1,'Y','N','TAG'),(9005,20,'Printable invoice amount is different than in billing system',1,2,'Y','N','TAG'),(9006,12,'Prepaid subscribers in Roaming are using open SMS Center, and thus not triggering charging on IN platform',2,5,'Y','N','TAG'),(9008,14,'Missing or incomplete SPI file generated',2,4,'Y','N','TAG'),(9009,2,'Order placed but not realized',1,3,'Y','N','TAG'),(9010,1,'Customer balance migration missing, amount incorrect',1,1,'Y','N','TAG'),(9011,3,'Failure in order processing',1,1,'Y','N','TAG'),(9012,11,'Under allocation of 3rd party\'s resources ',1,1,'Y','N','TAG'),(9013,33,'Failure in collecting of events records for rating',1,1,'Y','N','TAG'),(9014,35,'Incorrectly ignored events records',1,1,'Y','N','TAG'),(9015,39,'Staff applying unauthorized credits to customer accounts',1,1,'Y','N','TAG'),(9016,47,'Under payments from  peer operators',1,1,'Y','N','TAG'),(9017,50,'Discrepancies between campaigns definitions and implementation',1,1,'Y','N','TAG'),(9021,52,'Incorrect  processing of reports, profit & loss statement and financial statements',1,1,'Y','N','TAG'),(9022,53,'Under payments from  3rd parties',1,1,'Y','N','TAG'),(9023,34,'Missing processed events in output of rating',1,1,'Y','N','TAG'),(9024,100,'Assets Management',1,1,'Y','N','TAG'),(9025,101,'Anomalous deviations in billing, collections and bad debts / write offs',1,1,'Y','N','TAG'),(9026,102,'Revenue or cost leakage due to deficient margins on services or products',1,1,'Y','N','TAG'),(9027,11,'Mismatch between rented and sold circuits (same as 1018)',3,1,'Y','N','TAG'),(9028,103,'Operational overload of Customer Care',1,1,'Y','N','TAG'),(9029,104,'Deviations of unbilled accruals',1,1,'Y','N','TAG'),(9030,106,'Deviations between fulfilled shipments and invoiced shipments',1,1,'Y','N','TAG'),(9031,105,'Deviations in deferrals',1,1,'Y','N','TAG'),(9032,37,'Costs postings missing or wrong in general ledger ',2,4,'Y','N','TAG'),(9033,24,'Usage aggregation incorrect/incomplete',2,4,'Y','N','TAG'),(9034,107,'test2',1,1,'Y','N','TAG');
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
INSERT INTO `cvg_sub_risk_measure_link` VALUES (1001,156),(1001,157),(1002,156),(1003,45),(1004,49),(1005,46),(1005,48),(1006,50),(1006,51),(1008,114),(1008,121),(1008,127),(1009,114),(1009,116),(1009,117),(1009,118),(1010,121),(1010,127),(1011,1),(1011,11),(1011,12),(1012,127),(1012,128),(1013,121),(1013,127),(1013,128),(1013,239),(1014,132),(1014,136),(1014,140),(1014,148),(1014,153),(1016,123),(1016,124),(1017,124),(1017,238),(1018,117),(1018,118),(1019,237),(1019,238),(1020,192),(1020,202),(1021,111),(1021,112),(1022,111),(1022,112),(1023,127),(1023,128),(1024,145),(1025,191),(1025,192),(1025,193),(1025,204),(1025,230),(1026,152),(1026,153),(1026,154),(1027,117),(1027,122),(1028,202),(1028,217),(1028,219),(1029,191),(1029,202),(1029,217),(1029,219),(1029,230),(1031,202),(1033,122),(1033,124),(1033,127),(1033,128),(1034,114),(1034,116),(1034,117),(1034,118),(1034,126),(1034,127),(1035,119),(1036,122),(1037,117),(1037,118),(1037,119),(1038,113),(1039,113),(1040,116),(1041,191),(1041,202),(1041,230),(1042,202),(1042,204),(1042,207),(1043,191),(1043,192),(1043,202),(1043,230),(1044,8),(1044,9),(1045,236),(1045,237),(1046,236),(1046,237),(1047,238),(1048,108),(1048,109),(1048,110),(1049,108),(1049,109),(1049,110),(1050,87),(1050,89),(1051,86),(1052,69),(1052,76),(1053,69),(1053,76),(1054,58),(1056,59),(1056,61),(1056,63),(1058,58),(1058,59),(1058,60),(1058,61),(1058,62),(1058,63),(1058,64),(1059,58),(1059,59),(1059,60),(1059,61),(1061,65),(1061,66),(1061,67),(1062,80),(1062,81),(1064,58),(1064,59),(1064,61),(1065,85),(1065,88),(1065,90),(1065,92),(1065,93),(1065,94),(1065,96),(1065,98),(1065,100),(1065,102),(1066,71),(1067,67),(1067,68),(1067,75),(1067,80),(1067,81),(1067,82),(1067,83),(1067,84),(1068,108),(1069,86),(1069,91),(1069,95),(1069,97),(1070,86),(1070,91),(1070,95),(1070,97),(1071,59),(1071,63),(1071,106),(1072,71),(1073,71),(1073,80),(1073,81),(1074,71),(1075,86),(1075,91),(1075,95),(1075,97),(1076,70),(1076,77),(1077,170),(1077,171),(1077,172),(1077,181),(1077,182),(1078,80),(1078,81),(1079,82),(1079,83),(1080,70),(1080,77),(1080,104),(1081,65),(1081,72),(1081,73),(1081,78),(1082,106),(1083,75),(1083,78),(1084,182),(1084,183),(1084,184),(1085,205),(1085,206),(1086,188),(1086,189),(1087,182),(1089,108),(1089,109),(1090,82),(1090,83),(1091,85),(1091,90),(1091,93),(1091,96),(1091,100),(1092,65),(1092,72),(1092,73),(1092,78),(1093,65),(1093,72),(1093,73),(1093,78),(1094,65),(1094,72),(1094,73),(1094,78),(1095,66),(1095,67),(1096,66),(1096,67),(1097,66),(1097,67),(1098,66),(1098,67),(1099,86),(1099,91),(1099,95),(1099,97),(1101,182),(1101,204),(1102,182),(1102,197),(1103,182),(1109,77),(1109,78),(1110,210),(1110,219),(1111,188),(1111,189),(1112,67),(1113,90),(1113,91),(1113,92),(1113,100),(1114,160),(1114,161),(1114,162),(1115,209),(1115,210),(1116,209),(1116,210),(1117,182),(1117,204),(1118,182),(1118,231),(1118,232),(1119,215),(1119,230),(1119,231),(1120,189),(1121,170),(1121,171),(1121,172),(1122,199),(1123,195),(1123,196),(1123,197),(1123,201),(1124,205),(1124,206),(1125,170),(1125,171),(1125,172),(1126,170),(1126,171),(1126,172),(1127,230),(1127,231),(1127,232),(1128,230),(1130,170),(1130,171),(1130,172),(1131,210),(1132,231),(1133,195),(1133,196),(1133,197),(1134,230),(1134,231),(1134,232),(1135,230),(1135,231),(1135,232),(1136,192),(1136,231),(1136,232),(1137,192),(1137,193),(1137,231),(1137,232),(1138,203),(1138,212),(1138,213),(1138,215),(1139,202),(1139,204),(1140,200),(1140,202),(1140,207),(1140,223),(1140,224),(1140,225),(1141,9),(1141,14),(1142,58),(1142,59),(1142,60),(1142,61),(1142,62),(1142,63),(1142,64),(1143,230),(1144,192),(1144,193),(1144,231),(1145,192),(1145,193),(1145,231),(1146,192),(1146,193),(1146,231),(1147,200),(1147,202),(1147,231),(1148,200),(1148,202),(1149,200),(1150,200),(1150,202),(1150,223),(1151,224),(1151,225),(1152,200),(1154,15),(1154,16),(1154,17),(1154,18),(1154,19),(1154,20),(1154,21),(1155,15),(1155,16),(1155,17),(1155,18),(1155,19),(1155,20),(1155,21),(1156,15),(1156,16),(1156,17),(1156,18),(1156,19),(1156,20),(1156,21),(1157,15),(1157,16),(1157,17),(1157,18),(1157,19),(1157,20),(1157,21),(1158,184),(1158,202),(1159,182),(1159,183),(1160,182),(1160,183),(1160,208),(1162,202),(1162,230),(1162,231),(1162,232),(1163,202),(1163,230),(1163,231),(1163,232),(1164,204),(1164,231),(1165,202),(1165,230),(1165,231),(1165,232),(1166,182),(1167,195),(1167,196),(1168,181),(1168,195),(1168,196),(1171,182),(1172,160),(1172,169),(1173,160),(1173,169),(1176,121),(1177,219),(1177,220),(1177,221),(1177,222),(1178,223),(1178,225),(1179,202),(1180,219),(1180,221),(1181,223),(1181,224),(1181,225),(1182,146),(1182,151),(1182,152),(1183,191),(1183,230),(1187,182),(1187,202),(1187,231),(1188,231),(1188,232),(1189,231),(1189,232),(1190,182),(1190,231),(1191,182),(1191,231),(1193,182),(1193,231),(1194,182),(1194,204),(1194,231),(1197,192),(1197,193),(1197,231),(1197,232),(1198,58),(1198,59),(1198,60),(1198,61),(1201,176),(1201,177),(1201,228),(1201,229),(1206,223),(1206,225),(1207,225),(1207,226),(1208,225),(1208,226),(1209,223),(1209,225),(1209,226),(1210,23),(1210,25),(1210,233),(1211,143),(1211,144),(1212,23),(1212,25),(1212,233),(1213,22),(1213,23),(1214,22),(1214,23),(1216,1),(1216,2),(1216,3),(1216,4),(1216,5),(1217,225),(1217,226),(1218,217),(1218,223),(1218,225),(1219,219),(1219,220),(1220,199),(1221,102),(1221,103),(1221,105),(1222,111),(1222,112),(1223,116),(1225,109),(1226,131),(1226,134),(1227,108),(1227,109),(1227,110),(1227,129),(1230,145),(1231,146),(1232,151),(1232,155),(1234,185),(1234,186),(1234,187),(1235,188),(1235,189),(1236,188),(1236,189),(1237,188),(1237,189),(1238,188),(1238,189),(1240,131),(1240,134),(1243,108),(1243,109),(1245,110),(9000,178),(9000,179),(9002,1),(9003,204),(9004,160),(9004,163),(9004,164),(9005,165),(9005,166),(9008,65),(9008,66),(9008,67),(9009,123),(9009,124),(9009,237),(9009,238),(9011,125),(9011,126),(9012,117),(9012,122),(9013,178),(9013,179),(9013,180),(9013,185),(9013,186),(9013,187),(9014,178),(9014,179),(9014,180),(9014,181),(9015,16),(9015,17),(9015,18),(9015,20),(9016,135),(9016,137),(9016,138),(9016,141),(9017,158),(9017,159),(9021,43),(9021,44),(9022,151),(9022,155),(9023,181),(9023,183),(9024,52),(9024,53),(9024,54),(9024,55),(9024,56),(9024,57),(9025,176),(9025,177),(9025,227),(9025,228),(9025,229),(9027,117),(9027,118),(9028,12),(9029,233),(9029,234),(9030,236),(9030,239),(9031,235),(9032,22),(9033,201);
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

-- Dump completed on 2018-04-17  9:15:38
