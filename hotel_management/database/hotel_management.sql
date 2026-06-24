-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: hotel_management
-- ------------------------------------------------------
-- Server version	8.0.38

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

--
-- Current Database: `hotel_management`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `hotel_management` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `hotel_management`;

--
-- Table structure for table `admin_user`
--

DROP TABLE IF EXISTS `admin_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(100) NOT NULL COMMENT 'username',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `role` varchar(100) DEFAULT 'admin' COMMENT 'role',
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '新增时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='legacy table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_user`
--

LOCK TABLES `admin_user` WRITE;
/*!40000 ALTER TABLE `admin_user` DISABLE KEYS */;
INSERT INTO `admin_user` VALUES (1,'admin','123456','admin','2026-04-28 16:20:37');
/*!40000 ALTER TABLE `admin_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bill`
--

DROP TABLE IF EXISTS `bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `booking_id` bigint DEFAULT NULL COMMENT 'booking order id',
  `checkin_id` bigint DEFAULT NULL COMMENT 'checkin record id',
  `customer_id` bigint DEFAULT NULL COMMENT 'customer id',
  `room_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'room amount',
  `service_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'service amount',
  `discount_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'discount amount',
  `payable_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'payable amount',
  `paid_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'paid amount',
  `refund_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'refund amount',
  `status` varchar(30) NOT NULL DEFAULT 'unpaid' COMMENT 'unpaid, partial, paid, refunded',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'updated time',
  PRIMARY KEY (`id`),
  KEY `idx_bill_booking` (`booking_id`),
  KEY `idx_bill_checkin` (`checkin_id`),
  KEY `idx_bill_customer` (`customer_id`),
  CONSTRAINT `fk_bill_booking` FOREIGN KEY (`booking_id`) REFERENCES `booking_order` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_bill_checkin` FOREIGN KEY (`checkin_id`) REFERENCES `checkin_record` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_bill_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_bill_discount_amount_nonnegative` CHECK ((`discount_amount` >= 0)),
  CONSTRAINT `chk_bill_paid_amount_nonnegative` CHECK ((`paid_amount` >= 0)),
  CONSTRAINT `chk_bill_payable_amount_nonnegative` CHECK ((`payable_amount` >= 0)),
  CONSTRAINT `chk_bill_refund_amount_nonnegative` CHECK ((`refund_amount` >= 0)),
  CONSTRAINT `chk_bill_refund_not_exceed_paid` CHECK ((`refund_amount` <= `paid_amount`)),
  CONSTRAINT `chk_bill_room_amount_nonnegative` CHECK ((`room_amount` >= 0)),
  CONSTRAINT `chk_bill_service_amount_nonnegative` CHECK ((`service_amount` >= 0)),
  CONSTRAINT `chk_bill_status` CHECK ((`status` in (_gbk'unpaid',_gbk'partial',_gbk'paid',_gbk'refunded')))
) ENGINE=InnoDB AUTO_INCREMENT=9507 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='bill master';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill`
--

LOCK TABLES `bill` WRITE;
/*!40000 ALTER TABLE `bill` DISABLE KEYS */;
INSERT INTO `bill` VALUES (9501,6008,9301,4001,122.00,20.00,5.00,137.00,137.00,0.00,'paid','2026-05-08 10:00:00','2026-05-08 10:00:00'),(9502,6010,NULL,4001,6.00,0.00,0.00,6.00,12.00,0.00,'paid','2026-05-27 11:58:51','2026-05-27 11:59:57'),(9503,6008,9301,4001,122.00,20.00,5.00,137.00,0.00,0.00,'unpaid','2026-06-10 16:50:26','2026-06-10 16:50:26'),(9504,6011,NULL,4001,666.00,0.00,0.00,666.00,1332.00,0.00,'paid','2026-06-23 22:34:20','2026-06-23 22:34:33'),(9505,6012,NULL,4001,122.00,0.00,0.00,122.00,244.00,0.00,'paid','2026-06-24 10:19:45','2026-06-24 10:19:51'),(9506,6008,9303,4001,122.00,20.00,5.00,137.00,0.00,0.00,'unpaid','2026-06-24 11:57:29','2026-06-24 11:57:29');
/*!40000 ALTER TABLE `bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_guest`
--

DROP TABLE IF EXISTS `booking_guest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_guest` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `booking_id` bigint NOT NULL COMMENT 'booking order id',
  `guest_name` varchar(100) NOT NULL COMMENT 'guest name',
  `id_card_no` varchar(30) DEFAULT NULL COMMENT 'id card number',
  `phone` varchar(30) DEFAULT NULL COMMENT 'phone number',
  `is_primary` tinyint NOT NULL DEFAULT '0' COMMENT 'primary guest flag',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'updated time',
  PRIMARY KEY (`id`),
  KEY `idx_booking_guest_booking` (`booking_id`),
  CONSTRAINT `fk_booking_guest_booking` FOREIGN KEY (`booking_id`) REFERENCES `booking_order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_booking_guest_primary` CHECK ((`is_primary` in (0,1)))
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='planned checkin guests before arrival';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_guest`
--

LOCK TABLES `booking_guest` WRITE;
/*!40000 ALTER TABLE `booking_guest` DISABLE KEYS */;
INSERT INTO `booking_guest` VALUES (1,6001,'Customer1','440300199901011234','13823888881',1,'2026-04-29 10:00:00','2026-04-29 10:00:00'),(2,6002,'Customer2','440300199902021234','13823888882',1,'2026-04-29 10:05:00','2026-04-29 10:05:00'),(3,6007,'HuYue','440300199003031234','13612512514',1,'2026-04-29 10:30:00','2026-04-29 10:30:00'),(4,6007,'LinQi','440300199505052345','13612514715',0,'2026-04-29 10:30:10','2026-04-29 10:30:10'),(5,6007,'ZhaoRan','440300199701017890','13612514716',0,'2026-04-29 10:30:20','2026-04-29 10:30:20'),(6,6003,'Customer3',NULL,'13823888883',1,'2026-05-23 17:56:09','2026-05-23 17:56:09'),(7,6004,'Customer4',NULL,'13823888884',1,'2026-05-23 17:56:09','2026-05-23 17:56:09'),(8,6005,'Customer5',NULL,'13823888885',1,'2026-05-23 17:56:09','2026-05-23 17:56:09'),(9,6006,'Customer6',NULL,'13823888886',1,'2026-05-23 17:56:09','2026-05-23 17:56:09'),(10,6008,'Customer1',NULL,'13823888881',1,'2026-05-23 17:56:09','2026-05-23 17:56:09'),(11,6009,'Customer2',NULL,'13823888882',1,'2026-05-23 17:56:09','2026-05-23 17:56:09'),(14,6010,'Customer1','330106222222222222','13823888881',1,'2026-05-27 11:59:47','2026-05-27 11:59:47'),(15,6010,'cusaa','222222222222222222','2222222',0,'2026-05-27 11:59:47','2026-05-27 11:59:47'),(16,6011,'Customer1','小A','13823888881',1,'2026-06-23 22:34:20','2026-06-23 22:34:20'),(17,6012,'Customer1','aaaaa','13823888881',1,'2026-06-24 10:19:45','2026-06-24 10:19:45');
/*!40000 ALTER TABLE `booking_guest` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_booking_guest_before_insert_validate` BEFORE INSERT ON `booking_guest` FOR EACH ROW BEGIN
    IF TRIM(COALESCE(NEW.guest_name,''))='' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='booking guest name cannot be empty';
    END IF;
    IF NEW.is_primary NOT IN (0,1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='booking guest primary flag must be 0 or 1';
    END IF;
    IF NEW.is_primary=1 AND EXISTS(SELECT 1 FROM `booking_guest` WHERE booking_id=NEW.booking_id AND is_primary=1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='only one primary booking guest is allowed for each order';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_booking_guest_before_update_validate` BEFORE UPDATE ON `booking_guest` FOR EACH ROW BEGIN
    IF TRIM(COALESCE(NEW.guest_name,''))='' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='booking guest name cannot be empty';
    END IF;
    IF NEW.is_primary NOT IN (0,1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='booking guest primary flag must be 0 or 1';
    END IF;
    IF NEW.is_primary=1 AND EXISTS(SELECT 1 FROM `booking_guest` WHERE booking_id=NEW.booking_id AND is_primary=1 AND id<>OLD.id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='only one primary booking guest is allowed for each order';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `booking_order`
--

DROP TABLE IF EXISTS `booking_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `yudingbianhao` varchar(200) DEFAULT NULL COMMENT '预定编号',
  `kefangmingcheng` varchar(200) NOT NULL COMMENT '客房名称',
  `room_category` varchar(200) NOT NULL COMMENT '客房类型',
  `kefangjiage` float NOT NULL COMMENT '客房价格',
  `shuliang` int DEFAULT NULL COMMENT '数量',
  `zongjine` float DEFAULT NULL COMMENT 'total amount',
  `kefangtupian` varchar(200) DEFAULT NULL COMMENT '客房图片',
  `jiudianmingcheng` varchar(200) DEFAULT NULL COMMENT '酒店名称',
  `jiudiandizhi` varchar(200) DEFAULT NULL COMMENT '酒店地址',
  `customerming` varchar(200) DEFAULT NULL COMMENT 'username',
  `xingming` varchar(200) DEFAULT NULL COMMENT '姓名',
  `shoujihao` varchar(200) DEFAULT NULL COMMENT 'mobile phone',
  `yudingriqi` date DEFAULT NULL COMMENT '预定日期',
  `ispay` varchar(200) DEFAULT 'unpaid' COMMENT 'payment status',
  `customer_id` bigint DEFAULT NULL COMMENT 'customer id',
  `room_catalog_id` bigint DEFAULT NULL COMMENT 'room catalog id',
  `expected_checkin_date` date DEFAULT NULL COMMENT 'expected checkin date',
  `expected_checkout_date` date DEFAULT NULL COMMENT 'expected checkout date',
  `booking_status` varchar(30) NOT NULL DEFAULT 'created' COMMENT 'created, checked_in, cancelled, completed',
  `room_instance_id` bigint DEFAULT NULL COMMENT 'assigned room id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `yudingbianhao` (`yudingbianhao`),
  KEY `idx_booking_order_customer` (`customer_id`),
  KEY `idx_booking_order_catalog` (`room_catalog_id`),
  KEY `idx_booking_order_dates` (`expected_checkin_date`,`expected_checkout_date`),
  KEY `fk_booking_order_room_instance` (`room_instance_id`),
  CONSTRAINT `fk_booking_order_catalog` FOREIGN KEY (`room_catalog_id`) REFERENCES `room_catalog` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_booking_order_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_booking_order_room_instance` FOREIGN KEY (`room_instance_id`) REFERENCES `room_instance` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_booking_order_date_range` CHECK (((`expected_checkin_date` is null) or (`expected_checkout_date` is null) or (`expected_checkout_date` > `expected_checkin_date`))),
  CONSTRAINT `chk_booking_order_pay_status` CHECK ((`ispay` in (_gbk'unpaid',_gbk'partial',_gbk'paid',_gbk'refunded'))),
  CONSTRAINT `chk_booking_order_price_nonnegative` CHECK ((`kefangjiage` >= 0)),
  CONSTRAINT `chk_booking_order_quantity_positive` CHECK (((`shuliang` is null) or (`shuliang` >= 1))),
  CONSTRAINT `chk_booking_order_status` CHECK ((`booking_status` in (_gbk'created',_gbk'checked_in',_gbk'cancelled',_gbk'completed'))),
  CONSTRAINT `chk_booking_order_total_nonnegative` CHECK (((`zongjine` is null) or (`zongjine` >= 0)))
) ENGINE=InnoDB AUTO_INCREMENT=6014 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='客房预定';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_order`
--

LOCK TABLES `booking_order` WRITE;
/*!40000 ALTER TABLE `booking_order` DISABLE KEYS */;
INSERT INTO `booking_order` VALUES (6001,'2026-04-29 10:00:00','BK202604290001','RoomName1','RoomType1',122,1,122,'upload/booking_order_kefangtupian1.jpg','ShangriLa Hotel','Address1','user1','Customer1','13823888881','2026-04-29','unpaid',4001,3001,'2026-04-29','2026-04-30','cancelled',8007),(6002,'2026-04-29 10:05:00','BK202604290002','RoomName2','RoomType2',2,1,2,'upload/booking_order_kefangtupian2.jpg','ShangriLa Hotel','Address2','user2','Customer2','13823888882','2026-04-29','unpaid',4002,3002,'2026-04-29','2026-04-30','cancelled',8006),(6003,'2026-04-29 10:10:00','BK202604290003','RoomName3','RoomType3',3,1,3,'upload/booking_order_kefangtupian3.jpg','ShangriLa Hotel','Address3','user3','Customer3','13823888883','2026-04-29','unpaid',4003,3003,'2026-04-29','2026-04-30','cancelled',8005),(6004,'2026-04-29 10:15:00','BK202604290004','RoomName4','RoomType4',4,1,4,'upload/booking_order_kefangtupian4.jpg','ShangriLa Hotel','Address4','user4','Customer4','13823888884','2026-04-29','unpaid',4004,3004,'2026-04-29','2026-04-30','cancelled',8004),(6005,'2026-04-29 10:20:00','BK202604290005','RoomName5','RoomType5',5,1,5,'upload/booking_order_kefangtupian5.jpg','ShangriLa Hotel','Address5','user5','Customer5','13823888885','2026-04-29','unpaid',4005,3005,'2026-04-29','2026-04-30','cancelled',8003),(6006,'2026-04-29 10:25:00','BK202604290006','RoomName6','RoomType6',6,1,6,'upload/booking_order_kefangtupian6.jpg','ShangriLa Hotel','Address6','user6','Customer6','13823888886','2026-04-29','unpaid',4006,3006,'2026-04-29','2026-04-30','cancelled',8002),(6007,'2026-04-29 10:30:00','BK202604290007','river view room','DeluxeSuite',666,2,1332,'upload/1649006659141.jpg','ShangriLa Hotel','Shenzhen Nanshan Avenue 1001','user7','HuYue','13612512514','2026-04-29','paid',4007,3007,'2026-04-29','2026-04-30','created',8001),(6008,'2026-05-08 10:00:00','BK202605080008','RoomName1','RoomType1',122,1,122,'upload/room_catalog_kefangtupian1.jpg','ShangriLa Hotel','Address1','user1','Customer1','13823888881','2026-05-08','paid',4001,3001,'2026-05-08','2026-05-09','completed',8014),(6009,'2026-05-08 10:00:00','BK202605080009','RoomName6','RoomType6',6,1,6,'upload/room_catalog_kefangtupian6.jpg','ShangriLa Hotel','Address6','user2','Customer2','13823888882','2026-05-08','unpaid',4002,3006,'2026-05-08','2026-05-09','completed',8009),(6010,'2026-05-27 03:58:51','BK202605270001','RoomName6','RoomType6',6,1,6,'upload/room_catalog_kefangtupian6.jpg','ShangriLa Hotel','Address6','user1','Customer1','13823888881','2026-05-28','paid',4001,3006,'2026-05-28','2026-05-29','created',8002),(6011,'2026-06-23 14:34:20','BK202606230001','river view room','DeluxeSuite',666,1,666,'upload/1649006659141.jpg','ShangriLa Hotel','Shenzhen Nanshan Avenue 1001','user1','Customer1','13823888881','2026-06-26','paid',4001,3007,'2026-06-26','2026-06-27','created',8001),(6012,'2026-06-24 02:19:45','BK202606240001','RoomName1','RoomType1',122,1,122,'upload/room_catalog_kefangtupian1.jpg','ShangriLa Hotel','Address1','user1','Customer1','13823888881','2026-06-25','paid',4001,3001,'2026-06-25','2026-06-26','checked_in',8007),(6013,'2026-06-24 03:07:13','BK202607010013','RoomName2','RoomType2',255,1,255,NULL,'ShangriLa Hotel','Address2','user1','Customer1','13823888881','2026-07-01','unpaid',4001,3002,'2026-07-01','2026-07-02','cancelled',8006);
/*!40000 ALTER TABLE `booking_order` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_booking_order_before_insert_validate` BEFORE INSERT ON `booking_order` FOR EACH ROW BEGIN
    IF NEW.shuliang IS NOT NULL AND NEW.shuliang < 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='booking quantity must be at least 1';
    END IF;
    IF NEW.kefangjiage < 0 OR (NEW.zongjine IS NOT NULL AND NEW.zongjine < 0) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='booking amount cannot be negative';
    END IF;
    IF NEW.expected_checkin_date IS NOT NULL AND NEW.expected_checkout_date IS NOT NULL AND NEW.expected_checkout_date <= NEW.expected_checkin_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='expected checkout date must be after expected checkin date';
    END IF;
    IF NEW.ispay NOT IN ('unpaid','partial','paid','refunded') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='invalid booking payment status';
    END IF;
    IF NEW.booking_status NOT IN ('created','checked_in','cancelled','completed') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='invalid booking status';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_booking_after_insert_lock_room` AFTER INSERT ON `booking_order` FOR EACH ROW BEGIN
    DECLARE v_old_status varchar(30);
    IF NEW.room_instance_id IS NOT NULL THEN
        SELECT status INTO v_old_status FROM `room_instance` WHERE id=NEW.room_instance_id;
        IF v_old_status='available' THEN
            UPDATE `room_instance` SET status='reserved',updated_at=NOW() WHERE id=NEW.room_instance_id;
            INSERT INTO `room_status_log`(room_id,old_status,new_status,source_type,source_id,operator_id,remark)
            VALUES(NEW.room_instance_id,v_old_status,'reserved','booking_order',NEW.id,NULL,CONCAT('booking created: ',IFNULL(NEW.yudingbianhao,NEW.id)));
        END IF;
    END IF;
    INSERT INTO `booking_status_log`(booking_id,old_status,new_status,operator_id,remark)
    VALUES(NEW.id,NULL,NEW.booking_status,NULL,'booking inserted');
    INSERT INTO `operation_log`(operator_type,operator_id,business_type,business_id,action,remark)
    VALUES('system',NULL,'booking_order',NEW.id,'after_insert_booking',NEW.yudingbianhao);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_booking_order_before_update_validate` BEFORE UPDATE ON `booking_order` FOR EACH ROW BEGIN
    IF NEW.shuliang IS NOT NULL AND NEW.shuliang < 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='booking quantity must be at least 1';
    END IF;
    IF NEW.kefangjiage < 0 OR (NEW.zongjine IS NOT NULL AND NEW.zongjine < 0) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='booking amount cannot be negative';
    END IF;
    IF NEW.expected_checkin_date IS NOT NULL AND NEW.expected_checkout_date IS NOT NULL AND NEW.expected_checkout_date <= NEW.expected_checkin_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='expected checkout date must be after expected checkin date';
    END IF;
    IF NEW.ispay NOT IN ('unpaid','partial','paid','refunded') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='invalid booking payment status';
    END IF;
    IF NEW.booking_status NOT IN ('created','checked_in','cancelled','completed') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='invalid booking status';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_booking_after_update_release_room` AFTER UPDATE ON `booking_order` FOR EACH ROW BEGIN
    DECLARE v_current_status varchar(30);
    IF OLD.booking_status<>NEW.booking_status THEN
        INSERT INTO `booking_status_log`(booking_id,old_status,new_status,operator_id,remark)
        VALUES(NEW.id,OLD.booking_status,NEW.booking_status,NULL,'booking status changed');
    END IF;
    IF NEW.booking_status='cancelled' AND OLD.booking_status<>'cancelled' AND NEW.room_instance_id IS NOT NULL THEN
        SELECT status INTO v_current_status FROM `room_instance` WHERE id=NEW.room_instance_id;
        UPDATE `room_instance` SET status='available',updated_at=NOW() WHERE id=NEW.room_instance_id AND status IN ('reserved','available');
        INSERT INTO `room_status_log`(room_id,old_status,new_status,source_type,source_id,operator_id,remark)
        VALUES(NEW.room_instance_id,v_current_status,'available','booking_order',NEW.id,NULL,'booking cancelled and room released');
    END IF;
    IF NEW.booking_status='cancelled' AND OLD.booking_status<>'cancelled' THEN
        UPDATE `booking_room` SET room_status='cancelled' WHERE booking_id=NEW.id AND room_status IN ('reserved','checked_in');
        INSERT INTO `room_status_log`(room_id,old_status,new_status,source_type,source_id,operator_id,remark)
        SELECT br.room_id, ri.status, 'available', 'booking_room', br.id, NULL, 'booking cancelled and detail room released'
        FROM `booking_room` br JOIN `room_instance` ri ON ri.id=br.room_id
        WHERE br.booking_id=NEW.id AND ri.status='reserved';
        UPDATE `room_instance` ri JOIN `booking_room` br ON br.room_id=ri.id
           SET ri.status='available', ri.updated_at=NOW()
        WHERE br.booking_id=NEW.id AND ri.status='reserved';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `booking_room`
--

DROP TABLE IF EXISTS `booking_room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_room` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `booking_id` bigint NOT NULL COMMENT 'booking order id',
  `room_id` bigint NOT NULL COMMENT 'room instance id',
  `room_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'locked room price',
  `stay_start_date` date NOT NULL COMMENT 'planned checkin date',
  `stay_end_date` date NOT NULL COMMENT 'planned checkout date',
  `room_status` varchar(30) NOT NULL DEFAULT 'reserved' COMMENT 'reserved, checked_in, cancelled, completed',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_booking_room` (`booking_id`,`room_id`),
  KEY `idx_booking_room_room_date` (`room_id`,`stay_start_date`,`stay_end_date`),
  KEY `idx_booking_room_status` (`room_status`),
  CONSTRAINT `fk_booking_room_booking` FOREIGN KEY (`booking_id`) REFERENCES `booking_order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_booking_room_room` FOREIGN KEY (`room_id`) REFERENCES `room_instance` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_booking_room_date_range` CHECK ((`stay_end_date` > `stay_start_date`)),
  CONSTRAINT `chk_booking_room_price_nonnegative` CHECK ((`room_price` >= 0)),
  CONSTRAINT `chk_booking_room_status` CHECK ((`room_status` in (_gbk'reserved',_gbk'checked_in',_gbk'cancelled',_gbk'completed')))
) ENGINE=InnoDB AUTO_INCREMENT=7015 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='booking room detail for one order with multiple rooms';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_room`
--

LOCK TABLES `booking_room` WRITE;
/*!40000 ALTER TABLE `booking_room` DISABLE KEYS */;
INSERT INTO `booking_room` VALUES (7001,6001,8007,122.00,'2026-04-29','2026-04-30','cancelled','2026-05-07 09:00:00'),(7002,6002,8006,2.00,'2026-04-29','2026-04-30','cancelled','2026-05-07 09:00:00'),(7003,6003,8005,3.00,'2026-04-29','2026-04-30','cancelled','2026-05-07 09:00:00'),(7004,6004,8004,4.00,'2026-04-29','2026-04-30','cancelled','2026-05-07 09:00:00'),(7005,6005,8003,5.00,'2026-04-29','2026-04-30','cancelled','2026-05-07 09:00:00'),(7006,6006,8002,6.00,'2026-04-29','2026-04-30','cancelled','2026-05-07 09:00:00'),(7007,6007,8001,666.00,'2026-04-29','2026-04-30','reserved','2026-05-07 09:00:00'),(7008,6007,8008,666.00,'2026-04-29','2026-04-30','reserved','2026-05-07 09:00:00'),(7009,6008,8014,122.00,'2026-05-08','2026-05-09','completed','2026-05-08 10:00:00'),(7010,6009,8009,6.00,'2026-05-08','2026-05-09','completed','2026-05-08 10:00:00'),(7011,6010,8002,6.00,'2026-05-28','2026-05-29','reserved','2026-05-27 11:58:51'),(7012,6011,8001,666.00,'2026-06-26','2026-06-27','reserved','2026-06-23 22:34:20'),(7013,6012,8007,122.00,'2026-06-25','2026-06-26','checked_in','2026-06-24 10:19:45'),(7014,6013,8006,255.00,'2026-07-01','2026-07-02','cancelled','2026-06-24 11:07:13');
/*!40000 ALTER TABLE `booking_room` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_booking_room_after_insert_lock_room` AFTER INSERT ON `booking_room` FOR EACH ROW BEGIN
    DECLARE v_old_status varchar(30);
    IF NEW.room_status IN ('reserved','checked_in') THEN
        SELECT status INTO v_old_status FROM `room_instance` WHERE id=NEW.room_id;
        IF v_old_status='available' THEN
            UPDATE `room_instance`
               SET status=CASE WHEN NEW.room_status='checked_in' THEN 'occupied' ELSE 'reserved' END,
                   updated_at=NOW()
             WHERE id=NEW.room_id;
            INSERT INTO `room_status_log`(room_id,old_status,new_status,source_type,source_id,operator_id,remark)
            VALUES(NEW.room_id,v_old_status,CASE WHEN NEW.room_status='checked_in' THEN 'occupied' ELSE 'reserved' END,'booking_room',NEW.id,NULL,'booking room detail locked room');
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `booking_status_log`
--

DROP TABLE IF EXISTS `booking_status_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_status_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `booking_id` bigint NOT NULL COMMENT 'booking order id',
  `old_status` varchar(30) DEFAULT NULL COMMENT 'old status',
  `new_status` varchar(30) NOT NULL COMMENT 'new status',
  `operator_id` bigint DEFAULT NULL COMMENT 'operator id',
  `remark` varchar(500) DEFAULT NULL COMMENT 'remark',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  PRIMARY KEY (`id`),
  KEY `idx_booking_status_booking_time` (`booking_id`,`created_at`),
  CONSTRAINT `fk_booking_status_log_booking` FOREIGN KEY (`booking_id`) REFERENCES `booking_order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9133 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='booking status change log';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_status_log`
--

LOCK TABLES `booking_status_log` WRITE;
/*!40000 ALTER TABLE `booking_status_log` DISABLE KEYS */;
INSERT INTO `booking_status_log` VALUES (9101,6008,NULL,'created',NULL,'booking inserted','2026-05-08 10:00:00'),(9102,6009,NULL,'created',NULL,'booking inserted','2026-05-08 10:00:00'),(9103,6008,NULL,'checked_in',5001,'checkin record inserted','2026-05-08 10:00:00'),(9104,6008,'created','checked_in',NULL,'booking status changed','2026-05-08 10:00:00'),(9105,6008,'created','checked_in',5001,'confirm checkin','2026-05-08 10:00:00'),(9106,6008,'checked_in','completed',NULL,'booking status changed','2026-05-08 10:00:00'),(9107,6009,NULL,'checked_in',5002,'checkin record inserted','2026-05-08 10:00:00'),(9108,6009,'created','checked_in',NULL,'booking status changed','2026-05-08 10:00:00'),(9109,6009,'created','checked_in',5002,'confirm checkin','2026-05-08 10:00:00'),(9110,6001,'created','cancelled',NULL,'booking status changed','2026-05-23 17:56:37'),(9111,6002,'created','cancelled',NULL,'booking status changed','2026-05-23 17:56:37'),(9112,6003,'created','cancelled',NULL,'booking status changed','2026-05-23 17:56:37'),(9113,6004,'created','cancelled',NULL,'booking status changed','2026-05-23 17:56:37'),(9114,6005,'created','cancelled',NULL,'booking status changed','2026-05-23 17:56:37'),(9115,6006,'created','cancelled',NULL,'booking status changed','2026-05-23 17:56:37'),(9116,6010,NULL,'created',NULL,'booking inserted','2026-05-27 11:58:51'),(9117,6010,NULL,'created',4001,'customer submitted booking from front desk','2026-05-27 11:58:51'),(9118,6008,NULL,'checked_in',5001,'checkin record inserted','2026-06-10 16:50:25'),(9119,6008,'completed','checked_in',NULL,'booking status changed','2026-06-10 16:50:26'),(9120,6008,'completed','checked_in',5001,'confirm checkin','2026-06-10 16:50:26'),(9121,6008,'checked_in','completed',NULL,'booking status changed','2026-06-10 16:50:26'),(9122,6009,'checked_in','completed',NULL,'booking status changed','2026-06-10 18:28:08'),(9123,6011,NULL,'created',NULL,'booking inserted','2026-06-23 22:34:20'),(9124,6011,NULL,'created',4001,'customer submitted booking from front desk','2026-06-23 22:34:20'),(9125,6012,NULL,'created',NULL,'booking inserted','2026-06-24 10:19:45'),(9126,6012,NULL,'created',4001,'customer submitted booking from front desk','2026-06-24 10:19:45'),(9127,6013,NULL,'created',NULL,'booking inserted','2026-06-24 11:07:13'),(9128,6013,NULL,'created',5001,'booking created by procedure, rooms=1','2026-06-24 11:07:13'),(9129,6012,NULL,'checked_in',5001,'checkin record inserted','2026-06-24 11:10:13'),(9130,6012,'created','checked_in',NULL,'booking status changed','2026-06-24 11:10:13'),(9131,6012,'created','checked_in',5001,'confirm checkin','2026-06-24 11:10:13'),(9132,6013,'created','cancelled',NULL,'booking status changed','2026-06-24 11:10:31');
/*!40000 ALTER TABLE `booking_status_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checkin_assignment`
--

DROP TABLE IF EXISTS `checkin_assignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `checkin_assignment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `yudingbianhao` varchar(200) DEFAULT NULL COMMENT '预定编号',
  `jiudianmingcheng` varchar(200) NOT NULL COMMENT '酒店名称',
  `fangjianleixing` varchar(200) NOT NULL COMMENT '房间类型',
  `shuliang` float DEFAULT NULL COMMENT '数量',
  `kefangtupian` varchar(200) DEFAULT NULL COMMENT '客房图片',
  `customerming` varchar(200) DEFAULT NULL COMMENT 'username',
  `xingming` varchar(200) DEFAULT NULL COMMENT '姓名',
  `shoujihao` varchar(200) DEFAULT NULL COMMENT 'mobile phone',
  `fangjianhao` varchar(200) DEFAULT NULL COMMENT 'room number',
  `crossuserid` bigint DEFAULT NULL COMMENT '跨表用户id',
  `crossrefid` bigint DEFAULT NULL COMMENT '跨表主键id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='入住安排';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checkin_assignment`
--

LOCK TABLES `checkin_assignment` WRITE;
/*!40000 ALTER TABLE `checkin_assignment` DISABLE KEYS */;
INSERT INTO `checkin_assignment` VALUES (71,'2026-04-28 16:20:37','预定编号1','酒店名称1','房间类型1',1,'upload/checkin_assignment_kefangtupian1.jpg','customer','姓名1','mobile','room_no',1,1),(72,'2026-04-28 16:20:37','预定编号2','酒店名称2','房间类型2',2,'upload/checkin_assignment_kefangtupian2.jpg','customer','姓名2','mobile','room_no',2,2),(73,'2026-04-28 16:20:37','预定编号3','酒店名称3','房间类型3',3,'upload/checkin_assignment_kefangtupian3.jpg','customer','姓名3','mobile','room_no',3,3),(74,'2026-04-28 16:20:37','预定编号4','酒店名称4','房间类型4',4,'upload/checkin_assignment_kefangtupian4.jpg','customer','姓名4','mobile','room_no',4,4),(75,'2026-04-28 16:20:37','预定编号5','酒店名称5','房间类型5',5,'upload/checkin_assignment_kefangtupian5.jpg','customer','姓名5','mobile','room_no',5,5),(76,'2026-04-28 16:20:37','预定编号6','酒店名称6','房间类型6',6,'upload/checkin_assignment_kefangtupian6.jpg','customer','姓名6','mobile','room_no',6,6),(77,'2026-04-28 17:28:45','ASSIGN202604280077','ShangriLa Hotel','DeluxeSuite',2,'upload/1649006659141.jpg','user7','HuYue','13612512514','R0701,R0705',4007,6007);
/*!40000 ALTER TABLE `checkin_assignment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checkin_guest`
--

DROP TABLE IF EXISTS `checkin_guest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `checkin_guest` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `checkin_id` bigint NOT NULL COMMENT 'checkin record id',
  `guest_name` varchar(100) NOT NULL COMMENT 'guest name',
  `id_card_no` varchar(30) DEFAULT NULL COMMENT 'id card number',
  `phone` varchar(30) DEFAULT NULL COMMENT 'phone number',
  `is_primary` tinyint NOT NULL DEFAULT '0' COMMENT 'primary guest flag',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  PRIMARY KEY (`id`),
  KEY `idx_checkin_guest_checkin` (`checkin_id`),
  CONSTRAINT `fk_checkin_guest_record` FOREIGN KEY (`checkin_id`) REFERENCES `checkin_record` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_checkin_guest_primary` CHECK ((`is_primary` in (0,1)))
) ENGINE=InnoDB AUTO_INCREMENT=9406 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='checkin guest detail';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checkin_guest`
--

LOCK TABLES `checkin_guest` WRITE;
/*!40000 ALTER TABLE `checkin_guest` DISABLE KEYS */;
INSERT INTO `checkin_guest` VALUES (9401,9301,'Customer1','440101199001010011','13823888881',1,'2026-05-08 10:00:00'),(9402,9302,'Customer2','440101199202020022','13823888882',1,'2026-05-08 10:00:00'),(9403,9303,'Customer1',NULL,'13823888881',1,'2026-06-10 16:50:25'),(9405,9304,'Customer1','aaaaa','13823888881',1,'2026-06-24 11:10:13');
/*!40000 ALTER TABLE `checkin_guest` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_checkin_guest_before_insert_validate` BEFORE INSERT ON `checkin_guest` FOR EACH ROW BEGIN
    IF TRIM(COALESCE(NEW.guest_name,''))='' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='checkin guest name cannot be empty';
    END IF;
    IF NEW.is_primary NOT IN (0,1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='checkin guest primary flag must be 0 or 1';
    END IF;
    IF NEW.is_primary=1 AND EXISTS(SELECT 1 FROM `checkin_guest` WHERE checkin_id=NEW.checkin_id AND is_primary=1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='only one primary checkin guest is allowed for each checkin record';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_checkin_guest_before_update_validate` BEFORE UPDATE ON `checkin_guest` FOR EACH ROW BEGIN
    IF TRIM(COALESCE(NEW.guest_name,''))='' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='checkin guest name cannot be empty';
    END IF;
    IF NEW.is_primary NOT IN (0,1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='checkin guest primary flag must be 0 or 1';
    END IF;
    IF NEW.is_primary=1 AND EXISTS(SELECT 1 FROM `checkin_guest` WHERE checkin_id=NEW.checkin_id AND is_primary=1 AND id<>OLD.id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='only one primary checkin guest is allowed for each checkin record';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `checkin_record`
--

DROP TABLE IF EXISTS `checkin_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `checkin_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `booking_id` bigint DEFAULT NULL COMMENT 'booking order id',
  `room_id` bigint NOT NULL COMMENT 'room instance id',
  `customer_id` bigint DEFAULT NULL COMMENT 'customer id',
  `employee_id` bigint DEFAULT NULL COMMENT 'employee id',
  `checkin_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'checkin time',
  `checkout_time` datetime DEFAULT NULL COMMENT 'checkout time',
  `status` varchar(30) NOT NULL DEFAULT 'checked_in' COMMENT 'checked_in, checked_out, cancelled',
  `remark` varchar(500) DEFAULT NULL COMMENT 'remark',
  PRIMARY KEY (`id`),
  KEY `idx_checkin_booking` (`booking_id`),
  KEY `idx_checkin_room` (`room_id`),
  KEY `idx_checkin_customer` (`customer_id`),
  KEY `fk_checkin_record_employee` (`employee_id`),
  CONSTRAINT `fk_checkin_record_booking` FOREIGN KEY (`booking_id`) REFERENCES `booking_order` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_checkin_record_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_checkin_record_employee` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_checkin_record_room` FOREIGN KEY (`room_id`) REFERENCES `room_instance` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_checkin_record_status` CHECK ((`status` in (_gbk'checked_in',_gbk'checked_out',_gbk'cancelled'))),
  CONSTRAINT `chk_checkin_record_time_range` CHECK (((`checkout_time` is null) or (`checkout_time` >= `checkin_time`)))
) ENGINE=InnoDB AUTO_INCREMENT=9305 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='checkin master record';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checkin_record`
--

LOCK TABLES `checkin_record` WRITE;
/*!40000 ALTER TABLE `checkin_record` DISABLE KEYS */;
INSERT INTO `checkin_record` VALUES (9301,6008,8014,4001,5001,'2026-05-08 10:00:00','2026-06-10 16:50:26','checked_out','confirm checkin'),(9302,6009,8009,4002,5002,'2026-05-08 10:00:00','2026-06-10 18:28:08','checked_out','confirm checkin'),(9303,6008,8014,4001,5001,'2026-06-10 16:50:25','2026-06-24 11:57:29','checked_out','confirm checkin'),(9304,6012,8007,4001,5001,'2026-06-24 11:10:13',NULL,'checked_in','confirm checkin');
/*!40000 ALTER TABLE `checkin_record` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_checkin_after_insert_room_occupied` AFTER INSERT ON `checkin_record` FOR EACH ROW BEGIN
    DECLARE v_old_status varchar(30);
    SELECT status INTO v_old_status FROM `room_instance` WHERE id=NEW.room_id;
    UPDATE `room_instance` SET status='occupied',updated_at=NOW() WHERE id=NEW.room_id;
    INSERT INTO `room_status_log`(room_id,old_status,new_status,source_type,source_id,operator_id,remark)
    VALUES(NEW.room_id,v_old_status,'occupied','checkin_record',NEW.id,NEW.employee_id,'guest checked in');
    IF NEW.booking_id IS NOT NULL THEN
        UPDATE `booking_room` SET room_status='checked_in' WHERE booking_id=NEW.booking_id AND room_id=NEW.room_id;
        INSERT INTO `booking_status_log`(booking_id,old_status,new_status,operator_id,remark)
        VALUES(NEW.booking_id,NULL,'checked_in',NEW.employee_id,'checkin record inserted');
    END IF;
    INSERT INTO `operation_log`(operator_type,operator_id,business_type,business_id,action,remark)
    VALUES('employee',NEW.employee_id,'checkin_record',NEW.id,'checkin_inserted','room occupied');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_checkin_after_update_room_available` AFTER UPDATE ON `checkin_record` FOR EACH ROW BEGIN
    DECLARE v_old_status varchar(30);
    IF OLD.status<>NEW.status AND NEW.status='checked_out' THEN
        SELECT status INTO v_old_status FROM `room_instance` WHERE id=NEW.room_id;
        UPDATE `room_instance` SET status='cleaning',updated_at=NOW() WHERE id=NEW.room_id;
        INSERT INTO `room_status_log`(room_id,old_status,new_status,source_type,source_id,operator_id,remark)
        VALUES(NEW.room_id,v_old_status,'cleaning','checkin_record',NEW.id,NEW.employee_id,'guest checked out and room waits for cleaning');
        IF NEW.booking_id IS NOT NULL THEN
            UPDATE `booking_order` SET booking_status='completed' WHERE id=NEW.booking_id;
            UPDATE `booking_room` SET room_status='completed' WHERE booking_id=NEW.booking_id AND room_id=NEW.room_id;
        END IF;
        INSERT INTO `housekeeping_task`(room_id,checkin_id,assigned_employee_id,task_type,task_status,scheduled_time,remark)
        VALUES(NEW.room_id,NEW.id,NEW.employee_id,'checkout_cleaning','assigned',NOW(),'created by checkout trigger');
        INSERT INTO `operation_log`(operator_type,operator_id,business_type,business_id,action,remark)
        VALUES('employee',NEW.employee_id,'checkin_record',NEW.id,'checkout_updated','room cleaning');
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `customerming` varchar(200) NOT NULL COMMENT 'username',
  `xingming` varchar(200) NOT NULL COMMENT '姓名',
  `mima` varchar(200) NOT NULL COMMENT '密码',
  `xingbie` varchar(200) DEFAULT NULL COMMENT '性别',
  `nianling` int DEFAULT NULL COMMENT '年龄',
  `shoujihao` varchar(200) DEFAULT NULL COMMENT 'mobile phone',
  PRIMARY KEY (`id`),
  UNIQUE KEY `customerming` (`customerming`),
  CONSTRAINT `chk_customer_age_range` CHECK (((`nianling` is null) or (`nianling` between 0 and 120)))
) ENGINE=InnoDB AUTO_INCREMENT=4008 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (4001,'2026-04-28 09:20:00','user1','Customer1','123456','unknown',21,'13823888881'),(4002,'2026-04-28 09:21:00','user2','Customer2','123456','unknown',22,'13823888882'),(4003,'2026-04-28 09:22:00','user3','Customer3','123456','unknown',23,'13823888883'),(4004,'2026-04-28 09:23:00','user4','Customer4','123456','unknown',24,'13823888884'),(4005,'2026-04-28 09:24:00','user5','Customer5','123456','unknown',25,'13823888885'),(4006,'2026-04-28 09:25:00','user6','Customer6','123456','unknown',26,'13823888886'),(4007,'2026-04-28 09:26:00','user7','HuYue','111','unknown',36,'13612512514');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `employeegonghao` varchar(200) DEFAULT NULL COMMENT '员工工号',
  `employeexingming` varchar(200) DEFAULT NULL COMMENT '员工姓名',
  `mima` varchar(200) DEFAULT NULL COMMENT '密码',
  `xingbie` varchar(200) DEFAULT NULL COMMENT '性别',
  `lianxidianhua` varchar(200) DEFAULT NULL COMMENT '联系电话',
  `touxiang` varchar(200) DEFAULT NULL COMMENT '头像',
  `ruzhishijian` date DEFAULT NULL COMMENT '入职时间',
  `zhiwei` varchar(200) DEFAULT NULL COMMENT '职位',
  PRIMARY KEY (`id`),
  UNIQUE KEY `employeegonghao` (`employeegonghao`)
) ENGINE=InnoDB AUTO_INCREMENT=5008 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='员工';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (5001,'2026-04-28 09:30:00','EMP001','Employee1','123456','unknown','13823888881','upload/employee_touxiang1.jpg','2026-04-29','Position1'),(5002,'2026-04-28 09:31:00','EMP002','Employee2','123456','unknown','13823888882','upload/employee_touxiang2.jpg','2026-04-29','Position2'),(5003,'2026-04-28 09:32:00','EMP003','Employee3','123456','unknown','13823888883','upload/employee_touxiang3.jpg','2026-04-29','Position3'),(5004,'2026-04-28 09:33:00','EMP004','Employee4','123456','unknown','13823888884','upload/employee_touxiang4.jpg','2026-04-29','Position4'),(5005,'2026-04-28 09:34:00','EMP005','Employee5','123456','unknown','13823888885','upload/employee_touxiang5.jpg','2026-04-29','Position5'),(5006,'2026-04-28 09:35:00','EMP006','Employee6','123456','unknown','13823888886','upload/employee_touxiang6.jpg','2026-04-29','Position6'),(5007,'2026-04-28 09:36:00','EMP007','HuYue','222','unknown','13612514714','upload/1649006446364.jpg','2026-04-28','FrontDesk');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_performance`
--

DROP TABLE IF EXISTS `employee_performance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_performance` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `employee_id` bigint NOT NULL COMMENT 'employee id',
  `assessor_id` bigint DEFAULT NULL COMMENT 'assessor employee id',
  `period_start` date NOT NULL COMMENT 'assessment period start',
  `period_end` date NOT NULL COMMENT 'assessment period end',
  `checkin_count` int NOT NULL DEFAULT '0' COMMENT 'handled checkin count',
  `bill_count` int NOT NULL DEFAULT '0' COMMENT 'generated bill count',
  `payment_count` int NOT NULL DEFAULT '0' COMMENT 'handled payment count',
  `cleaning_count` int NOT NULL DEFAULT '0' COMMENT 'completed cleaning task count',
  `maintenance_count` int NOT NULL DEFAULT '0' COMMENT 'completed maintenance count',
  `operation_count` int NOT NULL DEFAULT '0' COMMENT 'operation log count',
  `manager_score` decimal(5,2) NOT NULL DEFAULT '0.00' COMMENT 'manager score',
  `total_score` decimal(6,2) NOT NULL DEFAULT '0.00' COMMENT 'calculated total score',
  `grade` varchar(20) NOT NULL DEFAULT 'C' COMMENT 'A, B, C, D',
  `remark` varchar(500) DEFAULT NULL COMMENT 'remark',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_employee_performance_period` (`employee_id`,`period_start`,`period_end`),
  KEY `idx_employee_performance_assessor` (`assessor_id`),
  CONSTRAINT `fk_employee_performance_assessor` FOREIGN KEY (`assessor_id`) REFERENCES `employee` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_employee_performance_employee` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_employee_performance_bill_count` CHECK ((`bill_count` >= 0)),
  CONSTRAINT `chk_employee_performance_checkin_count` CHECK ((`checkin_count` >= 0)),
  CONSTRAINT `chk_employee_performance_cleaning_count` CHECK ((`cleaning_count` >= 0)),
  CONSTRAINT `chk_employee_performance_grade` CHECK ((`grade` in (_gbk'A',_gbk'B',_gbk'C',_gbk'D'))),
  CONSTRAINT `chk_employee_performance_maintenance_count` CHECK ((`maintenance_count` >= 0)),
  CONSTRAINT `chk_employee_performance_manager_score` CHECK ((`manager_score` >= 0)),
  CONSTRAINT `chk_employee_performance_operation_count` CHECK ((`operation_count` >= 0)),
  CONSTRAINT `chk_employee_performance_payment_count` CHECK ((`payment_count` >= 0)),
  CONSTRAINT `chk_employee_performance_period_range` CHECK ((`period_end` >= `period_start`)),
  CONSTRAINT `chk_employee_performance_total_score` CHECK ((`total_score` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=9909 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='employee assessment result';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_performance`
--

LOCK TABLES `employee_performance` WRITE;
/*!40000 ALTER TABLE `employee_performance` DISABLE KEYS */;
INSERT INTO `employee_performance` VALUES (9901,5001,5002,'2026-05-01','2026-05-08',1,1,1,0,0,5,15.00,32.00,'D','generated by procedure','2026-05-08 10:00:00'),(9902,5002,5001,'2026-05-01','2026-05-08',1,0,0,0,0,2,12.00,19.00,'D','generated by procedure','2026-05-08 10:00:00'),(9903,5001,5002,'2026-05-01','2026-06-24',2,2,1,0,0,8,10.00,39.00,'D','generated by procedure','2026-06-24 10:40:44'),(9905,5001,NULL,'2026-06-24','2026-06-24',0,0,0,0,0,0,0.00,0.00,'D','generated by procedure','2026-06-24 10:41:05'),(9906,5001,5002,'2026-04-25','2026-06-24',3,2,1,0,0,13,10.00,49.00,'D','generated by procedure','2026-06-24 11:56:56');
/*!40000 ALTER TABLE `employee_performance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorite`
--

DROP TABLE IF EXISTS `favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorite` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `userid` bigint NOT NULL COMMENT '用户id',
  `refid` bigint DEFAULT NULL COMMENT '收藏id',
  `tablename` varchar(200) DEFAULT NULL COMMENT '表名',
  `name` varchar(200) NOT NULL COMMENT '收藏名称',
  `picture` varchar(200) NOT NULL COMMENT '收藏图片',
  `type` varchar(200) DEFAULT '1' COMMENT 'favorite type',
  `inteltype` varchar(200) DEFAULT NULL COMMENT '推荐类型',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_favorite_user_ref` (`userid`,`tablename`,`refid`),
  KEY `idx_favorite_user` (`userid`),
  CONSTRAINT `fk_favorite_customer` FOREIGN KEY (`userid`) REFERENCES `customer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_favorite_table_name` CHECK ((`tablename` in (_gbk'room_catalog',_gbk'hotel_profile')))
) ENGINE=InnoDB AUTO_INCREMENT=1305 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='legacy table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite`
--

LOCK TABLES `favorite` WRITE;
/*!40000 ALTER TABLE `favorite` DISABLE KEYS */;
INSERT INTO `favorite` VALUES (1301,'2026-05-01 09:00:00',4007,3006,'room_catalog','RoomName6','upload/room_catalog_kefangtupian6.jpg','1',NULL),(1302,'2026-05-01 09:05:00',4007,3007,'room_catalog','river view room','upload/1649006659141.jpg','1',NULL),(1303,'2026-05-01 09:10:00',4001,1001,'hotel_profile','ShangriLa Hotel','upload/hotel_profile_jiudiantupian1.jpg','1',NULL),(1304,'2026-05-01 09:15:00',4001,3002,'room_catalog','RoomName2','upload/room_catalog_kefangtupian2.jpg','1',NULL);
/*!40000 ALTER TABLE `favorite` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_favorite_before_insert_validate` BEFORE INSERT ON `favorite` FOR EACH ROW BEGIN
    IF NEW.tablename NOT IN ('room_catalog','hotel_profile') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='favorite target table is not allowed';
    END IF;
    IF NEW.refid IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='favorite target id cannot be null';
    END IF;
    IF NEW.tablename='room_catalog' AND NOT EXISTS(SELECT 1 FROM `room_catalog` WHERE id=NEW.refid) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='favorite room target does not exist';
    END IF;
    IF NEW.tablename='hotel_profile' AND NOT EXISTS(SELECT 1 FROM `hotel_profile` WHERE id=NEW.refid) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='favorite hotel target does not exist';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_favorite_before_update_validate` BEFORE UPDATE ON `favorite` FOR EACH ROW BEGIN
    IF NEW.tablename NOT IN ('room_catalog','hotel_profile') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='favorite target table is not allowed';
    END IF;
    IF NEW.refid IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='favorite target id cannot be null';
    END IF;
    IF NEW.tablename='room_catalog' AND NOT EXISTS(SELECT 1 FROM `room_catalog` WHERE id=NEW.refid) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='favorite room target does not exist';
    END IF;
    IF NEW.tablename='hotel_profile' AND NOT EXISTS(SELECT 1 FROM `hotel_profile` WHERE id=NEW.refid) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='favorite hotel target does not exist';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `hotel_profile`
--

DROP TABLE IF EXISTS `hotel_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel_profile` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `jiudianmingcheng` varchar(200) NOT NULL COMMENT '酒店名称',
  `leibie` varchar(200) NOT NULL COMMENT '类别',
  `xingji` varchar(200) NOT NULL COMMENT '星级',
  `jiudiantupian` varchar(200) DEFAULT NULL COMMENT '酒店图片',
  `jiudiandizhi` varchar(200) DEFAULT NULL COMMENT '酒店地址',
  `fuwurexian` varchar(200) DEFAULT NULL COMMENT '服务热线',
  `jiudianjieshao` longtext COMMENT '酒店介绍',
  `review_count` int NOT NULL DEFAULT '0' COMMENT 'review count',
  `avg_score` decimal(4,2) NOT NULL DEFAULT '0.00' COMMENT 'average score',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1002 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='legacy table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotel_profile`
--

LOCK TABLES `hotel_profile` WRITE;
/*!40000 ALTER TABLE `hotel_profile` DISABLE KEYS */;
INSERT INTO `hotel_profile` VALUES (1001,'2026-04-28 09:00:00','ShangriLa Hotel','Business Hotel','Four Star','upload/hotel_profile_jiudiantupian1.jpg','Shenzhen Nanshan Avenue 1001','13612514748','<p>Hotel profile used for database course design demo.</p>',8,5.00);
/*!40000 ALTER TABLE `hotel_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hotel_review`
--

DROP TABLE IF EXISTS `hotel_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel_review` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `refid` bigint NOT NULL COMMENT '关联表id',
  `userid` bigint NOT NULL COMMENT '用户id',
  `nickname` varchar(200) DEFAULT NULL COMMENT 'username',
  `content` longtext NOT NULL COMMENT '评论内容',
  `reply` longtext COMMENT '回复内容',
  `score` tinyint NOT NULL DEFAULT '5' COMMENT 'score from 1 to 5',
  PRIMARY KEY (`id`),
  KEY `idx_hotel_review_ref` (`refid`),
  KEY `idx_hotel_review_user` (`userid`),
  CONSTRAINT `fk_hotel_review_customer` FOREIGN KEY (`userid`) REFERENCES `customer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_hotel_review_hotel` FOREIGN KEY (`refid`) REFERENCES `hotel_profile` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_hotel_review_score_range` CHECK ((`score` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=1109 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='酒店简介评论表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotel_review`
--

LOCK TABLES `hotel_review` WRITE;
/*!40000 ALTER TABLE `hotel_review` DISABLE KEYS */;
INSERT INTO `hotel_review` VALUES (1101,'2026-05-01 12:00:00',1001,4001,'user1','hotel review 1','reply 1',5),(1102,'2026-05-01 12:05:00',1001,4002,'user2','hotel review 2','reply 2',5),(1103,'2026-05-01 12:10:00',1001,4003,'user3','hotel review 3','reply 3',5),(1104,'2026-05-01 12:15:00',1001,4004,'user4','hotel review 4','reply 4',5),(1105,'2026-05-01 12:20:00',1001,4005,'user5','hotel review 5','reply 5',5),(1106,'2026-05-01 12:25:00',1001,4006,'user6','hotel review 6','reply 6',5),(1107,'2026-05-01 12:30:00',1001,4007,'user7','additional hotel review',NULL,5),(1108,'2026-05-27 03:57:08',1001,4001,'user1','yes！！！',NULL,5);
/*!40000 ALTER TABLE `hotel_review` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_hotel_review_before_insert_validate` BEFORE INSERT ON `hotel_review` FOR EACH ROW BEGIN
    IF NEW.score < 1 OR NEW.score > 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='hotel review score must be between 1 and 5';
    END IF;
    IF TRIM(COALESCE(NEW.content,''))='' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='hotel review content cannot be empty';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_hotel_review_after_insert_update_score` AFTER INSERT ON `hotel_review` FOR EACH ROW BEGIN
    DECLARE v_review_count int DEFAULT 0;
    DECLARE v_avg_score decimal(4,2) DEFAULT 0.00;
    SELECT COUNT(*),ROUND(AVG(score),2) INTO v_review_count,v_avg_score FROM `hotel_review` WHERE refid=NEW.refid;
    UPDATE `hotel_profile` SET review_count=v_review_count,avg_score=COALESCE(v_avg_score,0.00) WHERE id=NEW.refid;
    INSERT INTO `operation_log`(operator_type,operator_id,business_type,business_id,action,remark)
    VALUES('customer',NEW.userid,'hotel_review',NEW.id,'hotel_review_inserted',CONCAT('score=',NEW.score));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `housekeeping_task`
--

DROP TABLE IF EXISTS `housekeeping_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `housekeeping_task` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `room_id` bigint NOT NULL COMMENT 'room instance id',
  `checkin_id` bigint DEFAULT NULL COMMENT 'checkout source checkin id',
  `assigned_employee_id` bigint DEFAULT NULL COMMENT 'assigned housekeeping employee id',
  `task_type` varchar(30) NOT NULL DEFAULT 'checkout_cleaning' COMMENT 'daily_cleaning, checkout_cleaning, deep_cleaning',
  `task_status` varchar(30) NOT NULL DEFAULT 'pending' COMMENT 'pending, assigned, in_progress, completed, cancelled',
  `scheduled_time` datetime DEFAULT NULL COMMENT 'scheduled time',
  `completed_time` datetime DEFAULT NULL COMMENT 'completed time',
  `remark` varchar(500) DEFAULT NULL COMMENT 'remark',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'updated time',
  PRIMARY KEY (`id`),
  KEY `idx_housekeeping_room_status` (`room_id`,`task_status`),
  KEY `idx_housekeeping_employee` (`assigned_employee_id`),
  KEY `fk_housekeeping_task_checkin` (`checkin_id`),
  CONSTRAINT `fk_housekeeping_task_checkin` FOREIGN KEY (`checkin_id`) REFERENCES `checkin_record` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_housekeeping_task_employee` FOREIGN KEY (`assigned_employee_id`) REFERENCES `employee` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_housekeeping_task_room` FOREIGN KEY (`room_id`) REFERENCES `room_instance` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_housekeeping_task_status` CHECK ((`task_status` in (_gbk'pending',_gbk'assigned',_gbk'in_progress',_gbk'completed',_gbk'cancelled'))),
  CONSTRAINT `chk_housekeeping_task_time_range` CHECK (((`completed_time` is null) or (`scheduled_time` is null) or (`completed_time` >= `scheduled_time`))),
  CONSTRAINT `chk_housekeeping_task_type` CHECK ((`task_type` in (_gbk'daily_cleaning',_gbk'checkout_cleaning',_gbk'deep_cleaning',_gbk'maintenance_cleaning')))
) ENGINE=InnoDB AUTO_INCREMENT=9705 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='room housekeeping task';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `housekeeping_task`
--

LOCK TABLES `housekeeping_task` WRITE;
/*!40000 ALTER TABLE `housekeeping_task` DISABLE KEYS */;
INSERT INTO `housekeeping_task` VALUES (9701,8003,NULL,5001,'daily_cleaning','assigned','2026-05-07 09:20:00',NULL,'sample housekeeping task','2026-05-07 09:20:00','2026-05-07 09:20:00'),(9702,8014,9301,5001,'checkout_cleaning','assigned','2026-05-08 10:00:00',NULL,'created by checkout trigger','2026-05-08 10:00:00','2026-05-08 10:00:00'),(9703,8009,9302,5002,'checkout_cleaning','assigned','2026-06-10 18:28:08',NULL,'created by checkout trigger','2026-06-10 18:28:08','2026-06-10 18:28:08'),(9704,8014,9303,5001,'checkout_cleaning','assigned','2026-06-24 11:57:29',NULL,'created by checkout trigger','2026-06-24 11:57:29','2026-06-24 11:57:29');
/*!40000 ALTER TABLE `housekeeping_task` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_housekeeping_after_update_release_room` AFTER UPDATE ON `housekeeping_task` FOR EACH ROW BEGIN
    DECLARE v_old_status varchar(30);
    IF OLD.task_status<>NEW.task_status AND NEW.task_status='completed' THEN
        SELECT status INTO v_old_status FROM `room_instance` WHERE id=NEW.room_id;
        UPDATE `room_instance` SET status='available',updated_at=NOW() WHERE id=NEW.room_id;
        INSERT INTO `room_status_log`(room_id,old_status,new_status,source_type,source_id,operator_id,remark)
        VALUES(NEW.room_id,v_old_status,'available','housekeeping_task',NEW.id,NEW.assigned_employee_id,'housekeeping completed and room released');
        INSERT INTO `operation_log`(operator_type,operator_id,business_type,business_id,action,remark)
        VALUES('employee',NEW.assigned_employee_id,'housekeeping_task',NEW.id,'complete_housekeeping','room available');
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `maintenance_record`
--

DROP TABLE IF EXISTS `maintenance_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenance_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `room_id` bigint NOT NULL COMMENT 'room instance id',
  `reported_by_employee_id` bigint DEFAULT NULL COMMENT 'report employee id',
  `handled_by_employee_id` bigint DEFAULT NULL COMMENT 'handle employee id',
  `issue_desc` varchar(500) NOT NULL COMMENT 'maintenance issue description',
  `maintenance_status` varchar(30) NOT NULL DEFAULT 'reported' COMMENT 'reported, processing, completed, cancelled',
  `start_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'reported time',
  `end_time` datetime DEFAULT NULL COMMENT 'finished time',
  `cost_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'maintenance cost',
  `remark` varchar(500) DEFAULT NULL COMMENT 'remark',
  PRIMARY KEY (`id`),
  KEY `idx_maintenance_room_status` (`room_id`,`maintenance_status`),
  KEY `idx_maintenance_reporter` (`reported_by_employee_id`),
  KEY `idx_maintenance_handler` (`handled_by_employee_id`),
  CONSTRAINT `fk_maintenance_record_handler` FOREIGN KEY (`handled_by_employee_id`) REFERENCES `employee` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_maintenance_record_reporter` FOREIGN KEY (`reported_by_employee_id`) REFERENCES `employee` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_maintenance_record_room` FOREIGN KEY (`room_id`) REFERENCES `room_instance` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_maintenance_record_cost_nonnegative` CHECK ((`cost_amount` >= 0)),
  CONSTRAINT `chk_maintenance_record_status` CHECK ((`maintenance_status` in (_gbk'reported',_gbk'processing',_gbk'completed',_gbk'cancelled'))),
  CONSTRAINT `chk_maintenance_record_time_range` CHECK (((`end_time` is null) or (`end_time` >= `start_time`)))
) ENGINE=InnoDB AUTO_INCREMENT=9802 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='room maintenance record';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenance_record`
--

LOCK TABLES `maintenance_record` WRITE;
/*!40000 ALTER TABLE `maintenance_record` DISABLE KEYS */;
INSERT INTO `maintenance_record` VALUES (9801,8033,5001,5001,'sample maintenance record','processing','2026-05-07 09:25:00',NULL,0.00,'sample room maintenance flow');
/*!40000 ALTER TABLE `maintenance_record` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_maintenance_after_insert_mark_room` AFTER INSERT ON `maintenance_record` FOR EACH ROW BEGIN
    DECLARE v_old_status varchar(30);
    IF NEW.maintenance_status IN ('reported','processing') THEN
        SELECT status INTO v_old_status FROM `room_instance` WHERE id=NEW.room_id;
        UPDATE `room_instance` SET status='maintenance',updated_at=NOW() WHERE id=NEW.room_id;
        INSERT INTO `room_status_log`(room_id,old_status,new_status,source_type,source_id,operator_id,remark)
        VALUES(NEW.room_id,v_old_status,'maintenance','maintenance_record',NEW.id,NEW.reported_by_employee_id,'maintenance reported');
        INSERT INTO `operation_log`(operator_type,operator_id,business_type,business_id,action,remark)
        VALUES('employee',NEW.reported_by_employee_id,'maintenance_record',NEW.id,'maintenance_reported',NEW.issue_desc);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_maintenance_after_update_release_room` AFTER UPDATE ON `maintenance_record` FOR EACH ROW BEGIN
    DECLARE v_old_status varchar(30);
    IF OLD.maintenance_status<>NEW.maintenance_status AND NEW.maintenance_status='completed' THEN
        SELECT status INTO v_old_status FROM `room_instance` WHERE id=NEW.room_id;
        UPDATE `room_instance` SET status='cleaning',updated_at=NOW() WHERE id=NEW.room_id;
        INSERT INTO `room_status_log`(room_id,old_status,new_status,source_type,source_id,operator_id,remark)
        VALUES(NEW.room_id,v_old_status,'cleaning','maintenance_record',NEW.id,NEW.handled_by_employee_id,'maintenance completed and room waits for cleaning');
        INSERT INTO `housekeeping_task`(room_id,assigned_employee_id,task_type,task_status,scheduled_time,remark)
        VALUES(NEW.room_id,NEW.handled_by_employee_id,'maintenance_cleaning','assigned',NOW(),'created after maintenance completed');
        INSERT INTO `operation_log`(operator_type,operator_id,business_type,business_id,action,remark)
        VALUES('employee',NEW.handled_by_employee_id,'maintenance_record',NEW.id,'maintenance_completed','room cleaning');
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `notice`
--

DROP TABLE IF EXISTS `notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notice` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `title` varchar(200) NOT NULL COMMENT '标题',
  `introduction` longtext COMMENT 'introduction',
  `picture` varchar(200) NOT NULL COMMENT '图片',
  `content` longtext NOT NULL COMMENT '内容',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='酒店公告';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notice`
--

LOCK TABLES `notice` WRITE;
/*!40000 ALTER TABLE `notice` DISABLE KEYS */;
INSERT INTO `notice` VALUES (91,'2026-04-28 16:20:37','Welcome Notice','Welcome to the hotel management system.','upload/notice_picture1.jpg','<p>Welcome to the upgraded hotel management system.</p>'),(92,'2026-04-28 16:20:37','Service Notice','Please contact the front desk if you need help.','upload/notice_picture2.jpg','<p>Front desk service is available all day.</p>');
/*!40000 ALTER TABLE `notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operation_log`
--

DROP TABLE IF EXISTS `operation_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `operation_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `operator_type` varchar(30) NOT NULL DEFAULT 'system' COMMENT 'admin, employee, customer, system',
  `operator_id` bigint DEFAULT NULL COMMENT 'operator id',
  `business_type` varchar(50) NOT NULL COMMENT 'business type',
  `business_id` bigint DEFAULT NULL COMMENT 'business id',
  `action` varchar(100) NOT NULL COMMENT 'operation action',
  `remark` varchar(500) DEFAULT NULL COMMENT 'remark',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  PRIMARY KEY (`id`),
  KEY `idx_operation_business` (`business_type`,`business_id`),
  KEY `idx_operation_operator` (`operator_type`,`operator_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9313 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='operation audit log';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operation_log`
--

LOCK TABLES `operation_log` WRITE;
/*!40000 ALTER TABLE `operation_log` DISABLE KEYS */;
INSERT INTO `operation_log` VALUES (9201,'system',NULL,'room_instance',8007,'init_room','init room R0101','2026-05-07 09:15:00'),(9202,'system',NULL,'room_instance',8014,'init_room','init room R0102','2026-05-07 09:15:00'),(9203,'system',NULL,'room_instance',8020,'init_room','init room R0103','2026-05-07 09:15:00'),(9204,'system',NULL,'room_instance',8006,'init_room','init room R0201','2026-05-07 09:15:00'),(9205,'system',NULL,'room_instance',8013,'init_room','init room R0202','2026-05-07 09:15:00'),(9206,'system',NULL,'room_instance',8005,'init_room','init room R0301','2026-05-07 09:15:00'),(9207,'system',NULL,'room_instance',8012,'init_room','init room R0302','2026-05-07 09:15:00'),(9208,'system',NULL,'room_instance',8019,'init_room','init room R0303','2026-05-07 09:15:00'),(9209,'system',NULL,'room_instance',8004,'init_room','init room R0401','2026-05-07 09:15:00'),(9210,'system',NULL,'room_instance',8011,'init_room','init room R0402','2026-05-07 09:15:00'),(9211,'system',NULL,'room_instance',8018,'init_room','init room R0403','2026-05-07 09:15:00'),(9212,'system',NULL,'room_instance',8024,'init_room','init room R0404','2026-05-07 09:15:00'),(9213,'system',NULL,'room_instance',8003,'init_room','init room R0501','2026-05-07 09:15:00'),(9214,'system',NULL,'room_instance',8010,'init_room','init room R0502','2026-05-07 09:15:00'),(9215,'system',NULL,'room_instance',8017,'init_room','init room R0503','2026-05-07 09:15:00'),(9216,'system',NULL,'room_instance',8023,'init_room','init room R0504','2026-05-07 09:15:00'),(9217,'system',NULL,'room_instance',8027,'init_room','init room R0505','2026-05-07 09:15:00'),(9218,'system',NULL,'room_instance',8002,'init_room','init room R0601','2026-05-07 09:15:00'),(9219,'system',NULL,'room_instance',8009,'init_room','init room R0602','2026-05-07 09:15:00'),(9220,'system',NULL,'room_instance',8016,'init_room','init room R0603','2026-05-07 09:15:00'),(9221,'system',NULL,'room_instance',8022,'init_room','init room R0604','2026-05-07 09:15:00'),(9222,'system',NULL,'room_instance',8026,'init_room','init room R0605','2026-05-07 09:15:00'),(9223,'system',NULL,'room_instance',8029,'init_room','init room R0606','2026-05-07 09:15:00'),(9224,'system',NULL,'room_instance',8001,'init_room','init room R0701','2026-05-07 09:15:00'),(9225,'system',NULL,'room_instance',8008,'init_room','init room R0702','2026-05-07 09:15:00'),(9226,'system',NULL,'room_instance',8015,'init_room','init room R0703','2026-05-07 09:15:00'),(9227,'system',NULL,'room_instance',8021,'init_room','init room R0704','2026-05-07 09:15:00'),(9228,'system',NULL,'room_instance',8025,'init_room','init room R0705','2026-05-07 09:15:00'),(9229,'system',NULL,'room_instance',8028,'init_room','init room R0706','2026-05-07 09:15:00'),(9230,'system',NULL,'room_instance',8030,'init_room','init room R0707','2026-05-07 09:15:00'),(9231,'system',NULL,'room_instance',8031,'init_room','init room R0708','2026-05-07 09:15:00'),(9232,'system',NULL,'room_instance',8032,'init_room','init room R0709','2026-05-07 09:15:00'),(9233,'system',NULL,'room_instance',8033,'init_room','init room R0710','2026-05-07 09:15:00'),(9264,'system',NULL,'booking_order',6008,'after_insert_booking','BK202605080008','2026-05-08 10:00:00'),(9265,'system',NULL,'booking_order',6009,'after_insert_booking','BK202605080009','2026-05-08 10:00:00'),(9266,'employee',5001,'checkin_record',9301,'checkin_inserted','room occupied','2026-05-08 10:00:00'),(9267,'employee',5001,'checkin_record',9301,'confirm_checkin','booking 6008','2026-05-08 10:00:00'),(9268,'employee',5001,'checkin_record',9301,'checkout_updated','room cleaning','2026-05-08 10:00:00'),(9269,'employee',5001,'bill',9501,'generate_checkout_bill','checkin 9301','2026-05-08 10:00:00'),(9270,'system',NULL,'payment_record',9601,'payment_inserted','PAY202605081000009501','2026-05-08 10:00:00'),(9271,'employee',5001,'payment_record',9601,'pay_bill','PAY202605081000009501','2026-05-08 10:00:00'),(9272,'employee',5002,'checkin_record',9302,'checkin_inserted','room occupied','2026-05-08 10:00:00'),(9273,'employee',5002,'checkin_record',9302,'confirm_checkin','booking 6009','2026-05-08 10:00:00'),(9274,'system',NULL,'booking_order',6001,'expire_unpaid_booking','3 minutes unpaid auto cancel: BK202604290001','2026-05-23 17:56:37'),(9275,'system',NULL,'booking_order',6002,'expire_unpaid_booking','3 minutes unpaid auto cancel: BK202604290002','2026-05-23 17:56:37'),(9276,'system',NULL,'booking_order',6002,'expire_unpaid_booking','3 minutes unpaid auto cancel: BK202604290002','2026-05-23 17:56:37'),(9277,'system',NULL,'booking_order',6003,'expire_unpaid_booking','3 minutes unpaid auto cancel: BK202604290003','2026-05-23 17:56:37'),(9278,'system',NULL,'booking_order',6003,'expire_unpaid_booking','3 minutes unpaid auto cancel: BK202604290003','2026-05-23 17:56:37'),(9279,'system',NULL,'booking_order',6004,'expire_unpaid_booking','3 minutes unpaid auto cancel: BK202604290004','2026-05-23 17:56:37'),(9280,'system',NULL,'booking_order',6004,'expire_unpaid_booking','3 minutes unpaid auto cancel: BK202604290004','2026-05-23 17:56:37'),(9281,'system',NULL,'booking_order',6005,'expire_unpaid_booking','3 minutes unpaid auto cancel: BK202604290005','2026-05-23 17:56:37'),(9282,'system',NULL,'booking_order',6005,'expire_unpaid_booking','3 minutes unpaid auto cancel: BK202604290005','2026-05-23 17:56:37'),(9283,'system',NULL,'booking_order',6006,'expire_unpaid_booking','3 minutes unpaid auto cancel: BK202604290006','2026-05-23 17:56:37'),(9284,'system',NULL,'booking_order',6006,'expire_unpaid_booking','3 minutes unpaid auto cancel: BK202604290006','2026-05-23 17:56:37'),(9285,'customer',4001,'hotel_review',1108,'hotel_review_inserted','score=5','2026-05-27 11:57:08'),(9286,'system',NULL,'booking_order',6010,'after_insert_booking','BK202605270001','2026-05-27 11:58:51'),(9287,'customer',4001,'booking_order',6010,'create_booking','BK202605270001','2026-05-27 11:58:51'),(9288,'customer',4001,'booking_order',6010,'update_booking_guests','BK202605270001','2026-05-27 11:59:47'),(9289,'system',NULL,'payment_record',9602,'payment_inserted','PAY202605271159579502','2026-05-27 11:59:57'),(9290,'customer',4001,'booking_order',6010,'pay_booking','PAY202605271159579502','2026-05-27 11:59:57'),(9291,'employee',5001,'checkin_record',9303,'checkin_inserted','room occupied','2026-06-10 16:50:25'),(9292,'employee',5001,'checkin_record',9303,'confirm_checkin','booking 6008','2026-06-10 16:50:26'),(9293,'employee',5001,'bill',9503,'generate_checkout_bill','checkin 9301','2026-06-10 16:50:26'),(9294,'employee',5002,'checkin_record',9302,'checkout_updated','room cleaning','2026-06-10 18:28:08'),(9295,'system',NULL,'booking_order',6011,'after_insert_booking','BK202606230001','2026-06-23 22:34:20'),(9296,'customer',4001,'booking_order',6011,'create_booking','BK202606230001','2026-06-23 22:34:20'),(9297,'system',NULL,'payment_record',9603,'payment_inserted','PAY202606232234339504','2026-06-23 22:34:33'),(9298,'customer',4001,'booking_order',6011,'pay_booking','PAY202606232234339504','2026-06-23 22:34:33'),(9299,'system',NULL,'booking_order',6012,'after_insert_booking','BK202606240001','2026-06-24 10:19:45'),(9300,'customer',4001,'booking_order',6012,'create_booking','BK202606240001','2026-06-24 10:19:45'),(9301,'system',NULL,'payment_record',9604,'payment_inserted','PAY202606241019519505','2026-06-24 10:19:51'),(9302,'customer',4001,'booking_order',6012,'pay_booking','PAY202606241019519505','2026-06-24 10:19:51'),(9303,'employee',5001,'room_instance',NULL,'batch_update_room_status','changed rooms: 4','2026-06-24 11:04:35'),(9304,'system',NULL,'booking_order',6013,'after_insert_booking','BK202607010013','2026-06-24 11:07:13'),(9305,'customer',4001,'booking_order',6013,'create_booking','BK202607010013','2026-06-24 11:07:13'),(9306,'employee',5001,'room_instance',NULL,'batch_update_room_status','changed rooms: 0','2026-06-24 11:07:13'),(9307,'employee',5001,'checkin_record',9304,'checkin_inserted','room occupied','2026-06-24 11:10:13'),(9308,'employee',5001,'checkin_record',9304,'confirm_checkin','booking 6012','2026-06-24 11:10:13'),(9309,'system',NULL,'booking_order',6013,'expire_unpaid_booking','3 minutes unpaid auto cancel: BK202607010013','2026-06-24 11:10:31'),(9310,'employee',5001,'room_instance',NULL,'batch_update_room_status','changed rooms: 4','2026-06-24 11:25:26'),(9311,'employee',5001,'checkin_record',9303,'checkout_updated','room cleaning','2026-06-24 11:57:29'),(9312,'employee',5001,'bill',9506,'generate_checkout_bill','checkin 9303','2026-06-24 11:57:29');
/*!40000 ALTER TABLE `operation_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_record`
--

DROP TABLE IF EXISTS `payment_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `bill_id` bigint NOT NULL COMMENT 'bill id',
  `payment_no` varchar(80) NOT NULL COMMENT 'payment number',
  `pay_method` varchar(30) NOT NULL DEFAULT 'cash' COMMENT 'cash, card, alipay, wechat',
  `pay_amount` decimal(10,2) NOT NULL COMMENT 'pay amount',
  `pay_status` varchar(30) NOT NULL DEFAULT 'success' COMMENT 'success, failed, cancelled',
  `paid_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'paid time',
  `remark` varchar(500) DEFAULT NULL COMMENT 'remark',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_payment_no` (`payment_no`),
  KEY `idx_payment_bill` (`bill_id`),
  CONSTRAINT `fk_payment_record_bill` FOREIGN KEY (`bill_id`) REFERENCES `bill` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_payment_record_amount_positive` CHECK ((`pay_amount` > 0)),
  CONSTRAINT `chk_payment_record_method` CHECK ((`pay_method` in (_gbk'cash',_gbk'card',_gbk'alipay',_gbk'wechat'))),
  CONSTRAINT `chk_payment_record_status` CHECK ((`pay_status` in (_gbk'success',_gbk'failed',_gbk'cancelled')))
) ENGINE=InnoDB AUTO_INCREMENT=9605 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='payment record';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_record`
--

LOCK TABLES `payment_record` WRITE;
/*!40000 ALTER TABLE `payment_record` DISABLE KEYS */;
INSERT INTO `payment_record` VALUES (9601,9501,'PAY202605081000009501','wechat',137.00,'success','2026-05-08 10:00:00','pay by procedure'),(9602,9502,'PAY202605271159579502','wechat',6.00,'success','2026-05-27 11:59:57','customer paid booking in front'),(9603,9504,'PAY202606232234339504','wechat',666.00,'success','2026-06-23 22:34:33','customer paid booking in front'),(9604,9505,'PAY202606241019519505','alipay',122.00,'success','2026-06-24 10:19:51','customer paid booking in front');
/*!40000 ALTER TABLE `payment_record` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_payment_before_insert_validate` BEFORE INSERT ON `payment_record` FOR EACH ROW BEGIN
    DECLARE v_payable decimal(10,2) DEFAULT 0.00;
    DECLARE v_existing_paid decimal(10,2) DEFAULT 0.00;
    IF NEW.pay_amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='payment amount must be greater than zero';
    END IF;
    IF NEW.pay_method NOT IN ('cash','card','alipay','wechat') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='invalid payment method';
    END IF;
    IF NEW.pay_status NOT IN ('success','failed','cancelled') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='invalid payment status';
    END IF;
    IF NEW.pay_status='success' THEN
        SELECT payable_amount INTO v_payable FROM `bill` WHERE id=NEW.bill_id;
        SELECT COALESCE(SUM(pay_amount),0) INTO v_existing_paid FROM `payment_record` WHERE bill_id=NEW.bill_id AND pay_status='success';
        IF v_existing_paid + NEW.pay_amount > v_payable THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='payment amount exceeds payable amount';
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_payment_after_insert_update_bill` AFTER INSERT ON `payment_record` FOR EACH ROW BEGIN
    DECLARE v_payable decimal(10,2);
    DECLARE v_paid decimal(10,2);
    DECLARE v_new_status varchar(30);
    IF NEW.pay_status='success' THEN
        SELECT payable_amount,paid_amount+NEW.pay_amount INTO v_payable,v_paid FROM `bill` WHERE id=NEW.bill_id;
        IF v_paid>=v_payable THEN SET v_new_status='paid';
        ELSEIF v_paid>0 THEN SET v_new_status='partial';
        ELSE SET v_new_status='unpaid'; END IF;
        UPDATE `bill` SET paid_amount=v_paid,status=v_new_status,updated_at=NOW() WHERE id=NEW.bill_id;
        UPDATE `booking_order` bo
        JOIN `bill` b ON b.booking_id=bo.id
        SET bo.ispay=CASE WHEN v_new_status='paid' THEN 'paid' WHEN v_new_status='partial' THEN 'partial' ELSE 'unpaid' END
        WHERE b.id=NEW.bill_id;
        INSERT INTO `operation_log`(operator_type,operator_id,business_type,business_id,action,remark)
        VALUES('system',NULL,'payment_record',NEW.id,'payment_inserted',NEW.payment_no);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `price_policy`
--

DROP TABLE IF EXISTS `price_policy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `price_policy` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `room_catalog_id` bigint NOT NULL COMMENT 'room catalog id',
  `policy_name` varchar(100) NOT NULL COMMENT 'policy name',
  `start_date` date NOT NULL COMMENT 'start date',
  `end_date` date NOT NULL COMMENT 'end date',
  `price_multiplier` decimal(6,2) NOT NULL DEFAULT '1.00' COMMENT 'price multiplier',
  `priority` int NOT NULL DEFAULT '1' COMMENT 'priority',
  `enabled` tinyint NOT NULL DEFAULT '1' COMMENT 'enabled flag',
  PRIMARY KEY (`id`),
  KEY `idx_price_policy_room_date` (`room_catalog_id`,`start_date`,`end_date`),
  CONSTRAINT `fk_price_policy_catalog` FOREIGN KEY (`room_catalog_id`) REFERENCES `room_catalog` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_price_policy_date_range` CHECK ((`end_date` >= `start_date`)),
  CONSTRAINT `chk_price_policy_enabled` CHECK ((`enabled` in (0,1))),
  CONSTRAINT `chk_price_policy_multiplier_positive` CHECK ((`price_multiplier` > 0)),
  CONSTRAINT `chk_price_policy_priority_positive` CHECK ((`priority` >= 1))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='room price policy';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `price_policy`
--

LOCK TABLES `price_policy` WRITE;
/*!40000 ALTER TABLE `price_policy` DISABLE KEYS */;
INSERT INTO `price_policy` VALUES (1,3001,'Normal Price','2026-05-01','2026-12-31',1.00,1,1),(2,3002,'Normal Price','2026-05-01','2026-12-31',1.00,1,1),(3,3003,'Normal Price','2026-05-01','2026-12-31',1.00,1,1),(4,3004,'Normal Price','2026-05-01','2026-12-31',1.00,1,1),(5,3005,'Normal Price','2026-05-01','2026-12-31',1.00,1,1),(6,3006,'Normal Price','2026-05-01','2026-12-31',1.00,1,1),(7,3007,'Normal Price','2026-05-01','2026-12-31',1.00,1,1);
/*!40000 ALTER TABLE `price_policy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refund_record`
--

DROP TABLE IF EXISTS `refund_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `refund_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `payment_id` bigint NOT NULL COMMENT 'payment id',
  `refund_no` varchar(80) NOT NULL COMMENT 'refund number',
  `refund_amount` decimal(10,2) NOT NULL COMMENT 'refund amount',
  `refund_reason` varchar(500) DEFAULT NULL COMMENT 'refund reason',
  `refund_status` varchar(30) NOT NULL DEFAULT 'success' COMMENT 'success, failed, cancelled',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_refund_no` (`refund_no`),
  KEY `idx_refund_payment` (`payment_id`),
  CONSTRAINT `fk_refund_record_payment` FOREIGN KEY (`payment_id`) REFERENCES `payment_record` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_refund_record_amount_positive` CHECK ((`refund_amount` > 0)),
  CONSTRAINT `chk_refund_record_status` CHECK ((`refund_status` in (_gbk'success',_gbk'failed',_gbk'cancelled')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='refund record';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refund_record`
--

LOCK TABLES `refund_record` WRITE;
/*!40000 ALTER TABLE `refund_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `refund_record` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_refund_before_insert_validate` BEFORE INSERT ON `refund_record` FOR EACH ROW BEGIN
    DECLARE v_total_paid decimal(10,2) DEFAULT 0.00;
    DECLARE v_total_refunded decimal(10,2) DEFAULT 0.00;
    DECLARE v_bill_id bigint;
    IF NEW.refund_amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='refund amount must be greater than zero';
    END IF;
    IF NEW.refund_status NOT IN ('success','failed','cancelled') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='invalid refund status';
    END IF;
    IF NEW.refund_status='success' THEN
        SELECT bill_id INTO v_bill_id FROM `payment_record` WHERE id=NEW.payment_id;
        SELECT COALESCE(SUM(pay_amount),0) INTO v_total_paid FROM `payment_record` WHERE bill_id=v_bill_id AND pay_status='success';
        SELECT COALESCE(SUM(rr.refund_amount),0) INTO v_total_refunded
        FROM `refund_record` rr
        JOIN `payment_record` pr ON pr.id=rr.payment_id
        WHERE pr.bill_id=v_bill_id AND rr.refund_status='success';
        IF v_total_refunded + NEW.refund_amount > v_total_paid THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='refund amount exceeds total paid amount';
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_refund_after_insert_update_payment` AFTER INSERT ON `refund_record` FOR EACH ROW BEGIN
    DECLARE v_bill_id bigint;
    DECLARE v_total_refund decimal(10,2);
    DECLARE v_paid_amount decimal(10,2);
    DECLARE v_new_status varchar(30);
    IF NEW.refund_status='success' THEN
        SELECT bill_id INTO v_bill_id FROM `payment_record` WHERE id=NEW.payment_id;
        SELECT COALESCE(SUM(rr.refund_amount),0) INTO v_total_refund
        FROM `refund_record` rr JOIN `payment_record` pr ON pr.id=rr.payment_id
        WHERE pr.bill_id=v_bill_id AND rr.refund_status='success';
        SELECT paid_amount INTO v_paid_amount FROM `bill` WHERE id=v_bill_id;
        IF v_total_refund>=v_paid_amount THEN SET v_new_status='refunded'; ELSE SET v_new_status='partial'; END IF;
        UPDATE `bill` SET refund_amount=v_total_refund,status=v_new_status,updated_at=NOW() WHERE id=v_bill_id;
        UPDATE `booking_order` bo
        JOIN `bill` b ON b.booking_id=bo.id
        SET bo.ispay=CASE WHEN v_new_status='refunded' THEN 'refunded' ELSE 'partial' END,
            bo.booking_status=CASE WHEN v_new_status='refunded' AND bo.booking_status='created' THEN 'cancelled' ELSE bo.booking_status END
        WHERE b.id=v_bill_id;
        INSERT INTO `operation_log`(operator_type,operator_id,business_type,business_id,action,remark)
        VALUES('system',NULL,'refund_record',NEW.id,'refund_inserted',NEW.refund_no);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `room_catalog`
--

DROP TABLE IF EXISTS `room_catalog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_catalog` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `kefangmingcheng` varchar(200) NOT NULL COMMENT '客房名称',
  `room_category` varchar(200) NOT NULL COMMENT '客房类型',
  `kefangtupian` varchar(200) NOT NULL COMMENT '客房图片',
  `kefangjiage` float NOT NULL COMMENT '客房价格',
  `shuliang` int DEFAULT NULL COMMENT '数量',
  `jiudianmingcheng` varchar(200) DEFAULT NULL COMMENT '酒店名称',
  `jiudiandizhi` varchar(200) DEFAULT NULL COMMENT '酒店地址',
  `kefangsheshi` longtext COMMENT '客房设施',
  `kefangjieshao` longtext COMMENT '客房介绍',
  `clicknum` int DEFAULT '0' COMMENT '点击次数',
  `hotel_profile_id` bigint DEFAULT NULL COMMENT 'hotel profile id',
  `room_category_id` bigint DEFAULT NULL COMMENT 'room category id',
  `review_count` int NOT NULL DEFAULT '0' COMMENT 'review count',
  `avg_score` decimal(4,2) NOT NULL DEFAULT '0.00' COMMENT 'average score',
  PRIMARY KEY (`id`),
  KEY `idx_room_catalog_hotel` (`hotel_profile_id`),
  KEY `idx_room_catalog_category` (`room_category_id`),
  CONSTRAINT `fk_room_catalog_hotel_profile` FOREIGN KEY (`hotel_profile_id`) REFERENCES `hotel_profile` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_room_catalog_room_category` FOREIGN KEY (`room_category_id`) REFERENCES `room_category` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_room_catalog_click_nonnegative` CHECK ((`clicknum` >= 0)),
  CONSTRAINT `chk_room_catalog_price_nonnegative` CHECK ((`kefangjiage` >= 0)),
  CONSTRAINT `chk_room_catalog_quantity_nonnegative` CHECK (((`shuliang` is null) or (`shuliang` >= 0)))
) ENGINE=InnoDB AUTO_INCREMENT=3008 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='酒店客房';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room_catalog`
--

LOCK TABLES `room_catalog` WRITE;
/*!40000 ALTER TABLE `room_catalog` DISABLE KEYS */;
INSERT INTO `room_catalog` VALUES (3001,'2026-04-28 09:10:00','RoomName1','RoomType1','upload/room_catalog_kefangtupian1.jpg',122,3,'ShangriLa Hotel','Address1','Facility1','<p>Description1</p>',4,1001,2001,0,0.00),(3002,'2026-04-28 09:11:00','RoomName2','RoomType2','upload/room_catalog_kefangtupian2.jpg',255,2,'ShangriLa Hotel','Address2','Facility2','<p>Description2</p>',8,1001,2002,0,0.00),(3003,'2026-04-28 09:12:00','RoomName3','RoomType3','upload/room_catalog_kefangtupian3.jpg',355,3,'ShangriLa Hotel','Address3','Facility3','<p>Description3</p>',4,1001,2003,0,0.00),(3004,'2026-04-28 09:13:00','RoomName4','RoomType4','upload/room_catalog_kefangtupian4.jpg',455,4,'ShangriLa Hotel','Address4','Facility4','<p>Description4</p>',5,1001,2004,0,0.00),(3005,'2026-04-28 09:14:00','RoomName5','RoomType5','upload/room_catalog_kefangtupian5.jpg',555,5,'ShangriLa Hotel','Address5','Facility5','<p>Description5</p>',8,1001,2005,0,0.00),(3006,'2026-04-28 09:15:00','RoomName6','RoomType6','upload/room_catalog_kefangtupian6.jpg',655,6,'ShangriLa Hotel','Address6','Facility6','<p>Description6</p>',12,1001,2006,0,0.00),(3007,'2026-04-28 09:16:00','river view room','DeluxeSuite','upload/1649006659141.jpg',666,18,'ShangriLa Hotel','Shenzhen Nanshan Avenue 1001','River view, bathtub, lounge area','<p>High floor suite for multi-order and room-state demo.</p>',8,1001,2007,0,0.00);
/*!40000 ALTER TABLE `room_catalog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room_category`
--

DROP TABLE IF EXISTS `room_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `room_category` varchar(200) NOT NULL COMMENT '客房类型',
  PRIMARY KEY (`id`),
  UNIQUE KEY `room_category` (`room_category`)
) ENGINE=InnoDB AUTO_INCREMENT=2008 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='客房类型';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room_category`
--

LOCK TABLES `room_category` WRITE;
/*!40000 ALTER TABLE `room_category` DISABLE KEYS */;
INSERT INTO `room_category` VALUES (2001,'2026-04-28 09:05:00','RoomType1'),(2002,'2026-04-28 09:05:10','RoomType2'),(2003,'2026-04-28 09:05:20','RoomType3'),(2004,'2026-04-28 09:05:30','RoomType4'),(2005,'2026-04-28 09:05:40','RoomType5'),(2006,'2026-04-28 09:05:50','RoomType6'),(2007,'2026-04-28 09:06:00','DeluxeSuite');
/*!40000 ALTER TABLE `room_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room_instance`
--

DROP TABLE IF EXISTS `room_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_instance` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `room_catalog_id` bigint NOT NULL COMMENT 'room catalog id',
  `room_no` varchar(50) NOT NULL COMMENT 'room number',
  `floor_no` int NOT NULL DEFAULT '1' COMMENT 'floor number',
  `status` varchar(30) NOT NULL DEFAULT 'available' COMMENT 'available, reserved, occupied, cleaning, maintenance',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'updated time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_room_instance_no` (`room_no`),
  KEY `idx_room_instance_catalog` (`room_catalog_id`),
  KEY `idx_room_instance_status` (`status`),
  CONSTRAINT `fk_room_instance_catalog` FOREIGN KEY (`room_catalog_id`) REFERENCES `room_catalog` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_room_instance_floor_positive` CHECK ((`floor_no` >= 1)),
  CONSTRAINT `chk_room_instance_status` CHECK ((`status` in (_gbk'available',_gbk'reserved',_gbk'occupied',_gbk'cleaning',_gbk'maintenance')))
) ENGINE=InnoDB AUTO_INCREMENT=8064 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='specific hotel room instances';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room_instance`
--

LOCK TABLES `room_instance` WRITE;
/*!40000 ALTER TABLE `room_instance` DISABLE KEYS */;
INSERT INTO `room_instance` VALUES (8001,3007,'R0701',1,'reserved','2026-05-07 09:00:00','2026-06-23 22:34:33'),(8002,3006,'R0601',1,'reserved','2026-05-07 09:00:00','2026-05-27 11:59:57'),(8003,3005,'R0501',1,'cleaning','2026-05-07 09:00:00','2026-05-07 09:10:00'),(8004,3004,'R0401',1,'available','2026-05-07 09:00:00','2026-05-23 17:56:37'),(8005,3003,'R0301',1,'available','2026-05-07 09:00:00','2026-05-23 17:56:37'),(8006,3002,'R0201',1,'available','2026-05-07 09:00:00','2026-06-24 11:10:31'),(8007,3001,'R0101',1,'occupied','2026-05-07 09:00:00','2026-06-24 11:10:13'),(8008,3007,'R0702',1,'reserved','2026-05-07 09:00:00','2026-05-07 09:05:00'),(8009,3006,'R0602',1,'cleaning','2026-05-07 09:00:00','2026-06-10 18:28:08'),(8010,3005,'R0502',1,'cleaning','2026-05-07 09:00:00','2026-06-24 11:04:35'),(8011,3004,'R0402',1,'available','2026-05-07 09:00:00','2026-05-07 09:00:00'),(8012,3003,'R0302',1,'available','2026-05-07 09:00:00','2026-05-07 09:00:00'),(8013,3002,'R0202',1,'available','2026-05-07 09:00:00','2026-05-07 09:00:00'),(8014,3001,'R0102',1,'cleaning','2026-05-07 09:00:00','2026-06-24 11:57:29'),(8015,3007,'R0703',1,'available','2026-05-07 09:00:00','2026-05-07 09:00:00'),(8016,3006,'R0603',1,'cleaning','2026-05-07 09:00:00','2026-06-24 11:25:26'),(8017,3005,'R0503',1,'cleaning','2026-05-07 09:00:00','2026-06-24 11:04:35'),(8018,3004,'R0403',1,'available','2026-05-07 09:00:00','2026-05-07 09:00:00'),(8019,3003,'R0303',1,'available','2026-05-07 09:00:00','2026-05-07 09:00:00'),(8020,3001,'R0103',1,'available','2026-05-07 09:00:00','2026-05-07 09:00:00'),(8021,3007,'R0704',1,'available','2026-05-07 09:00:00','2026-05-07 09:00:00'),(8022,3006,'R0604',1,'cleaning','2026-05-07 09:00:00','2026-06-24 11:25:26'),(8023,3005,'R0504',1,'cleaning','2026-05-07 09:00:00','2026-06-24 11:04:35'),(8024,3004,'R0404',1,'available','2026-05-07 09:00:00','2026-05-07 09:00:00'),(8025,3007,'R0705',1,'available','2026-05-07 09:00:00','2026-05-07 09:00:00'),(8026,3006,'R0605',1,'cleaning','2026-05-07 09:00:00','2026-06-24 11:25:26'),(8027,3005,'R0505',1,'cleaning','2026-05-07 09:00:00','2026-06-24 11:04:35'),(8028,3007,'R0706',1,'available','2026-05-07 09:00:00','2026-05-07 09:00:00'),(8029,3006,'R0606',1,'cleaning','2026-05-07 09:00:00','2026-06-24 11:25:26'),(8030,3007,'R0707',1,'available','2026-05-07 09:00:00','2026-05-07 09:00:00'),(8031,3007,'R0708',1,'available','2026-05-07 09:00:00','2026-05-07 09:00:00'),(8032,3007,'R0709',1,'available','2026-05-07 09:00:00','2026-05-07 09:00:00'),(8033,3007,'R0710',1,'maintenance','2026-05-07 09:00:00','2026-05-07 09:12:00');
/*!40000 ALTER TABLE `room_instance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room_review`
--

DROP TABLE IF EXISTS `room_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_review` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `refid` bigint NOT NULL COMMENT '关联表id',
  `userid` bigint NOT NULL COMMENT '用户id',
  `nickname` varchar(200) DEFAULT NULL COMMENT 'username',
  `content` longtext NOT NULL COMMENT '评论内容',
  `reply` longtext COMMENT '回复内容',
  `score` tinyint NOT NULL DEFAULT '5' COMMENT 'score from 1 to 5',
  PRIMARY KEY (`id`),
  KEY `idx_room_review_ref` (`refid`),
  KEY `idx_room_review_user` (`userid`),
  CONSTRAINT `fk_room_review_customer` FOREIGN KEY (`userid`) REFERENCES `customer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_room_review_room` FOREIGN KEY (`refid`) REFERENCES `room_catalog` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_room_review_score_range` CHECK ((`score` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=1208 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='legacy table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room_review`
--

LOCK TABLES `room_review` WRITE;
/*!40000 ALTER TABLE `room_review` DISABLE KEYS */;
INSERT INTO `room_review` VALUES (1201,'2026-05-01 13:00:00',3001,4001,'user1','room review 1','reply 1',5),(1202,'2026-05-01 13:05:00',3002,4002,'user2','room review 2','reply 2',5),(1203,'2026-05-01 13:10:00',3003,4003,'user3','room review 3','reply 3',5),(1204,'2026-05-01 13:15:00',3004,4004,'user4','room review 4','reply 4',5),(1205,'2026-05-01 13:20:00',3005,4005,'user5','room review 5','reply 5',5),(1206,'2026-05-01 13:25:00',3006,4006,'user6','room review 6','reply 6',5),(1207,'2026-05-01 13:30:00',3007,4007,'user7','suite review',NULL,5);
/*!40000 ALTER TABLE `room_review` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_room_review_before_insert_validate` BEFORE INSERT ON `room_review` FOR EACH ROW BEGIN
    IF NEW.score < 1 OR NEW.score > 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='room review score must be between 1 and 5';
    END IF;
    IF TRIM(COALESCE(NEW.content,''))='' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='room review content cannot be empty';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_room_review_after_insert_update_score` AFTER INSERT ON `room_review` FOR EACH ROW BEGIN
    DECLARE v_review_count int DEFAULT 0;
    DECLARE v_avg_score decimal(4,2) DEFAULT 0.00;
    SELECT COUNT(*),ROUND(AVG(score),2) INTO v_review_count,v_avg_score FROM `room_review` WHERE refid=NEW.refid;
    UPDATE `room_catalog` SET review_count=v_review_count,avg_score=COALESCE(v_avg_score,0.00) WHERE id=NEW.refid;
    INSERT INTO `operation_log`(operator_type,operator_id,business_type,business_id,action,remark)
    VALUES('customer',NEW.userid,'room_review',NEW.id,'room_review_inserted',CONCAT('score=',NEW.score));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `room_status_log`
--

DROP TABLE IF EXISTS `room_status_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_status_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `room_id` bigint NOT NULL COMMENT 'room instance id',
  `old_status` varchar(30) DEFAULT NULL COMMENT 'old status',
  `new_status` varchar(30) NOT NULL COMMENT 'new status',
  `source_type` varchar(50) NOT NULL COMMENT 'source business type',
  `source_id` bigint DEFAULT NULL COMMENT 'source business id',
  `operator_id` bigint DEFAULT NULL COMMENT 'operator id',
  `remark` varchar(500) DEFAULT NULL COMMENT 'remark',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'created time',
  PRIMARY KEY (`id`),
  KEY `idx_room_status_room_time` (`room_id`,`created_at`),
  CONSTRAINT `fk_room_status_log_room` FOREIGN KEY (`room_id`) REFERENCES `room_instance` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9036 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='room status change log';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room_status_log`
--

LOCK TABLES `room_status_log` WRITE;
/*!40000 ALTER TABLE `room_status_log` DISABLE KEYS */;
INSERT INTO `room_status_log` VALUES (9001,8003,'available','cleaning','system_init',NULL,NULL,'sample room prepared for housekeeping flow','2026-05-07 09:10:00'),(9002,8033,'available','maintenance','system_init',NULL,NULL,'sample room prepared for maintenance flow','2026-05-07 09:12:00'),(9003,8014,'available','reserved','booking_order',6008,NULL,'booking created: BK202605080008','2026-05-08 10:00:00'),(9004,8009,'available','reserved','booking_order',6009,NULL,'booking created: BK202605080009','2026-05-08 10:00:00'),(9005,8014,'reserved','occupied','checkin_record',9301,5001,'guest checked in','2026-05-08 10:00:00'),(9006,8014,'occupied','cleaning','checkin_record',9301,5001,'guest checked out and room waits for cleaning','2026-05-08 10:00:00'),(9007,8009,'reserved','occupied','checkin_record',9302,5002,'guest checked in','2026-05-08 10:00:00'),(9008,8007,'reserved','available','booking_order',6001,NULL,'booking cancelled and room released','2026-05-23 17:56:37'),(9009,8006,'reserved','available','booking_order',6002,NULL,'booking cancelled and room released','2026-05-23 17:56:37'),(9010,8005,'reserved','available','booking_order',6003,NULL,'booking cancelled and room released','2026-05-23 17:56:37'),(9011,8004,'reserved','available','booking_order',6004,NULL,'booking cancelled and room released','2026-05-23 17:56:37'),(9012,8003,'cleaning','available','booking_order',6005,NULL,'booking cancelled and room released','2026-05-23 17:56:37'),(9013,8002,'reserved','available','booking_order',6006,NULL,'booking cancelled and room released','2026-05-23 17:56:37'),(9014,8002,'available','reserved','booking_order',6010,NULL,'booking created: BK202605270001','2026-05-27 11:58:51'),(9015,8014,'cleaning','occupied','checkin_record',9303,5001,'guest checked in','2026-06-10 16:50:25'),(9016,8009,'occupied','cleaning','checkin_record',9302,5002,'guest checked out and room waits for cleaning','2026-06-10 18:28:08'),(9017,8007,'available','reserved','booking_order',6012,NULL,'booking created: BK202606240001','2026-06-24 10:19:45'),(9018,8010,'available','cleaning','batch_update',NULL,5001,'演示批量房态调整','2026-06-24 11:04:35'),(9019,8017,'available','cleaning','batch_update',NULL,5001,'演示批量房态调整','2026-06-24 11:04:35'),(9020,8023,'available','cleaning','batch_update',NULL,5001,'演示批量房态调整','2026-06-24 11:04:35'),(9021,8027,'available','cleaning','batch_update',NULL,5001,'演示批量房态调整','2026-06-24 11:04:35'),(9025,8006,'available','reserved','booking_order',6013,NULL,'booking created: BK202607010013','2026-06-24 11:07:13'),(9026,8007,'reserved','occupied','checkin_record',9304,5001,'guest checked in','2026-06-24 11:10:13'),(9027,8006,'reserved','available','booking_order',6013,NULL,'booking cancelled and room released','2026-06-24 11:10:31'),(9028,8016,'available','cleaning','batch_update',NULL,5001,'aaa','2026-06-24 11:25:26'),(9029,8022,'available','cleaning','batch_update',NULL,5001,'aaa','2026-06-24 11:25:26'),(9030,8026,'available','cleaning','batch_update',NULL,5001,'aaa','2026-06-24 11:25:26'),(9031,8029,'available','cleaning','batch_update',NULL,5001,'aaa','2026-06-24 11:25:26'),(9035,8014,'cleaning','cleaning','checkin_record',9303,5001,'guest checked out and room waits for cleaning','2026-06-24 11:57:29');
/*!40000 ALTER TABLE `room_status_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_config`
--

DROP TABLE IF EXISTS `system_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(100) NOT NULL COMMENT '配置参数名称',
  `value` varchar(100) DEFAULT NULL COMMENT 'config value',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_system_config_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='配置文件';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_config`
--

LOCK TABLES `system_config` WRITE;
/*!40000 ALTER TABLE `system_config` DISABLE KEYS */;
INSERT INTO `system_config` VALUES (1,'picture1','upload/1649006784751.jpg'),(2,'picture2','upload/picture2.jpg'),(3,'picture3','upload/picture3.jpg');
/*!40000 ALTER TABLE `system_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_bill_payment_summary`
--

DROP TABLE IF EXISTS `v_bill_payment_summary`;
/*!50001 DROP VIEW IF EXISTS `v_bill_payment_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_bill_payment_summary` AS SELECT 
 1 AS `bill_id`,
 1 AS `booking_id`,
 1 AS `checkin_id`,
 1 AS `customer_id`,
 1 AS `customer_name`,
 1 AS `room_amount`,
 1 AS `service_amount`,
 1 AS `discount_amount`,
 1 AS `payable_amount`,
 1 AS `actual_paid_amount`,
 1 AS `actual_refund_amount`,
 1 AS `bill_status`,
 1 AS `last_paid_at`,
 1 AS `created_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_booking_detail`
--

DROP TABLE IF EXISTS `v_booking_detail`;
/*!50001 DROP VIEW IF EXISTS `v_booking_detail`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_booking_detail` AS SELECT 
 1 AS `booking_id`,
 1 AS `booking_no`,
 1 AS `booking_time`,
 1 AS `customer_login_name`,
 1 AS `customer_id`,
 1 AS `customer_real_name`,
 1 AS `customer_phone`,
 1 AS `room_name`,
 1 AS `room_category`,
 1 AS `room_numbers`,
 1 AS `expected_checkin_date`,
 1 AS `expected_checkout_date`,
 1 AS `unit_price`,
 1 AS `quantity`,
 1 AS `total_amount`,
 1 AS `old_payment_status`,
 1 AS `booking_status`,
 1 AS `status_change_count`,
 1 AS `last_status_time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_checkin_guest_detail`
--

DROP TABLE IF EXISTS `v_checkin_guest_detail`;
/*!50001 DROP VIEW IF EXISTS `v_checkin_guest_detail`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_checkin_guest_detail` AS SELECT 
 1 AS `checkin_id`,
 1 AS `booking_id`,
 1 AS `customer_id`,
 1 AS `customer_name`,
 1 AS `room_no`,
 1 AS `room_name`,
 1 AS `room_category`,
 1 AS `checkin_time`,
 1 AS `checkout_time`,
 1 AS `checkin_status`,
 1 AS `primary_guest_name`,
 1 AS `guest_count`,
 1 AS `employee_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_customer_value_profile`
--

DROP TABLE IF EXISTS `v_customer_value_profile`;
/*!50001 DROP VIEW IF EXISTS `v_customer_value_profile`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_customer_value_profile` AS SELECT 
 1 AS `customer_id`,
 1 AS `customer_login_name`,
 1 AS `customer_name`,
 1 AS `customer_phone`,
 1 AS `booking_count`,
 1 AS `checkin_count`,
 1 AS `total_payable_amount`,
 1 AS `total_paid_amount`,
 1 AS `favorite_count`,
 1 AS `room_review_count`,
 1 AS `hotel_review_count`,
 1 AS `last_booking_time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_employee_operation_summary`
--

DROP TABLE IF EXISTS `v_employee_operation_summary`;
/*!50001 DROP VIEW IF EXISTS `v_employee_operation_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_employee_operation_summary` AS SELECT 
 1 AS `employee_id`,
 1 AS `employee_no`,
 1 AS `employee_name`,
 1 AS `total_operations`,
 1 AS `booking_operations`,
 1 AS `checkin_operations`,
 1 AS `bill_operations`,
 1 AS `refund_operations`,
 1 AS `cleaning_task_count`,
 1 AS `maintenance_task_count`,
 1 AS `latest_assessment_score`,
 1 AS `latest_assessment_grade`,
 1 AS `first_operation_time`,
 1 AS `last_operation_time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_employee_performance_detail`
--

DROP TABLE IF EXISTS `v_employee_performance_detail`;
/*!50001 DROP VIEW IF EXISTS `v_employee_performance_detail`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_employee_performance_detail` AS SELECT 
 1 AS `performance_id`,
 1 AS `employee_id`,
 1 AS `employee_no`,
 1 AS `employee_name`,
 1 AS `period_start`,
 1 AS `period_end`,
 1 AS `checkin_count`,
 1 AS `bill_count`,
 1 AS `payment_count`,
 1 AS `cleaning_count`,
 1 AS `maintenance_count`,
 1 AS `operation_count`,
 1 AS `manager_score`,
 1 AS `total_score`,
 1 AS `grade`,
 1 AS `assessor_name`,
 1 AS `created_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_housekeeping_task_detail`
--

DROP TABLE IF EXISTS `v_housekeeping_task_detail`;
/*!50001 DROP VIEW IF EXISTS `v_housekeeping_task_detail`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_housekeeping_task_detail` AS SELECT 
 1 AS `task_id`,
 1 AS `task_type`,
 1 AS `task_status`,
 1 AS `scheduled_time`,
 1 AS `completed_time`,
 1 AS `room_no`,
 1 AS `room_status`,
 1 AS `room_name`,
 1 AS `room_category`,
 1 AS `booking_id`,
 1 AS `assigned_employee_name`,
 1 AS `remark`,
 1 AS `created_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_monthly_revenue_report`
--

DROP TABLE IF EXISTS `v_monthly_revenue_report`;
/*!50001 DROP VIEW IF EXISTS `v_monthly_revenue_report`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_monthly_revenue_report` AS SELECT 
 1 AS `revenue_month`,
 1 AS `room_category`,
 1 AS `pay_method`,
 1 AS `bill_count`,
 1 AS `payment_count`,
 1 AS `gross_revenue`,
 1 AS `refund_amount`,
 1 AS `net_revenue`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_room_daily_status`
--

DROP TABLE IF EXISTS `v_room_daily_status`;
/*!50001 DROP VIEW IF EXISTS `v_room_daily_status`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_room_daily_status` AS SELECT 
 1 AS `room_id`,
 1 AS `room_no`,
 1 AS `floor_no`,
 1 AS `current_status`,
 1 AS `room_name`,
 1 AS `room_category`,
 1 AS `active_booking_id`,
 1 AS `booking_no`,
 1 AS `customer_name`,
 1 AS `active_checkin_id`,
 1 AS `checkin_time`,
 1 AS `checkout_time`,
 1 AS `active_housekeeping_task_id`,
 1 AS `active_maintenance_id`,
 1 AS `business_status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_room_inventory_overview`
--

DROP TABLE IF EXISTS `v_room_inventory_overview`;
/*!50001 DROP VIEW IF EXISTS `v_room_inventory_overview`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_room_inventory_overview` AS SELECT 
 1 AS `room_catalog_id`,
 1 AS `hotel_name`,
 1 AS `room_name`,
 1 AS `room_category`,
 1 AS `total_rooms`,
 1 AS `available_rooms`,
 1 AS `reserved_rooms`,
 1 AS `occupied_rooms`,
 1 AS `cleaning_rooms`,
 1 AS `maintenance_rooms`,
 1 AS `base_price`,
 1 AS `review_count`,
 1 AS `avg_score`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'hotel_management'
--

--
-- Dumping routines for database 'hotel_management'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_batch_update_room_status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_batch_update_room_status`(IN p_room_category varchar(200), IN p_old_status varchar(30), IN p_new_status varchar(30), IN p_operator_id bigint, IN p_remark varchar(500))
BEGIN DECLARE v_changed_count int DEFAULT 0; IF p_new_status IS NULL OR TRIM(p_new_status)='' THEN   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'new status is required'; END IF; INSERT INTO `room_status_log`(`room_id`,`old_status`,`new_status`,`source_type`,`source_id`,`operator_id`,`remark`) SELECT ri.id, ri.status, p_new_status, 'batch_update', NULL, p_operator_id, p_remark FROM `room_instance` ri JOIN `room_catalog` rc ON rc.id=ri.room_catalog_id WHERE (p_room_category IS NULL OR TRIM(p_room_category)='' OR rc.room_category=CONVERT(p_room_category USING utf8mb4) COLLATE utf8mb4_0900_ai_ci)   AND (p_old_status IS NULL OR TRIM(p_old_status)='' OR ri.status=CONVERT(p_old_status USING utf8mb4) COLLATE utf8mb4_0900_ai_ci)   AND ri.status<>CONVERT(p_new_status USING utf8mb4) COLLATE utf8mb4_0900_ai_ci; SET v_changed_count = ROW_COUNT(); UPDATE `room_instance` ri JOIN `room_catalog` rc ON rc.id=ri.room_catalog_id    SET ri.status=p_new_status, ri.updated_at=NOW() WHERE (p_room_category IS NULL OR TRIM(p_room_category)='' OR rc.room_category=CONVERT(p_room_category USING utf8mb4) COLLATE utf8mb4_0900_ai_ci)   AND (p_old_status IS NULL OR TRIM(p_old_status)='' OR ri.status=CONVERT(p_old_status USING utf8mb4) COLLATE utf8mb4_0900_ai_ci)   AND ri.status<>CONVERT(p_new_status USING utf8mb4) COLLATE utf8mb4_0900_ai_ci; INSERT INTO `operation_log`(`operator_type`,`operator_id`,`business_type`,`business_id`,`action`,`remark`) VALUES('employee',p_operator_id,'room_instance',NULL,'batch_update_room_status',CONCAT('changed rooms: ',v_changed_count)); SELECT v_changed_count AS changed_count; END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_confirm_checkin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_confirm_checkin`(IN p_booking_id bigint, IN p_employee_id bigint, IN p_guest_name varchar(100), IN p_id_card_no varchar(30), IN p_phone varchar(30))
BEGIN
    DECLARE v_room_id bigint;
    DECLARE v_customer_id bigint;
    DECLARE v_customer_login varchar(200);
    DECLARE v_checkin_id bigint;
    DECLARE v_old_status varchar(30);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;
    SELECT room_instance_id,customer_id,customerming,booking_status INTO v_room_id,v_customer_id,v_customer_login,v_old_status FROM `booking_order` WHERE id=p_booking_id FOR UPDATE;
    IF v_room_id IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='booking has no assigned room'; END IF;
    IF v_customer_id IS NULL THEN
        SELECT id INTO v_customer_id FROM `customer` WHERE customerming=v_customer_login LIMIT 1;
    END IF;
    INSERT INTO `checkin_record`(booking_id,room_id,customer_id,employee_id,checkin_time,status,remark) VALUES(p_booking_id,v_room_id,v_customer_id,p_employee_id,NOW(),'checked_in','confirm checkin');
    SET v_checkin_id=LAST_INSERT_ID();
    INSERT INTO `checkin_guest`(checkin_id,guest_name,id_card_no,phone,is_primary)
    SELECT v_checkin_id,bg.guest_name,bg.id_card_no,bg.phone,bg.is_primary
    FROM `booking_guest` bg WHERE bg.booking_id=p_booking_id;
    IF ROW_COUNT()=0 THEN
        INSERT INTO `checkin_guest`(checkin_id,guest_name,id_card_no,phone,is_primary) VALUES(v_checkin_id,IFNULL(p_guest_name,v_customer_login),p_id_card_no,p_phone,1);
    END IF;
    UPDATE `booking_order` SET booking_status='checked_in' WHERE id=p_booking_id;
    UPDATE `booking_room` SET room_status='checked_in' WHERE booking_id=p_booking_id AND room_id=v_room_id;
    UPDATE `room_instance` SET status='occupied',updated_at=NOW() WHERE id=v_room_id;
    INSERT INTO `booking_status_log`(booking_id,old_status,new_status,operator_id,remark) VALUES(p_booking_id,v_old_status,'checked_in',p_employee_id,'confirm checkin');
    INSERT INTO `operation_log`(operator_type,operator_id,business_type,business_id,action,remark) VALUES('employee',p_employee_id,'checkin_record',v_checkin_id,'confirm_checkin',CONCAT('booking ',p_booking_id));
    COMMIT;
    SELECT v_checkin_id AS checkin_id,v_room_id AS room_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_create_booking_order` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_booking_order`(IN p_customer_id bigint, IN p_room_catalog_id bigint, IN p_quantity int, IN p_booking_date date, IN p_operator_id bigint)
BEGIN
    DECLARE v_room_id bigint DEFAULT NULL;
    DECLARE v_needed int DEFAULT 1;
    DECLARE v_available_count int DEFAULT 0;
    DECLARE v_allocated_count int DEFAULT 0;
    DECLARE v_start_date date;
    DECLARE v_end_date date;
    DECLARE v_customer_name varchar(200);
    DECLARE v_real_name varchar(200);
    DECLARE v_phone varchar(200);
    DECLARE v_room_name varchar(200);
    DECLARE v_category varchar(200);
    DECLARE v_price decimal(10,2);
    DECLARE v_hotel_name varchar(200);
    DECLARE v_hotel_address varchar(200);
    DECLARE v_booking_no varchar(200);
    DECLARE v_booking_id bigint;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;
    DROP TEMPORARY TABLE IF EXISTS `tmp_booking_selected_rooms`;
    CREATE TEMPORARY TABLE `tmp_booking_selected_rooms` (
        `room_id` bigint NOT NULL PRIMARY KEY
    ) ENGINE=Memory;
    SET v_needed = GREATEST(1, IFNULL(p_quantity,1));
    SET v_start_date = IFNULL(p_booking_date,CURDATE());
    SET v_end_date = DATE_ADD(v_start_date, INTERVAL 1 DAY);
    SELECT customerming,xingming,shoujihao INTO v_customer_name,v_real_name,v_phone FROM `customer` WHERE id=p_customer_id FOR UPDATE;
    SELECT kefangmingcheng,room_category,kefangjiage,jiudianmingcheng,jiudiandizhi INTO v_room_name,v_category,v_price,v_hotel_name,v_hotel_address FROM `room_catalog` WHERE id=p_room_catalog_id;
    SELECT COUNT(*) INTO v_available_count
    FROM `room_instance` ri
    WHERE ri.room_catalog_id=p_room_catalog_id
      AND ri.status='available'
      AND NOT EXISTS (
          SELECT 1 FROM `booking_room` br
          JOIN `booking_order` bo ON bo.id=br.booking_id
          WHERE br.room_id=ri.id
            AND br.room_status IN ('reserved','checked_in')
            AND bo.booking_status NOT IN ('cancelled','completed')
            AND br.stay_start_date < v_end_date
            AND br.stay_end_date > v_start_date
      );
    IF v_available_count < v_needed THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='not enough available rooms'; END IF;
    INSERT INTO `tmp_booking_selected_rooms`(`room_id`)
    SELECT ri.id
    FROM `room_instance` ri
    WHERE ri.room_catalog_id=p_room_catalog_id
      AND ri.status='available'
      AND NOT EXISTS (
          SELECT 1 FROM `booking_room` br
          JOIN `booking_order` bo ON bo.id=br.booking_id
          WHERE br.room_id=ri.id
            AND br.room_status IN ('reserved','checked_in')
            AND bo.booking_status NOT IN ('cancelled','completed')
            AND br.stay_start_date < v_end_date
            AND br.stay_end_date > v_start_date
      )
    ORDER BY ri.room_no
    LIMIT v_needed;
    SELECT COUNT(*), MIN(room_id) INTO v_allocated_count, v_room_id FROM `tmp_booking_selected_rooms`;
    IF v_allocated_count <> v_needed OR v_room_id IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='room allocation failed'; END IF;
    SET v_booking_no=CONCAT('BK', DATE_FORMAT(v_start_date,'%Y%m%d'), LPAD((SELECT COUNT(*) + 1 FROM `booking_order`), 4, '0'));
    INSERT INTO `booking_order`(customer_id,room_catalog_id,expected_checkin_date,expected_checkout_date,yudingbianhao,kefangmingcheng,room_category,kefangjiage,shuliang,zongjine,jiudianmingcheng,jiudiandizhi,customerming,xingming,shoujihao,yudingriqi,ispay,booking_status,room_instance_id)
    VALUES(p_customer_id,p_room_catalog_id,v_start_date,v_end_date,v_booking_no,v_room_name,v_category,v_price,v_needed,v_price*v_needed,v_hotel_name,v_hotel_address,v_customer_name,v_real_name,v_phone,v_start_date,'unpaid','created',v_room_id);
    SET v_booking_id=LAST_INSERT_ID();
    INSERT INTO `booking_room`(booking_id,room_id,room_price,stay_start_date,stay_end_date,room_status)
    SELECT v_booking_id, room_id, v_price, v_start_date, v_end_date, 'reserved'
    FROM `tmp_booking_selected_rooms`
    ORDER BY room_id;
    INSERT INTO `booking_status_log`(booking_id,old_status,new_status,operator_id,remark) VALUES(v_booking_id,NULL,'created',p_operator_id,CONCAT('booking created by procedure, rooms=',v_allocated_count));
    INSERT INTO `operation_log`(operator_type,operator_id,business_type,business_id,action,remark) VALUES('customer',p_customer_id,'booking_order',v_booking_id,'create_booking',v_booking_no);
    DROP TEMPORARY TABLE IF EXISTS `tmp_booking_selected_rooms`;
    COMMIT;
    SELECT v_booking_id AS booking_id,v_booking_no AS booking_no,v_allocated_count AS room_count;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_create_housekeeping_task` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_housekeeping_task`(IN p_room_id bigint, IN p_employee_id bigint, IN p_task_type varchar(30), IN p_remark varchar(500))
BEGIN
    DECLARE v_old_status varchar(30);
    DECLARE v_task_id bigint;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;
    SELECT status INTO v_old_status FROM `room_instance` WHERE id=p_room_id FOR UPDATE;
    IF v_old_status IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='room not found';
    END IF;
    INSERT INTO `housekeeping_task`(room_id,assigned_employee_id,task_type,task_status,scheduled_time,remark)
    VALUES(p_room_id,p_employee_id,IFNULL(p_task_type,'daily_cleaning'),'assigned',NOW(),p_remark);
    SET v_task_id=LAST_INSERT_ID();
    IF v_old_status<>'cleaning' THEN
        UPDATE `room_instance` SET status='cleaning',updated_at=NOW() WHERE id=p_room_id;
        INSERT INTO `room_status_log`(room_id,old_status,new_status,source_type,source_id,operator_id,remark)
        VALUES(p_room_id,v_old_status,'cleaning','housekeeping_task',v_task_id,p_employee_id,'housekeeping task created');
    END IF;
    INSERT INTO `operation_log`(operator_type,operator_id,business_type,business_id,action,remark)
    VALUES('employee',p_employee_id,'housekeeping_task',v_task_id,'create_housekeeping_task',p_remark);
    COMMIT;
    SELECT v_task_id AS task_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_customer_consumption_report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_customer_consumption_report`(IN p_customer_id bigint, IN p_start_date date, IN p_end_date date)
BEGIN
    DECLARE v_start date;
    DECLARE v_end date;
    SET v_start=IFNULL(p_start_date,'2000-01-01');
    SET v_end=IFNULL(p_end_date,CURDATE());
    SELECT c.id AS customer_id,c.customerming AS customer_login_name,c.xingming AS customer_name,
           COUNT(DISTINCT bo.id) AS booking_count,COUNT(DISTINCT cr.id) AS checkin_count,
           COALESCE(SUM(DISTINCT b.payable_amount),0) AS total_payable_amount,
           COALESCE(SUM(DISTINCT b.paid_amount),0) AS total_paid_amount,
           COALESCE(SUM(DISTINCT b.refund_amount),0) AS total_refund_amount,
           COUNT(DISTINCT f.id) AS favorite_count,
           COUNT(DISTINCT rr.id)+COUNT(DISTINCT hr.id) AS review_count,
           MIN(bo.addtime) AS first_booking_time,MAX(bo.addtime) AS last_booking_time
    FROM `customer` c
    LEFT JOIN `booking_order` bo ON bo.customerming=c.customerming AND DATE(bo.addtime) BETWEEN v_start AND v_end
    LEFT JOIN `checkin_record` cr ON cr.customer_id=c.id AND DATE(cr.checkin_time) BETWEEN v_start AND v_end
    LEFT JOIN `bill` b ON b.customer_id=c.id AND DATE(b.created_at) BETWEEN v_start AND v_end
    LEFT JOIN `favorite` f ON f.userid=c.id LEFT JOIN `room_review` rr ON rr.userid=c.id LEFT JOIN `hotel_review` hr ON hr.userid=c.id
    WHERE p_customer_id IS NULL OR c.id=p_customer_id
    GROUP BY c.id,c.customerming,c.xingming
    ORDER BY total_paid_amount DESC,booking_count DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_employee_performance_report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_employee_performance_report`(IN p_employee_id bigint, IN p_start_date date, IN p_end_date date)
BEGIN DECLARE v_start date; DECLARE v_end date; SET v_start=IFNULL(p_start_date,'2000-01-01'); SET v_end=IFNULL(p_end_date,CURDATE()); SELECT e.id AS employee_id, e.employeegonghao AS employee_no, e.employeexingming AS employee_name,        COALESCE(cr.checkin_count,0) AS checkin_count,        COALESCE(bp.bill_count,0) AS bill_count,        COALESCE(bp.payment_count,0) AS payment_count,        COALESCE(ht.cleaning_count,0) AS cleaning_count,        COALESCE(mr.maintenance_count,0) AS maintenance_count,        COALESCE(bp.handled_payment_amount,0) AS handled_payment_amount,        COALESCE(ol.operation_count,0) AS operation_count,        ep.latest_assessment_score AS latest_assessment_score,        ep.latest_assessment_grade AS latest_assessment_grade,        COALESCE(ol.confirm_checkin_actions,0) AS confirm_checkin_actions,        COALESCE(ol.checkout_actions,0) AS checkout_actions,        COALESCE(ol.payment_actions,0) AS payment_actions,        ol.last_operation_time AS last_operation_time FROM `employee` e LEFT JOIN (   SELECT employee_id, COUNT(DISTINCT id) AS checkin_count   FROM `checkin_record`   WHERE DATE(checkin_time) BETWEEN v_start AND v_end   GROUP BY employee_id ) cr ON cr.employee_id=e.id LEFT JOIN (   SELECT cr2.employee_id, COUNT(DISTINCT b.id) AS bill_count, COUNT(DISTINCT pr.id) AS payment_count,          COALESCE(SUM(CASE WHEN pr.pay_status='success' THEN pr.pay_amount ELSE 0 END),0) AS handled_payment_amount   FROM `checkin_record` cr2   LEFT JOIN `bill` b ON b.checkin_id=cr2.id   LEFT JOIN `payment_record` pr ON pr.bill_id=b.id   WHERE DATE(cr2.checkin_time) BETWEEN v_start AND v_end   GROUP BY cr2.employee_id ) bp ON bp.employee_id=e.id LEFT JOIN (   SELECT assigned_employee_id AS employee_id, COUNT(DISTINCT id) AS cleaning_count   FROM `housekeeping_task`   WHERE task_status='completed' AND completed_time IS NOT NULL AND DATE(completed_time) BETWEEN v_start AND v_end   GROUP BY assigned_employee_id ) ht ON ht.employee_id=e.id LEFT JOIN (   SELECT handled_by_employee_id AS employee_id, COUNT(DISTINCT id) AS maintenance_count   FROM `maintenance_record`   WHERE maintenance_status='completed' AND end_time IS NOT NULL AND DATE(end_time) BETWEEN v_start AND v_end   GROUP BY handled_by_employee_id ) mr ON mr.employee_id=e.id LEFT JOIN (   SELECT employee_id, MAX(total_score) AS latest_assessment_score, MAX(grade) AS latest_assessment_grade   FROM `employee_performance`   WHERE period_start>=v_start AND period_end<=v_end   GROUP BY employee_id ) ep ON ep.employee_id=e.id LEFT JOIN (   SELECT operator_id AS employee_id, COUNT(DISTINCT id) AS operation_count,          SUM(CASE WHEN action='confirm_checkin' THEN 1 ELSE 0 END) AS confirm_checkin_actions,          SUM(CASE WHEN action='generate_checkout_bill' THEN 1 ELSE 0 END) AS checkout_actions,          SUM(CASE WHEN action='pay_bill' THEN 1 ELSE 0 END) AS payment_actions,          MAX(created_at) AS last_operation_time   FROM `operation_log`   WHERE operator_type='employee' AND DATE(created_at) BETWEEN v_start AND v_end   GROUP BY operator_id ) ol ON ol.employee_id=e.id WHERE p_employee_id IS NULL OR e.id=p_employee_id ORDER BY handled_payment_amount DESC, operation_count DESC; END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_generate_checkout_bill` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_generate_checkout_bill`(IN p_checkin_id bigint, IN p_service_amount decimal(10,2), IN p_discount_amount decimal(10,2), IN p_employee_id bigint)
BEGIN
    DECLARE v_booking_id bigint;
    DECLARE v_customer_id bigint;
    DECLARE v_room_amount decimal(10,2) DEFAULT 0.00;
    DECLARE v_payable decimal(10,2) DEFAULT 0.00;
    DECLARE v_bill_id bigint;
    DECLARE v_room_id bigint;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    START TRANSACTION;
    SELECT booking_id,customer_id,room_id INTO v_booking_id,v_customer_id,v_room_id FROM `checkin_record` WHERE id=p_checkin_id FOR UPDATE;
    SELECT COALESCE(zongjine,kefangjiage*COALESCE(shuliang,1),0) INTO v_room_amount FROM `booking_order` WHERE id=v_booking_id;
    SET v_payable=GREATEST(0,v_room_amount+IFNULL(p_service_amount,0)-IFNULL(p_discount_amount,0));
    INSERT INTO `bill`(booking_id,checkin_id,customer_id,room_amount,service_amount,discount_amount,payable_amount,status)
    VALUES(v_booking_id,p_checkin_id,v_customer_id,v_room_amount,IFNULL(p_service_amount,0),IFNULL(p_discount_amount,0),v_payable,'unpaid');
    SET v_bill_id=LAST_INSERT_ID();
    UPDATE `checkin_record` SET checkout_time=NOW(),status='checked_out' WHERE id=p_checkin_id;
    UPDATE `booking_order` SET booking_status='completed' WHERE id=v_booking_id;
    UPDATE `booking_room` SET room_status='completed' WHERE booking_id=v_booking_id AND room_id=v_room_id;
    UPDATE `room_instance` SET status='cleaning',updated_at=NOW() WHERE id=v_room_id;
    INSERT INTO `operation_log`(operator_type,operator_id,business_type,business_id,action,remark) VALUES('employee',p_employee_id,'bill',v_bill_id,'generate_checkout_bill',CONCAT('checkin ',p_checkin_id));
    COMMIT;
    SELECT v_bill_id AS bill_id,v_payable AS payable_amount;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_generate_employee_assessment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_generate_employee_assessment`(IN p_employee_id bigint, IN p_start_date date, IN p_end_date date, IN p_assessor_id bigint, IN p_manager_score decimal(5,2))
BEGIN
    DECLARE v_checkin_count int DEFAULT 0;
    DECLARE v_bill_count int DEFAULT 0;
    DECLARE v_payment_count int DEFAULT 0;
    DECLARE v_cleaning_count int DEFAULT 0;
    DECLARE v_maintenance_count int DEFAULT 0;
    DECLARE v_operation_count int DEFAULT 0;
    DECLARE v_total_score decimal(6,2) DEFAULT 0.00;
    DECLARE v_grade varchar(20) DEFAULT 'C';
    IF p_start_date IS NULL OR p_end_date IS NULL OR p_end_date < p_start_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='invalid assessment period';
    END IF;
    SELECT COUNT(*) INTO v_checkin_count FROM `checkin_record` WHERE employee_id=p_employee_id AND DATE(checkin_time) BETWEEN p_start_date AND p_end_date;
    SELECT COUNT(*) INTO v_bill_count FROM `bill` b JOIN `operation_log` ol ON ol.business_type='bill' AND ol.business_id=b.id WHERE ol.operator_type='employee' AND ol.operator_id=p_employee_id AND DATE(ol.created_at) BETWEEN p_start_date AND p_end_date;
    SELECT COUNT(*) INTO v_payment_count FROM `operation_log` WHERE operator_type='employee' AND operator_id=p_employee_id AND action='pay_bill' AND DATE(created_at) BETWEEN p_start_date AND p_end_date;
    SELECT COUNT(*) INTO v_cleaning_count FROM `housekeeping_task` WHERE assigned_employee_id=p_employee_id AND task_status='completed' AND DATE(completed_time) BETWEEN p_start_date AND p_end_date;
    SELECT COUNT(*) INTO v_maintenance_count FROM `maintenance_record` WHERE handled_by_employee_id=p_employee_id AND maintenance_status='completed' AND DATE(end_time) BETWEEN p_start_date AND p_end_date;
    SELECT COUNT(*) INTO v_operation_count FROM `operation_log` WHERE operator_type='employee' AND operator_id=p_employee_id AND DATE(created_at) BETWEEN p_start_date AND p_end_date;
    SET v_total_score = LEAST(100, v_checkin_count*5 + v_bill_count*4 + v_payment_count*3 + v_cleaning_count*3 + v_maintenance_count*4 + v_operation_count*1 + IFNULL(p_manager_score,0));
    IF v_total_score>=90 THEN SET v_grade='A';
    ELSEIF v_total_score>=75 THEN SET v_grade='B';
    ELSEIF v_total_score>=60 THEN SET v_grade='C';
    ELSE SET v_grade='D'; END IF;
    INSERT INTO `employee_performance`(employee_id,assessor_id,period_start,period_end,checkin_count,bill_count,payment_count,cleaning_count,maintenance_count,operation_count,manager_score,total_score,grade,remark)
    VALUES(p_employee_id,p_assessor_id,p_start_date,p_end_date,v_checkin_count,v_bill_count,v_payment_count,v_cleaning_count,v_maintenance_count,v_operation_count,IFNULL(p_manager_score,0),v_total_score,v_grade,'generated by procedure')
    ON DUPLICATE KEY UPDATE checkin_count=VALUES(checkin_count),bill_count=VALUES(bill_count),payment_count=VALUES(payment_count),cleaning_count=VALUES(cleaning_count),maintenance_count=VALUES(maintenance_count),operation_count=VALUES(operation_count),manager_score=VALUES(manager_score),total_score=VALUES(total_score),grade=VALUES(grade),assessor_id=VALUES(assessor_id),created_at=NOW();
    SELECT p_employee_id AS employee_id, v_total_score AS total_score, v_grade AS grade;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_pay_bill` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_pay_bill`(IN p_bill_id bigint, IN p_pay_method varchar(30), IN p_pay_amount decimal(10,2), IN p_employee_id bigint)
BEGIN
    DECLARE v_payment_no varchar(80);
    DECLARE v_payable decimal(10,2);
    DECLARE v_paid decimal(10,2);
    DECLARE v_payment_id bigint;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    IF p_pay_amount IS NULL OR p_pay_amount<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='pay amount must be positive'; END IF;
    START TRANSACTION;
    SELECT payable_amount,paid_amount INTO v_payable,v_paid FROM `bill` WHERE id=p_bill_id FOR UPDATE;
    IF v_paid+p_pay_amount>v_payable THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='pay amount exceeds payable amount'; END IF;
    SET v_payment_no=CONCAT('PAY',DATE_FORMAT(NOW(),'%Y%m%d%H%i%s'),LPAD(p_bill_id,4,'0'));
    INSERT INTO `payment_record`(bill_id,payment_no,pay_method,pay_amount,pay_status,paid_at,remark) VALUES(p_bill_id,v_payment_no,IFNULL(p_pay_method,'cash'),p_pay_amount,'success',NOW(),'pay by procedure');
    SET v_payment_id=LAST_INSERT_ID();
    INSERT INTO `operation_log`(operator_type,operator_id,business_type,business_id,action,remark) VALUES('employee',p_employee_id,'payment_record',v_payment_id,'pay_bill',v_payment_no);
    COMMIT;
    SELECT v_payment_id AS payment_id,v_payment_no AS payment_no;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_report_room_maintenance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = gbk */ ;
