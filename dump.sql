-- MySQL dump 10.13  Distrib 5.5.46, for debian-linux-gnu (x86_64)
--
-- Host: 10.7.0.9    Database: fxa
-- ------------------------------------------------------
-- Server version	5.5.44-0ubuntu0.14.04.1

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
-- Table structure for table `accountResetTokens`
--

DROP TABLE IF EXISTS `accountResetTokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accountResetTokens` (
  `tokenId` binary(32) NOT NULL,
  `tokenData` binary(32) NOT NULL,
  `uid` binary(16) NOT NULL,
  `createdAt` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`tokenId`),
  UNIQUE KEY `uid` (`uid`),
  KEY `createdAt` (`createdAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accountResetTokens`
--

LOCK TABLES `accountResetTokens` WRITE;
/*!40000 ALTER TABLE `accountResetTokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `accountResetTokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accountUnlockCodes`
--

DROP TABLE IF EXISTS `accountUnlockCodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accountUnlockCodes` (
  `uid` binary(16) NOT NULL,
  `unlockCode` binary(16) NOT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accountUnlockCodes`
--

LOCK TABLES `accountUnlockCodes` WRITE;
/*!40000 ALTER TABLE `accountUnlockCodes` DISABLE KEYS */;
/*!40000 ALTER TABLE `accountUnlockCodes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts` (
  `uid` binary(16) NOT NULL,
  `normalizedEmail` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `emailCode` binary(16) NOT NULL,
  `emailVerified` tinyint(1) NOT NULL DEFAULT '0',
  `kA` binary(32) NOT NULL,
  `wrapWrapKb` binary(32) NOT NULL,
  `authSalt` binary(32) NOT NULL,
  `verifyHash` binary(32) NOT NULL,
  `verifierVersion` tinyint(3) unsigned NOT NULL,
  `verifierSetAt` bigint(20) unsigned NOT NULL,
  `createdAt` bigint(20) unsigned NOT NULL,
  `locale` varchar(255) DEFAULT NULL,
  `lockedAt` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `normalizedEmail` (`normalizedEmail`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dbMetadata`
--

DROP TABLE IF EXISTS `dbMetadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dbMetadata` (
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dbMetadata`
--

LOCK TABLES `dbMetadata` WRITE;
/*!40000 ALTER TABLE `dbMetadata` DISABLE KEYS */;
INSERT INTO `dbMetadata` VALUES ('prune-last-ran','0'),('schema-patch-level','20');
/*!40000 ALTER TABLE `dbMetadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devices` (
  `uid` binary(16) NOT NULL,
  `id` binary(16) NOT NULL,
  `sessionTokenId` binary(32) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `type` varchar(16) DEFAULT NULL,
  `createdAt` bigint(20) unsigned DEFAULT NULL,
  `callbackURL` varchar(255) DEFAULT NULL,
  `callbackPublicKey` binary(32) DEFAULT NULL,
  PRIMARY KEY (`uid`,`id`),
  UNIQUE KEY `UQ_devices_sessionTokenId` (`uid`,`sessionTokenId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eventLog`
--

DROP TABLE IF EXISTS `eventLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eventLog` (
  `pos` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uid` binary(16) NOT NULL,
  `typ` enum('create','verify','reset','delete') NOT NULL,
  `iat` int(10) unsigned NOT NULL,
  PRIMARY KEY (`pos`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventLog`
--

LOCK TABLES `eventLog` WRITE;
/*!40000 ALTER TABLE `eventLog` DISABLE KEYS */;
/*!40000 ALTER TABLE `eventLog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eventLogPublishState`
--

DROP TABLE IF EXISTS `eventLogPublishState`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eventLogPublishState` (
  `lastPublishedPos` bigint(20) unsigned NOT NULL,
  `lastPublishedAt` int(10) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventLogPublishState`
--

LOCK TABLES `eventLogPublishState` WRITE;
/*!40000 ALTER TABLE `eventLogPublishState` DISABLE KEYS */;
INSERT INTO `eventLogPublishState` VALUES (0,0);
/*!40000 ALTER TABLE `eventLogPublishState` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `keyFetchTokens`
--

DROP TABLE IF EXISTS `keyFetchTokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `keyFetchTokens` (
  `tokenId` binary(32) NOT NULL,
  `authKey` binary(32) NOT NULL,
  `uid` binary(16) NOT NULL,
  `keyBundle` binary(96) NOT NULL,
  `createdAt` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`tokenId`),
  KEY `key_uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `keyFetchTokens`
--

LOCK TABLES `keyFetchTokens` WRITE;
/*!40000 ALTER TABLE `keyFetchTokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `keyFetchTokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `openids`
--

DROP TABLE IF EXISTS `openids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openids` (
  `hash` binary(32) NOT NULL,
  `id` varchar(255) NOT NULL,
  `uid` binary(16) NOT NULL,
  PRIMARY KEY (`hash`),
  KEY `openid_uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `openids`
--

LOCK TABLES `openids` WRITE;
/*!40000 ALTER TABLE `openids` DISABLE KEYS */;
/*!40000 ALTER TABLE `openids` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `passwordChangeTokens`
--

DROP TABLE IF EXISTS `passwordChangeTokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `passwordChangeTokens` (
  `tokenId` binary(32) NOT NULL,
  `tokenData` binary(32) NOT NULL,
  `uid` binary(16) NOT NULL,
  `createdAt` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`tokenId`),
  UNIQUE KEY `uid` (`uid`),
  KEY `session_uid` (`uid`),
  KEY `createdAt` (`createdAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `passwordChangeTokens`
--

LOCK TABLES `passwordChangeTokens` WRITE;
/*!40000 ALTER TABLE `passwordChangeTokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `passwordChangeTokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `passwordForgotTokens`
--

DROP TABLE IF EXISTS `passwordForgotTokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `passwordForgotTokens` (
  `tokenId` binary(32) NOT NULL,
  `tokenData` binary(32) NOT NULL,
  `uid` binary(16) NOT NULL,
  `passCode` binary(16) NOT NULL,
  `createdAt` bigint(20) unsigned NOT NULL,
  `tries` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`tokenId`),
  UNIQUE KEY `uid` (`uid`),
  KEY `createdAt` (`createdAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `passwordForgotTokens`
--

LOCK TABLES `passwordForgotTokens` WRITE;
/*!40000 ALTER TABLE `passwordForgotTokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `passwordForgotTokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessionTokens`
--

DROP TABLE IF EXISTS `sessionTokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessionTokens` (
  `tokenId` binary(32) NOT NULL,
  `tokenData` binary(32) NOT NULL,
  `uid` binary(16) NOT NULL,
  `createdAt` bigint(20) unsigned NOT NULL,
  `uaBrowser` varchar(255) DEFAULT NULL,
  `uaBrowserVersion` varchar(255) DEFAULT NULL,
  `uaOS` varchar(255) DEFAULT NULL,
  `uaOSVersion` varchar(255) DEFAULT NULL,
  `uaDeviceType` varchar(255) DEFAULT NULL,
  `lastAccessTime` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`tokenId`),
  KEY `session_uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessionTokens`
--

LOCK TABLES `sessionTokens` WRITE;
/*!40000 ALTER TABLE `sessionTokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessionTokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'fxa'
--
/*!50003 DROP PROCEDURE IF EXISTS `accountDevices_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `accountDevices_1`(
    IN `inUid` BINARY(16)
)
BEGIN
    SELECT tokenId as id FROM sessionTokens WHERE uid = inUid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `accountDevices_2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `accountDevices_2`(
  IN `inUid` BINARY(16)
)
BEGIN
  SELECT
    d.uid,
    d.id,
    d.sessionTokenId,
    d.name,
    d.type,
    d.createdAt,
    d.callbackURL,
    s.uaBrowser,
    s.uaBrowserVersion,
    s.uaOS,
    s.uaOSVersion,
    s.uaDeviceType,
    s.lastAccessTime
  FROM
    devices d LEFT JOIN sessionTokens s
  ON
    d.sessionTokenId = s.tokenId
  WHERE
    d.uid = inUid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `accountDevices_3` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `accountDevices_3`(
  IN `inUid` BINARY(16)
)
BEGIN
  SELECT
    d.uid,
    d.id,
    d.sessionTokenId,
    d.name,
    d.type,
    d.createdAt,
    d.callbackURL,
    d.callbackPublicKey,
    s.uaBrowser,
    s.uaBrowserVersion,
    s.uaOS,
    s.uaOSVersion,
    s.uaDeviceType,
    s.lastAccessTime
  FROM
    devices d LEFT JOIN sessionTokens s
  ON
    d.sessionTokenId = s.tokenId
  WHERE
    d.uid = inUid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `accountExists_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `accountExists_1`(
    IN `inEmail` VARCHAR(255)
)
BEGIN
    SELECT uid FROM accounts WHERE normalizedEmail = LOWER(inEmail);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `accountResetToken_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `accountResetToken_1`(
    IN `inTokenId` BINARY(32)
)
BEGIN
    SELECT
        t.uid,
        t.tokenData,
        t.createdAt,
        a.verifierSetAt
    FROM
        accountResetTokens t,
        accounts a
    WHERE
        t.tokenId = inTokenId
    AND
        t.uid = a.uid
    ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `account_2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `account_2`(
    IN `inUid` BINARY(16)
)
BEGIN
    SELECT
        a.uid,
        a.email,
        a.normalizedEmail,
        a.emailVerified,
        a.emailCode,
        a.kA,
        a.wrapWrapKb,
        a.verifierVersion,
        a.verifyHash,
        a.authSalt,
        a.verifierSetAt,
        a.createdAt,
        a.locale,
        a.lockedAt
    FROM
        accounts a
    WHERE
        a.uid = LOWER(inUid)
    ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `account_3` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `account_3`(
    IN `inUid` BINARY(16)
)
BEGIN
    SELECT
        a.uid,
        a.email,
        a.normalizedEmail,
        a.emailVerified,
        a.emailCode,
        a.kA,
        a.wrapWrapKb,
        a.verifierVersion,
        a.authSalt,
        a.verifierSetAt,
        a.createdAt,
        a.locale,
        a.lockedAt
    FROM
        accounts a
    WHERE
        a.uid = LOWER(inUid)
    ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ackPublishedEvents_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ackPublishedEvents_1`(
  IN `ackPos` BIGINT UNSIGNED
)
BEGIN

    
    UPDATE eventLogPublishState
    SET lastPublishedPos = ackPos, lastPublishedAt = UNIX_TIMESTAMP()
    WHERE lastPublishedPos < ackPos;

    DO RELEASE_LOCK('fxa-auth-server.event-log-lock');

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `checkPassword_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkPassword_1`(
    IN `inUid` BINARY(16),
    IN `inVerifyHash` BINARY(32)
)
BEGIN
    SELECT uid FROM accounts WHERE uid = inUid AND verifyHash = inVerifyHash;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createAccountResetToken_2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `createAccountResetToken_2`(
    IN tokenId BINARY(32),
    IN tokenData BINARY(32),
    IN uid BINARY(16),
    IN createdAt BIGINT UNSIGNED
)
BEGIN
    
    
    REPLACE INTO accountResetTokens(
        tokenId,
        tokenData,
        uid,
        createdAt
    )
    VALUES(
        tokenId,
        tokenData,
        uid,
        createdAt
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createAccount_2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `createAccount_2`(
    IN `uid` BINARY(16) ,
    IN `normalizedEmail` VARCHAR(255),
    IN `email` VARCHAR(255),
    IN `emailCode` BINARY(16),
    IN `emailVerified` TINYINT(1),
    IN `kA` BINARY(32),
    IN `wrapWrapKb` BINARY(32),
    IN `authSalt` BINARY(32),
    IN `verifierVersion` TINYINT UNSIGNED,
    IN `verifyHash` BINARY(32),
    IN `verifierSetAt` BIGINT UNSIGNED,
    IN `createdAt` BIGINT UNSIGNED,
    IN `locale` VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO accounts(
        uid,
        normalizedEmail,
        email,
        emailCode,
        emailVerified,
        kA,
        wrapWrapKb,
        authSalt,
        verifierVersion,
        verifyHash,
        verifierSetAt,
        createdAt,
        locale
    )
    VALUES(
        uid,
        LOWER(normalizedEmail),
        email,
        emailCode,
        emailVerified,
        kA,
        wrapWrapKb,
        authSalt,
        verifierVersion,
        verifyHash,
        verifierSetAt,
        createdAt,
        locale
    );

    INSERT INTO eventLog(
        uid,
        typ,
        iat
    )
    VALUES(
        uid,
        "create",
        UNIX_TIMESTAMP()
    );

    IF emailVerified THEN
        INSERT INTO eventLog(
            uid,
            typ,
            iat
        )
        VALUES(
            uid,
            "verify",
            UNIX_TIMESTAMP()
        );
    END IF;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createAccount_3` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `createAccount_3`(
    IN `uid` BINARY(16) ,
    IN `normalizedEmail` VARCHAR(255),
    IN `email` VARCHAR(255),
    IN `emailCode` BINARY(16),
    IN `emailVerified` TINYINT(1),
    IN `kA` BINARY(32),
    IN `wrapWrapKb` BINARY(32),
    IN `authSalt` BINARY(32),
    IN `verifierVersion` TINYINT UNSIGNED,
    IN `verifyHash` BINARY(32),
    IN `verifierSetAt` BIGINT UNSIGNED,
    IN `createdAt` BIGINT UNSIGNED,
    IN `locale` VARCHAR(255),
    IN `openid` VARCHAR(255),
    IN `openidHash` BINARY(32)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO accounts(
        uid,
        normalizedEmail,
        email,
        emailCode,
        emailVerified,
        kA,
        wrapWrapKb,
        authSalt,
        verifierVersion,
        verifyHash,
        verifierSetAt,
        createdAt,
        locale
    )
    VALUES(
        uid,
        LOWER(normalizedEmail),
        email,
        emailCode,
        emailVerified,
        kA,
        wrapWrapKb,
        authSalt,
        verifierVersion,
        verifyHash,
        verifierSetAt,
        createdAt,
        locale
    );

    IF openid IS NOT NULL THEN
        INSERT INTO openids(
            hash,
            id,
            uid
        )
        VALUES(
            openidHash,
            openid,
            uid
        );
    END IF;

    INSERT INTO eventLog(
        uid,
        typ,
        iat
    )
    VALUES(
        uid,
        "create",
        UNIX_TIMESTAMP()
    );

    IF emailVerified THEN
        INSERT INTO eventLog(
            uid,
            typ,
            iat
        )
        VALUES(
            uid,
            "verify",
            UNIX_TIMESTAMP()
        );
    END IF;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createDevice_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `createDevice_1`(
  IN `inUid` BINARY(16),
  IN `inId` BINARY(16),
  IN `inSessionTokenId` BINARY(32),
  IN `inName` VARCHAR(255),
  IN `inType` VARCHAR(16),
  IN `inCreatedAt` BIGINT UNSIGNED,
  IN `inCallbackURL` VARCHAR(255),
  IN `inCallbackPublicKey` BINARY(32)
)
BEGIN
  INSERT INTO devices(
    uid,
    id,
    sessionTokenId,
    name,
    type,
    createdAt,
    callbackURL,
    callbackPublicKey
  )
  VALUES (
    inUid,
    inId,
    inSessionTokenId,
    inName,
    inType,
    inCreatedAt,
    inCallbackURL,
    inCallbackPublicKey
  );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createKeyFetchToken_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `createKeyFetchToken_1`(
    IN tokenId BINARY(32),
    IN authKey BINARY(32),
    IN uid BINARY(16),
    IN keyBundle BINARY(96),
    IN createdAt BIGINT UNSIGNED
)
BEGIN
    INSERT INTO keyFetchTokens(
        tokenId,
        authKey,
        uid,
        keyBundle,
        createdAt
    )
    VALUES(
        tokenId,
        authKey,
        uid,
        keyBundle,
        createdAt
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createPasswordChangeToken_2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `createPasswordChangeToken_2`(
    IN tokenId BINARY(32),
    IN tokenData BINARY(32),
    IN uid BINARY(16),
    IN createdAt BIGINT UNSIGNED
)
BEGIN
    
    
    REPLACE INTO passwordChangeTokens(
        tokenId,
        tokenData,
        uid,
        createdAt
    )
    VALUES(
        tokenId,
        tokenData,
        uid,
        createdAt
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createPasswordForgotToken_2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `createPasswordForgotToken_2`(
    IN tokenId BINARY(32),
    IN tokenData BINARY(32),
    IN uid BINARY(16),
    IN passCode BINARY(16),
    IN createdAt BIGINT UNSIGNED,
    IN tries SMALLINT
)
BEGIN
    
    
    REPLACE INTO passwordForgotTokens(
        tokenId,
        tokenData,
        uid,
        passCode,
        createdAt,
        tries
    )
    VALUES(
        tokenId,
        tokenData,
        uid,
        passCode,
        createdAt,
        tries
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createSessionToken_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `createSessionToken_1`(
    IN tokenId BINARY(32),
    IN tokenData BINARY(32),
    IN uid BINARY(16),
    IN createdAt BIGINT UNSIGNED
)
BEGIN
    INSERT INTO sessionTokens(
        tokenId,
        tokenData,
        uid,
        createdAt
    )
    VALUES(
        tokenId,
        tokenData,
        uid,
        createdAt
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createSessionToken_2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `createSessionToken_2`(
    IN tokenId BINARY(32),
    IN tokenData BINARY(32),
    IN uid BINARY(16),
    IN createdAt BIGINT UNSIGNED,
    IN uaBrowser VARCHAR(255),
    IN uaBrowserVersion VARCHAR(255),
    IN uaOS VARCHAR(255),
    IN uaOSVersion VARCHAR(255),
    IN uaDeviceType VARCHAR(255)
)
BEGIN
    INSERT INTO sessionTokens(
        tokenId,
        tokenData,
        uid,
        createdAt,
        uaBrowser,
        uaBrowserVersion,
        uaOS,
        uaOSVersion,
        uaDeviceType,
        lastAccessTime
    )
    VALUES(
        tokenId,
        tokenData,
        uid,
        createdAt,
        uaBrowser,
        uaBrowserVersion,
        uaOS,
        uaOSVersion,
        uaDeviceType,
        createdAt
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `dbMetadata_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `dbMetadata_1`(
    IN `inName` VARCHAR(255)
)
BEGIN
    SELECT value FROM dbMetadata WHERE name = inName;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteAccountResetToken_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteAccountResetToken_1`(
    IN `inTokenId` BINARY(32)
)
BEGIN
    DELETE FROM accountResetTokens WHERE tokenId = inTokenId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteAccount_4` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteAccount_4`(
    IN `inUid` BINARY(16)
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    DELETE FROM sessionTokens WHERE uid = inUid;
    DELETE FROM keyFetchTokens WHERE uid = inUid;
    DELETE FROM accountResetTokens WHERE uid = inUid;
    DELETE FROM passwordChangeTokens WHERE uid = inUid;
    DELETE FROM passwordForgotTokens WHERE uid = inUid;
    DELETE FROM accountUnlockCodes WHERE uid = inUid;
    DELETE FROM accounts WHERE uid = inUid;

    INSERT INTO eventLog(
        uid,
        typ,
        iat
    )
    VALUES(
        inUid,
        "delete",
        UNIX_TIMESTAMP()
    );

    COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteAccount_5` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteAccount_5`(
    IN `inUid` BINARY(16)
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    DELETE FROM sessionTokens WHERE uid = inUid;
    DELETE FROM keyFetchTokens WHERE uid = inUid;
    DELETE FROM accountResetTokens WHERE uid = inUid;
    DELETE FROM passwordChangeTokens WHERE uid = inUid;
    DELETE FROM passwordForgotTokens WHERE uid = inUid;
    DELETE FROM accountUnlockCodes WHERE uid = inUid;
    DELETE FROM accounts WHERE uid = inUid;
    DELETE FROM openids WHERE uid = inUid;

    INSERT INTO eventLog(
        uid,
        typ,
        iat
    )
    VALUES(
        inUid,
        "delete",
        UNIX_TIMESTAMP()
    );

    COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteAccount_6` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteAccount_6`(
    IN `inUid` BINARY(16)
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    DELETE FROM sessionTokens WHERE uid = inUid;
    DELETE FROM keyFetchTokens WHERE uid = inUid;
    DELETE FROM accountResetTokens WHERE uid = inUid;
    DELETE FROM passwordChangeTokens WHERE uid = inUid;
    DELETE FROM passwordForgotTokens WHERE uid = inUid;
    DELETE FROM accountUnlockCodes WHERE uid = inUid;
    DELETE FROM accounts WHERE uid = inUid;
    DELETE FROM openids WHERE uid = inUid;
    DELETE FROM devices WHERE uid = inUid;

    INSERT INTO eventLog(
        uid,
        typ,
        iat
    )
    VALUES(
        inUid,
        "delete",
        UNIX_TIMESTAMP()
    );

    COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteDevice_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteDevice_1`(
    IN `inUid` BINARY(16),
    IN `inId` BINARY(16)
)
BEGIN
  DELETE
    devices, sessionTokens
  FROM
    devices LEFT JOIN sessionTokens
  ON
    devices.sessionTokenId = sessionTokens.tokenId
  WHERE
    devices.uid = inUid
  AND
    devices.id = inId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteKeyFetchToken_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteKeyFetchToken_1`(
    IN `inTokenId` BINARY(32)
)
BEGIN
    DELETE FROM keyFetchTokens WHERE tokenId = inTokenId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deletePasswordChangeToken_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deletePasswordChangeToken_1`(
    IN `inTokenId` BINARY(32)
)
BEGIN
    DELETE FROM passwordChangeTokens WHERE tokenId = inTokenId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deletePasswordForgotToken_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deletePasswordForgotToken_1`(
    IN `inTokenId` BINARY(32)
)
BEGIN
    DELETE FROM passwordForgotTokens WHERE tokenId = inTokenId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteSessionToken_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteSessionToken_1`(
    IN `inTokenId` BINARY(32)
)
BEGIN
    DELETE FROM sessionTokens WHERE tokenId = inTokenId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `emailRecord_2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `emailRecord_2`(
    IN `inEmail` VARCHAR(255)
)
BEGIN
    SELECT
        a.uid,
        a.email,
        a.normalizedEmail,
        a.emailVerified,
        a.emailCode,
        a.kA,
        a.wrapWrapKb,
        a.verifierVersion,
        a.verifyHash,
        a.authSalt,
        a.verifierSetAt,
        a.lockedAt
    FROM
        accounts a
    WHERE
        a.normalizedEmail = LOWER(inEmail)
    ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `emailRecord_3` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `emailRecord_3`(
    IN `inEmail` VARCHAR(255)
)
BEGIN
    SELECT
        a.uid,
        a.email,
        a.normalizedEmail,
        a.emailVerified,
        a.emailCode,
        a.kA,
        a.wrapWrapKb,
        a.verifierVersion,
        a.authSalt,
        a.verifierSetAt,
        a.lockedAt
    FROM
        accounts a
    WHERE
        a.normalizedEmail = LOWER(inEmail)
    ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `forgotPasswordVerified_4` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `forgotPasswordVerified_4`(
    IN `inPasswordForgotTokenId` BINARY(32),
    IN `inAccountResetTokenId` BINARY(32),
    IN `inTokenData` BINARY(32),
    IN `inUid` BINARY(16),
    IN `inCreatedAt` BIGINT UNSIGNED
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    
    
    REPLACE INTO accountResetTokens(
        tokenId,
        tokenData,
        uid,
        createdAt
    )
    VALUES(
        inAccountResetTokenId,
        inTokenData,
        inUid,
        inCreatedAt
    );

    DELETE FROM passwordForgotTokens WHERE tokenId = inPasswordForgotTokenId;

    DELETE FROM accountUnlockCodes WHERE uid = inUid;

    UPDATE accounts SET emailVerified = true, lockedAt = null WHERE uid = inUid;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getUnpublishedEvents_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getUnpublishedEvents_1`(
)
BEGIN

    SELECT @lockAcquired:=GET_LOCK('fxa-auth-server.event-log-lock', 1)
    AS lockAcquired;

    IF @lockAcquired THEN

      SELECT @lastPublishedPos:=lastPublishedPos
      AS lastPublishedPos FROM eventLogPublishState LIMIT 1;

      SELECT pos, uid, typ, iat
      FROM eventLog
      WHERE pos > @lastPublishedPos
      ORDER BY pos ASC
      LIMIT 100;

    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `keyFetchToken_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `keyFetchToken_1`(
    IN `inTokenId` BINARY(32)
)
BEGIN
    SELECT
        t.authKey,
        t.uid,
        t.keyBundle,
        t.createdAt,
        a.emailVerified,
        a.verifierSetAt
    FROM
        keyFetchTokens t,
        accounts a
    WHERE
        t.tokenId = inTokenId
    AND
        t.uid = a.uid
    ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `lockAccount_2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `lockAccount_2`(
    IN `inUid` BINARY(16),
    IN `inUnlockCode` BINARY(16),
    IN `inLockedAt` BIGINT UNSIGNED
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    
    
    REPLACE INTO accountUnlockCodes (
      uid,
      unlockCode
    )
    VALUES(
      inUid,
      inUnlockCode
    );

    UPDATE accounts SET lockedAt = inLockedAt WHERE uid = inUid;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `openIdRecord_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `openIdRecord_1`(
    IN `openidHash` BINARY(32)
)
BEGIN
    SELECT
        a.uid,
        a.email,
        a.normalizedEmail,
        a.emailVerified,
        a.emailCode,
        a.kA,
        a.wrapWrapKb,
        a.verifierVersion,
        a.authSalt,
        a.verifierSetAt,
        a.lockedAt,
        o.id as openId
    FROM
        accounts a,
        openids o
    WHERE
        o.hash = openidHash
    AND
        o.uid = a.uid
    ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `passwordChangeToken_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `passwordChangeToken_1`(
    IN `inTokenId` BINARY(32)
)
BEGIN
    SELECT
        t.uid,
        t.tokenData,
        t.createdAt,
        a.verifierSetAt
    FROM
        passwordChangeTokens t,
        accounts a
    WHERE
        t.tokenId = inTokenId
    AND
        t.uid = a.uid
    ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `passwordChangeToken_2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `passwordChangeToken_2`(
    IN `inTokenId` BINARY(32)
)
BEGIN
    SELECT
        t.uid,
        t.tokenData,
        t.createdAt,
        a.email,
        a.verifierSetAt
    FROM
        passwordChangeTokens t,
        accounts a
    WHERE
        t.tokenId = inTokenId
    AND
        t.uid = a.uid
    ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `passwordForgotToken_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `passwordForgotToken_1`(
    IN `inTokenId` BINARY(32)
)
BEGIN
    SELECT
        t.uid,
        t.tokenData,
        t.createdAt,
        t.passCode,
        t.tries,
        a.email,
        a.verifierSetAt
    FROM
        passwordForgotTokens t,
        accounts a
    WHERE
        t.tokenId = inTokenId
    AND
        t.uid = a.uid
    ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prune` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `prune`(IN pruneBefore BIGINT UNSIGNED, IN now BIGINT UNSIGNED)
BEGIN
    
    SELECT @lockAcquired:=GET_LOCK('fxa-auth-server.prune-lock', 3);

    IF @lockAcquired THEN

        SELECT @lastRan:=CONVERT(value, UNSIGNED) AS lastRan FROM dbMetadata WHERE `name` = 'prune-last-ran';

        IF @lastRan < pruneBefore THEN

            DELETE FROM accountResetTokens WHERE createdAt < pruneBefore;
            DELETE FROM passwordForgotTokens WHERE createdAt < pruneBefore;
            DELETE FROM passwordChangeTokens WHERE createdAt < pruneBefore;

            
            UPDATE dbMetadata SET value = CONVERT(now, CHAR) WHERE `name` = 'prune-last-ran';

        END IF;

        
        SELECT RELEASE_LOCK('fxa-auth-server.prune-lock');

    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `resetAccount_4` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `resetAccount_4`(
    IN `inUid` BINARY(16),
    IN `inVerifyHash` BINARY(32),
    IN `inAuthSalt` BINARY(32),
    IN `inWrapWrapKb` BINARY(32),
    IN `inVerifierSetAt` BIGINT UNSIGNED,
    IN `inVerifierVersion` TINYINT UNSIGNED
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    DELETE FROM sessionTokens WHERE uid = inUid;
    DELETE FROM keyFetchTokens WHERE uid = inUid;
    DELETE FROM accountResetTokens WHERE uid = inUid;
    DELETE FROM passwordChangeTokens WHERE uid = inUid;
    DELETE FROM passwordForgotTokens WHERE uid = inUid;
    DELETE FROM accountUnlockCodes WHERE uid = inUid;

    UPDATE
        accounts
    SET
        verifyHash = inVerifyHash,
        authSalt = inAuthSalt,
        wrapWrapKb = inWrapWrapKb,
        verifierSetAt = inVerifierSetAt,
        verifierVersion = inVerifierVersion
    WHERE
        uid = inUid
    ;

    INSERT INTO eventLog(
        uid,
        typ,
        iat
    )
    VALUES(
        inUid,
        "reset",
        UNIX_TIMESTAMP()
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sessions_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sessions_1`(
    IN `uidArg` BINARY(16)
)
BEGIN
    SELECT
        tokenId,
        uid,
        createdAt,
        uaBrowser,
        uaBrowserVersion,
        uaOS,
        uaOSVersion,
        uaDeviceType,
        lastAccessTime
    FROM sessionTokens
    WHERE uid = uidArg;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sessionToken_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sessionToken_1`(
    IN `inTokenId` BINARY(32)
)
BEGIN
    SELECT
        t.tokenData,
        t.uid,
        t.createdAt,
        a.emailVerified,
        a.email,
        a.emailCode,
        a.verifierSetAt,
        a.locale
    FROM
        sessionTokens t,
        accounts a
    WHERE
        t.tokenId = inTokenId
    AND
        t.uid = a.uid
    ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sessionToken_2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sessionToken_2`(
    IN `inTokenId` BINARY(32)
)
BEGIN
    SELECT
        t.tokenData,
        t.uid,
        t.createdAt,
        t.uaBrowser,
        t.uaBrowserVersion,
        t.uaOS,
        t.uaOSVersion,
        t.uaDeviceType,
        t.lastAccessTime,
        a.emailVerified,
        a.email,
        a.emailCode,
        a.verifierSetAt,
        a.locale
    FROM
        sessionTokens t,
        accounts a
    WHERE
        t.tokenId = inTokenId
    AND
        t.uid = a.uid
    ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sessionToken_3` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sessionToken_3`(
    IN `inTokenId` BINARY(32)
)
BEGIN
    SELECT
        t.tokenData,
        t.uid,
        t.createdAt,
        t.uaBrowser,
        t.uaBrowserVersion,
        t.uaOS,
        t.uaOSVersion,
        t.uaDeviceType,
        t.lastAccessTime,
        a.emailVerified,
        a.email,
        a.emailCode,
        a.verifierSetAt,
        a.locale,
        a.createdAt AS accountCreatedAt
    FROM
        sessionTokens t,
        accounts a
    WHERE
        t.tokenId = inTokenId
    AND
        t.uid = a.uid
    ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `unlockAccount_2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `unlockAccount_2`(
    IN `inUid` BINARY(16)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    DELETE FROM accountUnlockCodes WHERE uid = inUid;
    UPDATE accounts SET lockedAt = null WHERE uid = inUid;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `unlockCode_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `unlockCode_1`(
    in `inUid` BINARY(16)
)
BEGIN
    SELECT
        uc.unlockCode
    FROM
        accountUnlockCodes uc
    WHERE
        uc.uid = LOWER(inUid)
    ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateDevice_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateDevice_1`(
  IN `inUid` BINARY(16),
  IN `inId` BINARY(16),
  IN `inSessionTokenId` BINARY(32),
  IN `inName` VARCHAR(255),
  IN `inType` VARCHAR(16),
  IN `inCallbackURL` VARCHAR(255),
  IN `inCallbackPublicKey` BINARY(32)
)
BEGIN
  UPDATE devices
  SET sessionTokenId = COALESCE(inSessionTokenId, sessionTokenId),
    name = COALESCE(inName, name),
    type = COALESCE(inType, type),
    callbackURL = COALESCE(inCallbackURL, callbackURL),
    callbackPublicKey = COALESCE(inCallbackPublicKey, callbackPublicKey)
  WHERE uid = inUid AND id = inId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateLocale_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateLocale_1`(
    IN `inLocale` VARCHAR(255),
    IN `inUid` BINARY(16)
)
BEGIN
    UPDATE accounts SET locale = inLocale WHERE uid = inUid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updatePasswordForgotToken_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updatePasswordForgotToken_1`(
    IN `inTries` SMALLINT UNSIGNED,
    IN `inTokenId` BINARY(32)
)
BEGIN
    UPDATE passwordForgotTokens SET tries = inTries WHERE tokenId = inTokenId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateSessionToken_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSessionToken_1`(
    IN uaBrowserArg VARCHAR(255),
    IN uaBrowserVersionArg VARCHAR(255),
    IN uaOSArg VARCHAR(255),
    IN uaOSVersionArg VARCHAR(255),
    IN uaDeviceTypeArg VARCHAR(255),
    IN lastAccessTimeArg BIGINT UNSIGNED,
    IN tokenIdArg BINARY(32)
)
BEGIN
    UPDATE sessionTokens
        SET uaBrowser = uaBrowserArg,
            uaBrowserVersion = uaBrowserVersionArg,
            uaOS = uaOSArg,
            uaOSVersion = uaOSVersionArg,
            uaDeviceType = uaDeviceTypeArg,
            lastAccessTime = lastAccessTimeArg
        WHERE tokenId = tokenIdArg;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `upsertDevice_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `upsertDevice_1`(
    IN `inUid` BINARY(16),
    IN `inId` BINARY(16),
    IN `inSessionTokenId` BINARY(32),
    IN `inName` VARCHAR(255),
    IN `inType` VARCHAR(16),
    IN `inCreatedAt` BIGINT UNSIGNED,
    IN `inCallbackURL` VARCHAR(255)
)
BEGIN
  INSERT INTO devices(
    uid,
    id,
    sessionTokenId,
    name,
    type,
    createdAt,
    callbackURL
  )
  VALUES (
    inUid,
    inId,
    inSessionTokenId,
    inName,
    inType,
    inCreatedAt,
    inCallbackURL
  )
  ON DUPLICATE KEY UPDATE
    sessionTokenId = COALESCE(inSessionTokenId, sessionTokenId),
    name = COALESCE(inName, name),
    type = COALESCE(inType, type),
    callbackURL = COALESCE(inCallbackURL, callbackURL);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `verifyEmail_2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `verifyEmail_2`(
    IN `inUid` BINARY(16)
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    UPDATE accounts SET emailVerified = true WHERE uid = inUid;

    INSERT INTO eventLog(
        uid,
        typ,
        iat
    )
    VALUES(
        inUid,
        "verify",
        UNIX_TIMESTAMP()
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-01-23 20:53:54