/*!50003 SET character_set_results = gbk */ ;
/*!50003 SET collation_connection  = gbk_chinese_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_report_room_maintenance`(IN p_room_id bigint, IN p_report_employee_id bigint, IN p_handle_employee_id bigint, IN p_issue_desc varchar(500))
BEGIN
    DECLARE v_maintenance_id bigint;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
    IF p_issue_desc IS NULL OR p_issue_desc='' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='issue description is required';
    END IF;
    START TRANSACTION;
    SELECT id INTO v_maintenance_id FROM `room_instance` WHERE id=p_room_id FOR UPDATE;
    INSERT INTO `maintenance_record`(room_id,reported_by_employee_id,handled_by_employee_id,issue_desc,maintenance_status,remark)
    VALUES(p_room_id,p_report_employee_id,p_handle_employee_id,p_issue_desc,'reported','created by procedure');
    SET v_maintenance_id=LAST_INSERT_ID();
    COMMIT;
    SELECT v_maintenance_id AS maintenance_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_search_available_rooms` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_available_rooms`(IN p_room_category varchar(200), IN p_start_date date, IN p_end_date date, IN p_min_price decimal(10,2), IN p_max_price decimal(10,2))
BEGIN DECLARE v_start date; DECLARE v_end date; SET v_start = IFNULL(p_start_date, CURDATE()); SET v_end = IFNULL(p_end_date, DATE_ADD(v_start, INTERVAL 1 DAY)); IF v_end <= v_start THEN   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'end date must be greater than start date'; END IF; SELECT ri.id AS room_id, ri.room_no, ri.floor_no, rc.id AS room_catalog_id,        rc.kefangmingcheng AS room_name, rc.room_category, rc.kefangjiage AS base_price,        ROUND(rc.kefangjiage * COALESCE(MAX(pp.price_multiplier),1),2) AS final_price,        rc.jiudianmingcheng AS hotel_name, rc.jiudiandizhi AS hotel_address FROM `room_instance` ri JOIN `room_catalog` rc ON rc.id=ri.room_catalog_id LEFT JOIN `price_policy` pp ON pp.room_catalog_id=rc.id AND pp.enabled=1 AND v_start BETWEEN pp.start_date AND pp.end_date WHERE ri.status=CONVERT('available' USING utf8mb4) COLLATE utf8mb4_0900_ai_ci   AND (p_room_category IS NULL OR TRIM(p_room_category)='' OR rc.room_category=CONVERT(p_room_category USING utf8mb4) COLLATE utf8mb4_0900_ai_ci)   AND (p_min_price IS NULL OR rc.kefangjiage>=p_min_price)   AND (p_max_price IS NULL OR p_max_price=0 OR rc.kefangjiage<=p_max_price)   AND NOT EXISTS (       SELECT 1       FROM `booking_room` br       JOIN `booking_order` bo ON bo.id=br.booking_id       WHERE br.room_id=ri.id         AND br.room_status IN ('reserved','checked_in')         AND bo.booking_status NOT IN ('cancelled','completed')         AND br.stay_start_date < v_end         AND br.stay_end_date > v_start   )   AND NOT EXISTS (       SELECT 1       FROM `maintenance_record` mr       WHERE mr.room_id=ri.id AND mr.maintenance_status IN ('reported','processing')   ) GROUP BY ri.id, ri.room_no, ri.floor_no, rc.id, rc.kefangmingcheng, rc.room_category, rc.kefangjiage, rc.jiudianmingcheng, rc.jiudiandizhi ORDER BY final_price ASC, ri.room_no ASC; END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Current Database: `hotel_management`
--

USE `hotel_management`;

--
-- Final view structure for view `v_bill_payment_summary`
--

/*!50001 DROP VIEW IF EXISTS `v_bill_payment_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = gbk */;
/*!50001 SET character_set_results     = gbk */;
/*!50001 SET collation_connection      = gbk_chinese_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_bill_payment_summary` AS select `b`.`id` AS `bill_id`,`b`.`booking_id` AS `booking_id`,`b`.`checkin_id` AS `checkin_id`,`b`.`customer_id` AS `customer_id`,`c`.`xingming` AS `customer_name`,`b`.`room_amount` AS `room_amount`,`b`.`service_amount` AS `service_amount`,`b`.`discount_amount` AS `discount_amount`,`b`.`payable_amount` AS `payable_amount`,coalesce(sum((case when (`pr`.`pay_status` = 'success') then `pr`.`pay_amount` else 0 end)),0) AS `actual_paid_amount`,coalesce(sum((case when (`rr`.`refund_status` = 'success') then `rr`.`refund_amount` else 0 end)),0) AS `actual_refund_amount`,`b`.`status` AS `bill_status`,max(`pr`.`paid_at`) AS `last_paid_at`,`b`.`created_at` AS `created_at` from (((`bill` `b` left join `customer` `c` on((`c`.`id` = `b`.`customer_id`))) left join `payment_record` `pr` on((`pr`.`bill_id` = `b`.`id`))) left join `refund_record` `rr` on((`rr`.`payment_id` = `pr`.`id`))) group by `b`.`id`,`b`.`booking_id`,`b`.`checkin_id`,`b`.`customer_id`,`c`.`xingming`,`b`.`room_amount`,`b`.`service_amount`,`b`.`discount_amount`,`b`.`payable_amount`,`b`.`status`,`b`.`created_at` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_booking_detail`
--

/*!50001 DROP VIEW IF EXISTS `v_booking_detail`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = gbk */;
/*!50001 SET character_set_results     = gbk */;
/*!50001 SET collation_connection      = gbk_chinese_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_booking_detail` AS select `bo`.`id` AS `booking_id`,`bo`.`yudingbianhao` AS `booking_no`,`bo`.`addtime` AS `booking_time`,`bo`.`customerming` AS `customer_login_name`,coalesce(`bo`.`customer_id`,`c`.`id`) AS `customer_id`,`c`.`xingming` AS `customer_real_name`,`c`.`shoujihao` AS `customer_phone`,`bo`.`kefangmingcheng` AS `room_name`,`bo`.`room_category` AS `room_category`,group_concat(distinct `ri`.`room_no` order by `ri`.`room_no` ASC separator ',') AS `room_numbers`,`bo`.`expected_checkin_date` AS `expected_checkin_date`,`bo`.`expected_checkout_date` AS `expected_checkout_date`,`bo`.`kefangjiage` AS `unit_price`,`bo`.`shuliang` AS `quantity`,`bo`.`zongjine` AS `total_amount`,`bo`.`ispay` AS `old_payment_status`,`bo`.`booking_status` AS `booking_status`,count(distinct `bsl`.`id`) AS `status_change_count`,max(`bsl`.`created_at`) AS `last_status_time` from ((((`booking_order` `bo` left join `customer` `c` on(((`c`.`id` = `bo`.`customer_id`) or ((`bo`.`customer_id` is null) and (`c`.`customerming` = `bo`.`customerming`))))) left join `booking_room` `br` on((`br`.`booking_id` = `bo`.`id`))) left join `room_instance` `ri` on((`ri`.`id` = `br`.`room_id`))) left join `booking_status_log` `bsl` on((`bsl`.`booking_id` = `bo`.`id`))) group by `bo`.`id`,`bo`.`yudingbianhao`,`bo`.`addtime`,`bo`.`customerming`,`bo`.`customer_id`,`c`.`id`,`c`.`xingming`,`c`.`shoujihao`,`bo`.`kefangmingcheng`,`bo`.`room_category`,`bo`.`expected_checkin_date`,`bo`.`expected_checkout_date`,`bo`.`kefangjiage`,`bo`.`shuliang`,`bo`.`zongjine`,`bo`.`ispay`,`bo`.`booking_status` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_checkin_guest_detail`
--

/*!50001 DROP VIEW IF EXISTS `v_checkin_guest_detail`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = gbk */;
/*!50001 SET character_set_results     = gbk */;
/*!50001 SET collation_connection      = gbk_chinese_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_checkin_guest_detail` AS select `cr`.`id` AS `checkin_id`,`cr`.`booking_id` AS `booking_id`,`cr`.`customer_id` AS `customer_id`,`c`.`xingming` AS `customer_name`,`ri`.`room_no` AS `room_no`,`rc`.`kefangmingcheng` AS `room_name`,`rc`.`room_category` AS `room_category`,`cr`.`checkin_time` AS `checkin_time`,`cr`.`checkout_time` AS `checkout_time`,`cr`.`status` AS `checkin_status`,max((case when (`cg`.`is_primary` = 1) then `cg`.`guest_name` end)) AS `primary_guest_name`,count(`cg`.`id`) AS `guest_count`,`e`.`employeexingming` AS `employee_name` from (((((`checkin_record` `cr` join `room_instance` `ri` on((`ri`.`id` = `cr`.`room_id`))) join `room_catalog` `rc` on((`rc`.`id` = `ri`.`room_catalog_id`))) left join `customer` `c` on((`c`.`id` = `cr`.`customer_id`))) left join `employee` `e` on((`e`.`id` = `cr`.`employee_id`))) left join `checkin_guest` `cg` on((`cg`.`checkin_id` = `cr`.`id`))) group by `cr`.`id`,`cr`.`booking_id`,`cr`.`customer_id`,`c`.`xingming`,`ri`.`room_no`,`rc`.`kefangmingcheng`,`rc`.`room_category`,`cr`.`checkin_time`,`cr`.`checkout_time`,`cr`.`status`,`e`.`employeexingming` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_customer_value_profile`
--

/*!50001 DROP VIEW IF EXISTS `v_customer_value_profile`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = gbk */;
/*!50001 SET character_set_results     = gbk */;
/*!50001 SET collation_connection      = gbk_chinese_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_customer_value_profile` AS select `c`.`id` AS `customer_id`,`c`.`customerming` AS `customer_login_name`,`c`.`xingming` AS `customer_name`,`c`.`shoujihao` AS `customer_phone`,count(distinct `bo`.`id`) AS `booking_count`,count(distinct `cr`.`id`) AS `checkin_count`,coalesce(sum(distinct `b`.`payable_amount`),0) AS `total_payable_amount`,coalesce(sum(distinct `b`.`paid_amount`),0) AS `total_paid_amount`,count(distinct `f`.`id`) AS `favorite_count`,count(distinct `rr`.`id`) AS `room_review_count`,count(distinct `hr`.`id`) AS `hotel_review_count`,max(`bo`.`addtime`) AS `last_booking_time` from ((((((`customer` `c` left join `booking_order` `bo` on((`bo`.`customerming` = `c`.`customerming`))) left join `checkin_record` `cr` on((`cr`.`customer_id` = `c`.`id`))) left join `bill` `b` on((`b`.`customer_id` = `c`.`id`))) left join `favorite` `f` on((`f`.`userid` = `c`.`id`))) left join `room_review` `rr` on((`rr`.`userid` = `c`.`id`))) left join `hotel_review` `hr` on((`hr`.`userid` = `c`.`id`))) group by `c`.`id`,`c`.`customerming`,`c`.`xingming`,`c`.`shoujihao` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_employee_operation_summary`
--

/*!50001 DROP VIEW IF EXISTS `v_employee_operation_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = gbk */;
/*!50001 SET character_set_results     = gbk */;
/*!50001 SET collation_connection      = gbk_chinese_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_employee_operation_summary` AS select `e`.`id` AS `employee_id`,`e`.`employeegonghao` AS `employee_no`,`e`.`employeexingming` AS `employee_name`,count(distinct `ol`.`id`) AS `total_operations`,count(distinct (case when (`ol`.`business_type` = 'booking_order') then `ol`.`id` end)) AS `booking_operations`,count(distinct (case when (`ol`.`business_type` = 'checkin_record') then `ol`.`id` end)) AS `checkin_operations`,count(distinct (case when (`ol`.`business_type` = 'bill') then `ol`.`id` end)) AS `bill_operations`,count(distinct (case when (`ol`.`business_type` = 'refund_record') then `ol`.`id` end)) AS `refund_operations`,count(distinct `ht`.`id`) AS `cleaning_task_count`,count(distinct `mr`.`id`) AS `maintenance_task_count`,max(`ep`.`total_score`) AS `latest_assessment_score`,max(`ep`.`grade`) AS `latest_assessment_grade`,min(`ol`.`created_at`) AS `first_operation_time`,max(`ol`.`created_at`) AS `last_operation_time` from ((((`employee` `e` left join `operation_log` `ol` on(((`ol`.`operator_type` = 'employee') and (`ol`.`operator_id` = `e`.`id`)))) left join `housekeeping_task` `ht` on(((`ht`.`assigned_employee_id` = `e`.`id`) and (`ht`.`task_status` = 'completed')))) left join `maintenance_record` `mr` on(((`mr`.`handled_by_employee_id` = `e`.`id`) and (`mr`.`maintenance_status` = 'completed')))) left join `employee_performance` `ep` on((`ep`.`employee_id` = `e`.`id`))) group by `e`.`id`,`e`.`employeegonghao`,`e`.`employeexingming` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_employee_performance_detail`
--

/*!50001 DROP VIEW IF EXISTS `v_employee_performance_detail`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = gbk */;
/*!50001 SET character_set_results     = gbk */;
/*!50001 SET collation_connection      = gbk_chinese_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_employee_performance_detail` AS select `ep`.`id` AS `performance_id`,`ep`.`employee_id` AS `employee_id`,`e`.`employeegonghao` AS `employee_no`,`e`.`employeexingming` AS `employee_name`,`ep`.`period_start` AS `period_start`,`ep`.`period_end` AS `period_end`,`ep`.`checkin_count` AS `checkin_count`,`ep`.`bill_count` AS `bill_count`,`ep`.`payment_count` AS `payment_count`,`ep`.`cleaning_count` AS `cleaning_count`,`ep`.`maintenance_count` AS `maintenance_count`,`ep`.`operation_count` AS `operation_count`,`ep`.`manager_score` AS `manager_score`,`ep`.`total_score` AS `total_score`,`ep`.`grade` AS `grade`,`assessor`.`employeexingming` AS `assessor_name`,`ep`.`created_at` AS `created_at` from ((`employee_performance` `ep` join `employee` `e` on((`e`.`id` = `ep`.`employee_id`))) left join `employee` `assessor` on((`assessor`.`id` = `ep`.`assessor_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_housekeeping_task_detail`
--

/*!50001 DROP VIEW IF EXISTS `v_housekeeping_task_detail`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = gbk */;
/*!50001 SET character_set_results     = gbk */;
/*!50001 SET collation_connection      = gbk_chinese_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_housekeeping_task_detail` AS select `ht`.`id` AS `task_id`,`ht`.`task_type` AS `task_type`,`ht`.`task_status` AS `task_status`,`ht`.`scheduled_time` AS `scheduled_time`,`ht`.`completed_time` AS `completed_time`,`ri`.`room_no` AS `room_no`,`ri`.`status` AS `room_status`,`rc`.`kefangmingcheng` AS `room_name`,`rc`.`room_category` AS `room_category`,`cr`.`booking_id` AS `booking_id`,`e`.`employeexingming` AS `assigned_employee_name`,`ht`.`remark` AS `remark`,`ht`.`created_at` AS `created_at` from ((((`housekeeping_task` `ht` join `room_instance` `ri` on((`ri`.`id` = `ht`.`room_id`))) join `room_catalog` `rc` on((`rc`.`id` = `ri`.`room_catalog_id`))) left join `checkin_record` `cr` on((`cr`.`id` = `ht`.`checkin_id`))) left join `employee` `e` on((`e`.`id` = `ht`.`assigned_employee_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_monthly_revenue_report`
--

/*!50001 DROP VIEW IF EXISTS `v_monthly_revenue_report`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = gbk */;
/*!50001 SET character_set_results     = gbk */;
/*!50001 SET collation_connection      = gbk_chinese_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_monthly_revenue_report` AS select date_format(`pr`.`paid_at`,'%Y-%m') AS `revenue_month`,`rc`.`room_category` AS `room_category`,`pr`.`pay_method` AS `pay_method`,count(distinct `b`.`id`) AS `bill_count`,count(`pr`.`id`) AS `payment_count`,sum((case when (`pr`.`pay_status` = 'success') then `pr`.`pay_amount` else 0 end)) AS `gross_revenue`,coalesce(sum((case when (`rr`.`refund_status` = 'success') then `rr`.`refund_amount` else 0 end)),0) AS `refund_amount`,(sum((case when (`pr`.`pay_status` = 'success') then `pr`.`pay_amount` else 0 end)) - coalesce(sum((case when (`rr`.`refund_status` = 'success') then `rr`.`refund_amount` else 0 end)),0)) AS `net_revenue` from (((((`payment_record` `pr` join `bill` `b` on((`b`.`id` = `pr`.`bill_id`))) left join `checkin_record` `cr` on((`cr`.`id` = `b`.`checkin_id`))) left join `room_instance` `ri` on((`ri`.`id` = `cr`.`room_id`))) left join `room_catalog` `rc` on((`rc`.`id` = `ri`.`room_catalog_id`))) left join `refund_record` `rr` on((`rr`.`payment_id` = `pr`.`id`))) group by date_format(`pr`.`paid_at`,'%Y-%m'),`rc`.`room_category`,`pr`.`pay_method` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_room_daily_status`
--

/*!50001 DROP VIEW IF EXISTS `v_room_daily_status`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = gbk */;
/*!50001 SET character_set_results     = gbk */;
/*!50001 SET collation_connection      = gbk_chinese_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_room_daily_status` AS select `ri`.`id` AS `room_id`,`ri`.`room_no` AS `room_no`,`ri`.`floor_no` AS `floor_no`,`ri`.`status` AS `current_status`,`rc`.`kefangmingcheng` AS `room_name`,`rc`.`room_category` AS `room_category`,`br`.`booking_id` AS `active_booking_id`,`bo`.`yudingbianhao` AS `booking_no`,`bo`.`customerming` AS `customer_name`,`cr`.`id` AS `active_checkin_id`,`cr`.`checkin_time` AS `checkin_time`,`cr`.`checkout_time` AS `checkout_time`,`ht`.`id` AS `active_housekeeping_task_id`,`mr`.`id` AS `active_maintenance_id`,(case when ((`cr`.`id` is not null) and (`cr`.`status` = 'checked_in')) then 'occupied_by_checkin' when ((`mr`.`id` is not null) and (`mr`.`maintenance_status` in ('reported','processing'))) then 'maintenance_processing' when ((`ht`.`id` is not null) and (`ht`.`task_status` in ('pending','assigned','in_progress'))) then 'cleaning_processing' when ((`br`.`id` is not null) and (`br`.`room_status` in ('reserved','checked_in'))) then 'reserved_by_booking' else `ri`.`status` end) AS `business_status` from ((((((`room_instance` `ri` join `room_catalog` `rc` on((`rc`.`id` = `ri`.`room_catalog_id`))) left join `booking_room` `br` on(((`br`.`room_id` = `ri`.`id`) and (`br`.`room_status` in ('reserved','checked_in'))))) left join `booking_order` `bo` on(((`bo`.`id` = `br`.`booking_id`) and (`bo`.`booking_status` in ('created','reserved','checked_in'))))) left join `checkin_record` `cr` on(((`cr`.`room_id` = `ri`.`id`) and (`cr`.`status` = 'checked_in')))) left join `housekeeping_task` `ht` on(((`ht`.`room_id` = `ri`.`id`) and (`ht`.`task_status` in ('pending','assigned','in_progress'))))) left join `maintenance_record` `mr` on(((`mr`.`room_id` = `ri`.`id`) and (`mr`.`maintenance_status` in ('reported','processing'))))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_room_inventory_overview`
--

/*!50001 DROP VIEW IF EXISTS `v_room_inventory_overview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = gbk */;
/*!50001 SET character_set_results     = gbk */;
/*!50001 SET collation_connection      = gbk_chinese_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_room_inventory_overview` AS select `rc`.`id` AS `room_catalog_id`,`rc`.`jiudianmingcheng` AS `hotel_name`,`rc`.`kefangmingcheng` AS `room_name`,`rc`.`room_category` AS `room_category`,count(`ri`.`id`) AS `total_rooms`,sum((case when (`ri`.`status` = 'available') then 1 else 0 end)) AS `available_rooms`,sum((case when (`ri`.`status` = 'reserved') then 1 else 0 end)) AS `reserved_rooms`,sum((case when (`ri`.`status` = 'occupied') then 1 else 0 end)) AS `occupied_rooms`,sum((case when (`ri`.`status` = 'cleaning') then 1 else 0 end)) AS `cleaning_rooms`,sum((case when (`ri`.`status` = 'maintenance') then 1 else 0 end)) AS `maintenance_rooms`,round(`rc`.`kefangjiage`,2) AS `base_price`,`rc`.`review_count` AS `review_count`,`rc`.`avg_score` AS `avg_score` from (`room_catalog` `rc` left join `room_instance` `ri` on((`ri`.`room_catalog_id` = `rc`.`id`))) group by `rc`.`id`,`rc`.`jiudianmingcheng`,`rc`.`kefangmingcheng`,`rc`.`room_category`,`rc`.`kefangjiage`,`rc`.`review_count`,`rc`.`avg_score` */;
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

-- Dump completed on 2026-06-24 15:06:32

-- auth_token table structure only. Runtime login tokens are intentionally not exported.

-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: hotel_management
-- ------------------------------------------------------
-- Server version	8.0.38

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

--
-- Table structure for table `auth_token`
--

DROP TABLE IF EXISTS `auth_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_token` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '涓婚敭',
  `userid` bigint NOT NULL COMMENT '鐢ㄦ埛id',
  `username` varchar(100) NOT NULL COMMENT 'username',
  `tablename` varchar(100) DEFAULT NULL COMMENT '琛ㄥ悕',
  `role` varchar(100) DEFAULT NULL COMMENT '瑙掕壊',
  `auth_token` varchar(200) NOT NULL COMMENT '瀵嗙爜',
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鏂板鏃堕棿',
  `expiratedtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '杩囨湡鏃堕棿',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_auth_token_value` (`auth_token`),
  CONSTRAINT `chk_auth_token_expiration` CHECK ((`expiratedtime` >= `addtime`))
) ENGINE=InnoDB AUTO_INCREMENT=1409 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='legacy table';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-24 15:06:33
